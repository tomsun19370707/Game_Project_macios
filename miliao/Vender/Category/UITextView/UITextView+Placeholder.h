//
//  UITextView+Placeholder.h
//  EventsForecast
//
//  Created by 科pro on 2018/1/15.
//  Copyright © 2018年 zhangShang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Placeholder)
/**
 textView placeholder text
 */
@property (nonatomic ,copy)NSString *placeholder;
/**
 textView placeholder textColor
 */
@property (nonatomic ,strong)NSDictionary *placeholderAttributes;
/**
 the max inputLenth
 */
@property (nonatomic ,assign)NSInteger maxInputLength;

@end
