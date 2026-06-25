//
//  DeviceOpinion.h
//  GoGoGou
//
//  Created by lanou3g on 14-8-30.
//  Copyright (c) 2014年. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 判断是否iPhone X,异形屏*/
#define IS_iPhoneX   [DeviceOpinion is_special_shaped_screen]
/** iPhone X 导航部分不可用的高度*/
#define  iPhoneXNavNonHeight      24.f
/** iPhone X tab部分底部不可用的高度*/
#define  iPhoneXTabNonHeight      34.f
/** 导航，tab*/
#define  NavBarHeight        (IS_iPhoneX ? (64.f + iPhoneXNavNonHeight) : 64.f)
/** TabBar固定可用高度*/
#define  TabBarHeight        49.f
/** 屏幕宽高*/
#define SCREEN_HEIGHT_dy      (IS_iPhoneX ? ([[UIScreen mainScreen]bounds].size.height - iPhoneXTabNonHeight) : [[UIScreen mainScreen]bounds].size.height)
/** 屏幕宽高*/
#define SCREEN_WIDTH_dy       [[UIScreen mainScreen]bounds].size.width
/** 屏幕真实高度*/
#define SCREEN_HEIGHT_FULL    [[UIScreen mainScreen]bounds].size.height

#define  iPhoneXNavNonSSSSSHeightSSS        (IS_iPhoneX ? 24.f : 0)
#define  iPhoneXTabNonHeightsssss        (IS_iPhoneX ? 34.f : 0)

typedef NS_ENUM(NSInteger,DeviceType) {
    Unknown = 0,
    Simulator,
    iPhone_1G,          //基本不用
    iPhone_3G,          //基本不用
    iPhone_3GS,         //基本不用
    iPhone_4,           //基本不用
    iPhone_4s,          //基本不用
    iPhone_5,
    iPhone_5C,
    iPhone_5S,
    iPhone_SE,
    iPhone_6,
    iPhone_6P,
    iPhone_6s,
    iPhone_6s_P,
    iPhone_7,
    iPhone_7P,
    iPhone_8,
    iPhone_8P,
    iPhone_X,
    iPhone_XS,
    iPhone_XS_MAX,
    iPhone_XR,
    iPhone_11,
    iPhone_11_Pro,
    iPhone_11_Pro_Max,
    iPhone_SE_2nd,
    iPhone_12,
    iPhone_12_Pro,
    iPhone_12_mini,
    iPhone_12_Pro_Max,
    iPhone_13,
    iPhone_13_Pro,
    iPhone_13_mini,
    iPhone_13_Pro_Max,
    iPhone_14,
    iPhone_14_Pro,
    iPhone_14_Plus,
    iPhone_14_Pro_Max,
    iPhone_15,
    iPhone_15_Plus,
    iPhone_15_Pro,
    iPhone_15_Pro_Max,
    iPhone_16,
    iPhone_16_Plus,
    iPhone_16_Pro,
    iPhone_16_Pro_Max,
    iPhone_16_E,
};

typedef NS_ENUM(NSInteger,DyBarStyle) {
    /** 黑色*/
    Dark = 0,
    /** 白色*/
    White
};

@interface DeviceOpinion : NSObject
/** 3.5英寸屏幕，4，4s*/
+ (BOOL)isRunningOnINCHThreePointFive;//960 by 640 pixels
/** 4.0英寸屏幕，5，5s，5c，SE*/
+ (BOOL)isRunningOnINCHFour;//1136‑by‑640‑pixel
/** 4.7英寸屏幕，6，6s，7，8，SE_2nd*/
+ (BOOL)isRunningOnINCHFourPointSeven;//1334-by-750-pixel
/** 5.5英寸屏幕，6P，6SP，7P，8P*/
+ (BOOL)isRunningOnINCHFivePointFive;//1920-by-1080-pixel
/** 5.8英寸屏幕，X,XS，11Pro*/
+ (BOOL)isRunningOnINCHFivePointEight;//2436-by-1125-pixel
/** 6.1英寸屏幕，XR，11,12,12Pro*/
+ (BOOL)isRunningOnINCHSixPointOne;//1792-by-828-pixel
/** 6.5英寸屏幕，XS_MAX，11ProMax*/
+ (BOOL)isRunningOnINCHSixPointFive;//2688-by-1242-pixel
/** 5.4英寸屏幕，12mini*/
+ (BOOL)isRunningOnINCHFivePointFour;//2340-by-1080-pixel
/** 6.7英寸屏幕，12pro max*/
+ (BOOL)isRunningOnINCHSixPointSeven;//2778-by-1284-pixel

/******************************************************************************
 函数名称 : + (BOOL)isRunningOniPhone
 函数描述 : 当前是否运行在iPhone端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone;
/** 设备具体型号*/
+ (DeviceType)deviceType;
/** 是否是异形屏，X以上类型手机，根据屏幕尺寸判断*/
+ (BOOL)is_special_shaped_screen;
/** 如果想要判断设备是ipad，要用如下方法*/
+ (BOOL)is_iPad_model;
/** 设置statusBar颜色*/
+ (void)setBarStyle:(DyBarStyle)style;
/** 返回设备名称*/
+ (NSString *)deviceName;
@end


