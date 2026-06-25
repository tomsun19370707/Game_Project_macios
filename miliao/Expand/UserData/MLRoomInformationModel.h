//
//  MLRoomInformationModel.h
//  miliao
//
//  Created by aa on 2019/6/14.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLRoomInformationModel : NSObject


@property (nonatomic, strong) NSString *room_id;//房间ID
@property (nonatomic, strong) NSString *uuid;//主播靓号ID
@property (nonatomic, strong) NSString *name;//房间名称
@property (nonatomic, strong) NSString *is_me;//是否是自己房间
@property (nonatomic, strong) NSString *image;//房间头像
@property (nonatomic, strong) NSString *room_image_id;//房间背景图ID
@property (nonatomic, strong) NSString *room_bg_image;//房间背景图
@property (nonatomic, strong) NSString *partition_id;//房间分类ID
@property (nonatomic, strong) NSString *partition_name;//房间分类
@property (nonatomic, strong) NSString *status;//房间状态0正常1禁播2开播
@property (nonatomic, strong) NSString *status_text;
@property (nonatomic, strong) NSString *type;//房间是否加锁
@property (nonatomic, strong) NSString *type_text;
@property (nonatomic, strong) NSString *notice;//公告
@property (nonatomic, strong) NSString *heat;//活力值
@property (nonatomic, strong) NSString *is_collect;//0未收藏1收藏
@property (nonatomic, strong) NSString *nickname;//主播昵称
@property (nonatomic, strong) NSString *avatar;//主播头像
@property (nonatomic, strong) NSString *charm;//魅力值
@property (nonatomic, strong) NSString *avatar_frame_id;//头像框ID
@property (nonatomic, strong) NSString *avatar_frame_image;//主播头像框静态图
@property (nonatomic, strong) NSString *avatar_frame_svga_file;//主播头像框动态图
@property (nonatomic, strong) NSString *avatar_frame_name;//主播头像框名字
@property (nonatomic, strong) NSString *prevent_exit_microphone_position;
@property (nonatomic, strong) NSString *apply_nums;//当前排队人数
@property (nonatomic, strong) NSDictionary *userinfo;//自己的信息
@property (nonatomic, assign) BOOL is_muted;//自己是否被禁言
@property (nonatomic, strong) NSString *user_type;//0普通用户1房主2管理员
@property (nonatomic, strong) NSArray *microphone_position;//麦序信息




//@property (nonatomic, strong) NSString *week_star;
//@property (nonatomic, strong) NSString *freshTime;
//@property (nonatomic, strong) NSString *numid;
//@property (nonatomic, strong) NSString *updated_at;
//@property (nonatomic, strong) NSString *sex;
//@property(nonatomic, copy) NSString *bright_num;//靓号，为空不是靓号
//@property (nonatomic, strong) NSString *room_status;
//@property (nonatomic, strong) NSString *roomBlack;
//@property (nonatomic, strong) NSString *secret_chat;
//@property (nonatomic, strong) NSString *roomAdmin;
//@property (nonatomic, strong) NSString *is_top;



//@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *room_pass;
//@property (nonatomic, strong) NSString *is_popular;
//@property (nonatomic, strong) NSString *giftPrice;

//@property (nonatomic, strong) NSString *is_sound;
//@property (nonatomic, strong) NSString *is_speak;
//@property (nonatomic, strong) NSString *uid_sound;
//@property (nonatomic, strong) NSString *uid_black;
@property (nonatomic, assign) BOOL      isBanned;
@property (nonatomic, strong) NSString *is_afk;
@property (nonatomic, strong) NSString *mic_color;
@property (nonatomic, strong) NSString *txk;

@property(nonatomic, copy) NSString *meili;//新增主播魅力值
//@property (nonatomic, strong) NSString *zb_img;



+(instancetype)currentAccount;

@end


@interface MLRoomInformationManager : NSObject

/**
 存储用户信息
 @param dic 服务器获取来的用户信息字典
 @return <#return value description#>
 */
+ (BOOL)saveUserInfo:(MLRoomInformationModel *)dic;

/**
 取用户信息
 @return 返回用户信息模型
 */
+ (MLRoomInformationModel *)userInfo;

/**
 清空用户信息
 @return <#return value description#>
 */
+ (BOOL)clearUserInfo;

@end



