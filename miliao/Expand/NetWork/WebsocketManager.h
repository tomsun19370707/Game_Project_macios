//
//  WebsocketManager.h
//  WebsocketDemo
//
//  Created by nyl on 2019/4/11.
//  Copyright © 2019年 nieyinlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketRocket.h"
//#import <SRWebSocket.h>
NS_ASSUME_NONNULL_BEGIN

@interface WebsocketManager : NSObject

@property (nonatomic, strong) SRWebSocket *socket;

+ (WebsocketManager *)shareManager;
- (void)connectWebSocket;
- (void)closeWebSocketActively;
- (void)sendMsg:(NSDictionary *)msg;

@end

NS_ASSUME_NONNULL_END
