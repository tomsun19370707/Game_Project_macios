//
//  RunGamaResultViewController.h
//  miliao
//
//  Created by wzd on 2026-04-19.
//  Copyright © 2026 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RunGamaResultViewController : UIViewController
- (instancetype)initWithInfoDic:(NSArray *)infoDic;
@property(nonatomic, strong) NSArray *infoDic;
@property(nonatomic, strong) void (^finish)(NSDictionary *infoDic);
@property(nonatomic, strong) void (^cancel)(void);
@end

NS_ASSUME_NONNULL_END
