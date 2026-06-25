//
//  ScreenSize.m
//  君分时代
//
//  Created by 贠小飞 on 2018/4/10.
//  Copyright © 2018年 贠小飞. All rights reserved.
//

#import "ScreenSize.h"

@implementation ScreenSize


static CGFloat _deviceWidth = 0.0f;
static CGFloat _deviceHeight = 0.0;
static CGFloat _screenViewWidth = 0.0f;
static CGFloat _screenViewHeight = 0.0;
static CGFloat _screenDesignWidth = 320.0f;
static CGFloat _scaleWidth = 0.0f;
static CGFloat _tabBarHeight = 0.0f;

+ (void)loadData {
    UIScreen *screen = [UIScreen mainScreen];
    _deviceWidth = screen.bounds.size.width * screen.scale;
    _deviceHeight = screen.bounds.size.height * screen.scale;
    _screenViewWidth = screen.bounds.size.width;
    _screenViewHeight = screen.bounds.size.height;
    _screenDesignWidth = 320.0;
    _scaleWidth = _screenViewWidth / _screenDesignWidth;
}

+ (CGFloat)deviceWidth {
    return _deviceWidth;
}

+ (CGFloat)deviceHeight {
    return _deviceHeight;
}

+ (CGFloat)screenViewWidth {
    return _screenViewWidth;
}

+ (CGFloat)screenViewHeight {
    return _screenViewHeight;
}

+ (CGFloat)screenDesignWidth {
    return _screenDesignWidth;
}

+ (CGFloat)scaleWidth {
    return _scaleWidth;
}

+ (CGFloat)scale {
    return _scaleWidth;
}

+ (CGFloat)tabBarHeight {
    return _tabBarHeight;
}

+ (void)setTabBarHeight:(CGFloat)value {
    _tabBarHeight = value;
}


@end
