//
//  HBVideoCell.m
//  HBVideoPlayDemo
//
//  Created by admin on 2020/2/27.
//  Copyright © 2020 admin. All rights reserved.
//

#import "HBVideoCell.h"
#import "Masonry.h"
#import "HBAVPlayer.h"
@interface HBVideoCell()

@end

@implementation HBVideoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIView *playerView = [UIView new];
    playerView.backgroundColor = [UIColor greenColor];
    [self addSubview:playerView];
    self.playerView = playerView;
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(300, 150));
    }];
    
    
    [self.playerView layoutIfNeeded];
    __weak typeof (self) weakSelf = self;
    self.player.popbackBlock = ^{
        [weakSelf switchOpe];
    };
    [self.player play];
}


- (HBAVPlayer *)player {
    if (_player == nil) {
        _player = [[HBAVPlayer alloc] initWithSuperView:self.playerView playerUrl:@"http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4"];
    }
    return _player;
}



+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"cellId";
    id cell = (HBVideoCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[HBVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}


- (void)switchOpe {
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchScreen:)]) {
        [self.delegate switchScreen:self];
    }
}

@end
