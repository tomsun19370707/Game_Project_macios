//
//  EMO_RoomManagerCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/10.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_RoomManagerCell.h"
@interface EMO_RoomManagerCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UIButton *quDingButton;





@end

@implementation EMO_RoomManagerCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor=kClearColor;
        [self addSomeViews];
    }
    return self;
}

- (void)quDingButtonClick:(UIButton *)sender{
    ! self.quDingButtonClickBlock ?: self.quDingButtonClickBlock(self.dicData);
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:dicData[@"avatar"]] placeholderImage:[UIImage imageNamed:@"未加载头像"]];
    self.nickName.text = dicData[@"nickname"];
    
    if([dicData[@"type"] integerValue]==1){
        self.quDingButton.hidden=YES;
    }else{
        self.quDingButton.hidden=NO;
    }
    self.quDingButton.layer.contents=(id)KGetImage(@"followCancalImg").CGImage;
    if ([dicData[@"status"] integerValue]==4000){
//        [self.quDingButton setTitle:getLanguage(@"取消管理") forState:UIControlStateNormal];
        /** type;//0普通用户1房主2管理员*/
        if([dicData[@"type"] integerValue]==0){
            [self.quDingButton setTitle:getLanguage(@"设置管理") forState:UIControlStateNormal];
            self.quDingButton.layer.contents=(id)KGetImage(@"followSelectImg").CGImage;
            [self.quDingButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        }else if([dicData[@"type"] integerValue]==2){
            [self.quDingButton setTitle:getLanguage(@"取消管理") forState:UIControlStateNormal];
            [self.quDingButton setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        }
        
    }else if ([dicData[@"status"] integerValue]==5000){
        if([dicData[@"is_muted"] integerValue]==1){
            [self.quDingButton setTitle:getLanguage(@"取消禁言") forState:UIControlStateNormal];
        }else{
            [self.quDingButton setTitle:getLanguage(@"禁言") forState:UIControlStateNormal];
            self.quDingButton.layer.contents=(id)KGetImage(@"followSelectImg").CGImage;
        }
    }else if (([dicData[@"status"] integerValue]==6000)||([dicData[@"status"] integerValue]==1)){
        if([dicData[@"is_black"] integerValue]==1){
            [self.quDingButton setTitle:getLanguage(@"解除拉黑") forState:UIControlStateNormal];
        }else{
            [self.quDingButton setTitle:getLanguage(@"拉黑") forState:UIControlStateNormal];
            self.quDingButton.layer.contents=(id)KGetImage(@"followSelectImg").CGImage;
        }
    }else{
            if([dicData[@"type"] integerValue]==0){
                [self.quDingButton setTitle:getLanguage(@"设置管理") forState:UIControlStateNormal];
                self.quDingButton.layer.contents=(id)KGetImage(@"followSelectImg").CGImage;
            }else if([dicData[@"type"] integerValue]==2){
                [self.quDingButton setTitle:getLanguage(@"取消管理") forState:UIControlStateNormal];
            }
    }
    
    
}

- (void)addSomeViews{
    
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.nickName];
    [self.contentView addSubview:self.quDingButton];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(5);
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(12);
        make.right.mas_equalTo(self).offset(-12);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(self.bgView.mas_left).offset(10);
        make.width.mas_equalTo(50);
    }];
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(10);
        make.centerY.mas_equalTo(self.icon.mas_centerY);

        
    }];

    [self.quDingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(80);
    }];

}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:kClearColor];
        _bgView.layer.cornerRadius = 7;
        _bgView.layer.shadowOffset = CGSizeMake(0,1);
        _bgView.layer.masksToBounds = NO;
        _bgView.layer.shadowColor = mainQianColor.CGColor;
        _bgView.layer.shadowOpacity = 0.5f;
        _bgView.hidden = YES;
    }
    return _bgView;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [ControlCreator createImageView:self rect:CGRectMake(0, 0, 0, 0) imageName:@"未加载头像" backguoundColor:MLControlsHuiColor];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 25;
    }
    return _icon;
}
- (UILabel *)nickName{
    if (!_nickName) {
        _nickName = [ControlCreator createLabel:self rect:CGRectZero text:@"昵称" font:KFontA(13) color:RGBA(51, 51, 51, 1) backguoundColor:[UIColor clearColor] align:NSTextAlignmentLeft lines:1];
    }
    return _nickName;
}

- (UIButton *)quDingButton{
    if (!_quDingButton) {
        _quDingButton = [ControlCreator createButton:self rect:CGRectZero text:getLanguage(@"设置管理") font:KFontA(13) color:RGBA(153, 153, 153, 1) backguoundColor:nil imageName:@"" target:self action:@selector(quDingButtonClick:)];
//        CAGradientLayer *gl = [CAGradientLayer layer];
//        gl.frame = CGRectMake(0,0,KAdaptedWidth(80),KAdaptedHeight(30));
//        gl.startPoint = CGPointMake(0.5, 0);
//        gl.endPoint = CGPointMake(0.5, 1);
//        gl.colors = @[(__bridge id)RGBA(247, 212, 91, 0.59).CGColor,(__bridge id)RGBA(255, 238, 1, 1).CGColor];
//        gl.locations = @[@(0.0),@(1.0f)];
//        [_quDingButton.layer addSublayer:gl];
        //        [_quDingButton.layer insertSublayer:gl atIndex:0];
//        _quDingButton.layer.masksToBounds = YES;
//        _quDingButton.layer.cornerRadius = 15;
//        _quDingButton.layer.borderColor=RGBA(153, 153, 153, 1).CGColor;
//        _quDingButton.layer.borderWidth=1;
        
    }
    return _quDingButton;
}



@end

