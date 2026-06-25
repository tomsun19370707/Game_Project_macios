//
//  PackModel.h
//  miliao
//
//  Created by aa on 2019/9/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PackModel : NSObject

@property (nonatomic, strong) NSString *target_id;//iD
@property (nonatomic, strong) NSString *name;//名称
@property (nonatomic, strong) NSString *image;//图片
@property (nonatomic, strong) NSString *svga_file;//动图
@property (nonatomic, strong) NSString *price;//价格
@property (nonatomic, strong) NSString *expiretime;//有效期
@property (nonatomic, strong) NSString *expiretime_text;//有效期
@property (nonatomic, strong) NSString *uuid;//靓号



@property (nonatomic, strong) NSString *gift_id;//礼物ID
@property (nonatomic, strong) NSString *num;//数量
@property (nonatomic, strong) NSString *dress_id;//装扮ID


@property (nonatomic, assign) NSInteger type;//类型
@property (nonatomic, strong) NSString *is_dress;//是否装扮
@property (nonatomic, strong) NSString *select;


@end

NS_ASSUME_NONNULL_END
