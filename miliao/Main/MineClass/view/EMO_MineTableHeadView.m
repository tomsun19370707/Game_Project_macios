//
//  EMO_MineTableHeadView.m
//  miliao
//
//  Created by 张世浩 on 2022/10/12.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_MineTableHeadView.h"
#import "EMO_PersonalDataBaseVC.h"//个人主页
#import "EMO_FriendsContentVC.h"//好友,粉丝,关注
#import "EMO_OhterUserDynamicVC.h"//个人动态
#import "EMO_EditUserMsgViewController.h"//编辑个人资料
#import "ShareManager.h"
#import "WZBGradualLabel.h"
@interface EMO_MineTableHeadView()
Strong UIImageView *bgImgView;
Strong SVGAImageView *headSVGAImgView;
Strong UIImageView *headZBImgView;
Strong UIImageView *headImgView;
Strong UIButton *headImgBtn;
Strong UILabel *nameLabel;
Strong UIImageView *IDImgView;
Strong UIButton *IDLabel;
Strong WZBGradualLabel *IDColorLabel;
//Strong UIButton *editBtn;
Strong UIButton *rightImgBtn;
Strong UIButton *ageBtn;
Strong UIButton *constellationBtn;

Strong UILabel *friendsLabel;
Strong UILabel *followLabel;
Strong UILabel *fansLabel;

Strong UIView *functionView;
Strong UIView *functionTwoView;



@end


@implementation EMO_MineTableHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor= RGBA(248, 248, 248, 1);
    }
    return self;
}
- (UIColor*) gradientFromColor:(int)height
{
    CGSize size = CGSizeMake(1, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray* colors = [NSArray arrayWithObjects:(id)RandomColor.CGColor, (id)RandomColor.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

-(void)setUserInfoModel:(UserInfo *)userInfoModel{
    _userInfoModel=userInfoModel;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userInfoModel.avatar]] placeholderImage:KGetImage(@"未加载头像")];
  
    if (userInfoModel.is_zb) {
        if ([userInfoModel.avatar_frame_svga_file hasSuffix:@".svga"]||[userInfoModel.avatar_frame_svga_file hasSuffix:@".SVGA"]) {
//        if(userInfoModel.avatar_frame_svga_file.length>0){
            self.headSVGAImgView.imageName=userInfoModel.avatar_frame_svga_file;
        }else{
            [_headZBImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userInfoModel.avatar_frame_image]]];
        }
        self.headZBImgView.hidden=NO;
        self.headSVGAImgView.hidden=NO;
    }else{
        self.headZBImgView.hidden=YES;
        self.headSVGAImgView.hidden=YES;
    }
    self.nameLabel.text=[NSString stringWithFormat:@"%@",userInfoModel.nickname];
    [self.IDColorLabel removeFromSuperview];
    if (([userInfoModel.uuid integerValue]>0)&&([userInfoModel.uuid integerValue]!=[userInfoModel.user_id integerValue])) {
//        [self.IDLabel setTitle:[NSString stringWithFormat:@"ID:%@",userInfoModel.uuid] forState:UIControlStateNormal];

        self.IDColorLabel= [WZBGradualLabel gradualLabelWithFrame:(CGRect){0, 0, 100, 15} title:[NSString stringWithFormat:@"ID:%@",userInfoModel.uuid] duration:1.5 superview:self.IDLabel];
        self.IDColorLabel.gradualColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor cyanColor], [UIColor blueColor], [UIColor purpleColor]];
        self.IDColorLabel.font = KFontA(14);
        self.IDColorLabel.textAlignment = NSTextAlignmentLeft;
        self.IDColorLabel.textColor=RGBA(153, 153, 153, 1);
        [self.IDLabel setTitleColor:kClearColor forState:0];
        
//        [self.IDLabel setTitleColor:[UIColor gradientColorFromColor:kRedColor toColor:kYellowColor withHeight:5] forState:0];
        self.IDImgView.hidden=NO;
        [self.IDImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedWidth(15));
        }];
    }else{
        self.IDImgView.hidden=YES;
        [self.IDImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        [self.IDLabel setTitleColor:RGBA(153, 153, 153, 1) forState:0];
        [self.IDLabel setTitle:[NSString stringWithFormat:@"ID:%@",userInfoModel.user_id] forState:UIControlStateNormal];
    }
    [self.IDLabel setImagePositionWithType:SSImagePositionTypeRight spacing:5];
    
    if([userInfoModel.age integerValue]>0){
        self.ageBtn.hidden=NO;
        if ([userInfoModel.sex integerValue]==1) {
            self.ageBtn.backgroundColor=RGBA(0, 168, 255, 1);
//            self.ageBtn.layer.contents = (id) KGetImage(@"manBgImg").CGImage;
            [self.ageBtn setImage:KGetImage(@"manImg") forState:0];
        }else{
            self.ageBtn.backgroundColor=RGBA(255, 92, 100, 1);
//            self.ageBtn.layer.contents = (id) KGetImage(@"woManBgImg").CGImage;
            [self.ageBtn setImage:KGetImage(@"womanImg") forState:0];
        }
        [self.ageBtn setTitle:userInfoModel.age forState:0];
    }else{
        self.ageBtn.hidden=YES;
    }
    
   
    NSString *constellationStr=[Common isNull:userInfoModel.constellation];
    if(constellationStr.length>0){
        self.constellationBtn.hidden=NO;
        [self.constellationBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",constellationStr]] forState:UIControlStateNormal];
        [self.constellationBtn setTitle:constellationStr forState:UIControlStateNormal];
        if([userInfoModel.age integerValue]<1){
            [self.constellationBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(KAdaptedWidth(60));
                make.height.mas_equalTo(self.ageBtn.mas_height);
                make.top.mas_equalTo(self.IDLabel.mas_bottom).offset(KAdaptedHeight(10));
                make.leading.mas_equalTo(self.nameLabel.mas_leading);
            }];
            [self.constellationBtn layoutIfNeeded];
        }else{
            [self.constellationBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(KAdaptedWidth(60));
                make.height.mas_equalTo(self.ageBtn.mas_height);
                make.top.mas_equalTo(self.ageBtn.mas_top).offset(KAdaptedHeight(0));
                make.leading.mas_equalTo(self.ageBtn.mas_trailing).offset(KAdaptedWidth(15));
            }];
            [self.constellationBtn layoutIfNeeded];
        }
       

    }else{
        self.constellationBtn.hidden=YES;
    }
    
   
    
    
    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n%@",userInfoModel.dynamic_nums,getLanguage(@"动态")]];
    [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(15) range:NSMakeRange(0,2)];
    [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(2,AttributedStr1.length-2)];
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(34, 34, 34, 1) range:NSMakeRange(0,2)];
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(153, 153, 153, 1) range:NSMakeRange(2,AttributedStr1.length-2)];
    self.friendsLabel.attributedText = AttributedStr1;
    
    NSMutableAttributedString *AttributedStr12 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n%@",userInfoModel.attention_nums,getLanguage(@"关注")]];
    [AttributedStr12 addAttribute:NSFontAttributeName value:KFont(15) range:NSMakeRange(0,2)];
    [AttributedStr12 addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(2,AttributedStr12.length-2)];
    [AttributedStr12 addAttribute:NSForegroundColorAttributeName value:RGBA(34, 34, 34, 1) range:NSMakeRange(0,2)];
    [AttributedStr12 addAttribute:NSForegroundColorAttributeName value:RGBA(153, 153, 153, 1) range:NSMakeRange(2,AttributedStr12.length-2)];
    self.followLabel.attributedText = AttributedStr12;
    
    NSMutableAttributedString *AttributedStr13 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n%@",userInfoModel.fans_nums,getLanguage(@"粉丝")]];
    [AttributedStr13 addAttribute:NSFontAttributeName value:KFont(15) range:NSMakeRange(0,2)];
    [AttributedStr13 addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(2,AttributedStr13.length-2)];
    [AttributedStr13 addAttribute:NSForegroundColorAttributeName value:RGBA(34, 34, 34, 1) range:NSMakeRange(0,2)];
    [AttributedStr13 addAttribute:NSForegroundColorAttributeName value:RGBA(153, 153, 153, 1) range:NSMakeRange(2,AttributedStr13.length-2)];
    self.fansLabel.attributedText = AttributedStr13;
    
  
}


- (void)initView{
    
    [self bgImgView];
    
    [self headImgView];
    [self headZBImgView];
    [self headSVGAImgView];
    [self headImgBtn];
    [self nameLabel];
    [self IDImgView];
    [self IDLabel];
    [self IDColorLabel];
//    [self editBtn];
    [self rightImgBtn];
    [self ageBtn];
    [self constellationBtn];
    
    [self followLabel];
    [self friendsLabel];
    [self fansLabel];
    
    
    [self functionView];
    [self function];
    
    [self functionTwoView];
    [self functionTwo];
    
    self.IDImgView.hidden=YES;
    
}

- (UIImageView*)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image=KGetImage(@"mineHeadBgImg");
        [self addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(KAdaptedHeight(-50));
        }];
    }
    return _bgImgView;
}


-(UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView=[UIImageView new];
        _headImgView.image=KGetImage(@"未加载头像");
        _headImgView.layer.cornerRadius=KAdaptedHeight(40);
        _headImgView.layer.borderColor=RGBA(255, 255, 255, 1).CGColor;
        _headImgView.layer.borderWidth=KAdaptedWidth(1);
        _headImgView.layer.masksToBounds=YES;
        [self addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedHeight(80));
            make.height.mas_equalTo(KAdaptedHeight(80));
            make.leading.mas_equalTo(KAdaptedWidth(21));
            make.top.mas_equalTo(ZJTopNavH+KAdaptedHeight(15));
            
            
        }];
        
    }
    return _headImgView;
}

- (UIImageView*)headZBImgView{
    if (!_headZBImgView) {
        _headZBImgView = [[UIImageView alloc] init];
        _headZBImgView.layer.cornerRadius=KAdaptedHeight(100)/2;
        _headZBImgView.layer.masksToBounds=YES;
        [self addSubview:_headZBImgView];
        [_headZBImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedHeight(100));
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
            make.width.height.mas_equalTo(KAdaptedHeight(100));
            make.centerX.mas_equalTo(self.headImgView.mas_centerX);
            make.centerY.mas_equalTo(self.headImgView.mas_centerY);
            
        }];
    }
    return _headSVGAImgView;
}


- (UIButton *)headImgBtn{
    if (!_headImgBtn) {
        _headImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headImgBtn addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_headImgBtn];
        [_headImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.headImgView.mas_width);
            make.height.mas_equalTo(self.headImgView.mas_height);
            make.centerX.mas_equalTo(self.headImgView.mas_centerX);
            make.centerY.mas_equalTo(self.headImgView.mas_centerY);
            
        }];
    }
    return _headImgBtn;
}


- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"昵称";
        _nameLabel.textColor = RGBA(34, 34, 34, 1);
        _nameLabel.font=KFontBold(16);
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgView.mas_top);
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(14.5));
            make.trailing.mas_equalTo(KAdaptedWidth(-100));
            make.height.mas_equalTo(KAdaptedHeight(20));
        }];
    }
    return _nameLabel;
}


- (UIImageView*)IDImgView{
    if (!_IDImgView) {
        _IDImgView = [[UIImageView alloc] init];
        _IDImgView.image=KGetImage(@"liangIconImg");
        [self addSubview:_IDImgView];
        [_IDImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedHeight(15));
            make.height.mas_equalTo(KAdaptedHeight(15));
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedHeight(9.5));
            make.leading.mas_equalTo(self.nameLabel.mas_leading);
        }];
    }
    return _IDImgView;
}


- (UIButton *)IDLabel{
    if (!_IDLabel) {
        _IDLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_IDLabel setTitle:getLanguage(@"ID:00000") forState:UIControlStateNormal];
        [_IDLabel setTitleColor:RGBA(153, 153, 153, 1) forState:0];
        _IDLabel.titleLabel.font=KFontA(12);
        [_IDLabel setImage:[UIImage imageNamed:@"copyIconImg"] forState:UIControlStateNormal];
        [_IDLabel addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _IDLabel.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        _IDLabel.tag=100;
        [self addSubview:_IDLabel];
        [_IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedHeight(9.5));
//            make.leading.mas_equalTo(self.nameLabel.mas_leading);
            make.leading.mas_equalTo(self.IDImgView.mas_trailing).offset(KAdaptedWidth(5));
            make.width.mas_equalTo(KAdaptedWidth(100));
            make.height.mas_equalTo(KAdaptedHeight(15));
            
        }];
        [_IDLabel setImagePositionWithType:SSImagePositionTypeRight spacing:5];
    }
    return _IDLabel;
}


//- (WZBGradualLabel *)IDColorLabel{
//    if (!_IDColorLabel) {
//        _IDColorLabel= [WZBGradualLabel gradualLabelWithFrame:(CGRect){0, 0, 100, 15} title:@"" superview:self.IDLabel];
//    }
//    return _IDColorLabel;
//}



//- (UILabel *)IDLabel{
//    if (!_IDLabel) {
//        _IDLabel = [[UILabel alloc] init];
//        _IDLabel.text = @"ID: 0";
//        _IDLabel.textColor = RGBA(153, 153, 153, 1);
//        _IDLabel.font=KFont(12);
//        [self addSubview:_IDLabel];
//        [_IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedHeight(9.5));
//            make.leading.mas_equalTo(self.nameLabel.mas_leading);
//            make.width.mas_equalTo(KAdaptedWidth(85));
//            make.height.mas_equalTo(KAdaptedHeight(15));
//        }];
//    }
//    return _IDLabel;
//}


//- (UIButton *)editBtn{
//    if (!_editBtn) {
//        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_editBtn setImage:[UIImage imageNamed:@"copyIconImg"] forState:UIControlStateNormal];
//        [_editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_editBtn];
//        [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.IDLabel.mas_top);
//            make.leading.mas_equalTo(self.IDLabel.mas_trailing).offset(KAdaptedWidth(10));
//            make.width.height.mas_equalTo(KAdaptedHeight(15));
//        }];
//    }
//    return _editBtn;
//}



- (UIButton *)rightImgBtn{
    if (!_rightImgBtn) {
        _rightImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightImgBtn setImage:[UIImage imageNamed:@"mineRightImg"] forState:UIControlStateNormal];
        [_rightImgBtn addTarget:self action:@selector(RightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _rightImgBtn.tag=3000;
        [self addSubview:_rightImgBtn];
        [_rightImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(45), KAdaptedHeight(20)));
            make.centerY.mas_equalTo(self.IDLabel.mas_centerY);
            make.trailing.mas_equalTo(KAdaptedWidth(-11));
            
        }];
    }
    return _rightImgBtn;
}




- (UIButton *)ageBtn{
    if (!_ageBtn) {
        _ageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _ageBtn.backgroundColor=RGBA(255, 92, 100, 1);
//        _ageBtn.layer.contents = (id) KGetImage(@"manBgImg").CGImage;    // 如果需要背景透明加上下面这句
//        _ageBtn.layer.backgroundColor = [UIColor clearColor].CGColor;
        [_ageBtn setImage:[UIImage imageNamed:@"manImg"] forState:UIControlStateNormal];
        [_ageBtn setTitle:@" 22" forState:UIControlStateNormal];
        [_ageBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _ageBtn.titleLabel.font=KFont(11);
        [self addSubview:_ageBtn];
        [_ageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(40), KAdaptedHeight(15)));
            make.top.mas_equalTo(self.IDLabel.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.mas_equalTo(self.nameLabel.mas_leading);
            
        }];
        setViewCorner(_ageBtn, KAdaptedHeight(15)/2);
    }
    return _ageBtn;
}


- (UIButton *)constellationBtn{
    if (!_constellationBtn) {
        _constellationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _constellationBtn.layer.contents = (id) KGetImage(@"constellationImg").CGImage;    // 如果需要背景透明加上下面这句
        _constellationBtn.layer.backgroundColor = [UIColor clearColor].CGColor;
        [_constellationBtn setImage:[UIImage imageNamed:@"xingzuoImg"] forState:UIControlStateNormal];
        [_constellationBtn setTitle:@"金牛" forState:UIControlStateNormal];
        [_constellationBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _constellationBtn.titleLabel.font=KFont(10);
        [self addSubview:_constellationBtn];
        [_constellationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedWidth(60));
            make.height.mas_equalTo(self.ageBtn.mas_height);
            make.top.mas_equalTo(self.ageBtn.mas_top).offset(KAdaptedHeight(0));
            make.leading.mas_equalTo(self.ageBtn.mas_trailing).offset(KAdaptedWidth(15));
            
        }];
        [_constellationBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:3];
    }
    return _constellationBtn;
}



- (UILabel *)friendsLabel{
    if (!_friendsLabel) {
        _friendsLabel = [[UILabel alloc] init];
        _friendsLabel.numberOfLines=0;
        _friendsLabel.textAlignment=NSTextAlignmentCenter;
        NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"0\n%@",getLanguage(@"动态")]];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(16) range:NSMakeRange(0,2)];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(2,AttributedStr1.length-2)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(34, 34, 34, 1) range:NSMakeRange(0,2)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(153, 153, 153, 1) range:NSMakeRange(2,AttributedStr1.length-2)];
        _friendsLabel.attributedText = AttributedStr1;
        _friendsLabel.userInteractionEnabled=YES;
        _friendsLabel.tag=100;
        [_friendsLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
        [self addSubview:_friendsLabel];
        [_friendsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.followLabel.mas_width);
            make.height.mas_equalTo(self.followLabel.mas_height);
            make.top.mas_equalTo(self.followLabel.mas_top);
//            make.leading.mas_equalTo(self.followLabel.mas_trailing);
            
            make.leading.mas_equalTo(KAdaptedWidth(20));
        }];
    }
    return _friendsLabel;
}

- (UILabel *)followLabel{
    if (!_followLabel) {
        _followLabel = [[UILabel alloc] init];
        _followLabel.numberOfLines=0;
        _followLabel.textAlignment=NSTextAlignmentCenter;
        NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"0\n%@",getLanguage(@"关注")]];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(16) range:NSMakeRange(0,2)];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(2,AttributedStr1.length-2)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(34, 34, 34, 1) range:NSMakeRange(0,2)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(153, 153, 153, 1) range:NSMakeRange(2,AttributedStr1.length-2)];
        _followLabel.attributedText = AttributedStr1;
        _followLabel.userInteractionEnabled=YES;
        _followLabel.tag=200;
        [_followLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
        [self addSubview:_followLabel];
        [_followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((kWidth-KAdaptedWidth(28))/4, KAdaptedHeight(50)));
            make.centerX.mas_equalTo(KAdaptedWidth(0));
            make.top.mas_equalTo(self.headImgView.mas_bottom).offset(KAdaptedHeight(13));
           
            
        }];
    }
    return _followLabel;
}

- (UILabel *)fansLabel{
    if (!_fansLabel) {
        _fansLabel = [[UILabel alloc] init];
        _fansLabel.numberOfLines=0;
        _fansLabel.textAlignment=NSTextAlignmentCenter;
        NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"0\n%@",getLanguage(@"粉丝")]];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(16) range:NSMakeRange(0,2)];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(2,AttributedStr1.length-2)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1) range:NSMakeRange(0,2)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(102, 102, 102, 1) range:NSMakeRange(2,AttributedStr1.length-2)];
        _fansLabel.attributedText = AttributedStr1;
        _fansLabel.userInteractionEnabled=YES;
        _fansLabel.tag=300;
        [_fansLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
        [self addSubview:_fansLabel];
        [_fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.followLabel.mas_width);
            make.height.mas_equalTo(self.followLabel.mas_height);
            make.top.mas_equalTo(self.followLabel.mas_top);
            make.trailing.mas_equalTo(KAdaptedWidth(-20));
        }];
    }
    return _fansLabel;
}


- (UIView *)functionView{
    if (!_functionView) {
        _functionView = [[UIView alloc] init];
        _functionView.backgroundColor = [UIColor whiteColor];
        _functionView.layer.cornerRadius=KAdaptedHeight(10);
        _functionView.layer.masksToBounds=YES;
        [self addSubview:_functionView];
        [_functionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(KAdaptedHeight(-15));
            make.top.mas_equalTo(self.friendsLabel.mas_bottom).offset(KAdaptedHeight(15));
            make.leading.mas_equalTo(KAdaptedWidth(14));
            make.trailing.mas_equalTo(KAdaptedWidth(-14));
            make.height.mas_equalTo(KAdaptedHeight(100));
        }];
    }
    return _functionView;
}




-(void)function{
    NSArray *titleArray= @[getLanguage(@" 我的钱包"),
                        getLanguage(@" 爵位"),
                        getLanguage(@" 装扮中心"),
                        getLanguage(@" 我的家族")];
    NSArray *imageArray = @[KGetImage(@"walletImg"),
                        KGetImage(@"nobilityImg"),
                        KGetImage(@"skinImg"),
                        KGetImage(@"familyImg")];
    //每个Item宽高
    CGFloat W = (kWidth-KAdaptedWidth(28))/4;
    CGFloat H = KAdaptedHeight(100);
    //每行列数
    NSInteger rank = 4;
    //每列间距
    CGFloat rankMargin =0;
    //每行间距
    CGFloat rowMargin = 0;
    //Item索引 ->根据需求改变索引
    NSUInteger index = imageArray.count;
    
    for (int i = 0 ; i< index; i++) {
        //Item X轴
        CGFloat X = (i % rank) * (W + rankMargin);
        //Item Y轴
        NSUInteger Y = (i / rank) * (H +rowMargin);
        //Item top
        CGFloat top = 0;
        UIView *bgView=[[UIView alloc] init];
        [self.functionView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(Y+top);
            make.leading.mas_equalTo(X);
            make.size.mas_equalTo(CGSizeMake(W, H));
        }];
        UIImageView *imageView=[UIImageView new];
        imageView.image=imageArray[i];
        [bgView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo((W-KAdaptedWidth(25))/2);
            make.top.mas_equalTo(KAdaptedHeight(15));
            make.width.height.mas_equalTo(KAdaptedWidth(38));
        }];
        
        UILabel *nameLabel=[[UILabel alloc] init];
        nameLabel.text=titleArray[i];
        nameLabel.textColor=RGBA(102, 102, 102, 1);
        nameLabel.font=KFont(12);
        nameLabel.numberOfLines=0;
        nameLabel.textAlignment=NSTextAlignmentCenter;
        [bgView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(48));
            make.leading.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(W, H-KAdaptedHeight(58)));
            
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1000+i;
        [button addTarget:self action:@selector(otherButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
            
        }];
    }
}

- (UIView *)functionTwoView{
    if (!_functionTwoView) {
        _functionTwoView = [[UIView alloc] init];
        _functionTwoView.backgroundColor = [UIColor whiteColor];
        _functionTwoView.layer.cornerRadius=KAdaptedHeight(10);
        _functionTwoView.layer.masksToBounds=YES;
        [self addSubview:_functionTwoView];
        [_functionTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(KAdaptedHeight(-15));
            make.leading.mas_equalTo(KAdaptedWidth(14));
            make.trailing.mas_equalTo(KAdaptedWidth(-14));
            make.height.mas_equalTo(KAdaptedHeight(200));
        }];
    }
    return _functionTwoView;
}




-(void)functionTwo{
    NSArray *titleArray= @[getLanguage(@" 邀请好友"),
                        getLanguage(@" 任务中心"),
                        getLanguage(@" 我的礼物"),
                        getLanguage(@" 我的收藏"),
                           getLanguage(@" 我的等级"),
                           getLanguage(@" 家族中心"),
                           getLanguage(@" 我的房间"),
                           getLanguage(@" 我的技能")];
    NSArray *imageArray = @[KGetImage(@"inviteImg"),
                        KGetImage(@"taskImg"),
                        KGetImage(@"recommendImg"),
                        KGetImage(@"collectImg"),
                            KGetImage(@"gradeImg"),
                            KGetImage(@"rankingImg"),
                            KGetImage(@"roomImg"),
                            KGetImage(@"gameIconImg")];
    //每个Item宽高
    CGFloat W = (kWidth-KAdaptedWidth(28))/4;
    CGFloat H = KAdaptedHeight(100);
    //每行列数
    NSInteger rank = 4;
    //每列间距
    CGFloat rankMargin =0;
    //每行间距
    CGFloat rowMargin = 0;
    //Item索引 ->根据需求改变索引
    NSUInteger index = imageArray.count;
    
    for (int i = 0 ; i< index; i++) {
        //Item X轴
        CGFloat X = (i % rank) * (W + rankMargin);
        //Item Y轴
        NSUInteger Y = (i / rank) * (H +rowMargin);
        //Item top
        CGFloat top = 0;
        UIView *bgView=[[UIView alloc] init];
        [self.functionTwoView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(Y+top);
            make.leading.mas_equalTo(X);
            make.size.mas_equalTo(CGSizeMake(W, H));
        }];
        UIImageView *imageView=[UIImageView new];
        imageView.image=imageArray[i];
        [bgView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo((W-KAdaptedWidth(25))/2);
            make.top.mas_equalTo(KAdaptedHeight(15));
            make.width.height.mas_equalTo(KAdaptedWidth(33));
        }];
        
        UILabel *nameLabel=[[UILabel alloc] init];
        nameLabel.text=titleArray[i];
        nameLabel.textColor=RGBA(102, 102, 102, 1);
        nameLabel.font=KFont(13);
        nameLabel.numberOfLines=0;
        nameLabel.textAlignment=NSTextAlignmentCenter;
        [bgView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(48));
            make.leading.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(W, H-KAdaptedHeight(58)));
            
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 2000+i;
        [button addTarget:self action:@selector(otherButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
            
        }];
    }
}

-(void)headBtnClick{
    
    EMO_PersonalDataBaseVC *vc=[EMO_PersonalDataBaseVC new];
    vc.userID=[UserManager userInfo].user_id;
    [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
}


-(void)editBtnClick{
    
    [[ShareManager manager] shareCopyPaste:[Common isNull:self.userInfoModel.user_id]];
    
}

-(void)RightBtnClick{
    EMO_EditUserMsgViewController *VC=[EMO_EditUserMsgViewController new];
    [[Common getCurrentVC].navigationController pushViewController:VC animated:YES];
    
}

-(void)tap:(UITapGestureRecognizer *)tap{
    
    if (tap.view.tag==100) {
        
        EMO_OhterUserDynamicVC *vc=[EMO_OhterUserDynamicVC new];
        vc.userID=[UserManager userInfo].user_id;
        vc.type=2;
        [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
        return;
    }
    
    EMO_FriendsContentVC *vc=[EMO_FriendsContentVC new];
    vc.index=tap.view.tag;
    [[Common getCurrentVC].navigationController pushViewController:vc animated:YES];
}


- (void)otherButtonClick:(UIButton*)sender{
    sender.enabled = NO;
      //处理逻辑
    if (self.BtnClick) {
        self.BtnClick(sender.tag);
    }
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           sender.enabled = YES;
      });


}



@end
