//
//  CFMWalletCell.h
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMWalletCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@end
