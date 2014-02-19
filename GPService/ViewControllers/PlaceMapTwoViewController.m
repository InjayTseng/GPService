//
//  PlaceMapTwoViewController.m
//  GPService
//
//  Created by David Tseng on 2/19/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import "PlaceMapTwoViewController.h"
#import "PlaceDetailViewController.h"
#import "GPData.h"
#define DEFAULT_LAT 25.032609
#define DEFAULT_LON 121.558727
#define TAG_LBTEXT 111

@interface PlaceMapTwoViewController ()

@end

@implementation PlaceMapTwoViewController

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
    if (self.targetLocation == nil) {
        self.targetLocation = [[CLLocation alloc]initWithLatitude:DEFAULT_LAT longitude:DEFAULT_LON];
    }
    
    MKCoordinateRegion region;
    region.center = [self.targetLocation coordinate];
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    
    MKPointAnnotation *target = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D loc = [self.targetLocation coordinate];
    target.coordinate = loc;
    target.title = @"站點位置";
    [self.mapView addAnnotation:target];
    [self addPlaceAnnotations];
    
    self.mapView.delegate = self;
    [self.mapView setRegion:region animated:YES];
    [self.mapView setShowsUserLocation:YES];
    
}

-(void)addPlaceAnnotations{
    
    for (GPlace* place in [[GPData sharedInstance] nearbyPlaces]){
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D loc = place.coordinate;
        point.coordinate = loc;
        point.title = place.name;
        NSLog(@"%@ added.",place.name);
        point.subtitle = place.address;
        [self.mapView addAnnotation:point];
    }
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{

    static NSString *viewId = @"MKPinAnnotationView";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)
    [self.mapView dequeueReusableAnnotationViewWithIdentifier:viewId];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc]
                          initWithAnnotation:annotation reuseIdentifier:viewId];
    }
    
    UIButton*myButton =[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    myButton.frame =CGRectMake(0,0,40,40);
    [myButton addTarget:self action:@selector(annotaionViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    [myButton setRestorationIdentifier:[annotation title]];
    annotationView.rightCalloutAccessoryView = myButton;
    
    annotationView.canShowCallout = YES;
    
    return annotationView;


    
    
}

-(void)annotaionViewClicked:(id)sender{
    
    UIButton *btn = sender;
    //    NSLog(@"sender %@",btn.restorationIdentifier);
    //Site *site = [[DataManager shareInstance] searchSiteByTitle:btn.restorationIdentifier];
    //[self navigatesToDetailbySite:site];
    GPlace *place = [self getPlaceByname:btn.restorationIdentifier];
    NSLog(@"Go to %@",place.name);
    
    
    //[self dismissViewControllerAnimated:YES completion:^{
    //   self.selectBlock(site);
    //}];
    UIStoryboard * mainStroyboard = [UIStoryboard storyboardWithName:@"GPMain" bundle:nil];
    PlaceDetailViewController *dv = [mainStroyboard instantiateViewControllerWithIdentifier:@"PlaceDetailViewController"];
    
    [dv setCurrentPlace:place];
    [self.navigationController pushViewController:dv animated:YES];
    
}

-(GPlace*)getPlaceByname:(NSString*)name{
    
    for (GPlace *place in [[GPData sharedInstance] nearbyPlaces]){
        
        if ([place.name isEqualToString:name]) {
            
            return place;
        }
    }
    return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
