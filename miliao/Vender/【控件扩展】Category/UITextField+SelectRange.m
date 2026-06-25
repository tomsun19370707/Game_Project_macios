//
//  UITextField+SelectRange.m
//  zoneTry
//
//  Created by Sunny on 16/9/7.
//  Copyright © 2016年 ZoneTry. All rights reserved.
//

#import "UITextField+SelectRange.h"

@implementation UITextField (SelectRange)

- (NSRange) selectedRange {
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

@end
