//
//  MLSessionSetTableViewCell.h
//  miliao
//
//  Created by feifei on 2019/8/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MLSessionSetTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *focusOn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

