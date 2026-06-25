//
//  HGHeaderImageView.m
//  HGPersonalCenter
//
//  Created by 黑色幽默 on 2019/5/17.
//  Copyright © 2019 mint_bin. All rights reserved.
//

#import "TopicHeaderImageView.h"

CGFloat const HeaderImageViewHeight = 160;

@interface TopicHeaderImageView ()
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic,strong) UIView *bgView;
@end

@implementation TopicHeaderImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}
- (void)loadDataWithDic:(NSDictionary *)dic
{
    [self.backgroundImageView sd_setImageWithURL:dic[@"imageUrl"]];
    self.nickNameLabel.text = dic[@"title"];
    //    [self layoutIfNeeded];
}
- (void)setupViews {
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.nickNameLabel];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self);
        make.height.mas_offset(20);
    }];

    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);

    }];
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    }
    return _bgView;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = [UIFont systemFontOfSize:11];
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
        _nickNameLabel.text = @"下雪天";
    }
    return _nickNameLabel;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"center_bg.jpg"]];
    }
    return _backgroundImageView;
}

@end
