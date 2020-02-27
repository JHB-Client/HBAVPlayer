//
//  HBAVPlayer.h
//  HBVideoPlayDemo
//
//  Created by admin on 2019/11/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MASConstraintMaker;
NS_ASSUME_NONNULL_BEGIN

@interface HBAVPlayer : UIView
- (HBAVPlayer *)initWithSuperView:(UIView *)superView playerUrl:(NSString *)playerUrl;
- (void)play;
- (void)stop;
- (void)start;
- (void)remove;
- (void)setFullScreen;
- (void)setPlaylayerFrame:(void(NS_NOESCAPE ^)(MASConstraintMaker *make))block;
@property (nonatomic, copy) void(^popbackBlock)(void);
@end

NS_ASSUME_NONNULL_END
