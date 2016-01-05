//
//  PointOfInterestCell.m
//  BlocSpot
//
//  Created by Chad Clayton on 10/21/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import "PointOfInterestCell.h"
#import "CategorySelectionView.h"
#import "AppDelegate.h"
#import "Location.h"
#import "ShadowMask.h"

@interface PointOfInterestCell () <CategorySelectionViewDelegate>

@property (nonatomic, strong) CategorySelectionView *categorySelectionView;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) ShadowMask *shadowMask;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end



@implementation PointOfInterestCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    // Initialization code
    //[self.likeButton setTitle:nil forState:UIControlStateNormal];
    //[self.likeButton setImage:[UIImage imageNamed: @"heart-full-gray"] forState:UIControlStateNormal];
    
    [self.likeButton addTarget:self action: @selector(likeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) likeButtonPressed {
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeCategorySelectionView)];
    [[(UITableViewController*)self.delegate view] addGestureRecognizer:self.tapGesture];
    
        self.categorySelectionView = [[CategorySelectionView alloc] initInViewController:(UITableViewController *)self.delegate ForLocationNamed:self.searchResult.name];
        self.categorySelectionView.delegate = self;
        [((UITableViewController *)self.delegate).view addSubview:self.categorySelectionView];
    
    self.shadowMask = [[ShadowMask alloc] initWithFrame:[(UITableViewController*)self.delegate view].frame];
    [[(UITableViewController*)self.delegate view] insertSubview:self.shadowMask belowSubview:self.categorySelectionView];
    
}

- (void) categorySelected: (NSString *) category {
    
    //SearchResult *searchResult = source.searchResult;
    
    PointOfInterest *pointOfInterest = [NSEntityDescription insertNewObjectForEntityForName:@"PointOfInterest" inManagedObjectContext:self.context];
    
    //PointOfInterest *poi = [[PointOfInterest alloc] init];
    
    //poi = pointOfInterest;
    
    
    Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.context];
    
    pointOfInterest.location = location;
    pointOfInterest.name = self.searchResult.name;
    pointOfInterest.location.latitude = self.searchResult.latitude;
    pointOfInterest.location.longitude = self.searchResult.longitude;
    location.pointOfInterest = pointOfInterest;
    
    //poi = pointOfInterest;
    LocationType locationType;
    
    NSString *type = category;
    
    UIColor *pinColor;
    
    if ([type isEqualToString:@"Bar"]) {
        locationType = LocationTypeBar;
        pinColor = [UIColor redColor];
    } else if ([type isEqualToString:@"Coffee Shop"]) {
        locationType = LocationTypeCoffeeShop;
        pinColor = [UIColor blueColor];
    }else if ([type isEqualToString:@"Restaurant"]) {
        locationType = LocationTypeRestaurant;
        pinColor = [UIColor yellowColor];
    }else if ([type isEqualToString:@"Shopping"]) {
        locationType = LocationTypeShopping;
        pinColor = [UIColor greenColor];
    }else {
        locationType = LocationTypeRecreation;
        pinColor = [UIColor purpleColor];
    }
    pointOfInterest.locationType = locationType;
    
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Whoops couldn't save after category selection due to: %@", [error localizedDescription]);
    } else {
        NSLog(@"Saved %@ to disk with category: %@ - %@", pointOfInterest.name, pointOfInterest.category, category);
    }
    /*
    [self.mapView removeAnnotation:self.selectedSearchResult];
    static NSString *defaultPinID = @"resultPin";
    MKPinAnnotationView *pinView;
    if (pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:self.selectedSearchResult reuseIdentifier:defaultPinID];
    }
    pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    pinView.pinTintColor = pinColor;
    [self.mapView addSubview:pinView];
     */
    [self closeCategorySelectionView];
}

-(void) closeCategorySelectionView {
    self.categorySelectionView.hidden = YES;
    self.shadowMask.hidden = YES;
    
    self.categorySelectionView = nil;
    self.shadowMask = nil;
   // self.selectedSearchResult = nil;
}











@end
