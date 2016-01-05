//
//  MapViewController.m
//  BlocSpot
//
//  Created by Chad Clayton on 10/8/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import "MapViewController.h"
#import "DataSource.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "SearchResultsTableViewController.h"
#import "PointOfInterest.h"
#import "Location.h"
#import "CallOutBubble.h"
#import "LikeButton.h"
#import "UIButton+LikeButton.h"
#import "CategoryButton.h"
#import "CategorySelectionView.h"

@interface MapViewController ()  <CLLocationManagerDelegate, UITextFieldDelegate, MKMapViewDelegate, UIPickerViewDelegate, CategorySelectionViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *listButton;
@property (weak, nonatomic) IBOutlet UIPickerView *categorySelectionPicker;
@property (weak, nonatomic) IBOutlet UITableView *categorySelectionTable;
@property (nonatomic, strong) UIView *categoryView;
@property (nonatomic, strong) SearchResult *selectedSearchResult;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) MKPinAnnotationView *lastSelectedPin;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKLocalSearch *search;
@property (strong, nonatomic) NSMutableArray *pointOfInterestArray;
@property (strong, nonatomic) CategorySelectionView *categorySelectionView;
@property (nonatomic, assign) BOOL pinDropAnimated;


@end

#define METERS_PER_MILE 1609.344
#define SEARCH_BAR_MAX_WIDTH 250


@implementation MapViewController

#pragma mark - Standard View Controls
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [DataSource sharedInstance];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    
    // Do any additional setup after loading the view.
    self.context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    self.categorySelectionPicker.delegate = self;
    self.pinDropAnimated = YES;
    [self dropPinsFor:self.favoriteLocationArray];
    
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [self.searchBar removeFromSuperview];
    //[self.listButton removeFromSuperview];
    self.navigationController.navigationBar.alpha = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {

    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat searchBarWidth = screenWidth < 400 ? screenWidth * 1 / 2 : SEARCH_BAR_MAX_WIDTH;
    CGRect searchBarFrame = CGRectMake((screenWidth - searchBarWidth) / 2, self.navigationController.navigationBar.frame.size.height / 2 - 10, searchBarWidth, 20);
    
    self.searchBar = [[UITextField alloc] initWithFrame:searchBarFrame];
    self.searchBar.text= @"Search";
    self.searchBar.textAlignment = NSTextAlignmentCenter;
    self.searchBar.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    self.searchBar.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.3];
    [self.navigationController.navigationBar addSubview:self.searchBar];
    self.searchBar.delegate = self;
    self.searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.navigationController.navigationBar.alpha = 0.6;
    
    /*
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = -36.8406;
    zoomLocation.longitude = 174.7400;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, .5 * METERS_PER_MILE, .5 * METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
     */
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}
#pragma mark - Search Field
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSString *searchString = textField.text;
    NSLog(@"%@", searchString);
    
    // Call search function here...
    [self conductSearchFor:searchString];
    
    
    return NO;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField.text  isEqual: @"Search"]) {
        textField.text = nil;
    }
    
    return YES;
}

- (void) conductSearchFor:(NSString *)searchString {
    
    [self.search cancel];
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchString;
    request.region = self.mapView.region;
    
    self.search = [[MKLocalSearch alloc] initWithRequest:request];
    
    [self.search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        
        self.pointOfInterestArray = nil;
       
        self.pointOfInterestArray = [[NSMutableArray alloc] init];
        
        for (NSUInteger i = 0; i < response.mapItems.count; i++) {

            SearchResult *searchResult = [[SearchResult alloc] init];
            searchResult.name = response.mapItems[i].name;
            searchResult.latitude = [NSNumber numberWithDouble:response.mapItems[i].placemark.coordinate.latitude];
            searchResult.longitude = [NSNumber numberWithDouble:response.mapItems[i].placemark.coordinate.longitude];
            if (![searchResult isSavedLocation]) {
                searchResult.category = [NSNumber numberWithInteger:LocationTypeNone];
            }

            
            CLLocationCoordinate2D pinPoint;
            pinPoint.latitude = [searchResult.latitude doubleValue];
            pinPoint.longitude = [searchResult.longitude doubleValue];
            searchResult.coordinate = pinPoint;
            
            self.pointOfInterestArray[i] = searchResult;
            
        }
        [DataSource sharedInstance].localPlacesList = self.pointOfInterestArray;
        
        self.search = nil;
        
        [self dropPinsFor:[DataSource sharedInstance].localPlacesList];
        NSLog(@"PINS DROPPED");
    }];
}

- (NSNumber *) searchResult:(SearchResult *)searchResult matchesLocationInArray:(NSArray*) array {
    
    for (PointOfInterest *info in array) {
        PointOfInterest *pointOfInterest = info;
        if ([searchResult.name isEqualToString: pointOfInterest.name] &&
            [searchResult.latitude isEqualToNumber: pointOfInterest.location.latitude] &&
            [searchResult.longitude isEqualToNumber: pointOfInterest.location.longitude]) {
            return [NSNumber numberWithBool:YES];
        }
    }
    return [NSNumber numberWithBool:NO];
}


#pragma mark - MapView Controlls
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    MKPinAnnotationView *pinView = nil;
    if (annotation != mapView.userLocation) {
        
        static NSString *defaultPinID = @"resultPin";
        pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];

        if (pinView == nil) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        }
        SearchResult *annot;
        annot = annotation;
        annot.title = annot.name;
        UIColor *categoryColor;
        if (pinView.pinTintColor) {
            categoryColor = [self pinColorForSearchResult: annot];
            pinView.pinTintColor = categoryColor;
        } else {
            if ([[self pinColorForSearchResult:annot] isEqual:[UIColor grayColor]]) {
                pinView.pinColor = MKPinAnnotationColorPurple;
                categoryColor = [UIColor purpleColor];
            } else {
                pinView.pinColor = MKPinAnnotationColorRed;
                categoryColor = [UIColor redColor];
            }
        }
        
        [pinView setCanShowCallout:YES];
        
        LikeButton *likeButton = [LikeButton buttonWithColor:categoryColor];
        likeButton.searchResult = annot;
        
        [likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = likeButton;
        
        //pinView.detailCalloutAccessoryView = [[CallOutBubble alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        
        pinView.animatesDrop = self.pinDropAnimated;
    
    }
    
    return pinView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKPinAnnotationView *)view
{
    
    //[view setCanShowCallout:YES];
    //NSLog(@"Title:%@",[view.annotation title]);
    self.lastSelectedPin = view;
}



-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocationCoordinate2D location = self.mapView.userLocation.location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 3200.0, 3200.0);
    
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - Pins

- (void) dropPinsFor:(NSArray *)mapItemsArray {
    
    id userLocation = [self.mapView userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
    if (pins != nil) {
        if (userLocation != nil) {
            [pins removeObject:userLocation];
        }
        
        [self.mapView removeAnnotations:pins];
    }
    
    for (SearchResult *result in mapItemsArray) {
        
        //MKPinAnnotationView *annotView = [[MKPinAnnotationView alloc] init];
        
        [self.mapView addAnnotation:result];
        
    }
}

-(UIColor *) pinColorForSearchResult: (SearchResult *) searchResult {

    //NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PointOfInterest" inManagedObjectContext:self.context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ AND location.latitude == %@ AND location.longitude == %@", searchResult.name, searchResult.latitude, searchResult.longitude];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&error];
    
    UIColor *color;
    
    // If it is favorited the appropriate color should be returned
    if ( results.count > 0) {
        LocationType category = [searchResult.category integerValue];
        NSLog([NSString stringWithFormat:@"NamePOOP: %@ CategoryPOOP: %@", searchResult.name, searchResult.category]);
        switch (category) {
            case LocationTypeBar:
                color = [UIColor redColor];
                break;
            case LocationTypeCoffeeShop:
                color = [UIColor blueColor];
                break;
            case LocationTypeRestaurant:
                color = [UIColor yellowColor];
                break;
            case LocationTypeShopping:
                color = [UIColor greenColor];
                break;
            case LocationTypeRecreation:
                color = [UIColor purpleColor];
                break;
            default:
                color = [UIColor grayColor];
                break;
        }
    }
    // If search result is not saved/favorited, pin should be gray
    else {
        color = [UIColor grayColor];
    }
    
    return color;
}

-(void) likeButtonPressed: (LikeButton *) source {
    
    self.selectedSearchResult = source.searchResult;
    self.categorySelectionView = [[CategorySelectionView alloc] initInViewController:self ForLocationNamed:source.searchResult.name];
    self.categorySelectionView.delegate = self;
    [self.view addSubview:self.categorySelectionView];
    
    for (NSObject<MKAnnotation> *annotation in self.mapView.selectedAnnotations) {
        [self.mapView deselectAnnotation:annotation animated:YES];
    }
    
    

}

- (void) categorySelected: (NSString *) category {
    
    //SearchResult *searchResult = source.searchResult;
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeCategorySelectionView)];
    [self.view addGestureRecognizer:self.tapGesture];
    
    PointOfInterest *pointOfInterest = [NSEntityDescription insertNewObjectForEntityForName:@"PointOfInterest" inManagedObjectContext:self.context];
    
    
    Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.context];
    
    pointOfInterest.location = location;
    pointOfInterest.name = self.selectedSearchResult.name;
    pointOfInterest.location.latitude = self.selectedSearchResult.latitude;
    pointOfInterest.location.longitude = self.selectedSearchResult.longitude;

    
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
    
    self.lastSelectedPin.pinTintColor = pinColor;
     
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
    //[self dropPinsFor:[DataSource sharedInstance].localPlacesList];
    [self closeCategorySelectionView];
}

-(void) closeCategorySelectionView {
    self.categorySelectionView.hidden = YES;
    
    
    self.categorySelectionView = nil;
    self.selectedSearchResult = nil;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showMapView"]) {
        MapViewController *controller = (MapViewController *)segue.destinationViewController;
        controller.context = self.context;
        NSLog(@"Map button Clikced");
    } else if ([[segue identifier] isEqualToString:@"savedLocationSelected"]) {
        MapViewController *controller = (MapViewController *)segue.destinationViewController;
        controller.context = self.context;
        NSLog(@"Point of Interest Clicked");
    }
    
}




@end
