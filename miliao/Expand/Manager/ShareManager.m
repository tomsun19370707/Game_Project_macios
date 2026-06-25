//
//  ShareManager.m
//  miliao
//
//  Created by jkkj on 2021/6/29.
//  Copyright © 2021 miliao. All rights reserved.
//

#import "ShareManager.h"

@implementation ShareManager
+ (instancetype)manager {
    static ShareManager *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [self new];
    });
    return manager;
}
///复制
- (void)shareCopyPaste:(NSString *)copyStr{
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = [Common isNull:copyStr];
    [SVProgressHUD showSuccessWithStatus:getLanguage(@"已复制到剪切板")];
}

@end
