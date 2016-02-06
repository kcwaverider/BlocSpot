//
//  SearchResultsTableViewController.h
//  BlocSpot
//
//  Created by Chad Clayton on 10/19/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"


@interface SearchResultsTableViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSMutableArray *pointOfInterestArray;
@property (nonatomic, weak) MapViewController *mapViewController;


@end
