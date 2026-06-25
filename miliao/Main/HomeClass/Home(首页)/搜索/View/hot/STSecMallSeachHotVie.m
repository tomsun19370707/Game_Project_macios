//
//  STSecMallSeachHotVie.m
//  SecondTrading
//
//  Created by Dylan Lee on 2025/11/6.
//

#import "STSecMallSeachHotVie.h"
@interface STSecMallSeachHotVie ()
/** View */

@end

@implementation STSecMallSeachHotVie

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
    [self.contentView addSubview:self.pin];
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
-(DTAutoFitCollectionFlowView *)pin
{
    if (!_pin) {
        _pin = [[DTAutoFitCollectionFlowView alloc]initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH - 20 * 2, 1)];
        _pin.WHMarginTemp = 6 ;
        _pin.textColor = HexColorDy(@"#595757");
        _pin.isBorder = NO ;
        _pin.WHMarginTemp = 9 ;
        _pin.WHMarginNeighborTemp = 8 ;
        _pin.flowBGColor = HexColorDy(@"#E6E6E6") ;
//        _pin.selectColor = BaseMainColor;
        _pin.Radius = 11 ;
        _pin.type = DTAutoFitCollectionFlowViewTypeDefault ;
    }
    return _pin ;
}
#pragma mark --
#pragma mark --- Setter
-(void)setStrArr:(NSMutableArray *)strArr
{
    self.pin.dataArr = strArr;
    self.contentView.height = self.pin.bottom + 10 ;
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
