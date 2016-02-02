//
//  SearchResult.m
//  BlocSpot
//
//  Created by Chad Clayton on 10/27/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import "SearchResult.h"
#import "DataSource.h"
#import "AppDelegate.h"
#import "PointOfInterest.h"

@implementation SearchResult

- (instancetype) init {
    SearchResult *result = [super init];
    
    result.context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    return result;
}

- (BOOL) isSavedLocation {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PointOfInterest" inManagedObjectContext:self.context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ AND location.latitude == %@ AND location.longitude == %@", self.name, self.latitude, self.longitude];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (results.count > 0) {
        PointOfInterest *pointOfInterest = results[0];
        self.category = pointOfInterest.category;
        if (pointOfInterest.notes) {
            self.notes = pointOfInterest.notes;
        }
        
        return YES;
    }
    
    return false;
}

@end
