//
//  RoomSetRoomNameCell.h
//  miliao
//
//  Created by aa on 2019/7/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomSetRoomNameCell : UITableViewCell

@property (nonatomic, strong) NSString *textTF;

@property (nonatomic , copy) void(^nickNameClickBlock)(NSString *text);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
