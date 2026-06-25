//
//  ScreenSize.h
//  君分时代
//
//  Created by 贠小飞 on 2018/4/10.
//  Copyright © 2018年 贠小飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScreenSize : NSObject


+ (void)loadData;
+ (CGFloat)deviceWidth;
+ (CGFloat)deviceHeight;
+ (CGFloat)screenViewWidth;
+ (CGFloat)screenViewHeight;
+ (CGFloat)screenDesignWidth;
+ (CGFloat)scaleWidth;
+ (CGFloat)scale;
+ (CGFloat)tabBarHeight;
+ (void)setTabBarHeight:(CGFloat)value;

@end
