//
//  NSDate+HKExtension.m
//  百思不得姐--001
//
//  Created by Mask on 16/7/3.
//  Copyright © 2016年 Mask. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

-(NSDateComponents *)dateFrom:(NSDate *)from
{
    //拿到日历对象
    NSCalendar * calender = [NSCalendar currentCalendar];
    //比较时间
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return  [calender components:unit fromDate:from toDate:self options:kNilOptions];
}

-(BOOL)isThisYear
{
    //日历
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}


-(BOOL)isToday
{
    //日历
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents * nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents * selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year
    &&     nowCmps.month == selfCmps.month
    &&     nowCmps.day == selfCmps.day;
    
    //日期格式化类
//    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
//    fmt.dateFormat = @"yyyy-MM-dd";//2016-3-5  2016-3-5
//    
//    NSString * nowStr = [fmt stringFromDate:[NSDate date]];
//    NSString * selfStr = [fmt stringFromDate:self];
//    return [nowStr isEqualToString:selfStr];
}

-(BOOL)isYesterday
{
    /*  24小时  思路:  清零时间  再比较时间戳
     2016-1-1     00:00:00
     2015-12-31   00:00:00
     */
    //日期格式化类
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    //清空时间保留日期
    NSString * nowStr = [fmt stringFromDate:[NSDate date]];
    NSDate * nowDate = [fmt dateFromString:nowStr];
    
    NSString * selfStr = [fmt stringFromDate:self];
    NSDate * selfDate = [fmt dateFromString:selfStr];
    
    //日历类
    NSCalendar * calendar = [NSCalendar currentCalendar];
    //通过日历类比较日期
    NSDateComponents * cmps = [calendar components:NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.year == 0
    &&     cmps.month == 0
    &&     cmps.day == 1;
    
}




@end
