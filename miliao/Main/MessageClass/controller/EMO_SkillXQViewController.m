//
//  EMO_SkillXQViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/26.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_SkillXQViewController.h"

@interface EMO_SkillXQViewController ()

Strong UIImageView *iconImagView;

Strong UIView *voiceBgView;
Strong UIButton *voiceBtn;
Strong UIButton *playBtn;

Strong UILabel *contentLabel;
Strong NSDictionary *dicData;

Strong UIButton *delBtn;

@end

@implementation EMO_SkillXQViewController

-(NSDictionary *)dicData{
    if(!_dicData){
        _dicData=[NSDictionary dictionary];
    }
    return _dicData;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if([PlayerManager sharedInstance].status==ETPlayer_Playing){
        [[PlayerManager sharedInstance] stop];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBar:YES needBack:YES needBackground:YES];
    self.leftButtonView.image = ImageNamed(@"xiaoxi_back");
    self.titleLabel.text=getLanguage(@"技能详情");
    self.view.backgroundColor = RGBA(255, 255, 255, 1);
    [self addData];
    [self iconImagView];
    [self voiceBgView];
    [self voiceBtn];
    [self playBtn];
    [self contentLabel];
    
    if(self.type==1){
        [self delBtn];
    }
    
}


- (UIImageView*)iconImagView{
    if (!_iconImagView) {
        _iconImagView = [[UIImageView alloc] init];
        _iconImagView.image=KGetImage(@"gameBgImg");
        [self.view addSubview:_iconImagView];
        [_iconImagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(345), KAdaptedHeight(215)));
            make.centerX.mas_equalTo(KAdaptedWidth(0));
        }];
        setViewCorner(_iconImagView, KAdaptedHeight(10));
    }
    return _iconImagView;
}


- (UIView *)voiceBgView{
    if (!_voiceBgView) {
        _voiceBgView = [[UIView alloc] init];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,KAdaptedWidth(70),KAdaptedHeight(25));
        gl.startPoint = CGPointMake(0, 0.5);
        gl.endPoint = CGPointMake(1, 0.5);
        gl.colors = @[(__bridge id)BaseMainColor.CGColor, (__bridge id)RGBA(255, 238, 1, 1).CGColor];
        gl.locations = @[@(0), @(1.0f)];
        [_voiceBgView.layer addSublayer:gl];
        [self.view addSubview:_voiceBgView];
        [_voiceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KAdaptedHeight(25));
            make.width.mas_equalTo(KAdaptedWidth(70));
            make.leading.mas_equalTo(self.iconImagView.mas_leading).offset(KAdaptedWidth(10));
            make.bottom.mas_equalTo(self.iconImagView.mas_bottom).offset(KAdaptedHeight(-15));
            
        }];
        setViewCorner(_voiceBgView, KAdaptedHeight(25)/2);
    }
    return _voiceBgView;
}

- (UIButton *)voiceBtn{
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBtn setTitle:@"0s" forState:UIControlStateNormal];
        [_voiceBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _voiceBtn.titleLabel.font=KFontA(12);
        [_voiceBtn setImage:[UIImage imageNamed:@"voiceImg"] forState:UIControlStateNormal];
        [_voiceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.voiceBgView addSubview:_voiceBtn];
        [_voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(KAdaptedWidth(5));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(50), KAdaptedHeight(20)));
        }];
        [_voiceBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];
    }
    return _voiceBtn;
}


- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"playImg"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"stopImg"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.voiceBgView addSubview:_playBtn];
        [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(25), KAdaptedWidth(25)));
        }];
       
    }
    return _playBtn;
}


- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text=getLanguage(@"暂无");
        _contentLabel.textColor = RGBA(51, 51, 51, 1);
        _contentLabel.font=KFontA(14);
        _contentLabel.numberOfLines=0;
        [self.view addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.top.mas_equalTo(self.iconImagView.mas_bottom).offset(KAdaptedHeight(15));
            make.height.mas_equalTo(KAdaptedHeight(30));
        }];
    }
    return _contentLabel;
}


- (UIButton *)delBtn{
    if (!_delBtn) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delBtn.backgroundColor=RGBA(241, 241, 241, 1);
        [_delBtn setTitle:getLanguage(@"删除技能") forState:UIControlStateNormal];
        [_delBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        _delBtn.titleLabel.font=KFontA(15);
        [_delBtn addTarget:self action:@selector(delBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_delBtn];
        [_delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(KAdaptedHeight(-36)-KSAFEAREA_BOTTOM_HEIHGHT);
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(50));
        }];
        setViewCorner(_delBtn, KAdaptedHeight(25));
    }
    return _delBtn;
}





-(void)btnClick:(UIButton *)sender{
    self.playBtn.selected=!self.playBtn.selected;
    if(self.playBtn.selected){
        [[PlayerManager sharedInstance]playWithVoiceURL:[NSURL URLWithString:[Common isNull:self.dicData[@"video_url"]]]];
//        [[PlayerManager sharedInstance] playWithVoiceURL:[NSURL URLWithString:@"https://heart-chat.oss-cn-beijing.aliyuncs.com/uploads/20230705/a312df7abb1d21f6caee92a0b8e53482.mp3"]];
        
    }else{
        [[PlayerManager sharedInstance] stop];
    }
    
    
}


-(void)delBtnClick{
    
    [NetworkRequest POST:Request_DelSkill parmeters:@{@"skill_id":self.skillID} success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failture:^(NSError *error) {
        
    }];
    
    
    
}



-(void)addData{
    
    WeakSelf;
    [NetworkRequest POST:Request_GetMySkillInfo parmeters:@{@"id":self.skillID} success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        wself.dicData=baseModel.data;
        [wself.iconImagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",wself.dicData[@"image"]]] placeholderImage:KGetImage(@"gameBgImg")];
        [wself.voiceBtn setTitle:[NSString stringWithFormat:@"%@s",wself.dicData[@"times"]] forState:UIControlStateNormal];
        wself.contentLabel.text=[Common isNull:wself.dicData[@"desc"]];
        
        
    } failture:^(NSError *error) {
        
    }];
    
    
    
    
    
}




@end
