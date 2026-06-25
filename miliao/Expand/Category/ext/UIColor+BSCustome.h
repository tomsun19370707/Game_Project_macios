//
//  UIColor+BSCustome.h
//  BaiSiKanQi
//
//  Created by 李东阳 on 2019/1/18.
//  Copyright © 2019年 锤子科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientDyType) {// 渐变方向
    GradientDyTypeTopToBottom      = 0,//从上到下
    GradientDyTypeLeftToRight      = 1,//从左到右
    GradientDyTypeUpleftToLowright = 2,//左上到右下
    GradientDyTypeUprightToLowleft = 3,//右上到左下
};

/** 颜色16进制*/
#define  UIColorFromRGB(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/** hexStr*/
#define  HexColorDy(C)   [UIColor colorWithHexStringDy:C alpha:1.0]
/** RGB*/
#define  RGBCOLORDy(r,g,b)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
/** 主题色*/
#define  BaseMainColor     HexColorDy(@"#0D9AFF")
/** 分割线颜色*/
#define  LineColor         HexColorDy(@"f3f4f5")
/** 部分黄色*/
#define  YellowColor       HexColorDy(@"ffb64b")
/** 测试时候背景色，正式时候改为 clearColor*/
#define  TestColor         UIColor.randomColor
/** 消息发送方背景颜色*/
#define  ChatSendBg         RGBCOLORDy(200, 226, 249)


@interface UIColor (BSCustome)
/**
 * 从十六进制字符串获取颜色
 *
 * @parameter color:16进制字符串。支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 * @parameter alpha:透明度
 * @return 颜色。color类型
 */
+ (UIColor *)colorWithHexStringDy: (NSString *)color alpha:(CGFloat)alpha;
+ (UIColor *)randomColor;
/** 获取图片的主色调*/
+(UIColor*)mostColor:(UIImage*)image;
/** 渐变色 */
+ (UIColor *)gradientColors:(NSArray*)colors
               gradientType:(GradientDyType)gradientType
                    imgSize:(CGSize)imgSize;
@end
