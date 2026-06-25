//
//  NSMutableArray+Custom.m
//  FaceShow
//
//  Created by skyz on 2018/4/27.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import "NSMutableArray+Custom.h"

@implementation NSMutableArray (Custom)
#pragma mark -- 数组转json
- (NSString *)toReadableJSONString {
   NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                  options:NSJSONWritingPrettyPrinted
                                                    error:nil];

   if (data == nil) {
      return nil;
   }

   NSString *string = [[NSString alloc] initWithData:data
                                            encoding:NSUTF8StringEncoding];
   return string;
}
@end
