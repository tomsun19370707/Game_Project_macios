//
//  BaseModel.h
//  oxwall
//
//  Created by ChuanQi on 2019/7/29.
//  Copyright © 2019 ChuanQi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface BaseModel : NSObject
///1-成功
@property (assign, nonatomic) NSInteger code;
@property (strong, nonatomic) NSString * msg;
@property (strong, nonatomic) id data;

@end

@interface BaseMsgModel : NSObject
@property (strong, nonatomic) NSString * msg;
@property (strong, nonatomic) NSString * exception;
@property (strong, nonatomic) NSString * message;
@property (strong, nonatomic) NSString * code;
@end

@interface RootModel : NSObject
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, assign) BOOL selected;


@end
NS_ASSUME_NONNULL_END
