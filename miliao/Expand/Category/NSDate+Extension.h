//
//  NSDate+HKExtension.h
//  百思不得姐--001
//
//  Created by Mask on 16/7/3.
//  Copyright © 2016年 Mask. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/** 求出时间差值 */
-(NSDateComponents *)dateFrom:(NSDate *)from;

/**
 *  是否为今年
 */
-(BOOL)isThisYear;
/**
 *  是否为今天
 */
-(BOOL)isToday;

/**
 *  是否为昨天
 */
-(BOOL)isYesterday;


@end
