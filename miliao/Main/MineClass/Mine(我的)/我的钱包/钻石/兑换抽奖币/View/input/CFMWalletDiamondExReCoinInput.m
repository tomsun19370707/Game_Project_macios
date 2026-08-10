//
//  CFMWalletDiamondExReCoinInput.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMWalletDiamondExReCoinInput.h"
@interface CFMWalletDiamondExReCoinInput ()
/** View */

@end

@implementation CFMWalletDiamondExReCoinInput

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
//首先给让cell左右偏移一点的距离，通过重写cell的setframe方法来实现   
- (void)setFrame:(CGRect)frame{
    CGFloat margin = 12;
    frame.origin.x = margin;
    frame.size.width = SCREEN_WIDTH - margin*2;
    [super setFrame:frame];
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
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /** 初始化*/
    [self initContentview];
    /** RAC*/
    [self initRacChain];
    
    // 创建“全部兑换”按钮 (#3092FF, 14sp bold)
    self.exchangeAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.exchangeAllBtn setTitle:getLanguage(@"全部兑换") forState:UIControlStateNormal];
    [self.exchangeAllBtn setTitleColor:mHexRGB(0x3092FF) forState:UIControlStateNormal];
    self.exchangeAllBtn.titleLabel.font = [UIFont boldSystemFontOfSize:KAdaptedWidth(14)];
    self.exchangeAllBtn.hidden = YES; // 默认隐藏，在 vcType == 3 模式下显示
    
    [self.contentView addSubview:self.exchangeAllBtn];
    [self.exchangeAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.tf.mas_trailing).offset(-KAdaptedWidth(8));
        make.centerY.mas_equalTo(self.tf.mas_centerY);
        make.width.mas_equalTo(KAdaptedWidth(70));
        make.height.mas_equalTo(KAdaptedHeight(36));
    }];
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

#pragma mark --
#pragma mark --- Setter

#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
