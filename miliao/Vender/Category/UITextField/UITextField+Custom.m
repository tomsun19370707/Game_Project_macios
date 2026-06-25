//
//  UITextField+Custom.m
//  FaceShow
///Users/wangzhen/Music/iTunes/iTunes Media/Mobile Applications/映客 5.2.15 2/Payload/inke.app/src/app/ui/giftPop/control.lua
//  Created by skyz on 2018/1/19.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import "UITextField+Custom.h"
@implementation UITextField (Custom)
- (void)setTextFieldWithPlaceHolder:(NSString *)placeHolder color:(UIColor *)placeHodlderColor textAligent:(NSTextAlignment)textAligent{
   NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
   self.textAlignment = textAligent;
   //self.textColor = KTitleColor;

   paragraphStyle.alignment = textAligent;
   self.attributedPlaceholder = [[NSAttributedString alloc]initWithString:placeHolder attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:placeHodlderColor,NSFontAttributeName:[UIFont systemFontOfSize:14]}];
}
- (void)setTextFieldWithPlaceHolderStr:(NSString *)placeHolder color:(UIColor *)placeHodlderColor{
   NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
  
   self.textColor = placeHodlderColor;

   self.attributedPlaceholder = [[NSAttributedString alloc]initWithString:placeHolder attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:placeHodlderColor}];

}
//#pragma mark -- 限制长度
//- (void)setTFMinLength:(NSInteger)minLength
//              minBlock:(void(^)(void))minBlock
//             maxLength:(NSInteger)maxLength
//             maxLength:(void(^)(void))maxBlock{
//
//
//}
@end
