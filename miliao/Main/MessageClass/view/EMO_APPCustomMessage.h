//
//  EMO_APPCustomMessage.h
//  miliao
//
//  Created by ZhangShiHao on 2023/7/29.
//  Copyright © 2023 EMO. All rights reserved.
//

#define RCGiftMessageTypeIdentifier @"app:CustomShareMessage"

#import <RongIMLibCore/RongIMLibCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMO_APPCustomMessage : RCMessageContent


/** 消息内容 */
//@property(nonatomic, strong) NSString* user_id;
/** 消息内容 */
@property(nonatomic, strong) NSString* familyName;///家族名称
/** 消息内容 */
@property(nonatomic, strong) NSString* familyImage;///家族图标
/** 消息内容 */
@property(nonatomic, strong) NSString* familyLevel;//家族等级图标
/** 消息内容 */
@property(nonatomic, strong) NSString* familyId;//家族id
/**
 * 附加信息
 */
@property(nonatomic, strong) NSString* extra;


+(instancetype)messageWithContentFamilyName:(NSString *)familyName andFamilyUrl:(NSString *)familyImage andUser_id:(NSString *)user_id  andFamilyId:(NSString *)familyId andFamilyLevel:(NSString *)familyLevel;



@end

NS_ASSUME_NONNULL_END
