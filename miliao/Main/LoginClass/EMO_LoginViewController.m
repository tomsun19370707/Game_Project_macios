//
//  EMO_LoginViewController.m
//  miliao
//
//  Created by 张世浩 on 2022/10/8.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_LoginViewController.h"
#import "EMO_LoginView.h"
#import "EMO_CodeView.h"
#import "EMO_EditSettingVC.h"
#import <WXApi.h>
#import <AuthenticationServices/AuthenticationServices.h>
@interface EMO_LoginViewController ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@property(nonatomic,strong) EMO_LoginView * loginView;
@property(nonatomic,strong) EMO_CodeView * codeView;

@end

@implementation EMO_LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=HexColorDy(@"#F4FAFF");
    self.loginView=[[EMO_LoginView alloc] init];
    self.loginView.frame =CGRectMake(0, 0, kWidth, kHeight);
    [self.view addSubview:self.loginView];
    WeakSelf;
    self.loginView.BtnBlick = ^(NSInteger tag, NSInteger type, NSDictionary * _Nonnull dic) {
        [wself BtnClick:tag andType:type andDic:dic];
        
    };

    self.codeView=[[EMO_CodeView alloc] init];
    self.codeView.frame =CGRectMake(0, 0, kWidth, kHeight);
    [self.view addSubview:self.codeView];
    self.codeView.BtnBlick = ^(NSInteger tag, NSDictionary * _Nonnull dataDic) {
        if(tag==666){
            wself.codeView.hidden=YES;
        }else{
            [wself loginData:dataDic andType:4];
        }
        
    };
    self.codeView.hidden=YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatDidLoginNotification:) name:@"wechatDidLoginNotification" object:nil];
    
    
    [[OpenInstallSDK defaultManager] getInstallParmsCompleted:^(OpeninstallData*_Nullable appData) {
        //在主线程中回调
        if (appData.data) {//(获取自定义参数)
           //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
            NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:appData.data];
//            [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:dic[@"invite_code"]]];
            NSUserValueNameA([Common isNull:dic[@"invite_code"]], @"inviteCode");
        }
        if (appData.channelCode) {//(获取渠道编号参数)
            //e.g.可自己统计渠道相关数据等
        }
        NSLog(@"OpenInstallSDK:\n动态参数：%@;\n渠道编号：%@",appData.data,appData.channelCode);
//        [SVProgressHUD showImage:KGetImage(@"") status:[NSString stringWithFormat:@"OpenInstallSDK:\n动态参数：%@;\n渠道编号：%@",appData.data,appData.channelCode]];
    }];
    
    
}



-(void)BtnClick:(NSInteger)tag andType:(NSInteger)type andDic:(NSDictionary *)dic{
    WeakSelf;
    switch (tag) {
        case 100:{
            if(type==1){
                self.codeView.hidden=NO;
                self.codeView.phoneStr=dic[@"phone"];
                return;
            }
            [wself loginData:dic andType:type];
        }break;
        case 555:{
            NSLog(@"注册");
        }break;
        case 1001:{
            [wself QQLogin:1];//QQ
        }break;
        case 1002:{
            [wself QQLogin:2];//weixin
        }break;
        case 1003:{
            [wself handleAuthorizationAppleIDButtonPress];
          
        }break;
        default:
            break;
    }
    
    
    
    
}


-(void)loginData:(NSDictionary *)dic andType:(NSInteger)type{
    
    NSString *urlStr=[NSString string];
//    if(type==1){
//        urlStr=Request_SendSms;//获取验证码跳转
//    }else
        if(type==2){
        urlStr=Request_Login;//账号密码登录
    }else if(type==3){
        urlStr=Request_changePassword;//重置密码
    }else if(type==4){
        urlStr=Request_CodeLogin;//验证码登录
    }else if(type==5){
        urlStr=Request_Register;//注册
    }
    
//    WeakSelf;
    [SVProgressHUD show];
    [NetworkRequest POST:urlStr parmeters:dic success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD dismiss];
        if (baseModel.code == 1) {
            if(type==3){
                [self.loginView freshView:type];
            }else{
                UserDefaultsSave([Common isNull:baseModel.data[@"token"]], kToken);
                [UserManager saveUserInfo:baseModel.data];
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSucessNotification object:nil];
            }
           
        }else{
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[Common isNull:baseModel.msg]];
        }

    } failture:^(NSError *errors) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"网络连接失败")];
    }];

    
    
}





-(void)QQLogin:(NSInteger)type{
    WeakSelf;
    [SVProgressHUD show];
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:type==1?UMSocialPlatformType_QQ:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
           UMSocialUserInfoResponse *resp = result;
           // 第三方登录数据(为空表示平台未提供)
           // 授权数据
           NSLog(@" uid: %@", resp.uid);
           NSLog(@" openid: %@", resp.openid);
           NSLog(@" accessToken: %@", resp.accessToken);
           NSLog(@" refreshToken: %@", resp.refreshToken);
           NSLog(@" expiration: %@", resp.expiration);
           // 用户数据
           NSLog(@" name: %@", resp.name);
           NSLog(@" iconurl: %@", resp.iconurl);
           NSLog(@" gender: %@", resp.unionGender);
           // 第三方平台SDK原始数据
           NSLog(@" originalResponse: %@", resp.originalResponse);
        if (error==nil) {
            NSString *codeStr =NSUserTake(@"inviteCode");
            NSMutableDictionary *dicData=[NSMutableDictionary dictionary];
            if(codeStr.length>0){
                [dicData setObject:codeStr forKey:@"invite_code"];
            }
            if(type==2){
                [dicData addEntriesFromDictionary:@{@"wx_app_openid":resp.openid,@"unionid":resp.uid,@"nickname":resp.name,@"avatar":resp.iconurl}];
                [wself threeLogin:dicData andType:Request_ThreeLogin];
            }else{
                [dicData addEntriesFromDictionary:@{@"qq_app_openid":resp.openid,@"nickname":resp.name,@"avatar":resp.iconurl}];
                [wself threeLogin:dicData andType:Request_QQLogin];
            }
        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"授权失败")];
        }

       }];
    
}


-(void)threeLogin:(NSMutableDictionary *)msgDic andType:(NSString *)type{

    [NetworkRequest POST:type parmeters:msgDic success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD dismiss];
        
        if (baseModel.code == 1) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:baseModel.data];
            NSString *phone=[Common isNull:dic[@"mobile"]];
            UserDefaultsSave([Common isNull:dic[@"token"]], kToken);
            [UserManager saveUserInfo:dic];
            if(phone.length>0){
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSucessNotification object:nil];
            }else{
                EMO_EditSettingVC *vc=[EMO_EditSettingVC new];
                vc.index=6;//绑定手机号
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:baseModel.msg];
        }

    } failture:^(NSError *errors) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"网络连接失败")];
    }];
}



#pragma mark 微信通知
-(void)wechatDidLoginNotification:(NSNotification *)content{
    NSLog(@"%@",content.userInfo[@"code"]);
///sns/userinfo    获取用户个人信息
        NSString *UrlStr=[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WEIXINAPPKey,WEIXINAPPSecret,content.userInfo[@"code"]];
//        [SVProgressHUD show];
//        [[[ZWW_AFNetworking alloc] init] getWithUrl:UrlStr dict:nil succed:^(id  _Nullable responseObject) {
//            NSLog(@"%@",responseObject);
//
//
//            NSDictionary *dic=responseObject;
//            if ([dic.allKeys containsObject:@"errcode"]) {
//                [ToolsObject addPopVieToText:responseObject[@"errmsg"]];
//            }else{
//                [self ThreeLogin:responseObject[@"openid"] andAccess_token:responseObject[@"access_token"]];
//            }
//        } errorBlock:^(NSError * _Nullable error) {
//            NSLog(@"获取accessToken时出错 = %@", error);
//            [SVProgressHUD dismiss];
//            [ToolsObject addPopVieToText:getLanguage(@"授权失败")];
//        }];

}




// 处理授权
- (void)handleAuthorizationAppleIDButtonPress{
    NSLog(@"////////");
    
    if (@available(iOS 13.0, *)) {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        // 在用户授权期间请求的联系信息
        appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    }else{
        // 处理不支持系统版本
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"该系统版本暂不支持")];
    }
}

// 如果存在iCloud Keychain 凭证或者AppleID 凭证提示用户
- (void)perfomExistingAccountSetupFlows{
    NSLog(@"///已经认证过了/////");
    
    if (@available(iOS 13.0, *)) {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 授权请求AppleID
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        // 为了执行钥匙串凭证分享生成请求的一种机制
        ASAuthorizationPasswordProvider *passwordProvider = [[ASAuthorizationPasswordProvider alloc] init];
        ASAuthorizationPasswordRequest *passwordRequest = [passwordProvider createRequest];
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest, passwordRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    }else{
        // 处理不支持系统版本
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"该系统版本暂不支持")];
    }
}

#pragma mark - delegate
//@optional 授权成功地回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
    NSLog(@"授权完成:::%@", authorization.credential);
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", controller);
    NSLog(@"%@", authorization);
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
        NSString *user = appleIDCredential.user;
        // 使用过授权的，可能获取不到以下三个参数
        NSString *familyName = appleIDCredential.fullName.familyName;
        NSString *givenName = appleIDCredential.fullName.givenName;
        NSString *email = appleIDCredential.email;
        
        NSData *identityToken = appleIDCredential.identityToken;
        NSData *authorizationCode = appleIDCredential.authorizationCode;
        
        // 服务器验证需要使用的参数
        NSString *identityTokenStr = [[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding];
        NSString *authorizationCodeStr = [[NSString alloc] initWithData:authorizationCode encoding:NSUTF8StringEncoding];
        NSLog(@"%@\n\n%@", identityTokenStr, authorizationCodeStr);
        
        [SVProgressHUD showImage:KGetImage(@"") status:identityTokenStr];
//        [self QQorWechatLogin:identityTokenStr andType:AppleLogin];
        
        
        // Create an account in your system.
        // For the purpose of this demo app, store the userIdentifier in the keychain.
        //  需要使用钥匙串的方式保存用户的唯一信息
//        [YostarKeychain save:KEYCHAIN_IDENTIFIER(@"userIdentifier") data:user];
        
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        // 这个获取的是iCloud记录的账号密码，需要输入框支持iOS 12 记录账号密码的新特性，如果不支持，可以忽略
        // Sign in using an existing iCloud Keychain credential.
        // 用户登录使用现有的密码凭证
        ASPasswordCredential *passwordCredential = authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString *user = passwordCredential.user;
        // 密码凭证对象的密码
        NSString *password = passwordCredential.password;
        
    }else{
        NSLog(@"授权信息均不符");
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"授权失败")];

    }
}

// 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    // Handle error.
    NSLog(@"Handle error：%@", error);
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = getLanguage(@"用户取消了授权请求");
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = getLanguage(@"授权请求失败");
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = getLanguage(@"授权请求响应无效");
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = getLanguage(@"未能处理授权请求");
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = getLanguage(@"授权请求失败未知原因");
            break;
            
        default:
            break;
    }
    NSLog(@"%@", errorMsg);
    [SVProgressHUD showImage:KGetImage(@"") status:errorMsg];
    
}

// 告诉代理应该在哪个window 展示内容给用户
-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    // 返回window
    return [UIApplication sharedApplication].windows.lastObject;
}


@end
