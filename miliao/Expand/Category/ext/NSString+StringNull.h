//
//  NSString+StringNull.h
//  templateDemo
//
//  Created by 李东阳 on 2019/1/18.
//  Copyright © 2019年 锤子科技. All rights reserved.
//

/** 文字*/
#define  STRING(A)  [NSString stringWithFormat:@"%@",A]
#define  FORMAT(content) [NSString stringWithFormat:@"%@", content]
#define  FORMAT_TYPE(type ,content) [NSString stringWithFormat:type, content]

#import <Foundation/Foundation.h>

@interface NSString (StringNull)
/** 判空处理*/
-(BOOL)isNull;
+ (CGFloat)heightForContent:(NSString *)content font:(UIFont *)font contentWidth:(CGFloat)width;
+ (CGFloat)widthForContent:(NSString *)content font:(UIFont *)font;
+ (CGFloat)heightwoForWordContent:(NSString *)content withFontSize:(UIFont *)font contentWidth:(CGFloat)width;
+ (CGFloat)widthwoForWordContent:(NSString *)content withFontSize:(UIFont *)font;

/** 手机号校验*/
+(BOOL)validatePhone:(NSString *)phone;

/** 邮箱 利用正则表达式验证*/
+(BOOL)isValidateEmail:(NSString *)email;

/**
 校验身份证号码是否正确 返回BOOL值

 @param idCardString 身份证号码
 @return 返回BOOL值 YES or NO
 */
+ (BOOL)validIDCardString:(NSString *)idCardString ;

/** 隐藏手机号中间四位*/
+ (NSString *)hidePhoneMiddleNum:(NSString *)dailPhone;

/** 手机号四位自动分隔 空格*/
+ (NSString *)whiteBlankPhoneNum:(NSString *)dailPhone;

/** 隐藏用户名中间部分*/
+ (NSString *)hideUserNameMiddlePart:(NSString *)name;

/** 身份证校验*/
+ (BOOL)IsIdentityCard:(NSString *)IDNumber;

/** 银行卡号校验，使用支付宝接口校验*/
+ (void)checkCardNum:(NSString *)cardNum resultDic:(void (^)(NSDictionary *resultDic))result;

/** 校验输入价格（大于0）*/
+(BOOL)validatePriceNum:(NSString *)price;

/** 根据生日返回年龄*/
+ (NSString *)ageFromBirthday:(NSString *)birthday;

/** 判断接口返回状态是否成功*/
- (BOOL)successApiStatus;

- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

+ (NSMutableAttributedString*)attrStrWith:(NSString*)str withFont:(CGFloat)strFont withFontRange:(NSRange)fontRange withColor:(UIColor*)strColor withColorRange:(NSRange)colorRange;

/** PGDatePicker  时间转换*/
+ (NSString *)PGDatePickerTimeConvert:(NSDateComponents *)dateComponents;

/** 改变部分字体大小颜色 */
+ (NSMutableAttributedString *)attributedString:(NSString *)string font:(UIFont *)font color:(UIColor *)color range:(NSRange)range;

/** 根据时间返回 多少时间之前*/
/**
     1小时内显示“X分钟前”，
     大于1小时小于24小时，显示“X小时前”；
     大于24小时小于48小时显示“1天前”；
     大于48小时小于72小时显示“2天前”；
     大于72小时小于96小时显示“3天前”；
     大于96小时显示具体日期“xx月xx日”，
     跨年的显示“xxxx年xx月xx日”
 */
+ (NSString*)changeTimeIntervalAfterTarget:(NSString *)changeTime;

/** 时间差转成 天 时分秒*/
+ (NSString *)convertTime:(NSUInteger)second;

/** 获取当前时间字符串*/
+ (NSString *)getCurrentTime;

/** 计算两个时间差，使用日历*/
+ (NSString *)timeIntervalFromDate:(NSDate *)from to:(NSDate *)to;

/** 包含负数的时间差,可用于比较时间的先后*/
+ (NSString *)timeIntervalWithZeroFromDate:(NSDate *)from to:(NSDate *)to;

/** 根据指定日期，返回月日*/
+ (NSString *)MonthAndDayForDate:(NSString *)dateStr;

/** 返回当前日期指定天数后的日期（可前可后）*/
/**
 *  ** 在当前日期时间加上 某个时间段(传负数即返回当前时间之前x月x日的时间)
 *  @param year   当前时间若干年后 （传负数为当前时间若干年前）
 *  @param month  当前时间若干月后  （传0即与当前时间一样）
 *  @param day    当前时间若干天后
 *  @param hour   当前时间若干小时后
 *  @param minute 当前时间若干分钟后
 *  @param second 当前时间若干秒后
 *  @return 处理后的时间字符串
 */
+ (NSString *)dateStringAfterDate:(NSString *)objDateStr  ForYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute Second:(NSInteger)second;

/** 获取某天是星期几  输入年月日*/
+ (NSString *)weekdayStringFromDateString:(NSString *)ymd;

/** 是否小数 */
-(BOOL)isPureFloatsCount:(NSInteger )count;

//判断是否为整形：
- (BOOL)isPureInts;

/** 获取最近七天时间 数组*/
+(NSMutableArray *)latelyOneWeekTime;

/** 得到当前时间相对1970时间的字符串，精度到毫秒，返回13位长度字符串*/
+ (NSString *)gs_getCurrentTimeStringToMilliSecond;

/** 获取视频文件的大小,单位KB。*/
+ (CGFloat)getFileSize:(NSString *)path;

/**
 判断用户输入的密码是否符合规范，符合规范的密码要求：
 1. 长度大于多少位
 2. 密码中必须同时包含数字和字母*/
+(BOOL)judgePassWordLegal:(NSString *)pass ;

/** 匹配 数字，字母或符号至少两种的至少8位字的符串*/
+ (BOOL)validateString:(NSString *)string;

//截取字符串方法封装
- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString;

/** 时间戳转日期*/
+(NSString *)timeWithTimeIntervalString:(double )time;

/** 根据经纬度计算距离*/
+(double)distanceBetweenOrderBy:(double) latitude1 :(double) latitude2 :(double) longitude1 :(double) longitude2 ;

/**
 *  判断URL
 */
+ (BOOL)checkURLStr:(NSString *)str;

/** 字符串判空*/
+ (BOOL)NotNull:(NSString *)string;

//是否是纯空格或者换行
-(BOOL)isAllEmptyString;

/** 获取两个字符串之间的字符*/
+ (NSMutableArray *)fetchListFrom:(NSString *)start end:(NSString *)end tarStr:(NSString *)tarStr;

/** 随机生成指定位数的字符串*/
+ (NSString *)randomString:(NSInteger)number;

@end



