//
//  CFMultiplierGamesVC.h
//  miliao
//
//  Created by xxf on 2026/2/9.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "BaseVC.h"

#import <UIKit/UIKit.h>

@interface CFMultiplierGamesVC : UIViewController
/** 盘id，必传*/
@property (nonatomic,strong) NSString *rewardId;
/** 必传，1固定倍率  2随机倍率*/
@property (nonatomic,assign) int vcType;
- (void)showInView:(UIView *)superView;
@end
