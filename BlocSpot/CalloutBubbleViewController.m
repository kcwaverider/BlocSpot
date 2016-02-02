//
//  CalloutBubbleViewController.m
//  BlocSpot
//
//  Created by Chad Clayton on 1/14/16.
//  Copyright © 2016 Chad Clayton. All rights reserved.
//

#import "CalloutBubbleViewController.h"
#import "CallOutBubble.h"
#import "CategorySelectionView.h"
#import "PointOfInterest.h"
#import "Location.h"


@interface CalloutBubbleViewController () <CategorySelectionViewDelegate>

@property (weak, nonatomic) IBOutlet CallOutBubble *calloutBubble;

@property (nonatomic, weak) IBOutlet UILabel *locationName;
@property (nonatomic, weak, readwrite) IBOutlet UITextView *descriptionText;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;
@property (nonatomic, weak) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) CategorySelectionView *categorySelectionView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (assign) BOOL isSavedLocation;



@end

@implementation CalloutBubbleViewController
#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    self.calloutBubble.layer.cornerRadius = 5.0;
    self.categoryLabel.layer.masksToBounds = YES;
    self.categoryLabel.layer.cornerRadius = self.categoryLabel.frame.size.height / 2;
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:self.tapGesture];
    
    

    // Do any additional setup after loading the view.
    
}

-(void) viewDidLayoutSubviews {
    self.locationName.text = self.selectedPointOfInterest.title;
   // self.locationName.attributedText = self.selectedPointOfInterest.title;
    [self checkForSavedLocation];
    
    [self keepCalloutBubbleInsideView];
    
}

-(void) viewDidAppear:(BOOL)animated {

}

-(void) keepCalloutBubbleInsideView{
    CGFloat minimumInset = 10.0;
    
    CGPoint calloutBubbleCenter = self.touchLocation;
    
    // Make sure the calloutBubble does not go off screen to the Left/Right
    if ( (self.touchLocation.x + self.calloutBubble.frame.size.width / 2) > self.calloutBubble.superview.bounds.size.width) { // Location is too far Right
        
        calloutBubbleCenter.x = self.calloutBubble.superview.bounds.size.width - (self.calloutBubble.frame.size.width / 2) - minimumInset;
        
    } else if ( (self.touchLocation.x - self.calloutBubble.frame.size.width / 2) < self.calloutBubble.superview.bounds.origin.x) { // Location is too far Left
        
        calloutBubbleCenter.x = (self.calloutBubble.frame.size.width / 2) + minimumInset;
    }
    
    // Make sure the calloutBubble does not go off screen to the Top/Bottom
    
    if ( (self.touchLocation.y + self.calloutBubble.frame.size.height / 2) > self.calloutBubble.superview.bounds.size.height ) { // Location is too far DOWN
        
        calloutBubbleCenter.y = self.calloutBubble.superview.bounds.size.height - (self.calloutBubble.frame.size.height / 2)  - minimumInset;
        
    } else if ( (self.touchLocation.y - self.calloutBubble.frame.size.width / 2) <self.calloutBubble.superview.bounds.origin.y) { // Location is too far UP
        
        calloutBubbleCenter.y = (self.calloutBubble.frame.size.height / 2) + minimumInset;
    }
    
    self.calloutBubble.center = calloutBubbleCenter;
}

- (void) backgroundColorForCategory:(NSNumber *) category {
    
    switch ([category integerValue]) {
        case LocationTypeBar:
            self.categoryLabel.backgroundColor = [UIColor redColor];
            self.categoryLabel.text = @"Bar";
            break;
        case LocationTypeCoffeeShop:
            self.categoryLabel.backgroundColor = [UIColor blueColor];
            self.categoryLabel.text = @"Coffee Shop";
            break;
        case LocationTypeRestaurant:
            self.categoryLabel.backgroundColor = [UIColor yellowColor];
            self.categoryLabel.text = @"Restaurant";
            break;
        case LocationTypeShopping:
            self.categoryLabel.backgroundColor = [UIColor greenColor];
            self.categoryLabel.text = @"Shopping";
            break;
        case LocationTypeRecreation:
            self.categoryLabel.backgroundColor = [UIColor purpleColor];
            self.categoryLabel.text = @"Recreation";
            break;
        default:
            self.categoryLabel.backgroundColor = [UIColor clearColor];
            self.categoryLabel.text = nil;
            UIImage *emptyHeartImage = [UIImage imageNamed:@"heart-empty"];
            [self.saveButton setImage:emptyHeartImage forState:UIControlStateNormal];
            
            
            break;
    }


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Callout Bubble Controlls

- (IBAction)likeButtonPressed:(UIButton *)sender {
    
    self.categorySelectionView = [[CategorySelectionView alloc] initInViewController:self ForLocationNamed:self.selectedPointOfInterest.name];
    self.categorySelectionView.delegate = self;
    [self.view addSubview:self.categorySelectionView];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeCategorySelectionView)];
    [self.view addGestureRecognizer:self.tapGesture];
    self.calloutBubble.hidden = YES;
    
}

- (IBAction)directionsButtonPressed:(UIButton *)sender {
    CLLocation *fromLocation = self.locationManager.location;
    
    CLLocationCoordinate2D toLocationCoordinate = CLLocationCoordinate2DMake([self.selectedPointOfInterest.latitude floatValue], [self.selectedPointOfInterest.longitude floatValue]);
    MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:toLocationCoordinate addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placeMark];
    destination.name = self.selectedPointOfInterest.name;
    
    [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
    
}

- (void) categorySelected: (NSString *) category {
    // Set up a tap gesture recognizer & darken the map view
    
    PointOfInterest *pointOfInterest = [NSEntityDescription insertNewObjectForEntityForName:@"PointOfInterest" inManagedObjectContext:self.context];
    
    
    Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.context];
    
    pointOfInterest.location = location;
    pointOfInterest.name = self.selectedPointOfInterest.name;
    pointOfInterest.location.latitude = self.selectedPointOfInterest.latitude;
    pointOfInterest.location.longitude = self.selectedPointOfInterest.longitude;
    NSString *notesString = self.descriptionText.text;
    pointOfInterest.notes = notesString;
    
    
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
    
    self.selectedPointOfInterest.pinView.pinTintColor = pinColor;
    
    pointOfInterest.locationType = locationType;
    
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Whoops couldn't save after category selection due to: %@", [error localizedDescription]);
    } else {
        NSLog(@"Saved %@ to disk with category: %@ - %@", pointOfInterest.name, pointOfInterest.category, category);
        [self checkForSavedLocation];
    }
    
    [self closeCategorySelectionView];
    self.categoryLabel.backgroundColor = [UIColor yellowColor];
    self.tapGesture = nil;
    //self.view.alpha = 1;
}

-(void) closeCategorySelectionView {
    self.categorySelectionView.hidden = YES;
    //self.shadowMask.hidden = YES;
    
    self.categorySelectionView = nil;
    //self.shadowMask = nil;
    //self.selectedPointOfInterest = nil;
    self.calloutBubble.hidden = NO;
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:self.tapGesture];
    //[self.view setNeedsDisplay];
    
}

-(void) viewTapped:(UITapGestureRecognizer *) tapGesture{
    UIView *view = tapGesture.view;
    CGPoint tapLocation = [tapGesture locationInView:view];
    UIView *tappedView = [view hitTest:tapLocation withEvent:nil];
    
    if (tappedView != self.calloutBubble) {
        NSLog(@"Shut it down");
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        NSLog(@"Tap Tap");

    }
}

-(void) checkForSavedLocation {
    self.isSavedLocation = [self.selectedPointOfInterest isSavedLocation];
    
    if (self.isSavedLocation) {
        self.saveButton.hidden = YES;
        self.saveButton.enabled = NO;
        
        self.deleteButton.hidden = NO;
        self.deleteButton.enabled = YES;
        
        self.descriptionText.text = self.selectedPointOfInterest.notes;
    } else {
        self.saveButton.hidden = NO;
        self.saveButton.enabled = YES;
        
        self.deleteButton.hidden = YES;
        self.deleteButton.enabled = NO;
    }
    [self backgroundColorForCategory:self.selectedPointOfInterest.category];
    
}

- (IBAction) deleteLocation {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PointOfInterest" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@ AND location.latitude == %@ AND location.longitude == %@", self.selectedPointOfInterest.name, self.selectedPointOfInterest.latitude, self.selectedPointOfInterest.longitude]];
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for (int i = 0; i < results.count; i++){
        [self.context deleteObject:results[i]];
    }
    
    if(![self.context save:&error]) {
        NSLog(@"Whoops, coudn't save: %@", [error localizedDescription]);
    } else {
        [self.mapView removeAnnotation:self.selectedPointOfInterest.pinView.annotation];
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end

