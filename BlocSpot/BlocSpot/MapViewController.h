//
//  MapViewController.h
//  BlocSpot
//
//  Created by Chad Clayton on 10/8/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SearchResult.h"
#import "PointOfInterestCell.h"
#import "Location.h"


@interface MapViewController : UIViewController

extern NSString *const PointOfInterestWasDeleted;

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSMutableArray *favoriteLocationArray;


@end
