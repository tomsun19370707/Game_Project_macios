//
//  NSDate+Custom.h
//  FaceShow
//
//  Created by skyz on 2018/4/21.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Custom)
/**日期转时间 转化的时间类型*/
- (NSString *)dateToTimeStr:(NSString *)typeStr;
@end
