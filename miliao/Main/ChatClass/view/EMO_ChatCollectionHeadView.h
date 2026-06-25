//
//  EMO_ChatCollectionHeadView.h
//  miliao
//
//  Created by 张世浩 on 2022/10/12.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_ChatCollectionHeadView : BaseView

@property (nonatomic, strong) NSMutableArray *shufflingArray;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic , copy) void(^sureClickBlock)(NSInteger index);
@property (nonatomic , copy) void(^BtnClickBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
