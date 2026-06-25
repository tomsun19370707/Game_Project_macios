//
//  ObjectTool.h
//  GroupPurchaseProject
//
//  Created by 锤子科技 on 2017/6/22.
//  Copyright © 2017年 锤子科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
/** 页面PUSH*/
#define  Dn_NAVPUSH  [ObjectTool SharedSettings].currentVC.navigationController
#define  PUSH_NAVPUSH   Dn_NAVPUSH

@interface ObjectTool : NSObject
/* 设置项 */
+ (ObjectTool *)SharedSettings;
/** 当前正在显示的控制器*/
@property (nonatomic,strong) UIViewController *currentVC;
/** APP启动唤醒后，启动信息*/
@property (nonatomic,strong) NSDictionary *launchOptions;
/** 避免DYAlertView多次弹框问题*/
@property (nonatomic,assign) BOOL isAllowAlertShow;
/** iTunesConnectCheckState*/
@property (nonatomic,assign) BOOL Checking;
/** 1s内只允许发送一条消息*/
@property (nonatomic,assign) BOOL tempAllowSendMsg;


/*********************************环信相关设置************************************************************/
//记录当前发出的音视频消息的消息id
@property (nonatomic,copy) NSString *currentMessageId;
/** 当前聊天对象 */
@property (nonatomic,copy) NSString *currentChatUserId;
@property (nonatomic,strong) AgoraRtcEngineKit *agoraKit;
//当前进行的是音视频小屏幕 0否1是
@property (nonatomic,copy) NSString *smallView;
/** 是否在同步*/
@property (nonatomic,strong) NSString *isTongXunLu;
/** 群聊成员列表，用于在群聊里，比对备注和昵称
 {
easemobId = u19;
friendStatus = 1;
groupCode = 223293382656001;
groupId = 1;
id = 248;
isSilent = 0;
remark = "02\U5907\U6ce8";
role = 3;
userHeard = "http://bibimo.oss-ap-northeast-1.aliyuncs.com/202308181045179411.png";
userId = 19;
userName = Dylan2;
}
 */
/** 记录群主确认邀请， 点确认时候的  消息id， 确认后或者拒绝后，需要在本地删除此条消息*/
@property (nonatomic,strong) NSString *tempGroupOwnerComfireMsgId;
/** 是否是自己点击了挂断按钮，判断是对方拒绝，还是自己拒绝*/
@property (nonatomic,assign) BOOL isMySelfHungup;
/*********************************环信相关设置************************************************************/



/*********************************音视频电话提醒音设置begin************************************************************/
/** 在后台收到推送后，记录推送通知信息*/
@property (nonatomic,strong) NSDictionary *backgroundNotificationInfo;
/** 记录APP是否已经启动超过10s种了*/
@property (nonatomic,assign) BOOL appLanchReachTenSeconds;
/*********************************音视频电话提醒音设置end************************************************************/


/** 倒计时*/
/**
 time 正在进行的时间，每隔1s执行一次
 arrive  倒计时结束
 */
+ (void)countDownInterval:(int)interval time:(void(^)(NSString *time))time arrive:(void(^)(void))arrive;

/**
 *   间隔多长时间后执行方法
 *
 *  @param  delay      间隔时间
 *  @param  completion      结束回调
 */
+ (void)performSelectorAfterDelay:(double)delay completion:(void(^)(void))completion;

/** 计算缓存大小*/
+ (void)calculateCacheSizeWithCompletion:(void(^)(NSString *sizeContent))completion;

/** 清理缓存*/
+ (void)clearDiskCache:(void(^)(void))completion;

/** 按钮添加右上角角标数字(例如：购物车按钮右上角角标)*/
+ (void)cusView:(UIView *)view addTopBage:(int)bage bageLab:(void(^)(UILabel *num))bageLab ;

/** 设置消息未读角标数字*/
+ (void)messageBageVie:(UILabel *)bage bageNum:(int)bageNum;

/** 获取按照x坐标升序排列后的tabBarButtons*/
+ (void)tabBarButtonsAscSort:(UITabBarController *)tabVC finish:(void(^)(NSMutableArray *tabBarButtons))finish;

/** 获取APP当前名称和版本号*/
+ (NSString *)App_Name;
+ (NSString *)App_Version;

/** model转化为字典*/
+ (NSDictionary *)dicFromObject:(NSObject *)object ;

/** 获取文件地址*/
+ (NSDictionary *)dictionaryFromConfig:(NSString *)configFileName;

/** 系统提示弹框*/
+ (void)systemAlertTip:(NSString *)content;

/** 基础分享*/
+ (void)baseShareHandle;

/** 获取麦克风权限*/
- (void)fetchMicroPhoneStatus;

/** 群聊，判断消息是否超时未读*/
+ (BOOL)isGroupChatReadTimeout:(double)timestamp;

/** 视频格式转换*/
+ (NSURL *)_videoConvert2Mp4:(NSURL *)movUrl;

/** 获取音视频录制地址路径*/
+ (NSString *)getAudioOrVideoPath;
@end

