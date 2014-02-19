//
//  ViewController.m
//  GPService
//
//  Created by David Tseng on 2/19/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import "NearyByPlaceViewController.h"
#import "PlaceDetailViewController.h"
#import "PlaceMapViewController.h"
#import "PlaceMapTwoViewController.h"
#import "GPService.h"
#import "GPData.h"
#import "GPlace.h"
#import "SVProgressHUD.h"
@interface NearyByPlaceViewController () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tbView;
@property (strong, nonatomic) NSMutableArray* nearbyVenues;
@property (strong, nonatomic) UIButton *btnLoadMoreItem;


@end

@implementation NearyByPlaceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tbView.delegate = self;
    self.tbView.dataSource = self;
    self.btnLoadMoreItem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnLoadMoreItem.frame = CGRectMake(10.0, 0.0, 300.0, 40.0);
    [self.btnLoadMoreItem setTitle:@"更多餐廳..." forState:UIControlStateNormal];
    [self.btnLoadMoreItem addTarget:self action:@selector(actionBtnLoadMoreItem) forControlEvents:UIControlEventTouchUpInside];
    self.nearbyVenues = [[NSMutableArray alloc]init];
    
    [self rightButtonCreate];
    [SVProgressHUD showWithStatus: @"讀取中"];
    [GPService getNearbyFoodForLocation:self.targetLocation andComplete:^(NSArray *array) {
        [SVProgressHUD dismiss];
        [[GPData sharedInstance] setNearbyPlaces:[[NSMutableArray alloc] initWithArray:array] ];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            [self.nearbyVenues setArray:array];
            [self.tbView reloadData];
        }];
    }];
	// Do any additional setup after loading the view, typically from a nib.
}


-(void)rightButtonCreate{
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"地圖模式"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(mapModeClicked:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

- (void)mapModeClicked:(id)sender {
    UIStoryboard * mainStroyboard = [UIStoryboard storyboardWithName:@"GPMain" bundle:nil];
    PlaceMapTwoViewController *vm = [mainStroyboard instantiateViewControllerWithIdentifier:@"PlaceMapTwoViewController"];
    [vm setTargetLocation:self.targetLocation];
    [self.navigationController pushViewController:vm animated:YES];
    
}

- (void)actionBtnLoadMoreItem
{

    NSLog(@"Load");
    
    [SVProgressHUD setStatus:@"讀取中"];
    [GPService getNearbyFoodNextPage:[[GPData sharedInstance] nextPageToken] andComplete:^(NSArray *secondPage) {
        
        [SVProgressHUD dismiss];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            [[[GPData sharedInstance] nearbyPlaces] addObjectsFromArray:secondPage];
            [self.nearbyVenues addObjectsFromArray:secondPage];
            [self.tbView reloadData];
        }];
        
    } andFailure:^{
        
        [SVProgressHUD showSuccessWithStatus:@"搜尋結果完畢"];
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.nearbyVenues.count>1) {
        return self.nearbyVenues.count+1;
    }

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    if ([self.nearbyVenues count] >= 1) {
    
        if (indexPath.row == [self.nearbyVenues count]) {
    
            static NSString *MoreCellIdentifier = @"More";
            cell = [tableView dequeueReusableCellWithIdentifier:MoreCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MoreCellIdentifier];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:self.btnLoadMoreItem];
            
            
        }else{
            
            GPlace *place = [self.nearbyVenues objectAtIndex:indexPath.row];
            if (place.rating == nil) {
                
                cell.textLabel.text = [NSString stringWithFormat:@"%@",place.name];
                
            }else{
                
                cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)",place.name,place.rating];
                
            }
            cell.detailTextLabel.text = place.address;
            
//            NSURL * imageURL = [NSURL URLWithString:place.iconUrl];
//            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
//            UIImage * image = [UIImage imageWithData:imageData];
//            [cell.imageView setImage:image];
            
        }
    }
    
    
    //    cell.textLabel.text = [self.nearbyVenues[indexPath.row] name];
//    FSVenue *venue = self.nearbyVenues[indexPath.row];
//    if (venue.location.address) {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m, %@",
//                                     venue.location.distance,
//                                     venue.location.address];
//    } else {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m",
//                                     venue.location.distance];
//    }
//    
//    NSString* cateFileName = [self saftyFileName:venue.categories];
//    UIImage* lastTimeImage = [self loadImageWithName:cateFileName] ;
//    if (lastTimeImage == nil) {
//        NSURL * imageURL = [NSURL URLWithString:venue.categorieIconUrl];
//        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
//        UIImage * image = [UIImage imageWithData:imageData];
//        [cell.imageView setImage:image];
//        [self saveImage:image andName:cateFileName];
//    }else{
//        
//        [cell.imageView setImage:lastTimeImage];
//    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GPlace *place = self.nearbyVenues[indexPath.row];
    UIStoryboard * mainStroyboard = [UIStoryboard storyboardWithName:@"GPMain" bundle:nil];
    PlaceDetailViewController *vv = [mainStroyboard instantiateViewControllerWithIdentifier:@"PlaceDetailViewController"];
    [vv setCurrentPlace:place];
    [self.navigationController pushViewController:vv animated:YES];
    
}


@end
