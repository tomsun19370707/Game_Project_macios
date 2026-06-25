//
//  PublishControlView.m
//  miliao
//
//  Created by aa on 2019/7/12.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "PublishControlView.h"

@implementation PublishControlView


- (void)awakeFromNib{
    [super awakeFromNib];
//    self.userInteractionEnabled = NO;
    [self bringSubviewToFront:self.voiceBtn];
    
}

+(instancetype)controlView
{
    
    //XIB加载View
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}
- (IBAction)voiceBtnClick:(id)sender {
    // 开始文字输入
//    MYLog(@"");
//    if (self.status == statusVoice) {
//        MYLog(@"_delegate %@",_delegate);
//        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
//            [self.delegate chatBar:self changeStatusFrom:self.status to:statusKeyboard];
//        }
//        self.status = statusKeyboard;
//    } else { // 打开更多键盘
//        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
//            [self.delegate chatBar:self changeStatusFrom:self.status to:statusVoice];
//        }
//        self.status = statusVoice;
//    }
    
    if (_Viewdelegate &&[_Viewdelegate respondsToSelector:@selector(voiceBtnClick)]) {
        [self.Viewdelegate voiceBtnClick];
    }
}
- (IBAction)photoBtnClick:(id)sender {
    if (_Viewdelegate &&[_Viewdelegate respondsToSelector:@selector(picBtnClick)]) {
        [self.Viewdelegate picBtnClick];
    }
    
}


@end
