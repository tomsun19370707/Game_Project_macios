//
//  CFMRateRewardHis.m
//  miliao
//
//  Created by Dylan Lee on 2026/1/6.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "CFMRateRewardHis.h"
#import "CFMExRewardRuleAlert.h"
#import "CFMRewardHistoryAlert.h"
@interface CFMRateRewardHis ()
/** View */

@end

@implementation CFMRateRewardHis

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
    [self.cjBtn roundCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft radius:13];
    [self.zjBtn roundCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft radius:13];
    [self.cyBtn roundCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft radius:13];
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
- (IBAction)ruleAc:(id)sender {
    /** 抽奖说明*/
    CFMExRewardRuleAlert *al = [[NSBundle mainBundle] loadNibNamed:@"CFMExRewardRuleAlert" owner:self options:nil][0];
    al.webHtml = self.content;
    [al show];
}
- (IBAction)rewardHisAc:(id)sender {
    /** 中奖记录*/
    CFMRewardHistoryAlert *al = [[NSBundle mainBundle] loadNibNamed:@"CFMRewardHistoryAlert" owner:self options:nil][0];
    al.panType = 2 ;
    al.rewardId = self.ID;
    al.vcType = 1 ;
    [al show];
}
- (IBAction)joinHisAc:(id)sender {
    /** 参与记录*/
    CFMRewardHistoryAlert *al = [[NSBundle mainBundle] loadNibNamed:@"CFMRewardHistoryAlert" owner:self options:nil][0];
    al.panType = 2 ;
    al.rewardId = self.ID;
    al.vcType = 2 ;
    [al show];
}

#pragma mark --
#pragma mark --- Method
@end
