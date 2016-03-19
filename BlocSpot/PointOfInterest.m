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

//@synthesize distanceFromUser = _distanceFromUser;

NSString *const PointOfInterestWasDeleted = @"PointOfInterestWasDeleted";

- (instancetype) init {
    self = [super init];
    self.locationType = 0;
    //_distanceFromUser = [self distanceFromUser];
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

-(CLLocationDistance) distanceFromUser {
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    CLLocation *userCoordinate = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
    NSLog(@"User Latitiude: %f  User Longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.latitude);
    CLLocation *locationCoordinate = [[CLLocation alloc] initWithLatitude:[self.location.latitude doubleValue] longitude:[self.location.longitude doubleValue]];
    NSLog(@"Latitiude: %@  Latitude: %@", self.location.latitude, self.location.longitude);
    CLLocationDistance distance = [userCoordinate distanceFromLocation: locationCoordinate];
   
    return distance;
}

@end
