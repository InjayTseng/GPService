//
//  GPService.h
//  GPService
//
//  Created by David Tseng on 2/19/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface GPService : NSObject
typedef void(^XBLOCK)();
typedef void(^ARRAYBLOCK)(NSArray*);
+(void)getNearbyFoodForLocation:(CLLocation *)location andComplete:(ARRAYBLOCK)complete;
+(void)getNearbyFoodNextPage:(NSString*)nextToken andComplete:(ARRAYBLOCK)complete andFailure:(XBLOCK)failure;

+(NSString*)getPhotoURLWithPhotoReference:(NSString*)photoReference;
+(NSString*)getPhotoThumbURLWithPhotoReference:(NSString*)photoReference;
@end
