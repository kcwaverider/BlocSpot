//
//  MasterViewController.m
//  BlocSpot
//
//  Created by Chad Clayton on 10/5/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MapViewController.h"
#import "DataSource.h"
#import "SavedLocationCell.h"
#import "SearchResultsTableViewController.h"
#import "PointOfInterest.h"
#import "AppDelegate.h"

@import MapKit;

@interface MasterViewController () <UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *savedLocationsArray;
@property (nonatomic, strong) NSMutableArray *singleResultArray;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, strong) SearchResult *selectedSearchResult;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.predicate = nil;
    self.savedLocationsArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.fetchedResultsController = [self fetchedResultsController];
    [self setupCategoryButtons];
    self.navigationController.toolbar.barTintColor = [UIColor blackColor];
    //    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [self registerForPOIDeleteNotification];
    self.dataArray = [[self sortedDataArray] mutableCopy];
    
    }

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    self.dataArray = [[self sortedDataArray] mutableCopy];
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self.tableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
        
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PointOfInterest *pointOfInterest = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:pointOfInterest];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    } else if ([[segue identifier] isEqualToString:@"ShowSearchList"]) {
        SearchResultsTableViewController *controller = (SearchResultsTableViewController *)[segue destinationViewController];
        controller.context = [self.fetchedResultsController managedObjectContext];
        
    } else if ([[segue identifier] isEqualToString:@"showMapView"]) {
        MapViewController *mapViewController = segue.destinationViewController;
        mapViewController.favoriteLocationArray = self.savedLocationsArray;
            NSLog(@"Map button Clikced");
    } else if ([[segue identifier] isEqualToString:@"savedLocationSelected"]) {
        MapViewController *mapViewController = segue.destinationViewController;
        mapViewController.favoriteLocationArray = self.singleResultArray;
            NSLog(@"Point of Interest Clicked");
    }

}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /*
    if([self.fetchedResultsController sections] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex: section];
        
        return [sectionInfo numberOfObjects];
    } else {
        return 0;
    }
     */
    NSLog(@"Data Array Count: %lu", self.dataArray.count);
    return self.dataArray.count;
    
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    //cell.backgroundColor = [UIColor redColor];
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"savedLocationCell";
    
    
    
    SavedLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PointOfInterest * pointOfInterest = self.dataArray[indexPath.row];
    
    /*
    PointOfInterest *pointOfInterest = [self.fetchedResultsController objectAtIndexPath:indexPath];
    */
    cell.name.text = pointOfInterest.name;
    if (![pointOfInterest.notes hasPrefix:@"Notes"]) {
        cell.notes.text = pointOfInterest.notes;
    }
    //NSLog(@"Name: %@", pointOfInterest.name);

    
    UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    bgview.opaque = YES;
    bgview.backgroundColor = [self backgroundColorForCategory:pointOfInterest.category];
    [cell setBackgroundView:bgview];
    
    //Assign copy pointOfInterest to a searchResult so it can be displayed on the mapView
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = pointOfInterest.name;
    searchResult.category = pointOfInterest.category;
    searchResult.latitude = pointOfInterest.location.latitude;
    searchResult.longitude = pointOfInterest.location.longitude;
    CLLocationCoordinate2D pinPoint;
    pinPoint.latitude = [searchResult.latitude doubleValue];
    pinPoint.longitude = [searchResult.longitude doubleValue];
    searchResult.coordinate = pinPoint;
    
    if (indexPath.row == 0) {
        [self.savedLocationsArray removeAllObjects];
    }
    [self.savedLocationsArray addObject:searchResult];
    
    

   // NSLog(@"Name: %@", cell.name.text);
    

    return cell;
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.singleResultArray) {
        self.singleResultArray = [[NSMutableArray alloc] init];
    }
    [self.singleResultArray removeAllObjects];
    
    PointOfInterest *pointOfInterest = self.dataArray[indexPath.row];
    
    
    //Assign copy pointOfInterest to a searchResult so it can be displayed on the mapView
    SearchResult *searchResult = [[SearchResult alloc] init];
    searchResult.name = pointOfInterest.name;
    searchResult.category = pointOfInterest.category;
    searchResult.latitude = pointOfInterest.location.latitude;
    searchResult.longitude = pointOfInterest.location.longitude;
    CLLocationCoordinate2D pinPoint;
    pinPoint.latitude = [searchResult.latitude doubleValue];
    pinPoint.longitude = [searchResult.longitude doubleValue];
    searchResult.coordinate = pinPoint;
    
    [self.singleResultArray addObject:searchResult];

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PointOfInterest *poi = self.dataArray[indexPath.row];
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        
        [context deleteObject:poi];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Category Filtering

- (UIColor *) backgroundColorForCategory:(NSNumber *) category {
    
    UIColor *cellBackgroundColor;
    switch ([category integerValue]) {
        case LocationTypeBar:
            cellBackgroundColor = [UIColor redColor];
            break;
        case LocationTypeCoffeeShop:
            cellBackgroundColor = [UIColor blueColor];
            break;
        case LocationTypeRestaurant:
            cellBackgroundColor = [UIColor yellowColor];
            break;
        case LocationTypeShopping:
            cellBackgroundColor = [UIColor greenColor];
            break;
        case LocationTypeRecreation:
            cellBackgroundColor = [UIColor purpleColor];
            break;
        default:
            cellBackgroundColor = [UIColor grayColor];
            break;
    }
    
    cellBackgroundColor = [cellBackgroundColor colorWithAlphaComponent:0.2];
    
    return cellBackgroundColor;
}

- (void) setupCategoryButtons {
    NSArray *categoryButtonArray = @[self.allButton, self.barButton, self.coffeeShopButton, self.restaurantButton, self.shoppingButton, self.recreationButton];
    
    for (UIBarButtonItem *button in categoryButtonArray) {
        button.target = self;
        button.action = @selector(categoryButtonPushed:);
    }
}

- (void) categoryButtonPushed: (UIBarButtonItem *) button {
    [NSFetchedResultsController deleteCacheWithName:nil];
    if ([button.title isEqualToString:@"Bars"]) {
        self.predicate = [NSPredicate predicateWithFormat:@"category == %@",[NSNumber numberWithInteger:LocationTypeBar]];
    } else if ([button.title isEqualToString:@"Coffee"]) {
        self.predicate = [NSPredicate predicateWithFormat:@"category == %@",[NSNumber numberWithInteger:LocationTypeCoffeeShop]];
    } else if ([button.title isEqualToString:@"Food"]) {
        self.predicate = [NSPredicate predicateWithFormat:@"category == %@",[NSNumber numberWithInteger:LocationTypeRestaurant]];
    } else if ([button.title isEqualToString:@"Shopping"]) {
        self.predicate = [NSPredicate predicateWithFormat:@"category == %@",[NSNumber numberWithInteger:LocationTypeShopping]];
    } else if ([button.title isEqualToString:@"Recreation"]) {
        self.predicate = [NSPredicate predicateWithFormat:@"category == %@",[NSNumber numberWithInteger:LocationTypeRecreation]];
    } else {
        self.predicate = nil;
    }
    NSLog(@"The %@ button was pushed", button.title);
    //[NSFetchedResultsController deleteCacheWithName:@"Root"];
    // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"list = %@",self.list];
    [self.fetchedResultsController.fetchRequest setPredicate:self.predicate];
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.tableView reloadData];
}



#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    self.managedObjectContext = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PointOfInterest" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:self.predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];

    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
//        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
//            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

-(void) registerForPOIDeleteNotification{
    [[NSNotificationCenter defaultCenter] addObserverForName:PointOfInterestWasDeleted object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"Stuff Got Deleted!!!!!");
        if ([self.savedLocationsArray containsObject:note.object]) {
            [self.savedLocationsArray removeObject:note.object];
        }
    }];
}

-(NSArray *) sortedDataArray {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PointOfInterest" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *unsortedArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"distanceFromUser" ascending:YES];
    
    NSArray *sortedArray = [unsortedArray sortedArrayUsingDescriptors:@[sort]];
    PointOfInterest *pointOfInterest = sortedArray[0];
    
    for (int i = 0; i < sortedArray.count; i++) {
        PointOfInterest *poi1, *poi2;
        poi1 = sortedArray[i];
        poi2 = unsortedArray[i];
        //NSLog(@"Sorted: %f  Unsorted: %f", poi1.distanceFromUser, poi2.distanceFromUser);
    }
    return sortedArray;
}


/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

// TODO from Steve
//[NSFetchedResultsController deleteCacheWithName:@"Root"]; 
//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"list = %@",self.list];
//[fetchedResultsController.fetchRequest setPredicate:predicate];
//NSError *error = nil;
//if (![[self fetchedResultsController] performFetch:&error]) {
//    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//    abort();
//}
//[table reloadData];
@end
