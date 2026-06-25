//
//  UITabBar+Badge.m
//  miliao
//
//  Created by aa on 2019/9/26.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "UITabBar+Badge.h"
#define TabbarItemNums 4.0
@implementation UITabBar (Badge)
//显示小红点
- (void)showBadgeOnItemIndex:(int)index color:(UIColor *)color{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 4;//圆形
    badgeView.backgroundColor = color;//颜色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index + 0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 8, 8);//圆形大小为10
    [self addSubview:badgeView];
}
//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}
//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index || subView.tag == 100 + index) {
            [subView removeFromSuperview];
        }
    }
}
- (void)showBageOnItemWithIndex:(int)index value:(NSString *)valueStr color:(UIColor *)color{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    UILabel *badgeLabel = [[UILabel alloc] init];
    
    badgeLabel.tag = 100 + index;
    CGRect tabFrame = self.frame;
    //确定小红点的位置
    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeLabel.frame = CGRectMake(x, y, 12, 12);//圆形大小为12
    
    badgeLabel.layer.cornerRadius = 6;//圆形
    badgeLabel.layer.masksToBounds = YES;
    badgeLabel.backgroundColor = color;//颜色
    
    [self addSubview:badgeLabel];
    
    badgeLabel.text = valueStr;
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.font = Font(10);
    badgeLabel.textAlignment = NSTextAlignmentCenter;
}
@end
