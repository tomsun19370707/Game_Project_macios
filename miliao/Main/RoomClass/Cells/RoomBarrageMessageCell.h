//
//  RoomBarrageMessageCell.h
//  miliao
//
//  Created by aa on 2019/6/20.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLRoomMessageModel;

@interface RoomBarrageMessageCell : UITableViewCell


@property (nonatomic , copy) void(^nickNameClickBlock)(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect, MLRoomMessageModel *model);


@property (nonatomic, strong) MLRoomMessageModel *model;

- (void)setSystemInforms:(MLRoomMessageModel *)model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
