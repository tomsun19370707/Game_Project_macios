//
//  EMO_InviteFriendsView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/30.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_InviteFriendsView.h"

@interface EMO_InviteFriendsView()

Strong UIView *topView;
Strong UIImageView *bgImgView;
Strong UIImageView *codeImgView;
Strong UIButton *copybtn;
Strong UIView *centetView;
Strong UILabel *inviteNumLabel;
Strong UILabel *moneyLabel;
Strong UILabel *tiXianLabel;
Strong UIButton *WithdrawalBtn;
Strong UIView *bottomView;
Strong UIImageView *titleImgView;
Strong UILabel *titleLabel;


Strong UIView *footTopView;
Strong UIView *footBottomView;
Strong UILabel *tipLabel;
Strong UILabel *contentLabel;

@end

@implementation EMO_InviteFriendsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor= RGBA(107, 71, 255, 1);
        [self topView];
        [self bgImgView];
        [self codeImgView];
        [self copybtn];
        [self centetView];
        [self moneyLabel];
        [self inviteNumLabel];
        [self tiXianLabel];
        [self WithdrawalBtn];
        [self bottomView];
        [self titleImgView];
        [self titleLabel];
        
        
        [self footTopView];
        [self footBottomView];
        [self tipLabel];
        [self contentLabel];
        
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    
}

-(void)setType:(NSInteger)type{
    _type=type;
    if(type==1){
        self.footTopView.hidden=YES;
        self.footBottomView.hidden=YES;
        self.tipLabel.hidden=YES;
        self.contentLabel.hidden=YES;


    }else{
        self.topView.hidden=YES;
        self.bgImgView.hidden=YES;
        self.codeImgView.hidden=YES;
        self.copybtn.hidden=YES;
        self.centetView.hidden=YES;
        self.moneyLabel.hidden=YES;
        self.inviteNumLabel.hidden=YES;
        self.tiXianLabel.hidden=YES;
        self.WithdrawalBtn.hidden=YES;
        self.bottomView.hidden=YES;
        self.titleImgView.hidden=YES;
        self.titleLabel.hidden=YES;

    }
    
    
}



-(void)BtnClick:(UIButton *)sender{
    if(sender.tag==100){
        [[ShareManager manager] shareCopyPaste:[Common isNull:[UserManager userInfo].invite_url]];
    }else{
        [SVProgressHUD showImage:KGetImage(@"") status:@"提现"];
    }
    
}






- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = RGBA(107, 71, 255, 1);
        [self addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            make.bottom.mas_equalTo(KAdaptedHeight(0));
            
        }];
    }
    return _topView;
}

- (UIImageView*)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image=KGetImage(@"iinviteBgImg");
        [self.topView addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(KAdaptedHeight(-200));
            
        }];
    }
    return _bgImgView;
}
- (UIImageView*)codeImgView{
    if (!_codeImgView) {
        _codeImgView = [[UIImageView alloc] init];
        [_codeImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[UserManager userInfo].invite_qrcode]]placeholderImage:KGetImage(@"未加载图片")];
        [self.topView addSubview:_codeImgView];
        [_codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(200));
            make.centerX.mas_equalTo(0);
            make.width.height.mas_equalTo(KAdaptedHeight(180));
            
        }];
        setViewCorner(_codeImgView, KAdaptedHeight(10));
    }
    return _codeImgView;
}


- (UIButton *)copybtn{
    if (!_copybtn) {
        _copybtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_copybtn setTitle:getLanguage(@"复制链接") forState:UIControlStateNormal];
        [_copybtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        [_copybtn setImage:[UIImage imageNamed:@"iinviteCopyImg"] forState:UIControlStateNormal];
        _copybtn.titleLabel.font=KFont(13);
        [_copybtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _copybtn.tag=100;
        [self.topView addSubview:_copybtn];
        [_copybtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.codeImgView.mas_bottom).offset(KAdaptedHeight(10));
            make.centerX.mas_equalTo(KAdaptedWidth(0));
            make.width.mas_equalTo(KAdaptedWidth(100));
            make.height.mas_equalTo(KAdaptedHeight(20));
        }];
        [_copybtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];
    }
    return _copybtn;
}


- (UIView *)centetView{
    if (!_centetView) {
        _centetView = [[UIView alloc] init];
        _centetView.backgroundColor = RGBA(255, 255, 255, 1);
        [self.topView addSubview:_centetView];
        [_centetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.copybtn.mas_bottom).offset(KAdaptedHeight(15));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(80));
            
        }];
        setViewCorner(_centetView, KAdaptedHeight(10));
    }
    return _centetView;
}

- (UILabel *)inviteNumLabel{
    if (!_inviteNumLabel) {
        _inviteNumLabel = [[UILabel alloc] init];
        _inviteNumLabel.numberOfLines=0;
        _inviteNumLabel.textAlignment=NSTextAlignmentCenter;
        NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@位\n%@",[UserManager userInfo].invite_nums,getLanguage(@"邀请好友")]];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(16) range:NSMakeRange(0,1)];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(1,1)];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(2,AttributedStr1.length-2)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(34, 34, 34, 1) range:NSMakeRange(0,2)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(153, 153, 153, 1) range:NSMakeRange(2,AttributedStr1.length-2)];
        _inviteNumLabel.attributedText = AttributedStr1;
        [self.centetView addSubview:_inviteNumLabel];
        [_inviteNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.moneyLabel.mas_width);
            make.height.mas_equalTo(self.moneyLabel.mas_height);
            make.top.mas_equalTo(self.moneyLabel.mas_top);
            make.leading.mas_equalTo(KAdaptedWidth(20));
        }];
    }
    return _inviteNumLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.numberOfLines=0;
        _moneyLabel.textAlignment=NSTextAlignmentCenter;
        NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",[UserManager userInfo].invite_nums,getLanguage(@"邀请奖励")]];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(16) range:NSMakeRange(0,2)];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(2,AttributedStr1.length-2)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(34, 34, 34, 1) range:NSMakeRange(0,2)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(153, 153, 153, 1) range:NSMakeRange(2,AttributedStr1.length-2)];
        _moneyLabel.attributedText = AttributedStr1;
        [self.centetView addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((kWidth-KAdaptedWidth(30))/4, KAdaptedHeight(60)));
            make.centerX.mas_equalTo(KAdaptedWidth(0));
            make.top.mas_equalTo(KAdaptedHeight(10));
           
            
        }];
    }
    return _moneyLabel;
}

- (UILabel *)tiXianLabel{
    if (!_tiXianLabel) {
        _tiXianLabel = [[UILabel alloc] init];
        _tiXianLabel.numberOfLines=0;
        _tiXianLabel.textAlignment=NSTextAlignmentCenter;
        NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",[UserManager userInfo].withdrawal__price,getLanguage(@"已提现")]];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(16) range:NSMakeRange(0,2)];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(2,AttributedStr1.length-2)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1) range:NSMakeRange(0,2)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(102, 102, 102, 1) range:NSMakeRange(2,AttributedStr1.length-2)];
        _tiXianLabel.attributedText = AttributedStr1;
        [self.centetView addSubview:_tiXianLabel];
        [_tiXianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.moneyLabel.mas_width);
            make.height.mas_equalTo(self.moneyLabel.mas_height);
            make.top.mas_equalTo(self.moneyLabel.mas_top);
            make.trailing.mas_equalTo(KAdaptedWidth(-20));
        }];
    }
    return _tiXianLabel;
}

- (UIButton *)WithdrawalBtn{
    if (!_WithdrawalBtn) {
        _WithdrawalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _WithdrawalBtn.backgroundColor=BaseMainColor;
        [_WithdrawalBtn setTitle:getLanguage(@"立即提现") forState:UIControlStateNormal];
        [_WithdrawalBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _WithdrawalBtn.titleLabel.font=KFont(16);
        _WithdrawalBtn.layer.borderColor=kWhiteColor.CGColor;
        _WithdrawalBtn.layer.borderWidth=1;
        [_WithdrawalBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _WithdrawalBtn.tag=200;
        [self.topView addSubview:_WithdrawalBtn];
        [_WithdrawalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.centetView.mas_bottom).offset(KAdaptedHeight(15));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(50));
        }];
        setViewCorner(_WithdrawalBtn, KAdaptedHeight(25));
    }
    return _WithdrawalBtn;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.topView addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(10);
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(20));
            
        }];
        setViewCorner(_bottomView, KAdaptedHeight(10));
    }
    return _bottomView;
}

- (UIImageView*)titleImgView{
    if (!_titleImgView) {
        _titleImgView = [[UIImageView alloc] init];
        _titleImgView.image=KGetImage(@"iinviteTitleImg");
        [self.topView addSubview:_titleImgView];
        [_titleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(KAdaptedHeight(0));
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(KAdaptedHeight(35));
            make.width.mas_equalTo(KAdaptedWidth(245));
            
        }];
    }
    return _titleImgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = getLanguage(@"邀请记录");
        _titleLabel.textColor = RGBA(255, 255, 255, 1);
        _titleLabel.font=KFontA(16);
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        [self.topView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.titleImgView.mas_bottom);
            make.centerX.mas_equalTo(self.titleImgView.mas_centerX);
            make.width.mas_equalTo(self.titleImgView.mas_width);
            make.height.mas_equalTo(self.titleImgView.mas_height);

        }];
    }
    return _titleLabel;
}









- (UIView *)footTopView{
    if (!_footTopView) {
        _footTopView = [[UIView alloc] init];
        _footTopView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_footTopView];
        [_footTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-10);
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(20));
            
        }];
        setViewCorner(_footTopView, KAdaptedHeight(10));
    }
    return _footTopView;
}




- (UIView *)footBottomView{
    if (!_footBottomView) {
        _footBottomView = [[UIView alloc] init];
        _footBottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_footBottomView];
        [_footBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.footTopView.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(230));
            
        }];
        setViewCorner(_footBottomView, KAdaptedHeight(10));
    }
    return _footBottomView;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = getLanguage(@"邀请规则");
        _tipLabel.textColor = RGBA(0, 0, 0, 1);
        _tipLabel.font=KFontA(14);
        _tipLabel.textAlignment=NSTextAlignmentCenter;
        [self.footBottomView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(15));
            make.centerX.mas_equalTo(KAdaptedWidth(18));
            make.width.mas_equalTo(KAdaptedWidth(120));
            make.height.mas_equalTo(KAdaptedHeight(30));
        }];
    }
    return _tipLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = getLanguage(@"1.消费2.做新手任务3.阿巴阿巴阿巴4.这里说的任务包括主线任务、修真任务、传奇任务等，这是最直接的升级渠道。每个不同的任务给的经验值不同，一般来说任务耗时不会太长，具体奖励的可以在“任务”界面中选定某一任务后查看。5.每个不同的任务给的经验值不同，一般来说任务耗时不会太长.");
        _contentLabel.textColor = RGBA(102, 102, 102, 1);
        _contentLabel.font=KFontA(12);
        _contentLabel.numberOfLines=0;
        _contentLabel.textAlignment=NSTextAlignmentCenter;
        [self.footBottomView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(KAdaptedHeight(15));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.bottom.mas_equalTo(KAdaptedHeight(-30));
        }];
    }
    return _contentLabel;
}




@end
