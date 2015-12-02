//
//  CategorySelectionView.h
//  BlocSpot
//
//  Created by Chad Clayton on 12/1/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategorySelectionView;

@protocol CategorySelectionViewDelegate <NSObject>

-(void)METHOD_HERE;

//@required

-(void)categorySelected: (NSString *) category;

@end

@interface CategorySelectionView : UIView

- (instancetype) initForPoop;


- (CategorySelectionView *) initInViewController: (UIViewController * _Nonnull) superViewController ForLocationNamed: (NSString * _Nonnull) locationName;

@property (nonatomic, assign) _Nonnull id <CategorySelectionViewDelegate> delegate;



@end
