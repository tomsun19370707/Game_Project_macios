//
//  MLUserReporTypeCell.h
//  miliao
//
//  Created by feifei on 2019/8/5.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLUserReportModel;
@interface MLUserReporTypeCell : UITableViewCell

@property (nonatomic, strong) MLUserReportModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

