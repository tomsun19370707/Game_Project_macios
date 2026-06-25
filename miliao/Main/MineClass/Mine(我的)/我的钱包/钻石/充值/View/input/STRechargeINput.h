//
//  STRechargeINput.h
//  SecondTrading
//
//  Created by Dylan on 2025/10/25.
//

#import <UIKit/UIKit.h>

@interface STRechargeINput : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
/** 数据*/
@property (nonatomic,strong) NSMutableArray *limitArr;

/** 选择的金额*/
@property (nonatomic,copy) void (^fetchMoneyDone)(NSDictionary *model);
@end
