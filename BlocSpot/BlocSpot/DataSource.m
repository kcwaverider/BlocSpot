//
//  DataSource.m
//  BlocSpot
//
//  Created by Chad Clayton on 10/15/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource

+ (instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (instancetype) init {
    self = [super init];
    
    return self;
}
@end
