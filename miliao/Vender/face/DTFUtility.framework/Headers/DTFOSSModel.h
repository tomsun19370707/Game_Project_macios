//
//  DTFOSSModel.h
//  DTFUtility
//
//  Created by 汪澌哲 on 2023/10/22.
//  Copyright © 2023 com.alipay.iphoneclient.zoloz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTFOSSModel : NSObject
@property (nonatomic, copy) NSString *accessKeyId;
@property (nonatomic, copy) NSString *accessKeySecret;
@property (nonatomic, copy) NSString *securityToken;
@property (nonatomic, copy) NSString *endpoint;
@property (nonatomic, copy) NSString *bucket;

@end

NS_ASSUME_NONNULL_END
