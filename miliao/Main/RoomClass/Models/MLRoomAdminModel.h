//
//  MLRoomAdminModel.h
//  miliao
//
//  Created by aa on 2019/7/10.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLRoomAdminModel : NSObject
@property (nonatomic, strong) NSString *microphoneID;//位置ID
@property (nonatomic, strong) NSString *uid;//用户id
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *type;//类型,1房主2管理员0用户
@property (nonatomic, strong) NSString *type_text;
@property (nonatomic, strong) NSString *is_me;//是否是自己



@property (nonatomic, strong) NSString *is_admin;
@property (nonatomic, strong) NSString *is_mic;//是否在麦上


@end
