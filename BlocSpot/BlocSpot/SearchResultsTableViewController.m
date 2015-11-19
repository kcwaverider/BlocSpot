    //
//  SearchResultsTableViewController.m
//  BlocSpot
//
//  Created by Chad Clayton on 10/19/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "SearchResultsTableViewController.h"
#import "DataSource.h"
#import "PointOfInterestCell.h"
#import "Location.h"
#import "PointOfInterest.h"
#import "AppDelegate.h"



@interface SearchResultsTableViewController ()<PointOfInterestCellDelegate>



@end

@implementation SearchResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    //[self.tableView registerClass:[SearchResultsTableViewController class] forCellReuseIdentifier:@"poiCell"];
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
     
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // TODO: this needs to be populated from the data store
    //NSLog(@"Local POI Rows: %lu", (unsigned long)[DataSource sharedInstance].localPlacesList.count);
    return [DataSource sharedInstance].localPlacesList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *CellIdentifier = @"pointOfInterestCell";
    
    PointOfInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    // Configure the cell...
    cell.searchResult = [DataSource sharedInstance].localPlacesList[indexPath.row];
    //pointOfInterest = [DataSource sharedInstance].localPlacesList[indexPath.row];
    cell.name.text = cell.searchResult.name;
    if (cell.searchResult.favorite == [NSNumber numberWithBool:YES]) {
        //[cell.likeButton setImage:[UIImage imageNamed:@"heart-full"] forState:UIControlStateNormal];
        [cell.likeButton setImage:[UIImage imageNamed:@"heart-full-purple"] forState:UIControlStateNormal];
    } else {
        //cell.likeButton.alpha = 0.3;
    }
    
    return cell;
}

#pragma mark - Cell Like Delegate
- (void) cellDidPressLikeButton:(PointOfInterestCell *)cell ToLikeState:(BOOL)liked {
    if (liked) {
        NSLog(@"Like Button Pushed");
        
        PointOfInterest *pointOfInterest = [NSEntityDescription insertNewObjectForEntityForName:@"PointOfInterest" inManagedObjectContext:self.context];
        
        Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.context];
        pointOfInterest.name = cell.searchResult.name;
        pointOfInterest.category = cell.searchResult.category;
        pointOfInterest.favorite = cell.searchResult.favorite;
        
        location.latitude = cell.searchResult.latitude;
        location.longitude = cell.searchResult.longitude;
        pointOfInterest.location = location;
        location.pointOfInterest = pointOfInterest;
        
        NSError *error;
        if(![self.context save:&error]) {
            NSLog(@"Whoops, coudn't save: %@", [error localizedDescription]);
        }

    } else {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"PointOfInterest" inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@ AND location.latitude == %@ AND location.longitude == %@", cell.searchResult.name, cell.searchResult.latitude, cell.searchResult.longitude]];
        NSError *error = nil;
        NSArray *results = [self.context executeFetchRequest:fetchRequest error:&error];
        
        for (int i = 0; i < results.count; i++){
            [self.context deleteObject:results[i]];
        }
        
        if(![self.context save:&error]) {
            NSLog(@"Whoops, coudn't save: %@", [error localizedDescription]);
        }
    }
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
