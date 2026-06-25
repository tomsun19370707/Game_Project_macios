//
//  EMO_PaymentView.h
//  miliao
//
//  Created by 张世浩 on 2022/10/17.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_PaymentView : BaseView

Assign NSInteger type;

@property (nonatomic,copy)void(^payTypeBlock)(NSInteger type);

@end

NS_ASSUME_NONNULL_END
