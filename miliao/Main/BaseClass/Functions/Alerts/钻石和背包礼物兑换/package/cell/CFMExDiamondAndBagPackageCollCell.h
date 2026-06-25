//
//  CFMExDiamondAndBagPackageCollCell.h
//  miliao
//
//  Created by Dylan Lee on 2026/1/4.
//  Copyright © 2026 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMExDiamondAndBagPackageCollCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UIImageView *bg;

/** 是否选中*/
@property (nonatomic,assign) BOOL isSel;

@property (nonatomic,strong) GoodListInfoModel *model;
@end
