//
//  CFMRewardPriseTitle.h
//  miliao
//
//  Created by Dylan Lee on 2025/12/31.
//  Copyright © 2025 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMRewardPriseTitle : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
/** 必传 1抽奖盘 2倍率盘*/
@property (nonatomic,assign) int cellType;
/** 图片*/
@property (nonatomic,strong) NSMutableArray *limitArr;

@property (weak, nonatomic) IBOutlet UILabel *title;

/** 点击回调*/
@property (nonatomic,copy) void (^fetchClick)(void);

@end
