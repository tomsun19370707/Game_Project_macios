//
//  EMO_MyMoneyHeadView.h
//  miliao
//
//  Created by 张世浩 on 2022/10/15.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_MyMoneyHeadView : BaseView

Assign NSInteger type;

Strong UILabel *moneyLabel;
@property(nonatomic,copy) void (^BtnBlick)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END
