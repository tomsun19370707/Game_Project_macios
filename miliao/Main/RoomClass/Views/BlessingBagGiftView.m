//
//  BlessingBagGiftView.m
//  miliao
//
//  Created by 张世浩 on 2022/5/28.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "BlessingBagGiftView.h"

@interface BlessingBagGiftView()
@property(nonatomic,strong) UIImageView * iconImgView;
@property(nonatomic,strong) UILabel * nameLabel;
@property(nonatomic,strong) UILabel * moneyLabel;
@property(nonatomic,strong) UIButton * moneyBtn;

@end


@implementation BlessingBagGiftView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    [self iconImgView];
    [self nameLabel];
//    [self moneyLabel];
    [self moneyBtn];
    
}



- (UIImageView*)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image=[UIImage imageNamed:@"未加载图片"];
        [self addSubview:_iconImgView];
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.bottom.mas_equalTo(KAdaptedHeight(-35));
            
        }];
    }
    return _iconImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"宝箱";
        _nameLabel.textColor = Color(255, 255, 255, 1);
        _nameLabel.textAlignment=NSTextAlignmentCenter;
        _nameLabel.font=KFont(10);
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(KAdaptedHeight(5));
            make.height.mas_equalTo(KAdaptedWidth(15));
            
        }];
    }
    return _nameLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"0";
        _moneyLabel.textColor = Color(102, 71, 204, 1);
        _moneyLabel.textAlignment=NSTextAlignmentCenter;
        _moneyLabel.font=KFont(9);
        [self addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedHeight(5));
            make.height.mas_equalTo(KAdaptedHeight(11));
            
        }];
    }
    return _moneyLabel;
}


- (UIButton *)moneyBtn{
    if (!_moneyBtn) {
        _moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moneyBtn.backgroundColor=RGBA(227, 227, 227, 0.35);
        [_moneyBtn setTitle:@"0" forState:UIControlStateNormal];
        [_moneyBtn setTitleColor:RGBA(207, 221, 248, 1) forState:UIControlStateNormal];
        _moneyBtn.titleLabel.font=KFontA(11);
        [_moneyBtn setImage:[UIImage imageNamed:@"coinSmallImg"] forState:UIControlStateNormal];
        _moneyBtn.userInteractionEnabled=NO;
        [self addSubview:_moneyBtn];
        [_moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedHeight(5));
            make.height.mas_equalTo(KAdaptedHeight(11));
            
        }];
        setViewCorner(_moneyBtn, KAdaptedHeight(11)/2);
    }
    return _moneyBtn;
}



-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    self.nameLabel.text=[NSString stringWithFormat:@"%@",dicData[@"gift_name"]];
        [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"gift_image"]]] placeholderImage:[UIImage imageNamed:@"未加载图片"]];
    
//        _moneyLabel.text=[NSString stringWithFormat:@"%@",dicData[@"price"]];
    
    [self.moneyBtn setTitle:[NSString stringWithFormat:@"%ld",[dicData[@"price"] integerValue]] forState:UIControlStateNormal];
    
    
    
    
    
}




@end
