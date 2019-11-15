//
//  ViewController.m
//  YTLandScapeDemo
//
//  Created by admin on 2019/11/13.
//  Copyright © 2019 admin. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Masonry.h"

#import "HBAVPlayer.h"
@interface ViewController ()
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, strong) HBAVPlayer *player;
@end

static BOOL hasRotation;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
    
    self.navigationItem.title = @"首页";
    
    UIView *bgView = [UIView new];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    
    UIButton *selfRotationBtn = [UIButton new];
    selfRotationBtn.backgroundColor = [UIColor greenColor];
    [selfRotationBtn setTitle:@"内部切换" forState:UIControlStateNormal];
    [selfRotationBtn addTarget:self action:@selector(selfRotation) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:selfRotationBtn];
    [selfRotationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    
    UIButton *pushRotationBtn = [UIButton new];
    pushRotationBtn.backgroundColor = [UIColor greenColor];
    [pushRotationBtn setTitle:@"push切换" forState:UIControlStateNormal];
    [pushRotationBtn addTarget:self action:@selector(pushToViewCtr) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:pushRotationBtn];
    [pushRotationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(300);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    self.bgView = bgView;
}

- (void)selfRotation {
    hasRotation = !hasRotation;
    
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app_delegate.allowRotation = hasRotation;
    [app_delegate setInterfaceOrientationToPortrait: hasRotation ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait];
    self.navigationController.navigationBar.hidden = hasRotation;
    

    if (hasRotation) {
        self.bgView.hidden = true;
        self.player.hidden = false;
        [self.player start];
    }
    
}

- (HBAVPlayer *)player {
    if (_player == nil) {
        _player = [[HBAVPlayer alloc] initWithSuperView:self.view playerUrl:@"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4"];
        
        __weak typeof(self) WeakSelf = self;
        WeakSelf.player.popbackBlock = ^{
            [WeakSelf selfRotation];
            [WeakSelf.player stop];
            WeakSelf.player.hidden = true;
            WeakSelf.bgView.hidden = false;
        };
    }
    
    return _player;
}

- (void)pushToViewCtr {
    //1.
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app_delegate.allowRotation = true;
    [app_delegate setInterfaceOrientationToPortrait:UIInterfaceOrientationLandscapeRight];
    
    //2.
    [self.navigationController pushViewController:[NSClassFromString(@"HBVideoPlayViewController") new] animated:true];
}

@end
