//
//  EMO_RoomHoldingMView.m
//  miliao
//
//  Created by aa on 2019/7/8.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "EMO_RoomHoldingMView.h"
#import "RoomSearchView.h"


@interface EMO_RoomHoldingMView ()

@property (nonatomic, strong) RoomSearchView        *searchView;

@property (nonatomic, strong) UIView                *maskView;
@property (nonatomic, strong) UIView                *bgView;

@property (nonatomic, strong) UILabel               *titleLB;
@property (nonatomic, strong) UIView                *lineView;

@property (nonatomic, strong) UIButton              *cancelButton;

@end


@implementation EMO_RoomHoldingMView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [self addGestureRecognizer:singleTap];
        
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    WEAK_SELF
    
    [self addSubview:self.maskView];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLB];
    [self.bgView addSubview:self.searchView];
    self.searchView.quDingButtonClickBlock = ^(NSString *textTF) {
        weakSelf.searchView.searchTF.text = @"";
        [weakSelf removeFromSuperview];
        ! weakSelf.holdingMClickBlock ?: weakSelf.holdingMClickBlock(textTF);
    };
    
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.cancelButton];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(self);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(165);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
    }];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.mas_equalTo(self.bgView);
    }];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLB.mas_bottom).offset(10);
        make.left.mas_equalTo(self.bgView).offset(10);
        make.right.mas_equalTo(self.bgView).offset(-10);
        make.height.mas_equalTo(50);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView);
        make.left.mas_equalTo(self.bgView);
        make.right.mas_equalTo(self.bgView);
        make.height.mas_equalTo(50);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.cancelButton.mas_top);
        make.centerX.mas_equalTo(self.bgView);
        make.width.mas_equalTo(self.bgView);
        make.height.mas_equalTo(1);
    }];
    
    
}
- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
    self.searchView.searchTF.text = @"";
}
- (void)cancelButtonCliock{
    self.searchView.searchTF.text = @"";
    [self removeFromSuperview];
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:RGBA(255, 255, 255, 0.95)];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 10;
    }
    return _bgView;
}
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor blackColor]];
        _maskView.alpha = 0.2;
    }
    return _maskView;
}
- (UILabel *)titleLB{
    if (!_titleLB) {
        _titleLB = [ControlCreator createLabel:nil rect:CGRectZero text:@"报麦" font:Font(15) color:MHColorFromHexString(@"#000000") backguoundColor:[UIColor clearColor] align:NSTextAlignmentCenter lines:1];
    }
    return _titleLB;
}

- (RoomSearchView *)searchView{
    if (!_searchView) {
        _searchView = [[RoomSearchView alloc] initWithFrame:CGRectZero];
        _searchView.backgroundColor = [UIColor whiteColor];
    }
    return _searchView;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:MLControlsHuiColor];
    }
    return _lineView;
}
- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [ControlCreator createButton:nil rect:CGRectZero text:@"取消" font:Font(15) color:mainShenColor backguoundColor:[UIColor clearColor] imageName:@"" target:self action:@selector(cancelButtonCliock)];
    }
    return _cancelButton;
}

@end
