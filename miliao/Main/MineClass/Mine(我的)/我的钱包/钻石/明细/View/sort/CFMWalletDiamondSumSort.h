//
//  CFMWalletDiamondSumSort.h
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMWalletDiamondSumSort : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIButton *btn;

/** 选择了日期*/
@property (nonatomic,copy) void (^fetchDate)(NSString *date);
@end
