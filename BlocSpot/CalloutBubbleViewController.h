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
@import MapKit;

@interface CalloutBubbleViewController : UIViewController 

@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, strong) NSString *string;

@property (assign) CGPoint touchLocation;

@property (nonatomic, weak) MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic, strong) SearchResult *selectedPointOfInterest;
- (IBAction)likeButtonPressed:(id)sender;


@end
