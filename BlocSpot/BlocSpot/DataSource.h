//
//  DataSource.h
//  BlocSpot
//
//  Created by Chad Clayton on 10/15/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject

+ (instancetype) sharedInstance;

@property (nonatomic, strong) NSMutableArray *localPlacesList;
@property (nonatomic, strong) NSMutableArray *favoritePlacesList;

@end
