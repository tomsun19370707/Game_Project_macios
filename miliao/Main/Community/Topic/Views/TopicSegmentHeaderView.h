//
//  TopicSegmentHeaderView.h
//  miliao
//
//  Created by aa on 2019/8/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>
UIKIT_EXTERN CGFloat const SegmentViewHeight;
NS_ASSUME_NONNULL_BEGIN
@interface TopicSegmentHeaderViewCollectionViewCell : UICollectionViewCell
@property (nonatomic, readonly, strong) UILabel *titleLabel;
@end;
@interface TopicSegmentHeaderView : UIView
@property (nonatomic, assign) NSUInteger defaultSelectedIndex;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, copy) void (^selectedItemHelper)(NSUInteger index);

- (void)changeItemWithTargetIndex:(NSUInteger)targetIndex;
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;
@end

NS_ASSUME_NONNULL_END
