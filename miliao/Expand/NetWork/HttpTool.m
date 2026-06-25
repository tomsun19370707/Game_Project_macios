//
//  HttpTool.m
//  miliao
//
//  Created by aa on 2019/6/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "HttpTool.h"

#import "MLNetWorkHelper.h"
#import "Global.h"

@implementation HttpTool
/**获取声网RTCtoken*/
+ (NSURLSessionTask *)PostShengWangRTCTokenWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/demo/get_rtc_token") parameters:parameters success:success failure:failure];
    
}
/**获取声网RTMtoken*/
+ (NSURLSessionTask *)PostShengWangRTMTokenWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/demo/get_rtm_token") parameters:parameters success:success failure:failure];
    
}

/** 修改登录密码*/
+ (NSURLSessionTask *)getSetLoginPwdWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/update_pwd") parameters:parameters success:success failure:failure];
}

/** 登录*/
+ (NSURLSessionTask *)getLoginWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/login") parameters:parameters success:success failure:failure];
}


/** 三方登录*/
+ (NSURLSessionTask *)getThreeLoginWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/OtherLogin") parameters:parameters success:success failure:failure];
}


/** 登录-手机号验证码登录*/
+ (NSURLSessionTask *)getLoginWithCodeParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/phoneLogin") parameters:parameters success:success failure:failure];
}
/** 获取验证码*/
+ (NSURLSessionTask *)getCodeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/verification") parameters:parameters success:success failure:failure];
}
/** 验证验证码*/
+ (NSURLSessionTask *)getisCodeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/is_verification") parameters:parameters success:success failure:failure];
}
/** 注册*/
+ (NSURLSessionTask *)getRegisterWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/registered") parameters:parameters success:success failure:failure];
}
/** 第三方注册*/
+ (NSURLSessionTask *)getOtherRegisterWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/OtherRegister") parameters:parameters success:success failure:failure];
}
/** 第三方登录*/
+ (NSURLSessionTask *)getOtherLoginWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/OtherLogin") parameters:parameters success:success failure:failure];
}

#pragma mark - 首页
//获取轮播
+ (NSURLSessionTask *)getCarouseWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/carousel") parameters:parameters success:success failure:failure];
}
//获取热门列表
+ (NSURLSessionTask *)getis_popularWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/is_popular") parameters:parameters success:success failure:failure];
}
//获取推荐类别
+ (NSURLSessionTask *)getRoom_recommend_categoriesWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/room_recommend_categories") parameters:parameters success:success failure:failure];
}
//获取推荐房间列表
+ (NSURLSessionTask *)getis_topWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/is_top") parameters:parameters success:success failure:failure];
}
//获取指定类别房间列表
+ (NSURLSessionTask *)getRoom_recommend_roomWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/room_recommend_room") parameters:parameters success:success failure:failure];
}
//密聊
+ (NSURLSessionTask *)getSecret_chatWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/secret_chat") parameters:parameters success:success failure:failure];
}
//微星阁
+ (NSURLSessionTask *)getStar_loftWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/star_loft") parameters:parameters success:success failure:failure];
}
//获取收藏列表
+ (NSURLSessionTask *)getGet_mykeepWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/get_mykeep") parameters:parameters success:success failure:failure];
}
//获取房间信息
+ (NSURLSessionTask *)getEnter_roomWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/enter_room") parameters:parameters success:success failure:failure];
}

#pragma mark - ROOM
//获取房间审核状态
+ (NSURLSessionTask *)postRoomAuditDataWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/demo/room_apply_status") parameters:parameters success:success failure:failure];
}
//获取排行榜
+ (NSURLSessionTask *)getLeaderboardWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/ranking") parameters:parameters success:success failure:failure];
}
//获取需要全服播报的所有房间号
+ (NSURLSessionTask *)getRoom_publicRoomListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/temproom") parameters:parameters success:success failure:failure];
}
//获取排行榜新
+ (NSURLSessionTask *)getLeaderboardNewWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/demo/room_rankingb") parameters:parameters success:success failure:failure];
}

//获取房间内排行榜
+ (NSURLSessionTask *)getRoom_rankingWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
//    api/room_ranking
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/organiza/user_index") parameters:parameters success:success failure:failure];
}
//获取添加收藏
+ (NSURLSessionTask *)getRoom_myKeepWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/room_mykeep") parameters:parameters success:success failure:failure];
}
//取消收藏
+ (NSURLSessionTask *)getRemove_myKeepWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/remove_mykeep") parameters:parameters success:success failure:failure];
}
//获取房间状态
+ (NSURLSessionTask *)getMicrophone_statusWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/microphone_status") parameters:parameters success:success failure:failure];
}
//上麦
+ (NSURLSessionTask *)getUp_microphoneWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/up_microphone") parameters:parameters success:success failure:failure];
}
///申请上麦
+ (NSURLSessionTask *)getUp_SQmicrophoneWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Newmethod/upmic") parameters:parameters success:success failure:failure];
}
///申请上麦列表
+ (NSURLSessionTask *)getUp_SMListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Newmethod/miclist") parameters:parameters success:success failure:failure];
}
///同意和拒绝
+ (NSURLSessionTask *)getUp_DomicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Newmethod/domic") parameters:parameters success:success failure:failure];
}

//下麦
+ (NSURLSessionTask *)getGo_microphoneWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/go_microphone") parameters:parameters success:success failure:failure];
}
//设为封闭麦位
+ (NSURLSessionTask *)getShut_microphoneWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/shut_microphone") parameters:parameters success:success failure:failure];
}
//设为公开麦位
+ (NSURLSessionTask *)getOpen_microphoneWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/open_microphone") parameters:parameters success:success failure:failure];
}

//获取个人信息
+ (NSURLSessionTask *)get_other_userWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/get_other_user") parameters:parameters success:success failure:failure];
}
//禁麦
+ (NSURLSessionTask *)getIs_soundWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/is_sound") parameters:parameters success:success failure:failure];
}
//开麦
+ (NSURLSessionTask *)getRemove_soundWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/remove_sound") parameters:parameters success:success failure:failure];
}
//禁言
+ (NSURLSessionTask *)getIs_blackWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/is_black") parameters:parameters success:success failure:failure];
}
//解除禁言
+ (NSURLSessionTask *)getIs_NOblackWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/room/dis_black") parameters:parameters success:success failure:failure];
}
//获取禁言状态
+ (NSURLSessionTask *)getNot_speak_statusWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/not_speak_status") parameters:parameters success:success failure:failure];
}
//踢出房间
+ (NSURLSessionTask *)getOut_roomWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/out_room") parameters:parameters success:success failure:failure];
}
//获取举报类型
+ (NSURLSessionTask *)getReport_typeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/report_type") parameters:parameters success:success failure:failure];
}
//举报
+ (NSURLSessionTask *)getSend_reportWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/send_report") parameters:parameters success:success failure:failure];
}
//关注
+ (NSURLSessionTask *)getFollowWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/follow") parameters:parameters success:success failure:failure];
}
//取消关注
+ (NSURLSessionTask *)getCancel_followWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/cancel_follow") parameters:parameters success:success failure:failure];
}
//退出房间
+ (NSURLSessionTask *)getQuit_roomWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/quit_room") parameters:parameters success:success failure:failure];
}
//退出房间
+ (NSURLSessionTask *)getRoomUsersWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/getRoomUsers") parameters:parameters success:success failure:failure];
}
//设为房间管理员
+ (NSURLSessionTask *)getIs_adminWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/is_admin") parameters:parameters success:success failure:failure];
}
//设为房间管理员
+ (NSURLSessionTask *)getRemove_adminWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/remove_admin") parameters:parameters success:success failure:failure];
}
//搜索用户
+ (NSURLSessionTask *)getSearch_userWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/search_user") parameters:parameters success:success failure:failure];
}
//获取房间设置
+ (NSURLSessionTask *)getRoomInfoWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/getRoomInfo") parameters:parameters success:success failure:failure];
}
//提交房间设置
+ (NSURLSessionTask *)getEdit_roomWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/edit_room") parameters:parameters success:success failure:failure];
}
//获取当前音乐和音效
+ (NSURLSessionTask *)getNow_musicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/now_music") parameters:parameters success:success failure:failure];
}
//上一曲、下一曲
+ (NSURLSessionTask *)getNext_musicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/next_music") parameters:parameters success:success failure:failure];
}
//获取我的音乐
+ (NSURLSessionTask *)getUser_musicsWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/user_musics") parameters:parameters success:success failure:failure];
}
//获取音乐库
+ (NSURLSessionTask *)getLocal_musicsWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/local_musics") parameters:parameters success:success failure:failure];
}
//删除我的音乐
+ (NSURLSessionTask *)getDel_user_musicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/del_user_music") parameters:parameters success:success failure:failure];
}
//删除我的音乐
+ (NSURLSessionTask *)getCopy_musicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/copy_music") parameters:parameters success:success failure:failure];
}
//获取表情列表
+ (NSURLSessionTask *)getEmoji_listWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/emoji_list") parameters:parameters success:success failure:failure];
}
//发送表情
+ (NSURLSessionTask *)getGet_emojiWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/get_emoji") parameters:parameters success:success failure:failure];
}
//添加排麦
+ (NSURLSessionTask *)getAddWaidWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/addWaid") parameters:parameters success:success failure:failure];
}
//取消排麦
+ (NSURLSessionTask *)getDelWaitWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/delWait") parameters:parameters success:success failure:failure];
}
//获取礼物列表
+ (NSURLSessionTask *)getGift_listWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/gift_list") parameters:parameters success:success failure:failure];
}
//清空魅力值
+ (NSURLSessionTask *)getCleanMeiLiWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/cleargiftpricecount") parameters:parameters success:success failure:failure];
}
//发送礼物
+ (NSURLSessionTask *)getGift_queueWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/gift_queue") parameters:parameters success:success failure:failure];
}

//获取用户vip,徽章微张 图片
+ (NSURLSessionTask *)get_user_vipWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/get_user_vip") parameters:parameters success:success failure:failure];
}
//获取房间成员列表
+ (NSURLSessionTask *)get_room_usersWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/get_room_users") parameters:parameters success:success failure:failure];
}
//发送宝石
+ (NSURLSessionTask *)getSend_baoshiWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/send_baoshi") parameters:parameters success:success failure:failure];
}
//发送爆音卡
+ (NSURLSessionTask *)getsend_bykWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/send_byk") parameters:parameters success:success failure:failure];
}
//拒绝or接受
+ (NSURLSessionTask *)getHandle_cpWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/handle_cp") parameters:parameters success:success failure:failure];
}



#pragma mark - 社区
//动态详情
+ (NSURLSessionTask *)getDynamic_detailsWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/dynamic_details") parameters:parameters success:success failure:failure];
}
//发布动态
+ (NSURLSessionTask *)getSend_dynamicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/send_dynamic") parameters:parameters success:success failure:failure];
}
//发评论
+ (NSURLSessionTask *)getDynamic_commentWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/dynamic_comment") parameters:parameters success:success failure:failure];
}
//官方消息
//+ (NSURLSessionTask *)getOfficial_messageWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
//{
//    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/official_message") parameters:parameters success:success failure:failure];
//}
//社区活动
+ (NSURLSessionTask *)getactiveListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/activeList") parameters:parameters success:success failure:failure];
}
//是否有未读消息
+ (NSURLSessionTask *)getunreadMessageWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/unreadMessage") parameters:parameters success:success failure:failure];
}
//评论详情
+ (NSURLSessionTask *)getlookCommentsWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/lookComments") parameters:parameters success:success failure:failure];
}

//互动消息
+ (NSURLSessionTask *)getmessageWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/message") parameters:parameters success:success failure:failure];
}
//获取话题内动态
+ (NSURLSessionTask *)getTopic_dynamicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/topic_dynamic") parameters:parameters success:success failure:failure];
}
//获取热门话题
+ (NSURLSessionTask *)getTopicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/topic") parameters:parameters success:success failure:failure];
}
//获取推荐动态
+ (NSURLSessionTask *)getRecommended_dynamicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/dynamicTjList") parameters:parameters success:success failure:failure];
}
//获取最新动态
+ (NSURLSessionTask *)getNew_dynamicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/dynamicNewList") parameters:parameters success:success failure:failure];
}
//获取关注动态
+ (NSURLSessionTask *)getdynamicFollowListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/dynamicFollowList") parameters:parameters success:success failure:failure];
}
//发布动态
+ (NSURLSessionTask *)send_dynamictWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/send_dynamic_ios") parameters:parameters success:success failure:failure];
}
//删除动态
+ (NSURLSessionTask *)del_communityWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/del_community") parameters:parameters success:success failure:failure];
}
//删除官方消息
+ (NSURLSessionTask *)getDelete_messageWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/delete_message") parameters:parameters success:success failure:failure];
}
//社区动态搜索
+ (NSURLSessionTask *)getDynamic_searchWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/dynamic_search") parameters:parameters success:success failure:failure];
}

/**
 我点赞,收藏,转发,评论关注过的动态
 param type 1点赞2收藏3转发4评论5关注
 */
+ (NSURLSessionTask *)getMerge_dynamicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/merge_dynamic") parameters:parameters success:success failure:failure];
}
//删除评论
+ (NSURLSessionTask *)getDel_comments_threeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/del_comments_three") parameters:parameters success:success failure:failure];
}
//阅读官方消息（标记已读）
+ (NSURLSessionTask *)getRead_messageWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/read_message") parameters:parameters success:success failure:failure];
}

//获取话题标签
+ (NSURLSessionTask *)get_talk_labelsWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/get_talk_labels") parameters:parameters success:success failure:failure];
}
//获取动态详情
+ (NSURLSessionTask *)getdynamic_detailsWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/dynamic_details") parameters:parameters success:success failure:failure];
}
//收藏动态
+ (NSURLSessionTask *)getDynamics_handWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/dynamics_hand") parameters:parameters success:success failure:failure];
}
//分享动态
+ (NSURLSessionTask *)share_dynamicWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/share_dynamic") parameters:parameters success:success failure:failure];
}
////添加关注
//+ (NSURLSessionTask *)getFollowWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
//{
//    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/follow") parameters:parameters success:success failure:failure];
//}
////取消关注
//+ (NSURLSessionTask *)cancel_followWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
//{
//    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/cancel_follow") parameters:parameters success:success failure:failure];
//}
//搜索标签
+ (NSURLSessionTask *)search_labelsWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/search_labels") parameters:parameters success:success failure:failure];
}
#pragma mark - 消息
//好友列表
+ (NSURLSessionTask *)getUserFriendWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/userFriend") parameters:parameters success:success failure:failure];
}
//官方消息
+ (NSURLSessionTask *)getMini_officialWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/mini_official") parameters:parameters success:success failure:failure];
}
//是否关注I
+ (NSURLSessionTask *)getIs_followWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/is_follow") parameters:parameters success:success failure:failure];
}

//拉黑
+ (NSURLSessionTask *)getPull_blackWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/pull_black") parameters:parameters success:success failure:failure];
}
//举报类型
+ (NSURLSessionTask *)getReportWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/report") parameters:parameters success:success failure:failure];
}
//官方消息列表
+ (NSURLSessionTask *)getMiniOfficial_messageWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/official_message") parameters:parameters success:success failure:failure];
}

#pragma mark - 我的
//用户个人信息
+ (NSURLSessionTask *)get_user_infoWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/get_user_info") parameters:parameters success:success failure:failure];
}
//用户个人主页
+ (NSURLSessionTask *)get_user_home_pageWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/user_home_page") parameters:parameters success:success failure:failure];
}
//开启CP栏位
+ (NSURLSessionTask *)open_cp_cardWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/open_cp_card") parameters:parameters success:success failure:failure];
}
//CP详情
+ (NSURLSessionTask *)cp_descWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/cp_desc") parameters:parameters success:success failure:failure];
}
//解除CP
+ (NSURLSessionTask *)remove_cpWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/remove_cp") parameters:parameters success:success failure:failure];
}
//发送验证码
+ (NSURLSessionTask *)getVerificationWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/verification") parameters:parameters success:success failure:failure];
}
//忘记密码
+ (NSURLSessionTask *)forget_pwdWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/forget_pwd") parameters:parameters success:success failure:failure];
}
//获取星座
+ (NSURLSessionTask *)getConstellationWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/getConstellation") parameters:parameters success:success failure:failure];
}
//修改用户信息
+ (NSURLSessionTask *)edit_user_infoWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/edit_user_info") parameters:parameters success:success failure:failure];
}
//会员中心
+ (NSURLSessionTask *)vip_centerWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/vip_center") parameters:parameters success:success failure:failure];
}

//等级中心
+ (NSURLSessionTask *)level_centerWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/level_center") parameters:parameters success:success failure:failure];
}
//我的钱包 
+ (NSURLSessionTask *)getMy_storeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/my_store") parameters:parameters success:success failure:failure];
}
//转赠记录
+ (NSURLSessionTask *)getMy_zhuanZengHistoryWithParameters:(id)parameters page:(NSInteger)page success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    NSString *str = [NSString stringWithFormat:@"%@%ld",VERSION_HTTPS_SERVER_PATH(@"api/zhengsonglog?page="),page];
    return [self requestWithPostURL:str parameters:parameters success:success failure:failure];
}

//转赠记录
+ (NSURLSessionTask *)getMy_zhuanZengHistoryNewWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/money/money_zengsong_log") parameters:parameters success:success failure:failure];
}

//转赠
+ (NSURLSessionTask *)getMy_zhuanZengWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/zengsong") parameters:parameters success:success failure:failure];
}
//绑定支付宝
+ (NSURLSessionTask *)getMy_BandingAlipayWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/ali_oauth_code") parameters:parameters success:success failure:failure];
}
//绑定支付宝---修改后
+ (NSURLSessionTask *)getMy_BandingNewAlipayWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/upalipay") parameters:parameters success:success failure:failure];
}
//上传支付宝回调的用户数据给服务器
+ (NSURLSessionTask *)getMy_uploadAlipayMessageWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/ali_oauth_token") parameters:parameters success:success failure:failure];
}
//解绑支付宝
+ (NSURLSessionTask *)getMy_jiechuAliBandingWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/UntyingAli") parameters:parameters success:success failure:failure];
}
//提现
+ (NSURLSessionTask *)getMy_tixianWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/tixian") parameters:parameters success:success failure:failure];
}

//实名认证
+ (NSURLSessionTask *)getMy_renzhengWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/bindIdentity") parameters:parameters success:success failure:failure];
}

//兑换米钻
+ (NSURLSessionTask *)exchangeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/exchange") parameters:parameters success:success failure:failure];
}
//灵石兑换钻石
+ (NSURLSessionTask *)exchangeNewWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Newmethod/exchange") parameters:parameters success:success failure:failure];
}
///兑换手续费
+ (NSURLSessionTask *)exchangeexChangesxfWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Newmethod/exchangesxf") parameters:parameters success:success failure:failure];
}
//兑换查询
+ (NSURLSessionTask *)exchange_checkWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/exchange_check") parameters:parameters success:success failure:failure];
}
//新的兑换查询
+ (NSURLSessionTask *)exchange_checkNewWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Newmethod/exchangesxf") parameters:parameters success:success failure:failure];
}
//兑换米钻记录
+ (NSURLSessionTask *)exchange_logWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/exchange_log") parameters:parameters success:success failure:failure];
}

//提现记录
+ (NSURLSessionTask *)tixianRecord_logWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/tixian_log") parameters:parameters success:success failure:failure];
}

//充值列表
+ (NSURLSessionTask *)getIosGoodsListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/iosGoodsList") parameters:parameters success:success failure:failure];
}
//新充值列表
+ (NSURLSessionTask *)getIosNewGoodsListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Newmethod/goodslist") parameters:parameters success:success failure:failure];
}

//模拟充值接口
+ (NSURLSessionTask *)getIosRechargeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/go_pay/recharge") parameters:parameters success:success failure:failure];
}

//下单支付
+ (NSURLSessionTask *)getPayapiWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"tp6/public/index.php/index/Payapi/index") parameters:parameters success:success failure:failure];
}
//获取黑名单
+ (NSURLSessionTask *)getBlackListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/blackList") parameters:parameters success:success failure:failure];
}
//移除黑名单
+ (NSURLSessionTask *)getCancel_blackWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/cancel_black") parameters:parameters success:success failure:failure];
}
// 1星锐,金锐等级说明2vip等级说明3平台协议
+ (NSURLSessionTask *)getNOne_pageWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/one_page") parameters:parameters success:success failure:failure];
}
// 获取官方联系方式
+ (NSURLSessionTask *)getOfficialWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/official") parameters:parameters success:success failure:failure];
}
// 提交反馈
+ (NSURLSessionTask *)getFeedbackWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/feedback") parameters:parameters success:success failure:failure];
}
// 获取我的收益
+ (NSURLSessionTask *)getUser_incomeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/user_income") parameters:parameters success:success failure:failure];
}
// 调取实名认证
+ (NSURLSessionTask *)getSfrz_startWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/sfrz_start") parameters:parameters success:success failure:failure];
}

// 查询认证结果
+ (NSURLSessionTask *)getSfrz_queryWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/sfrz_query") parameters:parameters success:success failure:failure];
}

// 苹果内购测试
+ (NSURLSessionTask *)applepayWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/applepay") parameters:parameters success:success failure:failure];
}

//alipay
+ (NSURLSessionTask *)alipayWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/rechargePay") parameters:parameters success:success failure:failure];
    
}
// 我的背包
+ (NSURLSessionTask *)getMy_packParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/my_pack") parameters:parameters success:success failure:failure];
//    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Dwwyx/my_pack") parameters:parameters success:success failure:failure];
    
}
// 装扮
+ (NSURLSessionTask *)dress_upWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/dress_up") parameters:parameters success:success failure:failure];
    
}
// 兑换米钻卡
+ (NSURLSessionTask *)exchange_mizuan_cardWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/exchange_mizuan_card") parameters:parameters success:success failure:failure];
    
}
//搜索列表
+ (NSURLSessionTask *)getSearhListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/searhList") parameters:parameters success:success failure:failure];
    
}
//清空搜索列表
+ (NSURLSessionTask *)cleanSarhListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/cleanSarhList") parameters:parameters success:success failure:failure];
    
}
//搜索全部
+ (NSURLSessionTask *)search_allWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/search_all") parameters:parameters success:success failure:failure];
    
}
//搜索
+ (NSURLSessionTask *)merge_searchWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/merge_search") parameters:parameters success:success failure:failure];
}
#pragma --- 宝箱
//宝箱信息
+ (NSURLSessionTask *)getBoxInfoWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/getBoxInfo") parameters:parameters success:success failure:failure];
}
//宝箱说明文字
+ (NSURLSessionTask *)getRewardInfoWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/getRewardInfo") parameters:parameters success:success failure:failure];
}
//中奖记录
+ (NSURLSessionTask *)getAwardRecordListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/getAwardRecordList") parameters:parameters success:success failure:failure];
}
//积分可兑换物品列表
+ (NSURLSessionTask *)getAwardWaresListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/getAwardWaresList") parameters:parameters success:success failure:failure];
}

//奖池物品列表
+ (NSURLSessionTask *)getAwardJiangChiListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/getAwardBoxList") parameters:parameters success:success failure:failure];
}
//开奖
+ (NSURLSessionTask *)getAwardListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/getAwardList") parameters:parameters success:success failure:failure];
}
//购买钥匙
+ (NSURLSessionTask *)actionBuyKeysWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/actionBuyKeys") parameters:parameters success:success failure:failure];
}

//获得钥匙所需米钻数量
+ (NSURLSessionTask *)getMizuanNumWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/getMizuanNum") parameters:parameters success:success failure:failure];
}
//积分兑换
+ (NSURLSessionTask *)actionAwardExchangeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/actionAwardExchange") parameters:parameters success:success failure:failure];
}
/*********************************************************/
/*
 配置好MLNetworkHelper各项请求参数,封装成一个公共方法,给以上方法调用,
 相比在项目中单个分散的使用MLNetworkHelper/其他网络框架请求,可大大降低耦合度,方便维护
 在项目的后期, 你可以在公共请求方法内任意更换其他的网络请求工具,切换成本小
 以下是无缓存的公共方法,可自己再定制有缓存的
 */
 
+ (NSURLSessionTask *)completCompanyUploadFileWithURL:(NSString *)URL parameters:(id)parameters name:(NSString *)name images:(NSArray<UIImage *> *)images fileNames:(NSArray<NSString *> *)fileNames imageScale:(CGFloat)imageScale imageType:(NSString *)imageType audio:(NSString *)audiofilePath progress:(MLProgress)progresssasa success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    [MLNetWorkHelper setRequestTimeoutInterval:8.0];
    [MLNetWorkHelper openNetworkActivityIndicator:YES];
    [MLNetWorkHelper openLog];
    return [MLNetWorkHelper uploadImagesWithURL:URL parameters:parameters name:name images:images fileNames:fileNames imageScale:imageScale imageType:imageType audio:audiofilePath progress:^(NSProgress *progress) {
        progresssasa(progress);
        
    } success:^(id responseObject) {
        [MLNetWorkHelper openNetworkActivityIndicator:NO];
        
        success(responseObject);
    } failure:^(NSError *error) {
        [MLNetWorkHelper openNetworkActivityIndicator:NO];
        
        failure(error);
    }];
}

#pragma mark ------ 新增接口
//获取游戏列表
+ (NSURLSessionTask *)getGameListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"/api/room/game_list") parameters:parameters success:success failure:failure];
}

//抽取塔罗牌
+ (NSURLSessionTask *)getRqeustTLPWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Newmethod/luckdraw") parameters:parameters success:success failure:failure];
}
//获取塔罗牌中奖记录
+ (NSURLSessionTask *)getRqeustWinlistWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Newmethod/winlist") parameters:parameters success:success failure:failure];
}

//塔罗牌充值
+ (NSURLSessionTask *)getRqeustTLPRechangeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Newmethod/czmoney") parameters:parameters success:success failure:failure];
}


//分享
+ (NSURLSessionTask *)getRqeustShareFriendWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Newmethod/share") parameters:parameters success:success failure:failure];
}


#pragma mark 大胃王接口
//大胃王 获取商品信息的接口
+ (NSURLSessionTask *)getRequstDWWWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Dwwyx/dwwsp") parameters:parameters success:success failure:failure];
}
//今日排行
+ (NSURLSessionTask *)getRequstLeaderboardithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Dwwyx/todaytop") parameters:parameters success:success failure:failure];
}

//购买商品
+ (NSURLSessionTask *)getRequstBuyShopWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Dwwyx/buy") parameters:parameters success:success failure:failure];
}

//30秒开奖
+ (NSURLSessionTask *)getRequstShowPrizeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Dwwyx/autokj") parameters:parameters success:success failure:failure];
}

//规则
+ (NSURLSessionTask *)getRequstRuleWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Dwwyx/dwwgz") parameters:parameters success:success failure:failure];
}

//购买记录
+ (NSURLSessionTask *)getRequstPrizeResultsWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
//    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Dwwyx/gmjl") parameters:parameters success:success failure:failure];
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Dwwyx/wqjl") parameters:parameters success:success failure:failure];
}

//兑换商城
+ (NSURLSessionTask *)getGameShopWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/dwwyx/dhsc") parameters:parameters success:success failure:failure];
}
//兑换商品
+ (NSURLSessionTask *)getShopExchangeGoodsWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/dwwyx/scdh") parameters:parameters success:success failure:failure];
    
}
//兑换记录
+ (NSURLSessionTask *)getShopExchangeGoodsRecoedWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Dwwyx/dhjl") parameters:parameters success:success failure:failure];
}

#pragma mark 福袋


//获取福袋列表
+ (NSURLSessionTask *)getRequstFuDaiListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Fdyx/fdindex") parameters:parameters success:success failure:failure];
    
}

//福袋商品
+ (NSURLSessionTask *)getRequstFuDaiShopWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Fdyx/fdsp") parameters:parameters success:success failure:failure];
}

//福袋中奖记录
+ (NSURLSessionTask *)getRequstFuDaiPrizeWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Fdyx/zjjl") parameters:parameters success:success failure:failure];
}

//购买福袋
+ (NSURLSessionTask *)getRequstBuyFuDaiWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/Fdyx/buy") parameters:parameters success:success failure:failure];
}




//我加入的公会
+ (NSURLSessionTask *)postRequstJoinGuildWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/organiza/my_organiza") parameters:parameters success:success failure:failure];
}

//公会成员
+ (NSURLSessionTask *)postRequstGuildUserListWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/organiza/user_list") parameters:parameters success:success failure:failure];
}

//修改公会信息
+ (NSURLSessionTask *)postRequstChangeGuildMsgWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/organiza/edit_organiza") parameters:parameters success:success failure:failure];
}

//邀请成员
+ (NSURLSessionTask *)postRequstInvitationGuildUserWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/organiza/invite_user") parameters:parameters success:success failure:failure];
}

//邀请搜索成员
+ (NSURLSessionTask *)postRequstInvitationSearchGuildUserWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/organiza/search_user") parameters:parameters success:success failure:failure];
}



//我的受邀记录
+ (NSURLSessionTask *)postRequstInvitationrecordWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/organiza/invite_list") parameters:parameters success:success failure:failure];
}

//处理公会邀请
+ (NSURLSessionTask *)postRequstGuildInvitationWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/organiza/dispose_invite") parameters:parameters success:success failure:failure];
}


//踢出成员
+ (NSURLSessionTask *)postRequstGetOutGuildUserWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure{
    return [self requestWithPostURL:VERSION_HTTPS_SERVER_PATH(@"api/organiza/delete_user") parameters:parameters success:success failure:failure];
}


#pragma mark - 请求的公共方法
+ (NSURLSessionTask *)requestWithPostURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(MLRequestSuccess)success failure:(MLRequestFailure)failure {
    
    // 在请求之前你可以统一配置你请求的相关参数 ,设置请求头, 请求参数的格式, 返回数据的格式....这样你就不需要每次请求都要设置一遍相关参数
    //    [MLNetWorkHelper setValue:ML_AppVersion forHTTPHeaderField:@"version"];
    [MLNetWorkHelper setRequestTimeoutInterval:70.0];
    [MLNetWorkHelper openNetworkActivityIndicator:YES];
    [MLNetWorkHelper openLog];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameter];
    if ([UserManager userInfo].token) {
        if ([Common isEmptyString:dict[@"newtoken"]]) {
            ///为空
            [dict setObject:[UserManager userInfo].token forKey:@"token"];
        }
    }
    MYLog(@"请求接口--\n%@",URL);
    MYLog(@"---dic = %@\n---token---%@",dict,[UserManager userInfo].token);
    NSString *str = [DAConfig userLanguage];
    NSString *LanguageStr = [NSString string];
    if ([str isEqualToString:@"zh-Hans"]) {
//        LanguageStr = @"Chinese";
        LanguageStr =@"zh-cn";
    }else if ([str isEqualToString:@"en"]) {
//        LanguageStr = @"English";
        LanguageStr =@"en";
    } else  {
//        LanguageStr = @"Japanese";
        LanguageStr =@"zh-hk";
    }
    NSLog(@"多语言:%@",LanguageStr);
    [MLNetWorkHelper setValue:LanguageStr forHTTPHeaderField:@"accept-language"];
  
    // 发起请求
    return [MLNetWorkHelper POST:URL parameters:dict success:^(id responseObject) {
        // 在这里你可以根据项目自定义其他一些重复操作,比如加载页面时候的等待效果, 提醒弹窗....
        [MLNetWorkHelper openNetworkActivityIndicator:NO];
        success(responseObject);
    } failure:^(NSError *error) {
        // 同上
        [MLNetWorkHelper openNetworkActivityIndicator:NO];
//        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"网络连接错误，请稍后再试"];
        failure(error);
    }];
}

+ (NSURLSessionTask *)requestWithGetURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(MLRequestSuccess)success failure:(MLRequestFailure)failure {
    {
        // 在请求之前你可以统一配置你请求的相关参数 ,设置请求头, 请求参数的格式, 返回数据的格式....这样你就不需要每次请求都要设置一遍相关参数
        //    [MLNetWorkHelper setValue:ML_AppVersion forHTTPHeaderField:@"version"];
        [MLNetWorkHelper setRequestTimeoutInterval:8.0];
        [MLNetWorkHelper openNetworkActivityIndicator:YES];
        [MLNetWorkHelper openLog];
        
        // 发起请求
        return [MLNetWorkHelper GET:URL parameters:parameter success:^(id responseObject) {
            // 在这里你可以根据项目自定义其他一些重复操作,比如加载页面时候的等待效果, 提醒弹窗....
            [MLNetWorkHelper openNetworkActivityIndicator:NO];
            success(responseObject);
        } failure:^(NSError *error) {
            // 同上
            [MLNetWorkHelper openNetworkActivityIndicator:NO];
            failure(error);
        }];
    }
    
}


@end
