//
//  HttpTool.h
//  miliao
//
//  Created by aa on 2019/6/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 请求成功的block
 */
typedef void(^MLRequestSuccess)(id response);
/**
 请求失败的block
 */
typedef void(^MLRequestFailure)(NSError *error);
typedef void (^MLProgress)(NSProgress *progress);

@interface HttpTool : NSObject

/**获取声网RTCtoken*/
+ (NSURLSessionTask *)PostShengWangRTCTokenWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
/**获取声网RTMtoken*/
+ (NSURLSessionTask *)PostShengWangRTMTokenWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
/** 修改登录密码*/
+ (NSURLSessionTask *)getSetLoginPwdWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
/** 登录*/
+ (NSURLSessionTask *)getLoginWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

/** 三方登录*/
+ (NSURLSessionTask *)getThreeLoginWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
/** 登录-手机号验证码登录*/
+ (NSURLSessionTask *)getLoginWithCodeParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

+ (NSURLSessionTask *)getRegisterWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

+ (NSURLSessionTask *)getCodeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
+ (NSURLSessionTask *)getisCodeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
/** 第三方登录注册*/
+ (NSURLSessionTask *)getOtherRegisterWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
/** 第三方登录*/
+ (NSURLSessionTask *)getOtherLoginWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

#pragma mark - 首页
//获取轮播
+ (NSURLSessionTask *)getCarouseWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取热门列表
+ (NSURLSessionTask *)getis_popularWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取推荐类别
+ (NSURLSessionTask *)getRoom_recommend_categoriesWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取推荐房间列表
+ (NSURLSessionTask *)getis_topWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取指定类别房间列表
+ (NSURLSessionTask *)getRoom_recommend_roomWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//密聊
+ (NSURLSessionTask *)getSecret_chatWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//微星阁
+ (NSURLSessionTask *)getStar_loftWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取收藏列表
+ (NSURLSessionTask *)getGet_mykeepWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取房间信息
+ (NSURLSessionTask *)getEnter_roomWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

#pragma mark - ROOM
//获取房间审核状态
+ (NSURLSessionTask *)postRoomAuditDataWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取排行榜
+ (NSURLSessionTask *)getLeaderboardWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取需要全服播报的房间列表
+ (NSURLSessionTask *)getRoom_publicRoomListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取房间内排行榜
+ (NSURLSessionTask *)getRoom_rankingWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取添加收藏
+ (NSURLSessionTask *)getRoom_myKeepWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//取消收藏
+ (NSURLSessionTask *)getRemove_myKeepWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取房间状态
+ (NSURLSessionTask *)getMicrophone_statusWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//上麦
+ (NSURLSessionTask *)getUp_microphoneWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
///申请上麦
+ (NSURLSessionTask *)getUp_SQmicrophoneWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
///申请上麦列表
+ (NSURLSessionTask *)getUp_SMListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
///同意和拒绝
+ (NSURLSessionTask *)getUp_DomicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//下麦
+ (NSURLSessionTask *)getGo_microphoneWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//设为封闭麦位
+ (NSURLSessionTask *)getShut_microphoneWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//设为公开麦位
+ (NSURLSessionTask *)getOpen_microphoneWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取个人信息
+ (NSURLSessionTask *)get_other_userWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//禁麦
+ (NSURLSessionTask *)getIs_soundWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//开麦
+ (NSURLSessionTask *)getRemove_soundWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//禁言
+ (NSURLSessionTask *)getIs_blackWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//解除禁言
+ (NSURLSessionTask *)getIs_NOblackWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//获取禁言状态
+ (NSURLSessionTask *)getNot_speak_statusWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//踢出房间
+ (NSURLSessionTask *)getOut_roomWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取举报类型
+ (NSURLSessionTask *)getReport_typeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//举报
+ (NSURLSessionTask *)getSend_reportWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//关注
+ (NSURLSessionTask *)getFollowWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//取消关注
+ (NSURLSessionTask *)getCancel_followWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//退出房间
+ (NSURLSessionTask *)getQuit_roomWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//退出房间
+ (NSURLSessionTask *)getRoomUsersWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//设为房间管理员
+ (NSURLSessionTask *)getIs_adminWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//设为房间管理员
+ (NSURLSessionTask *)getRemove_adminWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//搜索用户
+ (NSURLSessionTask *)getSearch_userWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取房间设置
+ (NSURLSessionTask *)getRoomInfoWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//提交房间设置
+ (NSURLSessionTask *)getEdit_roomWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取当前音乐和音效
+ (NSURLSessionTask *)getNow_musicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//上一曲、下一曲
+ (NSURLSessionTask *)getNext_musicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取我的音乐
+ (NSURLSessionTask *)getUser_musicsWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取音乐库
+ (NSURLSessionTask *)getLocal_musicsWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//删除我的音乐
+ (NSURLSessionTask *)getDel_user_musicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//删除我的音乐
+ (NSURLSessionTask *)getCopy_musicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取表情列表
+ (NSURLSessionTask *)getEmoji_listWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//发送表情
+ (NSURLSessionTask *)getGet_emojiWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//添加排麦
+ (NSURLSessionTask *)getAddWaidWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//取消排麦
+ (NSURLSessionTask *)getDelWaitWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取礼物列表
+ (NSURLSessionTask *)getGift_listWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//清空魅力值
+ (NSURLSessionTask *)getCleanMeiLiWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//发送礼物
+ (NSURLSessionTask *)getGift_queueWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取用户vip,徽章微张 图片
+ (NSURLSessionTask *)get_user_vipWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取房间成员列表
+ (NSURLSessionTask *)get_room_usersWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//发送宝石
+ (NSURLSessionTask *)getSend_baoshiWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//发送爆音卡
+ (NSURLSessionTask *)getsend_bykWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//拒绝or接受
+ (NSURLSessionTask *)getHandle_cpWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

#pragma mark - 社区
//动态详情
+ (NSURLSessionTask *)getDynamic_detailsWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//发布动态
+ (NSURLSessionTask *)getSend_dynamicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//发评论
+ (NSURLSessionTask *)getDynamic_commentWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//官方消息
//+ (NSURLSessionTask *)getOfficial_messageWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//社区活动
+ (NSURLSessionTask *)getactiveListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//是否有未读消息
+ (NSURLSessionTask *)getunreadMessageWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//评论详情
+ (NSURLSessionTask *)getlookCommentsWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//互动消息
+ (NSURLSessionTask *)getmessageWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取话题内动态
+ (NSURLSessionTask *)getTopic_dynamicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取热门话题
+ (NSURLSessionTask *)getTopicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取推荐动态
+ (NSURLSessionTask *)getRecommended_dynamicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取最新动态
+ (NSURLSessionTask *)getNew_dynamicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取关注动态
+ (NSURLSessionTask *)getdynamicFollowListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//删除官方消息
+ (NSURLSessionTask *)getDelete_messageWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//社区动态搜索
+ (NSURLSessionTask *)getDynamic_searchWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
/**
 我点赞,收藏,转发,评论关注过的动态
 param type 1点赞2收藏3转发4评论5关注
 */
+ (NSURLSessionTask *)getMerge_dynamicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//删除评论
+ (NSURLSessionTask *)getDel_comments_threeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//阅读官方消息（标记已读）
+ (NSURLSessionTask *)getRead_messageWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//获取话题标签
+ (NSURLSessionTask *)get_talk_labelsWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取动态详情
+ (NSURLSessionTask *)getdynamic_detailsWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
////添加关注
//+ (NSURLSessionTask *)getFollowWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
////取消关注
//+ (NSURLSessionTask *)cancel_followWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//发布动态
+ (NSURLSessionTask *)send_dynamictWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//删除动态
+ (NSURLSessionTask *)del_communityWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//搜索标签
+ (NSURLSessionTask *)search_labelsWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
+ (NSURLSessionTask *)completCompanyUploadFileWithURL:(NSString *)URL parameters:(id)parameters name:(NSString *)name images:(NSArray<UIImage *> *)images fileNames:(NSArray<NSString *> *)fileNames imageScale:(CGFloat)imageScale imageType:(NSString *)imageType progress:(MLProgress)progresssasa success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//上传多张图片加音频
+ (NSURLSessionTask *)completCompanyUploadFileWithURL:(NSString *)URL parameters:(id)parameters name:(NSString *)name images:(NSArray<UIImage *> *)images fileNames:(NSArray<NSString *> *)fileNames imageScale:(CGFloat)imageScale imageType:(NSString *)imageType audio:(NSString *)audiofilePath progress:(MLProgress)progresssasa success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//抽取塔罗牌
+ (NSURLSessionTask *)getRqeustTLPWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//塔罗牌充值
+ (NSURLSessionTask *)getRqeustTLPRechangeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//获取塔罗牌中奖记录
+ (NSURLSessionTask *)getRqeustWinlistWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//分享
+ (NSURLSessionTask *)getRqeustShareFriendWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
#pragma mark - 消息
//获取好友列表
+ (NSURLSessionTask *)getUserFriendWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//官方消息
+ (NSURLSessionTask *)getMini_officialWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//是否关注
+ (NSURLSessionTask *)getIs_followWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//拉黑
+ (NSURLSessionTask *)getPull_blackWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//举报
+ (NSURLSessionTask *)getReportWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//官方消息列表
+ (NSURLSessionTask *)getMiniOfficial_messageWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;


#pragma mark - 我的
//用户个人信息
+ (NSURLSessionTask *)get_user_infoWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//用户个人主页
+ (NSURLSessionTask *)get_user_home_pageWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//开启CP栏位
+ (NSURLSessionTask *)open_cp_cardWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//CP详情
+ (NSURLSessionTask *)cp_descWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//解除CP
+ (NSURLSessionTask *)remove_cpWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//发送验证码
+ (NSURLSessionTask *)getVerificationWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//忘记密码
+ (NSURLSessionTask *)forget_pwdWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取星座
+ (NSURLSessionTask *)getConstellationWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//修改用户信息
+ (NSURLSessionTask *)edit_user_infoWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//会员中心
+ (NSURLSessionTask *)vip_centerWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//等级中心
+ (NSURLSessionTask *)level_centerWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//我的钱包
+ (NSURLSessionTask *)getMy_storeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//转赠记录
+ (NSURLSessionTask *)getMy_zhuanZengHistoryWithParameters:(id)parameters page:(NSInteger)page success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//转赠记录
+ (NSURLSessionTask *)getMy_zhuanZengHistoryNewWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//转赠
+ (NSURLSessionTask *)getMy_zhuanZengWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//绑定支付宝
+ (NSURLSessionTask *)getMy_BandingAlipayWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//直接绑定账户
+ (NSURLSessionTask *)getMy_BandingNewAlipayWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//上传支付宝用户信息到服务器
+ (NSURLSessionTask *)getMy_uploadAlipayMessageWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//接触支付宝绑定接口
+ (NSURLSessionTask *)getMy_jiechuAliBandingWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//提现
+ (NSURLSessionTask *)getMy_tixianWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//实名认证
+ (NSURLSessionTask *)getMy_renzhengWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//兑换米钻
+ (NSURLSessionTask *)exchangeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//0钻石
+ (NSURLSessionTask *)exchangeNewWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
///兑换手续费
+ (NSURLSessionTask *)exchangeexChangesxfWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//兑换查询
+ (NSURLSessionTask *)exchange_checkWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//新的兑换查询
+ (NSURLSessionTask *)exchange_checkNewWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//兑换米钻记录
+ (NSURLSessionTask *)exchange_logWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//提现记录
+ (NSURLSessionTask *)tixianRecord_logWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//充值列表
+ (NSURLSessionTask *)getIosGoodsListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//新充值列表
+ (NSURLSessionTask *)getIosNewGoodsListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//模拟充值接口
+ (NSURLSessionTask *)getIosRechargeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//下单支付
+ (NSURLSessionTask *)getPayapiWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获取黑名单
+ (NSURLSessionTask *)getBlackListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//移除黑名单
+ (NSURLSessionTask *)getCancel_blackWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
// 1星锐,金锐等级说明2vip等级说明3平台协议
+ (NSURLSessionTask *)getNOne_pageWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
// 获取官方联系方式
+ (NSURLSessionTask *)getOfficialWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
// 提交反馈
+ (NSURLSessionTask *)getFeedbackWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

// 苹果内购测试
+ (NSURLSessionTask *)applepayWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

+ (NSURLSessionTask *)alipayWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
// 我的背包
+ (NSURLSessionTask *)getMy_packParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
// 装扮
+ (NSURLSessionTask *)dress_upWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
// 兑换米钻卡
+ (NSURLSessionTask *)exchange_mizuan_cardWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//搜索列表
+ (NSURLSessionTask *)getSearhListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//清空搜索列表
+ (NSURLSessionTask *)cleanSarhListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//搜索全部
+ (NSURLSessionTask *)search_allWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//搜索
+ (NSURLSessionTask *)merge_searchWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

// 获取我的收益
+ (NSURLSessionTask *)getUser_incomeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
// 调取实名认证
+ (NSURLSessionTask *)getSfrz_startWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
// 插叙认证结果
+ (NSURLSessionTask *)getSfrz_queryWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
#pragma --- 宝箱
//宝箱信息
+ (NSURLSessionTask *)getBoxInfoWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//宝箱说明文字
+ (NSURLSessionTask *)getRewardInfoWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//中奖记录
+ (NSURLSessionTask *)getAwardRecordListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//积分可兑换物品列表
+ (NSURLSessionTask *)getAwardWaresListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//奖池物品列表
+ (NSURLSessionTask *)getAwardJiangChiListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//开奖
+ (NSURLSessionTask *)getAwardListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//购买钥匙
+ (NSURLSessionTask *)actionBuyKeysWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//获得钥匙所需米钻数量
+ (NSURLSessionTask *)getMizuanNumWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//积分兑换
+ (NSURLSessionTask *)actionAwardExchangeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
/**
 param user_id   当前用户id
 param target_id 动态或评论的id
 param type      1点赞动态 2收藏动态3转发动态4点赞评论
 param hand      add点赞 del取消点赞
 */
+ (NSURLSessionTask *)getDynamics_handWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//分享动态
+ (NSURLSessionTask *)share_dynamicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

+ (NSURLSessionTask *)getLeaderboardNewWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//获取游戏类表
+ (NSURLSessionTask *)getGameListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;


#pragma mark 大胃王游戏
//获取商品信息
+ (NSURLSessionTask *)getRequstDWWWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//获取今日排行
+ (NSURLSessionTask *)getRequstLeaderboardithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//购买商品
+ (NSURLSessionTask *)getRequstBuyShopWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//30秒开奖
+ (NSURLSessionTask *)getRequstShowPrizeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//规则
+ (NSURLSessionTask *)getRequstRuleWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//购买记录
+ (NSURLSessionTask *)getRequstPrizeResultsWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//兑换商城
+ (NSURLSessionTask *)getGameShopWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//兑换商品
+ (NSURLSessionTask *)getShopExchangeGoodsWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//兑换商品记录
+ (NSURLSessionTask *)getShopExchangeGoodsRecoedWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

#pragma mark 福袋


//获取福袋列表
+ (NSURLSessionTask *)getRequstFuDaiListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//福袋商品
+ (NSURLSessionTask *)getRequstFuDaiShopWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//福袋中奖记录
+ (NSURLSessionTask *)getRequstFuDaiPrizeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//购买福袋
+ (NSURLSessionTask *)getRequstBuyFuDaiWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;


//我加入的公会
+ (NSURLSessionTask *)postRequstJoinGuildWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//公会成员
+ (NSURLSessionTask *)postRequstGuildUserListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//修改公会信息
+ (NSURLSessionTask *)postRequstChangeGuildMsgWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//邀请成员
+ (NSURLSessionTask *)postRequstInvitationGuildUserWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//邀请搜索成员
+ (NSURLSessionTask *)postRequstInvitationSearchGuildUserWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
//邀请记录
+ (NSURLSessionTask *)postRequstInvitationrecordWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//处理公会邀请
+ (NSURLSessionTask *)postRequstGuildInvitationWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

//踢出成员
+ (NSURLSessionTask *)postRequstGetOutGuildUserWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;


@end
