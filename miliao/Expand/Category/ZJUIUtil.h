//
//  ZJUIUtil.h
//  ZJW_Course
//
//  Created by imac on 2018/5/4.
//  Copyright © 2018年 wangmeng. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Global.h"


@interface ZJUIUtil : NSObject
 //设置下拉刷新
+ (void) refreshWithHeader:(UIScrollView *) tableView
                   refresh:(dispatch_block_t)refresh;

// 设置下拉刷新 并设置背景颜色
+ (void) refreshWithHeader:(UITableView *) tableView
            backgroudColor:(UIColor *)color
                   refresh:(dispatch_block_t)refresh;

// 设置白色箭头下拉刷新
+ (void)refreshWithWhiteHeader:(UITableView *) tableView
                       refresh:(dispatch_block_t) refresh;

// 设置白色箭头下拉刷新
+ (void)refreshWithCollectionViewHeader:(UICollectionView *) collectionView
                       refresh:(dispatch_block_t) refresh;

// 设置上拉刷新(白色)
+ (void)refreshWithWhiteFooter:(UITableView *) tableView
                       refresh:(dispatch_block_t) refresh;
// 设置下拉加载更多
+ (void)loadWithHeader:(UITableView *) tableView
               refresh:(dispatch_block_t) refresh;
// 设置上拉刷新
+ (void) refreshWithFooter:(UITableView *) tableView
                   refresh:(dispatch_block_t) refresh;

// 设置上拉刷新
+ (void) refreshWithCollectionViewFooter:(UICollectionView *) collectionView
                   refresh:(dispatch_block_t) refresh;

+ (UIColor *) colorWithHexString:(NSString *) hex;
// 16进制颜色
+ (UIColor *) colorWithHex:(long) hexColor;
+ (UIColor *) colorWithHex:(long) hexColor alpha:(CGFloat)alpha;
+ (UIImage *) imageWithColor:(UIColor *)color;
+ (UIImage *) imageWithColor:(UIColor *)color
                        size:(CGSize)size;
// 设置导航栏左侧按钮偏移
+ (void) leftNavItem:(UIViewController *)current
              button:(UIButton *)button
             offsetX:(CGFloat)offsetX;
/** 根据字体计以及最大宽度计算控件高度*/
+ (CGSize)sizeWith:(NSString *) text
          font:(UIFont *) fontSize
             width:(NSInteger) width;
+ (NSMutableAttributedString *)setHtmlStr:(NSString *)html isAnalyze:(BOOL)isAnalyze;

@end
