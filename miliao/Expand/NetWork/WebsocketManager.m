//
//  WebsocketManager.m
//  WebsocketDemo
//
//  Created by nyl on 2019/4/11.
//  Copyright © 2019年 nieyinlong. All rights reserved.
//

#import "WebSocketManager.h"
#import "SRWebSocket.h"
#import <AFNetworking.h>
@interface WebsocketManager()<SRWebSocketDelegate>

//@property (nonatomic, strong) SRWebSocket *socket;
/** 当前发送出去的msg*/
@property (nonatomic, strong) NSDictionary *currentSendDic;
/** 是否主动关闭长链接*/
@property (nonatomic, assign) BOOL isActivelyClose;
@property (nonatomic, strong) NSTimer *networkCheckTimer;
@property (nonatomic, assign) NSInteger reConnectCount;
@property (nonatomic, strong) NSTimer *reConnectTimer;

@end

@implementation WebsocketManager

static WebsocketManager *instance = nil;

+ (WebsocketManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WebsocketManager alloc] init];
    });
    return instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}
- (id)copyWithZone:(NSZone *)zone {
    return instance;
}

- (NSString *)returnJSONStringWithDictionary:(NSDictionary *)dictionary{
    
    //系统自带
    
    //    NSError * error;
    
    //    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&error];
    
    //    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //自定义
    
    NSString *jsonStr = @"{";
    
    NSArray * keys = [dictionary allKeys];
    
    for (NSString * key in keys) {
        
        jsonStr = [NSString stringWithFormat:@"%@\"%@\":\"%@\",",jsonStr,key,[dictionary objectForKey:key]];
        
    }
    
    jsonStr = [NSString stringWithFormat:@"%@%@",[jsonStr substringWithRange:NSMakeRange(0, jsonStr.length-1)],@"}"];
    
    return jsonStr;
    
}

- (void)connectWebSocket {
    self.isActivelyClose = NO;

    NSString *wsUrlStr = @"ws://47.101.147.81:9090/ws";
    self.socket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:wsUrlStr]];
    self.socket.delegate = self;
    [self.socket open];
        
}
- (void)closeWebSocketActively {
//    self.isActivelyClose = YES;
    self.reConnectCount = 0;
    [self destoryNetWorkCheckingTimer];
    [self endReConnectTimer];
    [self closeWebSocket];
}

- (void)closeWebSocket {
    if (self.socket) {
        [self.socket close];
        self.socket.delegate = nil;
        self.socket = nil;
    }
}

- (void)reConnectWebSocket {
//    if (self.socket.readyState == SR_OPEN) { return; }
//    if (self.reConnectCount <= 5) {
//        [self connectWebSocket];
//        self.reConnectCount++;
//    } else {
//        // 重连5次失败则用定时器进行重连
//        self.reConnectTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(actionReConnectTimer) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:self.reConnectTimer forMode:NSDefaultRunLoopMode];
//    }
}


// 网络监测
- (void)startNetWorkStartChekingTimer {
    [self destoryNetWorkCheckingTimer];
    self.networkCheckTimer = [NSTimer scheduledTimerWithTimeInterval:1.3 target:self selector:@selector(actionNetWorkChecking) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.networkCheckTimer forMode:NSDefaultRunLoopMode];
}
- (void)destoryNetWorkCheckingTimer {
    if (self.networkCheckTimer) {
        [self.networkCheckTimer invalidate];
        self.networkCheckTimer = nil;
    }
}

- (void)actionNetWorkChecking {
    //有网络
    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable) {
        //关闭网络检测定时器
        [self destoryNetWorkCheckingTimer];
        //开始重连
        [self reConnectWebSocket];
    } else {
        NSLog(@"⚠️⚠️没有网络");
    }
}

- (void)endReConnectTimer {
    if (self.reConnectTimer) {
        [self.reConnectTimer invalidate];
        self.reConnectTimer = nil;
    }
}

- (void)actionReConnectTimer {
    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable) {
        [self connectWebSocket];
    }
}


//// 发送一条消息
//- (void)sendMsg:(NSDictionary *)msg{
////    NSDictionary *requestDic = @{@"text": msg, @"detailID": [NSString stringWithFormat:@"%@", detailID]};
//
//   NSDictionary *dic = @{@"action":@"sendallmessage",@"homeid":@"1",@"content":[msg modelToJSONString]};
//    [self.socket sendString:[dic modelToJSONString] error:nil];
//}


//- (void)sendData:(id)data {
//    if (!data) { return; }
//    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
////        [SVProgressHUD showErrorWithStatus:@"您的网络已断开!"];
//        NSLog(@"您的网络已断开!");
//        [self startNetWorkStartChekingTimer];
//        return;
//    }
//
//    if (!self.socket || self.socket.readyState == SR_CLOSED || self.socket.readyState == SR_CLOSING) {
//        [self reConnectWebSocket];
//        return;
//    }
//
//    if (self.socket.readyState == SR_OPEN) {
//        [SVProgressHUD show];
//        [self.socket send:[data modelToJSONString]];
//    }
//}

#pragma mark - SRWebSocketDelegate
-(void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"✅✅打开socket");
    
    [self endReConnectTimer];
    [self destoryNetWorkCheckingTimer];
//    [self.socket sendString:@"action=sendallmessage&content=1" error:nil];
    
//    [self.socket sendString:@"ssssssssss" error:nil];
//    [SVProgressHUD showSuccessWithStatus:@"连接成功"];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:@"reg" forKey:@"action"];
    [dictionary setValue:@"1" forKey:@"homeid"];
    [dictionary setValue:@"1" forKey:@"content"];
    NSLog(@"=======dic = %@",dictionary);
    NSLog(@"------json-----%@",[self returnJSONStringWithDictionary:dictionary]);
    [self.socket sendString:[dictionary modelToJSONString] error:nil];
    NSLog(@"链接成功！");
}

-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSDictionary *dic = [self dictionaryWithJsonString:message];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"socketNotification" object:nil];
    if ([dic[@"code"] isEqualToString:@"202"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"socketNotification" object:nil userInfo:[self dictionaryWithJsonString:dic[@"data"]]];
    }
    NSLog(@"✅✅✅✅✅✅----%@", message);
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"❌❌socket连接失败 = %@", error);
    [SVProgressHUD dismiss];
    if (self.isActivelyClose) {
        return;
    }
    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [self startNetWorkStartChekingTimer];//开启网络检测
    } else {
        [self reConnectWebSocket];
    }
}

-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"❌❌socket失去连接 = %@", reason);
//    [SVProgressHUD dismiss];
//    if (self.isActivelyClose) {
//        return;
//    }
//    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
//        [self startNetWorkStartChekingTimer];//开启网络检测
//    } else {
//        [self reConnectWebSocket];
//    }
}
@end

