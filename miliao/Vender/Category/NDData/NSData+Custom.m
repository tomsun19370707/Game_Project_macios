//
//  NSData+Custom.m
//  FaceShow
//
//  Created by skyz on 2018/2/6.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import "NSData+Custom.h"

@implementation NSData (Custom)
#pragma mark -- 转data
- (NSDictionary *)dictionaryWithData{
//   NSString *result =[[ NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
   NSError * err;
   NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:self

                                                       options:NSJSONReadingMutableContainers

                                                         error:&err];
   if (err) {
   }else{
      //KMyLogStr(@"", @"字符串成功");
   }
   return dic;
   

}
@end
