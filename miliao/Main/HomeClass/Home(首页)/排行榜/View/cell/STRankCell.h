//
//  STRankCell.h
//  miliao
//
//  Created by Dylan Lee on 2025/12/10.
//  Copyright © 2025 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STRankCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rankIcon;
@property (weak, nonatomic) IBOutlet UILabel *rankNum;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *money;

@property (nonatomic,assign) NSUInteger row;

/** 0 财富榜 1魅力棒*/
@property (nonatomic,assign) int bangType;

@property (nonatomic,strong) GoodListInfoModel *model;

@end
