//
//  EMO_MineTableHeadView.h
//  miliao
//
//  Created by 张世浩 on 2022/10/12.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "BaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface EMO_MineTableHeadView : BaseView
@property (nonatomic,copy) void (^BtnClick)(NSInteger senderTag);

@property (nonatomic ,strong) UserInfo *userInfoModel;

//
//Strong NSDictionary *dicData;




@end

NS_ASSUME_NONNULL_END
