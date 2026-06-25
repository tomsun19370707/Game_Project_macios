//
//  EMO_HomeHeadView.h
//  miliao
//
//  Created by 张世浩 on 2023/6/16.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_HomeHeadView : BaseView
Copy void(^SenderBlock)(NSInteger tag);

-(void)freshData;


@end

NS_ASSUME_NONNULL_END
