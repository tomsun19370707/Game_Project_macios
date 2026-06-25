//
//  AFmanager.m
//  FaceShow
//
//  Created by skyz on 2018/6/9.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import "AFmanager.h"

@implementation AFmanager
+(AFHTTPSessionManager *)shareManager {
   static AFHTTPSessionManager *manager=nil;
   dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      manager = [AFHTTPSessionManager manager];
//       manager.responseSerializer = [AFJSONResponseSerializer serializer];
//       manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"text/html",@"application/json",@"text/plain", nil];
//      [manager.requestSerializer  setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
      // manager.requestSerializer = [AFJSONRequestSerializer serializer];
      // manager.responseSerializer = [AFJSONResponseSerializer serializer];
   });
   return manager;
}
@end
