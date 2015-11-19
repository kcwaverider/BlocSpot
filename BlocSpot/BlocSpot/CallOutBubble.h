//
//  CallOutBubble.h
//  BlocSpot
//
//  Created by Chad Clayton on 11/11/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeButton.h"

typedef NS_ENUM(NSInteger, Category) {
    CategoryRestraunt           = 0,
    CategoryBar                 = 1,
    CategoryCoffeeShop          = 2,
    CategoryOther               = 3,
};

@interface CallOutBubble : UIView

@property (nonatomic, strong) IBOutlet LikeButton *foodPOIButton;
@property (nonatomic, strong) IBOutlet LikeButton *drinkPOIButton;
@property (nonatomic, strong) IBOutlet LikeButton *shoppingPOIButton;
@property (nonatomic, strong) IBOutlet LikeButton *recreationPOIButton;


@end
