//
//  CFMWalletDiamondExReCoinInput.h
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMWalletDiamondExReCoinInput : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UILabel *tip;
@property (strong, nonatomic) UIButton *exchangeAllBtn;

@end
