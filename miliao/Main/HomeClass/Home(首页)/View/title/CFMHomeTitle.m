//
//  CFMHomeTitle.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMHomeTitle.h"
#import "SGPagingView.h"
@interface CFMHomeTitle ()<SGPageTitleViewDelegate>
/** View */
@property (nonatomic,strong) SGPageTitleView *pageTitleView ;
@end

@implementation CFMHomeTitle

#pragma mark -
#pragma mark --- init
-(instancetype)init
{
    self = [super init];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- init frame
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- 初始化view
- (void)initContentview
{
    self.backgroundColor = UIColor.clearColor ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /** 初始化*/
    [self initContentview];
    /** RAC*/
    [self initRacChain];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark --- Rac
- (void)initRacChain {
    
}

#pragma mark -
#pragma mark --- Getter
-(SGPageTitleView *)pageTitleView
{
    if (!_pageTitleView) {
        /** 设置属性 */
        SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
        configure.titleColor = HexColorDy(@"#999999"); /** 普通状态颜色*/
        configure.titleFont = PingFangFONT(13) ;
        configure.titleSelectedFont = PingFangBoldFONT(15);
        configure.titleSelectedColor = HexColorDy(@"333333") ;
        configure.showBottomSeparator = NO ; /** 是否显示底部分割线，默认为 YES */
        configure.indicatorStyle = SGIndicatorStyleDefault ;
        configure.indicatorColor = BaseMainColor ;
        configure.indicatorCornerRadius = 8.0 ;
        configure.indicatorHeight = 6.0 ;
        configure.indicatorFixedWidth = 33;
        configure.indicatorToBottomDistance = 16 ;
//        configure.indicatorAdditionalWidth = 25; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
        configure.titleAdditionalWidth = 20 ; //标题额外增加的宽度
        configure.equivalence = NO ;
        
        NSArray *titles = _cateStrArr;
        if (titles.count != 0) {
            _pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(16, 0, SCREEN_WIDTH - 16 * 2, 45) delegate:self titleNames:titles configure:configure];
            _pageTitleView.selectedIndex = 0;//默认选中
            _pageTitleView.backgroundColor = UIColor.clearColor ;
        }
    }
    return _pageTitleView ;
}
#pragma mark --
#pragma mark --- Setter
-(void)setCateStrArr:(NSMutableArray *)cateStrArr
{
    _cateStrArr = cateStrArr ;
    
    /** 移除之前的*/
    [_pageTitleView removeFromSuperview];
    _pageTitleView = nil ;
    
    [self.contentView addSubview:self.pageTitleView];
    self.contentView.height = self.pageTitleView.bottom;
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
/**
 *  联动 pageContent 的方法
 *
 *  @param pageTitleView      SGPageTitleView
 *  @param selectedIndex      选中按钮的下标
 */
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex
{
    DLog(@"index---%ld",selectedIndex);
    
    if (self.fetchCateClick) {
        self.fetchCateClick(selectedIndex);
    }
}
@end
