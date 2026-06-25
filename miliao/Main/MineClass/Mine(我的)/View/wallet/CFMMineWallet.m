//
//  CFMMineWallet.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/6.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMMineWallet.h"
#import "EMO_MyWalletViewController.h"
#import "CFMMyBagVc.h"
#import "CFMWalletVc.h"
@interface CFMMineWallet ()
/** View */

@end

@implementation CFMMineWallet

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
//首先给让cell左右偏移一点的距离，通过重写cell的setframe方法来实现   
- (void)setFrame:(CGRect)frame{
    CGFloat margin = 12;
    frame.origin.x = margin;
    frame.size.width = SCREEN_WIDTH - margin*2;
    [super setFrame:frame];
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

#pragma mark --
#pragma mark --- Setter

#pragma mark --
#pragma mark --- ibaction
- (IBAction)walletAc:(id)sender {
    /** 我的钱包*/
    [Dn_NAVPUSH pushViewController:[CFMWalletVc new] animated:YES];
}
- (IBAction)bagAc:(id)sender {
    /** 我的背包*/
    CFMMyBagVc *bg = [[CFMMyBagVc alloc]init];
    [Dn_NAVPUSH pushViewController:bg animated:YES];
}

#pragma mark --
#pragma mark --- Method
@end
