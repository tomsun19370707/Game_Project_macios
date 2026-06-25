//
//  STRankSort.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/10.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "STRankSort.h"
@interface STRankSort ()
/** View */
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@end

@implementation STRankSort

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
    [self.btn1 makeRoundCorner];
    [self.btn2 makeRoundCorner];
    [self.btn3 makeRoundCorner];
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
    [self.btn1 setBackgroundColor:BaseMainColor forState:UIControlStateNormal];
    [self.btn2 setBackgroundColor:HexColorDy(@"#D9D9D9") forState:UIControlStateNormal];
    [self.btn3 setBackgroundColor:HexColorDy(@"#D9D9D9") forState:UIControlStateNormal];
    
    if (self.fetchClick) {
        self.fetchClick(0);
    }
}
- (IBAction)ac2:(id)sender {
    [self.btn2 setBackgroundColor:BaseMainColor forState:UIControlStateNormal];
    [self.btn1 setBackgroundColor:HexColorDy(@"#D9D9D9") forState:UIControlStateNormal];
    [self.btn3 setBackgroundColor:HexColorDy(@"#D9D9D9") forState:UIControlStateNormal];
    
    if (self.fetchClick) {
        self.fetchClick(1);
    }
}
- (IBAction)ac3:(id)sender {
    [self.btn3 setBackgroundColor:BaseMainColor forState:UIControlStateNormal];
    [self.btn2 setBackgroundColor:HexColorDy(@"#D9D9D9") forState:UIControlStateNormal];
    [self.btn1 setBackgroundColor:HexColorDy(@"#D9D9D9") forState:UIControlStateNormal];
    
    if (self.fetchClick) {
        self.fetchClick(2);
    }
}

#pragma mark --
#pragma mark --- Method
@end
