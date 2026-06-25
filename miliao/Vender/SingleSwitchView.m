//
//  SingleSwitchView.m
//  NormalProject
//
//  Created by 大靠山Mac mini on 2021/10/18.
//  Copyright © 2021 WYL. All rights reserved.
//

#import "SingleSwitchView.h"


@interface SingleSwitchView ()


@end


@implementation SingleSwitchView

//-(instancetype)initWithType:(NSInteger)type{
-(instancetype)init{
    
    if (self = [super init]) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text=@"";
        _nameLabel.font =KFont(12);
        [self addSubview:_nameLabel];
        
       
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mian_xunzhang"]];
        [self addSubview:_icon];
       
        _icon.hidden = YES;
        
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text=@"显示提示内容";
        _tipLabel.textColor=Color(38, 38, 38, 0.27);
        _tipLabel.font = KFont(10);
        [self addSubview:_tipLabel];
        
        _tipLabel.hidden=YES;
        
        _switchBtn=[[UISwitch alloc] init];
        _switchBtn.backgroundColor=RGBA(128, 128, 128, 1);
        [_switchBtn setOnTintColor: BaseMainColor];
        [_switchBtn addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        _switchBtn.on=false;
        _switchBtn.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _switchBtn.layer.cornerRadius=15;
        _switchBtn.layer.masksToBounds=YES;
        [self addSubview:_switchBtn];
       
        
        _lineView = [[UIView alloc] init];
//        _lineView.alpha = 0.2;
        _lineView.backgroundColor = Color(246, 248, 250, 1);
        [self addSubview:_lineView];
        [self layoutSubviewsAA];
    }
    return self;
}

-(void)layoutSubviewsAA{
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KAdaptedWidth(5));
        make.leading.mas_equalTo(KAdaptedWidth(15));
        make.trailing.mas_equalTo(self.mas_trailing).offset(-80);
        make.bottom.mas_equalTo(self.mas_bottom).offset(KAdaptedWidth(-5));
    }];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(KAdaptedWidth(7));
        make.width.mas_equalTo(KAdaptedWidth(10));
        make.height.mas_equalTo(KAdaptedWidth(13));
    }];
    
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedWidth(5));
        make.leading.mas_equalTo(self.nameLabel.mas_leading);
        make.trailing.mas_equalTo(self.nameLabel.mas_trailing);
        make.bottom.mas_equalTo(self.mas_bottom).offset(KAdaptedWidth(-5));
    }];
    
    
    [_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).offset(KAdaptedWidth(-15));
        make.centerY.equalTo(self.nameLabel.mas_centerY);
   
    }];
    
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

-(void)setNameStr:(NSString *)nameStr{
    _nameLabel.text=nameStr;
    
    
}
-(void)setTipStr:(NSString *)tipStr{
    _tipLabel.text=tipStr;
}
-(void)setShowIcon:(BOOL)showIcon{
    if (showIcon==NO) {
        _icon.hidden=NO;
    }
}

-(void)setShowTipLabel:(BOOL)showTipLabel{
    if (showTipLabel==NO) {
        _tipLabel.hidden=NO;
        
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-40);

        }];
        [_nameLabel layoutIfNeeded];

    }
    
    
}


- (void) switchChange:(UISwitch*)sw {
    
    if (self.SwitchClick) {
        self.SwitchClick(sw.on);
    }
    
}





@end
