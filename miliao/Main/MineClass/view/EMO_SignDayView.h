//
//  EMO_SignDayView.h
//  miliao
//
//  Created by ZhangShiHao on 2023/6/30.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_SignDayView : BaseView

Strong NSDictionary *dicData;

Copy void(^SignBlock)(NSDictionary *dic);

@end

NS_ASSUME_NONNULL_END
