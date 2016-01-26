//
//  CalloutBubbleViewController.h
//  BlocSpot
//
//  Created by Chad Clayton on 1/14/16.
//  Copyright © 2016 Chad Clayton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SearchResult.h"

@interface CalloutBubbleViewController : UIViewController 

@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, strong) NSString *string;

@property (assign) CGPoint touchLocation;

@property (nonatomic, strong) SearchResult *selectedPointOfInterest;


@end
