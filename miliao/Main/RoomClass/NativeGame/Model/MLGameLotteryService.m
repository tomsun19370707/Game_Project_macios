#import "MLGameLotteryService.h"
#import "MLNetWorkHelper.h"
#import <MJExtension.h>
#import "UserManager.h"

// 声明全局 API 域名宏 (如果未自动引入则使用 PrefixHeader 中的全局定义)
#ifndef VERSION_HTTPS_SERVER
#define VERSION_HTTPS_SERVER @"https://cfm.yunqizhongguo.com/" // 兜底配置
#endif

@implementation MLGameLotteryService

+ (NSDictionary *)buildParams:(NSDictionary *)params {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    if ([UserManager userInfo].token) {
        [dict setObject:[UserManager userInfo].token forKey:@"token"];
    }
    return [dict copy];
}

+ (void)getUserMoneyWithSuccess:(void(^)(MLGameUserMoneyModel *model))success 
                        failure:(void(^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/user/getMoney", VERSION_HTTPS_SERVER];
    [MLNetWorkHelper POST:url parameters:[self buildParams:@{}] success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            MLGameUserMoneyModel *model = [MLGameUserMoneyModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (success) success(model);
        } else {
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" 
                                                     code:[responseObject[@"code"] integerValue] 
                                                 userInfo:@{NSLocalizedDescriptionKey: responseObject[@"msg"] ?: @"请求失败"}];
                failure(error);
            }
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+ (void)getRoomDetailWithTypeId:(NSInteger)typeId 
                        success:(void(^)(MLGameLotteryInfoModel *model))success 
                        failure:(void(^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/lottery/get_room_detail", VERSION_HTTPS_SERVER];
    NSDictionary *params = @{@"id": @(typeId)};
    [MLNetWorkHelper POST:url parameters:[self buildParams:params] success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            MLGameLotteryInfoModel *model = [MLGameLotteryInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (success) success(model);
        } else {
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" 
                                                     code:[responseObject[@"code"] integerValue] 
                                                 userInfo:@{NSLocalizedDescriptionKey: responseObject[@"msg"] ?: @"请求失败"}];
                failure(error);
            }
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+ (void)getPrizesWithTypeId:(NSInteger)typeId 
                    success:(void(^)(NSArray<MLGameDrawResultModel *> *list))success 
                    failure:(void(^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/lottery/get_prizes", VERSION_HTTPS_SERVER];
    NSDictionary *params = @{@"type_id": @(typeId)};
    [MLNetWorkHelper POST:url parameters:[self buildParams:params] success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            NSArray *list = [MLGameDrawResultModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (success) success(list);
        } else {
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" 
                                                     code:[responseObject[@"code"] integerValue] 
                                                 userInfo:@{NSLocalizedDescriptionKey: responseObject[@"msg"] ?: @"请求失败"}];
                failure(error);
            }
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+ (void)drawWithTypeId:(NSInteger)typeId 
                 times:(NSInteger)times 
               success:(void(^)(NSArray<MLGameDrawResultModel *> *list, NSInteger totalValue, NSInteger logId))success 
               failure:(void(^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/lottery/draw", VERSION_HTTPS_SERVER];
    NSDictionary *params = @{
        @"type_id": @(typeId),
        @"times": @(times)
    };
    [MLNetWorkHelper POST:url parameters:[self buildParams:params] success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *list = [MLGameDrawResultModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
            NSInteger totalValue = [data[@"total_value"] integerValue];
            NSInteger logId = [data[@"lottery_log_id"] integerValue];
            if (success) success(list, totalValue, logId);
        } else {
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" 
                                                     code:[responseObject[@"code"] integerValue] 
                                                 userInfo:@{NSLocalizedDescriptionKey: responseObject[@"msg"] ?: @"请求失败"}];
                failure(error);
            }
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+ (void)diamondChangeLotteryCoinWithDiamondCount:(NSInteger)diamonds 
                                         success:(void(^)(id responseObject))success 
                                         failure:(void(^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/user/diamondChangeLotteryCoin", VERSION_HTTPS_SERVER];
    NSDictionary *params = @{@"diamond": @(diamonds)};
    [MLNetWorkHelper POST:url parameters:[self buildParams:params] success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if (success) success(responseObject[@"data"]);
        } else {
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" 
                                                     code:[responseObject[@"code"] integerValue] 
                                                 userInfo:@{NSLocalizedDescriptionKey: responseObject[@"msg"] ?: @"请求失败"}];
                failure(error);
            }
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+ (void)refreshPoolWithTypeId:(NSInteger)typeId 
                      success:(void(^)(NSArray<MLGameDrawResultModel *> *list, NSInteger diamondCost, NSString *newDiamondBalance))success 
                      failure:(void(^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/lottery/refresh_pool", VERSION_HTTPS_SERVER];
    NSDictionary *params = @{@"type_id": @(typeId)};
    [MLNetWorkHelper POST:url parameters:[self buildParams:params] success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *list = [MLGameDrawResultModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
            NSInteger cost = [data[@"diamond_cost"] integerValue];
            NSString *balance = [NSString stringWithFormat:@"%@", data[@"diamond"]];
            if (success) success(list, cost, balance);
        } else {
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" 
                                                     code:[responseObject[@"code"] integerValue] 
                                                 userInfo:@{NSLocalizedDescriptionKey: responseObject[@"msg"] ?: @"请求失败"}];
                failure(error);
            }
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+ (void)exchangeConfigWithTypeId:(NSInteger)typeId 
                          success:(void(^)(id responseObject))success 
                          failure:(void(^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/lottery/exchange_config", VERSION_HTTPS_SERVER];
    NSDictionary *params = @{@"type_id": @(typeId)};
    [MLNetWorkHelper POST:url parameters:[self buildParams:params] success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if (success) success(responseObject[@"data"]);
        } else {
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" 
                                                     code:[responseObject[@"code"] integerValue] 
                                                 userInfo:@{NSLocalizedDescriptionKey: responseObject[@"msg"] ?: @"请求失败"}];
                failure(error);
            }
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+ (void)exchangeGiftWithExchangeId:(NSInteger)exchangeId 
                         cardCount:(NSInteger)cardCount 
                           success:(void(^)(BOOL isSuccess, MLGameDrawResultModel *gift, NSInteger remainCard, NSInteger remainGem, NSString *msg))success 
                           failure:(void(^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/lottery/exchange_gift", VERSION_HTTPS_SERVER];
    NSDictionary *params = @{
        @"exchange_id": @(exchangeId),
        @"card_count": @(cardCount)
    };
    [MLNetWorkHelper POST:url parameters:[self buildParams:params] success:^(id responseObject) {
        // 特殊业务，当 code == 1 且 success == true 代表成功兑换；其余情况下返回 data 并提示
        NSDictionary *data = responseObject[@"data"];
        BOOL isOK = [responseObject[@"code"] integerValue] == 1 && [data[@"success"] boolValue];
        MLGameDrawResultModel *gift = nil;
        if (data[@"gift"] && data[@"gift"] != [NSNull null]) {
            gift = [MLGameDrawResultModel mj_objectWithKeyValues:data[@"gift"]];
        }
        NSInteger rCard = [data[@"remain_card_count"] integerValue];
        NSInteger rGem = [data[@"remain_gem_count"] integerValue];
        NSString *msg = responseObject[@"msg"] ?: @"";
        if (success) {
            success(isOK, gift, rCard, rGem, msg);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+ (void)getDrawLogWithTypeId:(NSInteger)typeId 
                    userType:(NSString *)userType 
                        page:(NSInteger)page 
                    pageSize:(NSInteger)pageSize 
                     success:(void(^)(NSArray *list, NSInteger total))success 
                     failure:(void(^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/lottery/draw_log", VERSION_HTTPS_SERVER];
    NSDictionary *params = @{
        @"type_id": @(typeId),
        @"user_type": userType ?: @"all",
        @"page": @(page),
        @"page_size": @(pageSize)
    };
    [MLNetWorkHelper POST:url parameters:[self buildParams:params] success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *list = data[@"data"];
            NSInteger total = [data[@"total"] integerValue];
            if (success) success(list, total);
        } else {
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" 
                                                      code:[responseObject[@"code"] integerValue] 
                                                  userInfo:@{NSLocalizedDescriptionKey: responseObject[@"msg"] ?: @"请求失败"}];
                failure(error);
            }
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+ (void)getFortuneLotteryListWithSuccess:(void(^)(NSArray<MLGameLotteryInfoModel *> *list))success 
                                 failure:(void(^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/fortune/getLotteryList", VERSION_HTTPS_SERVER];
    [MLNetWorkHelper GET:url parameters:[self buildParams:@{}] success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            NSArray *list = [MLGameLotteryInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (success) success(list);
        } else {
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" 
                                                     code:[responseObject[@"code"] integerValue] 
                                                 userInfo:@{NSLocalizedDescriptionKey: responseObject[@"msg"] ?: @"请求失败"}];
                failure(error);
            }
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+ (void)getLotteryWinLogWithTypeId:(NSInteger)typeId 
                              page:(NSInteger)page 
                          pageSize:(NSInteger)pageSize 
                           success:(void(^)(NSArray *list, NSInteger total))success 
                           failure:(void(^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/lottery/win_log", VERSION_HTTPS_SERVER];
    NSDictionary *params = @{
        @"type_id": @(typeId),
        @"type": @"real",
        @"user_type": @"all",
        @"page": @(page),
        @"page_size": @(pageSize)
    };
    [MLNetWorkHelper POST:url parameters:[self buildParams:params] success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *list = data[@"data"];
            NSInteger total = [data[@"total"] integerValue];
            if (success) success(list, total);
        } else {
            if (failure) {
                NSError *error = [NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" 
                                                     code:[responseObject[@"code"] integerValue] 
                                                 userInfo:@{NSLocalizedDescriptionKey: responseObject[@"msg"] ?: @"请求失败"}];
                failure(error);
            }
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

@end
