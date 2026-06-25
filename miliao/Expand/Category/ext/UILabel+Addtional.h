//
//  UILabel+Addtional.h
//  JinYiYuShi
//
//  Created by 李东阳 on 2019/1/18.
//  Copyright © 2019年 锤子科技. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 使用此方法创建的 lable，都支持长按复制操作
 */
@interface UILabel (Addtional)
+ (UILabel *)LabelWithFrame:(CGRect)frame fontSize:(int)size textColor:(UIColor *)textColor  textAlient:(NSTextAlignment )alient  numberLines:(int)numLine;

/** 验证码倒计时*/
- (void)smsCodeCountingDownIntervall:(int)interval;

/**  设置lable宽度 高度*/
- (void)fetchLableWidth;
- (void)fetchLableHeight;
@end
