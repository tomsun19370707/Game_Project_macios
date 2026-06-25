//
//  EMO_SearchFriendsTableViewCell.h
//  miliao
//
//  Created by aa on 2019/7/24.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class EMO_FriendsModel;
@interface EMO_SearchFriendsTableViewCell : UITableViewCell

//@property (nonatomic, strong) EMO_FriendsModel *model;

@property (nonatomic, strong) NSDictionary *model;

@property (nonatomic , copy) void(^iconImageClickBlock)(NSDictionary *model);
@property (nonatomic , copy) void(^quDingButtonClickBlock)(NSDictionary *model,UIButton * sender);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

