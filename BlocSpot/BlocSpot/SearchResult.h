//
//  SearchResult.h
//  BlocSpot
//
//  Created by Chad Clayton on 10/27/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SearchResult : NSObject

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *category;
@property (nullable, nonatomic, retain) NSNumber *favorite;
@property (nullable, nonatomic, retain) NSNumber *lattitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;

//- (BOOL) matchesLocationInArray:(NSArray * _Nullable)array;


@end
