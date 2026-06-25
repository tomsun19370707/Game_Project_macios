//
//  EMO_CommentMoreVC.h
//  miliao
//
//  Created by ZhangShiHao on 2023/7/7.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseController.h"
@class MessageInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface EMO_CommentMoreVC : BaseController

Strong MessageInfoModel *model;

Strong NSMutableArray *reportArr;

@end

NS_ASSUME_NONNULL_END
