//
//  RoomSetRoomBgCell.h
//  miliao
//
//  Created by aa on 2019/7/4.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomSetRoomBgCell : UITableViewCell


@property (nonatomic , copy) void(^roomBgViewClickBlock)(NSDictionary *model);

@property (nonatomic, strong) NSMutableArray*bgViewArray;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
