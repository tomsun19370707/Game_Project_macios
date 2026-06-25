//
//  RoomPasswordView.h
//  miliao
//
//  Created by aa on 2019/7/1.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "BaseView.h"




//@class MLRoomModel;



@interface RoomPasswordView : BaseView

//@property (nonatomic , copy) void(^sendSeBlock)(MLRoomModel *model, NSString *text);
//@property (nonatomic, strong) MLRoomModel *model;

@property (nonatomic , copy) void(^sendDicSeBlock)(NSDictionary *model, NSString *text);
@property (nonatomic, strong) NSDictionary *dicModel;

@end
