//
//  FFHomeHandel.m
//  FisheryFresh
//
//  Created by 李东阳 on 2020/6/22.
//  Copyright © 2020 云企科技. All rights reserved.
//

#import "FFHomeHandel.h"
@implementation FFHomeHandel
/** 获取房间列表*/
+ (void)requestChatRoomList:(NSMutableDictionary *)parameter success:(void(^)(NSMutableArray *dataArr,NSString *pageNo,BOOL hasNextPage) )success failure:(void(^)(void))failure
{
    [NetworkRequest POSTNew:Request_HomeSearch parmeters:parameter success:^(id responObject) {
        
        DLog(@"%@--",responObject);
        
        if ([NSString NotNull:responObject[@"data"]]) {
            NSArray *data = responObject[@"data"][@"room_list"];
            
            BOOL hasNext = NO ;
            NSString *pageNo = parameter[@"page"];
            if (data.count >= 10) {
                pageNo = [NSString stringWithFormat:@"%d",pageNo.intValue + 1] ;
                hasNext = YES;
            }else{
                hasNext = NO;
            }
            success([NSMutableArray arrayWithArray:data],pageNo,hasNext);
        }else{
            failure();
        }
        
    } failture:^(NSError *error) {
        failure();
    }];
}
/** 获取首页房间列表*/
+ (void)requestHomeChatRoomList:(NSMutableDictionary *)parameter success:(void(^)(NSMutableArray *dataArr,NSString *pageNo,BOOL hasNextPage) )success failure:(void(^)(void))failure
{
    if ([NSString NotNull:UserDefaultsGet(kToken)]) {
        parameter[@"token"] = UserDefaultsGet(kToken) ;
    }
    
    [NetworkRequest POSTNew:Request_GetRoomList parmeters:parameter success:^(id responObject) {
        
        DLog(@"%@--",responObject);
        
        if ([NSString NotNull:responObject[@"data"]]) {
            NSArray *data = responObject[@"data"];
            
            BOOL hasNext = NO ;
            NSString *pageNo = parameter[@"page"];
            if (data.count >= 10) {
                pageNo = [NSString stringWithFormat:@"%d",pageNo.intValue + 1] ;
                hasNext = YES;
            }else{
                hasNext = NO;
            }
            success([NSMutableArray arrayWithArray:data],pageNo,hasNext);
        }else{
            failure();
        }
        
    } failture:^(NSError *error) {
        failure();
    }];
}
/** 获取通用接口列表*/
+ (void)customeListRequestHandle:(NSMutableDictionary *)parameter apiStr:(NSString *)apiStr success:(void(^)(NSMutableArray *dataArr,NSString *pageNo,BOOL hasNextPage) )success failure:(void(^)(void))failure
{
    [NetworkRequest POST:apiStr parmeters:parameter success:^(id responObject) {
        
        BaseModel *baseModel = (BaseModel *)responObject;
        
        DLog(@"%@--",baseModel.data);
        
        NSMutableArray *resultList = [NSMutableArray array];
        BOOL hasNext = NO;
        NSString *pageNo = parameter[@"page"] ? [NSString stringWithFormat:@"%@", parameter[@"page"]] : @"1";
        
        if ([baseModel.data isKindOfClass:[NSArray class]]) {
            // 返回的 data 直接是数组列表 (明细接口场景)
            [resultList addObjectsFromArray:(NSArray *)baseModel.data];
        } else if ([baseModel.data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictData = (NSDictionary *)baseModel.data;
            if ([dictData[@"list"] isKindOfClass:[NSArray class]]) {
                [resultList addObjectsFromArray:dictData[@"list"]];
            } else if ([dictData[@"data"] isKindOfClass:[NSArray class]]) {
                [resultList addObjectsFromArray:dictData[@"data"]];
            } else {
                GoodCateInfo *model = [GoodCateInfo yy_modelWithJSON:baseModel.data];
                if ([model.data isKindOfClass:[NSArray class]]) {
                    [resultList addObjectsFromArray:model.data];
                }
            }
        }
        
        if (resultList.count >= 10) {
            pageNo = [NSString stringWithFormat:@"%d", pageNo.intValue + 1];
            hasNext = YES;
        } else {
            hasNext = NO;
        }
        
        success(resultList, pageNo, hasNext);
        
    } failture:^(NSError *error) {
        failure();
    }];
}

/** 不带分页的 获取通用接口列表*/
+ (void)customeNoPageListRequestHandle:(NSMutableDictionary *)parameter apiStr:(NSString *)apiStr success:(void(^)(NSMutableArray <NSDictionary *> *dataArr) )success failure:(void(^)(void))failure
{
    [NetworkRequest POST:apiStr parmeters:parameter success:^(id responObject) {
        
        BaseModel *baseModel = (BaseModel *)responObject;
        
//        DLog(@"%@--",baseModel.data);

        success(baseModel.data);
        
    } failture:^(NSError *error) {
        failure();
    }];
}

/** 不带分页的  转model 的接口  获取通用接口列表*/
+ (void)customeNoPageListRequestHandleChangeModel:(NSMutableDictionary *)parameter apiStr:(NSString *)apiStr success:(void(^)(NSMutableArray <GoodListInfoModel *> *dataArr) )success failure:(void(^)(void))failure
{
    [NetworkRequest POSTNew:apiStr parmeters:parameter success:^(id responObject) {
        
        DLog(@"%@",responObject);
        
        GoodCateInfo *model = [GoodCateInfo yy_modelWithJSON:responObject];

        success(model.data);
        
    } failture:^(NSError *error) {
        failure();
    }];
}

/** 通用操作接口*/
+ (void)customeOprHandle:(NSMutableDictionary *)parameter apiStr:(NSString *)apiStr success:(void(^)(BaseModel *info) )success failure:(void(^)(void))failure
{
//    [SVProgressHUD showLoadingHUDWithMessage:@""];
    [NetworkRequest POST:apiStr parmeters:parameter success:^(id responObject) {
        
        BaseModel *baseModel = (BaseModel *)responObject;

        success(baseModel);
        
//        [SVProgressHUD hideLoadingHUD];
    } failture:^(NSError *error) {
        failure();
//        [SVProgressHUD hideLoadingHUD];
    }];
}

/** 获取背包礼物列表*/
+ (void)fetchPackageGiftList:(NSMutableDictionary *)parameter success:(void(^)(NSMutableArray *dataArr,NSString *pageNo,BOOL hasNextPage) )success failure:(void(^)(void))failure
{
    [NetworkRequest POSTNew:user_getMyKnapsack parmeters:parameter success:^(id responObject) {
        
        DLog(@"%@--",responObject);
        
        GoodCateInfo *model = [GoodCateInfo yy_modelWithJSON:responObject];
        
        BOOL hasNext = NO ;
        NSString *pageNo = parameter[@"page"];
        if (model.data.count >= 10) {
            pageNo = [NSString stringWithFormat:@"%d",pageNo.intValue + 1] ;
            hasNext = YES;
        }else{
            hasNext = NO;
        }
        success(model.data,pageNo,hasNext);
        
    } failture:^(NSError *error) {
        failure();
    }];
}

/** 我收到和赠送的礼物列表*/  
+ (void)fetchMySendAndReceiveGiftList:(NSMutableDictionary *)parameter success:(void(^)(NSMutableArray *dataArr,NSString *pageNo,BOOL hasNextPage) )success failure:(void(^)(void))failure
{
    [NetworkRequest POSTNew:gift_getMyReceiveGift parmeters:parameter success:^(id responObject) {

        DLog(@"\ninfo :%@",responObject);

        if ([NSString NotNull:responObject[@"data"]]) {
            /** 处理数据*/
            /** para*/
            NSMutableDictionary *parame =[NSMutableDictionary dictionaryWithDictionary:responObject];
            NSArray *list = responObject[@"data"][@"list"];
            parame[@"data"] = list ;
            
            GoodCateInfo *model = [GoodCateInfo yy_modelWithJSON:parame];
            
            BOOL hasNext = NO ;
            NSString *pageNo = parameter[@"page"];
            if (model.data.count >= 10) {
                pageNo = [NSString stringWithFormat:@"%d",pageNo.intValue + 1] ;
                hasNext = YES;
            }else{
                hasNext = NO;
            }
            success(model.data,pageNo,hasNext);
        }
        
        
    } failture:^(NSError *error) {
        failure();
    }];
}

/** 获取音乐列表*/
+ (void)fetchMusicList:(NSMutableDictionary *)parameter success:(void(^)(NSMutableArray *dataArr,NSString *pageNo,BOOL hasNextPage) )success failure:(void(^)(void))failure
{
    [NetworkRequest POSTNew:user_getMusicList parmeters:parameter success:^(id responObject) {
        
        DLog(@"%@--",responObject);
        
        GoodCateInfo *model = [GoodCateInfo yy_modelWithJSON:responObject];
        
        BOOL hasNext = NO ;
        NSString *pageNo = parameter[@"page"];
        if (model.data.count >= 10) {
            pageNo = [NSString stringWithFormat:@"%d",pageNo.intValue + 1] ;
            hasNext = YES;
        }else{
            hasNext = NO;
        }
        success(model.data,pageNo,hasNext);
        
    } failture:^(NSError *error) {
        failure();
    }];
}

/** 获取轮播图列表*/
+ (void)requestLunboList:(NSMutableDictionary *)parameter success:(void(^)(NSMutableArray *dataArr,NSMutableArray *strUrlArr))success failure:(void(^)(void))failure
{
    [NetworkRequest POSTNew:index_dynamicBannerList parmeters:parameter success:^(id responObject) {
        
        DLog(@"%@--",responObject);
        
        __block NSMutableArray *arr = [NSMutableArray array];
        
        GoodCateInfo *model = [GoodCateInfo yy_modelWithJSON:responObject];
        [model.data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GoodListInfoModel *temp = obj ;
            [arr addObject:FORMAT(temp.image)];
        }];
        
        success(model.data,arr);
        
    } failture:^(NSError *error) {
        failure();
    }];
}
@end
