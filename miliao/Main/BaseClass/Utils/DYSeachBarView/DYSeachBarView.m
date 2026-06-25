//
//  DYSeachBarView.m
//  GroupPurchaseProject
//
//  Created by 李东阳 on 2018/7/9.
//  Copyright © 2018年 锤子科技. All rights reserved.
//

#import "DYSeachBarView.h"

@implementation DYSeachBarView
{
    UITextField *_tf;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(12, 0, 18, 18)];
        logo.image = IMAGE(@"DYSeachBarView_logo");
        [logo setCenterY:frame.size.height / 2];
        [self addSubview:logo];
        
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(logo.right + 5, 0, frame.size.width - logo.right - 5 - 10, frame.size.height)];
        tf.placeholder = @"请输入关键字搜索";
        tf.textColor = UIColor.blackColor ;
        tf.attributedPlaceholder = [NSString attributedString:tf.placeholder font:nil color:UIColorFromRGB(0x999999) range:NSMakeRange(0, tf.placeholder.length)];
        tf.font = PingFangFONT(13);
        tf.returnKeyType = UIReturnKeySearch ;
        tf.delegate = self ;
        tf.clearButtonMode = UITextFieldViewModeAlways ;
        [self addSubview:tf];
        _tf = tf ;
    }
    return self ;
}
#pragma mark - textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(seachBarViewShouldBeginEditing:)]) {
        return [self.delegate seachBarViewShouldBeginEditing:self];
    }
    return YES ;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.seachViewDidEndEditing) {
        self.seachViewDidEndEditing(textField.text);
    }
}

//setter
- (void)setText:(NSString *)text
{
    _tf.text = text ;
}
//getter
-(NSString *)text
{
    return _tf.text ;
}
- (void)setPlaceHoder:(NSString *)placeHoder
{
    _tf.attributedPlaceholder = [NSString attributedString:placeHoder font:nil color:UIColorFromRGB(0x999999) range:NSMakeRange(0, placeHoder.length)];
}
/** 第一响应者*/
- (void)resignFirstResponderHandle
{
    [_tf resignFirstResponder];
}
- (void)becomeFirstResponderHandle
{
    [_tf becomeFirstResponder];
}
@end

