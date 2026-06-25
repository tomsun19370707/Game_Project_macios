//
//  CS53Manager.h
//  VisitorSDKDemo
//
//  Created by Albert on 2019/9/3.
//  Copyright © 2019年 Albert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 * 聊天界面配置Key
 *
 * 说明: 1.以下所有key设置值类型统一为: NSString
 *      2.color  统一设置值方式为: 16进制字符串   例: @"FFFFFF" , 代表 白色
 *      3.radius 统一设置值方式为: 像素值        例: @"8",     , 代表 8px
 *      4.text   统一设置值方式为: 字符串        例: @"xxxx"   , 代表 "xxxx"
 
 */
UIKIT_EXTERN NSString *const CSConfigKeyNavigationShow;                 // 聊天界面的导航栏, 0:show,1:hidden. default is @"0"
UIKIT_EXTERN NSString *const CSConfigKeyNavigationBackgroundColor;      // 导航栏背景色, default is @"218BFC"
UIKIT_EXTERN NSString *const CSConfigKeyLeftChatBubbleBackgroundColor;  // 左侧聊天气泡背景色, default is @"EFF3F6"
UIKIT_EXTERN NSString *const CSConfigKeyLeftChatTextColor;              // 左侧聊天文本颜色, default is @"28334B"
UIKIT_EXTERN NSString *const CSConfigKeyLeftChatBubbleRadius;           // 左侧聊天气泡圆角值, default is @"8"
UIKIT_EXTERN NSString *const CSConfigKeyRightChatBubbleBackgroundColor; // 右侧聊天气泡背景色, default is @"218BFC"
UIKIT_EXTERN NSString *const CSConfigKeyRightChatTextColor;             // 右侧聊天文本颜色, default is @"FFFFFF"
UIKIT_EXTERN NSString *const CSConfigKeyRightChatBubbleRadius;          // 右侧聊天气泡圆角值, default is @"8"
UIKIT_EXTERN NSString *const CSConfigKeySystemTipsBackgroundColor;      // 系统提示背景色, default is @"EFF3F6"
UIKIT_EXTERN NSString *const CSConfigKeySystemTipsTextColor;            // 系统提示文本颜色, default is @"62778C"
UIKIT_EXTERN NSString *const CSConfigKeyRefreshingHeaderText;           // 下拉动画时刷新头部提示文本, default is @"下拉刷新"
UIKIT_EXTERN NSString *const CSConfigKeyRefreshingHeaderColor;          // 下拉动画时刷新头部提示 文本+箭头 颜色, default is @"218BFC"
UIKIT_EXTERN NSString *const CSConfigKeyRefreshNoMoreDataHeaderText;    // 下来没有数据时头部提示文本, default is @"没有更多消息啦"
UIKIT_EXTERN NSString *const CSConfigKeyWelcomeText;                    // 新访客首次进聊天页面提示文本, default is @"欢迎您的咨询，期待为您服务！"


@class CSCustomInfoModel;

@protocol CS53ServiceDelegate <NSObject>

@required

/**
 * 服务文件加载成功。
 *
 * 说明: 需要在此方法调用之后(该代理调用之后都可以，不仅仅是写在代理里)，调用 "loadChatList"初始化聊天列表后，后续的相关数据回调 才能进行正常的进行
 */
- (void)didFinishLoad;

@optional

/**
 * 服务文件加载失败。
 *
 * 说明: 该方法基本不会被调用，如果出现 ，可尝试再次调用 "login53ServiceWithVisitorId:" 重试一次，如果该回调依然调用，则SDK服务不可正常使用
 */
- (void)didFailLoad;

/**
 * 分配访客ID
 *
 * 1.说明: 此方法会在初次获取分配访客回调。
 * 2.用法: 接收到此方法回调时安全起见可以与缓存比对是否相同，不同则按需求缓存到本地或同步到服务器，否则忽略。用法举例如下:
 
            a.你的app不需要登录，那么你可直接将接收到的访客ID缓存到本地,下次登录53服务，即调用 "login53ServiceWithVisitorId:" 的时候，就应该将缓存的访客ID传进去。
 *
 *          b.你的app需要登录账号，那么你应该将接收到的访客ID和当前的账号进行对应保存或者同时上传到服务器(方便其他设备登录依然可以拿到对应的值)，下次登录53服务，即调用 "login53ServiceWithVisitorId:" 的时候，拿到当前登录账号对应的访客ID传进去。
 */
- (void)didReadVisitorId:(NSString *)visitorId;

/**
 * 未读总数量变更回调
 *
 * 1.说明: 该访客未读总数量变更触发，会多次调用
 * 2.用法: 接收到时候需比对上次未读总数量，发现不同再去更新UI
 */
- (void)didReadUnreadTotalNum:(NSInteger)unreadTotalNum;


/**
 * 消息处理中心
 *
 * 回调dic参数说明如下:
 *   {
        msgList:[{
                  arg : "",               // 公司唯一标识
                  headUrl : "",           // 公司头像
                  companyName : "",       // 公司名称
                  unreadNum : "",         // 访客和该公司的未读消息数
                  msg : "",               // 最新一条消息内容
                  time : "",              // 最新一条消息时间【距1970年毫秒级时间戳】
                  sendState : "",         // 消息发送状态【0：失败，1：成功】
                  workerName : ""         // 客服昵称【客服说话有值，访客说话为空】
 *                sender : ""             // 发送者【1：访客，2：客服】
        },...],
     }
 * 1.说明: 收/发消息会经过此函数回调
 * 2.用法: a.对于多商家用户【类似淘宝，访客需要和多个商家进行聊天】,"msgList" 字段更新聊天列表.
 *        b.对于单商家用户按需调用。
 */
- (void)didReadData:(NSDictionary *)dic;

/**
 * 已读取一条会话回调
 *
 * 回调dic参数说明如下:
 *   {
 *     arg: ""        // 公司唯一标识
 *     unreadNum: ""  // 未读数量
 *   }
 *
 * 1.说明: 点击进去某个聊天界面，就会收到该会话条目的已读回调
 * 2.用法: a.多商家用户【类似淘宝，访客需要和多个商家进行聊天】，可根据 arg 对应的 unreadNum 修改对应聊天列表的未读数量。
 *        b.单商家可忽略此回调然后调用 -[CS53ServiceDelegate didReadUnreadTotalNum:] 总数量回调即可判断未读数量变化
 */
- (void)didReadOneConversation:(NSDictionary *)dic;

@end

@interface CS53Manager : NSObject

+ (instancetype)sharedManager;

/**
 * 加载服务以及后续处理数据的代理
 */
@property (nonatomic, weak) id <CS53ServiceDelegate> delegate;

/**
 * 聊天界面的配置(需要在startWithAppId:方法之前调用方可生效)
 *
 * 1.说明: 参考头部 聊天界面配置key
 * 2.用法: 想设置哪个配置，便设置对应key的值即可,不配置则采用默认值,设置举例:
 *        1.设置左侧聊天框文本颜色为0xEEE2F6 :
            @{CSConfigKeyLeftChatTextColor: @"EEE2F6"}
 
 *        2.分别设置左右聊天框文本颜色为0xEEE2F6,0xEFF4F6 :
            @{CSConfigKeyLeftChatTextColor :@"EEE2F6",
              CSConfigKeyRightChatTextColor:@"EFF4F6"}
 */
@property (nonatomic, copy) NSDictionary *chatConfig;

/**
 * 初始化SDK服务
 *
 * @param appId     注册APP时候生成的appId
 */
- (void)startWithAppId:(NSString *)appId arg:(NSString *)arg;


/**
 * 登录SDK服务
 *
 * @param visitorId 访客id，即访客的唯一标识
 *
 * 说明: 初次调用传空 --> SDK服务会默认分配访客id，构建通讯，并通过 -[CS53ServiceDelegate didReadVisitorId:] 代理回调将visitorId传给你，你按照该方法处的说明保存 --> 后续调用该登录方法应该传入对应的保存的访客id，以保证访客的唯一性。
 */
- (void)login53ServiceWithVisitorId:(NSString *)visitorId;


/**
 * 退出SDK服务
 *
 * @param block 内部BOOL类型参数代表着退出的成功与否
 *
 * 说明: 旨在对于有账号登录的app，在退出登录的时候调用此函数，53服务会标识此访客下线，停止消息推送。
        无账号登录的app想在某时刻停止推送可调用，否则忽略。
 */
- (void)quit53Service:(void(^)(BOOL))block;

/**
 * 注册推送的token
 *
 * 说明: 你的app如果需要远程推送功能，你应该将申请下来的deviceToken通过此方法传递给SDK服务。
 */
- (void)registerDeviceToken:(id)deviceToken;

/**
 * 获取本地聊天列表信息
 *
 *
 *  1.说明:
 *      a.对于多商家(访客和APP里多个商家沟通，类似淘宝)用户而言，APP一上来需要获取上次的聊天列表，以及总未读数量。
 *      b.对于单商家(访客只和固定一个公司沟通，类似app的一个客服咨询入口)用户而言，可用此获取总未读数量。
 *  2.用法:
 *      a.该函数调用后如下代理才会触发:
 *          -[CS53ServiceDelegate didReadData:] ,
 *          -[CS53ServiceDelegate didReadUnreadTotalNum:] ,
 *          -[CS53ServiceDelegate didReadOneConversation:]
 *
 *      b.该函数调用后，会获取本地聊天列表和总未读数量，分别在 -[CS53ServiceDelegate didReadData:]，-[CS53ServiceDelegate didReadUnreadTotalNum:]这两个代理中返回。
 */
- (void)loadChatList;

/**
 * 注册第三方会员信息
 *
 * 说明: 如果你的app需要对接第三方会员功能，可用此函数
 */
- (void)registerCustomInfo:(CSCustomInfoModel *)customInfoModel;

@end
