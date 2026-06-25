//
//  UITextField+SelectRange.h
//  zoneTry
//
//  Created by Sunny on 16/9/7.
//  Copyright © 2016年 ZoneTry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (SelectRange)

/**
 *  光标位置
 */
- (NSRange) selectedRange;
@end
