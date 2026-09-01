//
//  CFMRateRewardInput.m
//  miliao
//
//  Created by Dylan Lee on 2026/1/6.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "CFMRateRewardInput.h"
#import "CFMExDiamondAndBagAlert.h"
@interface CFMRateRewardInput ()
/** View */

@end

@implementation CFMRateRewardInput

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
    self.title.hidden = YES;

    NSString *str3 = @"请输入下注金额";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:str3];
    [str addAttribute:NSForegroundColorAttributeName value:HexColorDy(@"eeeeee") range:NSMakeRange(0,str3.length)];
    self.tf.attributedPlaceholder = str ;
    
    [self.inputBg makeRoundCornerAndLayerColor:HexColorDy(@"eeeeee")];
    self.inputBg.layer.cornerRadius = 5 ;
    
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 5 ;
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [self.exBtn makeRoundCorner];
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
    // 阻止 super 调用以防作为普通 view 挂载时触发 tableview 私有消息崩溃
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    // 阻止 super 调用
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
- (IBAction)exAc:(id)sender {
    /** 兑换黑曜石*/
    /** 兑换*/
    CFMExDiamondAndBagAlert *al = [[NSBundle mainBundle] loadNibNamed:@"CFMExDiamondAndBagAlert" owner:self options:nil][0];
    al.fetchRefresh = self.fetchRefresh;
    [al show];
}
#pragma mark --
#pragma mark --- Method
@end
