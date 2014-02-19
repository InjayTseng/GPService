//
//  GPData.m
//  GPService
//
//  Created by David Tseng on 2/19/14.
//  Copyright (c) 2014 David Tseng. All rights reserved.
//

#import "GPData.h"

@implementation GPData

+(GPData *) sharedInstance
{
    static GPData *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] init];
    });
    return _sharedClient;
}

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

@end
