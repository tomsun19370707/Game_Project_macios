//
//  SMDataTool.m
//  Orange
//
//  Created by dongdong on 2018/9/11.
//  Copyright © 2018年 dongdong. All rights reserved.
//

#import "SMDataTool.h"

@implementation SMDataTool

+ (SMDataTool *)defaultCenter
{
    static SMDataTool *dataTool = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        dataTool = [[SMDataTool alloc] init];
    });
    return dataTool;
}
//日期格式转字符串
- (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

//字符串转日期格式
- (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
//    date = [self worldTimeToChinaTime:date];
    return date;
}
//将String转为时间戳
-(NSString *)timeStamapFromUTCString:(NSString *)UTCString withDateFormat:(NSString *)format{
    
    //先将UTC字符串转为UTCDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    NSDate *UTCDate = [dateFormatter dateFromString:UTCString];
    
    NSString *timeStamap = [self timeStampFromUTCDate:UTCDate];
    return timeStamap;
}
//时间戳转时间字符串
- (NSString *)time_timestampToString:(NSInteger)timestamp withDateFormat:(NSString *)format{
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:format];
    
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    
    return string;
    
}
//将当前时间（NSDate）转为时间戳
-(NSString *)timeStampFromUTCDate:(NSDate *)UTCDate{
    
     NSTimeInterval timeInterval = [UTCDate timeIntervalSince1970];
     // *1000,是精确到毫秒；这里是精确到秒;
     NSString *result = [NSString stringWithFormat:@"%.0f",timeInterval];
     return result;

}
//将世界时间转化为中国区时间
- (NSDate *)worldTimeToChinaTime:(NSDate *)date
{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger interval = [timeZone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval:interval];
    return localeDate;
}
//得到data任意月前后的日期
-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];// NSGregorianCalendar
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
    
}
//得到data后一周的日期
-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withDay:(int)day
{
 
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setDay:day];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];// NSGregorianCalendar
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
}
//得到data后一年的日期
-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withYear:(int)year
{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setYear:year];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];// NSGregorianCalendar
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
}
//计算时间差
-(int)dateTimeDifferenceWithStartTime:(NSDate *)startD endTime:(NSDate *)endD{
    
//    NSDateFormatter *date = [[NSDateFormatter alloc]init];
//
//    [date setDateFormat:format];
//
//    NSDate *startD =[date dateFromString:startTime];
//
//    NSDate *endD = [date dateFromString:endTime];
    
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    
    NSTimeInterval value = end - start;
    
    int second = (int)value;//秒
    MYLog(@"second %d",second);
//    int minute = (int)value /60%60;
//
//    int house = (int)value / (24 *3600)%3600;
//
//    int day = (int)value / (24 *3600);
//
//    NSString *str;
//
//    if (day != 0) {
//
//        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];
//
//    }else if (day==0 && house !=0) {
//
//        str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];
//
//
//    }else if (day==0 && house==0 && minute!=0) {
//
//        str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];
//
//    }else{
//
    
//       NSString * str = [NSString stringWithFormat:@"%d",(int)value];
    
//    }
    
    return (int)second;
}
- (NSString *) getweekDayStringWithDate:(NSDate *) date

{
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; // 指定日历的算法
    
    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    
    // 1 是周日，2是周一 3.以此类推
    
    NSNumber * weekNumber = @([comps weekday]);
    
    NSInteger weekInt = [weekNumber integerValue];
    
    NSString *weekDayString = @"00";
    
    switch (weekInt) {
            
        case 1:
        {
            weekDayString = @"00";
        }
            break;
            
        case 2:
        {
            weekDayString = @"01";
        }
            
            break;
            
        case 3:
        {
            weekDayString = @"02";
        }
            break;
            
        case 4:
        {
            weekDayString = @"03";
        }
            break;
            
        case 5:
        {
            weekDayString = @"04";
        }
            break;
            
        case 6:
        {
            weekDayString = @"05";
        }
            break;
            
        case 7:
        {
            weekDayString = @"06";
        }
            break;
            
        default:
            
            break;
            
    }
    
    return weekDayString;
    
}

//model转化为字典
- (NSMutableDictionary *)dicFromObject:(NSObject *)object {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [object valueForKey:name];//valueForKey返回的数字和字符串都是对象
        
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            //string , bool, int ,NSinteger
            [dic setObject:value forKey:name];
            
        } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            //字典或字典
            [dic setObject:[self arrayOrDicWithObject:(NSArray*)value] forKey:name];
            
        } else if (value == nil) {
            //null
            //[dic setObject:[NSNull null] forKey:name];//这行可以注释掉?????
            
        } else {
            //model
            [dic setObject:[self dicFromObject:value] forKey:name];
        }
    }
    
    return dic;
}
//将可能存在model数组转化为普通数组
- (id)arrayOrDicWithObject:(id)origin {
    if ([origin isKindOfClass:[NSArray class]]) {
        //数组
        NSMutableArray *array = [NSMutableArray array];
        for (NSObject *object in origin) {
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [array addObject:object];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [array addObject:[self arrayOrDicWithObject:(NSArray *)object]];
                
            } else {
                //model
                [array addObject:[self dicFromObject:object]];
            }
        }
        
        return [array copy];
        
    } else if ([origin isKindOfClass:[NSDictionary class]]) {
        //字典
        NSDictionary *originDic = (NSDictionary *)origin;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSString *key in originDic.allKeys) {
            id object = [originDic objectForKey:key];
            
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [dic setObject:object forKey:key];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [dic setObject:[self arrayOrDicWithObject:object] forKey:key];
                
            } else {
                //model
                [dic setObject:[self dicFromObject:object] forKey:key];
            }
        }
        
        return [dic copy];
    }
    
    return [NSNull null];
}

- (BOOL)isBlankDictionary:(NSDictionary *)dic {
    
    if (!dic) {
        
        return YES;
        
    }
    
    if ([dic isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
    if (!dic.count) {
        
        return YES;
        
    }
    
    if (dic == nil) {
        
        return YES;
        
    }
    
    if (dic == NULL) {
        
        return YES;
        
    }
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        
        return YES;
        
    }
    
    return NO;
    
}
-(BOOL)isNineKeyBoard:(NSString *)string
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}
- (BOOL)hasEmoji:(NSString*)string
{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}
- (BOOL)stringContainsEmoji:(NSString *)string {
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}




//更改图片透明度
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font {
    
    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake(width, 2000);
    //1.2配置计算时的行截取方法,和contentLabel对应
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:10];
    //1.3配置计算时的字体的大小
    //1.4配置属性字典
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    //2.计算
    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    CGFloat height = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    
    return height;
    
}
- (NSString *)objArrayToJSON:(NSArray *)array {
    
    
    
    NSString *jsonStr = @"[";
    
    
    
    for (NSInteger i = 0; i < array.count; ++i) {
        
        if (i != 0) {
            
            jsonStr = [jsonStr stringByAppendingString:@","];
            
        }
        
        jsonStr = [jsonStr stringByAppendingString:array[i]];
        
    }
    
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    
    
    
    return jsonStr;
    
}
@end
