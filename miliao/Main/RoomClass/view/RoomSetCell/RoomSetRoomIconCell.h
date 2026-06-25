//
//  RoomSetRoomIconCell.h
//  miliao
//
//  Created by aa on 2019/7/4.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomSetRoomIconCell : UITableViewCell


@property (nonatomic, strong) UIImageView *roomIcon;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
