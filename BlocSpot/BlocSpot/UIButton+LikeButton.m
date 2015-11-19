//
//  UIButton+LikeButton.m
//  BlocSpot
//
//  Created by Chad Clayton on 11/13/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import "UIButton+LikeButton.h"



@implementation UIButton (LikeButton)

+ (UIButton *) likeButtonWithColor:(StarColor) color {
    UIButton *button = [self likeButton];
    NSString *buttonColor;
    
    switch (color) {
        case HeartColorRed:
            buttonColor = @"heart-full-red";
            break;
        case HeartColorBlue:
            buttonColor = @"heart-full-blue";
            break;
        case HeartColorGreen:
            buttonColor = @"heart-full-green";
            break;
        case HeartColorPurple:
            buttonColor = @"heart-full-purple";
            break;
        case HeartColorYellow:
            buttonColor = @"heart-full-yellow";
            break;
        case HeartColorGray:
        default:
            buttonColor = @"heart-full-gray";
            break;
    }
    [button setImage:[UIImage imageNamed:buttonColor] forState:UIControlStateNormal];
    
    return button;
}

- (UIButton *) likeButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"star-full-gray"] forState:UIControlStateNormal];
    
    return button;
}

@end
