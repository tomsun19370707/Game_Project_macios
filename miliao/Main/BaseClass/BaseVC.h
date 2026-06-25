//
//  BaseVC.h
//  templateDemo
//
//  Created by 李东阳 on 2019/1/18.
//  Copyright © 2019年 锤子科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavBar.h"

/** 下拉、上拉类型 */
typedef NS_ENUM(NSInteger, RefreshType) {
    /** 普通请求 */
    NoneRefreshType = 11230,
    /** 下拉刷新 */
    HeaderRefreshType = 11231,
    /** 上拉加载 */
    FooterRefreshType = 11232,
};

@interface BaseVC : UIViewController
/** 自定义导航条*/
@property (nonatomic,strong)BaseNavBar *navigationBar;
/** 导航下居左对齐的标题*/
@property (nonatomic,strong) UILabel *subNaviTitle;
@property (nonatomic,strong) UILabel *secondTitle;
/** 返回上一级*/
- (void)back;
/** 分页数据加载*/
- (void)refreshPagingDataWithType:(RefreshType)refreshType  Scroll:(UIScrollView *)scroll;
/** 从栈中移出当前控控制器*/
- (void)dismissDetailVC:(void(^)(void))completion;
@end
