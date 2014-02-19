//
//  VenueDetailViewController.m
//  FSQProject
//
//  Created by David Tseng on 2/11/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PlaceDetailViewController.h"
#import "SVProgressHUD.h"
#import "GPService.h"
@interface PlaceDetailViewController ()

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation PlaceDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
//    NSLog(@"%@",[self.currentVenue dictionaryRepresentation]);
//    NSLog(@"%@ %@ ",[[self.currentVenue contact] link],[[self.currentVenue contact] phone]);
    self.navigationItem.title = self.currentPlace.name;
    self.lbCategory.text = @"Restaurant";
    [self.imgView setFrame:CGRectMake(0, 0, 320, 700)];
    [self mapSetting];
    [self buttonDisplay];
	// Do any additional setup after loading the view.
}



-(void)buttonDisplay{

    [self setButtonShadow:self.btnRoute];
    [self setButtonShadow:self.btnImage];
}


-(void)setButtonShadow:(UIButton*)btn{
    
    btn.layer.cornerRadius = 8.0f;
    btn.layer.masksToBounds = NO;
    btn.layer.borderWidth = 0.0f;
    
    btn.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    btn.layer.shadowOpacity = 0.8;
    btn.layer.shadowRadius = 8;
    btn.layer.shadowOffset = CGSizeMake(8.0f, 8.0f);


}

-(void)mapSetting{
    
    self.mpView.layer.cornerRadius = 10.0;
    
    MKCoordinateRegion newRegion;
    newRegion.center = self.currentPlace.coordinate;
    newRegion.span.latitudeDelta=0.01;
    newRegion.span.longitudeDelta=0.01;
    
    [self.mpView setRegion:newRegion animated:NO];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:self.currentPlace.coordinate];
    [annotation setTitle:self.currentPlace.name];
    [self.mpView removeAnnotations:self.mpView.annotations];
    [self.mpView addAnnotation:annotation];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnRouteToPlace:(id)sender {
    
    [self routeFrom:25.03224425354909 andLon:121.5583175891882 toLocation:self.currentPlace.coordinate.latitude andLon:self.currentPlace.coordinate.longitude];
    
}

- (IBAction)btnImageShowClicked:(id)sender {
    
    [SVProgressHUD showWithStatus:@"讀取中"];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    for(NSString* str in self.currentPlace.photos){
        
        NSString* photoUrl = [GPService getPhotoURLWithPhotoReference:str];
        NSString* thumbUrl = [GPService getPhotoThumbURLWithPhotoReference:str];
        
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:photoUrl]]];
        [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:thumbUrl]]];
        
    }
    

    
    self.photos = photos;
    self.thumbs = thumbs;
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = YES;
    //        browser.wantsFullScreenLayout = YES;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = YES;
    [browser setCurrentPhotoIndex:0];
    
    // Show
    
    if (self.photos.count != 0) {
        
        [SVProgressHUD dismiss];
        [self.navigationController pushViewController:browser animated:YES];
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"沒有照片"];
    }
    
    
    
}
//- (IBAction)btnGotoLinkClicked:(id)sender {
//
//     UIStoryboard * mainStroyboard = [UIStoryboard storyboardWithName:@"FSMain" bundle:nil];
//    OfficialWebPageViewController* web = [mainStroyboard instantiateViewControllerWithIdentifier:@"OfficialWebPageViewController"];
//    [web setUrl:self.currentVenue.contact.link];
//    [self.navigationController pushViewController:web animated:YES];
//
//}



-(void)routeFrom:(double)lat1 andLon:(double)lon1 toLocation:(double)lat2 andLon:(double)lon2{
    
    CLLocationCoordinate2D location1;
    location1.latitude = lat1;
    location1.longitude = lon1;
    
    CLLocationCoordinate2D location2;
    location2.latitude = lat2;
    location2.longitude = lon2;
    
    MKPlacemark *annotation1 = [[MKPlacemark alloc]initWithCoordinate:location1 addressDictionary:nil];
    MKMapItem *curItem = [[MKMapItem alloc]initWithPlacemark:annotation1];
    
    MKPlacemark *annotation2 = [[MKPlacemark alloc]initWithCoordinate:location2 addressDictionary:nil];
    MKMapItem *toItem = [[MKMapItem alloc]initWithPlacemark:annotation2];
    
    NSArray *array = [[NSArray alloc] initWithObjects:curItem,toItem,nil];
    NSDictionary *dicOption = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking,
                                MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES] };
    [MKMapItem openMapsWithItems:array launchOptions:dicOption];
}




#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}





@end
