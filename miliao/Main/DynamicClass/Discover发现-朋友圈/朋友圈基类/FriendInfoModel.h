//
//  FriendInfoModel.h
//  WeChat
//
//  Created by zhengwenming on 2017/9/21.
//  Copyright © 2017年 zhengwenming. All rights reserved.
//


#import "BaseModel.h"

@interface FriendInfoModel : RootModel
@property(nonatomic,copy)NSString *imgName;

@property(nonatomic,copy)NSString *photo;

@property(nonatomic,copy)NSString *userName;

@property(nonatomic,copy)NSString *userId;

@property(nonatomic,copy)NSString *phoneNO;
@property(nonatomic,assign)NSRange range;

-(instancetype)initWithDic:(NSDictionary *)dic;
@end
