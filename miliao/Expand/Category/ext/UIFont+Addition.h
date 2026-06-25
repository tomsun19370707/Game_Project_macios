//
//  UIFont+Addition.h
//  PodFullDemo
//
//  Created by 李东阳 on 2022/3/20.
//  Copyright © 2022 锤子科技. All rights reserved.
//

#import <UIKit/UIKit.h>

/** ----- Font -----*/
#define FONT(s) [UIFont systemFontOfSize:(s)]
/** 苹方常规体*/
#define PingFangFONT(s) [UIFont fontWithName:@"PingFangSC-Regular" size: (s)]
/** 苹方粗体*/
#define PingFangBoldFONT(s) [UIFont fontWithName:@"PingFangSC-Semibold" size: (s)]


NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Addition)

@end

NS_ASSUME_NONNULL_END
