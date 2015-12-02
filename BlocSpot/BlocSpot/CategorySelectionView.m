//
//  CategorySelectionView.m
//  BlocSpot
//
//  Created by Chad Clayton on 12/1/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import "CategorySelectionView.h"
#import "SearchResult.h"
#import "CategoryButton.h"

@interface CategorySelectionView ()

@property (nonatomic, strong) NSMutableArray *buttonArray;


@end


@implementation CategorySelectionView

- (instancetype) initForPoop {
    self = [super init];
    return self;
}

- (CategorySelectionView *) initInViewController: (UIViewController *) superViewController ForLocationNamed: (NSString *) locationName {
    self = [super init];
    
    
    CGFloat cornerRadius = 15;
    
    NSLog(@"likeButtonPressed");
    CGFloat xLocation = superViewController.view.bounds.size.width / 10;
    CGFloat yLocation = superViewController.view.bounds.size.height / 8;
    CGFloat width = superViewController.view.frame.size.width * (4.0/5.0);
    CGFloat height = superViewController.view.frame.size.height * (3.0/5.0);
    [self setFrame:CGRectMake( xLocation, yLocation, width, height)];
    
    
    NSLog(@"X: %f    Y: %f   Width: %f   Height: %f", xLocation, yLocation, height, width);
    
    self.buttonArray = [[NSMutableArray alloc] init];
    self.layer.cornerRadius = cornerRadius;
    self.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor blackColor];
    self.hidden = NO;
    
    UILabel *instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 2.0 / 7.0)];
    NSString *instructionString = [NSString stringWithFormat:@"Select a category for \n %@.", locationName];
    [instructionLabel setText:instructionString];
    instructionLabel.font = [UIFont boldSystemFontOfSize:20.0];
    instructionLabel.numberOfLines = 0;
    instructionLabel.textAlignment = NSTextAlignmentCenter;
    instructionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:instructionLabel];
    
    
    NSArray *categoryNames = @[@"Bar", @"Coffee Shop", @"Restaurant", @"Shopping", @"Recreation"];
    NSArray *categoryColors = @[[UIColor redColor], [UIColor blueColor], [UIColor yellowColor], [UIColor greenColor], [UIColor purpleColor]];
    
    for (NSInteger i = 0; i < 5; i++) {
        
        self.buttonArray[i] = [CategoryButton buttonWithType:UIButtonTypeSystem];
        
        CategoryButton *button = (CategoryButton *)self.buttonArray[i];
        
        [button setTitle:categoryNames[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:20.0];
        button.backgroundColor = [categoryColors[i] colorWithAlphaComponent:0.3];
        CGPoint buttonOrigin = CGPointMake(0, (self.frame.size.height * (2.0 + (CGFloat)i) / 7.0));
        button.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, self.frame.size.width, self.frame.size.height / 7);
        //button.searchResult = source.searchResult;
        
        [button addTarget:self action:@selector(categoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 4) {
            
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:(CGSize){cornerRadius, cornerRadius}].CGPath;
            maskLayer.frame = button.bounds;
            button.layer.mask = maskLayer;
        }
        
        [self addSubview:(CategoryButton *)self.buttonArray[i]];
    }
    
    return self;
}

-(void) categoryButtonTapped: (CategoryButton *) source {
    
}


@end
