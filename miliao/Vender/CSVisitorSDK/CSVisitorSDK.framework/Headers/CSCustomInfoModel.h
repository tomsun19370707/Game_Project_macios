//
//  CSCustomInfoModel.h
//  CSVisitorSDK
//
//  Created by Albert on 2021/5/18.
//  Copyright © 2021 Albert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSCustomInfoModel : NSObject

@property (nonatomic, copy) NSString *arg;        // 必传，公司标识
@property (nonatomic, copy) NSString *visitorId;  // 必传，访客id
@property (nonatomic, copy) NSString *userId;     // 选传，第三方会员id
@property (nonatomic, copy) NSString *username;   // 选传，访客名称(可传第三方会员名称)
@property (nonatomic, copy) NSString *email;      // 选传，访客邮箱
@property (nonatomic, copy) NSString *qq;         // 选传，访客qq
@property (nonatomic, copy) NSString *phone;      // 选传，访客电话
@property (nonatomic, copy) NSString *company;    // 选传，访客公司名称
@property (nonatomic, copy) NSString *address;    // 选传，访客地址
@property (nonatomic, copy) NSString *notes;      // 选传，备注信息
@property (nonatomic, copy) NSString *wechat;     // 选传，访客微信
@property (nonatomic, copy) NSString *customInfo; // 选传，自定义信息(此字段可以回传给对接用户服务器，可按需使用)


@end

NS_ASSUME_NONNULL_END
