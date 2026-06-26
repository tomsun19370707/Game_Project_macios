#import <UIKit/UIKit.h>

@interface UIImageView (AspectFitGeometry)

/**
 计算 AspectFit 模式下，设计稿中绝对坐标在当前设备屏幕上的物理 Center 映射点
 */
- (CGPoint)ml_calculatePhysicalCenterWithDesignX:(CGFloat)designX 
                                         designY:(CGFloat)designY 
                                     designWidth:(CGFloat)designWidth 
                                    designHeight:(CGFloat)designHeight;

@end
