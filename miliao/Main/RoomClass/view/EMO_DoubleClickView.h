//
//  EMO_DoubleClickView.h
//  miliao
//
//  Created by ZhangShiHao on 2023/7/28.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_DoubleClickView : BaseView

Assign NSInteger num;

Copy void (^numBlock)(NSInteger num);

@end

NS_ASSUME_NONNULL_END
