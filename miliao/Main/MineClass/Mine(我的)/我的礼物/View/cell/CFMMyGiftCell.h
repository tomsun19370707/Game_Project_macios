//
//  CFMMyGiftCell.h
//  miliao
//
//  Created by Dylan Lee on 2025/12/8.
//  Copyright © 2025 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMMyGiftCell : UITableViewCell
/** 0 我收到的 1 我赠送的*/
@property (nonatomic,assign) int oprIndex;
@property (nonatomic,strong) GoodListInfoModel *model;
@end
