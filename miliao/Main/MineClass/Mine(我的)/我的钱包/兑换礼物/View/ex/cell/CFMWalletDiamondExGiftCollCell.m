//
//  CFMWalletDiamondExGiftCollCell.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMWalletDiamondExGiftCollCell.h"
@interface CFMWalletDiamondExGiftCollCell ()
/** View */
@property (weak, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgWid;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
@implementation CFMWalletDiamondExGiftCollCell

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
    [self.bg makeRoundCorner];

    [self makeRoundCornerAndLayerColor:UIColor.clearColor];
    self.layer.cornerRadius = 9 ;
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
    if (isSel) {
        self.layer.borderColor = BaseMainColor.CGColor ;
    }else{
        self.layer.borderColor = UIColor.clearColor.CGColor ;
    }
}
-(void)setModel:(GoodListInfoModel *)model
{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:IMAGE(@"正方形")];
    self.name.text = model.name ;
    
    /** 所需要的奖评币*/
    self.num.text = FORMAT(model.prize_coin);
    self.bgWid.constant = [NSString widthForContent:self.num.text font:self.num.font] + 22 + 3 ;
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
