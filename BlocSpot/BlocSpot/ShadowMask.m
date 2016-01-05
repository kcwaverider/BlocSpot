//
//  ShadowMask.m
//  BlocSpot
//
//  Created by Chad Clayton on 1/5/16.
//  Copyright © 2016 Chad Clayton. All rights reserved.
//

#import "ShadowMask.h"

@implementation ShadowMask

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype) init {
    ShadowMask *mask = [super init];
    mask.tintColor = [UIColor blackColor];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = .5;
    return mask;
}

-(instancetype) initWithFrame:(CGRect)frame {
    ShadowMask *mask = [super initWithFrame:frame];
    mask.tintColor = [UIColor blackColor];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = .5;
    return mask;
}

@end
