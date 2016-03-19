//
//  MasterViewController.h
//  BlocSpot
//
//  Created by Chad Clayton on 10/5/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) id <UITableViewDelegate> delegate;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *allButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *coffeeShopButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *restaurantButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *shoppingButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *recreationButton;



@end

