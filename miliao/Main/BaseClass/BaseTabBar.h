//
//  BaseTabBar.h
//  templateDemo
//
//  Created by 李东阳 on 2019/1/18.
//  Copyright © 2019年 锤子科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BaseTabBar : UITabBarController
/** 此view上可以放置点击按钮之类的控件 */
@property (nonatomic,strong)UIView *backView;
@end
