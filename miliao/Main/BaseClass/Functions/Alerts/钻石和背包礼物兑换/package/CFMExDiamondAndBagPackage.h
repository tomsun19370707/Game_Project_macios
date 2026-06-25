//
//  CFMExDiamondAndBagPackage.h
//  miliao
//
//  Created by Dylan Lee on 2026/1/4.
//  Copyright © 2026 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMExDiamondAndBagPackage : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
/** 图片*/
@property (nonatomic,strong) NSMutableArray *limitArr;

@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UILabel *tip;


/** 选择了礼物后*/
@property (nonatomic,copy) void (^fetchClick)(NSInteger selIndex);
@end
