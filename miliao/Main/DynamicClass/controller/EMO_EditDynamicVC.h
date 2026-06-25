//
//  EMO_EditDynamicVC.h
//  miliao
//
//  Created by ZhangShiHao on 2023/8/17.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseController.h"
@class MessageInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface EMO_EditDynamicVC : BaseController

Strong MessageInfoModel *model;

Copy void(^successBlock)(void);

@end

NS_ASSUME_NONNULL_END
