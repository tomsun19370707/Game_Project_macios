//
//  RoomSearchView.h
//  miliao
//
//  Created by aa on 2019/7/4.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "BaseView.h"

@interface RoomSearchView : BaseView

@property (nonatomic , copy) void(^quDingButtonClickBlock)(NSString *textTF);


@property (nonatomic, strong) UITextField *searchTF;


@end
