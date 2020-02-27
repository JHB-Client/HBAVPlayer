//
//  ViewController.m
//  HBNormalVideoPlayerDemo
//
//  Created by admin on 2020/2/27.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Masonry.h"

#import "HBAVPlayer.h"
#import "HBVideoCell.h"
@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, HBVideoCellDelegate>
@end

static BOOL hasRotation;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"首页";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HBVideoCell *cell = [HBVideoCell cellWithTableView:tableView];
    cell.delegate = self;
    return cell;
}

- (void)switchScreen:(HBVideoCell *)videoCell {
    videoCell.hasRotation = !videoCell.hasRotation;
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app_delegate.allowRotation = videoCell.hasRotation;
    [app_delegate setInterfaceOrientationToPortrait: videoCell.hasRotation ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait];
    self.navigationController.navigationBar.hidden = videoCell.hasRotation;
    //
    if (videoCell.hasRotation == true) {
        [videoCell.playerView removeFromSuperview];
        [self.view addSubview:videoCell.playerView];
        [videoCell.player setFullScreen];
    } else {
        [videoCell.playerView removeFromSuperview];
        [videoCell addSubview:videoCell.playerView];
        [videoCell.player setPlaylayerFrame:^(MASConstraintMaker * _Nonnull make) {
            make.center.mas_equalTo(videoCell);
            make.size.mas_equalTo(CGSizeMake(300, 150));
        }];
    }
}
@end
