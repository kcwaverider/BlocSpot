//
//  PointOfInterestCell.h
//  BlocSpot
//
//  Created by Chad Clayton on 10/21/15.
//  Copyright © 2015 Chad Clayton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResult.h"
#import "LikeButton.h"
@class PointOfInterestCell;
@protocol PointOfInterestCellDelegate <NSObject>
@required
- (void) cellDidPressLikeButton:(PointOfInterestCell *)cell ToLikeState:(BOOL)likeState;

@end


@interface PointOfInterestCell : UITableViewCell

- (void) likeButtonPressed;

@property (nonatomic, strong) IBOutlet UILabel *name;
//@property (nonatomic, strong) IBOutlet UIImageView *likeImage;
@property (nonatomic, strong) SearchResult *searchResult;
@property (nonatomic, strong) IBOutlet LikeButton *likeButton;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, assign) id <PointOfInterestCellDelegate> delegate;

@end
