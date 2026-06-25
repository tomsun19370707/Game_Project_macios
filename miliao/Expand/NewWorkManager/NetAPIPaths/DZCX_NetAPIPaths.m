//
//  DZCX_NetAPIPaths.m
//  ARINASI
//
//  Created by jkkj on 2022/6/9.
//  Copyright © 2022 ZSH. All rights reserved.
//

#import "DZCX_NetAPIPaths.h"

@implementation DZCX_NetAPIPaths
#pragma mark----公共
NSString *const Request_getQiNiuToken = VERSION_HTTPS_SERVER@"addons/qiniu/index/params";//七牛token

//NSString *const Request_AppUpload = VERSION_HTTPS_SERVER@"addons/qiniu/index/upload";//上传文件
NSString *const Request_AppUpload = VERSION_HTTPS_SERVER@"api/common/upload";//上传文件

NSString *const Request_AppText = VERSION_HTTPS_SERVER@"api/common/getArticle";//获取APP内的协议
NSString *const Request_AppConfiguration= VERSION_HTTPS_SERVER@"api/common/getGroundingSet";//获取app配置

NSString *const Request_AppUpVersion= VERSION_HTTPS_SERVER@"api/index/version";//获取app版本

NSString *const Request_userInfo=VERSION_HTTPS_SERVER@"api/user/uinfo";//获取用户信息
NSString *const Request_GetReportReason=VERSION_HTTPS_SERVER@"api/common/getReportReason";//获取举报原因
NSString *const Request_CheckMessage=VERSION_HTTPS_SERVER@"api/index/checkMessage";//审核文本
NSString *const Request_UpDataVersion=VERSION_HTTPS_SERVER@"api/common/version";//版本更新
NSString *const Request_replaceText=VERSION_HTTPS_SERVER@"api/index/replaceText";//脏字库





#pragma mark - 登陆注册
///
NSString *const Request_ShenHe = VERSION_HTTPS_SERVER@"/api/index/ios_css_on";

///发送验证码
NSString *const Request_SendSms = VERSION_HTTPS_SERVER@"api/sms/send";

///验证码登录/一键登录
NSString *const Request_CodeLogin = VERSION_HTTPS_SERVER@"api/user/mobilelogin";

///注册
NSString *const Request_Register = VERSION_HTTPS_SERVER@"api/user/register";

///QQ登录
NSString *const Request_QQLogin = VERSION_HTTPS_SERVER@"api/user/qqLogin";
///wechat登录
NSString *const Request_ThreeLogin = VERSION_HTTPS_SERVER@"api/user/wxAppLogin";
//密码登录
NSString *const Request_Login = VERSION_HTTPS_SERVER@"api/user/login";
//忘记密码
NSString *const Request_changePassword = VERSION_HTTPS_SERVER@"api/user/resetpwd";


//设置密码
NSString *const Request_settingPassword = VERSION_HTTPS_SERVER@"api/user/setpassword";

//修改密码
NSString *const Request_changePsd = VERSION_HTTPS_SERVER@"api/user/in_app_reset_pwd";

//绑定手机号
NSString *const Request_BimgPhone = VERSION_HTTPS_SERVER@"api/user/bindMobile";
//更换邮箱
NSString *const Request_changePhone = VERSION_HTTPS_SERVER@"api/user/changemobile";

//注销账号
NSString *const Request_cancellation = VERSION_HTTPS_SERVER@"api/user/cancellation";




#pragma mark - 动态

NSString *const Request_GetDynamicTopic = VERSION_HTTPS_SERVER@"api/dynamic/getDynamicTopic";//获取话题列表
NSString *const Request_AddDynamic = VERSION_HTTPS_SERVER@"api/dynamic/addDynamic";//发布动态
NSString *const Request_LikeOrFollow = VERSION_HTTPS_SERVER@"api/dynamic/operateDynamic";//点赞,取赞;收藏,取收
NSString *const Request_AddComment = VERSION_HTTPS_SERVER@"api/dynamic/addComment";//发布评论
NSString *const Request_GetDynamicList = VERSION_HTTPS_SERVER@"api/dynamic/getDynamicList";//动态列表
NSString *const Request_GetDynamicXQ = VERSION_HTTPS_SERVER@"api/dynamic/getDynamicInfo";//动态详情
NSString *const Request_DynamicCommnetList = VERSION_HTTPS_SERVER@"api/dynamic/getDynamicCommnetList";//评论列表
NSString *const Request_DelDynamic = VERSION_HTTPS_SERVER@"api/dynamic/delDynamic";//删除动态
NSString *const Request_DelComment = VERSION_HTTPS_SERVER@"api/dynamic/delComment";//删除评论
NSString *const Request_EditDynamic = VERSION_HTTPS_SERVER@"api/dynamic/editDynamic";//编辑动态
NSString *const Request_GetReceivelike = VERSION_HTTPS_SERVER@"api/dynamic/getReceiveLikeList";//收到的喜欢

#pragma mark - 我的信息
NSString *const Request_AddReport=VERSION_HTTPS_SERVER@"api/user/addReport";//提交举报
NSString *const Request_UserInfo = VERSION_HTTPS_SERVER@"api/user/index";//会员中心,
NSString *const Request_ChangeUserInfo = VERSION_HTTPS_SERVER@"api/user/profile";//修改个人信息,
NSString *const Request_BindingInviteCode = VERSION_HTTPS_SERVER@"api/user/binPid";//绑定邀请码
NSString *const Request_GetMyInvite = VERSION_HTTPS_SERVER@"api/user/getMyInviteLog";//邀请记录
NSString *const Request_SubmitFeedback = VERSION_HTTPS_SERVER@"api/user/submitFeedback";//提交反馈
NSString *const Request_GetMyCollectRoomList = VERSION_HTTPS_SERVER@"api/user/getMyCollectRoomList";//获取我收藏的房间

NSString *const Request_GetSkillList = VERSION_HTTPS_SERVER@"api/user/getSkillList";//获取可添加的技能
NSString *const Request_GetMySkillList = VERSION_HTTPS_SERVER@"api/user/getMySkillList";//获取我的技能
NSString *const Request_GetMySkillInfo = VERSION_HTTPS_SERVER@"api/user/getMySkillInfo";//获取我的技能详情
NSString *const Request_AddSkill = VERSION_HTTPS_SERVER@"api/user/addSkill";//添加技能
NSString *const Request_DelSkill = VERSION_HTTPS_SERVER@"api/user/delSkill";//删除技能
NSString *const Request_GetfollowOrBlack = VERSION_HTTPS_SERVER@"api/user/operateToUid";//关注,取关;拉黑,取黑
NSString *const Request_GetMyFriendList = VERSION_HTTPS_SERVER@"api/user/getMyFriend";//我的关注,粉丝列表
NSString *const Request_GetBlockList = VERSION_HTTPS_SERVER@"api/user/getMyblock";//拉黑列表
NSString *const Request_userNameAuthentication = VERSION_HTTPS_SERVER@"api/user/userRealName";//提交,编辑实名认证

NSString *const Request_CollectRoom = VERSION_HTTPS_SERVER@"api/room/collectRoom";//收藏/取消收藏房间
NSString *const Request_InitFace = VERSION_HTTPS_SERVER@"user/initFaceVerify";//发起认证请求



NSString *const Request_GetPeerageList = VERSION_HTTPS_SERVER@"api/peerage/getPeerageList";//爵位列表

NSString *const Request_RechangeList = VERSION_HTTPS_SERVER@"api/recharge/getRechangeList";//充值列表
NSString *const Request_RechangeOrder=VERSION_HTTPS_SERVER@"api/order/addOrder";//充值订单
NSString *const Request_ValidateApplePay=VERSION_HTTPS_SERVER@"api/notify/validateApplePay";//验证苹果支付
NSString *const Request_GetMyMoney=VERSION_HTTPS_SERVER@"api/user/getMyMoney";//获取我的余额

NSString *const Request_SearchGiveUser=VERSION_HTTPS_SERVER@"api/user/getUserList";//搜索转增对象
NSString *const Request_GiveUser=VERSION_HTTPS_SERVER@"api/user/transferOther";//转增
NSString *const Request_MoneyRecordList=VERSION_HTTPS_SERVER@"api/user/getMyMoneyLog";//金币余额记录
NSString *const Request_GetMyWithdrawal=VERSION_HTTPS_SERVER@"api/user/getMyWithdrawal";//提现明细
NSString *const Request_getMyTransferLog=VERSION_HTTPS_SERVER@"api/user/getMyTransferLog";//转增记录
NSString *const Request_getMyDiamondLog=VERSION_HTTPS_SERVER@"api/user/getMyDiamondLog";//钻石余额明细
NSString *const Request_ApplyWithdrawal=VERSION_HTTPS_SERVER@"api/user/applyWithdrawal";//申请提现
NSString *const Request_getSystemNotice=VERSION_HTTPS_SERVER@"api/user/getSystemNotice";//获取系统通知
NSString *const Request_GetSystemNoticeInfo=VERSION_HTTPS_SERVER@"api/user/getSystemNoticeInfo";//获取通知详情
NSString *const Request_getOtherUserInfo=VERSION_HTTPS_SERVER@"api/user/getHimUserInfo";//获取他人信息
NSString *const Request_GetOnline=VERSION_HTTPS_SERVER@"api/index/getOnline";//获取用户在线状态





NSString *const Request_TaskList= VERSION_HTTPS_SERVER@"api/task/getTaskList";//任务列表
NSString *const Request_SigninList = VERSION_HTTPS_SERVER@"api/task/getSigninList";//签到列表
NSString *const Request_signIn = VERSION_HTTPS_SERVER@"api/task/signIn";//签到
NSString *const Request_CheckTask = VERSION_HTTPS_SERVER@"api/index/checkTask";//私信任务检测


NSString *const Request_MyFamily = VERSION_HTTPS_SERVER@"api/family/getMyFamily";//家族中心/我的家族/指定家族
NSString *const Request_FamilyUserList = VERSION_HTTPS_SERVER@"api/family/getFamilyUserList";//家族成员内列表
NSString *const Request_FamilyList = VERSION_HTTPS_SERVER@"api/family/getFamilyList";//搜索家族和家族列表
NSString *const Request_ApplyFamily = VERSION_HTTPS_SERVER@"api/family/applyFamily";//申请入驻,申请退出
NSString *const Request_getfamilyApplyList = VERSION_HTTPS_SERVER@"api/family/getApplyList";//入住列表/退出列表
NSString *const Request_OperateFamilyUserApply = VERSION_HTTPS_SERVER@"api/family/operateFamilyUserApply";//入住申请/退出申请

NSString *const Request_EditFamily = VERSION_HTTPS_SERVER@"api/family/editFamily";//修改房间信息
NSString *const Request_KickedFamily = VERSION_HTTPS_SERVER@"api/family/kickedFamily";//踢出成员
NSString *const Request_GetMyFamilyIncome = VERSION_HTTPS_SERVER@"api/family/getMyFamilyIncomeLog";//获取家族流水列表/获取家族内单人流水

NSString *const Request_GetMyKnapsack = VERSION_HTTPS_SERVER@"api/user/getMyKnapsack";//我的背包
NSString *const Request_UseDress = VERSION_HTTPS_SERVER@"api/user/useDress";//使用装扮
NSString *const Request_RemoveDress = VERSION_HTTPS_SERVER@"api/user/removeDress";//卸下装扮
NSString *const Request_PayDress = VERSION_HTTPS_SERVER@"api/order/payDress";//购买装扮



#pragma mark 礼物

NSString *const Request_GetGiftList = VERSION_HTTPS_SERVER@"api/gift/getGiftList";//获取推荐礼物列表
NSString *const Request_GetBoxList = VERSION_HTTPS_SERVER@"api/gift/getBoxList";//宝箱列表
NSString *const Request_GetBoxInfo = VERSION_HTTPS_SERVER@"api/gift/getBoxInfo";//宝箱信息
NSString *const Request_GetDressList = VERSION_HTTPS_SERVER@"api/gift/getDressList";//商城装扮
NSString *const Request_GetDrawList = VERSION_HTTPS_SERVER@"api/gift/getDrawList";//抽奖列表
NSString *const Request_GetDrawProbability = VERSION_HTTPS_SERVER@"api/gift/getDrawPrizeList";//获取抽奖奖品的概率
NSString *const Request_GetMyReceiveGift = VERSION_HTTPS_SERVER@"api/gift/getMyReceiveGift";//获取我收到的礼物


#pragma mark 房间

NSString *const Request_Get_rtc_token = VERSION_HTTPS_SERVER@"api/user/get_rtc_token";//RTCtoken
NSString *const Request_Get_rtm_token = VERSION_HTTPS_SERVER@"api/user/get_rtm_token";//RTMToken
NSString *const Request_GetRoomPartition = VERSION_HTTPS_SERVER@"api/room/getRoomPartition";//获取房间分区
NSString *const Request_Lottery = VERSION_HTTPS_SERVER@"api/room/lottery";//抽奖开箱
NSString *const Request_GetRoomList = VERSION_HTTPS_SERVER@"api/room/getRoomList";//获取房间列表
NSString *const Request_EnterRoom = VERSION_HTTPS_SERVER@"api/room/enterRoom";//进入房间
NSString *const Request_AddRoom = VERSION_HTTPS_SERVER@"api/room/addRoom";//创建房间
NSString *const Request_GetRoomInfo = VERSION_HTTPS_SERVER@"api/room/getRoomInfo";//获取房间信息
NSString *const Request_GetRoomMicrophonePosition = VERSION_HTTPS_SERVER@"api/room/getRoomMicrophonePosition";//获取麦位列表
NSString *const Request_GetRoomImage = VERSION_HTTPS_SERVER@"api/room/getRoomImage";//房间背景列表
NSString *const Request_EditRoomInfo = VERSION_HTTPS_SERVER@"api/room/editRoomInfo";//修改房间信息
NSString *const Request_ApplyMicrophonePosition = VERSION_HTTPS_SERVER@"api/room/applyMicrophonePosition";//用户or房主上下麦
NSString *const Request_GetRoomUser = VERSION_HTTPS_SERVER@"api/room/getRoomUser";//获取/搜索房间内在线会员/房管/禁言/拉黑
NSString *const Request_SetRoomAdmin = VERSION_HTTPS_SERVER@"api/room/setRoomAdmin";//设置or取消管理员
NSString *const Request_GetApplyList = VERSION_HTTPS_SERVER@"api/room/getApplyList";//获取麦位申请列表
NSString *const Request_SetRoomUser = VERSION_HTTPS_SERVER@"api/room/setRoomUser";//设置房间内会员---拉黑/取消拉黑---禁言/取消禁言
NSString *const Request_EmptyCharm = VERSION_HTTPS_SERVER@"api/room/emptyCharm";//清空房间魅力值/单人魅力值
NSString *const Request_CloseMicrophone = VERSION_HTTPS_SERVER@"api/room/closeMicrophone";//全员闭麦/单人闭麦
NSString *const Request_OpenMicrophone = VERSION_HTTPS_SERVER@"api/room/openMicrophone";//全员开麦/单人开麦
NSString *const Request_SetMicrophoneCountdown = VERSION_HTTPS_SERVER@"api/room/setMicrophoneCountdown";//设置麦位倒计时/取消倒计时
NSString *const Request_LockMicrophone = VERSION_HTTPS_SERVER@"api/room/lockMicrophone";//锁麦/解除锁麦
NSString *const Request_GetRanking = VERSION_HTTPS_SERVER@"api/emo/gift/getRanking";//排行榜
NSString *const Request_AgreeMicrophoneApply = VERSION_HTTPS_SERVER@"api/room/agreeMicrophoneApply";//抱人上麦/同意申请上麦
NSString *const Request_delMicrophoneApply = VERSION_HTTPS_SERVER@"api/room/refuseMicrophoneApply";//拒绝申请上麦
NSString *const Request_UnderMicrophone = VERSION_HTTPS_SERVER@"api/room/underMicrophone";//主动下麦/抱人下麦
NSString *const Request_ExitAllMicrophone = VERSION_HTTPS_SERVER@"api/room/exitAllMicrophone";//除房主外，全员下麦

NSString *const Request_GetRoomPriceLog = VERSION_HTTPS_SERVER@"api/room/getRoomPriceLog";//打赏清单
NSString *const Request_GetMyRoomList = VERSION_HTTPS_SERVER@"api/room/getMyRoomList";//获取我的房间/我管理的房间
NSString *const Request_Resignation = VERSION_HTTPS_SERVER@"api/room/resignation";//辞职
NSString *const Request_GetOperateLog = VERSION_HTTPS_SERVER@"api/room/getOperateLog";//获取操作日志
NSString *const Request_Quit_hand = VERSION_HTTPS_SERVER@"api/room/quit_hand";//退出房间
NSString *const Request_KickOutRoom = VERSION_HTTPS_SERVER@"api/room/kickOutUser";//踢出房间
NSString *const Request_SendGift = VERSION_HTTPS_SERVER@"api/room/sendGift";//送礼物
NSString *const Request_SendBackPackGift = VERSION_HTTPS_SERVER@"api/room/allSend";//背包送礼物
NSString *const Request_GetDrawListRecord= VERSION_HTTPS_SERVER@"api/room/getDrawList";//中奖记录

#pragma mark 首页

NSString *const Request_GetRandRoom = VERSION_HTTPS_SERVER@"api/index/getRandRoom";//根据分区获取随机房间id
NSString *const Request_GetHomeRoll = VERSION_HTTPS_SERVER@"api/index/getRoomPriceLog";//首页头条
NSString *const Request_GetBanner = VERSION_HTTPS_SERVER@"api/index/getBanner";//获取轮播
NSString *const Request_HomeSearch = VERSION_HTTPS_SERVER@"api/index/search";//首页搜索



@end
