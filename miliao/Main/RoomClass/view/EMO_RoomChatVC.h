//
//  EMO_RoomChatVC.h
//  miliao
//
//  Created by jkkj on 2023/11/6.
//  Copyright © 2023 EMO. All rights reserved.
//

#import <RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMO_RoomChatVC : RCConversationListViewController
Copy void(^dismisBlock)(NSString *tag,NSString *title);
@end

NS_ASSUME_NONNULL_END
