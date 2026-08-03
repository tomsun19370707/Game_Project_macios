#import <Foundation/Foundation.h>

@interface MLGameDrawResultModel : NSObject <NSCopying>

@property (nonatomic, assign) NSInteger giftId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) BOOL is_guaranteed;

/**
 兼容性的图片加载地址 (内部自动处理 pic 与 image 兜底)
 */
- (NSString *)imageUrl;

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
@property (nonatomic, assign) NSInteger guarantee_triggered;
@property (nonatomic, copy) NSString *is_guarantee;
@property (nonatomic, copy) NSString *guarantee_min_price;

@end
