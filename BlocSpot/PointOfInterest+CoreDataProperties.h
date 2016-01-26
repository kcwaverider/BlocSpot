//
//  PointOfInterest+CoreDataProperties.h
//  BlocSpot
//
//  Created by Chad Clayton on 10/16/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PointOfInterest.h"

NS_ASSUME_NONNULL_BEGIN

@interface PointOfInterest (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *category;
@property (nullable, nonatomic, retain) NSNumber *favorite;
@property (nullable, nonatomic, retain) Location *location;
@property (nullable, nonatomic, retain) NSString *notes;

@end

NS_ASSUME_NONNULL_END
