//
//  MapViewController.m
//  BlocSpot
//
//  Created by Chad Clayton on 10/8/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()  <CLLocationManagerDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *searchBar;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

//@property (strong, nonatomic)

@end

#define METERS_PER_MILE 1609.344
#define SEARCH_BAR_MAX_WIDTH 300


@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    // Do any additional setup after loading the view.
    NSLog(@"%f", self.view.frame.size.width);
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    self.searchBar = [[UITextField alloc] initWithFrame:CGRectMake(self.navigationController.navigationBar.frame.size.width / 2 - 30, self.navigationController.navigationBar.frame.size.height / 2 - 10, 60, 20)];
    self.searchBar.text= @"Search";
    self.searchBar.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    self.searchBar.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.3];
    [self.navigationController.navigationBar addSubview:self.searchBar];
    self.searchBar.delegate = self;
    //self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    //self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    
    NSLog(@"%@", NSStringFromCGRect(self.searchBar.frame));
    
    
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
    
    return NO;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    textField.text = nil;
    
    return YES;
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
