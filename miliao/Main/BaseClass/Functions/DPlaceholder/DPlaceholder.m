//
//  DPlaceholder.m
//  MXRobot
//
//  Created by Dylan on 2025/8/4.
//

#import "DPlaceholder.h"
@interface DPlaceholder ()
/** View */

@end

@implementation DPlaceholder

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
-(void)setDelegate:(UIScrollView *)delegate
{
    [delegate addSubview:self];
    self.centerY = delegate.height / 2.0 ;
    self.hidden = YES ;
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
/** 加载占位图*/
+ (DPlaceholder *)loadPlaceholder
{
    DPlaceholder *pl = [[NSBundle mainBundle] loadNibNamed:@"DPlaceholder" owner:nil options:nil][0];
    pl.selectionStyle = UITableViewCellSelectionStyleNone ;
    [pl setFrame:CGRectMake(0, 0, SCREEN_WIDTH, pl.contentView.height)];
    pl.centerY = (SCREEN_HEIGHT_dy - NavBarHeight) / 2.0 ;
    return pl;
}
@end
