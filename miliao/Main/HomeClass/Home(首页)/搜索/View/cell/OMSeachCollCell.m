//
//  OMSeachCollCell.m
//  SecondTrading
//
//  Created by Dylan Lee on 2025/11/5.
//

#import "OMSeachCollCell.h"
@interface OMSeachCollCell ()
/** View */

@end
@implementation OMSeachCollCell

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
    [self.lab makeRoundCornerAndLayerColor:HexColorDy(@"#999999")];
    self.lab.layer.cornerRadius = 8 ;
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

#pragma mark --
#pragma mark --- ibaction
- (IBAction)delAc:(id)sender {
    if (self.fetchDel) {
        self.fetchDel();
    }
}
#pragma mark --
#pragma mark --- Method
@end
