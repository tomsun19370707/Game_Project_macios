//
//  EMO_PersonalNavView.h
//  miliao
//
//  Created by 张世浩 on 2023/6/26.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_PersonalNavView : BaseView
Strong UIButton *messageBtn;
Strong UIButton *moreBtn;
Copy void (^BtnBlock)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END
