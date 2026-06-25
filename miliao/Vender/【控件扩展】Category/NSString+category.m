//
//  NSString+category.m
//  XiYuanPlus
//
//  Created by lijie lijie on 2018/4/10.
//  Copyright © 2018年 Hoping. All rights reserved.
//

#import "NSString+category.h"
#define DeviceSign           @"DeviceSign"
#import <CommonCrypto/CommonDigest.h>
#include <sys/param.h>
#include <sys/mount.h>
#import "sys/utsname.h"

@implementation NSString (category)

+ (BOOL)compareTowLocation:(CGFloat)longctionOne locationTwo:(CGFloat)locationTwo{
    NSNumber *aaa=[NSNumber numberWithFloat:longctionOne];
    NSNumber *aaa1=[NSNumber numberWithFloat:locationTwo];
    if ([aaa compare:aaa1]==NSOrderedSame)
    {
        MYLog(@"相等");
        return YES;
    }else{
        MYLog(@"不相等");
        return NO;
    }
}

///字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        return nil;
    }
    return dic;
}


///判断是不是纯数字
+ (BOOL)inputShouldNumber:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}


/**
 *  xigua
 *
 *  @param dic 数据字典
 *
 *  @return 返回json串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    if (!dic) {
        return NULL;
    }
    NSError *parseError = nil;
    if (![dic isKindOfClass:[NSNull class]]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        
    }
    return @"";
}


/**
 [""]    xigua
 [""]    @returns 获取当前时间
 [""] */
+(NSString *)getCurrentIntervalTime
{
    NSDate *date = [NSDate date];
    return [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]*1000];
}

/**
 *  xigua
 *
 *  @param second 秒
 *
 *  @return 分钟和秒
 */
+(NSString *)changeSecondToMinute:(NSString *)second{
    int min = [second intValue]/60;
    int ksecond = [second intValue] - min*60;
    return [NSString stringWithFormat:@"%d'%d''",min,ksecond];
}

/**
 [""]    xigua
 [""]    @returns 获取当前时间
 [""] */
+(NSString *)getCurrentTime:(NSString *)kTimeFormarter
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kTimeFormarter];//yyyy-MM-dd HH:mm:ss
    
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}


+(NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
}

/*
 获取当前时间戳
 */
+(NSString *)getCurrentTimeSp{
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    MYLog(@"date2时间戳 = %@",date2);
    return date2;
}
/**
 *  ybjia  根据时间戳，获取日期字符串，格式为：yyyy-MM-dd HH:mm:ss
 */
+(NSString *)getDateStringWithTimeInterval:(NSTimeInterval)timeInterval
{
    
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
    
}

/**
 时间戳转时间的方法:
 
 @param time 时间戳
 @return 时间
 */
+ (NSString *)dateStringChangeToTimestamp:(NSString *)time {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]/1000];
    NSString *day = [dateFormatter stringFromDate:theday];
    return day;
}
/**
 *  计算剩余时间
 *
 *  @param endTime   结束日期
 *
 *  @return 剩余时间
 */
+ (NSString *)getCountDownStringWithEndTime:(NSString *)endTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *now = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];//设置时区
    NSInteger interval = [zone secondsFromGMTForDate: now];
    NSDate *localDate = [now  dateByAddingTimeInterval: interval];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    NSInteger endInterval = [zone secondsFromGMTForDate: endDate];
    NSDate *end = [endDate dateByAddingTimeInterval: endInterval];
    NSUInteger voteCountTime = ([end timeIntervalSinceDate:localDate]) / 3600 / 24;
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld", voteCountTime];
    
    return timeStr;
}
/*
 作者：西瓜
 yyyy-MM-dd HH:mm:ss
 转化服务器时间
 */
+ (NSString *)getDate:(NSDate *)dateTime kTimeFormarter:(NSString *)kTimeFormarter{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kTimeFormarter];//yyyy-MM-dd HH:mm:ss
    NSString* str = [formatter stringFromDate:dateTime];
    return str;
}

/**
 秒转分
 
 @param time 时长-秒
 @return 时长-分
 */
+ (NSString *)stringWithTime:(NSInteger)time {
    int minute = (time ) / 60;
    int second = (int)(time ) % 60;
    
    return [NSString stringWithFormat:@"%02d'%02d\"", minute, second];
}

/**
 秒转分
 
 @param time 时长-秒
 @return 时长-分
 */
+ (NSString *)minuteAndSecStringWithTime:(NSInteger)time {
    int minute = (time ) / 60;
    int second = (int)(time ) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minute, second];
}

/**
 *  getDeviceUUID
 *
 *  @return 设备唯一标示
 */
+ (NSString *)getDeviceUUID {
    
    NSString *deviceStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    if (!deviceStr||[deviceStr isEqualToString:@""]) {
        
        return [self getOneUUID];
    } else {
        
        return deviceStr;
    }
}



/**
 xigua
 @param str 要md5的字符传
 @returns 返回加密后的串
 */
+ (NSString *)md5:(NSString *)str {
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/*
 作者：xigua
 获取uuid
 */
+ (NSString *)getOneUUID {
    
    CFUUIDRef   puuid      = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (__bridge_transfer NSString *)CFStringCreateCopy(NULL, uuidString);
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

/**
 设置用户登录信息
 */
+(BOOL)validateName:(NSString *)name{
    NSString *tempRegex= @"^([\u4e00-\u9fa5]){2,7}$";
    NSPredicate *tempTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",tempRegex];
    return [tempTest evaluateWithObject:name];
}
/*
 密码验证
 */
+(BOOL)validapwd:(NSString *)pwd{
    NSString *pwdRegex= @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *pwdTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",pwdRegex];
    return [pwdTest evaluateWithObject:pwd];
}

/*
 手机号验证
 */
+(BOOL)validaeMoblieNumber:(NSString *)phoneNumber{
    NSString *phoneRegex= @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9])|(19[0,0-9]))\\d{8}";
    NSPredicate *phoneTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}

/*
 电话号验证
 */
+(BOOL)validaePhoneNumber:(NSString *)phoneNumber{
    NSString *phoneRegex= @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *phoneTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}

/*
 邮箱验证
 */
+(BOOL)validaEmail:(NSString *)email
{
    NSString *emailRegex= @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*
 身份证后4位校验
 */
+(BOOL)validaID4:(NSString *)idStr
{
    NSString *idRegex= @"[0-9]{3}([0-9]|X|x)";
    NSPredicate *idTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",idRegex];
    return [idTest evaluateWithObject:idStr];
}

/*
 身份证号是否合法匹配
 */
+(BOOL)checkId:(NSString *)cid{
    NSDictionary *aCity=@{
                          @"11":@"北京",@"12":@"天津",@"13":@"河北",@"14":@"山西",@"15":@"内蒙古",
                          @"21":@"辽宁",@"22":@"吉林",@"23":@"黑龙江",@"31":@"上海",@"32":@"江苏",
                          @"33":@"浙江",@"34":@"安徽",@"35":@"福建",@"36":@"江西",@"37":@"山东",
                          @"41":@"河南",@"42":@"湖北",@"43":@"湖南",@"44":@"广东",@"45":@"广西",
                          @"46":@"海南",@"50":@"重庆",@"51":@"四川",@"52":@"贵州",@"53":@"云南",
                          @"54":@"西藏",@"61":@"陕西",@"62":@"甘肃",@"63":@"青海",@"64":@"宁夏",
                          @"65":@"新疆",@"71":@"台湾",@"81":@"香港",@"82":@"澳门",@"91":@"国外"};
    
    NSArray *arrExp = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6",
                        @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];//加权因子
    
    NSArray *arrValid = @[@"1",@"0",@"X", @"9", @"8", @"7", @"6", @"5",
                          @"4", @"3",@"2"];//校验码
    
    if(![self validateIdentityCard:cid]){
        return NO;
    }
    
    NSString *sId = [cid substringToIndex:2];
    NSArray *keys = aCity.allKeys;
    if (![keys containsObject:sId]) {
        return NO;
    }
    int iSum=0;
    int idx;
    for(int i = 0; i < cid.length - 1; i++){
        NSRange curRange = NSMakeRange(i, 1);
        //对前17位数字与权值乘积求和
        iSum += [[cid substringWithRange:curRange] intValue] * [[arrExp objectAtIndex:i] intValue];
    }
    
    idx = iSum % 11;
    if([[arrValid objectAtIndex:idx] isEqualToString:[[cid substringWithRange:NSMakeRange(17, 1)] uppercaseString]]){
        return YES;
    }else{
        return NO;
    }
}

/*
 身份证校验
 */
+(BOOL)validateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])(\\d{4}|\\d{3}(X|x))";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


+(NSString *)identifier
{
    NSString *strUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return strUUID;
}

//手机别名
+(NSString *)phoneName
{
    return [[UIDevice currentDevice] name];
}
//手机系统版本
/**
 *  手机系统版本
 *
 *  @return e.g. 8.0
 */
+(NSString *)phoneVersion{
    return [[UIDevice currentDevice] systemVersion];
}
//手机型号
//这个方法只能获取到iphone、iPad这种信息，无法获取到是iPhone 4、iphpone5这种具体的型号。

/**
 *  手机型号
 *
 *  @return e.g. iPhone
 */
+(NSString *)phoneModel{
    return [[UIDevice currentDevice] model];
}
//设备版本
//这个代码可以获取到具体的设备版本（已更新到iPhone 6s、iPhone 6s Plus），缺点是：采用的硬编码。具体的对应关系可以参考：https://www.theiphonewiki.com/wiki/Models

//这个方法可以通过AppStore的审核，放心用吧。

/**
 *  设备版本
 *
 *  @return e.g. iPhone 5S
 */
+(NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"] || [deviceString isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]
        ||[deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]
        ||[deviceString isEqualToString:@"iPad4,8"]
        ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceString;
}

+ (NSString *)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSString *language;
    if([currentLanguage rangeOfString:@"-"].location != NSNotFound)//_roaldSearchText
    {
        NSArray *strArr = [currentLanguage componentsSeparatedByString:@"-"];
        language = [NSString stringWithFormat:@"%@_%@",[strArr firstObject] ,[strArr lastObject]];
    }
    else
    {
        language = currentLanguage;
    }

    return language;
}

+(NSString *)sysname{
    return [UIDevice currentDevice].systemName;
}

/**
 *  字符串转MD5字符串
 *
 *  @param str 要转换的字符串
 *
 *  @return 转换后的字符串
 */
+ (NSString *)string2md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/**
 *  计算文字适配宽度或高度
 *
 *  @param heightMask 是否是高度适配
 *  @param flt        高度适配表示宽度 宽度适配表示高度
 *  @param font       当前字符串字体格式
 *
 *  @return 返回高度或者宽度
 */
- (float)stringWithHeightMask:(BOOL)heightMask withMask:(float)flt withFont:(UIFont *)font{
    //记录自适应后的高度
    float flt_Auto = .0f;
    //当前要适应的尺寸高度
    CGSize size_Content = CGSizeMake(heightMask?flt:MAXFLOAT, heightMask?MAXFLOAT:flt);
    //IOS7.0以上计算文字高度
    CGSize size = [self boundingRectWithSize:size_Content options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    //记录计算后的变化的尺寸
    flt_Auto = heightMask?size.height:size.width;
    return flt_Auto;
}

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
+ (float)stringWithHeightMask:(BOOL)heightMask withMask:(float)flt withFont:(UIFont *)font withContentStr:(NSString *)str{
    //记录自适应后的高度
    float flt_Auto = .0f;
    //当前要适应的尺寸高度
    CGSize size_Content = CGSizeMake(heightMask?flt:MAXFLOAT, heightMask?MAXFLOAT:flt);
    //IOS7.0以上计算文字高度
    CGSize size = [str boundingRectWithSize:size_Content options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    //记录计算后的变化的尺寸
    flt_Auto = heightMask?size.height:size.width;
    return flt_Auto;
}

+ (CGFloat)calculateParagraphFrameHeight:(NSString *)text width:(CGFloat)width fontsize:(CGFloat)size paragraphy:(CGFloat)paragraphy {
    
    //1.1最大允许绘制的文本范围
    CGSize size1 = CGSizeMake(width, MAXFLOAT);
    //1.2配置计算时的行截取方法,和contentLabel对应
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:paragraphy];
    //1.3配置计算时的字体的大小
    //1.4配置属性字典
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:size], NSParagraphStyleAttributeName:style};
    //2.计算
    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    CGFloat height = [text boundingRectWithSize:size1 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    return height;
//
//
//
//    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
//    [paragraphStyle setLineSpacing:paragraphy];
//    CGRect rect=[text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size],NSParagraphStyleAttributeName:paragraphStyle} context:nil];
//    return rect.size.height;
}

+ (CGFloat)calculateFrameHeight:(NSString *)text width:(CGFloat)width fontsize:(CGFloat)size{
    CGRect rect=[text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    return rect.size.height;
}

+ (CGFloat)calculateFrameWidth:(CGFloat)width text:(NSString *)text height:(CGFloat)height fontsize:(CGFloat)size {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:size]};
    CGSize labelsize = [text boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return labelsize.width;
}

/**
 *  @author PZ_Chen, 2016年07月06日17点07分
 *
 *  获得第一个字符
 *
 *  @return 返回第一个字符
 */
- (char)firstChar{
    if ([self length]) {
        NSString * str_Temp = self;
        str_Temp = [str_Temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSMutableString *ms = [NSMutableString stringWithString:str_Temp];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                return [[ms uppercaseString] characterAtIndex:0];
            }else{
                return [str_Temp characterAtIndex:0];
            }
        }else{
            return [str_Temp characterAtIndex:0];
        }
    }else{
        return 0;
    }
}

/**
 *  @author PZ_Chen, 2016年08月31日05点19分
 *
 *  去除前后字符串空格
 *
 *  @return 返回去除后的空格
 */
-(NSString *)deleteSpace{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSAttributedString *)setString:(NSString *)str withColorOneStr:(NSString *)oneStr andColorOne:(UIColor *)colorOne andColorTwoStr:(NSString *)twoStr andColorTwo:(UIColor *)colorTwo {
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:str];
    NSRange range1=[[hintString string]rangeOfString:oneStr];
    [hintString addAttribute:NSForegroundColorAttributeName value:colorOne range:range1];
    NSRange range2=[[hintString string]rangeOfString:twoStr];
    [hintString addAttribute:NSForegroundColorAttributeName value:colorTwo range:range2];
    return hintString;
}

+ (NSString *)getLongTimeUrl:(NSString *)movieStr{
    NSURL    *movieURL = [NSURL URLWithString:movieStr];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:movieURL options:opts];  // 初始化视频媒体文件
    int minute = 0, second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    //XYLog(@"movie duration : %d", second);
    if (second >= 60) {
        int index = second / 60;
        minute = index;
        second = second - index*60;
    }
    
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
}

+ (int)getLonglongTimeUrl:(NSString *)movieStr{
    NSURL *movieURL = [NSURL URLWithString:movieStr];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:movieURL options:opts];  // 初始化视频媒体文件
    int minute = 0, second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    if (second >= 60) {
        int index = second / 60;
        minute = index;
        second = second - index * 60;
    }
    return second;
}

//计算单行文本行高、支持包含emoji表情符的计算。开头空格、自定义插入的文本图片不纳入计算范围
- (CGSize)singleLineSizeWithAttributeText:(UIFont *)font {
    CTFontRef cfFont = CTFontCreateWithName((CFStringRef) font.fontName, font.pointSize, NULL);
    CGFloat leading = font.lineHeight - font.ascender + font.descender;
    CTParagraphStyleSetting paragraphSettings[1] = { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof (CGFloat), &leading };
    
    CTParagraphStyleRef  paragraphStyle = CTParagraphStyleCreate(paragraphSettings, 1);
    CFRange textRange = CFRangeMake(0, self.length);
    
    CFMutableAttributedStringRef string = CFAttributedStringCreateMutable(kCFAllocatorDefault, self.length);
    
    CFAttributedStringReplaceString(string, CFRangeMake(0, 0), (CFStringRef) self);
    
    CFAttributedStringSetAttribute(string, textRange, kCTFontAttributeName, cfFont);
    CFAttributedStringSetAttribute(string, textRange, kCTParagraphStyleAttributeName, paragraphStyle);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(string);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(DBL_MAX, DBL_MAX), nil);
    
    CFRelease(paragraphStyle);
    CFRelease(string);
    CFRelease(cfFont);
    CFRelease(framesetter);
    return size;
}

//固定宽度计算多行文本高度，支持包含emoji表情符的计算。开头空格、自定义插入的文本图片不纳入计算范围、
- (CGSize)multiLineSizeWithAttributeText:(CGFloat)width font:(UIFont *)font {
    CTFontRef cfFont = CTFontCreateWithName((CFStringRef) font.fontName, font.pointSize, NULL);
    CGFloat leading = font.lineHeight - font.ascender + font.descender;
    CTParagraphStyleSetting paragraphSettings[1] = { kCTParagraphStyleSpecifierLineBreakMode, sizeof (CGFloat), &leading };
    
    CTParagraphStyleRef  paragraphStyle = CTParagraphStyleCreate(paragraphSettings, 1);
    CFRange textRange = CFRangeMake(0, self.length);
    
    //  Create an empty mutable string big enough to hold our test
    CFMutableAttributedStringRef string = CFAttributedStringCreateMutable(kCFAllocatorDefault, self.length);
    
    //  Inject our text into it
    CFAttributedStringReplaceString(string, CFRangeMake(0, 0), (CFStringRef) self);
    
    //  Apply our font and line spacing attributes over the span
    CFAttributedStringSetAttribute(string, textRange, kCTFontAttributeName, cfFont);
    CFAttributedStringSetAttribute(string, textRange, kCTParagraphStyleAttributeName, paragraphStyle);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(string);
    
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(width, DBL_MAX), nil);
    
    CFRelease(paragraphStyle);
    CFRelease(string);
    CFRelease(cfFont);
    CFRelease(framesetter);
    
    return size;
}

//计算单行文本宽度和高度，返回值与UIFont.lineHeight一致，支持开头空格计算。包含emoji表情符的文本行高返回值有较大偏差。
- (CGSize)singleLineSizeWithText:(UIFont *)font{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}


- (NSString *) md5 {
    const char *str = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( str, (CC_LONG)strlen(str), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

- (NSURL *)urlScheme:(NSString *)scheme {
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:[NSURL URLWithString:self] resolvingAgainstBaseURL:NO];
    components.scheme = scheme;
    return [components URL];
}

+ (NSString *)formatCount:(NSInteger)count {
    if(count < 10000) {
        return [NSString stringWithFormat:@"%ld",(long)count];
    }else {
        return [NSString stringWithFormat:@"%.1fw",count/10000.0f];
    }
}

+(NSDictionary *)readJson2DicWithFileName:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return dic;
}


+ (NSString *)currentTime {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time * 1000];
    return timeString;
}

+ (NSMutableAttributedString *)mutableAttributedStringFromString:(NSString *)string withFont1:(UIFont *)font1 withFont2:(UIFont *)font2 {
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [string rangeOfString:@" ¥"];
    [mutableAttributedString addAttributes:@{NSFontAttributeName : font1 , NSForegroundColorAttributeName : COLOR_F42415} range:NSMakeRange(0, range.location)];
    [mutableAttributedString addAttributes:@{NSFontAttributeName : font2 , NSForegroundColorAttributeName : COLOR_999999 , NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(range.location+1, string.length-(range.location+1))];
    
    return mutableAttributedString;
}

+ (BOOL)isPureInt:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (NSString *)tenThousandTfromInt:(int)parameter {
    int value = parameter;
    if (value >= 10000.00) {
        double val = value / 10000.00;
        return [NSString stringWithFormat:@"%.1f万",val];
    } else {
        return [NSString stringWithFormat:@"%d",parameter];
    }
}

+ (NSString *)tenThousandTfromFloat:(float)parameter {
    float value = parameter;
    if (value >= 10000.00) {
        double val = value / 10000.00;
        return [NSString stringWithFormat:@"%.1f万",val];
    } else {
        return [NSString removeFloatAllZeroByString:[NSString stringWithFormat:@"%f",parameter]];
    }
}

///返回千分之
+ (NSString *)thousandTfromFloat:(float)parameter
{
    float value = parameter;
    if (value >= 1000.00) {
        double val = value / 1000.00;
        return [NSString stringWithFormat:@"%.1fk",val];
    } else {
        return [NSString removeFloatAllZeroByString:[NSString stringWithFormat:@"%f",parameter]];
    }
}

+ (NSString*)removeFloatAllZeroByString:(NSString *)testNumber {
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    return outNumber;
}

@end
