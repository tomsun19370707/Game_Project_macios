//
//  EMO_MLRoomNewVC.h
//  miliao
//
//  Created by ZhangShiHao on 2023/7/7.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseController.h"
@class RoomFloatingWindow;

NS_ASSUME_NONNULL_BEGIN

@interface EMO_MLRoomNewVC : BaseController

//上个页面的dic参数，用来刷新直播间信息
//@property (nonatomic, strong) NSDictionary                          *roomInformationDic;//


@property (nonatomic, strong) RoomFloatingWindow                    *floatingWindow;

@property (nonatomic, strong) NSDictionary  *gameData;


@end

NS_ASSUME_NONNULL_END
