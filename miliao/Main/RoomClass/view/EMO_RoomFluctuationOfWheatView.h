//
//  EMO_RoomFluctuationOfWheatView.h
//  miliao
//
//  Created by feifei on 2019/9/2.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "BaseView.h"

@class MLRoomAdminModel;
@interface EMO_RoomFluctuationOfWheatView : BaseView


@property (nonatomic, strong) NSArray *mic_user;
@property (nonatomic, strong) NSArray *room_user;
@property (nonatomic, strong) NSArray *searchArry;

@property (nonatomic , copy) void(^searchButtonClickBlock)(NSString *userid);

@property (nonatomic , copy) void(^quDingButtonClickBlock)(MLRoomAdminModel *model);

@property (nonatomic, assign) BOOL isSearch;


@end


