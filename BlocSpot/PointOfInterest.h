//
//  PointOfInterest.h
//  BlocSpot
//
//  Created by Chad Clayton on 10/16/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

typedef NS_ENUM(NSInteger, LocationType) {
    LocationTypeBar             = 0,
    LocationTypeCoffeeShop      = 1,
    LocationTypeRestaurant      = 2,
    LocationTypeShopping        = 3,
    LocationTypeRecreation      = 4,
};

NS_ASSUME_NONNULL_BEGIN

@interface PointOfInterest : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
@property (nonatomic, assign) LocationType locationType;
- (instancetype) init;
@end

NS_ASSUME_NONNULL_END

#import "PointOfInterest+CoreDataProperties.h"
