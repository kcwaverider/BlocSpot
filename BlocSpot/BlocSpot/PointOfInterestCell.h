//
//  PointOfInterestCell.h
//  BlocSpot
//
//  Created by Chad Clayton on 10/21/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointOfInterest.h"
#import "LikeButton.h"




@interface PointOfInterestCell : UITableViewCell

- (void) likePressed;

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UIImageView *likeImage;
@property (nonatomic, strong) PointOfInterest *pointOfInterest;
@property (nonatomic, strong) IBOutlet LikeButton *likeButton;

@end
