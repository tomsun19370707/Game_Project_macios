
/*!
 *  @header BAKit.h
 *
 
 *********************************************************************************
 *
 * 在使用BAKit的过程中如果出现bug请及时以以下任意一种方式联系我，我会及时修复bug
 *
 * QQ     : 可以添加ios开发技术群 479663605 在这里找到我(博爱1616【137361770】)
 * 微博    : 博爱1616
 * Email  : 137361770@qq.com
 * GitHub : https://github.com/boai
 * 博客    : http://boaihome.com
 
 *********************************************************************************
 
 */


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 button 的样式，以图片为基准
 
 - BAKit_ButtonLayoutTypeNormal: button 默认样式：内容居中-图左文右
 - BAKit_ButtonLayoutTypeCenterImageRight: 内容居中-图右文左
 - BAKit_ButtonLayoutTypeCenterImageTop: 内容居中-图上文下
 - BAKit_ButtonLayoutTypeCenterImageBottom: 内容居中-图下文上
 - BAKit_ButtonLayoutTypeLeftImageLeft: 内容居左-图左文右
 - BAKit_ButtonLayoutTypeLeftImageRight: 内容居左-图右文左
 - BAKit_ButtonLayoutTypeRightImageLeft: 内容居右-图左文右
 - BAKit_ButtonLayoutTypeRightImageRight: 内容居右-图右文左
 */
typedef NS_ENUM(NSInteger, BAKit_ButtonLayoutType) {
    // 无任何处理
    BAKit_ButtonLayoutTypeDefault = 0,
    // 系统默认样式
    BAKit_ButtonLayoutTypeNormal,
    BAKit_ButtonLayoutTypeCenterImageRight,
    BAKit_ButtonLayoutTypeCenterImageTop,
    BAKit_ButtonLayoutTypeCenterImageBottom,
    BAKit_ButtonLayoutTypeLeftImageLeft,
    BAKit_ButtonLayoutTypeLeftImageRight,
    BAKit_ButtonLayoutTypeRightImageLeft,
    BAKit_ButtonLayoutTypeRightImageRight,
};

/**
 UIButton：点击事件 block 返回

 @param button 当前的 button
 */
typedef void (^BAKit_UIButtonActionBlock)(UIButton * _Nonnull button);

@interface UIButton (BAKit)

/**
 button 的布局样式，默认为：BAKit_ButtonLayoutTypeNormal，注意：文字、字体大小、图片等设置一定要在设置 ba_button_setBAKit_ButtonLayoutType 之前设置，要不然计算会以默认字体大小计算，导致位置偏移
 */
@property(nonatomic, assign) BAKit_ButtonLayoutType ba_buttonLayoutType;

/*!
 *  文字与图片之间的间距，默认为：0
 */
@property (nonatomic, assign) CGFloat ba_padding;

/*!
 *  文字或图片距离 button 左右边界的最小距离，默认为：5
 */
@property (nonatomic, assign) CGFloat ba_padding_inset;

/**
 UIButton：点击事件 block 返回
 */
@property(nonatomic, copy) BAKit_UIButtonActionBlock ba_buttonActionBlock;


#pragma mark - 布局样式 和 间距
/**
 UIButton：快速设置 button 的布局样式 和 间距，
 注意：如果后期动态改变文字或者图片后，需要在赋值之后重新调用此方法：
 
 @param type button 的布局样式
 @param padding 文字与图片之间的间距
 */
- (void)ba_button_setButtonLayoutType:(BAKit_ButtonLayoutType)type
                              padding:(CGFloat)padding;



@end


NS_ASSUME_NONNULL_END


