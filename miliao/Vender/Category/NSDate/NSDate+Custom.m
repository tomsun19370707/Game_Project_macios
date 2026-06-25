//
//  NSDate+Custom.m
//  FaceShow
//
//  Created by skyz on 2018/4/21.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import "NSDate+Custom.h"

@implementation NSDate (Custom)
#pragma mark -- 日期转字符串
- (NSString *)dateToTimeStr:(NSString *)typeStr{
   NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

   [formatter setDateStyle:NSDateFormatterMediumStyle];

   [formatter setTimeStyle:NSDateFormatterShortStyle];

   [formatter setDateFormat:typeStr]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
//   NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
//
//   [formatter setTimeZone:timeZone];

//   NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
//
//   NSLog(@"1296035591  = %@",confromTimesp);
   NSString *confromTimespStr = [formatter stringFromDate:self];

   return confromTimespStr;
}
@end
