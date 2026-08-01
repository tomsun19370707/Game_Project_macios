#import <Foundation/Foundation.h>
#import "MLGameLotteryInfoModel.h"
#import "MLGameDrawResultModel.h"

FOUNDATION_EXPORT NSString *MLFormatLargeNumber(double num);

@interface MLGameLotteryService : NSObject

+ (NSDictionary *)buildParams:(NSDictionary *)params;

/**
 1. 查询个人余额
 */
+ (void)getUserMoneyWithSuccess:(void(^)(MLGameUserMoneyModel *model))success 
                        failure:(void(^)(NSError *error))failure;

/**
 2. 查询玩法详情与钥匙余额
 */
+ (void)getRoomDetailWithTypeId:(NSInteger)typeId 
                        success:(void(^)(MLGameLotteryInfoModel *model))success 
                        failure:(void(^)(NSError *error))failure;

/**
 3. 获取奖池奖品列表
 */
+ (void)getPrizesWithTypeId:(NSInteger)typeId 
                    success:(void(^)(NSArray<MLGameDrawResultModel *> *list))success 
                    failure:(void(^)(NSError *error))failure;

/**
 4. 执行抽奖
 */
+ (void)drawWithTypeId:(NSInteger)typeId 
                 times:(NSInteger)times 
               success:(void(^)(NSArray<MLGameDrawResultModel *> *list, NSInteger totalValue, NSInteger logId))success 
               failure:(void(^)(NSError *error))failure;

/**
 5. 钻石购买钥匙
 */
+ (void)diamondChangeLotteryCoinWithDiamondCount:(NSInteger)diamonds 
                                         success:(void(^)(id responseObject))success 
                                         failure:(void(^)(NSError *error))failure;

/**
 6. 玩法1特有：手动刷新 18格奖池
 */
+ (void)refreshPoolWithTypeId:(NSInteger)typeId 
                      success:(void(^)(NSArray<MLGameDrawResultModel *> *list, NSInteger diamondCost, NSString *newDiamondBalance))success 
                      failure:(void(^)(NSError *error))failure;

/**
 7. 玩法1特有：高级兑换配置列表
 */
+ (void)exchangeConfigWithTypeId:(NSInteger)typeId 
                         success:(void(^)(id responseObject))success 
                         failure:(void(^)(NSError *error))failure;

/**
 8. 玩法1特有：执行高级兑换
 */
+ (void)exchangeGiftWithExchangeId:(NSInteger)exchangeId 
                         cardCount:(NSInteger)cardCount 
                           success:(void(^)(BOOL isSuccess, MLGameDrawResultModel *gift, NSInteger remainCard, NSInteger remainGem, NSString *msg))success 
                           failure:(void(^)(NSError *error))failure;

/**
 9. 抽奖汇总记录 (折叠明细版)
 */
+ (void)getDrawLogWithTypeId:(NSInteger)typeId 
                    userType:(NSString *)userType 
                        page:(NSInteger)page 
                    pageSize:(NSInteger)pageSize 
                     success:(void(^)(NSArray *list, NSInteger total))success 
                     failure:(void(^)(NSError *error))failure;

/**
 10. 今日运势接口
 */
+ (void)getFortuneLotteryListWithSuccess:(void(^)(NSArray<MLGameLotteryInfoModel *> *list))success 
                                 failure:(void(^)(NSError *error))failure;

/**
 11. 全服大奖公告接口
 */
+ (void)getLotteryWinLogWithTypeId:(NSInteger)typeId 
                              page:(NSInteger)page 
                          pageSize:(NSInteger)pageSize 
                           success:(void(^)(NSArray *list, NSInteger total))success 
                           failure:(void(^)(NSError *error))failure;

@end
