//
//  UIButton+LikeButton.h
//  BlocSpot
//
//  Created by Chad Clayton on 11/13/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResult.h"


@interface UIButton (LikeButton)

typedef NS_ENUM(NSInteger, StarColor) {
    HeartColorRed       = 0,
    HeartColorBlue      = 1,
    HeartColorYellow    = 2,
    HeartColorGreen     = 3,
    HeartColorPurple    = 4,
    HeartColorGray      = 5,
};

@property (nonatomic, strong) SearchResult *searchResult;

+ (UIButton *) likeButtonWithColor:(StarColor) color;


@end
