//
//  FFHomeHandel.h
//  FisheryFresh
//
//  Created by 李东阳 on 2020/6/22.
//  Copyright © 2020 云企科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFHomeHandel : NSObject
/** 获取房间列表*/
+ (void)requestChatRoomList:(NSMutableDictionary *)parameter success:(void(^)(NSMutableArray *dataArr,NSString *pageNo,BOOL hasNextPage) )success failure:(void(^)(void))failure;

/** 获取首页房间列表*/
+ (void)requestHomeChatRoomList:(NSMutableDictionary *)parameter success:(void(^)(NSMutableArray *dataArr,NSString *pageNo,BOOL hasNextPage) )success failure:(void(^)(void))failure;

/** 获取通用接口列表*/
+ (void)customeListRequestHandle:(NSMutableDictionary *)parameter apiStr:(NSString *)apiStr success:(void(^)(NSMutableArray *dataArr,NSString *pageNo,BOOL hasNextPage) )success failure:(void(^)(void))failure;

/** 不带分页的 获取通用接口列表*/
+ (void)customeNoPageListRequestHandle:(NSMutableDictionary *)parameter apiStr:(NSString *)apiStr success:(void(^)(NSMutableArray <NSDictionary *> *dataArr) )success failure:(void(^)(void))failure;

/** 通用操作接口*/
+ (void)customeOprHandle:(NSMutableDictionary *)parameter apiStr:(NSString *)apiStr success:(void(^)(BaseModel *info) )success failure:(void(^)(void))failure;

/** 获取背包礼物列表*/
+ (void)fetchPackageGiftList:(NSMutableDictionary *)parameter success:(void(^)(NSMutableArray *dataArr,NSString *pageNo,BOOL hasNextPage) )success failure:(void(^)(void))failure;

/** 我收到和赠送的礼物列表*/  
+ (void)fetchMySendAndReceiveGiftList:(NSMutableDictionary *)parameter success:(void(^)(NSMutableArray *dataArr,NSString *pageNo,BOOL hasNextPage) )success failure:(void(^)(void))failure;

/** 获取音乐列表*/
+ (void)fetchMusicList:(NSMutableDictionary *)parameter success:(void(^)(NSMutableArray *dataArr,NSString *pageNo,BOOL hasNextPage) )success failure:(void(^)(void))failure;

/** 不带分页的  转model 的接口  获取通用接口列表*/
+ (void)customeNoPageListRequestHandleChangeModel:(NSMutableDictionary *)parameter apiStr:(NSString *)apiStr success:(void(^)(NSMutableArray <GoodListInfoModel *> *dataArr) )success failure:(void(^)(void))failure;

/** 获取轮播图列表*/
+ (void)requestLunboList:(NSMutableDictionary *)parameter success:(void(^)(NSMutableArray *dataArr,NSMutableArray *strUrlArr))success failure:(void(^)(void))failure;
@end

