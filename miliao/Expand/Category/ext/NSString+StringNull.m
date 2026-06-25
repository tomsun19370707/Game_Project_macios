//
//  NSString+StringNull.m
//  templateDemo
//
//  Created by 李东阳 on 2019/1/18.
//  Copyright © 2019年 锤子科技. All rights reserved.
//

#import "NSString+StringNull.h"

@implementation NSString (StringNull)
-(BOOL)isNull
{
    if (!self) {
        return YES;
    }else if ([self isEqualToString:@"(null)"]) {
        return YES;
    }else if ([self isEqualToString:@"null"]) {
        return YES;
    }else if ([self isEqualToString:@"<null>"]) {
        return YES;
    }else if ([self isEqual:[NSNull null]]) {
        return YES;
    }else if (self.length == 0) {
        return YES;
    }else if (self == nil) {
        return YES;
    }else if (self == NULL) {
        return YES;
    }
    return  NO ;
}
#pragma mark ------返回字体的高度
+ (CGFloat)heightForContent:(NSString *)content font:(UIFont *)font contentWidth:(CGFloat)width
{
    /** 计算内容大小*/
    NSDictionary *arrtribute = @{NSFontAttributeName:font};
    CGSize size = [content boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:arrtribute context:nil].size;
    return size.height;
}
#pragma mark ------返回字体的宽度
+ (CGFloat)widthForContent:(NSString *)content font:(UIFont *)font
{
    NSDictionary *arrtribute = @{NSFontAttributeName:font };
    CGSize size = [content boundingRectWithSize:CGSizeMake(100000, 15) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:arrtribute context:nil].size;
    return size.width;
}

+ (CGFloat)heightwoForWordContent:(NSString *)content withFontSize:(UIFont *)font contentWidth:(CGFloat)width
{
    NSDictionary *arrtribute = @{NSFontAttributeName:font};
    CGSize size = [content boundingRectWithSize:CGSizeMake(width, 50000000) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:arrtribute context:nil].size;
    return size.height;
}
+ (CGFloat)widthwoForWordContent:(NSString *)content withFontSize:(UIFont *)font
{
    NSDictionary *arrtribute = @{NSFontAttributeName:font};
    CGSize size = [content boundingRectWithSize:CGSizeMake(100000, 15) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:arrtribute context:nil].size;
    return size.width;
}
#pragma mark 检验是否是手机号
+(BOOL)validatePhone:(NSString *)phone
{
    //    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    //    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    //    return [phoneTest evaluateWithObject:phone];
    
    if (phone.length == 11) {
        NSString *firstL = [phone substringToIndex:1];
        if (firstL.intValue == 1) {
            return YES ;
        }
    }
    return NO ;
}
/** 邮箱 利用正则表达式验证*/
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 校验身份证号码是否正确 返回BOOL值

 @param idCardString 身份证号码
 @return 返回BOOL值 YES or NO
 */
+ (BOOL)validIDCardString:(NSString *)idCardString {
    NSString *regex = @"^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isRe = [predicate evaluateWithObject:idCardString];
    if (!isRe) {
         //身份证号码格式不对
        return NO;
    }
    //加权因子 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2
    NSArray *weightingArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //校验码 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2
    NSArray *verificationArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    NSInteger sum = 0;//保存前17位各自乖以加权因子后的总和
    for (int i = 0; i < weightingArray.count; i++) {//将前17位数字和加权因子相乘的结果相加
        NSString *subStr = [idCardString substringWithRange:NSMakeRange(i, 1)];
        sum += [subStr integerValue] * [weightingArray[i] integerValue];
    }
    
    NSInteger modNum = sum % 11;//总和除以11取余
    NSString *idCardMod = verificationArray[modNum]; //根据余数取出校验码
    NSString *idCardLast = [idCardString.uppercaseString substringFromIndex:17]; //获取身份证最后一位
    
    if (modNum == 2) {//等于2时 idCardMod为10  身份证最后一位用X表示10
        idCardMod = @"X";
    }
    if ([idCardLast isEqualToString:idCardMod]) { //身份证号码验证成功
        return YES;
    } else { //身份证号码验证失败
        return NO;
    }
}

/** 隐藏手机号中间四位*/
+ (NSString *)hidePhoneMiddleNum:(NSString *)dailPhone
{
    NSString *dail = @"";
    if ([NSString validatePhone:dailPhone]) {
        dail = [dailPhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    return dail;
}

/** 手机号四位自动分隔 空格*/
+ (NSString *)whiteBlankPhoneNum:(NSString *)dailPhone
{
    NSString *dail = @"";
    if ([NSString validatePhone:dailPhone]) {
        NSString *str1 = [dailPhone substringWithRange:NSMakeRange(0, 3)];
        NSString *str2 = [dailPhone substringWithRange:NSMakeRange(3, 4)];
        NSString *str3 = [dailPhone substringWithRange:NSMakeRange(7, 4)];
        dail = [NSString stringWithFormat:@"%@ %@ %@",str1,str2,str3];
    }
    return dail;
}

/** 隐藏用户名中间部分*/
+ (NSString *)hideUserNameMiddlePart:(NSString *)name
{
    if (!name || [name isNull]) {
        return @"" ;
    }
    if (name.length == 1) {
        return [NSString stringWithFormat:@"%@***",name];
    }
    return [NSString stringWithFormat:@"%@***%@",[name substringWithRange:NSMakeRange(0, 1)], [name substringFromIndex:name.length - 1]];
}

+ (BOOL)IsIdentityCard:(NSString *)IDNumber
{
    NSMutableArray *IDArray = [NSMutableArray array];
    // 遍历身份证字符串,存入数组中
    for (int i = 0; i < 18; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [IDNumber substringWithRange:range];
        [IDArray addObject:subString];
    }
    // 系数数组
    NSArray *coefficientArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    // 余数数组
    NSArray *remainderArray = [NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil];
    // 每一位身份证号码和对应系数相乘之后相加所得的和
    int sum = 0;
    for (int i = 0; i < 17; i++) {
        int coefficient = [coefficientArray[i] intValue];
        int ID = [IDArray[i] intValue];
        sum += coefficient * ID;
    }
    // 这个和除以11的余数对应的数
    NSString *str = remainderArray[(sum % 11)];
    // 身份证号码最后一位
    NSString *string = [IDNumber substringFromIndex:17];
    // 如果这个数字和身份证最后一位相同,则符合国家标准,返回YES
    if ([str isEqualToString:string]) {
        return YES;
    } else {
        return NO;
    }
}

/** 根据生日返回年龄*/
+ (NSString *)ageFromBirthday:(NSString *)birthday
{
    if (birthday.length < 10) {
        return nil ;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *now = [formatter stringFromDate:[NSDate date]];
    NSString *birD = [birthday substringToIndex:4];
    return [NSString stringWithFormat:@"%d",now.intValue - birD.intValue];
}

/** 判断接口返回状态是否成功*/
- (BOOL)successApiStatus
{
    if ([self isEqualToString:@"success"]) {
        return YES;
    }
    return NO ;
}

/** 根据指定日期，返回月日*/
+ (NSString *)MonthAndDayForDate:(NSString *)dateStr
{
    if (dateStr.length == 0 || !dateStr || [dateStr isNull]) {
        return @"" ;
    }
    NSString *str = [dateStr substringWithRange:NSMakeRange(5, 5)];
    NSArray *arr = [str componentsSeparatedByString:@"-"];
    if (arr.count == 2) {
        NSString *m = arr[0];
        NSString *d = arr[1];
        return [NSString stringWithFormat:@"%d月%d日", m.intValue,d.intValue];
    }
    return @"" ;
}
/** 银行卡号校验，使用支付宝接口校验*/
+ (void)checkCardNum:(NSString *)cardNum resultDic:(void (^)(NSDictionary *resultDic))result
{
    /**
     string url = "https://ccdcapi.alipay.com/validateAndCacheCardInfo.json?_input_charset=utf-8&cardNo=";
     url += bankCardNo;  //bankCardNo:银行卡号
     url += "&cardBinCheck=true"; //是否检查银行
     */
    NSString *urlString = [NSString stringWithFormat:@"https://ccdcapi.alipay.com/validateAndCacheCardInfo.json?_input_charset=utf-8&cardNo=%@&cardBinCheck=true",cardNum];
    NSURLSession *session = [NSURLSession sharedSession];
    //加载一个NSURL对象
    NSURLSessionTask *task = [session  dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        if (data) {
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            /**
             validated  是否可用   0否1是
             */
            if (result) {
                result(dict);
            }
        }
    }];
    [task resume];
}

//计算label文本的高度
- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        resultSize = [self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: font } context:nil].size;
    } else {
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        
        resultSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        
#endif
        
    }
    resultSize = CGSizeMake(MIN(size.width, ceilf(resultSize.width)), MIN(size.height, ceilf(resultSize.height)));
    
    return resultSize;
}
+ (NSMutableAttributedString*)attrStrWith:(NSString*)str withFont:(CGFloat)strFont withFontRange:(NSRange)fontRange withColor:(UIColor*)strColor withColorRange:(NSRange)colorRange{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    if (fontRange.length>0) {
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:strFont]
         
                              range:fontRange];
    }
    if (colorRange.length>0) {
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:strColor
         
                              range:colorRange];
    }
    
    return AttributedStr;
}
+(BOOL)validatePriceNum:(NSString *)price
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.\n"] invertedSet];
    NSString *filtered = [[price componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [price isEqualToString:filtered];
    if(!basicTest)
    {
        //输入了非法字符
        return NO;
    }
    //其他的类型不需要检测，直接写入
    return YES;
}

/** PGDatePicker  时间转换*/
+ (NSString *)PGDatePickerTimeConvert:(NSDateComponents *)dateComponents;
{
    /*
     Calendar Year: 2018
     Month: 7
     Leap month: no
     Day: 16
     Hour: 9
     Minute: 29
     Second: 14
     Weekday: 6
     */
    NSString *yearStr = [NSString stringWithFormat:@"%ld",(long)dateComponents.year];
    NSString *monthStr = @"" ;
    NSString *dayStr = @"" ;
    NSUInteger month = dateComponents.month;
    if (month < 10) {
        monthStr = [NSString stringWithFormat:@"0%ld",(long)dateComponents.month];
    }else{
        monthStr = [NSString stringWithFormat:@"%ld",(long)dateComponents.month];
    }
    
    NSUInteger day = dateComponents.day;
    if (day < 10) {
        dayStr = [NSString stringWithFormat:@"0%ld",(long)dateComponents.day];
    }else{
        dayStr = [NSString stringWithFormat:@"%ld",(long)dateComponents.day];
    }
    
    return [NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,dayStr];
}

/**
 改变部分字体大小颜色
 
 param NSMutableAttributedString NSMutableAttributedString
 return attribute
 */

+ (NSMutableAttributedString *)attributedString:(NSString *)string font:(UIFont *)font color:(UIColor *)color range:(NSRange)range {
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    
    if (font) {
        [attribute addAttribute:NSFontAttributeName value:font range:range];
    }
    
    if (color) {
        [attribute addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    
    return attribute;
}

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
+ (NSString*)changeTimeIntervalAfterTarget:(NSString *)changeTime
{
    NSString *nianStr = [changeTime substringToIndex:4];
    NSString *yueStr = [changeTime substringWithRange:NSMakeRange(5, 2)];
    NSString *riStr = [changeTime substringWithRange:NSMakeRange(8, 2)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:changeTime];//model.created_at 时间
    //八小时时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:timeDate];
    NSDate *mydate = [timeDate dateByAddingTimeInterval:interval];
    NSDate *nowDate = [[NSDate date]dateByAddingTimeInterval:interval];
    //两个时间间隔
    NSTimeInterval timeInterval = [mydate timeIntervalSinceDate:nowDate];
    timeInterval = -timeInterval;
    //    long temp = 0;
    //    NSString *time;
    
    int yue = timeInterval/(24*60*60*30);
    int day = timeInterval/(24*60*60);
    int huor = timeInterval/(60*60);
    int min = timeInterval/60;
    int sec = timeInterval;
    
    /** 跨年的显示“xxxx年xx月xx日  */
    if (![self isSameDay:timeDate date2:[NSDate date]]) {/** 不是同一年 */
        return [NSString stringWithFormat:@"%d年%d月%d日",nianStr.intValue,yueStr.intValue,riStr.intValue];
    } else {/** 是同一年 */
        if (huor > 0) {/** 超过1小时 */
            if (huor >= 1 && huor < 24) {
                return [NSString stringWithFormat:@"%d小时前",huor];
            }
            
            if (huor >= 24 && huor <= 96) {
                /** 大于24小时小于48小时显示“1天前” */
                if (huor >= 24 && huor < 48) {
                    return @"1天前";
                }
                /** 大于48小时小于72小时显示“2天前” */
                if (huor >= 48 && huor < 72) {
                    return @"2天前";
                }
                /** 大于72小时小于96小时显示“3天前” */
                if (huor >= 72 && huor <= 96) {
                    return @"3天前";
                }
            }
            
            /** 大于96小时显示具体日期“xx月xx日” */
            if (huor > 96) {
                return [NSString stringWithFormat:@"%d月%d日",yueStr.intValue,riStr.intValue];
            }
        } else {/** 1小时内 */
            if (huor < 1 && min < 1) {
                return [NSString stringWithFormat:@"%d秒前",sec];
            }
            /** 1小时内显示“X分钟前” */
            if (huor < 1) {
                return [NSString stringWithFormat:@"%d分钟前",min];
            }
        }
    }
    return @"";
}

/** 判断2个日期是否是同一年*/
+ (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2 {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    return (([comp1 year] == [comp2 year]));
}

/** 时间差转成 天 时分秒*/
+ (NSString *)convertTime:(NSUInteger)second{
    
    int seconds = second % 60;
    int minutes = (second / 60) % 60;
    int hours = (second / 3600) % 60;;
    int day = second / (3600 * 24) ;
    return [NSString stringWithFormat:@"%d天%02d:%02d:%02d",day,hours, minutes, seconds];
}

/** 获取当前时间字符串*/
+ (NSString *)getCurrentTime
{
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dataTime = [formater stringFromDate:[NSDate date]];
    
    return dataTime;
}

/** 计算两个时间差，使用日历*/
+ (NSString *)timeIntervalFromDate:(NSDate *)from to:(NSDate *)to
{
    /** 取绝对值*/
    NSCalendar *cal = [NSCalendar currentCalendar];
    //    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *d = [cal components:unitFlags fromDate:from toDate:to options:0];
    NSString *hour = [NSString stringWithFormat:@"%ld",(long)labs([d hour])];
    NSString *minute = [NSString stringWithFormat:@"%02ld",(long)labs([d minute])];
    NSString *second = [NSString stringWithFormat:@"%02ld",(long)labs([d second])];
    NSString *timeInterval = [NSString stringWithFormat:@"%@:%@:%@",hour,minute,second];
    return timeInterval ;
}

/** 包含负数的时间差,可用于比较时间的先后*/
+ (NSString *)timeIntervalWithZeroFromDate:(NSDate *)from to:(NSDate *)to
{
    /** 取绝对值*/
    NSCalendar *cal = [NSCalendar currentCalendar];
    //    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *d = [cal components:unitFlags fromDate:from toDate:to options:0];
    
    NSString *timeInterval = [NSString stringWithFormat:@"%ld:%02ld:%02ld",(long)[d hour],(long)[d minute],(long)[d second]];
    return timeInterval ;
}

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
+ (NSString *)dateStringAfterDate:(NSString *)objDateStr  ForYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute Second:(NSInteger)second
{
    NSDate *localDate = [NSDate date];
    if (objDateStr) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        localDate = [formatter dateFromString:objDateStr] ;
    }
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *minDate = [calender dateByAddingComponents:comps toDate:localDate options:0];
    
    NSDateComponents *components = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:minDate];
    NSString *DateTime = [NSString PGDatePickerTimeConvert:components];
    return DateTime;
}
/** 获取某天是星期几  输入年月日*/
+ (NSString *)weekdayStringFromDateString:(NSString *)ymd
{
    if (!ymd) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * inputDate = [formatter dateFromString:ymd] ;
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}
/** 是否小数 */
-(BOOL)isPureFloatsCount:(NSInteger )count{
//    if (count <= 0.0) {
//        return NO;
//    }
    NSString *phoneRegex = [NSString stringWithFormat:@"^[0-9]+(\\.[0-9]{0,%ld})?$",count];
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}
//判断是否为整形：
- (BOOL)isPureInts{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

/** 获取最近七天时间 数组*/
+(NSMutableArray *)latelyOneWeekTime{
    NSMutableArray *eightArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 7; i ++) {
        //从现在开始的24小时
//        NSTimeInterval secondsPerDay = -i * 24*60*60; //往前推7天
        NSTimeInterval secondsPerDay = i * 24*60*60; //往后推7天
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M-d"];//@"M月d日"
        NSString *dateStr = [dateFormatter stringFromDate:curDate];//几月几号
        
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
        [weekFormatter setDateFormat:@"EEEE"];//星期几 @"HH:mm 'on' EEEE MMMM d"];
        NSString *weekStr = [weekFormatter stringFromDate:curDate];
        
        //转换英文为中文
        NSString *chinaStr = [NSString cTransformFromE:weekStr];
        
        //组合时间
        NSString *strTime = [NSString stringWithFormat:@"%@,%@",dateStr,chinaStr];
        [eightArr addObject:strTime];
    }
    
    return eightArr;
}
//转换英文为中文
+(NSString *)cTransformFromE:(NSString *)theWeek{
    NSString *chinaStr;
    if(theWeek){
        if([theWeek isEqualToString:@"Monday"] || [theWeek isEqualToString:@"星期一"]){
            chinaStr = @"周一";
        }else if([theWeek isEqualToString:@"Tuesday"] || [theWeek isEqualToString:@"星期二"]){
            chinaStr = @"周二";
        }else if([theWeek isEqualToString:@"Wednesday"] || [theWeek isEqualToString:@"星期三"]){
            chinaStr = @"周三";
        }else if([theWeek isEqualToString:@"Thursday"] || [theWeek isEqualToString:@"星期四"]){
            chinaStr = @"周四";
        }else if([theWeek isEqualToString:@"Friday"] || [theWeek isEqualToString:@"星期五"]){
            chinaStr = @"周五";
        }else if([theWeek isEqualToString:@"Saturday"] || [theWeek isEqualToString:@"星期六"]){
            chinaStr = @"周六";
        }else if([theWeek isEqualToString:@"Sunday"] || [theWeek isEqualToString:@"星期日"]){
            chinaStr = @"周日";
        }else{
            chinaStr = theWeek;
        }
    }
    return chinaStr;
}
/** 得到当前时间相对1970时间的字符串，精度到毫秒，返回13位长度字符串*/
+ (NSString *)gs_getCurrentTimeStringToMilliSecond {
    double currentTime =  [[NSDate date] timeIntervalSince1970]*1000;
    NSString *strTime = [NSString stringWithFormat:@"%.0f",currentTime];
    return strTime;
}

/** 获取视频文件的大小,单位KB。*/
+ (CGFloat)getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = - 1.0;
    if ([fileManager fileExistsAtPath:path]) {
        //获取文件的属性
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0 * size / 1024 / 1024;
        
    }else{
        DLog(@"文件不存在");
    }
    return filesize;
}
/**
 判断用户输入的密码是否符合规范，符合规范的密码要求：
 1. 长度大于多少位
 2. 密码中必须同时包含数字和字母*/
+(BOOL)judgePassWordLegal:(NSString *)pass
{
    // 检查密码长度至少6位
    if (pass.length < 6) {
        return NO;
    }
    
    // 正则表达式：至少包含一个字母和一个数字
    NSString *pattern = @"^(?=.*[A-Za-z])(?=.*\\d).+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    
    return [predicate evaluateWithObject:pass];
}

/** 匹配 数字，字母或符号至少两种的至少8位字的符串*/
+ (BOOL)validateString:(NSString *)string
{
    // 检查字符串长度是否至少为 8 位
    if (string.length < 8) {
        return NO;
    }
    
    // 定义正则表达式来检查字母、数字、符号
    NSString *letterRegex = @"[a-zA-Z]";
    NSString *digitRegex = @"\\d";
    NSString *symbolRegex = @"[^a-zA-Z0-9]";
    
    NSRegularExpression *letterRegEx = [NSRegularExpression regularExpressionWithPattern:letterRegex options:NSRegularExpressionCaseInsensitive error:nil];
    NSRegularExpression *digitRegEx = [NSRegularExpression regularExpressionWithPattern:digitRegex options:0 error:nil];
    NSRegularExpression *symbolRegEx = [NSRegularExpression regularExpressionWithPattern:symbolRegex options:0 error:nil];
    
    // 检查是否匹配字母、数字、符号
    BOOL hasLetter = [letterRegEx numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)] > 0;
    BOOL hasDigit = [digitRegEx numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)] > 0;
    BOOL hasSymbol = [symbolRegEx numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)] > 0;
    
    // 检查是否由任意两组组合而成
    int matchCount = 0;
    if (hasLetter) {
        matchCount++;
    }
    if (hasDigit) {
        matchCount++;
    }
    if (hasSymbol) {
        matchCount++;
    }
    return matchCount >= 2;
}


/** 判断是否包含字母*/
- (BOOL)containsLetters
{
    // 创建正则表达式
    NSString *pattern = @"[a-zA-Z]";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"正则表达式创建失败: %@", error.localizedDescription);
        return NO;
    }
    // 查找匹配项
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return numberOfMatches > 0;
}

/** 判断是否包含数字*/
- (BOOL)containsNumbers
{
    // 创建正则表达式
    NSString *pattern = @"\\d";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"正则表达式创建失败: %@", error.localizedDescription);
        return NO;
    }
    // 查找匹配项
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return numberOfMatches > 0;
}

//截取字符串方法封装
- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString
{
    NSRange startRange = [self rangeOfString:startString];
    if (startRange.length > 0) {
        NSRange endRange = [self rangeOfString:endString];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        if (self.length > range.length) {
            return [self substringWithRange:range];
        }
    }
    return nil;
}

/** 时间戳转日期*/
+(NSString *)timeWithTimeIntervalString:(double )time
{
    if (time > 140000000000){
        time = time / 1000.0 ;
    }
    
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)time];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // [dateFormat setDateFormat:@"HH:mm:ss"];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:nd];
    return dateString;
}

/** 根据经纬度计算距离*/
+(double)distanceBetweenOrderBy:(double) latitude1 :(double) latitude2 :(double) longitude1 :(double) longitude2
{
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:latitude1 longitude:longitude1];
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:latitude2 longitude:longitude2];
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    return  distance;
}

/**
 *  判断URL
 */
+ (BOOL)checkURLStr:(NSString *)str {
    NSString *lowercaseStr = [str lowercaseString];
    NSString *regexURL = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",
                          @"^((https|http|ftp|rtsp|mms)?://)",
                          @"?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?",
                          @"(([0-9]{1,3}\\.){3}[0-9]{1,3}",
                          @"|",
                          @"([0-9a-z_!~*'()-]+\\.)*",
                          @"([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.",
                          @"[a-z]{2,6})",
                          @"(:[0-9]{1,4})?",
                          @"((/?)|",
                          @"(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexURL];
    
    return [predicate evaluateWithObject:lowercaseStr];
}

/** 字符串判空*/
+ (BOOL)NotNull:(NSString *)string
{
    if (!string) {
        return NO;
    }
    /** 先进行格式化*/
    NSString *fromat = FORMAT(string);
    if (!fromat || [fromat isNull]) {
        return NO;
    }
    return YES;
}

//是否是纯空格或者换行
-(BOOL)isAllEmptyString
{
    if(!self) {
        return YES;
    }else{
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet*set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString*trimedString = [self stringByTrimmingCharactersInSet:set];
        if([trimedString length] ==0) {
            return YES;
        }else{
            return NO;
        }
    }
}

/** 获取两个字符串之间的字符*/
+ (NSMutableArray *)fetchListFrom:(NSString *)start end:(NSString *)end tarStr:(NSString *)tarStr
{
    NSMutableArray *arr = [NSMutableArray array];

    while ([tarStr subStringFrom:start to:end]) {
        NSString *str = [tarStr subStringFrom:start to:end] ;
        [arr addObject:str];
        /** 移出指定片段*/
        NSString *temp = [NSString stringWithFormat:@"%@%@%@",start,str,end];
        tarStr = [tarStr stringByReplacingOccurrencesOfString:temp withString:@""];
    }
    
    return arr;
}

/** 随机生成指定位数的字符串*/
+ (NSString *)randomString:(NSInteger)number
{
    
    NSString *ramdom;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i ; i ++) {
        int a = (arc4random() % 122);
        if (a > 96) {
            char c = (char)a;
            [array addObject:[NSString stringWithFormat:@"%c",c]];
            if (array.count == number) {
                break;
            }
        } else continue;
    }
    ramdom = [array componentsJoinedByString:@""];
    return ramdom;
    
}
@end








