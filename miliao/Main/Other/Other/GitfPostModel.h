//
//  GitfPostModel.h
//  miliao
//
//  Created by aa on 2019/8/9.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GitfPostModel : NSObject
//头像
@property (nonatomic, strong) NSString *uid;
//ID
@property (nonatomic, strong) NSString *img;
//昵称
@property (nonatomic, strong) NSString *user_name;
//1男2女
@property (nonatomic, strong) NSString *num;
//生日
@property (nonatomic, strong) NSString *gift_name;
//星座
@property (nonatomic, strong) NSString *from_name;
@property (nonatomic, strong) NSString *boxclass;
@end

NS_ASSUME_NONNULL_END
