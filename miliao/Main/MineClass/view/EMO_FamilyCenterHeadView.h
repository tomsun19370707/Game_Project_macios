//
//  EMO_FamilyCenterHeadView.h
//  miliao
//
//  Created by ZhangShiHao on 2023/7/4.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_FamilyCenterHeadView : BaseView

Strong NSDictionary *dicData;

Copy void (^SenderBlock)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END
