//
//  CFMExDiamondAndBagPackageCollCell.m
//  miliao
//
//  Created by Dylan Lee on 2026/1/4.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "CFMExDiamondAndBagPackageCollCell.h"
@interface CFMExDiamondAndBagPackageCollCell ()
/** View */

@end
@implementation CFMExDiamondAndBagPackageCollCell

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
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /** 初始化*/
    [self initContentview];
    /** RAC*/
    [self initRacChain];
    
    // Initialization code
}

#pragma mark -
#pragma mark --- Rac
- (void)initRacChain {
    
}

#pragma mark -
#pragma mark --- Getter

#pragma mark --
#pragma mark --- Setter
-(void)setIsSel:(BOOL)isSel
{
    self.bg.hidden = !isSel ;
}
-(void)setModel:(GoodListInfoModel *)model
{
    if ([model isKindOfClass:[GoodListInfoModel class]]) {
        [self.icon sd_setImageWithURL:[NSURL URLWithString:FORMAT(model.image)] placeholderImage:IMAGE(@"正方形")];
        self.name.text = model.name ?: @"";
        self.num.text = [NSString stringWithFormat:@"x%d", model.exchange_num];
    } else if ([model isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)model;
        [self.icon sd_setImageWithURL:[NSURL URLWithString:FORMAT(dict[@"image"])] placeholderImage:IMAGE(@"正方形")];
        self.name.text = FORMAT(dict[@"name"]);
        self.num.text = [NSString stringWithFormat:@"x%@", FORMAT(dict[@"exchange_num"] ?: dict[@"num"] ?: @"1")];
    }
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
