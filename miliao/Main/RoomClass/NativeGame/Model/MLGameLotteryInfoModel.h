#import <Foundation/Foundation.h>

#pragma mark - MLGameLotteryOptModel (价格档位)
@interface MLGameLotteryOptModel : NSObject
@property (nonatomic, assign) NSInteger nums;
@property (nonatomic, assign) NSInteger coin_cost; // 对应钥匙消耗
@end

#pragma mark - MLGameLotteryInfoModel (玩法详情)
@interface MLGameLotteryInfoModel : NSObject
@property (nonatomic, assign) NSInteger typeId; // 对应 id
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *content; // 玩法规则文本说明
@property (nonatomic, strong) NSArray<MLGameLotteryOptModel *> *coin_cost_opt;
@property (nonatomic, assign) NSInteger lottery_coin; // 当前玩法的钥匙余额
@property (nonatomic, assign) NSInteger lucky; // 玩法保底寻梦值
@property (nonatomic, assign) NSInteger profit_rate; // 运势收益率，例如 1000 表示 1000%
@property (nonatomic, assign) NSInteger consume_diamonds; // 今日消耗钻石数
@property (nonatomic, assign) NSInteger produce_diamonds; // 今日产出钻石数
@property (nonatomic, assign) NSInteger coin_cost; // 对应钥匙消耗数
- (NSString *)imageUrl;
@end

#pragma mark - MLGameUserMoneyModel (个人资产余额)
@interface MLGameUserMoneyModel : NSObject
@property (nonatomic, copy) NSString *diamond; // 强红线：钻石余额为 String，防止闪退
@property (nonatomic, assign) NSInteger lottery_coin; // 全局钥匙余额
@end
