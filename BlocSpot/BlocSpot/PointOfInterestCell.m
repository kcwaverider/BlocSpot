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
    self.likeImage = [[UIImageView alloc] init];
    [self.likeButton setTitle:nil forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed: @"heart-empty"] forState:UIControlStateNormal];
    self.likeButton.tintColor = [UIColor purpleColor];
    
    [self.likeButton addTarget:self action: @selector(likePressed) forControlEvents:UIControlEventTouchUpInside];
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
    
    [self.delegate cellDidPressLikeButton:self ToLikeState:self.likeButton.liked];
    
}











@end
