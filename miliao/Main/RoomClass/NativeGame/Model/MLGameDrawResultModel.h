#import <Foundation/Foundation.h>

@interface MLGameDrawResultModel : NSObject <NSCopying>

@property (nonatomic, assign) NSInteger giftId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger num;

/**
 兼容性的图片加载地址 (内部自动处理 pic 与 image 兜底)
 */
- (NSString *)imageUrl;

/**
 有序去重合并中奖结果
 */
+ (NSArray<MLGameDrawResultModel *> *)mergeAndSortDrawGifts:(NSArray<MLGameDrawResultModel *> *)drawResultList;

@end
