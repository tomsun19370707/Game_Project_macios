//
//  CFMRewardHistoryAlert.h
//  miliao
//
//  Created by Dylan Lee on 2025/12/31.
//  Copyright © 2025 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMRewardHistoryAlert : UITableViewCell
/** 必传，1抽奖盘  2倍率盘*/
@property (nonatomic,assign) int panType;
/** 盘id， 必传*/
@property (nonatomic,strong) NSString *rewardId;
/** 必传 1中奖记录 2参与记录*/
@property (nonatomic,assign) int vcType;

/** alert*/
- (void)show;
@end
