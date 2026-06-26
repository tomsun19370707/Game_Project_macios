#import "UIImageView+AspectFitGeometry.h"

@implementation UIImageView (AspectFitGeometry)

- (CGPoint)ml_calculatePhysicalCenterWithDesignX:(CGFloat)designX 
                                         designY:(CGFloat)designY 
                                     designWidth:(CGFloat)designWidth 
                                    designHeight:(CGFloat)designHeight {
    if (self.image == nil) {
        // 无图片时降级为基于自身宽高的比例拉伸对齐
        CGFloat scaleX = self.bounds.size.width / designWidth;
        CGFloat scaleY = self.bounds.size.height / designHeight;
        return CGPointMake(designX * scaleX, designY * scaleY);
    }
    
    CGSize viewSize = self.bounds.size;
    
    // 1. 计算在 AspectFit 模式下的缩放比
    CGFloat scale = MIN(viewSize.width / designWidth, viewSize.height / designHeight);
    
    // 2. 计算大图在 UIImageView 实际渲染边界中的 X 与 Y 平移偏移量
    CGFloat transX = (viewSize.width - designWidth * scale) / 2.0;
    CGFloat transY = (viewSize.height - designHeight * scale) / 2.0;
    
    // 3. 换算出灵果在当前屏幕上的物理位置
    CGFloat physicalX = designX * scale + transX;
    CGFloat physicalY = designY * scale + transY;
    
    return CGPointMake(physicalX, physicalY);
}

@end
