//
//  CFMWalletRewardHisCell.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMWalletRewardHisCell.h"
@interface CFMWalletRewardHisCell ()
/** View */
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyWid;

@end

@implementation CFMWalletRewardHisCell

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
-(void)setModel:(GoodListInfoModel *)model
{
    self.title.text = model.memo;
    self.time.text = model.createtime ;
    /** 0 增加 1 减少*/
    switch (model.type) {
        case 0:
            self.money.text = [NSString stringWithFormat:@"+%.2f",model.money.floatValue];
            break;
        case 1:
            self.money.text = [NSString stringWithFormat:@"-%.2f",model.money.floatValue];
            break;   
        default:
            self.money.text = nil ;
            break;
    }
    
    self.moneyWid.constant = [NSString widthForContent:self.money.text font:self.money.font] + 3 ;
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
