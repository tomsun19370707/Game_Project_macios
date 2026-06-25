//
//  CFMWalletDiamondExGiftVie.h
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMWalletDiamondExGiftVie : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
/** 数据*/
@property (nonatomic,strong) NSMutableArray *limitArr;

/** 切换钻石 和 倍率盘*/
@property (nonatomic,copy) void (^fetchClick)(int index);

/** 选择了礼物*/
@property (nonatomic,copy) void (^fetchGiftClick)(int giftIndex);
@end
