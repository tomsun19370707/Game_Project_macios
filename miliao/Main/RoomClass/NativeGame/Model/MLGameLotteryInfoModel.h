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
@property (nonatomic, strong) NSArray<MLGameLotteryOptModel *> *coin_cost_opt;
@property (nonatomic, assign) NSInteger lottery_coin; // 当前玩法的钥匙余额
@property (nonatomic, assign) NSInteger lucky; // 玩法保底寻梦值
- (NSString *)imageUrl;
@end

#pragma mark - MLGameUserMoneyModel (个人资产余额)
@interface MLGameUserMoneyModel : NSObject
@property (nonatomic, copy) NSString *diamond; // 强红线：钻石余额为 String，防止闪退
@property (nonatomic, assign) NSInteger lottery_coin; // 全局钥匙余额
@end
