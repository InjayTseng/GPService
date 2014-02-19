//
//  VenueMapViewController.m
//  FSQProject
//
//  Created by David Tseng on 1/16/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import "PlaceMapViewController.h"
#import "GPlace.h"
#import "SVProgressHUD.h"
#import "PlaceDetailViewController.h"
#import "GPData.h"
#import <MapKit/MapKit.h>

#define DEFAULT_LAT 25.032609
#define DEFAULT_LON 121.558727
#define TAG_LBTEXT 111

@interface PlaceMapViewController ()

@end


@implementation PlaceMapViewController

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
    
    [self setNearbyVenuesArray:[[GPData sharedInstance] nearbyPlaces]];
    [self addPlaceAnnotations];
    
    
    self.mapView.delegate = self;
    [self.mapView setRegion:region animated:YES];
    [self.mapView setShowsUserLocation:YES];
    


}

-(void)addPlaceAnnotations{

    for (GPlace* place in self.nearbyVenuesArray){
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D loc = place.coordinate;
        point.coordinate = loc;
        point.title = place.name;
        NSLog(@"%@ added.",place.name);
        point.subtitle = place.address;
        [self.mapView addAnnotation:point];
    }

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    
    if ([[annotation title] isEqualToString:@"站點位置"]) {
        static NSString *identifier = @"站點位置";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;

        return annotationView;
    }
    

    static NSString *PlaceIdentifier = @"VenueLocation";
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:PlaceIdentifier];
//    MKPinAnnotationView *annotationView =
//    (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc]
                          initWithAnnotation:annotation
                          reuseIdentifier:PlaceIdentifier];
    } else {
        annotationView.annotation = annotation;
    }
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    
    UIButton*myButton =[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    myButton.frame =CGRectMake(0,0,40,40);
    [myButton addTarget:self action:@selector(annotaionViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    [myButton setRestorationIdentifier:[annotation title]];
    annotationView.rightCalloutAccessoryView = myButton;
    
    
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

    for (GPlace *place in self.nearbyVenuesArray){

        if ([place.name isEqualToString:name]) {
            
            return place;
        }
    }
    return nil;
}


//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
//}


@end
