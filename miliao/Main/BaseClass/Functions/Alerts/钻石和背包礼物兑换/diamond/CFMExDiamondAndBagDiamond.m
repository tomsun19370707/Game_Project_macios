//
//  CFMExDiamondAndBagDiamond.m
//  miliao
//
//  Created by Dylan Lee on 2026/1/4.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "CFMExDiamondAndBagDiamond.h"
@interface CFMExDiamondAndBagDiamond ()
/** View */
@end

@implementation CFMExDiamondAndBagDiamond

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
    NSString *str2 = @"99.00";
    NSString *str3 = [NSString stringWithFormat:@"当前钻石余额：%@",str2];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:str3];
    [str addAttribute:NSForegroundColorAttributeName value:HexColorDy(@"#FF6F00") range:NSMakeRange(7,str2.length)];
    self.balance.attributedText = str;
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

#pragma mark --
#pragma mark --- Method
@end
