//
//  RoomFloatingWindow.h
//  miliao
//
//  Created by aa on 2019/7/2.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "BaseView.h"

//悬浮球
@interface RoomFloatingWindow : BaseView

@property (nonatomic , copy) void(^muteSwitchButtonBlock)(void);
@property (nonatomic , copy) void(^shutDownButtonBlock)(void);
@property (nonatomic , copy) void(^enterTheRoomBlock)(void);

@property (weak, nonatomic) IBOutlet UIButton *muteSwitchButton;

@end
