//
//  MKWithdrawalView.m
//  MKProject
//
//  Created by jkkj on 2021/4/26.
//

#import "MKWithdrawalView.h"
#import "UIButton+Badge.h"
@interface MKWithdrawalView ()
@property (nonatomic, strong)UIView * indicatorView;
@property (nonatomic, strong)UIScrollView * scrollerView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *itemBtnArr;
@end

@implementation MKWithdrawalView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineColor = kColorMain;
        self.selectFont = KCFont(17);
        self.noteFont = [UIFont systemFontOfSize:13];
        self.lineHeight = 3;
        self.selectColor = [UIColor blackColor];
        self.noteColor = [UIColor blackColor];
        self.itemBtnArr = [[NSMutableArray alloc] init];
        self.typeUI = MKUITypeDefault;
    }
    return self;
}

- (UIScrollView *)scrollerView{
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _scrollerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollerView];
    }
    return _scrollerView;
}
- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.indicatorView.backgroundColor = lineColor;
}

- (NSMutableArray<UIButton *>*)itemBtnArr
{
    if (!_itemBtnArr) {
        _itemBtnArr = [[NSMutableArray alloc]init];
    }
    return _itemBtnArr;
}

- (void)setLineHeight:(float)lineHeight{
    _lineHeight = lineHeight;
    self.indicatorView.height = lineHeight;
}

- (UIView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc]initWithFrame:CGRectMake(0,self.height - 10, 20, 3)];
        _indicatorView.backgroundColor = kColorMain;
        setViewCorner(_indicatorView, 2);
        if (self.typeUI == MKUITypeScroller) {
            [self.scrollerView addSubview:_indicatorView];
        }else{
            [self addSubview:_indicatorView];
        }
    }
    return _indicatorView;
}

- (void)seeBtnPage:(NSString *)pageStr index:(NSInteger)index{
    UIButton *btn = self.itemBtnArr[index];
//    btn.badgeValue = pageStr;
//    btn.badgeTextColor = [UIColor whiteColor];
//    btn.badgeBGColor = [UIColor redColor];
//    btn.badgeFont = FONT(12);
//    btn.badgeMinSize = 15;
}

- (void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    UIButton *curBtn = nil;
    for (int i=0; i<self.itemBtnArr.count; i++) {
        UIButton *btn = self.itemBtnArr[i];
        if (selectIndex == btn.tag) {
            btn.selected = YES;
            btn.titleLabel.font = self.selectFont;
            curBtn = btn;
        }else{
            btn.selected = NO;
            btn.titleLabel.font = self.noteFont;
        }
    }
    WeakSelf;
    [UIView animateWithDuration:0.25 animations:^{
        wself.indicatorView.centerX = curBtn.centerX;
    }];
}
#pragma mark --Setter

- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
//    if (self.typeUI == MKUITypeDefault) {
//        [self removeAllSubviews];
//    }else{
//        [self.scrollerView removeAllSubviews];
//    }
    UIButton *curBtn = nil;
    ///kScreenWidth
    CGFloat width = self.width/titleArray.count;
    for (int i=0; i<titleArray.count; i++) {
        NSString *title = titleArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:self.noteColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = self.noteFont;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.typeUI == MKUITypeScroller) {
            CGFloat btnWidth = [Common getStringWidthWithText:title font:self.selectFont viewHeight:self.height] + 5;
            btn.frame = CGRectMake(curBtn.right,0,btnWidth, self.height - 5);
            [self.scrollerView addSubview:btn];
        }else{
            btn.frame = CGRectMake(i*width,0,width, self.height - 5);
            [self addSubview:btn];
        }
        curBtn = btn;
        [self.itemBtnArr addObject:btn];
    }
    self.selectIndex = 0;
    if (self.itemBtnArr.count >0) {
        UIButton *btn = self.itemBtnArr[0];
        self.indicatorView.centerX = btn.centerX;
    }
}

- (void)btnClick:(UIButton *)sender{
    self.selectIndex = sender.tag;
    if ([self.delegate respondsToSelector:@selector(switchIndex:)]) {
            [self.delegate switchIndex:sender.tag];
        }
    if (self.switchBlock) {
        self.switchBlock(sender.tag);
    }
}

@end
