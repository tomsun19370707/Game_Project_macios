//
//  EMO_AddTalkView.h
//  miliao
//
//  Created by ZhangShiHao on 2023/6/28.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_AddTalkView : BaseView

Strong NSMutableArray *selectDataArr;

Copy void(^talkBlock)(NSMutableArray *dataArr);

@end

NS_ASSUME_NONNULL_END
