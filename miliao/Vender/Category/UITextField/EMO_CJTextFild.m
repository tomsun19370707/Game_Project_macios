//
//  EMO_CJTextFild.m
//  miliao
//
//  Created by jkkj on 2023/11/10.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_CJTextFild.h"

@implementation EMO_CJTextFild
- (void)deleteBackward
{
    if ([self.text length] == 0) {
        if ([self.cj_delegate respondsToSelector:@selector(cjTextFieldDeleteBackward:)]) {
            [self.cj_delegate cjTextFieldDeleteBackward:self];
        }
    }
    [super deleteBackward];
}

- (BOOL)keyboardInputShouldDelete:(UITextField *)textField
{
    BOOL shouldDelete = YES;
  
    if ([UITextField instancesRespondToSelector:_cmd]) {
        BOOL (*keyboardInputShouldDelete)(id, SEL, UITextField *) = (BOOL (*)(id, SEL, UITextField *))[UITextField instanceMethodForSelector:_cmd];
      
        if (keyboardInputShouldDelete) {
            shouldDelete = keyboardInputShouldDelete(self, _cmd, textField);
        }
    }
  
    BOOL isIos8 = ([[[UIDevice currentDevice] systemVersion] intValue] == 8);
    BOOL isLessThanIos8_3 = ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.3f);
  
    if (![textField.text length] && isIos8 && isLessThanIos8_3) {
        [self deleteBackward];
    }
  
    return shouldDelete;
}

@end
