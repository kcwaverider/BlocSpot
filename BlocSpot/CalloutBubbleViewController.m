//
//  CalloutBubbleViewController.m
//  BlocSpot
//
//  Created by Chad Clayton on 1/14/16.
//  Copyright © 2016 Chad Clayton. All rights reserved.
//

#import "CalloutBubbleViewController.h"
#import "CallOutBubble.h"

@interface CalloutBubbleViewController ()

@property (weak, nonatomic) IBOutlet CallOutBubble *calloutBubble;

@property (nonatomic, weak) IBOutlet UILabel *locationName;
@property (nonatomic, weak, readwrite) IBOutlet UITextView *descriptionText;
@property (nonatomic, weak) IBOutlet UIButton *likeButton;
@property (nonatomic, weak) IBOutlet UIButton *mapButton;

@end

@implementation CalloutBubbleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.calloutBubble.layer.cornerRadius = 5.0;
    self.descriptionText.layer.borderColor = [[UIColor blackColor] CGColor];
    self.descriptionText.layer.borderWidth = 1.0f;
    //self.view.backgroundColor = [UIColor clearColor];
    ;
    
    
    // Do any additional setup after loading the view.
    
}



-(void) viewDidAppear:(BOOL)animated {
    //self.calloutBubble.contentMode = UIViewContentModeRedraw
    self.calloutBubble.center = self.touchLocation;
    CGFloat x = self.calloutBubble.center.x;
    CGFloat y = self.calloutBubble.center.y;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)likeButtonPressed:(UIButton *)sender {
}

- (IBAction)directionsButtonPressed:(UIButton *)sender {
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
