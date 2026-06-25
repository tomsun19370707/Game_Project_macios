//
//  RunGamaRuleViewController.h
//  miliao
//
//  Created by wzd on 2026-04-16.
//  Copyright © 2026 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RunGamaRuleViewController : UIViewController
- (instancetype)initWithInfoDic:(NSDictionary *)infoDic;
@property(nonatomic, strong) NSDictionary *infoDic;
@property(nonatomic, strong) void (^finish)(NSDictionary *infoDic);
@property(nonatomic, strong) void (^cancel)(void);
@end

NS_ASSUME_NONNULL_END
