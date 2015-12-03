//
//  LikeButton.m
//  BlocSpot
//
//  Created by Chad Clayton on 10/22/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import "LikeButton.h"

@interface LikeButton ()



@end

@implementation LikeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) init {
    self = [super init];
    self.liked = NO;
    return self;
}

+ (instancetype) buttonForCategory:(LocationType)category {
    LikeButton *likeButton = [LikeButton buttonWithType:UIButtonTypeCustom];
    NSString *imageName;
    [likeButton setImage:[UIImage imageNamed:@"heart-full-gray"] forState:UIControlStateNormal];
    likeButton.frame = CGRectMake(0, 0, 30, 30);
    
    switch (category) {
        case LocationTypeBar:
            imageName = @"heart-full-red";
            break;
        case LocationTypeCoffeeShop:
            imageName = @"heart-full-blue";
            break;
        case LocationTypeRestaurant:
            imageName = @"heart-full-yellow";
            break;
        case LocationTypeShopping:
            imageName = @"heart-full-green";
            break;
        case LocationTypeRecreation:
            imageName = @"heart-full-purple";
            break;
        default:
            imageName = @"heart-full-gray";
            break;
    }
    [likeButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    return likeButton;
    
}

+ (instancetype) buttonWithColor:(UIColor *)color {
    LikeButton *likeButton = [LikeButton buttonWithType:UIButtonTypeCustom];
    NSString *imageName;
    
    likeButton.frame = CGRectMake(0, 0, 30, 30);
    
    if ([color isEqual:[UIColor redColor]]) {
        imageName = @"heart-full-red";
    } else if ([color isEqual:[UIColor blueColor]]){
        imageName = @"heart-full-blue";
    } else if ([color isEqual:[UIColor yellowColor]]){
        imageName = @"heart-full-yellow";
    } else if ([color isEqual:[UIColor greenColor]]){
        imageName = @"heart-full-green";
    } else if ([color isEqual:[UIColor purpleColor]]){
        imageName = @"heart-full-purple";
    } else {
        imageName = @"heart-full-gray";
    }
    
    [likeButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    return likeButton;
}

- (void) setHeartColorForCategory:(NSNumber *)category {
    
    NSString *imageName;
    
    switch ([category integerValue]) {
        case LocationTypeBar:
            imageName = @"heart-full-red";
            break;
        case LocationTypeCoffeeShop:
            imageName = @"heart-full-blue";
            break;
        case LocationTypeRestaurant:
            imageName = @"heart-full-yellow";
            break;
        case LocationTypeShopping:
            imageName = @"heart-full-green";
            break;
        case LocationTypeRecreation:
            imageName = @"heart-full-purple";
            break;
        default:
            imageName = @"heart-full-gray";
            break;
    }
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}


@end
