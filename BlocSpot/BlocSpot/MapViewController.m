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
#import <CoreLocation/CoreLocation.h>
#import "SearchResultsTableViewController.h"

@interface MapViewController ()  <CLLocationManagerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *listButton;


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKLocalSearch *search;
@property (strong, nonatomic) NSMutableArray *pointOfInterestArray;

@end

#define METERS_PER_MILE 1609.344
#define SEARCH_BAR_MAX_WIDTH 250


@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [DataSource sharedInstance];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    
    // Do any additional setup after loading the view.
    
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
   //self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    //self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    
    
    
    //[self.navigationController.navigationBar addSubview:self.listButton];
    //[self.listButton removeFromSuperview];
    
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

    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = -36.8406;
    zoomLocation.longitude = 174.7400;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, .5 * METERS_PER_MILE, .5 * METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSString *searchString = textField.text;
    NSLog(@"%@", searchString);
    
    // Call search function here...
    [self conductSearchFor:searchString];
    
    
    return NO;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    textField.text = nil;
    
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
        [DataSource sharedInstance].localPlacesList = [response.mapItems mutableCopy];
        self.search = nil;
        
        [self dropPinsFor:response.mapItems];
    }];
}

- (void) dropPinsFor:(NSArray *)mapItemsArray {
    
    id userLocation = [self.mapView userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
    if (pins != nil) {
        if (userLocation != nil) {
            [pins removeObject:userLocation];
        }
        
        [self.mapView removeAnnotations:pins];
    }
    
    for (MKMapItem *mapItem in mapItemsArray) {
        
        CGFloat latitude = mapItem.placemark.location.coordinate.latitude;
        CGFloat longitude = mapItem.placemark.location.coordinate.longitude;
        CLLocationCoordinate2D pinPoint;
        pinPoint.latitude = latitude;
        pinPoint.longitude = longitude;
        
        MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
        annot.coordinate = pinPoint;
         
       // MKPinAnnotationView *annot = [[MKPinAnnotationView alloc] ini]
        [self.mapView addAnnotation:annot];
        
    }
}


- (void) showList{
    SearchResultsTableViewController *list = [[SearchResultsTableViewController alloc] init];
    list.view.frame = CGRectMake( 120, 0, CGRectGetWidth(self.view.frame) - 120, CGRectGetHeight(self.view.frame) );
    list.pointOfInterestArray = [[NSMutableArray alloc]initWithArray:self.pointOfInterestArray];
    [self presentViewController:list animated:YES  completion:^{
        //list.pointOfInterestArray = [[NSMutableArray alloc]initWithArray:self.pointOfInterestArray];
    }];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


@end
