//
//  AppDelegate.h
//  HBNormalVideoPlayerDemo
//
//  Created by admin on 2020/2/27.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign) BOOL allowRotation;
- (void)setInterfaceOrientationToPortrait:(UIInterfaceOrientation)interfaceOrientation;
@end

