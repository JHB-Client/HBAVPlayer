//
//  ViewController.m
//  HBAVPlayerDemo
//
//  Created by admin on 2019/11/13.
//  Copyright © 2019 admin. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *playerUrl = @"http://front-images.oss-cn-hangzhou.aliyuncs.com/i4/7cd76264037912663238de6cad3a5a71-167200670";
    [self playWithUrl:playerUrl];
}




- (void)playWithUrl:(NSString *)playerUrl {
    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:playerUrl]];
//        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:playerUrl] options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
        
    if (self.player.currentItem) {
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    } else {
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    }
        
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    // 设置播放的UI
    self.playerLayer.frame = CGRectMake(100, 100, 200, 100);
    self.playerLayer.backgroundColor = [UIColor greenColor].CGColor;
    // AVLayerVideoGravityResizeAspect
    // AVLayerVideoGravityResizeAspectFill
    // AVLayerVideoGravityResize
    self.playerLayer.videoGravity = AVLayerVideoGravityResize;
    [self.view.layer addSublayer:self.playerLayer];
    
    //------------------------AVPlayerItem监听-------------------
    [self setPlayerItemObserver];
    
    //-------------------------播放相关通知监听------------------------
    [self setPlayObserver];
}

- (void)setPlayerItemObserver {
    // 播放状态: 一定要使用status,这个是固定的。
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 缓冲进度
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    // 当缓存不够，视频加载不出来的情况
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
     // 监听缓存足够播放的状态
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
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
}

- (void)dealloc {

[[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([@"status" isEqualToString:keyPath]) {
//        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            // 获取视频时长
            CMTime duration = playerItem.duration;
            // 转换成秒
            CGFloat totalSecond = CMTimeGetSeconds(duration);
            NSLog(@"-------视频时长:%lf", totalSecond);
            
            [self.player play];
        } else if (playerItem.status == AVPlayerItemStatusFailed) {
            NSLog(@"------失败");
        } else if(playerItem.status == AVPlayerItemStatusUnknown){
            NSLog(@"------无数据源");
        }
    } else if ([@"loadedTimeRanges" isEqualToString:keyPath]) {
         NSArray *timeRanges = (NSArray *)[change objectForKey:NSKeyValueChangeNewKey];
        
        //
        if (timeRanges && timeRanges.count) {
           CMTimeRange timeRange = [timeRanges.firstObject CMTimeRangeValue];
           CMTime bufferDuration =  CMTimeAdd(timeRange.start, timeRange.duration);
            // 获取到缓冲的时间,然后除以总时间,得到缓冲的进度
            NSLog(@"-----缓冲的进度:%f",CMTimeGetSeconds(bufferDuration));
        }
    } else if ([@"playbackBufferEmpty" isEqualToString:keyPath]) {
        NSLog(@"------缓存不够");
    } else if ([@"playbackLikelyToKeepUp" isEqualToString:keyPath]) {
        NSLog(@"------缓存足够");
    }
}

@end
