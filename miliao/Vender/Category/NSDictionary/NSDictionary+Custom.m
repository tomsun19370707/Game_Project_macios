//
//  NSDictionary+Custom.m
//  FaceShow
//
//  Created by skyz on 2018/2/6.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import "NSDictionary+Custom.h"

@implementation NSDictionary (Custom)
#pragma mark -- 字典转json
- (NSData*)dictionaryToJson{
   NSError *parseError = nil;
   NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
  NSString * dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
   return [dataStr dataUsingEncoding:NSUTF8StringEncoding];
}
// 字典转json字符串方法

-(NSString *)convertToJsonData{
   NSError *error;

   NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];

   NSString *jsonString;

   if (!jsonData) {

      NSLog(@"%@",error);

   }else{

      jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

   }

   NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

   NSRange range = {0,jsonString.length};

   //去掉字符串中的空格

   [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

   NSRange range2 = {0,mutStr.length};

   //去掉字符串中的换行符

   [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

   return mutStr;

}
@end
