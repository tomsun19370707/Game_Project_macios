//
//  RoomGiftMessageCell.h
//  miliao
//
//  Created by aa on 2019/7/22.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLRoomMessageModel;
@interface RoomGiftMessageCell : UITableViewCell

@property (nonatomic , copy) void(^nickNameClickBlock)(UIView *containerView, NSString *text, NSRange range, CGRect rect, MLRoomMessageModel *model);

@property (nonatomic, strong) MLRoomMessageModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end

