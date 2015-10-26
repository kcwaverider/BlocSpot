//
//  SearchResultsTableViewController.h
//  BlocSpot
//
//  Created by Chad Clayton on 10/19/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointOfInterestCell.h"
#import "Location.h"

@interface SearchResultsTableViewController : UITableViewController<PointOfInterestCellDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *pointOfInterestArray;


@end
