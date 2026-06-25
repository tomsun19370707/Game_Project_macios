//
//  EMO_RoomSQSMCell.m
//  miliao
//
//  Created by jkkj on 2021/7/6.
//  Copyright © 2021 miliao. All rights reserved.
//

#import "EMO_RoomSQSMCell.h"

@implementation EMO_RoomSQSMCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor=kClearColor;
    setViewCorner(self.icon, self.icon.height/2);
    setViewCorner(self.RefusedBtn, self.RefusedBtn.height/2);
    setViewCorner(self.determineBtn, self.determineBtn.height/2);
//    [self.RefusedBtn setBackgroundImage:KGetImage(@"giftBgImg") forState:UIControlStateNormal];
//    [self.determineBtn setBackgroundImage:KGetImage(@"giftBgImg") forState:UIControlStateNormal];

    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,52,22);
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)RGBA(247, 212, 91, 0.59).CGColor,(__bridge id)RGBA(255, 238, 1, 1).CGColor];
    gl.locations = @[@(0.0),@(1.0f)];
    [self.determineBtn.layer addSublayer:gl];
    [self.determineBtn.layer insertSublayer:gl atIndex:0];
    self.determineBtn.layer.cornerRadius = 22/2;
    self.determineBtn.layer.masksToBounds=YES;
//    [self.determineBtn setTitle:getLanguage(@"同意") forState:UIControlStateNormal];
//    [self.determineBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    
    
    self.RefusedBtn.layer.borderColor= RGBA(155, 155, 155, 0.16).CGColor;
    self.RefusedBtn.layer.borderWidth=1;
    self.RefusedBtn.layer.cornerRadius=22/2;
    self.RefusedBtn.layer.masksToBounds=YES;
//    [self.RefusedBtn setTitle:getLanguage(@"拒绝") forState:UIControlStateNormal];
//[self.RefusedBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
    
}

- (IBAction)btnClick:(UIButton *)sender{
    if (self.cellClickBlock) {
        self.cellClickBlock(_model, _index,sender.tag);
    }
}

- (void)cellModel:(NSDictionary *)model index:(NSInteger)index{
    _model = model;
    _index = index;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:[Common isNull:model[@"avatar"]]] placeholderImage:[UIImage imageNamed:@"未加载头像"]];
    self.name.text = model[@"nickname"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
