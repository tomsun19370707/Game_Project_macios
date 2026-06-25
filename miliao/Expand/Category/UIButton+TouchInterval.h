//
//  UIButton+TouchInterval.h
//  miliao
//
//  Created by 张世浩 on 2022/6/27.
//  Copyright © 2022 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define defaultInterval .4// 默认间隔时间

@interface UIButton (TouchInterval)

/**
*  设置点击时间间隔
*/
@property (nonatomic, assign) NSTimeInterval timeInterVal;
@end

NS_ASSUME_NONNULL_END
