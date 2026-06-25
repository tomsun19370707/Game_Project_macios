//
//  MKWithdrawalView.h
//  MKProject
//
//  Created by jkkj on 2021/4/26.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    MKUITypeDefault,//静态布局,根据屏幕宽度
    MKUITypeScroller//动态布局,根据文字宽度布局
} MKUIType;//指示器类型枚举
@protocol MKWithdrawalViewDelegate <NSObject>

- (void)switchIndex:(NSInteger )index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MKWithdrawalView : UIView
Strong NSArray *titleArray;
Assign NSInteger selectIndex;
Strong UIColor *lineColor;
Assign float lineHeight;
Strong UIColor *selectColor;
Strong UIColor *noteColor;
Strong UIFont *selectFont;
Strong UIFont *noteFont;
Assign MKUIType typeUI;
@property (nonatomic, weak) id<MKWithdrawalViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame;
Copy void(^switchBlock)(NSInteger index);
- (void)seeBtnPage:(NSString *)pageStr index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
