//
//  MakeOrder.h
//  ZYT_iOS
//
//  Created by nicz on 2018/6/26.
//  Copyright © 2018年 MHT All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MakeOrder : NSObject

@property (strong, nonatomic) NSString *appid;
@property (strong, nonatomic) NSString *noncestr;
@property (strong, nonatomic) NSString *package;
@property (strong, nonatomic) NSString *partnerid;
@property (strong, nonatomic) NSString *prepayid;
@property (strong, nonatomic) NSString *timestamp;
@property (strong, nonatomic) NSString *paySign;

@end
