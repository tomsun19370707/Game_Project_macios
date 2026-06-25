//
//  NSString+category.h
//  XiYuanPlus
//
//  Created by lijie lijie on 2018/4/10.
//  Copyright © 2018年 Hoping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (category)
/**
 比较两个数值是否相等
 */
+ (BOOL)compareTowLocation:(CGFloat)longctionOne locationTwo:(CGFloat)locationTwo;

///字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/**
 *  xigua
 *
 *  @param dic 数据字典
 *
 *  @return 返回json串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/**
 *  xigua
 *
 *  @param dataDic 数据字典
 *
 *  @return 请求字典
 */
+ (NSDictionary *)getReqParamDic:(NSDictionary *)dataDic;


/**
 [""]    xigua
 [""]    @returns 获取当前时间
 [""] */
+ (NSString *)getCurrentIntervalTime;
/**
 *  xigua
 *
 *  @param second 秒
 *
 *  @return 分钟和秒
 */
+(NSString *)changeSecondToMinute:(NSString *)second;

/**
 *   xigua
 *
 *  @param kTimeFormarter 格式
 *
 *  @return 格式当前的时间
 */
+(NSString *)getCurrentTime:(NSString *)kTimeFormarter;
/*
 获取当前时间戳,到毫秒  建议用这个
 */
+(NSString *)getNowTimeTimestamp3;
/*
 获取当前时间戳
 */
+ (NSString *)getCurrentTimeSp;
/**
 *  ybjia  根据时间戳，获取日期字符串，格式为：yyyy-MM-dd HH:mm:ss
 */

+ (NSString *)getDateStringWithTimeInterval:(NSTimeInterval)timeInterval;

/**
 时间戳转时间的方法:
 
 @param time 时间戳
 @return 时间
 */
+ (NSString *)dateStringChangeToTimestamp:(NSString *)time;
/**
 *  计算剩余时间
 *
 *  @param endTime   结束日期
 *
 *  @return 剩余时间
 */
+ (NSString *)getCountDownStringWithEndTime:(NSString *)endTime;
/*
 作者：西瓜
 yyyy-MM-dd HH:mm:ss
 转化服务器时间
 */
+(NSString *)getDate:(NSDate *)dateTime kTimeFormarter:(NSString *)kTimeFormarter;

/**
 秒转分

 @param time 时长-秒
 @return 时长-分
 */
+ (NSString *)stringWithTime:(NSInteger)time;

/**
 秒转分
 03:20
 @param time 时长-秒
 @return 时长-分
 */
+ (NSString *)minuteAndSecStringWithTime:(NSInteger)time;

/**
 *  getDeviceUUID
 *
 *  @return 设备唯一标示
 */
+ (NSString *)getDeviceUUID;

/**
 xigua
 @param str 要md5的字符传
 @returns 返回加密后的串
 */
+ (NSString *)md5:(NSString *)str;


/**
 *  xigua
 *
 *  @return 获取唯一id
 */
+ (NSString *)getOneUUID;

+(NSString *)identifier;
+(NSString *)phoneName;
+(NSString *)phoneVersion;//手机系统版本号
+(NSString *)phoneModel;
+(NSString*)deviceVersion;//手机具体型号
+(NSString *)getCurrentLanguage;//当前语言
+ (NSMutableAttributedString *)mutableAttributedStringFromString:(NSString *)string withFont1:(UIFont *)font1 withFont2:(UIFont *)font2;
/**
 *  @param name 用户名
 *
 *  @return 验证用户名
 */
+(BOOL)validateName:(NSString *)name;

/**
 *  @param phoneNumber 手机号
 *
 *  @return 验证手机号
 */
+(BOOL)validaeMoblieNumber:(NSString *)phoneNumber;

/**
 *  @param phoneNumber 电话号
 *
 *  @return 验证电话号
 */
+(BOOL)validaePhoneNumber:(NSString *)phoneNumber;

/**
 *  @param email 邮箱
 *
 *  @return 验证邮箱是否合法
 */
+(BOOL)validaEmail:(NSString *)email;

/*
 身份证号是否合法匹配
 */
+(BOOL)checkId:(NSString *)cid;

/*
 身份证后4位校验
 */
+(BOOL)validaID4:(NSString *)idStr;

/*
 密码验证
 */
+(BOOL)validapwd:(NSString *)pwd;


/*
 身份证校验
 */
+(BOOL)validateIdentityCard: (NSString *)identityCard;


/**
 *  字符串转MD5字符串
 *
 *  @param str 要转换的字符串
 *
 *  @return 转换后的字符串
 */
+ (NSString *)string2md5:(NSString *)str;


/**
 *  计算文字适配宽度或高度
 *
 *  @param heightMask 是否是高度适配
 *  @param flt        高度适配表示宽度 宽度适配表示高度
 *  @param font       当前字符串字体格式
 *
 *  @return 返回高度或者宽度
 */
- (float)stringWithHeightMask:(BOOL)heightMask withMask:(float)flt withFont:(UIFont *)font;

/**
 *  计算文字适配宽度或高度
 *
 *  @param heightMask 是否是高度适配
 *  @param flt        高度适配表示宽度 宽度适配表示高度
 *  @param font       当前字符串字体格式
 *  @param str        当前字符串内容
 *
 *  @return 返回高度或者宽度
 */
+ (float)stringWithHeightMask:(BOOL)heightMask withMask:(float)flt withFont:(UIFont *)font withContentStr:(NSString *)str;

/**
 *  计算文本高度(带行间距)
 *
 *  @param text 文本
 *  @param width 最大宽
 *  @param size 字体大小
 *  @param paragraphy 行间距
 *
 *  @return 返回高度
 */
+ (CGFloat)calculateParagraphFrameHeight:(NSString *)text width:(CGFloat)width fontsize:(CGFloat)size paragraphy:(CGFloat)paragraphy;

/**
 *  计算文本高度(不带行间距 目前行间距为6)
 *  @return 返回高度
 */
+ (CGFloat)calculateFrameHeight:(NSString *)text width:(CGFloat)width fontsize:(CGFloat)size;

/**
 *  计算文本宽度
 *  @return 返回宽度
 */
+ (CGFloat)calculateFrameWidth:(CGFloat)width text:(NSString *)text height:(CGFloat)height fontsize:(CGFloat)size;

/**
 *  @author PZ_Chen, 2016年07月06日17点07分
 *
 *  获得第一个字符
 *
 *  @return 返回第一个字符
 */
- (char)firstChar;

/**
 *  @author PZ_Chen, 2016年08月31日05点19分
 *
 *  去除前后字符串空格
 *
 *  @return 返回去除后的空格
 */
- (NSString *)deleteSpace;

//设置多种文字颜色
- (NSAttributedString *)setString:(NSString *)str withColorOneStr:(NSString *)oneStr andColorOne:(UIColor *)colorOne andColorTwoStr:(NSString *)twoStr andColorTwo:(UIColor *)colorTwo;
+ (NSString *)getLongTimeUrl:(NSString *)movieStr;
+ (NSString *)getLonglongTimeUrl:(NSString *)movieStr;
//douyin
- (CGSize)singleLineSizeWithAttributeText:(UIFont *)font;

- (CGSize)multiLineSizeWithAttributeText:(CGFloat)width font:(UIFont *)font;

- (CGSize)singleLineSizeWithText:(UIFont *)font;

- (NSString *)md5;

- (NSURL *)urlScheme:(NSString *)scheme;

+ (NSString *)formatCount:(NSInteger)count;

+(NSDictionary *)readJson2DicWithFileName:(NSString *)fileName;

+ (NSString *)currentTime;

/**
 *  获取当前的fromTarget
 *
 *  @return fromTarget
 */
+ (NSString *)currentFromTarget;

///判断是不是纯数字
+ (BOOL)inputShouldNumber:(NSString *)inputString;
///判断是否是整型
+ (BOOL)isPureInt:(NSString*)string;
///返回万分之
+ (NSString *)tenThousandTfromInt:(int)parameter;
+ (NSString *)tenThousandTfromFloat:(float)parameter;
///返回千分之
+ (NSString *)thousandTfromFloat:(float)parameter;
//去掉小数点之后的0
+ (NSString*)removeFloatAllZeroByString:(NSString *)testNumber;
@end
