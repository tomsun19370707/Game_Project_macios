//
//  CFMMyBagExCoinInput.h
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMMyBagExCoinInput : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *avaNum;
@property (weak, nonatomic) IBOutlet UITextField *tf;

@property (nonatomic,strong) GoodListInfoModel *model;
@end
