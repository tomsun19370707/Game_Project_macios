//
//  EMO_RoomSetViewController.h
//  miliao
//
//  Created by aa on 2019/7/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "BaseController.h"

@interface EMO_RoomSetViewController : BaseController

@property (nonatomic , copy) void(^roomSetClickBlock)(NSMutableDictionary *setInfo);


@end
