//
//  HBVideoPlayViewController.m
//  HBVideoPlayDemo
//
//  Created by admin on 2019/11/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HBVideoPlayViewController.h"
#import "AppDelegate.h"
#import "HBAVPlayer.h"
@interface HBVideoPlayViewController ()
@property (nonatomic, strong) HBAVPlayer *player;
@end

@implementation HBVideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self.player play];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parsePlay) name:@"parsePlay" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continuePlay) name:@"continuePlay" object:nil];
}


- (void)parsePlay {
    if (self.player) {
        [self.player stop];
    }
}

- (void)continuePlay {
    if (self.player) {
        [self.player play];
    }
}



- (HBAVPlayer *)player {
    if (_player == nil) {
        _player = [[HBAVPlayer alloc] initWithSuperView:self.view playerUrl:@"http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4"];
        
        __weak typeof(self) WeakSelf = self;
        WeakSelf.player.popbackBlock = ^{
            [WeakSelf.navigationController popViewControllerAnimated:true];
        };
    }
    
    return _player;
}


//
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.player play];
    self.navigationController.navigationBar.hidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = false;
  
    //1.
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app_delegate.allowRotation = false;
    [app_delegate setInterfaceOrientationToPortrait:UIInterfaceOrientationPortrait];
    
    [self.player remove];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    
    //
    NSLog(@"------===2==-----");
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"parsePlay" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"continuePlay" object:nil];
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
