//
//  CFMHomeTitle.h
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMHomeTitle : UITableViewCell
/** 设置文字内容*/
@property (nonatomic,strong) NSMutableArray *cateStrArr;

/** 选中分类index*/
@property (nonatomic,copy) void (^fetchCateClick)(NSUInteger index);
@end
