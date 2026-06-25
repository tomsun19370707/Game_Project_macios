//
//  CFMChatRoomSkipManager.h
//  miliao
//
//  Created by Dylan Lee on 2026/1/9.
//  Copyright © 2026 EMO. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 进入语聊房管理工具*/
#import "EMO_StartPlayViewController.h"
#import "EMO_EndPlayViewController.h"
#import "RoomPasswordView.h"

@interface CFMChatRoomSkipManager : NSObject
Strong RoomPasswordView *passWordView;
/* 设置项 */
+ (CFMChatRoomSkipManager *)shared;

/** 点击房间的判断逻辑*/
-(void)getRoomInfo:(NSDictionary *)roomInfo;
@end
