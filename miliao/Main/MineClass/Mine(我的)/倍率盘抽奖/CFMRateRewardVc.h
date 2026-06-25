//
//  CFMRateRewardVc.h
//
//  类介绍说明：
//
//

#import "BaseVC.h"

#import <UIKit/UIKit.h>

@interface CFMRateRewardVc : BaseVC 
/** 盘id，必传*/
@property (nonatomic,strong) NSString *rewardId;
/** 必传，1固定倍率  2随机倍率*/
@property (nonatomic,assign) int vcType;
@end
