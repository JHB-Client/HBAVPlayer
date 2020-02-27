//
//  HBVideoCell.h
//  HBVideoPlayDemo
//
//  Created by admin on 2020/2/27.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HBVideoCell, HBAVPlayer;
@protocol HBVideoCellDelegate <NSObject>
- (void)switchScreen:(HBVideoCell *)videoCell;
@end

NS_ASSUME_NONNULL_BEGIN

@interface HBVideoCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, weak) id<HBVideoCellDelegate> delegate;
@property (nonatomic, assign) BOOL hasRotation;
@property (nonatomic, weak) UIView *playerView;
@property (nonatomic, strong) HBAVPlayer *player;
@end

NS_ASSUME_NONNULL_END
