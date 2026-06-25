//
//  CFMHomeNav.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/9.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMHomeNav.h"
#import "STSecMallSeachVc.h"
@interface CFMHomeNav ()
/** View */
@property (weak, nonatomic) IBOutlet UIView *bg;

@end

@implementation CFMHomeNav

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        STSecMallSeachVc *se = [[STSecMallSeachVc alloc]init];
        [Dn_NAVPUSH pushViewController:se  animated:YES];
    }];
    [self.bg addGestureRecognizer:tap];
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
