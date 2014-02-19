//
//  VenueDetailViewController.h
//  FSQProject
//
//  Created by David Tseng on 2/11/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "GPlace.h"
#import "MWPhotoBrowser.h"


@interface PlaceDetailViewController : UIViewController<MWPhotoBrowserDelegate>{
    UISegmentedControl *_segmentedControl;
    NSMutableArray *_selections;
}

@property (strong, nonatomic) IBOutlet MKMapView *mpView;
@property GPlace *currentPlace;
@property (weak, nonatomic) IBOutlet UILabel *lbCategory;
@property (strong, nonatomic) IBOutlet UIButton *btnRoute;
@property (strong, nonatomic) IBOutlet UIButton *btnImage;

- (IBAction)btnRouteToPlace:(id)sender;
- (IBAction)btnImageShowClicked:(id)sender;

@end
