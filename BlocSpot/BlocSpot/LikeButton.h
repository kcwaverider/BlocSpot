//
//  LikeButton.h
//  BlocSpot
//
//  Created by Chad Clayton on 10/22/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointOfInterest.h"

@class LikeButton;
@class SearchResult;
@protocol LikeButtonDelegate <NSObject>

-(void) likeButtonPressed;

@end

@interface LikeButton : UIButton

@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) _Nonnull id <LikeButtonDelegate> delegate;
@property (nonatomic, strong) SearchResult *searchResult;

+ (instancetype _Nonnull) buttonForCategory: (LocationType) category;
+ (instancetype _Nonnull) buttonWithColor: (UIColor *) color;

@end
