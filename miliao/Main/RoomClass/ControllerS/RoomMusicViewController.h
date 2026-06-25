//
//  RoomMusicViewController.h
//  miliao
//
//  Created by aa on 2019/7/10.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "BaseController.h"

@class RoomMusicModel;

@interface RoomMusicViewController : BaseController


@property (nonatomic , copy) void(^playClickBlock)(RoomMusicModel *musicModel);

@property (nonatomic, strong) RoomMusicModel *musicModel;

@end
