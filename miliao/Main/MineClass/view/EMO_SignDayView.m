//
//  EMO_SignDayView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/30.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_SignDayView.h"

@interface EMO_SignDayView()

Strong UIView *bgViw;
Strong UIImageView  *selectImgViw;
Strong UIButton  *moneyBtn;
Strong UIImageView  *sevenImgViw;

Strong UILabel *dayLabel;

Strong UIButton  *clickBtn;

@end

@implementation EMO_SignDayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self bgViw];
        [self moneyBtn];
        [self sevenImgViw];
        [self selectImgViw];
        [self dayLabel];
        [self clickBtn];
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    
    if([dicData[@"type"] integerValue]==2){
        self.sevenImgViw.hidden=NO;
        self.moneyBtn.hidden=YES;
        [self.moneyBtn setTitle:@"" forState:UIControlStateNormal];
    }else{
        self.sevenImgViw.hidden=YES;
        self.moneyBtn.hidden=NO;
        [self.moneyBtn setTitle:[NSString stringWithFormat:@"%ld",[dicData[@"price"] integerValue]] forState:UIControlStateNormal];
    }
    [self.moneyBtn setImagePositionWithType:SSImagePositionTypeTop spacing:5];
    self.moneyBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    if([dicData[@"is_sign"]integerValue]==1){
        self.bgViw.backgroundColor=RGBA(247, 212, 91, 0.41);
        self.selectImgViw.hidden=NO;
        self.clickBtn.userInteractionEnabled=NO;
    }else{
        self.clickBtn.userInteractionEnabled=YES;
        self.selectImgViw.hidden=YES;
        self.bgViw.backgroundColor=RGBA(248, 248, 248, 1);
    }
    
    self.dayLabel.text=[NSString stringWithFormat:@"%@",dicData[@"day"]];
    
}


- (UIView *)bgViw{
    if (!_bgViw) {
        _bgViw = [[UIView alloc] init];
        _bgViw.backgroundColor = RGBA(248, 248, 248, 1);
        [self addSubview:_bgViw];
        [_bgViw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            make.bottom.mas_equalTo(KAdaptedHeight(-30));
            
        }];
        setViewCorner(_bgViw, KAdaptedHeight(5));
    }
    return _bgViw;
}


- (UIImageView*)sevenImgViw{
    if (!_sevenImgViw) {
        _sevenImgViw = [[UIImageView alloc] init];
        _sevenImgViw.image=KGetImage(@"gift2Img");//
        [self.bgViw addSubview:_sevenImgViw];
        [_sevenImgViw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.mas_equalTo(KAdaptedHeight(8));
            make.bottom.trailing.mas_equalTo(KAdaptedHeight(-8));
            
        }];
    }
    return _sevenImgViw;
}


- (UIButton *)moneyBtn{
    if (!_moneyBtn) {
        _moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moneyBtn setTitle:getLanguage(@"0") forState:UIControlStateNormal];
        [_moneyBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _moneyBtn.titleLabel.font=KFontA(11);
        [_moneyBtn setImage:[UIImage imageNamed:@"coinImg"] forState:UIControlStateNormal];
        _moneyBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
//        _moneyBtn.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        [self.bgViw addSubview:_moneyBtn];
        [_moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
        }];
        [_moneyBtn setImagePositionWithType:SSImagePositionTypeTop spacing:5];


    }
    return _moneyBtn;
}
- (UIImageView*)selectImgViw{
    if (!_selectImgViw) {
        _selectImgViw = [[UIImageView alloc] init];
        _selectImgViw.image=KGetImage(@"selectImg");//coinImg
        [self.bgViw addSubview:_selectImgViw];
        [_selectImgViw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.mas_equalTo(0);
            make.height.width.mas_equalTo(KAdaptedHeight(12));
            
        }];
    }
    return _selectImgViw;
}


- (UILabel *)dayLabel{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.text = getLanguage(@"第一天");
        _dayLabel.textColor = RGBA(0, 0, 0, 1);
        _dayLabel.font=KFontA(10);
        _dayLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_dayLabel];
        [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgViw.mas_bottom);
            make.leading.trailing.bottom.mas_equalTo(KAdaptedWidth(0));
        }];
    }
    return _dayLabel;
}


- (UIButton *)clickBtn{
    if (!_clickBtn) {
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clickBtn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_clickBtn];
        [_clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(KAdaptedWidth(0));
        }];
    }
    return _clickBtn;
}

-(void)BtnClick{
    
//    [SVProgressHUD showImage:KGetImage(@"") status:[NSString stringWithFormat:@"%@",self.dicData[@"day"]]];
    
    if(self.SignBlock){
        self.SignBlock(self.dicData);
    }
    
}



@end
