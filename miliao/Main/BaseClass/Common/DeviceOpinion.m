//
//  DeviceOpinion.m
//  GoGoGou
//
//  Created by lanou3g on 14-8-30.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "DeviceOpinion.h"
#import <sys/utsname.h>
@implementation DeviceOpinion
/******************************************************************************
 函数名称 : + (BOOL)isRunningOniPhone
 函数描述 : 当前是否运行在iPhone端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}
+ (DeviceType)deviceType{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine
                                            encoding:NSUTF8StringEncoding];
    //simulator
    if ([platform isEqualToString:@"i386"])          return Simulator;
    if ([platform isEqualToString:@"x86_64"])        return Simulator;
    
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])     return iPhone_1G;
    if ([platform isEqualToString:@"iPhone1,2"])     return iPhone_3G;
    if ([platform isEqualToString:@"iPhone2,1"])     return iPhone_3GS;
    if ([platform isEqualToString:@"iPhone3,1"])     return iPhone_4;
    if ([platform isEqualToString:@"iPhone3,2"])     return iPhone_4;
    if ([platform isEqualToString:@"iPhone4,1"])     return iPhone_4s;
    if ([platform isEqualToString:@"iPhone5,1"])     return iPhone_5;
    if ([platform isEqualToString:@"iPhone5,2"])     return iPhone_5;
    if ([platform isEqualToString:@"iPhone5,3"])     return iPhone_5C;
    if ([platform isEqualToString:@"iPhone5,4"])     return iPhone_5C;
    if ([platform isEqualToString:@"iPhone6,1"])     return iPhone_5S;
    if ([platform isEqualToString:@"iPhone6,2"])     return iPhone_5S;
    if ([platform isEqualToString:@"iPhone7,1"])     return iPhone_6P;
    if ([platform isEqualToString:@"iPhone7,2"])     return iPhone_6;
    if ([platform isEqualToString:@"iPhone8,1"])     return iPhone_6s;
    if ([platform isEqualToString:@"iPhone8,2"])     return iPhone_6s_P;
    if ([platform isEqualToString:@"iPhone8,4"])     return iPhone_SE;
    if ([platform isEqualToString:@"iPhone9,1"])     return iPhone_7;
    if ([platform isEqualToString:@"iPhone9,3"])     return iPhone_7;
    if ([platform isEqualToString:@"iPhone9,2"])     return iPhone_7P;
    if ([platform isEqualToString:@"iPhone9,4"])     return iPhone_7P;
    if ([platform isEqualToString:@"iPhone10,1"])    return iPhone_8;
    if ([platform isEqualToString:@"iPhone10,4"])    return iPhone_8;
    if ([platform isEqualToString:@"iPhone10,2"])    return iPhone_8P;
    if ([platform isEqualToString:@"iPhone10,5"])    return iPhone_8P;
    if ([platform isEqualToString:@"iPhone10,3"])    return iPhone_X;
    if ([platform isEqualToString:@"iPhone10,6"])    return iPhone_X;
    if ([platform isEqualToString:@"iPhone11,2"])    return iPhone_XS;
    if ([platform isEqualToString:@"iPhone11,6"])    return iPhone_XS_MAX;
    if ([platform isEqualToString:@"iPhone11,8"])    return iPhone_XR;
    if ([platform isEqualToString:@"iPhone12,1"])    return iPhone_11;
    if ([platform isEqualToString:@"iPhone12,3"])    return iPhone_11_Pro;
    if ([platform isEqualToString:@"iPhone12,5"])    return iPhone_11_Pro_Max;
    if ([platform isEqualToString:@"iPhone12,8"])    return iPhone_SE_2nd;
    if ([platform isEqualToString:@"iPhone13,2"])    return iPhone_12;
    if ([platform isEqualToString:@"iPhone13,3"])    return iPhone_12_Pro;
    if ([platform isEqualToString:@"iPhone13,1"])    return iPhone_12_mini;
    if ([platform isEqualToString:@"iPhone13,4"])    return iPhone_12_Pro_Max;
    if ([platform isEqualToString:@"iPhone14,5"])    return iPhone_13;
    if ([platform isEqualToString:@"iPhone14,2"])    return iPhone_13_Pro;
    if ([platform isEqualToString:@"iPhone14,4"])    return iPhone_13_mini;
    if ([platform isEqualToString:@"iPhone14,3"])    return iPhone_13_Pro_Max;
    if ([platform isEqualToString:@"iPhone14,7"])    return iPhone_14;
    if ([platform isEqualToString:@"iPhone15,2"])    return iPhone_14_Pro;
    if ([platform isEqualToString:@"iPhone14,8"])    return iPhone_14_Plus;
    if ([platform isEqualToString:@"iPhone15,3"])    return iPhone_14_Pro_Max;
    if ([platform isEqualToString:@"iPhone15,4"])    return iPhone_15;
    if ([platform isEqualToString:@"iPhone15,5"])    return iPhone_15_Plus;
    if ([platform isEqualToString:@"iPhone16,1"])    return iPhone_15_Pro;
    if ([platform isEqualToString:@"iPhone16,2"])    return iPhone_15_Pro_Max;
    if ([platform isEqualToString:@"iPhone17,3"])    return iPhone_16;
    if ([platform isEqualToString:@"iPhone17,4"])    return iPhone_16_Plus;
    if ([platform isEqualToString:@"iPhone17,1"])    return iPhone_16_Pro;
    if ([platform isEqualToString:@"iPhone17,2"])    return iPhone_16_Pro_Max;
    if ([platform isEqualToString:@"iPhone17,5"])    return iPhone_16_E;
    return Unknown;
}

/** 返回设备名称*/
+ (NSString *)deviceName{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine
                                            encoding:NSUTF8StringEncoding];
    //simulator
    if ([platform isEqualToString:@"i386"])          return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])        return @"Simulator";
    
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])     return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])     return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])     return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])     return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])     return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])     return @"iPhone 4s";
    if ([platform isEqualToString:@"iPhone5,1"])     return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])     return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"])     return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"])     return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"])     return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"])     return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"])     return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])     return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])     return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])     return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])     return @"iPhone se";
    if ([platform isEqualToString:@"iPhone9,1"])     return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,3"])     return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])     return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,4"])     return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])    return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,2"])    return @"iPhone Xs";
    if ([platform isEqualToString:@"iPhone11,6"])    return @"iPhone Xs Max";
    if ([platform isEqualToString:@"iPhone11,8"])    return @"iPhone Xr";
    if ([platform isEqualToString:@"iPhone12,1"])    return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"])    return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"])    return @"iPhone 11 Pro Max";
    if ([platform isEqualToString:@"iPhone12,8"])    return @"iPhone Se 2";
    if ([platform isEqualToString:@"iPhone13,2"])    return @"iPhone 12";
    if ([platform isEqualToString:@"iPhone13,3"])    return @"iPhone 12 Pro";
    if ([platform isEqualToString:@"iPhone13,1"])    return @"iPhone 12 mini";
    if ([platform isEqualToString:@"iPhone13,4"])    return @"iPhone 12 Pro Max";
    if ([platform isEqualToString:@"iPhone14,5"])    return @"iPhone 13";
    if ([platform isEqualToString:@"iPhone14,2"])    return @"iPhone 13 Pro";
    if ([platform isEqualToString:@"iPhone14,4"])    return @"iPhone 13 mini";
    if ([platform isEqualToString:@"iPhone14,3"])    return @"iPhone 13 Pro Max";
    if ([platform isEqualToString:@"iPhone14,7"])    return @"iPhone 14";
    if ([platform isEqualToString:@"iPhone15,2"])    return @"iPhone 14 Pro";
    if ([platform isEqualToString:@"iPhone14,8"])    return @"iPhone 14 Plus";
    if ([platform isEqualToString:@"iPhone15,3"])    return @"iPhone 14 Pro Max";
    if ([platform isEqualToString:@"iPhone15,4"])    return @"iPhone 15";
    if ([platform isEqualToString:@"iPhone15,5"])    return @"iPhone 15 Plus";
    if ([platform isEqualToString:@"iPhone16,1"])    return @"iPhone 15 Pro";
    if ([platform isEqualToString:@"iPhone16,2"])    return @"iPhone 15 Pro Max";
    if ([platform isEqualToString:@"iPhone17,3"])    return @"iPhone 16";
    if ([platform isEqualToString:@"iPhone17,4"])    return @"iPhone 16 Plus";
    if ([platform isEqualToString:@"iPhone17,1"])    return @"iPhone 16 Pro";
    if ([platform isEqualToString:@"iPhone17,2"])    return @"iPhone 16 Pro Max";
    if ([platform isEqualToString:@"iPhone17,5"])    return @"iPhone 16e";
    return @"未知";
}

/** 3.5英寸屏幕，4，4s*/
+ (BOOL)isRunningOnINCHThreePointFive
{
    BOOL screenSize = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO ;
    
    DeviceType device = [DeviceOpinion deviceType];
    if (device == iPhone_4 || device == iPhone_4s || screenSize) {
        return YES;
    }
    return NO ;
}
/** 4.0英寸屏幕，5，5s，5c，SE*/
+ (BOOL)isRunningOnINCHFour
{
    BOOL screenSize = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO ;
    
    DeviceType device = [DeviceOpinion deviceType];
    if (device == iPhone_5 || device == iPhone_5S || device == iPhone_5C || device == iPhone_SE || screenSize) {
        return YES;
    }
    return NO ;
}
/** 4.7英寸屏幕，6，6s，7，8，SE_2nd*/
+ (BOOL)isRunningOnINCHFourPointSeven
{
    BOOL screenSize = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO ;
    
    DeviceType device = [DeviceOpinion deviceType];
    if (device == iPhone_6 || device == iPhone_6s || device == iPhone_7 || device == iPhone_8 || device == iPhone_SE_2nd || screenSize) {
        return YES;
    }
    return NO ;
}
/** 5.5英寸屏幕，6P，6SP，7P，8P*/
+ (BOOL)isRunningOnINCHFivePointFive
{
    BOOL screenSize = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 1920), [[UIScreen mainScreen] currentMode].size) : NO ;
    
    DeviceType device = [DeviceOpinion deviceType];
    if (device == iPhone_6P || device == iPhone_6s_P || device == iPhone_7P || device == iPhone_8P || screenSize) {
        return YES;
    }
    return NO ;
}
/** 5.8英寸屏幕，X，XS，11Pro*/
+ (BOOL)isRunningOnINCHFivePointEight
{
    //判断iPhoneX和iPhoneXS
    BOOL screenSize = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO ;
    
    DeviceType device = [DeviceOpinion deviceType];
    if (device == iPhone_X || device == iPhone_XS || screenSize || device == iPhone_11_Pro) {
        return YES;
    }
    return NO ;
}
/** 6.1英寸屏幕，XR，11,12,12Pro*/
+ (BOOL)isRunningOnINCHSixPointOne
{
    //判断iPHoneXr
    BOOL screenSize = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO ;
    
    DeviceType device = [DeviceOpinion deviceType];
    if (device == iPhone_XR || screenSize || device == iPhone_11 || device == iPhone_12 || device == iPhone_12_Pro) {
        return YES;
    }
    return NO ;
}
/** 6.5英寸屏幕，XS_MAX,11ProMax*/
+ (BOOL)isRunningOnINCHSixPointFive
{
    //判断iPhoneXs Max
    BOOL screenSize = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO ;
    
    DeviceType device = [DeviceOpinion deviceType];
    if (device == iPhone_XS_MAX || screenSize || device == iPhone_11_Pro_Max) {
        return YES;
    }
    return NO ;
}
/** 5.4英寸屏幕，12mini*/
+ (BOOL)isRunningOnINCHFivePointFour
{
    //2340-by-1080-pixel
    //判断iPhone12 mini
    BOOL screenSize = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 2340), [[UIScreen mainScreen] currentMode].size) : NO ;
    
    DeviceType device = [DeviceOpinion deviceType];
    if (device == iPhone_12_mini || screenSize) {
        return YES;
    }
    return NO ;
}
/** 6.7英寸屏幕，12pro max*/
+ (BOOL)isRunningOnINCHSixPointSeven
{
    //2778-by-1284-pixel
    //判断 12pro max
    BOOL screenSize = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1284, 2778), [[UIScreen mainScreen] currentMode].size) : NO ;
    
    DeviceType device = [DeviceOpinion deviceType];
    if (device == iPhone_12_Pro_Max || screenSize) {
        return YES;
    }
    return NO ;
}
/** 是否是异形屏，X以上类型手机，根据屏幕尺寸判断,需要兼容模拟器运行条件*/
+ (BOOL)is_special_shaped_screen
{
    if ([DeviceOpinion getStatusBarHeight] > 20.0) {
        return YES;
    }
    
    if ([DeviceOpinion isRunningOnINCHFivePointEight]) {
        //判断iPhoneX和iPhoneXS
        return YES ;
    }else if ([DeviceOpinion isRunningOnINCHSixPointOne]) {
        //判断iPHoneXr
        return YES ;
    }else if ([DeviceOpinion isRunningOnINCHSixPointFive]) {
        //判断iPhoneXs Max
        return YES ;
    }else if ([DeviceOpinion isRunningOnINCHFivePointFour]) {
        //判断iPhone12 mini
        return YES ;
    }else if ([DeviceOpinion isRunningOnINCHSixPointSeven]) {
        //判断iPhone12 pro Max
        return YES ;
    }
    return NO ;
}
/** 如果想要判断设备是ipad，要用如下方法*/
+ (BOOL)is_iPad_model
{
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPhone"]) {
        //iPhone
        return NO;
    }
    else if([deviceType isEqualToString:@"iPod touch"]) {
        //iPod Touch
        return NO;
    }
    else if([deviceType rangeOfString:@"iPad"].location != NSNotFound) {
        //iPad
        return YES;
    }
    return NO;
    //这两个防范判断不准，不要用
    //#define is_iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    //
    //#define is_iPad (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
}

/** 获取状态栏高度*/
+ (CGFloat)getStatusBarHeight
{
    // 状态栏(statusbar)
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
//    DLog(@"\nstatus width - %f", rectStatus.size.width); // 宽度
//    DLog(@"\nstatus height - %f", rectStatus.size.height);   // 高度
    return rectStatus.size.height;
}

/** 设置statusBar颜色*/
+ (void)setBarStyle:(DyBarStyle)style
{
    if (style == Dark) {
        if (@available(iOS 13.0, *)) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        } else {
            // Fallback on earlier versions
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
    }else if (style == White) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}
@end





