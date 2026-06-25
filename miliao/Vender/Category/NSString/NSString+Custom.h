//
//  NSString+Custom.h
//  FaceShow
//
//  Created by skyz on 2018/1/9.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Custom)

#pragma mark --获取普通文本的的原始宽高
- (CGSize)getSizeWithStrFloat:(float)strFont;
- (CGFloat)getHeightWithWidth:(CGFloat)width font:(CGFloat)font;
/**文字添加下划线*/
- (NSMutableAttributedString *)addBottomlineWithcolor:(UIColor *)color;
/**是否为空*/
- (BOOL)isEmpty;
/**字符串转json*/
- (NSDictionary *)dictionaryWithJsonString;
/**字符串转任意类型*/
- (id)toJson;
/**判断字符串是否是邮箱*/
- (BOOL)isValidateEmail;
/**是数字加字母*/
- (BOOL) isLetterAndNumber;
/**判断字符串是电话号码*/
- (BOOL)isPhoneNumber;
/**判断身份证是否合法*/
- (BOOL)judgeIdentityStringValid ;
/**时间转md5加密 不添加校验*/
- (NSString *)getMD5;
/**时间转md5加密 添加校验*/
- (NSString *)getMD5AddValidation;
/*
 含义：时间戳转时间
 @param typeStr 转化的时间类型

 */
- (NSString *)toTimeStr:(NSString *)typeStr;

/**时间戳转化为日期*/
- (NSDate *)toDateStr:(NSString *)typeStr;
/*
 含义：@好友转化
 @param successBlock 转化成功的操作
 @param NSString 返回转化后的字符串

 */
- (NSString *)transformFriendStrWithSuccessBlock:(void(^)(NSArray *userNameArr))successBlock;
//获取两个字符之间的字符串
- (NSString *)betweenToString:(NSString *)message beginStr:(NSString *)beginStr endStr:(NSString *)endStr;
/**时间转化*/
- (NSString *)timeBeforeInfoWithString:(NSTimeInterval)timeIntrval;

/**
 转化时间间隔

 @param timeIntrval timeStamp
 @return index:数字  des:描述
 */
- (NSDictionary *)timeStrBeforeInfoWithTimeStamp:(NSTimeInterval)timeIntrval;

/**人数转化为K W*/
- (NSString *)changeCount;
@end
