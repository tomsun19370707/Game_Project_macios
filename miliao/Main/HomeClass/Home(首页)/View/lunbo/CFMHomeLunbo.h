//
//  CFMHomeLunbo.h
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMHomeLunbo : UITableViewCell
@property (nonatomic,strong) SDCycleScrollView *cycleImageView ;

/** 轮播数据，用于跳转*/
@property (nonatomic,strong) NSMutableArray<NSDictionary *> *lunboData;
/** 头条数据*/
@property (nonatomic,strong) NSMutableArray<NSDictionary *> *noticeData;
@end
