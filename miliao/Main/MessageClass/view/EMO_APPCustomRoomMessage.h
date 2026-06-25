//
//  EMO_APPCustomRoomMessage.h
//  miliao
//
//  Created by ZhangShiHao on 2023/8/3.
//  Copyright © 2023 EMO. All rights reserved.
//
#define RCGiftMessageTypeIdentifier @"app:CustomShareRoomMessage"
#import <RongIMLibCore/RongIMLibCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMO_APPCustomRoomMessage : RCMessageContent

/** 消息内容 */
//@property(nonatomic, strong) NSString* user_id;
@property(nonatomic, strong) NSString* roomName;///房间名称
@property(nonatomic, strong) NSString* roomImage;///房间封面图
@property(nonatomic, strong) NSString* roomNotice;//房间公告
@property(nonatomic, strong) NSString* roomId;//房间id
@property(nonatomic, strong) NSString* roomUuid;//房间uuid
@property (nonatomic, strong) NSString *roomStatus;//房间状态0正常1禁播2开播
@property (nonatomic, strong) NSString *roomType;//房间是否加锁

/**
 * 附加信息
 */
@property(nonatomic, strong) NSString* extra;


+(instancetype)messageWithContentRoomName:(NSString *)roomName andRoomUrl:(NSString *)roomImage andRoomId:(NSString *)roomId  andRoomUuid:(NSString *)roomUuid andRoomStatus:(NSString *)roomStatus andRoomType:(NSString *)roomType andRoomNotice:(NSString *)roomNotice;



@end

NS_ASSUME_NONNULL_END
