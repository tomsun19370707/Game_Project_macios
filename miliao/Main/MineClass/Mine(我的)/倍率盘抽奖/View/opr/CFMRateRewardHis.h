//
//  CFMRateRewardHis.h
//  miliao
//
//  Created by Dylan Lee on 2026/1/6.
//  Copyright © 2026 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMRateRewardHis : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *cjBtn;
@property (weak, nonatomic) IBOutlet UIButton *zjBtn;
@property (weak, nonatomic) IBOutlet UIButton *cyBtn;
/** 房间详情*/
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *ID;
@end
