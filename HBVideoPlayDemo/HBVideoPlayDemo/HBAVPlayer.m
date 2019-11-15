//
//  HBAVPlayer.m
//  HBVideoPlayDemo
//
//  Created by admin on 2019/11/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HBAVPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"
@interface HBAVPlayer ()
@property (nonatomic, copy) NSString *playerUrl;
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@end

@implementation HBAVPlayer

- (HBAVPlayer *)initWithSuperView:(UIView *)superView playerUrl:(NSString *)playerUrl {
    self = [self initWithFrame:superView.bounds];
    [superView addSubview:self];
    
    //
    
    self.playerUrl = playerUrl;
//    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:playerUrl]];
//    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    if (self.player.currentItem) {
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    } else {
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    }
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    // 设置播放的UI
    self.playerLayer.frame = self.bounds;
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    // AVLayerVideoGravityResizeAspect
    // AVLayerVideoGravityResizeAspectFill
    // AVLayerVideoGravityResize
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:self.playerLayer];
    
    //-------------------------播放相关通知监听------------------------
    [self setPlayObserver];
    
    //
    UIButton *backBtn = [UIButton new];
    [backBtn setTitle:@"关" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [backBtn layoutIfNeeded];
    backBtn.backgroundColor = [UIColor lightGrayColor];
    backBtn.layer.cornerRadius = backBtn.bounds.size.width * 0.5;
    backBtn.layer.masksToBounds = true;
    backBtn.alpha = 0.7;
    //
    return self;
}

- (void)start {
    [self.player.currentItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [self.player play];
    }];
}

- (void)play {
    [self.player play];
}
- (void)stop {
    [self.player pause];
    //    [self removeFromSuperview];
    //    self.player = nil;
    //    [self.playerLayer removeFromSuperlayer];
}

- (void)remove {
    [self.player pause];
    [self removeFromSuperview];
    self.player = nil;
    [self.playerLayer removeFromSuperlayer];
}

- (AVPlayer *)player {
    if (_player == nil) {
         _player = [AVPlayer playerWithPlayerItem:self.playerItem];
    }
    return _player;
}


- (AVPlayerItem *)playerItem {
    if (_playerItem == nil) {
        _playerItem = [AVPlayerItem playerItemWithAsset:self.asset];
    }
    return _playerItem;
}

- (AVAsset *)asset {
    if (_asset == nil) {
        _asset = [AVAsset assetWithURL:[NSURL URLWithString:self.playerUrl]];
    }
    return _asset;
}


- (void)popBack {
    if (self.popbackBlock) {
        self.popbackBlock();
    }
}


- (void)setPlayObserver {
    //1.播放状态
    //    播放完成
    //    AVPlayerItemDidPlayToEndTimeNotification
    //    播放失败
    //    AVPlayerItemFailedToPlayToEndTimeNotification
    //    异常中断
    //    AVPlayerItemPlaybackStalledNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayFailed:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:self.player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackStalled:) name:AVPlayerItemPlaybackStalledNotification object:self.player.currentItem];
}


- (void)moviePlayDidEnd:(NSNotification *)notification {
    NSLog(@"-------视频播放完毕");
    //
    AVPlayerItem*item = [notification object];
    [item seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [self.player play];
    }];
}

- (void)moviePlayFailed:(NSNotification *)notification {
    NSLog(@"-------视频播放失败");
}

- (void)moviePlaybackStalled:(NSNotification *)notification {
    NSLog(@"-------视频播放异常中断");
    [self.player pause];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
