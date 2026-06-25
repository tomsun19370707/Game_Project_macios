//
//  EMO_EndPlayViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/19.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_EndPlayViewController.h"

@interface EMO_EndPlayViewController ()
Strong UIImageView *bgImgView;
Strong UIButton *backBtn;
Strong UILabel *tipLabel;
Strong UIImageView *headImgView;
Strong UILabel *nameLabel;
Strong UIButton *startPlayBtn;


@end

@implementation EMO_EndPlayViewController

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBar:YES needBack:YES needBackground:YES];
    self.barView.backgroundColor=kClearColor;
    [self bgImgView];
    [self backBtn];
    [self tipLabel];
    [self headImgView];
    [self nameLabel];
    [self startPlayBtn];

    
}

- (UIImageView*)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image=KGetImage(@"roombg2");
        [self.view addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(KAdaptedWidth(0));
        }];
    }
    return _bgImgView;
}


- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"closeBackImg"] forState:UIControlStateNormal];
        _backBtn.tag=200;
        [_backBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.imageEdgeInsets=UIEdgeInsetsMake(6, 6, -6, -6);
        [self.view addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedWidth(35));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.top.mas_equalTo(ZJTopNavH);
            
            
        }];
    }
    return _backBtn;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = getLanguage(@"当前直播结束");
        _tipLabel.textColor = kWhiteColor;
        _tipLabel.font=KFontBold(16);
        _tipLabel.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(120));
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(30));
        }];
    }
    return _tipLabel;
}


- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dicData[@"image"]]]placeholderImage:KGetImage(@"未加载头像")];
        [self.view addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(KAdaptedHeight(30));
            make.width.height.mas_equalTo(KAdaptedHeight(60));
            make.centerX.mas_equalTo(KAdaptedWidth(0));
        }];
        setViewCorner(_headImgView, KAdaptedHeight(60)/2);
    }
    return _headImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
//        _nameLabel.text = getLanguage(@"昵称");
        _nameLabel.text=[Common isNull:self.dicData[@"name"]];
        _nameLabel.textColor = kWhiteColor;
        _nameLabel.font=KFontA(14);
        _nameLabel.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgView.mas_bottom).offset(KAdaptedHeight(15));
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(30));
        }];
    }
    return _nameLabel;
}

- (UIButton *)startPlayBtn{
    if (!_startPlayBtn) {
        _startPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startPlayBtn.layer.borderColor=BaseMainColor.CGColor;
        _startPlayBtn.layer.borderWidth=1;
        _startPlayBtn.layer.cornerRadius = KAdaptedHeight(40)/2;
        _startPlayBtn.layer.masksToBounds=YES;
        [_startPlayBtn setTitle:getLanguage(@"返回") forState:UIControlStateNormal];
        [_startPlayBtn setTitleColor:BaseMainColor forState:UIControlStateNormal];
        _startPlayBtn.titleLabel.font=KFontBold(15);
        _startPlayBtn.tag=100;
        [_startPlayBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_startPlayBtn];
        [_startPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KAdaptedHeight(40));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.bottom.mas_equalTo(KAdaptedHeight(-35));
            
        }];
    }
    return _startPlayBtn;
}

-(void)BtnClick:(UIButton *)sender{
    if(self.type==1){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}




@end
