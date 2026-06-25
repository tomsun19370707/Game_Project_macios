//
//  CFMHomeFlow.h
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMHomeFlow : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
/** 数据*/
@property (nonatomic,strong) NSMutableArray *limitArr;

@end
