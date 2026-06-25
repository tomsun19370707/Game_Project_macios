//
//  SessageSetTableViewCell.h
//  miliao
//
//  Created by feifei on 2019/8/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SessageSetTableViewCell : UITableViewCell
@property(nonatomic,copy) void(^addBlock)(BOOL addBlack);
@property (nonatomic, strong) NSString *ryUserID;
@property (nonatomic, strong) NSString *type;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

