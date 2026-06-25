//
//  MsgPushUtil.h
//  enjoyfun
//
//  Created by 李东阳 on 2020/4/16.
//  Copyright © 2020 锤子科技. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 跳转目标Vc*/

@interface MsgPushUtil : NSObject

/** 消息推送跳转*/
+ (void)messagePush:(NSDictionary *)userInfo ;

/** 远程推送，点击系统消息弹框后，消息跳转*/
+ (void)remoteNotificationMessagePush:(NSDictionary *)userInfo ;

@end

//以下放置到APP首页homeVc里
//[ObjectTool performSelectorAfterDelay:0.3 completion:^{
//    NSDictionary *lanch = [ObjectTool SharedSettings].launchOptions ;
//    if (lanch) {
//        /** 推送导航*/
//        [ObjectTool SharedSettings].currentVC = self ;
//        /** 远程推送消息跳转*/
//        NSMutableDictionary *remoteDic = [NSMutableDictionary dictionaryWithDictionary:[lanch objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];
//        [MsgPushUtil remoteNotificationMessagePush:remoteDic];
//        /** 启动后，再次置空*/
//        [ObjectTool SharedSettings].launchOptions = nil ;
//    }
//}];
