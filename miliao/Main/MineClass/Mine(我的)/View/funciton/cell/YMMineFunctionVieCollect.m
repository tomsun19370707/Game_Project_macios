//
//  YMMineFunctionVieCollect.m
//  YunMarket
//
//  Created by 李东阳 on 2021/3/17.
//

#import "YMMineFunctionVieCollect.h"
@interface YMMineFunctionVieCollect ()
/** View */
@end
@implementation YMMineFunctionVieCollect

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
    [self.num makeRoundCorner];
    self.num.hidden = YES ;
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
-(void)setNumStr:(NSString *)numStr
{
    if (numStr.intValue > 0) {
        self.num.hidden = NO ;
        self.num.text = FORMAT_TYPE(@"%d", numStr.intValue);
    }else{
        self.num.hidden = YES ;
    }
}
#pragma mark --
#pragma mark --- ibaction

#pragma mark --
#pragma mark --- Method
@end
