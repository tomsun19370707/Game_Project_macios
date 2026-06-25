//
//  RoomSetRoomAnnouncementCell.h
//  miliao
//
//  Created by aa on 2019/7/4.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomSetRoomAnnouncementCell : UITableViewCell

@property (nonatomic, strong) NSString *notice;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
