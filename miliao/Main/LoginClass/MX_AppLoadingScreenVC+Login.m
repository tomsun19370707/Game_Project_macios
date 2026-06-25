//
//  MX_AppLoadingScreenVC+Login.m
//  MXProject
//
//  Created by jkkj on 2023/2/14.
//

#import "MX_AppLoadingScreenVC+Login.h"
#import <ATAuthSDK/ATAuthSDK.h>
#import <AuthenticationServices/AuthenticationServices.h>
#import "EMO_LoginViewController.h"
@implementation MX_AppLoadingScreenVC (Login)
#pragma mark -获取本机号码
- (void)getCurrentMobile{
    //1. 设置SDK参数，app⽣命周期内调⽤⼀次即可
    NSString *info = @"revIF/pfh8yQX05sC1FY3EqrmK/uSPybwNGunZdN1Q321DE5vypYnClDPJFXohCu6wWsJju+tRoR0O02pmAXCBnJyvv26IzJSjdKFLKM5fcAYTVhOb0Ffd0aE29q/Q0e0XYPevIXlbKorWfJR8L3RFxUW+bvCWH01o006XIsYljOiQUBug1lOrAdH6qaLFthD0w5+fYPXG0hyF4CwBGperho/CohJjDCHAM7g7Z7hVYLkAojvZfm26TX1KBsQlIxg6YFsPZBESI=";
    WeakSelf;
    //设置SDK参数，app⽣命周期内调⽤⼀次即可
    [[TXCommonHandler sharedInstance] setAuthSDKInfo:info complete:^(NSDictionary *     _Nonnull resultDic) {
        NSLog(@"设置SDK参数，app⽣命周期内调⽤⼀次即可 %@",resultDic);
    }];
    [self setInfor];
}

- (void)setInfor{
    CGFloat timeout=30.0;
    __weak typeof(self) weakSelf = self;
    //2. 检测当前环境是否⽀持⼀键登录，⽀不⽀持提前知道
    __block BOOL support = YES;
    [[TXCommonHandler sharedInstance] checkEnvAvailableWithAuthType:PNSAuthTypeLoginToken complete:^(NSDictionary * _Nullable resultDic) {
        support = [PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]];
    }];
    
    //3. 开始⼀键登录流程
    //3.1 调⽤加速授权⻚弹起接⼝，提前获取必要参数，为后⾯弹起授权⻚加速
    [[TXCommonHandler sharedInstance] accelerateLoginPageWithTimeout:timeout     complete:^(NSDictionary * _Nonnull resultDic) {
        if ([PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]] == NO)     {
            [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:resultDic[@"msg"]]];
            //无卡状态
            EMO_LoginViewController *rootVC = [[EMO_LoginViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
            [[Common AppWindow] setRootViewController:nav];
            return ;
        }
        TXCustomModel *model = [self createModelView];
        WeakSelf;
        [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:timeout controller:self model:model complete:^(NSDictionary * _Nonnull resultDic)     {
            NSString *code = [resultDic objectForKey:@"resultCode"];
            if ([PNSCodeLoginControllerPresentSuccess isEqualToString:code]) {
            } else if ([PNSCodeLoginControllerClickCancel isEqualToString:code]) {
            } else if ([PNSCodeLoginControllerClickChangeBtn isEqualToString:code]) {
                ///点击了其他手机号
                //                [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:NO complete:^{
                //
                //                }];
            } else if ([PNSCodeLoginControllerClickLoginBtn isEqualToString:code]) {
                if ([[resultDic objectForKey:@"isChecked"] boolValue] == YES) {
                    
                } else {
                    [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:@"请同意一键登录认证服务条款后重试"]];
                }
            } else if ([PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:code]) {
            } else if ([PNSCodeLoginControllerClickProtocol isEqualToString:code]) {
                
            } else if ([PNSCodeSuccess isEqualToString:code]) {
                //点击登录按钮获取登录Token成功回调
                [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:^{
                    NSString *token = [NSString stringWithFormat:@"%@",resultDic[@"token"]];
                    [self AutomaticPhont:[Common isNull:token]];
                }];
            } else {
                [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:@"获取登录Token失败"]];
               
                EMO_LoginViewController *rootVC = [[EMO_LoginViewController alloc] init];
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
                        [[Common AppWindow] setRootViewController:nav];
            }
        }];
    }];
}
- (TXCustomModel *)createModelView{
    ///设置界面布局和颜色
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.navIsHidden = YES;
    model.logoImage = [UIImage imageNamed:@"LoginIcon"];
    model.numberColor = UIColor.whiteColor;
    model.numberFont = KCFont(26);
    model.backgroundImage = KGetImage(@"MX_BackDefault");
    UIImage *selectionImg = [UIImage imageNamed:@"MX_LoginBtnBackImg"];
    model.loginBtnBgImgs = @[selectionImg,selectionImg,selectionImg];
    model.loginBtnText = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"222222"],NSFontAttributeName : [UIFont systemFontOfSize:15.0]}];
    model.changeBtnIsHidden = YES;
    model.navBackImage = [UIImage imageNamed:@"fanhui"];
    model.privacyAlignment = NSTextAlignmentCenter;
    model.checkBoxIsChecked = YES;
    model.privacyColors = @[[UIColor colorWithHexString:@"#666666"],[UIColor colorWithHexString:@"#FFEED3"]];
    //添加自定义控件并对自定义控件进行布局
    __block UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherBtn setTitle:@"其他方式登录" forState:UIControlStateNormal];
    [otherBtn setTitleColor:UIColor.whiteColor forState:0];
    otherBtn.titleLabel.font = KFont(15);
    otherBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    [otherBtn addTarget:self action:@selector(otherBtnClick) forControlEvents:UIControlEventTouchUpInside];
    otherBtn.frame = CGRectMake(112, 200, kScreenWidth - 224, 40);
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:otherBtn];
    };
    setViewCorner(otherBtn, 20);
    model.customViewLayoutBlock = ^(CGSize screenSize,CGRect contentViewFrame,CGRect navFrame,CGRect titleBarFrame,CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        CGRect frame = otherBtn.frame;
        frame.origin.x = (contentViewFrame.size.width - frame.size.width) * 0.5;
        frame.origin.y = CGRectGetMinY(privacyFrame) + frame.size.height;
        frame.size.width = contentViewFrame.size.width - frame.origin.x * 2;
        otherBtn.frame = frame;
    };
    //协议位置
    model.privacyFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(0, screenSize.height/2, superViewSize.width, 30);
    };
    return model;
}
//点击其他号码
- (void)otherBtnClick{
    EMO_LoginViewController *rootVC = [[EMO_LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    [[Common AppWindow] setRootViewController:nav];
}

//一键取号
- (void)AutomaticPhont:(NSString *)token{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[@"accessToken"] = token;
    dic[@"type"] = @"1";
    NSString *string =NSUserTake(@"inviteCode");
    if(string.length>0){
        dic[@"invite_code"] = string;
    }
    [SVProgressHUD show];
    [NetworkRequest POST:Request_CodeLogin parmeters:dic success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD dismiss];
        if (baseModel.code == 1) {
            UserDefaultsSave([Common isNull:baseModel.data[@"token"]], kToken);
            [UserManager saveUserInfo:baseModel.data];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSucessNotification object:nil];
        }else{
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[Common isNull:baseModel.msg]];
        }

    } failture:^(NSError *errors) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"网络连接失败")];
    }];
}
@end
