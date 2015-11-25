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
    [self.likeButton setTitle:nil forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed: @"heart-full-gray"] forState:UIControlStateNormal];
    
    [self.likeButton addTarget:self action: @selector(likePressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) likePressed {
    // button was pressed while in the like state, thus unliking the location
    if (self.likeButton.liked) {
        self.likeButton.liked = NO;
        self.likeButton.alpha = 0.3;
        //[self.likeButton setImage:[UIImage imageNamed: @"heart-empty"] forState:UIControlStateNormal];
    // button was pressed while in the unlike state, thus liking the location
    } else {
        self.likeButton.liked = YES;
        self.likeButton.alpha = 1.0;
        //[self.likeButton setImage:[UIImage imageNamed: @"heart-full"] forState:UIControlStateNormal];
    }
    
    [self.delegate cellDidPressLikeButton:self ToLikeState:self.likeButton.liked];
    
}











@end
