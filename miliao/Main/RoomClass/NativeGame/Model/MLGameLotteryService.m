#import "MLGameLotteryService.h"
#import "MLNetWorkHelper.h"
#import <MJExtension.h>
#import "UserManager.h"
#import "Global.h"

// 声明全局 API 域名宏 (如果未自动引入则使用 PrefixHeader 中的全局定义)
#ifndef VERSION_HTTPS_SERVER
#define VERSION_HTTPS_SERVER @"https://cfm.yunqizhongguo.com/" // 兜底配置
#endif

static NSInteger g_poolId = 0;
static NSInteger g_poolVersion = 0;

NSString *MLFormatLargeNumber(double num) {
    if (num >= 1000000000000.0) {
        double v = num / 1000000000000.0;
        NSString *str = [NSString stringWithFormat:@"%.2f万亿", v];
        return [str stringByReplacingOccurrencesOfString:@".00" withString:@""];
    } else if (num >= 100000000.0) {
        double v = num / 100000000.0;
        NSString *str = [NSString stringWithFormat:@"%.2f亿", v];
        return [str stringByReplacingOccurrencesOfString:@".00" withString:@""];
    } else if (num >= 10000.0) {
        double v = num / 10000.0;
        NSString *str = [NSString stringWithFormat:@"%.2f万", v];
        return [str stringByReplacingOccurrencesOfString:@".00" withString:@""];
    } else {
        return [NSString stringWithFormat:@"%.0f", floor(num)];
    }
}

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
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            if (failure) failure([NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"数据格式错误"}]);
            return;
        }
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
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            if (failure) failure([NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"数据格式错误"}]);
            return;
        }
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
    [self getPrizesWithTypeId:typeId successWithInfo:^(NSArray<MLGameDrawResultModel *> *list, NSInteger luckyValue, NSInteger luckyLimit) {
        if (success) success(list);
    } failure:failure];
}

+ (void)getPrizesWithTypeId:(NSInteger)typeId 
            successWithInfo:(void(^)(NSArray<MLGameDrawResultModel *> *list, NSInteger luckyValue, NSInteger luckyLimit))success 
                    failure:(void(^)(NSError *error))failure {
    if (typeId == 11) {
        NSString *url = [NSString stringWithFormat:@"%@api/emo/lottery/current_pool", VERSION_HTTPS_SERVER];
        NSDictionary *params = @{@"type_id": @(typeId)};
        [MLNetWorkHelper GET:url parameters:[self buildParams:params] success:^(id responseObject) {
            if (![responseObject isKindOfClass:[NSDictionary class]]) {
                if (failure) failure([NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"数据格式错误"}]);
                return;
            }
            if ([responseObject[@"code"] integerValue] == 1) {
                id rawData = responseObject[@"data"];
                NSArray *itemsArray = nil;
                NSInteger luckyVal = -1;
                NSInteger luckyLim = 200;
                if ([rawData isKindOfClass:[NSDictionary class]]) {
                    if (rawData[@"lucky_value"]) luckyVal = [rawData[@"lucky_value"] integerValue];
                    if (rawData[@"lucky_limit"]) luckyLim = [rawData[@"lucky_limit"] integerValue];
                    else if (rawData[@"lucky_max"]) luckyLim = [rawData[@"lucky_max"] integerValue];
                    
                    NSDictionary *poolDict = rawData[@"pool"];
                    if (poolDict && [poolDict isKindOfClass:[NSDictionary class]]) {
                        g_poolId = [poolDict[@"pool_id"] integerValue];
                        g_poolVersion = [poolDict[@"pool_version"] integerValue];
                        itemsArray = poolDict[@"items"];
                    } else if (rawData[@"items"]) {
                        itemsArray = rawData[@"items"];
                    }
                } else if ([rawData isKindOfClass:[NSArray class]]) {
                    itemsArray = rawData;
                }
                NSArray *list = [MLGameDrawResultModel mj_objectArrayWithKeyValuesArray:itemsArray];
                if (success) success(list, luckyVal, luckyLim);
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
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@api/emo/lottery/get_prizes", VERSION_HTTPS_SERVER];
    NSDictionary *params = @{@"type_id": @(typeId)};
    [MLNetWorkHelper POST:url parameters:[self buildParams:params] success:^(id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            if (failure) failure([NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"数据格式错误"}]);
            return;
        }
        if ([responseObject[@"code"] integerValue] == 1) {
            NSArray *list = [MLGameDrawResultModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (success) success(list, -1, 200);
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
    [self drawWithTypeId:typeId times:times successResponse:^(NSArray<MLGameDrawResultModel *> *list, NSInteger totalValue, NSInteger logId, MLGameDrawResponseModel * _Nullable responseModel) {
        if (success) success(list, totalValue, logId);
    } failure:failure];
}

+ (void)drawWithTypeId:(NSInteger)typeId 
                 times:(NSInteger)times 
       successResponse:(void(^)(NSArray<MLGameDrawResultModel *> *list, NSInteger totalValue, NSInteger logId, MLGameDrawResponseModel * _Nullable responseModel))success 
               failure:(void(^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/lottery/draw", VERSION_HTTPS_SERVER];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
        @"type_id": @(typeId),
        @"times": @(times),
        @"request_id": [[NSUUID UUID] UUIDString]
    }];
    if (typeId == 11 && g_poolId > 0) {
        params[@"pool_id"] = @(g_poolId);
        params[@"pool_version"] = @(g_poolVersion);
    }
    [MLNetWorkHelper POST:url parameters:[self buildParams:params] success:^(id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            if (failure) failure([NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"数据格式错误"}]);
            return;
        }
        if ([responseObject[@"code"] integerValue] == 1) {
            NSDictionary *data = responseObject[@"data"];
            if (typeId == 11 && data[@"pool_version"]) {
                g_poolVersion = [data[@"pool_version"] integerValue];
            }
            MLGameDrawResponseModel *responseModel = [MLGameDrawResponseModel mj_objectWithKeyValues:data];
            NSArray *list = responseModel.list ?: @[];
            NSInteger totalValue = responseModel.total_value;
            NSInteger logId = responseModel.lottery_log_id;
            if (success) success(list, totalValue, logId, responseModel);
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
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            if (success) success(responseObject); // 保持原行为，兼容非Dict数据
            return;
        }
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
    [self refreshPoolWithTypeId:typeId successWithInfo:^(NSArray<MLGameDrawResultModel *> *list, NSInteger diamondCost, NSString *newDiamondBalance, NSInteger luckyValue, NSInteger luckyLimit) {
        if (success) success(list, diamondCost, newDiamondBalance);
    } failure:failure];
}

+ (void)refreshPoolWithTypeId:(NSInteger)typeId 
              successWithInfo:(void(^)(NSArray<MLGameDrawResultModel *> *list, NSInteger diamondCost, NSString *newDiamondBalance, NSInteger luckyValue, NSInteger luckyLimit))success 
                      failure:(void(^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/lottery/refresh_pool", VERSION_HTTPS_SERVER];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
        @"type_id": @(typeId),
        @"request_id": [[NSUUID UUID] UUIDString]
    }];
    if (typeId == 11 && g_poolId > 0) {
        params[@"pool_id"] = @(g_poolId);
        params[@"pool_version"] = @(g_poolVersion);
    }
    [MLNetWorkHelper POST:url parameters:[self buildParams:params] success:^(id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            if (failure) failure([NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"数据格式错误"}]);
            return;
        }
        if ([responseObject[@"code"] integerValue] == 1) {
            NSDictionary *data = responseObject[@"data"];
            id rawList = nil;
            NSInteger luckyVal = -1;
            NSInteger luckyLim = 200;
            if ([data isKindOfClass:[NSDictionary class]]) {
                if (data[@"lucky_value"]) luckyVal = [data[@"lucky_value"] integerValue];
                if (data[@"lucky_limit"]) luckyLim = [data[@"lucky_limit"] integerValue];
                else if (data[@"lucky_max"]) luckyLim = [data[@"lucky_max"] integerValue];
            }
            if (data[@"pool"] && [data[@"pool"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *poolDict = data[@"pool"];
                g_poolId = [poolDict[@"pool_id"] integerValue];
                g_poolVersion = [poolDict[@"pool_version"] integerValue];
                rawList = poolDict[@"items"];
            } else {
                rawList = data[@"list"];
            }
            NSArray *list = [MLGameDrawResultModel mj_objectArrayWithKeyValuesArray:rawList];
            NSInteger cost = [data[@"charged_cost"] integerValue] ?: [data[@"diamond_cost"] integerValue];
            NSString *balance = [NSString stringWithFormat:@"%@", data[@"lottery_coin"] ?: (data[@"diamond"] ?: @"0")];
            if (success) success(list, cost, balance, luckyVal, luckyLim);
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
    NSInteger targetTypeId = (typeId <= 0 || typeId == 7) ? 11 : typeId;
    NSDictionary *params = @{@"type_id": @(targetTypeId)};
    [MLNetWorkHelper POST:url parameters:[self buildParams:params] success:^(id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            if (success) success(responseObject); // 保持原行为，兼容非Dict
            return;
        }
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
                         requestId:(NSString *)requestId
                           success:(void(^)(BOOL isSuccess, MLGameDrawResultModel *gift, NSInteger remainCard, NSInteger remainGem, NSString *msg))success 
                           failure:(void(^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/lottery/exchange_gift", VERSION_HTTPS_SERVER];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type_id"] = @(11);
    params[@"exchange_id"] = @(exchangeId);
    params[@"card_count"] = @(cardCount);
    if (requestId.length > 0) {
        params[@"request_id"] = requestId;
    }
    
    [MLNetWorkHelper POST:url parameters:[self buildParams:params] success:^(id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            if (success) success(NO, nil, 0, 0, @"数据格式错误");
            return;
        }
        
        NSDictionary *data = responseObject[@"data"];
        BOOL isOK = NO;
        MLGameDrawResultModel *gift = nil;
        NSInteger rCard = 0;
        NSInteger rGem = 0;
        NSString *msg = responseObject[@"msg"] ?: @"";
        
        if (data && data != [NSNull null] && [data isKindOfClass:[NSDictionary class]]) {
            NSInteger codeVal = [responseObject[@"code"] integerValue];
            NSInteger succVal = [data[@"success"] integerValue];
            if (succVal <= 0) succVal = [data[@"success"] boolValue] ? 1 : 0;
            
            isOK = (codeVal == 1 && succVal == 1);
            if (data[@"gift"] && data[@"gift"] != [NSNull null] && [data[@"gift"] isKindOfClass:[NSDictionary class]]) {
                gift = [MLGameDrawResultModel mj_objectWithKeyValues:data[@"gift"]];
            }
            rCard = [data[@"remain_card_count"] integerValue];
            rGem = [data[@"remain_gem_count"] integerValue];
        }
        
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
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            if (failure) failure([NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"数据格式错误"}]);
            return;
        }
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

+ (void)getFortuneLotteryListWithSuccess:(void(^)(NSArray<MLGameLotteryInfoModel *> *list))success {
    [self getFortuneLotteryListWithSuccess:success failure:nil];
}

+ (void)getFortuneLotteryListWithSuccess:(void(^)(NSArray<MLGameLotteryInfoModel *> *list))success 
                                 failure:(void(^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/fortune/getLotteryList", VERSION_HTTPS_SERVER];
    [MLNetWorkHelper GET:url parameters:[self buildParams:@{}] success:^(id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            if (failure) failure([NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"数据格式错误"}]);
            return;
        }
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
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            if (failure) failure([NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"数据格式错误"}]);
            return;
        }
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

+ (void)getGameFourRankingWithLimit:(NSInteger)limit
                            success:(void(^)(NSArray<MLGameFourRankingUserModel *> *list))success
                            failure:(void(^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/emo/lottery/get_ranking", VERSION_HTTPS_SERVER];
    NSDictionary *params = @{
        @"limit": @(limit > 0 ? limit : 100)
    };
    [MLNetWorkHelper GET:url parameters:[self buildParams:params] success:^(id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            if (failure) failure([NSError errorWithDomain:@"MLGameLotteryServiceErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"数据格式错误"}]);
            return;
        }
        if ([responseObject[@"code"] integerValue] == 1) {
            NSArray *list = [MLGameFourRankingUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
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

@end
