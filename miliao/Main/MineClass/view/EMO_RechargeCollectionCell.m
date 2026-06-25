//
//  EMO_RechargeCollectionCell.m
//  miliao
//
//  Created by 张世浩 on 2022/10/17.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_RechargeCollectionCell.h"

@interface EMO_RechargeCollectionCell ()
@property(nonatomic,strong) UIView * bgView;
@property(nonatomic,strong) UIView * bgBorderView;
@property(nonatomic,strong) UIImageView * iconImg;
@property(nonatomic,strong) UILabel * coinLabel;
@property(nonatomic,strong) UILabel * moneyLabel;

@end


@implementation EMO_RechargeCollectionCell


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self bgView];
        [self bgBorderView];
        [self iconImg];
        [self coinLabel];
        [self moneyLabel];
//        self.bgBorderView.hidden=YES;

    }
    
    return self;
    

}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    self.coinLabel.text=[NSString stringWithFormat:@"%@",dicData[@"ios_price"]];;
    self.moneyLabel.text=[NSString stringWithFormat:@"%@%@",dicData[@"money"],getLanguage(@"元")];
}

-(void)setShowBorder:(BOOL)showBorder{
    _showBorder=showBorder;
    self.bgBorderView.hidden=!showBorder;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.bgBorderView.hidden=!selected;

}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius=KAdaptedHeight(10);
        _bgView.layer.shadowColor = RGBA(168, 168, 168, 0.16).CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(0,0);
        _bgView.layer.shadowOpacity = 1;
        _bgView.layer.shadowRadius = 4;
//        _bgView.layer.masksToBounds=YES;
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.mas_equalTo(KAdaptedWidth(5));
            make.bottom.trailing.mas_equalTo(KAdaptedWidth(-5));
            
            
        }];
    }
    return _bgView;
}

- (UIView *)bgBorderView{
    if (!_bgBorderView) {
        _bgBorderView = [[UIView alloc] init];
        _bgBorderView.backgroundColor = RGBA(255, 252, 243, 1);
        _bgBorderView.layer.cornerRadius=KAdaptedHeight(10);
        _bgBorderView.layer.borderWidth=KAdaptedWidth(0.5);
        _bgBorderView.layer.borderColor=BaseMainColor.CGColor;
        _bgBorderView.layer.masksToBounds=YES;
        [self.bgView addSubview:_bgBorderView];
        [_bgBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(KAdaptedWidth(0));
            
        }];
    }
    return _bgBorderView;
}


- (UIImageView*)iconImg{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.image=KGetImage(@"coinImg");
        [self.bgView addSubview:_iconImg];
        [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedWidth(17));
//            make.centerY.mas_equalTo(0);
            make.bottom.mas_equalTo(self.bgView.mas_centerY);
            make.leading.mas_equalTo(KAdaptedWidth(8));
        }];
    }
    return _iconImg;
}

- (UILabel *)coinLabel{
    if (!_coinLabel) {
        _coinLabel = [[UILabel alloc] init];
        _coinLabel.text = @"666.00";
        _coinLabel.textColor = RGBA(34, 34, 34, 1);
        _coinLabel.font=KFontBold(15);
        [self.bgView addSubview:_coinLabel];
        [_coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.bgView.mas_centerY);
            make.leading.mas_equalTo(self.iconImg.mas_trailing).offset(KAdaptedWidth(7));
            make.trailing.mas_equalTo(KAdaptedWidth(-5));
            make.height.mas_equalTo(KAdaptedWidth(20));
        }];
    }
    return _coinLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = [NSString stringWithFormat:@"%@",getLanguage(@"元")];
        _moneyLabel.textColor = RGBA(153, 153, 153, 1);
        _moneyLabel.font=KFont(14);
        [self.bgView addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgView.mas_centerY);
            make.leading.mas_equalTo(self.coinLabel.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(self.coinLabel.mas_trailing).offset(KAdaptedWidth(0));
            make.height.mas_equalTo(self.coinLabel.mas_height);
        }];
    }
    return _moneyLabel;
}




@end
