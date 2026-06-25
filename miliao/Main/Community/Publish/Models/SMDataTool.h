//
//  SMDataTool.h
//  Orange
//
//  Created by dongdong on 2018/9/11.
//  Copyright © 2018年 dongdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMDataTool : NSObject
+ (SMDataTool *)defaultCenter;
//日期格式转字符串
- (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format;
//字符串转日期格式
- (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format;
//得到data任意月份前后的日期
-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month;
-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withDay:(int)day;
-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withYear:(int)year;
//当前日期是周几
- (NSString *) getweekDayStringWithDate:(NSDate *) date;
//将String转为时间戳
-(NSString *)timeStamapFromUTCString:(NSString *)UTCString withDateFormat:(NSString *)format;
//时间戳转时间字符串
- (NSString *)time_timestampToString:(NSInteger)timestamp withDateFormat:(NSString *)format;

-(NSString *)timeStampFromUTCDate:(NSDate *)UTCDate;

//计算时间差 分
-(int)dateTimeDifferenceWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime;
//model转化为字典
- (NSDictionary *)dicFromObject:(NSObject *)object;
//判断字典是否有空值
- (BOOL)isBlankDictionary:(NSDictionary *)dic;
-(BOOL)isNineKeyBoard:(NSString *)string;
- (BOOL)hasEmoji:(NSString*)string;
- (BOOL)stringContainsEmoji:(NSString *)string;
//数组转json
- (NSString *)objArrayToJSON:(NSArray *)array;

//更改图片透明度
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image;
//根据字符串计算高度
- (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font;
@end
