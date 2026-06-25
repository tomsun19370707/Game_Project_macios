//
//  EMO_EditUserMsgVC.h
//  miliao
//
//  Created by ZhangShiHao on 2023/6/27.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_EditUserMsgVC : BaseController

Assign NSInteger type;

Strong NSString *contentStr;

Copy void(^MsgBlock)(NSString *contentStr);

@end

NS_ASSUME_NONNULL_END
