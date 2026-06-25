//
//  BaseTabBar.m
//  templateDemo
//
//  Created by 李东阳 on 2019/1/18.
//  Copyright © 2019年 锤子科技. All rights reserved.
//

#import "BaseTabBar.h"
@interface BaseTabBar ()
@end
@implementation BaseTabBar

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 页面*/
    [self initSubview];
    
    // Do any additional setup after loading the view.
}
#pragma mark --- 初始化
- (void)initSubview
{
    /** tab背景图*/
    [self.tabBar insertSubview:self.backView atIndex:0];
    self.tabBar.opaque = NO;
}
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TabBarHeight)];
        if ([DeviceOpinion is_special_shaped_screen]) {
            _backView.height = TabBarHeight + iPhoneXTabNonHeight ;
        }
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView ;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

