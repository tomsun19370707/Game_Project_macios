//
//  CFMMyGiftOpr.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/8.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMMyGiftOpr.h"
@interface CFMMyGiftOpr ()
/** View */
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UILabel *mark;
@end

@implementation CFMMyGiftOpr

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
    [self.mark makeRoundCorner];
    
    CGFloat margin = SCREENWIDTH / 4.0 ;
    self.mark.centerX = margin ;
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
- (IBAction)ac1:(id)sender {
    CGFloat margin = SCREENWIDTH / 4.0 ;
    self.mark.centerX = margin ;
    [self.btn1 setTitleColor:HexColorDy(@"333333") forState:UIControlStateNormal];
    [self.btn2 setTitleColor:HexColorDy(@"666666") forState:UIControlStateNormal];
    
    if (self.fetchClick) {
        self.fetchClick(0);
    }
}
- (IBAction)ac2:(id)sender {
    CGFloat margin = SCREENWIDTH / 4.0 ;
    self.mark.centerX = margin * 3.0 ;
    [self.btn2 setTitleColor:HexColorDy(@"333333") forState:UIControlStateNormal];
    [self.btn1 setTitleColor:HexColorDy(@"666666") forState:UIControlStateNormal];
    
    if (self.fetchClick) {
        self.fetchClick(1);
    }
}
#pragma mark --
#pragma mark --- Method
@end
