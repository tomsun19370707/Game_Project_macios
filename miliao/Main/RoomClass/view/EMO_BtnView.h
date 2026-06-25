//
//  EMO_BtnView.h
//  miliao
//
//  Created by 张世浩 on 2022/10/25.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_BtnView : BaseView

@property(nonatomic,copy) void(^BtnBlock)(NSInteger tag);
Strong UIImageView *iconImgView;
Strong UILabel *nameLabel;
Strong UIButton *ClickBtn;

Assign NSInteger imgTop;
Assign NSInteger labelBottom;

@end

NS_ASSUME_NONNULL_END
