//
//  SVProgressHUD+Addition.m
//  FisheryFresh
//
//  Created by 李东阳 on 2020/7/13.
//  Copyright © 2020 云企科技. All rights reserved.
//

#import "SVProgressHUD+Addition.h"

@implementation SVProgressHUD (Addition)
+ (void)hideLoadingHUD
{
    [SVProgressHUD dismiss];
}

+ (void)showLoadingHUDWithMessage:(nullable NSString *)message
{
    /** 正在加载的不再提示*/
    if ([SVProgressHUD isVisible]) {
        return;
    }
    
    /** 刷新*/
    dispatch_async(dispatch_get_main_queue(), ^{
        // 如果当前视图还有其他提示框，就dismiss
        [self hideLoadingHUD];
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
        [SVProgressHUD setCornerRadius:5];
        [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
        
        // 加载中的提示框一般不要自动dismiss，比如在网络请求，要在网络请求成功后调用 hideLoadingHUD 方法即可
        if (message.length > 0) {
            [SVProgressHUD showWithStatus:message];
        }else{
            [SVProgressHUD show];
        }
    });
}

+ (void)showTextHUDWithMessage:(NSString *)message
{
    /** 刷新*/
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingHUD];
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
        [SVProgressHUD setCornerRadius:5];
        [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
        
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:message];
        
        [SVProgressHUD dismissWithDelay:ALERT_MESSAGE_DISPLAY_INTERVAL];
    });
    
}


+ (void)showCompletionHUDWithMessage:(NSString *)message completion:(completeAction)completion
{
    /** 刷新*/
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingHUD];
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
        [SVProgressHUD setCornerRadius:5];
        [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
        
        [SVProgressHUD showSuccessWithStatus:message];
        
        [SVProgressHUD dismissWithDelay:ALERT_MESSAGE_DISPLAY_INTERVAL];
        if (completion) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
    
}

+ (void)showWarningHUDWithMessage:(NSString *)message completion:(completeAction)completion
{
    /** 刷新*/
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingHUD];
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
        [SVProgressHUD setCornerRadius:5];
        [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
        
        [SVProgressHUD showErrorWithStatus:message];
        
        [SVProgressHUD dismissWithDelay:ALERT_MESSAGE_DISPLAY_INTERVAL];
        if (completion) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}
@end

