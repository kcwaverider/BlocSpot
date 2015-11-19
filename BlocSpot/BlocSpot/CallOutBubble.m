//
//  CallOutBubble.m
//  BlocSpot
//
//  Created by Chad Clayton on 11/11/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import "CallOutBubble.h"

@implementation CallOutBubble

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.foodPOIButton = [LikeButton buttonWithType:UIButtonTypeCustom];
        [self.foodPOIButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.foodPOIButton setImage:[UIImage imageNamed:@"heart-full-gray"] forState:UIControlStateNormal];
        
        self.foodPOIButton.frame = CGRectMake(0, 0, 30, 30);
        [self addSubview:self.foodPOIButton];
        
        /*
        self.barStatus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart-full"]];
        self.coffeeShopStatus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart-full"]];
        self.otherStatus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart-full"]];
        
        self.restaurantStatus.tintColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.3];
        self.barStatus.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.3];
        self.coffeeShopStatus.tintColor = [UIColor colorWithRed:0.5 green:0.0 blue:0.5 alpha:0.3];
        self.otherStatus.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        
        self.restaurantStatus.frame = CGRectMake(0, 0, 28, 28);
        self.barStatus.frame = CGRectMake(30, 0, 28, 28);
        self.coffeeShopStatus.frame = CGRectMake(60, 0, 28, 28);
        self.otherStatus.frame = CGRectMake(90, 0, 28, 28);
        
        [self addSubview:self.restaurantStatus];
        [self addSubview:self.barStatus];
        [self addSubview:self.coffeeShopStatus];
        [self addSubview:self.otherStatus];
         */
    }
    
    
    
    
    
    return self;
}

-(void)buttonClicked {
    
}

/*
 - (instancetype)init
 {
 self = [super init];
 if (self) {
 self.restaurantStatus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart-full"]];
 self.barStatus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart-full"]];
 self.coffeeShopStatus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart-full"]];
 self.otherStatus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart-full"]];
 
 self.restaurantStatus.tintColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.3];
 self.barStatus.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.3];
 self.coffeeShopStatus.tintColor = [UIColor colorWithRed:0.5 green:0.0 blue:0.5 alpha:0.3];
 self.otherStatus.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
 
 self.restaurantStatus.frame = CGRectMake(0, 0, 28, 28);
 self.barStatus.frame = CGRectMake(30, 0, 28, 28);
 self.coffeeShopStatus.frame = CGRectMake(60, 0, 28, 28);
 self.otherStatus.frame = CGRectMake(90, 0, 28, 28);
 
 [self addSubview:self.restaurantStatus];
 [self addSubview:self.barStatus];
 [self addSubview:self.coffeeShopStatus];
 [self addSubview:self.otherStatus];
 }
 return self;
 }
 */

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end

















