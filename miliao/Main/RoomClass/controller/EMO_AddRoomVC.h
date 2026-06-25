//
//  EMO_AddRoomVC.h
//  miliao
//
//  Created by jkkj on 2024/1/19.
//  Copyright © 2024 EMO. All rights reserved.
//

#import "BaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_AddRoomVC : BaseController
@property (nonatomic , copy) void(^roomSetClickBlock)(NSMutableDictionary *setInfo);
@end

NS_ASSUME_NONNULL_END
