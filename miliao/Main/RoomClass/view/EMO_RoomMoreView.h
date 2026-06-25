//
//  EMO_RoomMoreView.h
//  miliao
//
//  Created by 张世浩 on 2022/10/20.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_RoomMoreView : BaseView

Copy void(^BtnClick)(NSInteger senderTag);

/** 是否是自己*/
@property (nonatomic,assign) BOOL isMe;

@end

NS_ASSUME_NONNULL_END
