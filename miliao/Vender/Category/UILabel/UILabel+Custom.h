//
//  UILabel+Custom.h
//  FaceShow
//
//  Created by skyz on 2018/3/14.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Custom)
/**昵称跳转个人中心*/
- (void)pushToPersonVCWith:(NSString *)accountStr;
/**设置半角*/
- (void)setBorderWithCornerRadius:(CGFloat)cornerRadius
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(UIColor *)borderColor
                             type:(UIRectCorner)corners;
@end
