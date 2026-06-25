//
//  MLMaskView.m
//  miliao
//
//  Created by aa on 2019/5/29.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "MLMaskView.h"

@interface MLMaskView ()

@property (weak, nonatomic) IBOutlet UILabel *promptLB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maskViewH;

@end


@implementation MLMaskView

- (IBAction)cancelClick:(UIButton *)sender {
    !_leftButtonBlock ? : _leftButtonBlock();
    [self removeFromSuperview];
}

- (IBAction)determineClick:(UIButton *)sender {
    
    !_determineClickBlock ? : _determineClickBlock();
    [self removeFromSuperview];
}

- (void)setLeftButtonString:(NSString *)left rightButton:(NSString *)right promptLB:(NSString *)title maskViewH:(CGFloat )maskViewH{
    [self.leftButton setTitle:left forState:UIControlStateNormal];
    [self.rightButton setTitle:right forState:UIControlStateNormal];
    NSMutableAttributedString *attrString =
    [[NSMutableAttributedString alloc] initWithString:title];
    self.promptLB.attributedText = attrString;
    self.promptLB.textAlignment = NSTextAlignmentCenter;
    self.maskViewH.constant = maskViewH;
    [self layoutIfNeeded];
}


@end
