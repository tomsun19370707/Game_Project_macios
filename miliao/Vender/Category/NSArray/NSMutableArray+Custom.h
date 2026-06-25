//
//  NSMutableArray+Custom.h
//  FaceShow
//
//  Created by skyz on 2018/4/27.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Custom)
/**
 *  转换成JSON串字符串（有可读性）
 *
 *  @return JSON字符串
 */
- (NSString *)toReadableJSONString;
@end
