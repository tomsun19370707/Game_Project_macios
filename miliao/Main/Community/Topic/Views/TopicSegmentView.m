//
//  TopicSegmentView.m
//  miliao
//
//  Created by aa on 2019/8/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "TopicSegmentView.h"

#define kWidth self.frame.size.width
#define kHeight self.frame.size.height

@interface TopicSegmentView () <UIScrollViewDelegate>
@property (nonatomic, strong) TopicSegmentHeaderView *header;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation TopicSegmentView

#pragma mark - Life
- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray *)controllers titleArray:(NSArray *)titleArray parentController:(UIViewController *)parentController {
    if ( self = [super initWithFrame:frame]) {
        self.frame = frame;
        
        self.header = [[TopicSegmentHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, SegmentViewHeight) titleArray:titleArray];
        self.header.layer.shadowOffset = CGSizeZero;
        self.header.layer.masksToBounds = NO;
        self.header.layer.shadowColor = mainQianColor.CGColor;
        self.header.layer.shadowOpacity = 0.5f;
        CGRect shadowRect  = CGRectMake(0, SegmentViewHeight, kWidth, 1);
        UIBezierPath *path =[UIBezierPath bezierPathWithRect:shadowRect];
        self.header.layer.shadowPath = path.CGPath;
        [self addSubview:self.header];
         [self addSubview:self.bgView];
        [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(SegmentViewHeight);
        }];
        __weak  typeof(self) weakSelf = self;
        weakSelf.header.selectedItemHelper = ^(NSUInteger index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.contentScrollView setContentOffset:CGPointMake(index * kWidth, 0) animated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:CurrentSelectedChildViewControllerIndex object:nil userInfo:@{@"selectedPageIndex" : @(index)}];
        };
        
        self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SegmentViewHeight + 5, kWidth, kHeight-SegmentViewHeight)];
        self.contentScrollView.contentSize = CGSizeMake(kWidth * controllers.count, 0);
        self.contentScrollView.delegate = self;
        self.contentScrollView.showsHorizontalScrollIndicator = NO;
        self.contentScrollView.pagingEnabled = YES;
        self.contentScrollView.bounces = NO;
        [self addSubview:self.contentScrollView];
        
        [controllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *controller = obj;
            [self.contentScrollView addSubview:controller.view];
            controller.view.frame = CGRectMake(idx * kWidth, 0, kWidth, kHeight);
            [parentController addChildViewController:controller];
            [controller didMoveToParentViewController:parentController];
        }];
    }
    return self;
}
- (UIView *)bgView{
    if (!_bgView) {
        
        
    }
    return _bgView;
}
#pragma mark - Setter
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    self.header.selectedIndex =  selectedIndex;
    [[NSNotificationCenter defaultCenter] postNotificationName:CurrentSelectedChildViewControllerIndex object:nil userInfo:@{@"selectedPageIndex" : @(selectedIndex)}];
}

#pragma mark - UIScrollViewDelegate
//增加分页视图左右滑动和外界tableView上下滑动互斥处理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:IsEnablePersonalCenterVCMainTableViewScroll object:nil userInfo:@{@"canScroll" : @"0"}];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[NSNotificationCenter defaultCenter] postNotificationName:IsEnablePersonalCenterVCMainTableViewScroll object:nil userInfo:@{@"canScroll" : @"1"}];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger selectedIndex = (NSUInteger)self.contentScrollView.contentOffset.x / kWidth;
    [self.header changeItemWithTargetIndex:selectedIndex];
    [[NSNotificationCenter defaultCenter] postNotificationName:CurrentSelectedChildViewControllerIndex object:nil userInfo:@{@"selectedPageIndex" : @(selectedIndex)}];
}

@end
