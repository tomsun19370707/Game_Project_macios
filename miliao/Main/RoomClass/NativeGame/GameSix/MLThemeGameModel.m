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

- (NSDictionary *)buildParams:(NSDictionary *)params {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString *token = [UserManager userInfo].token;
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
    
    NSString *token = [UserManager userInfo].token;
    
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

- (void)fetchTowerGameSixBootstrapWithRoomId:(NSString *)roomId
                                     success:(MLGameSixSuccessBlock)success
                                     failure:(MLGameSixFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/tower_game_six/bootstrap", VERSION_HTTPS_SERVER];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (roomId) {
        [params setObject:roomId forKey:@"room_id"];
    }
    
    [MLNetWorkHelper GET:url parameters:[self buildParams:params] success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            MLTowerGameSixBootstrapModel *model = [MLTowerGameSixBootstrapModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (success) success(model);
        } else {
            if (failure) failure(nil, responseObject[@"msg"] ?: @"初始化失败");
        }
    } failure:^(NSError *error) {
        if (failure) failure(error, error.localizedDescription);
    }];
}

- (void)fetchTowerGameSixFusionCandidatesWithSuccess:(MLGameSixSuccessBlock)success
                                             failure:(MLGameSixFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/tower_game_six/fusion_candidates", VERSION_HTTPS_SERVER];
    
    [MLNetWorkHelper GET:url parameters:[self buildParams:@{}] success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            MLTowerGameSixFusionCandidateModel *model = [MLTowerGameSixFusionCandidateModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (success) success(model);
        } else {
            if (failure) failure(nil, responseObject[@"msg"] ?: @"获取融合候选列表失败");
        }
    } failure:^(NSError *error) {
        if (failure) failure(error, error.localizedDescription);
    }];
}

- (void)previewTowerGameSixFusionWithItems:(NSArray<NSDictionary *> *)items
                                   success:(MLGameSixSuccessBlock)success
                                   failure:(MLGameSixFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/tower_game_six/fusion_preview", VERSION_HTTPS_SERVER];
    NSDictionary *params = @{@"items": items ?: @[]};
    
    [self postJSONWithURL:url parameters:params success:success failure:failure];
}

- (void)exchangeTowerGameSixTicketWithGlobalItems:(NSArray<NSDictionary *> *)globalItems
                                        tempItems:(NSArray<NSDictionary *> *)tempItems
                                     stateVersion:(NSInteger)stateVersion
                                          success:(MLGameSixSuccessBlock)success
                                          failure:(MLGameSixFailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/tower_game_six/exchange_ticket", VERSION_HTTPS_SERVER];
    NSString *requestId = [[NSUUID UUID] UUIDString];
    NSDictionary *params = @{
        @"global_items": globalItems ?: @[],
        @"temp_items": tempItems ?: @[],
        @"state_version": @(stateVersion),
        @"request_id": requestId
    };
    
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
    
    [MLNetWorkHelper GET:url parameters:[self buildParams:@{}] success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            NSArray *list = [MLCandidateItemModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (success) success(list);
        } else {
            if (failure) failure(nil, responseObject[@"msg"] ?: @"获取暂存包失败");
        }
    } failure:^(NSError *error) {
        if (failure) failure(error, error.localizedDescription);
    }];
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

@end
