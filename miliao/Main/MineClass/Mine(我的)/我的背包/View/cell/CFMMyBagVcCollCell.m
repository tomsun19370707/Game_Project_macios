//
//  CFMMyBagVcCollCell.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/8.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMMyBagVcCollCell.h"
#import "CFMMyBagExCoinVc.h"
@interface CFMMyBagVcCollCell ()
/** View */
@property (weak, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
@implementation CFMMyBagVcCollCell

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
    self.bg.layer.masksToBounds = YES;
    self.bg.layer.cornerRadius = 8 ;
    [self.btn makeRoundCorner];
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
-(void)setModel:(GoodListInfoModel *)model
{
    _model = model ;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:IMAGE(@"正方形")];
    self.name.text = [NSString stringWithFormat:@"%@*%d",model.name,model.num];
}
#pragma mark --
#pragma mark --- ibaction
- (IBAction)ac:(id)sender {
    
    if (_model.exchange_num==0) {
        [SVProgressHUD showTextHUDWithMessage:@"可兑换数量为0"];
        return;
    }
    
    CFMMyBagExCoinVc *coin = [[CFMMyBagExCoinVc alloc]init];
    coin.giftInfo = _model ;
    [Dn_NAVPUSH pushViewController:coin animated:YES];
}
#pragma mark --
#pragma mark --- Method
@end
