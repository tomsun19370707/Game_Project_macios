//
//  CFMRateRewardInput.h
//  miliao
//
//  Created by Dylan Lee on 2026/1/6.
//  Copyright © 2026 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMRateRewardInput : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *inputBg;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UIButton *exBtn;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *balanceWid;
/** 刷新通知*/
@property (nonatomic,copy) void (^fetchRefresh)(void);
@end
