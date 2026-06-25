//
//  STRechargeINputCollCell.m
//  SecondTrading
//
//  Created by Dylan on 2025/10/25.
//

#import "STRechargeINputCollCell.h"
@interface STRechargeINputCollCell ()
/** View */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labWid;
@property (weak, nonatomic) IBOutlet UILabel *price;

/** 设置 钻石数量*/
@property (nonatomic,strong) NSString *diaNum;

@end
@implementation STRechargeINputCollCell

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
    [self makeRoundCornerAndLayerColor:HexColorDy(@"#F8F8F8")];
    self.layer.cornerRadius = 8 ;
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
        self.backgroundColor = RGB(234, 226, 254) ;
    }else{
        self.layer.borderColor = HexColorDy(@"#F8F8F8").CGColor ;
        self.backgroundColor = UIColor.clearColor ;
    }
}
-(void)setDiaNum:(NSString *)diaNum
{
    self.lab.text = diaNum ;
    self.labWid.constant = [NSString widthForContent:self.lab.text font:self.lab.font] + 3 ;
}
-(void)setModel:(NSDictionary *)model
{
    NSString *diamond = model[@"diamond"];
    NSString *price = model[@"price"];
    self.diaNum = FORMAT_TYPE(@"%.0f", diamond.floatValue);
    self.price.text = [NSString stringWithFormat:@"￥%.2f",price.floatValue];
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
