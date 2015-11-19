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

@interface MapViewController ()  <CLLocationManagerDelegate, UITextFieldDelegate, MKMapViewDelegate, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *listButton;
@property (weak, nonatomic) IBOutlet UIPickerView *categorySelectionPicker;
@property (weak, nonatomic) IBOutlet UITableView *categorySelectionTable;
@property (nonatomic, strong) UIView *categoryView;


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKLocalSearch *search;
@property (strong, nonatomic) NSMutableArray *pointOfInterestArray;

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
    self.navigationController.navigationBar.alpha = 0.6;

    /*
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = -36.8406;
    zoomLocation.longitude = 174.7400;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, .5 * METERS_PER_MILE, .5 * METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
     */
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
        NSLog(@"Map Items: %@", response.mapItems);
        
        self.pointOfInterestArray = nil;
       // [DataSource sharedInstance].localPlacesList = [response.mapItems mutableCopy];
        self.pointOfInterestArray = [[ NSMutableArray alloc] init];
        // TODO: call a method that deletes all items from the data store
        //[DataSource sharedInstance].localPlacesList = nil;
        for (NSUInteger i = 0; i < response.mapItems.count; i++) {
          /*
            PointOfInterest *pointOfInterest = [NSEntityDescription insertNewObjectForEntityForName:@"PointOfInterest" inManagedObjectContext:self.context];
           
            Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.context];
            
            pointOfInterest.name = response.mapItems[i].name;
            pointOfInterest.category = [NSNumber numberWithInteger:i];
            
            NSNumber *latitude = [NSNumber numberWithDouble:response.mapItems[i].placemark.coordinate.latitude];
            location.latitude = latitude;
            NSNumber *longitude = [NSNumber numberWithDouble:response.mapItems[i].placemark.coordinate.longitude];
            location.longitude = longitude;
            pointOfInterest.location = location;
            location.pointOfInterest = pointOfInterest;
            self.pointOfInterestArray[i] = pointOfInterest;
            */
            SearchResult *searchResult = [[SearchResult alloc] init];
            searchResult.name = response.mapItems[i].name;
            searchResult.category = [NSNumber numberWithInteger:i];
            
            searchResult.latitude = [NSNumber numberWithDouble:response.mapItems[i].placemark.coordinate.latitude];
            searchResult.longitude = [NSNumber numberWithDouble:response.mapItems[i].placemark.coordinate.longitude];
            CLLocationCoordinate2D pinPoint;
            pinPoint.latitude = [searchResult.latitude doubleValue];
            pinPoint.longitude = [searchResult.longitude doubleValue];
            searchResult.coordinate = pinPoint;
            
            searchResult.favorite = [self searchResult:searchResult matchesLocationInArray:[DataSource sharedInstance].favoritePlacesList];
            
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
        
        if (pinView.pinTintColor) {
            pinView.pinTintColor = [self pinColorForSearchResult: annot];
        } else {
            if ([[self pinColorForSearchResult:annot] isEqual:[UIColor grayColor]]) {
                pinView.pinColor = MKPinAnnotationColorPurple;
            } else {
                pinView.pinColor = MKPinAnnotationColorRed;
            }
        }
        
        [pinView setCanShowCallout:YES];
        
        
        //pinView.leftCalloutAccessoryView = [[CallOutBubble alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        LikeButton *likeButton = [LikeButton buttonWithType:UIButtonTypeCustom];
        [likeButton setImage:[UIImage imageNamed:@"heart-full-gray"] forState:UIControlStateNormal];
        likeButton.frame = CGRectMake(0, 0, 30, 30);
        [likeButton addTarget:self action:@selector(likeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = likeButton;
        
        //pinView.detailCalloutAccessoryView = [[CallOutBubble alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        
        pinView.animatesDrop = YES;
    
    }
    
    return pinView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //[view setCanShowCallout:YES];
    //NSLog(@"Title:%@",[view.annotation title]);
}



-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocationCoordinate2D location = self.mapView.userLocation.location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 1000.0, 1000.0);
    
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
        // MKAnnotationView *annotView = [self mapView:self.mapView viewForAnnotation:annot];
        // [self.mapView addSubview:annotView];
    }
}

-(UIColor *) pinColorForSearchResult: (SearchResult *) searchResult {

    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PointOfInterest" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ AND location.latitude == %@ AND location.longitude == %@", searchResult.name, searchResult.latitude, searchResult.longitude];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    UIColor *color;
    
    // If it is favorited the appropriate color should be returned
    if ( results.count > 0) {
        color = [UIColor redColor];
    }
    // If search result is not saved/favorited, pin should be gray
    else {
        color = [UIColor grayColor];
    }
    
    return color;
}

-(void) likeButtonPressed {
    NSLog(@"likeButtonPressed");
    CGFloat xLocation = self.view.bounds.size.width / 10;
    CGFloat yLocation = self.view.bounds.size.height / 8;
    CGFloat width = self.view.frame.size.width * (4.0/5.0);
    CGFloat height = self.view.frame.size.height * (3.0/5.0);
    NSLog(@"X: %f    Y: %f   Width: %f   Height: %f", xLocation, yLocation, height, width);
    UIView *categorySelectionView = [[UIView alloc] initWithFrame:CGRectMake( xLocation, yLocation, width, height)];
    categorySelectionView.layer.cornerRadius = 15.0;
    categorySelectionView.backgroundColor = [UIColor whiteColor];
    categorySelectionView.tintColor = [UIColor blackColor];
    categorySelectionView.hidden = NO;
    [self.view addSubview:categorySelectionView];
    NSArray *categoryNames = @[@"Bar", @"Coffee Shop", @"Restaurant", @"Shopping", @"Recreation"];
    //HeartColor  heartColors[5];
    //heartColors = [HeartColorRed, HeartColorBlue, HeartColorYellow, HeartColorGreen, HeartColorPurple];
    
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *button = [UIButton likeButtonWithColor:i];
        [button addTarget:self action:@selector(categorySelected:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.text = categoryNames[i];
        CGPoint 
        button.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showMapView"]) {
        MapViewController *controller = (MapViewController *)[segue destinationViewController];
        controller.context = self.context;
    }
    
}




@end
