//
//  GPData.h
//  GPService
//
//  Created by David Tseng on 2/19/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPlace.h"

@interface GPData : NSObject

+(GPData *) sharedInstance;

@property (strong, nonatomic) GPlace *selected;
@property (strong, nonatomic) NSMutableArray *nearbyPlaces;
@property (strong, nonatomic) NSString *nextPageToken;

@end
