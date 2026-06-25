//
//  EMO_PersonalHeadView.m
//  miliao
//
//  Created by 张世浩 on 2023/6/25.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_PersonalHeadView.h"
#import "WZBGradualLabel.h"
#import "RoomPasswordView.h"
@interface EMO_PersonalHeadView()
Strong RoomPasswordView *passWordView;

Strong UIImageView *bgImgView;
Strong SVGAImageView *headSVGAImgView;
Strong UIImageView *headZBImgView;
Strong UIImageView *headImgView;
Strong UILabel *nickLabel;
Strong UIImageView *IDImgView;
Strong UIButton *idBtn;
Strong WZBGradualLabel *IDColorLabel;
Strong UIButton *followBtn;

Strong UIView *bgView;
Strong UILabel *followLabel;
Strong UILabel *faceLabel;
Strong UILabel *ipLabel;

Strong UIButton *ageBtn;
Strong UIButton *constellationBtn;
Strong UILabel *describeLabel;

Strong UIView *lineView;
Strong UIView *onlineView;
Strong UIImageView *onlineImg;
Strong UILabel *onlineLabel;
Strong UIImageView *levelImg;
Strong UIView *rightLiveView;
Strong UIButton *rightLiveBtn;
Assign BOOL is_attention;

@end

@implementation EMO_PersonalHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor=[UIColor clearColor];
        [self bgImgView];
        [self headImgView];
        [self headZBImgView];
        [self headSVGAImgView];
        [self nickLabel];
        [self onlineView];
        [self IDImgView];
        [self idBtn];
        [self IDColorLabel];
        [self followBtn];
        [self bgView];
        [self followLabel];
        [self faceLabel];
        [self ipLabel];
        [self ageBtn];
        [self constellationBtn];
        [self describeLabel];
        [self lineView];
        [self rightLiveView];
        [self levelImg];
        self.layer.masksToBounds=YES;
        self.IDImgView.hidden=YES;
    }
    return self;
}

-(void)setLevel_image:(NSString *)level_image{
    if([level_image containsString:@"http"]){
        [self.levelImg sd_setImageWithURL:[NSURL URLWithString:level_image] placeholderImage:defaultionPhotoIcon];
    }else{
        if(![Common isEmptyString:level_image]){
            self.levelImg.image = KGetImage(level_image);
        }
    }
    
}

-(void)setRoomDic:(NSDictionary *)roomDic{
    _roomDic = roomDic;
    if(![Common isEmptyString:roomDic[@"name"]]){
        self.rightLiveView.hidden = NO;
        NSString *liveName = [NSString stringWithFormat:@"  %@  ",roomDic[@"name"]];
        [self.rightLiveBtn setTitle:liveName forState:UIControlStateNormal];
    }else{
        self.rightLiveView.hidden = YES;
    }
}
-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    int online = [dicData[@"online"] intValue];
    self.onlineView.hidden = online==1?NO:YES;
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"cover_image"]]]placeholderImage:KGetImage(@"未加载头像")];
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"avatar"]]]placeholderImage:KGetImage(@"未加载头像")];

    NSString *svgaUrl=[NSString stringWithFormat:@"%@",dicData[@"avatar_frame_svga_file"]];
    if ([svgaUrl hasSuffix:@".svga"]||[svgaUrl hasSuffix:@".SVGA"]) {
        self.headSVGAImgView.imageName=svgaUrl;
    }else{
        [self.headZBImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"avatar_frame_image"]]]];
    }
    
    self.nickLabel.text=[Common isNull:dicData[@"nickname"]];
    NSString *idStr=[Common isNull:dicData[@"uuid"]];
    [self.IDColorLabel removeFromSuperview];
    if(([idStr integerValue]>0)&&([idStr integerValue]!=[dicData[@"id"] integerValue])){
        self.IDColorLabel= [WZBGradualLabel gradualLabelWithFrame:(CGRect){0, 0, 100, KAdaptedHeight(55)/2} title:idStr duration:1.5  superview:self.idBtn];
        self.IDColorLabel.gradualColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor cyanColor], [UIColor blueColor], [UIColor purpleColor]];
        self.IDColorLabel.font = KFontA(12);
        self.IDColorLabel.textAlignment = NSTextAlignmentLeft;
        self.IDColorLabel.textColor=RGBA(255, 255, 255, 1);
        [self.idBtn setTitleColor:kClearColor forState:0];
        [self.idBtn setTitle:[Common isNull:dicData[@"uuid"]] forState:UIControlStateNormal];
        self.IDImgView.hidden=NO;
        [self.IDImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedWidth(15));
        }];
    }else{
        self.IDImgView.hidden=YES;
        [self.IDImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        [self.idBtn setTitleColor:RGBA(255, 255, 255, 1) forState:0];
        [self.idBtn setTitle:[Common isNull:dicData[@"id"]] forState:UIControlStateNormal];
    }
    [self.idBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];

    self.ipLabel.text = [NSString stringWithFormat:@"IP:%@",dicData[@"city"]];
    self.faceLabel.text = [NSString stringWithFormat:@"粉丝 %@",dicData[@"fans_nums"]];
    self.followLabel.text = [NSString stringWithFormat:@"关注 %@",dicData[@"attention_nums"]];
    self.describeLabel.text = [Common isNull:dicData[@"bio"]];
    
    NSString *constellationStr=[Common isNull:dicData[@"constellation"]];
    if(constellationStr.length>0){
        [self.constellationBtn setTitle:constellationStr forState:UIControlStateNormal];
        [self.constellationBtn setImage:[UIImage imageNamed:constellationStr] forState:UIControlStateNormal];
    }else{
        self.constellationBtn.hidden=YES;
    }
   
    [self.ageBtn setTitle:[NSString stringWithFormat:@"%@",dicData[@"age"]] forState:UIControlStateNormal];
    if([dicData[@"sex"] integerValue]==1){
        self.ageBtn.backgroundColor=RGBA(0, 168, 255, 1);
        [self.ageBtn setImage:[UIImage imageNamed:@"manImg"] forState:UIControlStateNormal];
        
    }else{
        [self.ageBtn setImage:[UIImage imageNamed:@"womanImg"] forState:UIControlStateNormal];
        self.ageBtn.backgroundColor=RGBA(255, 92, 100, 1);
    }

    if([dicData[@"id"] integerValue]==[[UserManager userInfo].user_id integerValue]){
        self.followBtn.hidden=YES;
        
    }else{
        self.followBtn.hidden=NO;
        if([dicData[@"is_attention"] integerValue]==1){
            [self.followBtn setTitle:getLanguage(@"取消关注") forState:UIControlStateNormal];
            self.is_attention=YES;
        }else{
            self.is_attention=NO;
            [self.followBtn setTitle:getLanguage(@"关注") forState:UIControlStateNormal];
        }
    }
}

- (RoomPasswordView *)passWordView{
    if (!_passWordView) {
        _passWordView = [[RoomPasswordView alloc] initWithFrame:CGRectMake(0, 0, ScreenViewWidth, ScreenViewHeight)];
    }
    return _passWordView;
}

- (UIImageView*)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image=KGetImage(@"未加载头像");
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.clipsToBounds = YES;
        [self addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(210));
 
        }];
        
       UIImageView *bgImgView1 = [[UIImageView alloc] init];
        bgImgView1.backgroundColor=RGBA(0, 0, 0, 0.2);
        [_bgImgView addSubview:bgImgView1];
        [bgImgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.bottom.mas_equalTo(KAdaptedHeight(0));
        }];
    }
    return _bgImgView;
}

- (UIImageView*)headZBImgView{
    if (!_headZBImgView) {
        _headZBImgView = [[UIImageView alloc] init];
        _headZBImgView.layer.cornerRadius=KAdaptedHeight(75)/2;
        _headZBImgView.layer.masksToBounds=YES;
        [self addSubview:_headZBImgView];
        [_headZBImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedHeight(75));
            make.centerX.mas_equalTo(self.headImgView.mas_centerX);
            make.centerY.mas_equalTo(self.headImgView.mas_centerY);
            
        }];
    }
    return _headZBImgView;
}

- (SVGAImageView *)headSVGAImgView{
    if (!_headSVGAImgView) {
        _headSVGAImgView = [[SVGAImageView alloc] init];
        _headSVGAImgView.contentMode=UIViewContentModeScaleToFill;
        _headSVGAImgView.autoPlay=YES;
        [self addSubview:_headSVGAImgView];
        [_headSVGAImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedHeight(75));
            make.centerX.mas_equalTo(self.headImgView.mas_centerX);
            make.centerY.mas_equalTo(self.headImgView.mas_centerY);
            
        }];
    }
    return _headSVGAImgView;
}

- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"未加载头像");
        _headImgView.layer.cornerRadius=KAdaptedHeight(55)/2;
        _headImgView.layer.borderWidth=2;
        _headImgView.layer.borderColor=kWhiteColor.CGColor;
        _headImgView.layer.masksToBounds=YES;
        [self addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.bgImgView.mas_bottom).offset(KAdaptedHeight(-38));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.width.height.mas_equalTo(KAdaptedHeight(55));
        }];
    }
    return _headImgView;
}

- (UIImageView*)levelImg{
    if (!_levelImg) {
        _levelImg = [[UIImageView alloc] init];
        [self addSubview:_levelImg];
        [_levelImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgView.mas_bottom).offset(KAdaptedHeight(-10));
//            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.centerX.equalTo(self.headImgView);
            make.width.mas_equalTo(KAdaptedHeight(67));
            make.height.mas_equalTo(KAdaptedHeight(20));
        }];
    }
    return _levelImg;
}

- (UILabel *)nickLabel{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.text = @"昵称";
        _nickLabel.font=KFontBold(15);
        _nickLabel.textColor = RGBA(255, 255, 255, 1);
        [self addSubview:_nickLabel];
        [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgView.mas_top);
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(10));
            make.bottom.mas_equalTo(self.headImgView.mas_centerY);
        }];
    }
    return _nickLabel;
}

-(UIView *)onlineView{
    if(!_onlineView){
        _onlineView = [[UIView alloc] init];
        _onlineView.backgroundColor = UIColor.clearColor;
        [self addSubview:_onlineView];
        [_onlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nickLabel.mas_right).offset(6);
            make.height.mas_offset(15);
            make.centerY.equalTo(self.nickLabel);
        }];
        
        self.onlineImg = [[UIImageView alloc] init];
        self.onlineImg.backgroundColor = [UIColor colorWithHexString:@"#17E800"];
        [self.onlineView addSubview:self.onlineImg];
        [self.onlineImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(5);
            make.centerY.equalTo(self.onlineView);
            make.width.height.mas_offset(8);
        }];
        setViewCorner(self.onlineImg, 4);
        
        self.onlineLabel = [[UILabel alloc] init];
        self.onlineLabel.textColor = UIColor.whiteColor;
        self.onlineLabel.backgroundColor = [UIColor clearColor];
        self.onlineLabel.textAlignment = NSTextAlignmentLeft;
        self.onlineLabel.font = KFont(9);
        self.onlineLabel.text = @"在线";
        [self.onlineView addSubview:self.onlineLabel];
        [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.onlineImg.mas_right).offset(4);
            make.centerY.equalTo(self.onlineImg);
            make.height.mas_offset(15);
        }];
    }
    return _onlineView;
}

- (UIImageView*)IDImgView{
    if (!_IDImgView) {
        _IDImgView = [[UIImageView alloc] init];
        _IDImgView.image=KGetImage(@"liangIconImg");
        [self addSubview:_IDImgView];
        [_IDImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedHeight(15));
            make.height.mas_equalTo(KAdaptedHeight(15));
            make.top.mas_equalTo(self.nickLabel.mas_bottom).offset(KAdaptedHeight(7));
            make.leading.mas_equalTo(self.nickLabel.mas_leading);
        }];
    }
    return _IDImgView;
}
- (UIButton *)idBtn{
    if (!_idBtn) {
        _idBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_idBtn setTitle:getLanguage(@"ID:123456789") forState:UIControlStateNormal];
        [_idBtn setTitleColor:RGBA(255, 255, 255, 1) forState:0];
        _idBtn.titleLabel.font=KFontA(12);
        [_idBtn setImage:[UIImage imageNamed:@"copyImg"] forState:UIControlStateNormal];
        [_idBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _idBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        _idBtn.tag=100;
        [self addSubview:_idBtn];
        [_idBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nickLabel.mas_bottom);
            make.width.mas_equalTo(KAdaptedWidth(100));
            make.bottom.mas_equalTo(self.headImgView.mas_bottom);
            make.leading.mas_equalTo(self.IDImgView.mas_trailing).offset(KAdaptedWidth(5));
            
        }];
        [_idBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];
    }
    return _idBtn;
}

- (UIButton *)followBtn{
    if (!_followBtn) {
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followBtn setTitle:getLanguage(@"关注") forState:UIControlStateNormal];
        [_followBtn setTitleColor:RGBA(255, 255, 255, 1) forState:0];
        _followBtn.titleLabel.font=KFontA(13);
        _followBtn.layer.borderColor=RGBA(255, 255, 255, 1).CGColor;
        _followBtn.layer.borderWidth=1;
        _followBtn.layer.cornerRadius=KAdaptedHeight(13);
        _followBtn.layer.masksToBounds=YES;
        [_followBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _followBtn.tag=200;
        [self addSubview:_followBtn];
        [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.headImgView.mas_centerY);
            make.width.mas_equalTo(KAdaptedWidth(100));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(26));
            
        }];
    }
    return _followBtn;
}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius=KAdaptedHeight(10);
        _bgView.layer.masksToBounds=YES;
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgView.mas_bottom).offset(KAdaptedHeight(20));
            make.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(KAdaptedHeight(20));
            
        }];
    }
    return _bgView;
}

- (UILabel *)followLabel{
    if (!_followLabel) {
        _followLabel = [[UILabel alloc] init];
        _followLabel.text = @"关注 0";
        _followLabel.font=KFont(14);
        _followLabel.textColor = RGBA(51, 51, 51, 1);
        [self.bgView addSubview:_followLabel];
        [_followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(15));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.width.mas_equalTo(KAdaptedWidth(70));
            make.height.mas_equalTo(KAdaptedHeight(20));
        }];
    }
    return _followLabel;
}

- (UILabel *)faceLabel{
    if (!_faceLabel) {
        _faceLabel = [[UILabel alloc] init];
        _faceLabel.text = @"粉丝 0";
        _faceLabel.font=KFont(14);
        _faceLabel.textColor = RGBA(51, 51, 51, 1);
        [self.bgView addSubview:_faceLabel];
        [_faceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(15));
            make.leading.mas_equalTo(self.followLabel.mas_trailing).offset(KAdaptedWidth(15));
            make.width.mas_equalTo(KAdaptedWidth(70));
            make.height.mas_equalTo(KAdaptedHeight(20));
        }];
    }
    return _faceLabel;
}

- (UILabel *)ipLabel{
    if (!_ipLabel) {
        _ipLabel = [[UILabel alloc] init];
        _ipLabel.text = @"IP:北京";
        _ipLabel.font=KFont(13);
        _ipLabel.textColor = RGBA(51, 51, 51, 1);
        _ipLabel.backgroundColor=RGBA(153, 153, 153, 0.15);
        _ipLabel.layer.cornerRadius=KAdaptedHeight(10);
        _ipLabel.layer.masksToBounds=YES;
        _ipLabel.textAlignment=NSTextAlignmentCenter;
        [self.bgView addSubview:_ipLabel];
        [_ipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.width.mas_equalTo(KAdaptedWidth(70));
            make.height.mas_equalTo(KAdaptedHeight(20));
        }];
    }
    return _ipLabel;
}

- (UIButton *)ageBtn{
    if (!_ageBtn) {
        _ageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _ageBtn.backgroundColor=RGBA(255, 92, 100, 1);
        [_ageBtn setTitle:getLanguage(@"22") forState:UIControlStateNormal];
        [_ageBtn setTitleColor:RGBA(255, 255, 255, 1) forState:0];
        _ageBtn.titleLabel.font=KFontA(12);
        [_ageBtn setImage:[UIImage imageNamed:@"womanImg"] forState:UIControlStateNormal];
        _ageBtn.layer.cornerRadius=KAdaptedHeight(8);
        _ageBtn.layer.masksToBounds=YES;
        [self.bgView addSubview:_ageBtn];
        [_ageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.followLabel.mas_bottom).offset(KAdaptedHeight(12));
            make.width.mas_equalTo(KAdaptedWidth(40));
            make.leading.mas_equalTo(self.followLabel.mas_leading);
            make.height.mas_equalTo(KAdaptedHeight(16));
        }];
        [_ageBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:2];
        
    }
    return _ageBtn;
}

- (UIView *)rightLiveView{
    if (!_rightLiveView) {
        _rightLiveView = [[UIView alloc] init];
        _rightLiveView.hidden = YES;
        _rightLiveView.backgroundColor = [UIColor colorWithHexString:@"#FFEE01"];
        [self addSubview:_rightLiveView];
        [_rightLiveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(10);
            make.height.mas_offset(30);
            make.bottom.equalTo(self.headImgView.mas_top);
        }];
        setViewCorner(_rightLiveView, 15);
        
        _rightLiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightLiveBtn setImage:KGetImage(@"UY_ZhuYeLive") imageHL:0];
        [_rightLiveBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:0];
        _rightLiveBtn.titleLabel.font=KFontA(13);
        [_rightLiveBtn addTarget:self action:@selector(liveClick) forControlEvents:UIControlEventTouchUpInside];
        [_rightLiveView addSubview:_rightLiveBtn];
        [_rightLiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-5);
            make.left.mas_offset(5);
            make.top.bottom.mas_offset(0);
        }];
    }
    return _rightLiveView;
}

//进入直播间
-(void)liveClick{
    [self getIntoTheRoom:self.roomDic passWord:@""];
}



- (UIButton *)constellationBtn{
    if (!_constellationBtn) {
        _constellationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _constellationBtn.backgroundColor=RGBA(174, 81, 255, 1);
        _constellationBtn.layer.cornerRadius = KAdaptedHeight(8);
        _constellationBtn.layer.masksToBounds=YES;
        [_constellationBtn setTitle:getLanguage(@"金牛") forState:UIControlStateNormal];
        [_constellationBtn setTitleColor:RGBA(255, 255, 255, 1) forState:0];
        _constellationBtn.titleLabel.font=KFontA(12);
        [_constellationBtn setImage:[UIImage imageNamed:@"xingzuoImg"] forState:UIControlStateNormal];
        [self.bgView addSubview:_constellationBtn];
        [_constellationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.ageBtn.mas_top);
            make.leading.mas_equalTo(self.ageBtn.mas_trailing).offset(KAdaptedWidth(12));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(60), KAdaptedHeight(16)));
        }];
        [_constellationBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:2];
    }
    return _constellationBtn;
}

- (UILabel *)describeLabel{
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.text = @"每天都是开心的一天";
        _describeLabel.font=KFont(14);
        _describeLabel.textColor = RGBA(51, 51, 51, 1);
        [self.bgView addSubview:_describeLabel];
        [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.ageBtn.mas_bottom).offset(KAdaptedHeight(12));
            make.leading.mas_equalTo(self.followLabel.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(20));
        }];
    }
    return _describeLabel;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBA(241, 241, 241, 1);
        [self.bgView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(KAdaptedHeight(-20));
            make.height.mas_equalTo(KAdaptedHeight(1));
        }];
    }
    return _lineView;
}

-(void)btnClick:(UIButton *)sender{
    
    if(sender.tag==100){
        UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
        pastboard.string = [NSString stringWithFormat:@"%@",self.idBtn.titleLabel.text];
        [SVProgressHUD showSuccessWithStatus:getLanguage(@"已经复制到剪切板")];
    }else{
        
        [NetworkRequest POST:Request_GetfollowOrBlack parmeters:@{@"type":@"0",@"to_uid":self.dicData[@"id"]} success:^(id responObject) {
            BaseModel *basemodel=(BaseModel *)responObject;
            [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:basemodel.msg]];
            self.is_attention=!self.is_attention;
            if(self.is_attention){
                [self.followBtn setTitle:getLanguage(@"取消关注") forState:UIControlStateNormal];
            }else{
                [self.followBtn setTitle:getLanguage(@"关注") forState:UIControlStateNormal];
            }

        } failture:^(NSError *error) {

        }];
    }
}

#pragma  mark 进入房间前获取RTCtoken

-(void)getIntoTheRoom:(NSDictionary *)dic passWord:(NSString *)passWord{
    WeakSelf;
    
    [NetworkRequest POST:Request_Get_rtc_token parmeters:@{@"room_id":dic[@"id"]} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        UserDefaultsSave(basemodel.data,@"ShengWangRTCToken");
        [wself getRoomInformationWithModel:dic passWord:passWord];
        
    } failture:^(NSError *error) {
        
    }];
}

#pragma mark 进入房间
- (void)getRoomInformationWithModel:(NSDictionary *)model passWord:(NSString *)passWord{
    WeakSelf;
    [NetworkRequest POST:Request_EnterRoom parmeters:passWord.length<1?@{@"room_id":model[@"id"]}:@{@"room_id":model[@"id"],@"password":passWord} success:^(id responObject) {
        BaseModel *basemolde=(BaseModel *)responObject;
//        code 1开播 2未开播  3加锁
        if(basemolde.code==1){
            EMO_MLRoomNewVC *vc=[EMO_MLRoomNewVC new];
            MLRoomInformationModel *mode=[MLRoomInformationModel mj_objectWithKeyValues:basemolde.data[@"room_info"]];
            mode.microphone_position=basemolde.data[@"microphone_position"];
            NSDictionary *userDic=[NSDictionary dictionary];
            userDic=basemolde.data[@"userinfo"];
            mode.userinfo=userDic;
            mode.is_muted=[userDic[@"is_muted"] boolValue];
            mode.user_type=[Common isNullNumber:userDic[@"type"]];
                MLRoomInformationModel *model1 = [MLRoomInformationModel currentAccount];
            [model1 mj_setKeyValues:mode];
            
            [wself.navigationController pushViewController:vc animated:YES];
        }else if(basemolde.code==3){
            [[UIApplication sharedApplication].delegate.window addSubview:self.passWordView];
            [self.passWordView setDicModel:model];
            WeakSelf;
            self.passWordView.sendDicSeBlock = ^(NSDictionary *model, NSString *text) {
                [wself getIntoTheRoom:model passWord:text];
            };
        }else {
            [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:basemolde.msg]];
        }

    } failture:^(NSError *error) {
        
    }];
}



@end
