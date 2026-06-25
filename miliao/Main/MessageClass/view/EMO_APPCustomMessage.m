//
//  EMO_APPCustomMessage.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/29.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_APPCustomMessage.h"

@implementation EMO_APPCustomMessage


+(instancetype)messageWithContentFamilyName:(NSString *)familyName andFamilyUrl:(NSString *)familyImage andUser_id:(NSString *)user_id andFamilyId:(NSString *)familyId andFamilyLevel:(NSString *)familyLevel{
    
    
    EMO_APPCustomMessage *msg = [[EMO_APPCustomMessage alloc] init];
    if (msg) {
        msg.familyName = familyName;
        msg.familyImage=familyImage;
        msg.familyLevel=familyLevel;
        msg.familyId=familyId;
//        msg.user_id=user_id;
        
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
        self.familyName=[aDecoder decodeObjectForKey:@"familyName"];
        self.familyImage=[aDecoder decodeObjectForKey:@"familyImage"];
        self.familyLevel=[aDecoder decodeObjectForKey:@"familyLevel"];
        self.familyId=[aDecoder decodeObjectForKey:@"familyId"];
//        self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
//    [aCoder encodeObject:self.content forKey:KEY_TXTMSG_CONTENT];
    [aCoder encodeObject:self.extra forKey:KEY_TXTMSG_EXTRA];
    [aCoder encodeObject:self.familyName forKey:@"familyName"];
    [aCoder encodeObject:self.familyImage forKey:@"familyImage"];
    [aCoder encodeObject:self.familyLevel forKey:@"familyLevel"];
    [aCoder encodeObject:self.familyId forKey:@"familyId"];
//    [aCoder encodeObject:self.user_id forKey:@"user_id"];
    
    
    
}

#pragma mark – RCMessageCoding delegate methods

-(NSData *)encode {
    
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
//    [dataDict setObject:self.content forKey:@"content"];
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }

//     [dataDict setObject:self.user_id forKey:@"user_id"];
    [dataDict setObject:[NSString stringWithFormat:@"%@",self.familyName] forKey:@"familyName"];
    [dataDict setObject:[NSString stringWithFormat:@"%@",self.familyImage] forKey:@"familyImage"];
    [dataDict setObject:[NSString stringWithFormat:@"%@",self.familyLevel] forKey:@"familyLevel"];
    [dataDict setObject:[NSString stringWithFormat:@"%@",self.familyId] forKey:@"familyId"];
    
   

  
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
            self.familyName=dictionary[@"familyName"];
            self.familyImage=dictionary[@"familyImage"];
//            self.user_id = dictionary[@"user_id"];
            self.familyLevel=dictionary[@"familyLevel"];
            self.familyId=dictionary[@"familyId"];
            
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
    
}

- (NSString *)conversationDigest
{
//    return @"会话列表要显示的内容";
//    return self.content;
    return @"[家族分享]";
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
