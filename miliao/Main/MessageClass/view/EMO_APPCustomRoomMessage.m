//
//  EMO_APPCustomRoomMessage.m
//  miliao
//
//  Created by ZhangShiHao on 2023/8/3.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_APPCustomRoomMessage.h"

@implementation EMO_APPCustomRoomMessage

+(instancetype)messageWithContentRoomName:(NSString *)roomName andRoomUrl:(NSString *)roomImage andRoomId:(NSString *)roomId  andRoomUuid:(NSString *)roomUuid andRoomStatus:(NSString *)roomStatus andRoomType:(NSString *)roomType andRoomNotice:(NSString *)roomNotice{
    
    
    EMO_APPCustomRoomMessage *msg = [[EMO_APPCustomRoomMessage alloc] init];
    if (msg) {
        msg.roomName = roomName;
        msg.roomImage=roomImage;
        msg.roomNotice=roomNotice;
        msg.roomId=roomId;
        msg.roomUuid=roomUuid;
        msg.roomStatus=roomStatus;
        msg.roomType=roomType;
        
        
    }
    
    return msg;

}



+(RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
    
}


#pragma mark – NSCoding protocol methods
#define KEY_TXTMSG_CONTENT @"content"
#define KEY_TXTMSG_EXTRA @"extra"

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
//        self.content = [aDecoder decodeObjectForKey:KEY_TXTMSG_CONTENT];
        self.extra = [aDecoder decodeObjectForKey:KEY_TXTMSG_EXTRA];
        self.roomName=[aDecoder decodeObjectForKey:@"roomName"];
        self.roomImage=[aDecoder decodeObjectForKey:@"roomImage"];
        self.roomNotice=[aDecoder decodeObjectForKey:@"roomNotice"];
        self.roomId=[aDecoder decodeObjectForKey:@"roomId"];
        self.roomUuid=[aDecoder decodeObjectForKey:@"roomUuid"];
        self.roomStatus=[aDecoder decodeObjectForKey:@"roomStatus"];
        self.roomType=[aDecoder decodeObjectForKey:@"roomType"];

        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
//    [aCoder encodeObject:self.content forKey:KEY_TXTMSG_CONTENT];
    [aCoder encodeObject:self.extra forKey:KEY_TXTMSG_EXTRA];
    [aCoder encodeObject:self.roomName forKey:@"roomName"];
    [aCoder encodeObject:self.roomImage forKey:@"roomImage"];
    [aCoder encodeObject:self.roomNotice forKey:@"roomNotice"];
    [aCoder encodeObject:self.roomId forKey:@"roomId"];
    [aCoder encodeObject:self.roomUuid forKey:@"roomUuid"];
    [aCoder encodeObject:self.roomStatus forKey:@"roomStatus"];
    [aCoder encodeObject:self.roomType forKey:@"roomType"];

    
    
    
}

#pragma mark – RCMessageCoding delegate methods

-(NSData *)encode {
    
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
//    [dataDict setObject:self.content forKey:@"content"];
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }


    [dataDict setObject:[NSString stringWithFormat:@"%@",self.roomName] forKey:@"roomName"];
    [dataDict setObject:[NSString stringWithFormat:@"%@",self.roomImage] forKey:@"roomImage"];
    [dataDict setObject:[NSString stringWithFormat:@"%@",self.roomNotice] forKey:@"roomNotice"];
    [dataDict setObject:[NSString stringWithFormat:@"%@",self.roomId] forKey:@"roomId"];
    [dataDict setObject:[NSString stringWithFormat:@"%@",self.roomUuid] forKey:@"roomUuid"];
    [dataDict setObject:[NSString stringWithFormat:@"%@",self.roomStatus] forKey:@"roomStatus"];
    [dataDict setObject:[NSString stringWithFormat:@"%@",self.roomType] forKey:@"roomType"];
   

  
    if (self.senderUserInfo) {
        NSMutableDictionary *__dic=[[NSMutableDictionary alloc]init];
        if (self.senderUserInfo.name) {
            [__dic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [__dic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [__dic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:__dic forKey:@"user"];
    }
    
    //NSDictionary* dataDict = [NSDictionary dictionaryWithObjectsAndKeys:self.content, @"content", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}

-(void)decodeWithData:(NSData *)data {
//    __autoreleasing NSError* __error = nil;
//    if (!data) {
//        return;
//    }
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
//                                                         options:kNilOptions
//                                                           error:&__error];
//
    if (data) {
        __autoreleasing NSError *error = nil;
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if (dictionary) {
//            self.content = dictionary[@"content"];
            
            self.extra = dictionary[@"extra"];
            self.roomName=dictionary[@"roomName"];
            self.roomImage=dictionary[@"roomImage"];
            self.roomNotice=dictionary[@"roomNotice"];
            self.roomId=dictionary[@"roomId"];
            self.roomUuid=dictionary[@"roomUuid"];
            self.roomStatus=dictionary[@"roomStatus"];
            self.roomType=dictionary[@"roomType"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
    
}

- (NSString *)conversationDigest
{
//    return @"会话列表要显示的内容";
//    return self.content;
    return @"[房间分享]";
}
+(NSString *)getObjectName {
    
    return RCGiftMessageTypeIdentifier;
}
#if ! __has_feature(objc_arc)
-(void)dealloc
{
    [super dealloc];
}
#endif//__has_feature(objc_arc)
@end
