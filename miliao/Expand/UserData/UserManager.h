//
//  UserManager.h
//  miliao
//
//  Created by aa on 2019/6/12.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (nonatomic,copy)NSString *user_id;//用户id
@property (nonatomic,copy)NSString *cover_image;//背景
@property (nonatomic,copy)NSString *avatar;//头像
@property (nonatomic,copy)NSString *mobile;//手机号
@property (nonatomic,copy)NSString *nickname;//用户昵称
@property (nonatomic,copy)NSString *token;//新接口token
@property (nonatomic,copy)NSString *birthday;//生日
@property (nonatomic,copy)NSString *constellation;//星座
@property (nonatomic,copy)NSString *is_disturb;//免打扰0关闭免打扰；1开启
@property (nonatomic,copy)NSString *online;//在线状态:0=online,1=offline,2=logout
@property (nonatomic,assign)BOOL is_zb;// 0是未装扮，1是已装扮
@property (nonatomic,copy)NSString *avatar_frame_image;//头像框IMG
@property (nonatomic,copy)NSString *avatar_frame_svga_file;//头像框DVGA
@property (nonatomic,copy)NSString *avatar_frame_id;//头像框ID
@property (nonatomic,copy)NSString *avatar_frame_name;//头像狂名字
@property (nonatomic,copy)NSString *enter_effects_image;//进场特效IMG
@property (nonatomic,copy)NSString *enter_effects_id;//进场特效ID
@property (nonatomic,copy)NSString *enter_effects_name;//进场特效名字

@property (nonatomic,copy)NSString *rode_image;//坐骑IMG
@property (nonatomic,copy)NSString *rode_svga_file;//坐骑SVGA
@property (nonatomic,copy)NSString *rode_id;//坐骑ID
@property (nonatomic,copy)NSString *rode_name;//坐骑名字

@property (nonatomic,copy)NSString *is_transfer;//是否开启转赠0=不开启,1=开启
@property (nonatomic,copy)NSString *stealth_in_room;//是否隐身
@property (nonatomic,copy)NSString *heat_addition;//热度加成
@property (nonatomic,copy)NSString *prevent_exit_microphone_position;//防下麦
@property (nonatomic,copy)NSString *max_charm_exp;//最大魅力值
@property (nonatomic,copy)NSString *charm_level;//魅力等级
@property (nonatomic,copy)NSString *charm;//魅力值
@property (nonatomic,copy)NSString *max_contribute_exp;//最大贡献值
@property (nonatomic,copy)NSString *contribute;//贡献值
@property (nonatomic,copy)NSString *contribute_level;//贡献等级

@property (nonatomic,copy)NSString *wx_app_openid;//
@property (nonatomic,copy)NSString *qq_app_openid;
@property (nonatomic,copy)NSString *rong_token;//融云token
@property (nonatomic,copy)NSString *rong_user_id;//融云userID
@property (nonatomic,copy)NSString *ry_Appkey;//
@property (nonatomic,copy) NSString *invite_code;//邀请码
@property (nonatomic,copy)NSString *invite_nums;//邀请人数
@property (nonatomic,copy)NSString *invite_price;//邀请奖励
@property (nonatomic,copy)NSString *withdrawal__price;//邀请已提现金额
@property (nonatomic,copy)NSString *invite_qrcode;//二维码
@property (nonatomic,copy) NSString *pid;//上级id
@property (nonatomic,copy) NSString *invite_url;//邀请链接
@property (nonatomic,copy) NSString *uuid;//靓号(可变id（用于信息页面展示，靓号作用）)
@property (nonatomic,copy) NSString *createtime;//
@property (nonatomic,copy) NSString *expiretime;//
@property (nonatomic,copy) NSString *expires_in;//
@property (nonatomic,copy) NSString *attention_nums;//关注数
@property (nonatomic,copy) NSString *fans_nums;//粉丝数
@property (nonatomic,copy) NSString *dynamic_nums;//动态数
@property (nonatomic,copy) NSString *unionid;//微信唯一id
@property (nonatomic,copy) NSString *real_name_status;//是否实名认证 0.待提交,1.审核中,2.审核通过,3.审核拒绝
@property (nonatomic,copy) NSString *is_sign;//是否签到
@property (nonatomic,copy) NSString *withdrawal_alipay_account;//
@property (nonatomic,copy) NSString *withdrawal_alipay_name;//
@property (nonatomic,copy) NSString *withdrawal_wechat_account;//
@property (nonatomic,copy) NSString *withdrawal_wechat_name;//
@property (nonatomic,copy) NSString *peerage_icon;////等级图片
@property (nonatomic,copy) NSString *bio;////个性签名
@property (nonatomic,copy) NSString *peerage_exp;//等级经验
@property (nonatomic,copy) NSString *peerage_id;//等级ID
@property (nonatomic,copy) NSString *peerage;//
//@property (nonatomic,copy) NSString *peerage_image;//等级图标
@property (nonatomic,copy) NSString *gender;//
@property (nonatomic,copy) NSString *diamond;//钻石
@property (nonatomic,copy) NSString *money;//金币
@property (nonatomic,copy) NSString *price_to_diamond;//1RMB对应多少钻石
@property (nonatomic,copy)NSString *age;//年龄
@property (nonatomic,assign)BOOL is_zengsong;//转增功能
@property (nonatomic,copy)NSString *sex;//性别 1男2女
@property (nonatomic,strong) NSString *service;//客服电话
@property (nonatomic,strong) NSString *total_gift_money;//背包总价值
@property (nonatomic,assign) BOOL is_show_draw;//语音房礼物是否显示1-显示 0-不显示


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface UserManager : NSObject

/**
 存储用户信息
 @param dic 服务器获取来的用户信息字典
 @return <#return value description#>
 */
+ (BOOL)saveUserInfo:(NSDictionary *)dic;

/**
 取用户信息
 @return 返回用户信息模型
 */
+ (UserInfo *)userInfo;

/**
 清空用户信息
 @return <#return value description#>
 */
+ (BOOL)clearUserInfo;

@end

