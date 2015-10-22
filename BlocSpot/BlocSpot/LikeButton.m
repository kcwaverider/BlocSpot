//
//  LikeButton.m
//  BlocSpot
//
//  Created by Chad Clayton on 10/22/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import "LikeButton.h"

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
    
    [self setImage:[UIImage imageNamed:@"heart-empty"] forState:UIControlStateNormal];
    
    return self;
}

@end
