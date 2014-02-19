//
//  GPlace.h
//  GPService
//
//  Created by David Tseng on 2/19/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface GPlace : NSObject

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* iconUrl;
@property (strong, nonatomic) NSString* address;
@property (strong, nonatomic) NSString* rating;
@property (strong, nonatomic) NSArray* photos;

@end


@interface GPPhote : NSObject

@property (strong, nonatomic) NSString* photoReference;

@end