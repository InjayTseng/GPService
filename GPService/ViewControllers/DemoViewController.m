//
//  DemoViewController.m
//  GPService
//
//  Created by David Tseng on 2/19/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import "DemoViewController.h"
#import "NearyByPlaceViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface DemoViewController ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation DemoViewController

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
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
	// Do any additional setup after loading the view.
}
- (IBAction)btnStaticLocationClicked:(id)sender {
    UIStoryboard * mainStroyboard = [UIStoryboard storyboardWithName:@"GPMain" bundle:nil];
    
    NearyByPlaceViewController *nv = [mainStroyboard instantiateViewControllerWithIdentifier:@"NearyByPlaceViewController"];
    
    //    CLLocation *loc = [[CLLocation alloc]initWithLatitude:37.33240904999999 longitude:122.0305121099999];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:24.983977 longitude:121.541721];
    
    [nv setTargetLocation:loc];
    
    [self.navigationController pushViewController:nv
                                         animated:YES];
    
}
- (IBAction)btnCurrentLocationClicked:(id)sender {
    
    UIStoryboard * mainStroyboard = [UIStoryboard storyboardWithName:@"GPMain" bundle:nil];
    NearyByPlaceViewController *nv = [mainStroyboard instantiateViewControllerWithIdentifier:@"NearyByPlaceViewController"];
    
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
    
    [nv setTargetLocation:loc];
    
    [self.navigationController pushViewController:nv
                                         animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
