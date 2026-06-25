//
//  STRechargeINputCollCell.h
//  SecondTrading
//
//  Created by Dylan on 2025/10/25.
//

#import <UIKit/UIKit.h>

@interface STRechargeINputCollCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab;

@property (nonatomic,assign) BOOL isSel;

/** 信息*/
@property (nonatomic,strong) NSDictionary *model;
@end
