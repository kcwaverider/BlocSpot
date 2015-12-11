//
//  PointOfInterest.m
//  BlocSpot
//
//  Created by Chad Clayton on 10/16/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import "PointOfInterest.h"
#import "Location.h"

@implementation PointOfInterest

// Insert code here to add functionality to your managed object subclass

- (instancetype) init {
    self = [super init];
    self.locationType = 0;
    
    return self;
}

-(void) setLocationType:(LocationType)locationType {
    //self.locationType = LocationTypeRestaurant;
//    if (!self.category) {
//        self.category = [[NSNumber alloc] init];
//    }
    self.category = [NSNumber numberWithInteger:locationType];
}

-(LocationType) locationType {
    self.locationType = [self.category integerValue];
    return self.locationType;
}

@end
