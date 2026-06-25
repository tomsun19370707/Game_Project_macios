//
//  DZCX_NetAPIPaths.h
//  ARINASI
//
//  Created by jkkj on 2022/6/9.
//  Copyright © 2022 ZSH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DZCX_NetAPIPaths : NSObject
#pragma mark - 公共
extern NSString *const Request_getQiNiuToken;//七牛token
extern NSString *const Request_AppUpload;//上传文件
extern NSString *const Request_AppText ;//获取APP内的协议
extern NSString *const Request_AppConfiguration;//获取app配置
extern NSString *const Request_AppUpVersion;//获取app版本
extern NSString *const Request_userInfo;//获取用户信息
extern NSString *const Request_GetReportReason;//获取举报原因
extern NSString *const Request_CheckMessage;//审核文本
extern NSString *const Request_UpDataVersion;//版本更新
extern NSString *const Request_replaceText;//脏字库

#pragma mark - 登陆注册
///短信验证码
extern NSString *const Request_ShenHe;//
extern NSString *const Request_SendSms;//获取验证码
extern NSString *const Request_CodeLogin;///验证码登录
extern NSString *const Request_Register;///注册
extern NSString *const Request_Login;///密码登录
extern NSString *const Request_changePassword;//忘记密码
extern NSString *const Request_settingPassword;//设置密码
extern NSString *const Request_changePsd;//修改密码
//绑定邮箱
extern NSString *const Request_BimgPhone;//绑定手机号
extern NSString *const Request_changePhone;//更换手机号
extern NSString *const Request_QQLogin;///qq登录
extern NSString *const Request_ThreeLogin;//weixin登录

extern NSString *const Request_cancellation;//注销账号


#pragma mark - 动态

extern NSString *const Request_GetDynamicTopic ;//获取话题列表
extern NSString *const Request_AddDynamic ;//发布动态
extern NSString *const Request_LikeOrFollow ;//点赞,取赞;关注,取关
extern NSString *const Request_AddComment;//发布评论
extern NSString *const Request_GetDynamicList;//动态列表
extern NSString *const Request_GetDynamicXQ ;//动态详情
extern NSString *const Request_DynamicCommnetList ;//评论列表
extern NSString *const Request_DelDynamic ;//删除动态
extern NSString *const Request_DelComment;//删除评论
extern NSString *const Request_EditDynamic;//编辑动态
extern NSString *const Request_GetReceivelike;//收到的喜欢




#pragma mark - 我的信息
extern NSString *const Request_AddReport;//提交举报
extern NSString *const Request_UserInfo;//会员中心,
extern NSString *const Request_ChangeUserInfo;//修改个人信息,
extern NSString *const Request_BindingInviteCode;//绑定邀请码
extern NSString *const Request_GetMyInvite;//邀请记录
extern NSString *const Request_SubmitFeedback;//提交反馈
extern NSString *const Request_GetMyCollectRoomList;//获取我收藏的房间
extern NSString *const Request_GetSkillList;//获取可添加的技能
extern NSString *const Request_GetMySkillList;//获取我的技能
extern NSString *const Request_GetMySkillInfo ;//获取我的技能详情
extern NSString *const Request_AddSkill;//添加技能
extern NSString *const Request_DelSkill;//删除技能
extern NSString *const Request_GetfollowOrBlack;//关注,取关;拉黑,取黑
extern NSString *const Request_GetMyFriendList;//我的关注粉丝
extern NSString *const Request_GetBlockList;//拉黑列表
extern NSString *const Request_userNameAuthentication;//提交,编辑实名认证
extern NSString *const Request_GetPeerageList;//爵位列表
extern NSString *const Request_RechangeList;//充值列表
extern NSString *const Request_RechangeOrder;//充值订单
extern NSString *const Request_ValidateApplePay;//验证苹果支付
extern NSString *const Request_GetMyMoney;//获取我的余额
extern NSString *const Request_SearchGiveUser;//搜索转增对象
extern NSString *const Request_GiveUser;//转增
extern NSString *const Request_MoneyRecordList;//金币余额记录
extern NSString *const Request_GetMyWithdrawal;//提现明细
extern NSString *const Request_getMyTransferLog;//转增记录
extern NSString *const Request_getMyDiamondLog;//钻石余额明细
extern NSString *const Request_ApplyWithdrawal;//申请提现
extern NSString *const Request_getSystemNotice;//获取系统通知
extern NSString *const Request_GetSystemNoticeInfo;//获取通知详情
extern NSString *const Request_getOtherUserInfo;//获取他人信息
extern NSString *const Request_GetOnline;//获取用户在线状态

extern NSString *const Request_TaskList;//任务列表
extern NSString *const Request_SigninList;//签到列表
extern NSString *const Request_signIn;//签到
extern NSString *const Request_CheckTask;//私信任务检测


extern NSString *const Request_MyFamily;//家族中心/我的家族/指定家族
extern NSString *const Request_FamilyUserList;//家族成员内列表
extern NSString *const Request_FamilyList;//搜索家族和家族列表
extern NSString *const Request_ApplyFamily;//申请入驻,申请退出
extern NSString *const Request_getfamilyApplyList;//入住列表/退出列表
extern NSString *const Request_OperateFamilyUserApply;//入住申请/退出申请
extern NSString *const Request_EditFamily;//修改房间信息
extern NSString *const Request_KickedFamily;//踢出成员
extern NSString *const Request_GetMyFamilyIncome;//获取家族流水列表/获取家族内单人流水

extern NSString *const Request_GetMyKnapsack;//我的背包
extern NSString *const Request_UseDress;//使用装扮
extern NSString *const Request_RemoveDress;//卸下装扮
extern NSString *const Request_PayDress;//购买装扮

#pragma mark 礼物

extern NSString *const Request_GetGiftList;//获取推荐礼物列表
extern NSString *const Request_GetBoxList;//获取宝箱列表
extern NSString *const Request_GetBoxInfo;//获取宝箱信息
extern NSString *const Request_GetDressList;//获取商城装扮
extern NSString *const Request_GetDrawList;//获取抽奖列表
extern NSString *const Request_GetDrawProbability;//获取抽奖奖品的概率
extern NSString *const Request_GetMyReceiveGift;//获取我收到的礼物

#pragma mark 房间

extern NSString *const Request_Get_rtc_token;//RTCtoken
extern NSString *const Request_Get_rtm_token;//RTMToken
extern NSString *const Request_GetRoomPartition;//获取房间分区
extern NSString *const Request_Lottery;//抽奖开箱
extern NSString *const Request_GetRoomList;//获取房间列表
extern NSString *const Request_EnterRoom;//进入房间
extern NSString *const Request_AddRoom;//创建房间
extern NSString *const Request_GetRoomInfo;//获取房间信息
extern NSString *const Request_GetRoomMicrophonePosition;//获取麦位列表
extern NSString *const Request_GetRoomImage;//房间背景列表
extern NSString *const Request_EditRoomInfo;//修改房间信息
extern NSString *const Request_CollectRoom;//收藏/取消收藏房间
extern NSString *const Request_InitFace;//发起认证
extern NSString *const Request_ApplyMicrophonePosition;//用户or房主上下麦
extern NSString *const Request_GetRoomUser;//获取/搜索房间内在线会员/房管/禁言/拉黑
extern NSString *const Request_SetRoomAdmin;//设置or取消管理员
extern NSString *const Request_GetApplyList;//获取麦位申请列表
extern NSString *const Request_SetRoomUser;//设置房间内会员---拉黑/取消拉黑---禁言/取消禁言
extern NSString *const Request_EmptyCharm;//清空房间魅力值/单人魅力值
extern NSString *const Request_CloseMicrophone;//全员闭麦/单人闭麦
extern NSString *const Request_OpenMicrophone;//全员开麦/单人开麦
extern NSString *const Request_SetMicrophoneCountdown;//设置麦位倒计时/取消倒计时
extern NSString *const Request_LockMicrophone;//锁麦/解除锁麦
extern NSString *const Request_GetRanking;//排行榜
extern NSString *const Request_AgreeMicrophoneApply;//抱人上麦/同意申请上麦
extern NSString *const Request_delMicrophoneApply;//拒绝申请上麦
extern NSString *const Request_UnderMicrophone;//主动下麦/抱人下麦
extern NSString *const Request_ExitAllMicrophone;//除房主外，全员下麦
extern NSString *const Request_GetRoomPriceLog;//打赏清单
extern NSString *const Request_GetMyRoomList;//获取我的房间/我管理的房间
extern NSString *const Request_Resignation;//辞职
extern NSString *const Request_GetOperateLog;//获取操作日志
extern NSString *const Request_Quit_hand;//退出房间
extern NSString *const Request_KickOutRoom;//踢出房间
extern NSString *const Request_SendGift;//送礼物
extern NSString *const Request_SendBackPackGift;//宋背包
extern NSString *const Request_GetDrawListRecord;//中奖记录

#pragma mark 首页

extern NSString *const Request_GetRandRoom;//根据分区获取随机房间id
extern NSString *const Request_GetHomeRoll;//首页头条
extern NSString *const Request_GetBanner;//获取轮播
extern NSString *const Request_HomeSearch;//首页搜索



#pragma mark 签到
/** 判断今日是否可签到 */
#define   user_check_today  [NSString stringWithFormat:@"%@api/emo/user/check_today",VERSION_HTTPS_SERVER]



#pragma mark 我的钱包
/** 获取用户钱包金币，钻石，紫金等余额 */
#define   user_getMoney  [NSString stringWithFormat:@"%@api/emo/user/getMoney",VERSION_HTTPS_SERVER]
/** 紫金明细 */
#define   user_lotteryCoinLogList  [NSString stringWithFormat:@"%@api/emo/user/lotteryCoinLogList",VERSION_HTTPS_SERVER]
/** 黑曜石明细 */
#define   user_ratioCoinLogList  [NSString stringWithFormat:@"%@api/emo/user/ratioCoinLogList",VERSION_HTTPS_SERVER]
/** 元宝明细 */
#define   user_userPrizeCoinList  [NSString stringWithFormat:@"%@api/emo/user/userPrizeCoinList",VERSION_HTTPS_SERVER]
/** 金币明细 */
#define   user_userMoneyLogList  [NSString stringWithFormat:@"%@api/emo/user/userMoneyLogList",VERSION_HTTPS_SERVER]
/** 钻石明细 */
#define   user_userDiamondList  [NSString stringWithFormat:@"%@api/emo/user/userDiamondList",VERSION_HTTPS_SERVER]
/** 钻石充值配置列表*/
#define   user_rechargeDiamondConfigList  [NSString stringWithFormat:@"%@api/emo/user/rechargeDiamondConfigList",VERSION_HTTPS_SERVER]
/** 钻石充值-发起充值*/
#define   user_rechargeDiamond  [NSString stringWithFormat:@"%@api/emo/user/rechargeDiamond",VERSION_HTTPS_SERVER]
/** 兑换费率配置相关*/
#define   index_config  [NSString stringWithFormat:@"%@api/emo/index/config",VERSION_HTTPS_SERVER]
/** 金币兑换钻石*/
#define   user_moneyChangeDiamond  [NSString stringWithFormat:@"%@api/emo/user/moneyChangeDiamond",VERSION_HTTPS_SERVER]
/** 钻石兑换紫金*/
#define   user_diamondChangeLotteryCoin  [NSString stringWithFormat:@"%@api/emo/user/diamondChangeLotteryCoin",VERSION_HTTPS_SERVER]
/** 钻石兑换黑曜石*/
#define   user_diamondChangeRatioCoin  [NSString stringWithFormat:@"%@api/emo/user/diamondChangeRatioCoin",VERSION_HTTPS_SERVER]
/** 保存登录设备信息(登录后调用)*/
#define   user_saveLoginDevice  [NSString stringWithFormat:@"%@api/emo/user/saveLoginDevice",VERSION_HTTPS_SERVER]



#pragma mark 抽奖盘
/** 获取抽奖盘列表*/
#define   lottery_get_rooms  [NSString stringWithFormat:@"%@api/emo/lottery/get_rooms",VERSION_HTTPS_SERVER]
#define   lottery_get_rooms_new  [NSString stringWithFormat:@"%@api/emo/turntable_wheel/get_rooms",VERSION_HTTPS_SERVER]




/** 获取倍率盘列表*/
#define   ratio_get_rooms  [NSString stringWithFormat:@"%@api/emo/ratio/get_rooms",VERSION_HTTPS_SERVER]
/** 获取倍率盘详情*/
#define   ratio_room_detail  [NSString stringWithFormat:@"%@api/emo/ratio/room_detail",VERSION_HTTPS_SERVER]
#define   ratio_room_detailNew  [NSString stringWithFormat:@"%@api/emo/turntable_wheel/room_detail",VERSION_HTTPS_SERVER]

/** 下注*/
#define   ratio_bet  [NSString stringWithFormat:@"%@api/emo/ratio/bet",VERSION_HTTPS_SERVER]
#define   ratio_bet_new  [NSString stringWithFormat:@"%@api/emo/turntable_wheel/bet",VERSION_HTTPS_SERVER]

/** 中奖记录*/
#define   ratio_my_win_log  [NSString stringWithFormat:@"%@api/emo/ratio/my_win_log",VERSION_HTTPS_SERVER]
#define   ratio_my_win_log_new  [NSString stringWithFormat:@"%@api/emo/turntable_wheel/my_win_log",VERSION_HTTPS_SERVER]
/** 参与记录*/
#define   ratio_my_records  [NSString stringWithFormat:@"%@api/emo/ratio/my_records",VERSION_HTTPS_SERVER]
#define   ratio_my_records_new  [NSString stringWithFormat:@"%@api/emo/turntable_wheel/my_records",VERSION_HTTPS_SERVER]



/** 获取我的背包列表（新） */
#define   user_getMyKnapsack  [NSString stringWithFormat:@"%@api/user/getMyKnapsack",VERSION_HTTPS_SERVER]
/** 获取钻石和倍率盘礼物列表*/
#define   gift_giftList  [NSString stringWithFormat:@"%@api/emo/gift/giftList",VERSION_HTTPS_SERVER]
/** 元宝兑换礼物*/
#define   gift_prizeCoinChangeGift  [NSString stringWithFormat:@"%@api/emo/gift/prizeCoinChangeGift",VERSION_HTTPS_SERVER]
/** 背包礼物兑换黑曜石*/
#define   gift_bagGiftExchangeRatioCoin  [NSString stringWithFormat:@"%@api/emo/gift/bagGiftExchangeRatioCoin",VERSION_HTTPS_SERVER]
/** 排行榜 （新）*/
#define   gift_getRanking  [NSString stringWithFormat:@"%@api/emo/gift/getRanking",VERSION_HTTPS_SERVER]
/** 我收到和赠送的礼物列表*/
#define   gift_getMyReceiveGift  [NSString stringWithFormat:@"%@api/emo/gift/getMyReceiveGift",VERSION_HTTPS_SERVER]
/** 赠送礼物（新）*/
#define   gift_sendGift  [NSString stringWithFormat:@"%@api/emo/gift/sendGift",VERSION_HTTPS_SERVER]


/** 首页用户中奖通知列表*/
#define   lottery_get_win_notice_log  [NSString stringWithFormat:@"%@api/emo/lottery/get_win_notice_log",VERSION_HTTPS_SERVER]
/** 首页我正在开播的房间*/
#define   user_getMyOnlineRoom  [NSString stringWithFormat:@"%@api/emo/user/getMyOnlineRoom",VERSION_HTTPS_SERVER]
/** 获取音乐列表*/
#define   user_getMusicList  [NSString stringWithFormat:@"%@api/emo/user/getMusicList",VERSION_HTTPS_SERVER]


/** 提交/编辑实名认证*/
#define   user_userRealName  [NSString stringWithFormat:@"%@api/user/userRealName",VERSION_HTTPS_SERVER]



/** 动态推荐轮播图列表*/
#define   index_dynamicBannerList  [NSString stringWithFormat:@"%@api/emo/index/dynamicBannerList",VERSION_HTTPS_SERVER]
/** 动态推荐轮播图详情*/
#define   index_dynamicBannerDetail  [NSString stringWithFormat:@"%@api/emo/index/dynamicBannerDetail",VERSION_HTTPS_SERVER]


/** H5 签到抽奖模块
 H5 签到抽奖模块 https://cfm.yunqizhongguo.com/h5/#/pages/lottery/lottery?token=f6044f06-75ac-48ea-8f0c-e75db60649e5&id=1
 签到抽奖跳转路径一样，
 签到入参：token、type固定传sign
 抽奖入参：token、id（仅限1-6）
 */
#define   lottery_lottery_h5  [NSString stringWithFormat:@"%@h5/#/pages/lottery/lottery",VERSION_HTTPS_SERVER]



/** 我的访客记录*/
#define   user_getVisitorList  [NSString stringWithFormat:@"%@api/emo/user/getVisitorList",VERSION_HTTPS_SERVER]
/** 添加访客记录*/
#define   user_createVisitor  [NSString stringWithFormat:@"%@api/emo/user/createVisitor",VERSION_HTTPS_SERVER]

/** 主播进出房间*/
#define   room_inRoom  [NSString stringWithFormat:@"%@api/room/inRoom",VERSION_HTTPS_SERVER]


/**赛跑游戏**/
/** 获取规则 */
#define   rungame_role  [NSString stringWithFormat:@"%@api/bet/index/index",VERSION_HTTPS_SERVER]
/** 实时赛况 */
#define   rungame_getHistory  [NSString stringWithFormat:@"%@api/bet/index/getHistory",VERSION_HTTPS_SERVER]
/** 比赛记录 */
#define   rungame_getMyHistory  [NSString stringWithFormat:@"%@api/bet/bet/getMyHistory",VERSION_HTTPS_SERVER]
/** 获取当前游戏状态*/
#define   rungame_getCurrentGame  [NSString stringWithFormat:@"%@api/bet/index/getCurrentGame",VERSION_HTTPS_SERVER]
/** 获取本局我的下注*/
#define   rungame_getMyBet  [NSString stringWithFormat:@"%@api/bet/bet/getMyBet",VERSION_HTTPS_SERVER]
/** 下注 */
#define   rungame_placeBet  [NSString stringWithFormat:@"%@api/bet/bet/placeBet",VERSION_HTTPS_SERVER]
@end

NS_ASSUME_NONNULL_END
