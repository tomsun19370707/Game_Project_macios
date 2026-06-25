//
//  EMO_MyGuildXQFootView.h
//  miliao
//
//  Created by ZhangShiHao on 2023/6/29.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_MyGuildXQFootView : BaseView

//Strong NSDictionary *dicData;

Assign NSInteger status;

Copy void(^BtnBlock)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END
