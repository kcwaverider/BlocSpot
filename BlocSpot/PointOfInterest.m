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
    
    return self;
}

-(void) setLocationType:(LocationType)locationType {
    self.locationType = locationType;
    self.category = [NSNumber numberWithInteger:self.locationType];
}

-(LocationType) locationType {
    self.locationType = [self.category integerValue];
    return self.locationType;
}

@end
