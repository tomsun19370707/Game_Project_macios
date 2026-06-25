//
//  EMO_RoomTopView.h
//  miliao
//
//  Created by 张世浩 on 2022/10/19.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_RoomTopView : BaseView
Strong UIButton *hotBtn;

@property (nonatomic , copy) void(^BtnClickBlock)(NSInteger index);

Strong NSDictionary *dicData;

- (void)loadData;

/** 设置id*/
@property (nonatomic,strong) NSString *uidSet;

@end

NS_ASSUME_NONNULL_END
