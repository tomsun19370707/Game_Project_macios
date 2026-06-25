//
//  RoomMusicTableViewCell.h
//  miliao
//
//  Created by aa on 2019/7/16.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoomMusicModel;

@interface RoomMusicTableViewCell : UITableViewCell

@property (nonatomic , copy) void(^singleTapGestureClickBlock)(RoomMusicModel *model);
@property (nonatomic , copy) void(^playAndSuspendedClickBlock)(RoomMusicModel *model);


@property (nonatomic, strong) RoomMusicModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

