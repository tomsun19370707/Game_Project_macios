//
//  MLRoomMSequenceModel.h
//  miliao
//
//  Created by aa on 2019/6/22.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLRoomMSequenceModel : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, assign) NSInteger num;//麦位位置
@property (nonatomic, strong) NSString *uuid;//用户id
@property (nonatomic, strong) NSString *uid;//用户id
@property (nonatomic, strong) NSString *is_me;//是否自己
@property (nonatomic, strong) NSString *status;//0空麦1锁麦2麦上有人
@property (nonatomic, strong) NSString *status_text;//描述
@property (nonatomic, strong) NSString *user_charm;//魅力值
@property (nonatomic, strong) NSString *avatar;//头像
@property (nonatomic, strong) NSString *nickname;//用户昵称
@property (nonatomic, strong) NSString *prevent_exit_microphone_position;//防下麦
@property (nonatomic, strong) NSString *type;//0不闭麦1闭麦
@property (nonatomic, strong) NSString *type_text;//描述
@property (nonatomic, strong) NSString *is_countdown;//是否开启倒计时0不开启1开启
@property (nonatomic, strong) NSString *is_countdown_text;//倒计时说明
@property (nonatomic, strong) NSString *countdown_times;//倒计时时长

@property (nonatomic, strong) NSString *avatar_frame_id;//头像框ID
@property (nonatomic, strong) NSString *avatar_frame_name;//头像框标题
@property (nonatomic, strong) NSString *avatar_frame_image;//头像框静态图
@property (nonatomic, strong) NSString *avatar_frame_svga_file;//头像框动态图
@property (nonatomic, strong) NSString *is_owners;//是否是房主


@property (nonatomic, strong) NSString *isSelected;

//@property (nonatomic, strong) NSString *shut_sound;
//@property (nonatomic, strong) NSString *is_sound;
//@property (nonatomic, strong) NSString *mic_color;
//@property (nonatomic, strong) NSString *txk;
//@property (nonatomic, strong) NSString *MSequence;
//@property (nonatomic, strong) NSString *vip_img;




@end
