//
//  MLThemeGameModel.m
//  miliao
//

#import "MLThemeGameModel.h"
#import "MLNetWorkHelper.h"
#import "UserManager.h"
#import "Global.h"
#import <MJExtension/MJExtension.h>

#ifndef VERSION_HTTPS_SERVER
#define VERSION_HTTPS_SERVER @"https://cfm.yunqizhongguo.com/"
#endif

@implementation MLThemeGameModel

+ (instancetype)sharedInstance {
    static MLThemeGameModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MLThemeGameModel alloc] init];
    });
    return instance;
}

- (NSString *)currentAuthToken {
    NSString *token = UserDefaultsGet(kToken);
    if (!token || token.length == 0) {
        token = [UserManager userInfo].token;
    }
    return token ?: @"";
}

- (NSDictionary *)buildParams:(NSDictionary *)params {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString *token = [self currentAuthToken];
    if (token && token.length > 0) {
        [dict setObject:token forKey:@"token"];
    }
    return [dict copy];
}

/// 专用于发送标准的 Raw JSON Body POST 请求 (Content-Type: application/json & Header Token)
- (void)postJSONWithURL:(NSString *)urlStr
             parameters:(NSDictionary *)params
                success:(MLGameSixSuccessBlock)success
                failure:(MLGameSixFailureBlock)failure {
    
    NSString *token = [self currentAuthToken];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if (token && token.length > 0) {
        [request setValue:token forHTTPHeaderField:@"Token"];
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params ?: @{} options:0 error:&error];
    if (jsonData) {
        [request setHTTPBody:jsonData];
    }
    
#if DEBUG
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    MYLog(@"[MLThemeGameModel API Request] URL: %@, Header Token: %@, Body: %@", urlStr, token, jsonStr);
#endif
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
#if DEBUG
                MYLog(@"[MLThemeGameModel API Response Fail] Error: %@", error);
#endif
                if (failure) failure(error, error.localizedDescription);
                return;
            }
            if (!data) {
                if (failure) failure(nil, @"服务端无数据返回");
                return;
            }
            
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"code"] integerValue] == 1) {
                    if (success) success(responseObject[@"data"]);
                } else {
                    if (failure) failure(nil, responseObject[@"msg"] ?: @"请求失败");
                }
            } else {
                if (failure) failure(nil, @"数据格式错误");
            }
        });
    }];
    [task resume];
}

/// 专用于发送标准的 GET 请求 (Query Parameters & Header Token)
- (void)getJSONWithURL:(NSString *)urlStr
            parameters:(NSDictionary *)params
               success:(MLGameSixSuccessBlock)success
               failure:(MLGameSixFailureBlock)failure {
    NSString *token = [self currentAuthToken];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:urlStr];
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (params && params.count > 0) {
        for (NSString *key in params) {
            id val = params[key];
            [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:[NSString stringWithFormat:@"%@", val]]];
        }
    }
    if (queryItems.count > 0) {
        components.queryItems = queryItems;
    }
    
    NSURL *finalURL = components.URL ?: [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:finalURL];
    [request setHTTPMethod:@"GET"];
    if (token && token.length > 0) {
        [request setValue:token forHTTPHeaderField:@"Token"];
    }
    
#if DEBUG
    MYLog(@"[MLThemeGameModel GET Request] URL: %@, Header Token: %@", finalURL.absoluteString, token);
#endif
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
#if DEBUG
                MYLog(@"[MLThemeGameModel GET Response Fail] Error: %@", error);
#endif
                if (failure) failure(error, error.localizedDescription);
                return;
            }
            if (!data) {
                if (failure) failure(nil, @"服务端无数据返回");
                return;
            }
            
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"code"] integerValue] == 1) {
                    if (success) success(responseObject[@"data"]);
                } else {
                    if (failure) failure(nil, responseObject[@"msg"] ?: @"请求失败");
                }
            } else {
                if (failure) failure(nil, @"数据格式错误");
            }
        });
    }];
    [task resume];
}

- (void)fetchTowerGameSixBootstrapWithRoomId:(NSString *)roomId
                                     success:(MLGameSixSuccessBlock)success
                                     failure:(MLGameSixFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/tower_game_six/bootstrap", VERSION_HTTPS_SERVER];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (roomId) {
        [params setObject:roomId forKey:@"room_id"];
    }
    
    [self getJSONWithURL:url parameters:[self buildParams:params] success:^(id data) {
        MLTowerGameSixBootstrapModel *model = [MLTowerGameSixBootstrapModel mj_objectWithKeyValues:data];
        if (success) success(model);
    } failure:failure];
}

- (void)fetchTowerGameSixFusionCandidatesWithSuccess:(MLGameSixSuccessBlock)success
                                             failure:(MLGameSixFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/tower_game_six/fusion_candidates", VERSION_HTTPS_SERVER];
    
    [self getJSONWithURL:url parameters:[self buildParams:@{}] success:^(id data) {
        MLTowerGameSixFusionCandidateModel *model = [MLTowerGameSixFusionCandidateModel mj_objectWithKeyValues:data];
        if (success) success(model);
    } failure:failure];
}

- (void)previewTowerGameSixFusionWithItems:(NSArray<NSDictionary *> *)items
                                   success:(MLGameSixSuccessBlock)success
                                   failure:(MLGameSixFailureBlock)failure {
    [self previewTowerGameSixFusionWithItems:items ticketTypeId:0 success:success failure:failure];
}

- (void)previewTowerGameSixFusionWithItems:(NSArray<NSDictionary *> *)items
                              ticketTypeId:(NSInteger)ticketTypeId
                                   success:(MLGameSixSuccessBlock)success
                                   failure:(MLGameSixFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/tower_game_six/fusion_preview", VERSION_HTTPS_SERVER];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"items"] = items ?: @[];
    if (ticketTypeId > 0) {
        params[@"ticket_type_id"] = @(ticketTypeId);
    }
    
    [self postJSONWithURL:url parameters:params success:success failure:failure];
}

- (void)exchangeTowerGameSixTicketWithGlobalItems:(NSArray<NSDictionary *> *)globalItems
                                        tempItems:(NSArray<NSDictionary *> *)tempItems
                                     stateVersion:(NSInteger)stateVersion
                                          success:(MLGameSixSuccessBlock)success
                                          failure:(MLGameSixFailureBlock)failure {
    [self exchangeTowerGameSixTicketWithGlobalItems:globalItems tempItems:tempItems ticketTypeId:0 stateVersion:stateVersion success:success failure:failure];
}

- (void)exchangeTowerGameSixTicketWithGlobalItems:(NSArray<NSDictionary *> *)globalItems
                                        tempItems:(NSArray<NSDictionary *> *)tempItems
                                     ticketTypeId:(NSInteger)ticketTypeId
                                     stateVersion:(NSInteger)stateVersion
                                          success:(MLGameSixSuccessBlock)success
                                          failure:(MLGameSixFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/tower_game_six/exchange_ticket", VERSION_HTTPS_SERVER];
    NSString *requestId = [[NSUUID UUID] UUIDString];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"global_items"] = globalItems ?: @[];
    params[@"temp_items"] = tempItems ?: @[];
    params[@"state_version"] = @(stateVersion);
    params[@"request_id"] = requestId;
    if (ticketTypeId > 0) {
        params[@"ticket_type_id"] = @(ticketTypeId);
    }
    
    [self postJSONWithURL:url parameters:params success:success failure:failure];
}

- (void)exchangeTowerGameSixTicketWithTicketTypeId:(NSInteger)ticketTypeId
                                      stateVersion:(NSInteger)stateVersion
                                           success:(MLGameSixSuccessBlock)success
                                           failure:(MLGameSixFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/tower_game_six/exchange_ticket", VERSION_HTTPS_SERVER];
    NSString *requestId = [[NSUUID UUID] UUIDString];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"request_id"] = requestId;
    params[@"ticket_type_id"] = @(ticketTypeId);
    params[@"state_version"] = @(stateVersion);
    
    [self postJSONWithURL:url parameters:params success:success failure:failure];
}

- (void)recastTowerGameSixWithStateVersion:(NSInteger)stateVersion
                                   success:(MLGameSixSuccessBlock)success
                                   failure:(MLGameSixFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/tower_game_six/recast", VERSION_HTTPS_SERVER];
    NSString *requestId = [[NSUUID UUID] UUIDString];
    NSDictionary *params = @{
        @"state_version": @(stateVersion),
        @"request_id": requestId
    };
    
    [self postJSONWithURL:url parameters:params success:success failure:failure];
}

- (void)fetchTowerGameSixTempInventoryWithSuccess:(MLGameSixSuccessBlock)success
                                           failure:(MLGameSixFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/tower_game_six/temp_inventory", VERSION_HTTPS_SERVER];
    
    [self getJSONWithURL:url parameters:[self buildParams:@{}] success:^(id data) {
        NSArray *list = [MLCandidateItemModel mj_objectArrayWithKeyValuesArray:data];
        if (success) success(list);
    } failure:failure];
}

- (void)withdrawTowerGameSixTempGiftsWithItems:(NSArray<NSDictionary *> *)items
                                       success:(MLGameSixSuccessBlock)success
                                       failure:(MLGameSixFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/tower_game_six/withdraw", VERSION_HTTPS_SERVER];
    NSString *requestId = [[NSUUID UUID] UUIDString];
    NSDictionary *params = @{
        @"request_id": requestId,
        @"items": items ?: @[]
    };
    
    [self postJSONWithURL:url parameters:params success:success failure:failure];
}

- (void)claimTowerGameSixCurrentRewardWithTicketId:(NSInteger)ticketId
                                            drawId:(long long)drawId
                                      stateVersion:(NSInteger)stateVersion
                                           success:(MLGameSixSuccessBlock)success
                                           failure:(MLGameSixFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/tower_game_six/withdraw", VERSION_HTTPS_SERVER];
    NSString *requestId = [[NSUUID UUID] UUIDString];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"request_id"] = requestId;
    params[@"ticket_id"] = @(ticketId);
    params[@"draw_id"] = @(drawId);
    params[@"state_version"] = @(stateVersion);
    // 严格隔离：绝对不传 items 字段
    
    [self postJSONWithURL:url parameters:params success:^(id _Nullable responseObj) {
        MLTowerGameSixWithdrawResultModel *resultModel = [MLTowerGameSixWithdrawResultModel mj_objectWithKeyValues:responseObj];
        if (success) {
            success(resultModel ?: responseObj);
        }
    } failure:failure];
}

- (void)fetchTowerGameSixRecordsWithPage:(NSInteger)page
                                   limit:(NSInteger)limit
                                    type:(NSString * _Nullable)type
                                 success:(MLGameSixSuccessBlock)success
                                 failure:(MLGameSixFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/tower_game_six/records", VERSION_HTTPS_SERVER];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(page > 0 ? page : 1);
    params[@"limit"] = @(limit > 0 ? limit : 100);
    params[@"type"] = type.length > 0 ? type : @"draw";
    
    [self getJSONWithURL:url parameters:[self buildParams:params] success:^(id data) {
        if (success) success(data);
    } failure:failure];
}

@end
