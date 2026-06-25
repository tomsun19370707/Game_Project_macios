//
//  OMSeachCollCell.h
//  SecondTrading
//
//  Created by Dylan Lee on 2025/11/5.
//

#import <UIKit/UIKit.h>

@interface OMSeachCollCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@property (nonatomic,copy) void (^fetchDel)(void);
@end
