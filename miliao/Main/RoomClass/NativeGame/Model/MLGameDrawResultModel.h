#import <Foundation/Foundation.h>

@interface MLGameDrawResultModel : NSObject <NSCopying>

@property (nonatomic, assign) NSInteger giftId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) BOOL is_guaranteed;
@property (nonatomic, copy) NSString *probability_text;
@property (nonatomic, assign) double probability;

/**
 兼容性的图片加载地址 (内部自动处理 pic 与 image 兜底)
 */
- (NSString *)imageUrl;

/**
 格式化显示概率字符串 (例如 "28.86%")
 */
- (NSString *)displayProbability;

/**
 有序去重合并中奖结果
 */
+ (NSArray<MLGameDrawResultModel *> *)mergeAndSortDrawGifts:(NSArray<MLGameDrawResultModel *> *)drawResultList;

@end

#pragma mark - MLGameDrawResponseModel (抽奖接口 Response 包裹模型)
@interface MLGameDrawResponseModel : NSObject

@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *list;
@property (nonatomic, assign) NSInteger total_value;
@property (nonatomic, assign) NSInteger lottery_log_id;
@property (nonatomic, assign) NSInteger lucky_value;
@property (nonatomic, assign) NSInteger lucky_limit;
@property (nonatomic, assign) NSInteger lucky_progress_value;
@property (nonatomic, assign) NSInteger lucky_progress_limit;
@property (nonatomic, copy) NSString *lucky_progress_percent;
@property (nonatomic, assign) NSInteger next_guarantee_threshold;
@property (nonatomic, copy) NSString *next_guarantee_min_price;
@property (nonatomic, assign) NSInteger lucky_stage_index;
@property (nonatomic, assign) NSInteger lucky_stage_count;
@property (nonatomic, assign) NSInteger guarantee_triggered;
@property (nonatomic, copy) NSString *is_guarantee;
@property (nonatomic, copy) NSString *guarantee_min_price;

@end

#pragma mark - MLGameFourRankingUserModel (玩法 4 自然周排行榜实体模型)
@interface MLGameFourRankingUserModel : NSObject

@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, assign) int64_t uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger type8_count;  // 青玉福袋 (type_id=8)
@property (nonatomic, assign) NSInteger type9_count;  // 碧海福袋 (type_id=9)
@property (nonatomic, assign) NSInteger type10_count; // 鎏金福袋 (type_id=10)
@property (nonatomic, assign) NSInteger total_count;

@end
