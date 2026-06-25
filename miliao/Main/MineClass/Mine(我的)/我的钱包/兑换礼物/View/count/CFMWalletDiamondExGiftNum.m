//
//  CFMWalletDiamondExGiftNum.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMWalletDiamondExGiftNum.h"
@interface CFMWalletDiamondExGiftNum ()
/** View */

@end

@implementation CFMWalletDiamondExGiftNum

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
    [self.contentView addSubview:self.numberVie];
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
-(NumberCalculate *)numberVie
{
    if (!_numberVie) {
        _numberVie = [[NumberCalculate alloc]initWithFrame:CGRectMake(0, 0, 90, 26)];
        _numberVie.minNum = 1 ;
        _numberVie.baseNum = @"1";
        _numberVie.right = SCREENWIDTH - 12 * 2 - 16 ;
        _numberVie.centerY = self.contentView.height / 2.0 ;
    }
    return _numberVie;
}
#pragma mark --
#pragma mark --- Setter

#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
