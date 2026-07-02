#import <UIKit/UIKit.h>

@interface MLChatRoomMarqueeLabel : UIView

/**
 设置需要播报的富文本列表
 */
- (void)setMarqueeItems:(NSArray<NSAttributedString *> *)items;

/**
 开始上下翻滚轮播
 */
- (void)startScroll;

/**
 停止轮播
 */
- (void)stopScroll;

@end
