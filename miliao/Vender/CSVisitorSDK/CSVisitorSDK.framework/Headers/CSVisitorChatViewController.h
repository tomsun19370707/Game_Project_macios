//
//  CSVisitorChatViewController.h
//  VisitorSDKDemo
//
//  Created by Albert on 2019/8/26.
//  Copyright © 2019年 Albert. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CSPreMessageModel;

@interface CSVisitorChatViewController : UIViewController

// 预发消息数组
@property (nonatomic, copy) NSArray<CSPreMessageModel *> *preMessageModelArr;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

- (instancetype)initWithArg:(nonnull NSString *)arg style:(nonnull NSString *)style;

/**
 *  @param chatViewFrame default is (0, CSSafeAreaTopHeight, CSScreenWidth, CSScreenHeight - CSSafeAreaTopHeight - CSSafeAreaBottomHeight)
 *
 *  CSScreenWidth:          [[UIScreen mainScreen]bounds].size.width
 *  CSScreenHeight:         [[UIScreen mainScreen]bounds].size.height
 *  CSSafeAreaTopHeight:    (cs_statusBarHeight() + 44.0)
 *  CSSafeAreaBottomHeight: (cs_isIphoneXSeries() ? 34.0 : 0)
 *  cs_isIphoneXSeries():   判断是否是iPhoneX系列
 *  cs_statusBarHeight():   statusBar高度
 */
- (instancetype)initWithArg:(nonnull NSString *)arg style:(nonnull NSString *)style chatViewFrame:(CGRect)chatViewFrame;
@end

NS_ASSUME_NONNULL_END
