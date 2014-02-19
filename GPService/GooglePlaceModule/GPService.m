//
//  GPService.m
//  GPService
//
//  Created by David Tseng on 2/19/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import "GPService.h"
#import "GPlace.h"
#import "GPData.h"
@implementation GPService


+(void)getNearbyFoodForLocation:(CLLocation *)location andComplete:(ARRAYBLOCK)complete{

    NSString *strURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=500&types=food&language=zh-TW&sensor=false&key=AIzaSyAw_9t8_7Le9OVbDJfzsC3U3mtZUWTb6js",location.coordinate.latitude,location.coordinate.longitude];
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSLog(@"url = %@", url);
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
	[req setHTTPMethod:@"GET"];
	[NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue]completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
//        NSLog(@"array : %@",dictionary);
        NSArray *array = [dictionary objectForKey:@"results"]; // retrieve that Day Gym Classes

        NSString *nxt_page_token = [dictionary objectForKey:@"next_page_token"];
        [[GPData sharedInstance] setNextPageToken:nxt_page_token];
        
        NSMutableArray *nearByPlaceArray = [[NSMutableArray alloc]init];
        
        for (NSDictionary* subDic in array){
        
            GPlace *place  =[[GPlace alloc]init];
//            NSLog(@"Sub %@",subDic);
            CLLocationCoordinate2D location;
            location.latitude =[[[[subDic objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
            location.longitude =[[[[subDic objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
            place.coordinate = location;
            place.name = [subDic objectForKey:@"name"];
            place.iconUrl = [subDic objectForKey:@"icon"];
            place.address = [subDic objectForKey:@"vicinity"];
            place.rating =[subDic objectForKey:@"rating"];
            
            NSArray* photosArrayTemp = [subDic objectForKey:@"photos"];
            NSMutableArray* photosArray = [[NSMutableArray alloc]init];
            for (NSDictionary * photDic  in photosArrayTemp){
            
                NSString* photoReference = [photDic objectForKey:@"photo_reference"];
                
                if (photoReference != nil) {
                    
                    [photosArray addObject:photoReference];
                }
            }
            place.photos = [NSArray arrayWithArray:photosArray];
            [nearByPlaceArray addObject:place];
        }
        NSArray* arrayOut = [NSArray arrayWithArray:nearByPlaceArray];
        complete(arrayOut);
        
    }];
    
}

+(void)getNearbyFoodNextPage:(NSString*)nextToken andComplete:(ARRAYBLOCK)complete andFailure:(XBLOCK)failure{

//https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=ClRIAAAAA6_80mA3VbkPRTawH0Fc2qv2zh28FA-D0RdPQqugFRuWxAk7vFADFjNH4JV65CtFn9s1qE2CpWUN-Ek42X1PU38TEnUaTvBPhnG2HjIcXUESEAVZmD0zcmFe9zOhCsFeVmkaFLDwndrZeaOww2hPyY6_zC07v0UJ&sensor=false&&key=AIzaSyAw_9t8_7Le9OVbDJfzsC3U3mtZUWTb6js&language=zh-TW
    
    
    if (nextToken == nil) {
        
        failure();
        return;
    }
    
    if (nextToken.length < 1) {
        failure ();
        return;
    }
    
    NSString *strURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=%@&sensor=false&&key=AIzaSyAw_9t8_7Le9OVbDJfzsC3U3mtZUWTb6js&language=zh-TW",nextToken];
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSLog(@"url = %@", url);
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
	[req setHTTPMethod:@"GET"];
	[NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue]completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
//        NSLog(@"array : %@",dictionary);
        NSArray *array = [dictionary objectForKey:@"results"]; // retrieve that Day Gym Classes
        
        NSString *nxt_page_token = [dictionary objectForKey:@"next_page_token"];
        [[GPData sharedInstance] setNextPageToken:nxt_page_token];
        
        NSMutableArray *nearByPlaceArray = [[NSMutableArray alloc]init];
        
        for (NSDictionary* subDic in array){
            
            GPlace *place  =[[GPlace alloc]init];
            //            NSLog(@"Sub %@",subDic);
            CLLocationCoordinate2D location;
            location.latitude =[[[[subDic objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
            location.longitude =[[[[subDic objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
            place.coordinate = location;
            place.name = [subDic objectForKey:@"name"];
            place.iconUrl = [subDic objectForKey:@"icon"];
            place.address = [subDic objectForKey:@"vicinity"];
            place.rating =[subDic objectForKey:@"rating"];
            
            NSArray* photosArrayTemp = [subDic objectForKey:@"photos"];
            NSMutableArray* photosArray = [[NSMutableArray alloc]init];
            for (NSDictionary * photDic  in photosArrayTemp){
                
                NSString* photoReference = [photDic objectForKey:@"photo_reference"];
                
                if (photoReference != nil) {
                    
                    [photosArray addObject:photoReference];
                }
            }
            place.photos = [NSArray arrayWithArray:photosArray];
            
            [nearByPlaceArray addObject:place];
        }
        NSArray* arrayOut = [NSArray arrayWithArray:nearByPlaceArray];
        complete(arrayOut);
        
    }];
}


+(NSString*)getPhotoURLWithPhotoReference:(NSString*)photoReference{

    NSString *strURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&sensor=true&key=AIzaSyAw_9t8_7Le9OVbDJfzsC3U3mtZUWTb6js",photoReference];

    return strURL;
}

+(NSString*)getPhotoThumbURLWithPhotoReference:(NSString*)photoReference{
    
    NSString *strURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=50&photoreference=%@&sensor=true&key=AIzaSyAw_9t8_7Le9OVbDJfzsC3U3mtZUWTb6js",photoReference];
    
    return strURL;
}

@end
