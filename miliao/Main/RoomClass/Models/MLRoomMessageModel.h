//
//  MLRoomMessageModel.h
//  miliao
//
//  Created by aa on 2019/6/20.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MLRoomMessageModel : NSObject

@property (nonatomic, strong) NSString              *nickName;
@property (nonatomic, strong) NSString              *avatar;
@property (nonatomic, strong) NSString              *user_id;
@property (nonatomic, strong) NSString              *headimgurl;
@property (nonatomic, strong) NSString              *nick_color;
@property (nonatomic, strong) NSString              *message;
//@property (nonatomic, strong) NSString            *typStr;
@property (nonatomic, strong) NSString              *messageType;
@property (nonatomic, strong) NSString              *giftOrFuDai;
@property (nonatomic, strong) NSArray              *FuDaiuserList;
/** 自定义添加的 主播 进出房间的  msgType,1为进入,2是离开*/
@property (nonatomic,strong) NSString *msgType;
@property (nonatomic, strong) NSString              *rode_image;
@property (nonatomic, strong) NSString              *enter_effects_image;
@property (nonatomic, strong) NSString              *peerage_image;
@property (nonatomic, strong) NSString              *contribute_level;
@property (nonatomic, strong) NSString              *charm_level;



@property (nonatomic, strong) NSString              *ltk_left;
@property (nonatomic, strong) NSString              *ltk;
@property (nonatomic, strong) NSString              *ltk_right;

@property(nonatomic, copy) NSArray                  *awardList;


@property (nonatomic, strong) NSArray               *userInfo;
@property (nonatomic, strong) NSString              *toNickName;
@property (nonatomic, strong) NSString              *toUser_id;
@property (nonatomic, strong) NSString              *toheadimgurl;
@property (nonatomic, strong) NSString              *toNick_color;
@property (nonatomic, strong) NSString              *show_img;
@property (nonatomic, strong) NSString              *type;
@property (nonatomic, strong) NSString              *giftNum;
@property (nonatomic, strong) NSString              *gift_name;
@property (nonatomic, strong) NSString              *show_gif_img;
@property (nonatomic, strong) NSString              *e_name;

@property (nonatomic, strong) NSString              *box_class;


@property (nonatomic, strong) NSString              *room_name;
@property (nonatomic, strong) NSString              *room_type;
@property (nonatomic, strong) NSString              *room_background;
@property (nonatomic, strong) NSString              *room_intro;
@property (nonatomic, strong) NSString              *emoji;
@property (nonatomic, strong) NSString              *is_answer;
@property (nonatomic, strong) NSString              *t_length;

//@property (nonatomic, strong) NSString              *vip_img;
@property (nonatomic, strong) NSString              *vip_num;
//@property (nonatomic, strong) NSString              *hz_img;
@property (nonatomic, strong) NSString              *vip_tx;

@property (nonatomic, strong) NSString              *cpType;
@property (nonatomic, strong) NSString              *cp_tx;
@property (nonatomic, strong) NSString              *cp_xssm;

@property (nonatomic, strong) NSString              *coin;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat cellWeight;
@property(nonatomic, assign) CGFloat messageWidth;//文字的宽度


@end
