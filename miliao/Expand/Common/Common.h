//
//  Common.h
//  miliao
//
//  Created by jkkj on 2021/6/29.
//  Copyright © 2021 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Common : NSObject
+ (instancetype)sharedSingleton;

/// 定义一个ChannelAttributeType的字符串类型作为枚举类型
typedef NSString *ChannelAttributeType NS_STRING_ENUM;
//频道9麦位的上锁状态
FOUNDATION_EXPORT ChannelAttributeType const Attribute_Lock1;
//频道房主信息
FOUNDATION_EXPORT ChannelAttributeType const Attribute_Own1;
//频道9麦位的话简开关
FOUNDATION_EXPORT ChannelAttributeType const Attribute_Say1;
//频道的背景图
FOUNDATION_EXPORT ChannelAttributeType const Attribute_BgImg1;
//频道的公告
FOUNDATION_EXPORT ChannelAttributeType const Attribute_Publish1;
//频道的封面图
FOUNDATION_EXPORT ChannelAttributeType const Attribute_CoverImg1;
//频道的名称
FOUNDATION_EXPORT ChannelAttributeType const Attribute_Name1;

+ (void)ChannelAttributeType:(ChannelAttributeType)channelAttributeType;

//获取当前时间日期星期
+(NSArray *)getCurrentTimeAndWeekDay;

//字符串为空检查
+ (BOOL)isEmptyString:(NSString *)sourceStr;
//判断空值，如果为空，就返回字符串 @""
+ (id)isNull:(id)object_1;
//判断是否为空,为空,就返回字符串@"0"
+ (id)isNullNumber:(id)object_1;
//判断数组是否为空
+ (BOOL)isBlankArr:(NSArray*)arr;
//判断字典是否为空
+ (BOOL)isBlankDictionary:(NSDictionary*)dic;
//删除字符串中多余的unicode码
+ (NSString *)deleteUnicodeStr:(NSString *)unicodeString;

///View转image
+(UIImage*)createImageFromView:(UIView*)view;
///获取当前显示的视图
+ (UIViewController *)getCurrentVC;
/**
 type:
 0-上左上右
 1-下左下右
 2-全部
 3-上左下左
 */
+ (void)setCornerFor:(NSInteger )type andView:(UIView *)aView andConer:(CGFloat)corner;

/*
 view 是要设置渐变字体的控件   bgVIew是view的父视图  colors是渐变的组成颜色  startPoint是渐变开始点 endPoint结束点
 */
+(void)TextGradientview:(UIView *)view bgVIew:(UIView *)bgVIew gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
/*
 control 是要设置渐变字体的控件   bgVIew是view的父视图  colors是渐变的组成颜色  startPoint是渐变开始点 endPoint结束点
 */
+(void)TextGradientControl:(UIControl *)control bgVIew:(UIView *)bgVIew gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

///获取window
+ (UIWindow *)AppWindow;
//获取设备标识
+ (NSString *)getUUID;
//用于存储iap内购返回的购买凭证
+ (NSString *)iapReceiptPath;
//获取字符串的宽度
+ (CGFloat)getStringWidthWithText:(NSString *)text font:(UIFont *)font viewHeight:(CGFloat)height;
/// 添加四边阴影效果
+ (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor;


+(NSString *)getTime;
/*
 *  时间戳转时间
 */
+ (NSString *)time:(NSString *)time andShowHoursMinutes:(BOOL)show;

//设置语言
+ (NSString *)getStringWithKey:(NSString *)key;
///左右渐变色
/// 渐变色
/// @param view 当前view
/// @param colorArray @[(__bridge id)[UIColor colorWithHexString:@"ff0000"].CGColor,(__bridge id)[UIColor colorWithHexString:@"ff0b00"].CGColor]
/// @param locations 分割比例 @[@0.2,@0.4,@1.0,@1.0]
+(void)setLeftCAGradientLayerForView:(UIView *)view colorArray:(NSArray *)colorArray
                           locations:(NSArray *)locations;


+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+(NSString *)dictionaryToJson:(NSDictionary *)dic;


/*
 *  获取视频URL第一帧图片
 */
+ (UIImage*)getThumbnailImage:(NSString*)videoURL;



@end

NS_ASSUME_NONNULL_END
