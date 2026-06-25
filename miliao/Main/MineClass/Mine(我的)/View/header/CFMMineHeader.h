//
//  CFMMineHeader.h
//  miliao
//
//  Created by Dylan Lee on 2025/12/6.
//  Copyright © 2025 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMMineHeader : UITableViewCell
@property (nonatomic,strong) UserInfo *model;

/** 访客数量*/
@property (nonatomic,assign) int visitToatleCount;
@end
