//
//  RunGamaViewController.h
//  miliao
//
//  Created by wzd on 2026-04-08.
//  Copyright © 2026 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGAPlayer.h"
NS_ASSUME_NONNULL_BEGIN

@interface RunGamaViewController : UIViewController<SVGAPlayerDelegate>
- (instancetype)initWithInfoDic:(NSDictionary *)infoDic;
@property(nonatomic, strong) NSDictionary *infoDic;
@property(nonatomic, strong) void (^finish)(NSDictionary *infoDic);
@property(nonatomic, strong) void (^cancel)(void);
@end
@interface RunGameButton : UIButton
@property (nonatomic, strong) NSString * type, *itemId,*amount;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) void (^cancelClick)(RunGameButton *btn);
@end
NS_ASSUME_NONNULL_END
