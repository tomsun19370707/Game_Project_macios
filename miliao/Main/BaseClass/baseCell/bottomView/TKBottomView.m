//
//  TKBottomView.m
//  Tcbook
//
//  Created by 李东阳 on 2019/5/13.
//  Copyright © 2019 锤子科技. All rights reserved.
//

#import "TKBottomView.h"

@implementation TKBottomView

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
    /** 渐变色*/
//    self.btn.backgroundColor = UIColor.clearColor ;
//    [self.btn setWidth:(SCREEN_WIDTH - 16 * 2)];
//    [self.btn makeShadowFromColor:HexColorDy(@"0x6CC76A") to:HexColorDy(@"0x33BE46") cornerRadius:self.btn.height / 2.0];
    
    self.btn.backgroundColor = BaseMainColor ;
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

@end
