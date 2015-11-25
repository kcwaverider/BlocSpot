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



NS_ASSUME_NONNULL_BEGIN

@interface PointOfInterest : NSManagedObject

typedef NS_ENUM(NSInteger, LocationType) {
    LocationTypeNone            = 0,
    LocationTypeBar             = 1,
    LocationTypeCoffeeShop      = 2,
    LocationTypeRestaurant      = 3,
    LocationTypeShopping        = 4,
    LocationTypeRecreation      = 5,
};

// Insert code here to declare functionality of your managed object subclass
@property (nonatomic, assign) LocationType locationType;
- (instancetype) init;
@end

NS_ASSUME_NONNULL_END

#import "PointOfInterest+CoreDataProperties.h"
