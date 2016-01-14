//
//  CalloutBubbleViewController.h
//  BlocSpot
//
//  Created by Chad Clayton on 1/14/16.
//  Copyright © 2016 Chad Clayton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalloutBubbleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIButton *directionsButton;

@property (weak, nonatomic) IBOutlet UITextView *descriptionText;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@end
