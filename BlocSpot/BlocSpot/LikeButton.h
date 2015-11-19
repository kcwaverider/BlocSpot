//
//  LikeButton.h
//  BlocSpot
//
//  Created by Chad Clayton on 10/22/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LikeButton;
@protocol LikeButtonDelegate <NSObject>

-(void) likeButtonPressed;

@end

@interface LikeButton : UIButton

@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) id <LikeButtonDelegate> delegate;

@end
