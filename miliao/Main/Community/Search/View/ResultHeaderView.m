//
//  ResultHeaderView.m
//  miliao
//
//  Created by aa on 2019/8/8.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "ResultHeaderView.h"
@interface ResultHeaderView()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIButton *moreBtn;
@end
@implementation ResultHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViewsAndLayout];
    }
    return self;
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}
- (void)setupViewsAndLayout
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
//    [self addSubview:self.lineView];
//    [self addSubview:self.moreBtn];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.height.mas_offset(15);
        make.centerY.equalTo(self);
    }];
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel);
//        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
//        make.size.mas_offset(CGSizeMake(25, 3));
//    }];
//    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).offset(-15);
//        make.centerY.equalTo(self);
//        make.size.mas_offset(CGSizeMake(12, 20));
//    }];
}
- (void)moreBtnClick
{
    !self.moreBtnBlock ?:self.moreBtnBlock();
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [ControlCreator createLabel:self rect:CGRectZero text:@"" font:Font(14) color:mainViceColor backguoundColor:nil align:NSTextAlignmentLeft lines:0];
    }
    return _titleLabel;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [ControlCreator createView:self rect:CGRectZero backguoundColor:MLControlsColor];
        _lineView.clipsToBounds = YES;
        _lineView.layer.cornerRadius = 2;
    }
    return _lineView;
}
- (UIButton *)moreBtn
{
    if (!_moreBtn) {
        _moreBtn = [ControlCreator createButton:self rect:CGRectZero text:nil font:nil color:nil backguoundColor:nil imageName:@"shequ_gengduo" target:self action:@selector(moreBtnClick)];
    }
    return _moreBtn;
}
@end
