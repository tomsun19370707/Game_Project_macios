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
@property (nonatomic, assign) NSInteger lucky_limit; // 清空上限
@property (nonatomic, assign) NSInteger lucky_progress_value; // 当前阶梯分子
@property (nonatomic, assign) NSInteger lucky_progress_limit; // 当前阶梯分母
@property (nonatomic, copy) NSString *lucky_progress_percent; // 进度百分比
@property (nonatomic, assign) NSInteger next_guarantee_threshold; // 下一保底阈值
@property (nonatomic, copy) NSString *next_guarantee_min_price; // 下一保底最低价值
@property (nonatomic, assign) NSInteger lucky_stage_index; // 当前阶梯序号
@property (nonatomic, assign) NSInteger lucky_stage_count; // 总阶梯数
@property (nonatomic, assign) NSInteger profit_rate; // 运势收益率，例如 1000 表示 1000%
@property (nonatomic, assign) NSInteger consume_diamonds; // 今日消耗钻石数
@property (nonatomic, assign) NSInteger produce_diamonds; // 今日产出钻石数
@property (nonatomic, assign) NSInteger coin_cost; // 对应钥匙消耗数
@property (nonatomic, assign) NSInteger internal_game_id; // 内部玩法 ID (如 6)
@property (nonatomic, copy) NSString *source; // 玩法数据源标示 (如 "tower")
- (NSString *)imageUrl;
@end

#pragma mark - MLGameUserMoneyModel (个人资产余额)
@interface MLGameUserMoneyModel : NSObject
@property (nonatomic, copy) NSString *diamond; // 强红线：钻石余额为 String，防止闪退
@property (nonatomic, assign) NSInteger lottery_coin; // 全局钥匙余额
@end
