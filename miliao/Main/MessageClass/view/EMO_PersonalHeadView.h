//
//  EMO_PersonalHeadView.h
//  miliao
//
//  Created by 张世浩 on 2023/6/25.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_PersonalHeadView : BaseView

Strong NSDictionary *dicData;
Strong NSString *level_image;
Strong NSDictionary *roomDic;//直播间名称
@end

NS_ASSUME_NONNULL_END
