//
//  UITextField+Custom.h
//  FaceShow
//
//  Created by skyz on 2018/1/19.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Custom)
/**包含占位符的位置*/
- (void)setTextFieldWithPlaceHolder:(NSString *)placeHolder color:(UIColor *)placeHodlderColor textAligent:(NSTextAlignment)textAligent;
/**不包含占位符的位置*/
- (void)setTextFieldWithPlaceHolderStr:(NSString *)placeHolder color:(UIColor *)placeHodlderColor;

///**限制长度*/
//- (void)setTFMinLength:(NSInteger)minLength
//              minBlock:(void(^)(void))minBlock
//             maxLength:(NSInteger)maxLength
//             maxLength:(void(^)(void))maxBlock;
@end
