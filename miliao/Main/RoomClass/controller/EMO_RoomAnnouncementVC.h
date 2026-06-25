//
//  EMO_RoomAnnouncementVC.h
//  miliao
//
//  Created by aa on 2019/7/4.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "BaseController.h"

@interface EMO_RoomAnnouncementVC : BaseController

@property (nonatomic, strong) NSString *announcementStr;

@property (nonatomic , copy) void(^announcementStrClickBlock)(NSString *announcementStr);

@end
