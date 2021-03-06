//
//  SearchResult.h
//  BlocSpot
//
//  Created by Chad Clayton on 10/27/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SearchResult : MKPointAnnotation

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *category;
@property (nullable, nonatomic, retain) NSNumber *favorite;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, strong) NSString *notes;
@property (nullable, nonatomic, strong) MKPinAnnotationView *pinView;
@property (nonatomic, strong)  NSManagedObjectContext * _Nonnull context;

//- (BOOL) matchesLocationInArray:(NSArray * _Nullable)array;


- (BOOL) isSavedLocation;


@end
