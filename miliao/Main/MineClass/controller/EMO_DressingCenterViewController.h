//
//  EMO_DressingCenterViewController.h
//  miliao
//
//  Created by 张世浩 on 2022/12/1.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "BaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_DressingCenterViewController : BaseController

Assign NSInteger index;
Assign NSInteger type;

@property (nonatomic , copy) void(^showImageViewBlock)(NSString * url);
- (void)refreView;
@end

NS_ASSUME_NONNULL_END
