//
//  EMO_UserInfoView.h
//  miliao
//
//  Created by 张世浩 on 2022/10/21.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "BaseView.h"
@class MLRoomUserModel;
NS_ASSUME_NONNULL_BEGIN

@interface EMO_UserInfoView : BaseView


@property (nonatomic , copy) void(^personalBtnClickBlock)(MLRoomUserModel *model,NSInteger tag);

@property (nonatomic, strong) MLRoomUserModel *model;


@end

NS_ASSUME_NONNULL_END
