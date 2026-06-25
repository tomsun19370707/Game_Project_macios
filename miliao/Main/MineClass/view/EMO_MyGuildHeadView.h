//
//  EMO_MyGuildHeadView.h
//  miliao
//
//  Created by 张世浩 on 2022/10/18.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_MyGuildHeadView : BaseView


@property(nonatomic,copy) void(^BtnBlock)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END
