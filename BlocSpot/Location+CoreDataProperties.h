//
//  Location+CoreDataProperties.h
//  BlocSpot
//
//  Created by Chad Clayton on 10/16/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface Location (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) PointOfInterest *pointOfInterest;

@end

NS_ASSUME_NONNULL_END
