//
//  EMO_PrizeResultsView.h
//  miliao
//
//  Created by ZhangShiHao on 2023/7/26.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_PrizeResultsView : BaseView

Assign NSInteger type;

Strong NSArray *arrData;

Strong UILabel *priceLabel;

@end

NS_ASSUME_NONNULL_END
