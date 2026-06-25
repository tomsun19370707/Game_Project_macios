//
//  RoomSetRoomPWCell.h
//  miliao
//
//  Created by aa on 2019/7/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomSetRoomPWCell : UITableViewCell


@property (nonatomic, strong) NSString *passwordTX;

@property (nonatomic , copy) void(^passwordTXClickBlock)(NSString *passwordTX);


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
