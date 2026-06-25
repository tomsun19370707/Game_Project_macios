//
//  EMO_DressingCenterHeadView.m
//  miliao
//
//  Created by 张世浩 on 2022/12/1.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_DressingCenterHeadView.h"
#import "EMO_DressingCenterBaseVC.h"//我的装扮
#import "WZBGradualLabel.h"
@interface EMO_DressingCenterHeadView ()
//Strong UIView *bgView;
Strong UIImageView *bgImgVIiew;
Strong UIButton *backBtn;
Strong UILabel *titleLabel;
Strong UIButton *myBtn;
Strong UIView *userBgView;
Strong SVGAImageView *headZBImgView;
Strong UIImageView *headImgView;
Strong UIImageView *headBoxView;
Strong UILabel *nameLabel;
Strong UILabel *IDLabel;
Strong WZBGradualLabel *IDColorLabel;

@end


@implementation EMO_DressingCenterHeadView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor= RGBA(248, 248, 248, 1);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectChange:) name:@"HeadChange" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectChangeID:) name:@"HeadChangeID" object:nil];
    }
    return self;
}

-(void)setType:(NSInteger)type{
    _type=type;
    if(self.type==2){
//        self.myBtn.hidden=NO;
        [_myBtn setTitle:getLanguage(@"商城") forState:UIControlStateNormal];
    }else{
//        self.myBtn.hidden=YES;
        [_myBtn setTitle:getLanguage(@"我的") forState:UIControlStateNormal];
    }
    
            
}

- (void)initView{
    [self bgImgVIiew];
    [self backBtn];
    [self titleLabel];
    [self myBtn];
    [self userBgView];
    [self headImgView];
    [self headBoxView];
    [self headZBImgView];
    [self nameLabel];
    [self IDLabel];
    if([UserManager userInfo].avatar_frame_svga_file.length>0){
        self.headBoxView.hidden=YES;
    }
    
    self.IDLabel.text = [NSString stringWithFormat:@"    ID:%@",[Common isNull:[UserManager userInfo].user_id]];
    [self.IDColorLabel removeFromSuperview];
    if ([[UserManager userInfo].uuid integerValue]>0) {
        self.IDColorLabel= [WZBGradualLabel gradualLabelWithFrame:(CGRect){0, 0, kWidth/2, 25} title:[NSString stringWithFormat:@"ID:%@",[UserManager userInfo].uuid] duration:1.5 superview:self.IDLabel];
        self.IDColorLabel.gradualColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor cyanColor], [UIColor blueColor], [UIColor purpleColor]];
        self.IDColorLabel.font = KFontA(12);
        self.IDColorLabel.textAlignment = NSTextAlignmentCenter;
        self.IDColorLabel.textColor=RGBA(153, 153, 153, 1);
        self.IDLabel.textColor=RGBA(255, 255, 255, 0.1);
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.IDLabel.text];
//        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
//        attchment.bounds=CGRectMake(-30,0,15,15);//设置frame
//        attchment.image=[UserManager userInfo].uuid.length>0?KGetImage(@"liangIconImg"):KGetImage(@"");//设置图片
//        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
//    //    [attributedString appendAttributedString:string]; //添加到尾部
//        [attributedString insertAttributedString:string atIndex:0]; //添加到前边
//        self.IDLabel.attributedText = attributedString;
    }else{
        self.IDLabel.textColor=RGBA(153, 153, 153, 1);
        
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.IDLabel.text];
    NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
    attchment.bounds=CGRectMake(-30,0,15,15);//设置frame
    attchment.image=[UserManager userInfo].uuid.length>0?KGetImage(@"liangIconImg"):KGetImage(@"");//设置图片
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
//    [attributedString appendAttributedString:string]; //添加到尾部
    [attributedString insertAttributedString:string atIndex:0]; //添加到前边
    self.IDLabel.attributedText = attributedString;
    
    
}


-(void)BtnClick:(UIButton *)sender{
    if(sender.tag==100){
        [[Common getCurrentVC].navigationController popViewControllerAnimated:YES];
    }else{
        if(self.type==2){
            EMO_DressingCenterBaseVC *vc=[EMO_DressingCenterBaseVC new];
            vc.type=1;
            [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
        }else{
            [[Common getCurrentVC].navigationController popViewControllerAnimated:YES];
        }
        
    }
    
}



- (UIImageView*)bgImgVIiew{
    if (!_bgImgVIiew) {
        _bgImgVIiew = [[UIImageView alloc] init];
        _bgImgVIiew.image=KGetImage(@"dressingTopBgImg");
        [self addSubview:_bgImgVIiew];
        [_bgImgVIiew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(KAdaptedHeight(-0));
            
        }];
    }
    return _bgImgVIiew;
}




- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:KGetImage(@"xiaoxi_back") forState:UIControlStateNormal];
        _backBtn.tag=100;
        [self addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(45), KAdaptedHeight(45)));
            make.top.mas_equalTo(kSafeArea_Top);
        }];
    }
    return _backBtn;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = getLanguage(@" 装扮中心");
        _titleLabel.textColor = RGBA(34, 34, 34, 1);
        _titleLabel.font=KFont(18);
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(self.backBtn.mas_height);
            make.centerY.mas_equalTo(self.backBtn.mas_centerY);
            make.width.mas_equalTo(kWidth/2);
        }];
    }
    return _titleLabel;
}

- (UIButton *)myBtn{
    if (!_myBtn) {
        _myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_myBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_myBtn setTitleColor:RGBA(0, 0, 0, 1) forState:UIControlStateNormal];
//        [_myBtn setTitle:getLanguage(@"我的") forState:UIControlStateNormal];
        [_myBtn setTitle:getLanguage(@"商城") forState:UIControlStateNormal];
        _myBtn.titleLabel.font=KFontA(14);
        _myBtn.tag=200;
        [self addSubview:_myBtn];
        [_myBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-8));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(45), KAdaptedHeight(45)));
            make.top.mas_equalTo(kSafeArea_Top);
        }];
    }
    return _myBtn;
}



- (UIView *)userBgView{
    if (!_userBgView) {
        _userBgView = [[UIView alloc] init];
        _userBgView.backgroundColor = kClearColor;
        _userBgView.layer.cornerRadius=KAdaptedHeight(10);
        _userBgView.layer.masksToBounds=YES;
        [self addSubview:_userBgView];
        [_userBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.bottom.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(150));
        }];
    }
    return _userBgView;
}



- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[UserManager userInfo].avatar]]placeholderImage:KGetImage(@"未加载头像")];
            _headImgView.layer.cornerRadius=KAdaptedHeight(35);
            _headImgView.layer.borderColor=RGBA(83, 191, 255, 1).CGColor;
            _headImgView.layer.borderWidth=KAdaptedWidth(1);
            _headImgView.layer.masksToBounds=YES;
        [self.userBgView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedHeight(70));
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(KAdaptedHeight(22));
            
        }];
    }
    return _headImgView;
}

- (UIImageView*)headBoxView{
    if (!_headBoxView) {
        _headBoxView = [[UIImageView alloc] init];
        if ([UserManager userInfo].is_zb) {
            [_headBoxView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[UserManager userInfo].avatar_frame_image]]];
        }
        _headBoxView.layer.cornerRadius=KAdaptedHeight(90)/2;
        _headBoxView.layer.masksToBounds=YES;
        [self.userBgView addSubview:_headBoxView];
        [_headBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedHeight(90));
            make.centerX.mas_equalTo(0);
//            make.top.mas_equalTo(KAdaptedHeight(20));
            make.centerY.mas_equalTo(self.headImgView.mas_centerY);
            
        }];
    }
    return _headBoxView;
}

- (SVGAImageView *)headZBImgView{
    if (!_headZBImgView) {
        _headZBImgView = [[SVGAImageView alloc] init];
        if ([UserManager userInfo].is_zb) {
            _headZBImgView.imageName=[NSString stringWithFormat:@"%@",[UserManager userInfo].avatar_frame_svga_file];
        }
        _headZBImgView.contentMode=UIViewContentModeScaleToFill;
        _headZBImgView.autoPlay=YES;
        [self.userBgView addSubview:_headZBImgView];
        [_headZBImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedHeight(90));
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(self.headImgView.mas_centerY);
            
            
        }];
    }
    return _headZBImgView;
}



- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = [Common isNull:[UserManager userInfo].nickname];
        _nameLabel.textColor = RGBA(34, 34, 34, 1);
        _nameLabel.font=KFont(15);
        _nameLabel.textAlignment=NSTextAlignmentCenter;
        [self.userBgView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(25));
            make.top.mas_equalTo(self.headImgView.mas_bottom).offset(KAdaptedHeight(5));
            make.width.mas_equalTo(kWidth/2);
        }];
    }
    return _nameLabel;
}
- (UILabel *)IDLabel{
    if (!_IDLabel) {
        _IDLabel = [[UILabel alloc] init];
        _IDLabel.text = [Common isNull:[UserManager userInfo].user_id];
        _IDLabel.textColor = RGBA(153, 153, 153, 1);
        _IDLabel.font=KFont(12);
        _IDLabel.textAlignment=NSTextAlignmentCenter;
        [self.userBgView addSubview:_IDLabel];
        [_IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(25));
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedHeight(3));
            make.width.mas_equalTo(kWidth/2);
        }];
    }
    return _IDLabel;
}


- (void)connectChange:(NSNotification *)aNotification {
    NSDictionary *dic = aNotification.object;
    NSString *str=[NSString stringWithFormat:@"%@",dic[@"svga_img"]];
    if(str.length>0){
        self.headZBImgView.hidden=NO;
        self.headBoxView.hidden=YES;
    }else{
        self.headZBImgView.hidden=YES;
        self.headBoxView.hidden=NO;
    }
    [self.headBoxView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"head_Box"]]]];
    
    self.headZBImgView.imageName=[NSString stringWithFormat:@"%@",dic[@"svga_img"]];
    
}

- (void)connectChangeID:(NSNotification *)aNotification {
    NSDictionary *dic = aNotification.object;
    NSString *str=[NSString stringWithFormat:@"%@",dic[@"head_Box"]];

    [self.IDColorLabel removeFromSuperview];
    if ([str integerValue]==2) {
        self.IDColorLabel= [WZBGradualLabel gradualLabelWithFrame:(CGRect){0, 0, kWidth/2, 25} title:[NSString stringWithFormat:@"ID:%@",dic[@"IDStr"]] duration:1.5 superview:self.IDLabel];
        self.IDColorLabel.gradualColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor cyanColor], [UIColor blueColor], [UIColor purpleColor]];
        self.IDColorLabel.font = KFontA(12);
        self.IDColorLabel.textAlignment = NSTextAlignmentCenter;
        self.IDColorLabel.textColor=RGBA(153, 153, 153, 1);
        self.IDLabel.textColor=RGBA(255, 255, 255, 0.1);

    }else{
        self.IDLabel.textColor=RGBA(153, 153, 153, 1);
        
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.IDLabel.text];
    if([str integerValue]==2){
        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
        attchment.bounds=CGRectMake(-30,0,15,15);//设置frame
        attchment.image=KGetImage(@"liangIconImg");//设置图片
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
    //    [attributedString appendAttributedString:string]; //添加到尾部
        [attributedString insertAttributedString:string atIndex:0]; //添加到前边
    }
   
    self.IDLabel.attributedText = attributedString;
    
    
}


@end
