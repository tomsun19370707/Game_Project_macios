//
//  AppDelegate.m
//  miliao
//
//  Created by aa on 2019/5/22.
//  Copyright © 2019 miliao. All rights reserved.


//com.JKProject.AirProject
//com.JKProject.emoApp  正式
#import <AliyunFaceAuthFacade/AliyunFaceAuthFacade.h>
#import "AppDelegate.h"
#import "GitfPostModel.h"
#import <WXApi.h>

#import "Global.h"
#import <UMPush/UMessage.h>
#import "RoomFloatingWindow.h"
#import "EMO_LoginViewController.h"
#import "WholeGiftView.h"
#import "WholeBoxView.h"
#import <UMCommonLog/UMCommonLogHeaders.h>
#import <UMCommon/UMCommon.h>
#import <UMAPM/UMCrashConfigure.h>
#import <UMAPM/UMLaunch.h>
//#import <UMAPM/UMAPMConfig.h>

#import "UITabBar+Badge.h"
//#import <Bugly/Bugly.h>
#import "MLNetWorkHelper.h"
#import "ZFLandscapeRotationManager.h"
#import "EMO_APPCustomMessage.h"
#import "EMO_APPCustomRoomMessage.h"

#import <CSVisitorSDK/CS53Manager.h>
#import "MX_AppLoadingScreenVC.h"

#import "JYYSPayManger.h"
#import "OpenUDID.h"

#define kDocument_Folder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
@interface AppDelegate ()
<RCIMUserInfoDataSource, RCIMConnectionStatusDelegate, AgoraRtcEngineDelegate,UNUserNotificationCenterDelegate,RCIMReceiveMessageDelegate,OpenInstallDelegate,WXApiDelegate>

@property (nonatomic, strong) AgoraRtcEngineKit                     *agoraKit;
//@property (nonatomic, strong) WholeGiftView *wholeGiftView;
@property (nonatomic, strong) DSAlert        *versionAlertView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [UIApplication sharedApplication].statusBarStyle            = UIStatusBarStyleDefault;
    [ScreenSize loadData];
    self.window  = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"first"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first"];
            NSLog(@"%i",[[NSUserDefaults standardUserDefaults] boolForKey:@"first"]);
        NSUserValueNameA(@(0), @"alertShowTime");
        NSUserValueNameA(@(2), @"alertShow");
        NSUserValueNameA(@(0), @"loginSelect");
    }
    
    NSUserValueNameA(@"", @"inviteCode");
    NSUserValueNameA(@(1), @"TiXian");//提现:1隐藏2开启
    
    [AliyunFaceAuthFacade initSDK];
    [self judgeVersion];
    [self LaunchJudge];
    //    [Bugly startWithAppId:@"a1439fbce1"];
    [self configUSharePlatforms:launchOptions];
    
    [OpenInstallSDK initWithDelegate:self];
    [[RCIM sharedRCIM] initWithAppKey:RONYUNAPPKey];
    [[RCIM sharedRCIM]registerMessageType:EMO_APPCustomMessage.class];//SDK初始化之后后注册消息类型
    [[RCIM sharedRCIM]registerMessageType:EMO_APPCustomRoomMessage.class];//SDK初始化之后后注册消息类型
    [RCIM sharedRCIM].connectionStatusDelegate = self;
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    RCKitConfigCenter.ui.globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
    RCKitConfigCenter.ui.globalMessageAvatarStyle =RC_USER_AVATAR_CYCLE;
    RCKitConfigCenter.message.showUnkownMessageNotificaiton=YES;
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    [RCIM sharedRCIM].userInfoDataSource = self;
    RCKitConfigCenter.ui.globalNavigationBarTintColor= mainViceColor;
    [RCIM sharedRCIM].receiveMessageDelegate = self;

    // 0.设置聊天页面(不设置将采用默认界面)
    [CS53Manager sharedManager].chatConfig = @{CSConfigKeyRightChatTextColor:@"EEE2F6"};
       
    // 1.初始化 appId: 按文档说明注册->获取注册生成的appId(必填)//
//    [[CS53Manager sharedManager] startWithAppId:@"" arg:@"10087813"]; //
    [[CS53Manager sharedManager] startWithAppId:@"z20rhp4d5f" arg:@"10719921"];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //注册推送，用于iOS8之前的系统
    }
#warning 百度Key
//    [[BaiduMobStat defaultStat] startWithAppId:@""];//百度统计Key
    [[RCCoreClient sharedCoreClient] recordLaunchOptionsEvent:launchOptions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectToRongCloud) name:kLoginSucessNotification object:nil];
    
    [[IAPManager shared] startManager];

    
    /** BUG IN CLIENT OF UIKIT: The caller of UIApplication.openURL(_:)
     解决微信未适配iOS18系统废弃 openURL 方法的问题
     */
    [AppDelegate hookOldOpenUrl:AppDelegate.class];
    
    return YES;
}

- (void)judgeVersion{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"appVersionKey"];
////         当前版本号
//        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];

        if ([UserManager userInfo].user_id) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSucessNotification object:nil];
        }else{
            
//            ZXTabBarController *zxTabBarController = [[ZXTabBarController alloc] init];
//            self.window.rootViewController = zxTabBarController;
//            return;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                EMO_LoginViewController *loginVC = [[EMO_LoginViewController alloc] init];
                ZXNavigationController *navVC = [[ZXNavigationController alloc] initWithRootViewController:loginVC];
                navVC.navigationBarHidden = YES;
                self.window.rootViewController = navVC;
                [self.window makeKeyAndVisible];
            });
        }
    });
}
- (void)LaunchJudge
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kIsOpenRoomGiftAnimation];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
}
// MARK: - 接收到消息的回调
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    PostNoticeObserver(@"UpDataMessage", nil);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if([message.objectName isEqualToString:@"RC:RoomMsg"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseRoomNotification" object:nil];
            [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"房间涉嫌违规,已被禁播!")];
        }
        
        if([message.objectName isEqualToString:@"RC:RoomOfflineMsg"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseRoomUserNotification" object:nil];
            [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"房间已关闭!")];
            return;
        }
        
        
    
        
//        if([message.senderUserId containsString:@"admin"]){
//            RCTextMessage *msg=(RCTextMessage *)message.content;
//            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[NSString stringWithFormat:@"%@",msg.content]];
//          [[RCIMClient sharedRCIMClient] deleteMessages: @[@(message.messageId)]];
//            [UserManager clearUserInfo];
//            EMO_LoginViewController *loginVC = [[EMO_LoginViewController alloc] init];
//            ZXNavigationController *navVC = [[ZXNavigationController alloc] initWithRootViewController:loginVC];
//            navVC.navigationBarHidden = YES;
//            self.window.rootViewController = navVC;
//            return;
//        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarAddBadge" object:nil];
  
    });
}

/*!
 当 Kit 收到消息回调的方法
 @param message 接收到的消息
 @return YES 拦截，不显示 ; NO: 不拦截, 显示此消息。
 */
//-(BOOL)interceptMessage:(RCMessage *)message{
//    if ([message.senderUserId isEqualToString:@"admin"]) {
//        return YES;
//    }
//    return NO;
//}

/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}
/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    [[RCCoreClient sharedCoreClient] setDeviceToken:token];
//    [[RCIMClient sharedRCIMClient] setDeviceToken:[self getHexStringForData:deviceToken]];
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"deviceToken:%@",hexToken);
    NSLog(@"deviceToken %@",token);
}
// Data 转换成 NSString（NSData ——> NSString）
- (NSString *)getHexStringForData:(NSData *)data {
    NSUInteger len = [data length];
    char *chars = (char *)[data bytes];
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for (NSUInteger i = 0; i < len; i ++) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    }
    return hexString;
}

- (void)configUSharePlatforms:(NSDictionary *)launchOptions
{
    //开发者需要显式的调用此函数，日志系统才能工作
    [UMCommonLogManager setUpUMCommonLogManager];
#warning 友盟Key
//    [UMConfigure initWithAppkey:UMENGAPPKey channel:@"rf0ylbmnttvagthtzu124a9ptmmcbdyv"];//正式
    [UMConfigure initWithAppkey:UMENGAPPKey channel:@""];
    // Push's basic setting
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert;
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            MYLog(@"entity = %@",entity);
        }else
        {
            MYLog(@"ssssss = %@",entity);
        }
        
    }];
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession | UMSocialPlatformType_WechatTimeLine appKey:WEIXINAPPKey appSecret:WEIXINAPPSecret redirectURL:@"https://uyu.jiangkukeji.cn/"];
    
    /*设置QQ平台的appID*/
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ | UMSocialPlatformType_Qzone appKey:QQID appSecret:QQKey redirectURL:@""];

    ////设置启动模块自定义函数开始
//    [UMLaunch beginLaunch:@"intUmeng"];
//    //初始化友盟SDK
//    UMAPMConfig* config = [UMAPMConfig defaultConfig];
//    config.crashAndBlockMonitorEnable = YES;
//    config.launchMonitorEnable = YES;
//    config.memMonitorEnable = YES;
//    config.oomMonitorEnable = YES;
//    config.networkEnable = YES;
//    [UMCrashConfigure setAPMConfig:config];
//    [UMConfigure initWithAppkey:UMENGAPPKey channel:@""];
//    //设置启动模块自定义函数开始
//    [UMLaunch endLaunch:@"intUmeng"];
//    NSLog(@"UMAPM version:%@",[UMCrashConfigure getVersion]);
//    //设置预定义DidFinishLaunchingEnd时间
//    [UMLaunch setPredefineLaunchType:UMPredefineLaunchType_DidFinishLaunchingEnd];
    
    
}

- (void)giftPostNotice:(GitfPostModel *)model
{
    WholeGiftView *wholeGiftView = [[WholeGiftView alloc] init];
    NSString *str = @"";
    str = NSStringFormat(@"惊现土豪~%@送给%@ X%@ %@~",model.user_name,model.from_name,model.num,model.gift_name);
    
    wholeGiftView.model = model;
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:13] hiegth:30];
    CGFloat width = size.width + 100;
    wholeGiftView.frame = CGRectMake(ScreenWidth, ScreenHeight/3 - 100, width, 90);
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:wholeGiftView];
    
    [UIView transitionWithView:wholeGiftView duration:2 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionTransitionFlipFromRight animations:^{
        wholeGiftView.frame = CGRectMake(0, ScreenHeight/3 - 100, width, 90);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(delayCode:) withObject:wholeGiftView afterDelay:1.0f];
    }];
}

- (void)delayCode:(WholeGiftView *)wholeGiftView{
    [UIView transitionWithView:wholeGiftView duration:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        wholeGiftView.frame = CGRectMake(-wholeGiftView.width - ScreenWidth, ScreenHeight/3 - 100, wholeGiftView.width, 90);
    } completion:^(BOOL finished) {
        [wholeGiftView removeFromSuperview];
    }];
    
}

- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object offline:(BOOL)offline hasPackage:(BOOL)hasPackage
{
   
}

- (void)boxPostNotice:(GitfPostModel *)model{
    WholeBoxView *wholeBoxView = [[WholeBoxView alloc] init];
    NSString *str = @"";
    str = NSStringFormat(@"哇哦~%@在普通蛋中开出%@",model.user_name,model.gift_name);
    
    wholeBoxView.model = model;
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:13] hiegth:30];
    CGFloat width = size.width + 100;
    wholeBoxView.frame = CGRectMake(ScreenWidth, ScreenHeight/3 - 50, width, 90);
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:wholeBoxView];
    
    
    [UIView transitionWithView:wholeBoxView duration:10 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionTransitionFlipFromRight animations:^{
        wholeBoxView.frame = CGRectMake(-wholeBoxView.width - ScreenWidth, ScreenHeight/3 - 50, width, 90);
    } completion:^(BOOL finished) {
        [wholeBoxView removeFromSuperview];
    }];
}

/// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    ZFInterfaceOrientationMask orientationMask = [ZFLandscapeRotationManager supportedInterfaceOrientationsForWindow:window];
    if (orientationMask != ZFInterfaceOrientationMaskUnknow) {
        return (UIInterfaceOrientationMask)orientationMask;
    }
    /// 这里是非播放器VC支持的方向
    return UIInterfaceOrientationMaskPortrait;
}


//通过OpenInstall获取已经安装App被拉起时的参数（如果是通过渠道页面拉起App时，会返回渠道编号）
-(void)getWakeUpParams:(OpeninstallData *)appData{
    if (appData.data) {//(获取自定义参数)
        //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
    }
    if (appData.channelCode) {//(获取渠道编号参数)
        //e.g.可自己统计渠道相关数据等
    }
    NSLog(@"OpenInstallSDK:\n动态参数：%@;\n渠道编号：%@",appData.data,appData.channelCode);
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{
    //处理通过openinstall一键拉起App时传递的数据
    [OpenInstallSDK continueUserActivity:userActivity];
    //其他第三方回调；
     [WXApi handleOpenUniversalLink:userActivity delegate:self];
     return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self UpdataVersion];

}
#pragma mark 版本更新
-(void)UpdataVersion{
    [NetworkRequest POST:Request_UpDataVersion parmeters:nil success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        NSDictionary *dic=basemodel.data[@"ios"];
        NSArray *localArray = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] componentsSeparatedByString:@"."];
        NSArray *versionArray = [dic[@"newversion"] componentsSeparatedByString:@"."];
        if ([localArray[0] intValue] < [versionArray[0] intValue]) {
            [self alert2:dic];
        }else if ([localArray[0] intValue] == [versionArray[0] intValue]){
            if ([localArray[1] intValue] < [versionArray[1] intValue]) {
                [self alert2:dic];
            }else if ([localArray[1] intValue] == [versionArray[1] intValue]){
                if (!(localArray.count<3||(versionArray.count<3))) {
                    if ([localArray[2] intValue] < [versionArray[2] intValue]) {
                        [self alert2:dic];
                    }
                }
            }
        }
        
    } failture:^(NSError *error) {
        
    }];
    
}

-(void)alert2:(NSDictionary *)dataDic{
    
//    [dataDic[@"enforce_switch"] integerValue]!=2?@[getLanguage(@"取消"), getLanguage(@"确定")]:@[getLanguage(@"确定")]
    
    _versionAlertView= [[DSAlert alloc] ds_showTitle:[NSString stringWithFormat:@"%@%@",getLanguage(@"发现新版本"),dataDic[@"newversion"]] message:[NSString stringWithFormat:@"%@",dataDic[@"content"]] image:nil buttonTitles:@[getLanguage(@"确定")] buttonTitlesColor:[dataDic[@"type"] integerValue]!=2?@[RGBA(51, 51, 51, 0.58), RGBA(51, 51, 51, 1)]:@[RGBA(51, 51, 51, 1)]];
    _versionAlertView.bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _versionAlertView.showAnimate = YES;
    [_versionAlertView ds_showAlertView];
    DSWeak;
    _versionAlertView.buttonActionBlock = ^(NSInteger index){
        if (index == 0){
//            if ([dataDic[@"enforce_switch"] integerValue]==0) {
//                [weakSelf.versionAlertView ds_dismissAlertView];
//            }else{
//        https://itunes.apple.com/cn/app/id1593993165
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"downloadurl"]]]];
//            }
            [_versionAlertView ds_dismissAlertView];
        }
        else if (index == 1){
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"downloadurl"]]]];
        }
    };
    
 

    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[IAPManager shared] stopManager];
}
//iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"userInfo %@",userInfo);
     if ([UserManager userInfo].user_id) {
         NSString *type = userInfo[@"data"][@"type"];
         if ([type isEqualToString:@"gift"]) {
             MYLog(@">>>>>>>>>>>>>>>>>%@",userInfo);
             GitfPostModel *model = [GitfPostModel mj_objectWithKeyValues:userInfo[@"data"][@"data"]];
             [self giftPostNotice:model];
         }else if ([type isEqualToString:@"award"]){
             
             GitfPostModel *model = [GitfPostModel mj_objectWithKeyValues:userInfo[@"data"][@"data"]];
             [self boxPostNotice:model];
         }
     }
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
//    //当应用处于前台时提示设置，需要哪个可以设置哪一个
//    completionHandler(UNNotificationPresentationOptionNone);
}
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0)){
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"userInfo %@",userInfo);
     if ([UserManager userInfo].user_id) {
         NSString *type = userInfo[@"data"][@"type"];
         if ([type isEqualToString:@"gift"]) {
             MYLog(@">>>>>>>>>>>>>>>>>%@",userInfo);
             GitfPostModel *model = [GitfPostModel mj_objectWithKeyValues:userInfo[@"data"][@"data"]];
             [self giftPostNotice:model];
         }else if ([type isEqualToString:@"award"]){
             
             GitfPostModel *model = [GitfPostModel mj_objectWithKeyValues:userInfo[@"data"][@"data"]];
             [self boxPostNotice:model];
         }
     }
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionNone);
}
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    
//    [OpenInstallSDK handLinkURL:url];
//    
//    if ([url.host isEqualToString:@"safepay"]) {
//           //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
//
//        }];
//           [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//               NSLog(@"result = %@",resultDic);
//           }];
//       }
//    return YES;
//}
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    
    //处理通过openinstall URL scheme拉起App的数据
    [OpenInstallSDK handLinkURL:url];
    
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            // 支付宝支付状态
            JYYSPayManger *manger = [JYYSPayManger sharedPayManger];
            manger.ALiPayPaymentCallback(resultDic);
        }];
        
        // 授权跳转支付宝登录，处理回调结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            // 支付宝授权状态
            JYYSPayManger *manger = [JYYSPayManger sharedPayManger];
            manger.ALiAuthCallback(resultDic);
        }];
        
        return YES;
    }else if ([url.absoluteString containsString:@"pay"] || [url.absoluteString containsString:@"resendContextReqByScheme"]) {
        /** [options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.xin"]
         */
        /** 微信退款 商家确认     字符：resendContextReqByScheme
         NSString *subheading = userInfo[@"subheading"];
         if ([NSString NotNull:subheading]) {
             WXOpenBusinessViewReq *req = [WXOpenBusinessViewReq object];
             req.businessType = @"requestMerchantTransfer";
             req.query = subheading;
//                req.query = @"mchId=1230000000&appId=wx8888888888888888&package=affffddafdfafddffda%3D%3D";
             [WXApi sendReq:req completion:^(BOOL success) {
                 
             }];
             DLog(@"%@",[WXApi getApiVersion]);
             DLog(@"version");
         }
         */
        
        /** 微信支付*/
        return [WXApi handleOpenURL:url delegate:[JYYSPayManger sharedPayManger]];
    }
    
    NSLog(@"%@",url.host);
        
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([NSStringFormat(@"%@", url) isEqualToString:@""]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[NSNotificationCenter defaultCenter] postNotificationName:kRealNameAuthentication object:nil];
        }
    }
    return result;
}

// MARK: - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion {
    MYLog(@"Rong cloud userID: %@", userId);
    
    if ([userId isEqualToString:@"admin_message"]) {
        RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId
                                                         name:getLanguage(@"官方消息")
                                                     portrait:[NSString stringWithFormat:@"%@/upload/uploads/20230104/9f37eb03e45dc00c00051a92eff34a1d.png",VERSION_HTTPS_SERVER]];
        completion(user);
    }
    
    
    if ([userId isEqualToString:[UserManager userInfo].rong_user_id]) {
        RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId
                                                         name:[UserManager userInfo].nickname
                                                     portrait:[UserManager userInfo].avatar];
        //缓存至用户信息
//        [kRongCloudManager insertWithUser:user];
        completion(user);
    } else {
        __block RCUserInfo *user;
        //根据userId去查找相对应的头像和昵称,缓存
        [NetworkRequest POST:Request_getOtherUserInfo parmeters:@{@"to_uid":userId} success:^(id responObject) {
            BaseModel *mode=(BaseModel *)responObject;
            NSDictionary *dic=mode.data[@"user_info"];
            user = [[RCUserInfo alloc] initWithUserId:userId
                                                name:dic[@"nickname"]
                                            portrait:dic[@"avatar"]];
            //缓存至用户信
            completion(user);
        } failture:^(NSError *error) {
            completion(user);
        }];
        
        

    }
}

// MARK: - 融云服务器连接状态监听
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    ///用户在其他设备登录/用户被封禁
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT ||
        status == ConnectionStatus_DISCONN_EXCEPTION) {
        //被踢下线
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"下线通知" message:@"您的账号在别的设备登录，您已被迫下线" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MX_AppLoadingScreenVC *loginVC = [[MX_AppLoadingScreenVC alloc] init];
                ZXNavigationController *navVC = [[ZXNavigationController alloc] initWithRootViewController:loginVC];
                navVC.navigationBarHidden = YES;
                self.window.rootViewController = navVC;
            });
            [self.agoraKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
            }];
            [[RCCoreClient sharedCoreClient] logout];
            [UserManager clearUserInfo];
            [MLRoomInformationManager clearUserInfo];
        }]];
        // 由于它是一个控制器 直接modal出来就好了
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }else if (status == ConnectionStatus_Connected) {
        MYLog(@"融云服务器连接成功!");
//        [SVProgressHUD dismiss];
    } else  {
        if (status == ConnectionStatus_DISCONN_EXCEPTION) {
            MYLog(@"融云服务器断开连接!");
        } else if (status == ConnectionStatus_Connecting) {
            MYLog(@"融云服务器正在连接");
        }else{
            MYLog(@"融云服务器连接失败!");
        }
    }
}

// MARK: - 连接融云服务器
- (void)connectToRongCloud {
    NSLog(@"ry_token---%@",[UserManager userInfo].rong_token);
    NSLog(@"ry_id---%@",[UserManager userInfo].rong_user_id);
    
    
    /** 登录成功后，保存设备 信息*/
    [self saveDeviceInfo];
    
//    ZXTabBarController *zxTabBarController = [[ZXTabBarController alloc] init];
//    self.window.rootViewController = zxTabBarController;
//
//    return;

    
    
    [[RCIM sharedRCIM] connectWithToken:[UserManager userInfo].rong_token dbOpened:^(RCDBErrorCode code) {

    } success:^(NSString *userId) {
        RCUserInfo *currentUserInfo = [[RCUserInfo alloc] initWithUserId:[UserManager userInfo].rong_user_id
                                                                            name:[UserManager userInfo].nickname
                                                                        portrait:[UserManager userInfo].avatar];
//        currentUserInfo.extra=[UserManager userInfo].sex;
        currentUserInfo.extra=[Common dictionaryToJson:@{@"sex":[Common isNullNumber:[UserManager userInfo].sex]}];
        [RCIM sharedRCIM].currentUserInfo = currentUserInfo;
        [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
//            TabBarController *mainVC = [[TabBarController alloc] init];
//            self.window.rootViewController = mainVC;
            if([[UserManager userInfo].is_disturb integerValue]==1){
                [[RCChannelClient sharedChannelManager] setNotificationQuietHoursLevel:@"00:00:00" spanMins:1439 level:RCPushNotificationQuietHoursLevelBlocked success:^() {} error:^(RCErrorCode status) {}];

            }else{
                [[RCChannelClient sharedChannelManager]setNotificationQuietHoursLevel:@"00:00:00" spanMins:1439 level:RCPushNotificationQuietHoursLevelDefault success:^{
                } error:^(RCErrorCode status) {
                }];
                
            }
            
            ZXTabBarController *zxTabBarController = [[ZXTabBarController alloc] init];
            self.window.rootViewController = zxTabBarController;
            
        });
    } error:^(RCConnectErrorCode errorCode) {
        if (errorCode == RC_CONN_ID_REJECT ||
            errorCode == RC_CONN_TOKEN_INCORRECT ||
            errorCode == RC_CONN_NOT_AUTHRORIZED ||
            errorCode == RC_CONN_PACKAGE_NAME_INVALID ||
            errorCode == RC_CONN_APP_BLOCKED_OR_DELETED ||
            errorCode == RC_CONN_USER_BLOCKED ||
            errorCode == RC_CLIENT_NOT_INIT ||
            errorCode == RC_INVALID_PARAMETER ||
            errorCode == RC_INVALID_ARGUMENT) {

            [UserManager clearUserInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                EMO_LoginViewController *loginVC = [[EMO_LoginViewController alloc] init];
                ZXNavigationController *navVC = [[ZXNavigationController alloc] initWithRootViewController:loginVC];
                navVC.navigationBarHidden = YES;
                self.window.rootViewController = navVC;
            });
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"登录失效，请重新登录"];
        }else{
            RCUserInfo *currentUserInfo = [[RCUserInfo alloc] initWithUserId:[UserManager userInfo].rong_user_id
                                                                        name:[UserManager userInfo].nickname
                                                                    portrait:[UserManager userInfo].avatar];
            [RCIM sharedRCIM].currentUserInfo = currentUserInfo;
            [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
//            [MobClick profileSignInWithPUID:[UserManager userInfo].ry_uid];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
//                TabBarController *mainVC = [[TabBarController alloc] init];
//                self.window.rootViewController = mainVC;
            });
        }
    }];
    
    ///***************************
    
//    [[RCIM sharedRCIM] connectWithToken:[UserManager userInfo].ry_token success:^(NSString *userId) {
//                                                               //设置当前用户信息
//        RCUserInfo *currentUserInfo = [[RCUserInfo alloc] initWithUserId:[UserManager userInfo].ry_uid
//                                                                            name:[UserManager userInfo].nickname
//                                                                        portrait:[UserManager userInfo].avatar];
//        [RCIM sharedRCIM].currentUserInfo = currentUserInfo;
//        [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
//        [MobClick profileSignInWithPUID:[UserManager userInfo].ry_uid];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//            TabBarController *mainVC = [[TabBarController alloc] init];
//            self.window.rootViewController = mainVC;
//        });
//    } error:^(RCConnectErrorCode status) {
////        RC_CONN_ID_REJECT, RC_CONN_TOKEN_INCORRECT, RC_CONN_NOT_AUTHRORIZED,
////        RC_CONN_PACKAGE_NAME_INVALID, RC_CONN_APP_BLOCKED_OR_DELETED,
////        RC_CONN_USER_BLOCKED,
////        RC_DISCONN_KICK, RC_CLIENT_NOT_INIT, RC_INVALID_PARAMETER, RC_INVALID_ARGUMENT
//        if (status == RC_CONN_ID_REJECT || status == RC_CONN_TOKEN_INCORRECT || status == RC_CONN_NOT_AUTHRORIZED || status == RC_CONN_PACKAGE_NAME_INVALID || status == RC_CONN_APP_BLOCKED_OR_DELETED || status == RC_CONN_USER_BLOCKED || status == RC_CLIENT_NOT_INIT || status == RC_INVALID_PARAMETER || status == RC_INVALID_ARGUMENT) {
//
//            [UserManager clearUserInfo];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                EMO_LoginViewController *loginVC = [[EMO_LoginViewController alloc] init];
//                ZXNavigationController *navVC = [[ZXNavigationController alloc] initWithRootViewController:loginVC];
//                navVC.navigationBarHidden = YES;
//                self.window.rootViewController = navVC;
//            });
//            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"登录失效，请重新登录"];
//
//        }else{
//            RCUserInfo *currentUserInfo = [[RCUserInfo alloc] initWithUserId:[UserManager userInfo].ry_uid
//                                                                        name:[UserManager userInfo].nickname
//                                                                    portrait:[UserManager userInfo].avatar];
//            [RCIM sharedRCIM].currentUserInfo = currentUserInfo;
//            [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
//            [MobClick profileSignInWithPUID:[UserManager userInfo].ry_uid];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//                TabBarController *mainVC = [[TabBarController alloc] init];
//                self.window.rootViewController = mainVC;
//            });
//        }
//    } tokenIncorrect:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//            TabBarController *mainVC = [[TabBarController alloc] init];
//            self.window.rootViewController = mainVC;
//        });
////        [UserManager clearUserInfo];
////        dispatch_async(dispatch_get_main_queue(), ^{
////             EMO_LoginViewController *loginVC = [[EMO_LoginViewController alloc] init];
////            ZXNavigationController *navVC = [[ZXNavigationController alloc] initWithRootViewController:loginVC];
////            navVC.navigationBarHidden = YES;
////            self.window.rootViewController = navVC;
////        });
////        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"登录失效，请重新登录"];
//    }];
}


/** BUG IN CLIENT OF UIKIT: The caller of UIApplication.openURL(_:)
 解决微信未适配iOS18系统废弃 openURL 方法的问题
 */

- (BOOL)g_openURL:(NSURL*)url
{
    [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];
    return YES;
}
+ (void)hookOldOpenUrl:(Class)targetCls
{
    Class cls = [UIApplication class];
    if (cls) {
        Method originalMethod =class_getInstanceMethod(cls, @selector(openURL:));
        Method swizzledMethod =class_getInstanceMethod(targetCls, @selector(g_openURL:));
        
        if (!originalMethod || !swizzledMethod) {
            return;
        }
        IMP originalIMP = method_getImplementation(originalMethod);
        IMP swizzledIMP = method_getImplementation(swizzledMethod);
        const char *originalType = method_getTypeEncoding(originalMethod);
        const char *swizzledType = method_getTypeEncoding(swizzledMethod);
        class_replaceMethod(cls,@selector(openURL:),swizzledIMP,swizzledType);
        class_replaceMethod(cls,@selector(g_openURL:),originalIMP,originalType);
    }
}

/** 登录成功后，保存设备 信息*/
- (void)saveDeviceInfo
{
    NSString* openUDID = [OpenUDID value];
    DLog(@"\ndevice UDID :%@",openUDID);
    /** para*/
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    parameter[@"device_id"] = openUDID;
    parameter[@"device_name"] = [DeviceOpinion deviceName];
    /** 设备类型 android ios*/
    parameter[@"device_type"] = @"ios";
    [NetworkRequest POST:user_saveLoginDevice parmeters:parameter success:^(id responObject) {
       
    } failture:^(NSError *error) {
        
    }];
}
@end


