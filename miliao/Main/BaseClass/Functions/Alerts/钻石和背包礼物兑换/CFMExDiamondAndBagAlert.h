//
//  CFMExDiamondAndBagAlert.h
//  miliao
//
//  Created by Dylan Lee on 2026/1/4.
//  Copyright © 2026 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMExDiamondAndBagAlert : UITableViewCell
/** alert*/
- (void)show;
- (void)showOnview:(UIView *)window;
/** 刷新通知*/
@property (nonatomic,copy) void (^fetchRefresh)(void);
@end
