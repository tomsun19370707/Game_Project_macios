//
//  MLRoomUserModel.h
//  miliao
//
//  Created by aa on 2019/6/26.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLRoomUserModel : NSObject

@property (nonatomic, strong) NSString *is_in_room;//是否是当前房间的人;1在0不在
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *is_attention;
@property (nonatomic, strong) NSString *attention_nums;
@property (nonatomic, strong) NSString *fans_nums;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *birthday_time;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSString *contribute_level;
@property (nonatomic, strong) NSString *charm_level;
@property (nonatomic, strong) NSString *peerage_id;
@property (nonatomic, strong) NSString *peerage_name;
@property (nonatomic, strong) NSString *peerage_image;//
@property (nonatomic, strong) NSString *constellation;//星座

@property (nonatomic, strong) NSString *zaiMaiShang;

@property (nonatomic, strong) NSString *microphone_position_id;//麦位ID
@property (nonatomic, strong) NSString *microphone_position_num;//麦位序号
@property (nonatomic, strong) NSString *microphone_position_type;//是否开麦闭麦 0不闭麦 1闭麦
@property (nonatomic, strong) NSString *is_muted;//是否禁言0不禁言1禁言
@property (nonatomic, assign) NSInteger prevent_exit_microphone_position;//防下麦

@property (nonatomic, strong) NSString *level_image;//家族等级图标

@property (nonatomic, strong) NSArray *skill_info;//技能列表

@property (nonatomic, strong) NSDictionary *room_info;//房间信息
@property (nonatomic, strong) NSDictionary *family_info;//家族信息



@end
