//
//  PointOfInterestCell.m
//  BlocSpot
//
//  Created by Chad Clayton on 10/21/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import "PointOfInterestCell.h"
#import "LikeButton.h"

@interface PointOfInterestCell ()



@end



@implementation PointOfInterestCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) likePressed {
    if (self.likeButton.liked) {
        self.likeButton.liked = NO;
        [self.likeButton setImage:[UIImage imageNamed: @"heart-empty"] forState:UIControlStateNormal];
    } else {
        self.likeButton.liked = YES;
        [self.likeButton setImage:[UIImage imageNamed: @"heart-full"] forState:UIControlStateNormal];
    }
}

@end
