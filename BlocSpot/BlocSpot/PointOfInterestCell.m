//
//  PointOfInterestCell.m
//  BlocSpot
//
//  Created by Chad Clayton on 10/21/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import "PointOfInterestCell.h"

@interface PointOfInterestCell ()

@property (nonatomic, strong) IBOutlet UILabel *name;

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

@end
