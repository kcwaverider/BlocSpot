//
//  SavedLocationCell.h
//  BlocSpot
//
//  Created by Chad Clayton on 11/23/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "SearchResult.h"
#import "PointOfInterest.h"



@interface SavedLocationCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *notes;

@property (nonatomic, strong) SearchResult *searchResult;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UIColor *backgroundColor;




@end
