//
//  MLMyMusicListVCViewController.h
//  miliao
//
//  Created by aa on 2019/7/15.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "BaseController.h"

@class RoomMusicModel;
@interface MLMyMusicListVC : BaseController <JXCategoryListContentViewDelegate>


@property (nonatomic , copy) void(^playClickBlock)(RoomMusicModel *musicModel);

@property (nonatomic, strong) RoomMusicModel *musicModel;

@end

