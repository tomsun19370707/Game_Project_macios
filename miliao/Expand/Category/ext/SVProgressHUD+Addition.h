//
//  SVProgressHUD+Addition.h
//  FisheryFresh
//
//  Created by 李东阳 on 2020/7/13.
//  Copyright © 2020 云企科技. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^__nullable completeAction)(void);

@interface SVProgressHUD (Addition)

/*
 隐藏hud
 */
+ (void)hideLoadingHUD;
/*
 加载中+文字提示（文字可为空）
 */
+ (void)showLoadingHUDWithMessage:(nullable NSString *)message;
/*
 纯文字提示
 */
+ (void)showTextHUDWithMessage:(nonnull NSString *)message;
/*
 失败提示
 */
+ (void)showWarningHUDWithMessage:(nullable NSString *)message completion:(completeAction)completion;
/*
 完成提示
 */
+ (void)showCompletionHUDWithMessage:(nullable NSString *)message completion:(completeAction)completion;



@end

NS_ASSUME_NONNULL_END
