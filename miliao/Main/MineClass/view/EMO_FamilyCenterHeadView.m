//
//  EMO_FamilyCenterHeadView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/4.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_FamilyCenterHeadView.h"

@interface  EMO_FamilyCenterHeadView()
Strong UIImageView *bgImgVIiew;

Strong UIImageView *headImgView;
//Strong UILabel *titleLabel1;
Strong UIButton *nameBtn;
Strong UIImageView *iconView;
Strong UILabel *IDLabel;
Strong UIButton *funtionBtn;

Strong UIView *bgBottomVIiew;
Strong UILabel *tipLabel;
Strong UIButton *detailBtn;

Strong UIView *cententView;
Strong UILabel *dayLabel;
Strong UIView *lineOneView;
Strong UILabel *weekLabel;
Strong UIView *lineTwoView;
Strong UILabel *monthLabel;

@end

@implementation EMO_FamilyCenterHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor= kWhiteColor;
        self.layer.masksToBounds=YES;
        [self bgImgVIiew];
        [self headImgView];
        [self iconView];
        [self nameBtn];
//        [self titleLabel1];
        [self IDLabel];
        [self funtionBtn];
        [self bgBottomVIiew];
        [self tipLabel];
        [self detailBtn];
        [self cententView];
        [self weekLabel];
        [self dayLabel];
        [self lineOneView];
        [self lineTwoView];
        [self monthLabel];
        
        
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"image"]]] placeholderImage:KGetImage(@"未加载头像")];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"family_level_image"]]] placeholderImage:KGetImage(@"familyGradeImg1")];
    self.IDLabel.text=[NSString stringWithFormat:@"ID:%@",dicData[@"id"]];
    [self.nameBtn setTitle:[NSString stringWithFormat:@"%@  ",dicData[@"name"]] forState:UIControlStateNormal];
  
    CGSize textWidth = [self.nameBtn.titleLabel.text sizeWithFont:KFontA(18) maxSize:CGSizeMake(kWidth-KAdaptedWidth(100), CGFLOAT_MAX)];
    [self.nameBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(textWidth.width+KAdaptedWidth(30));
        
    }];
    [self.nameBtn layoutIfNeeded];
    [self.nameBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];
    
    
//    self.titleLabel1.text = [NSString stringWithFormat:@"%@  ",dicData[@"nickname"]];
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel1.text];
//    NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
//    attchment.bounds=CGRectMake(5,-2,67,20);//设置frame
//    attchment.image=[UIImage imageNamed:dicData[@"iconImg"]];//设置图片
//    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
//    [attributedString appendAttributedString:string]; //添加到尾部
//    self.titleLabel1.attributedText = attributedString;
    
    [_funtionBtn setTitle:[Common isNull:dicData[@"num"]] forState:UIControlStateNormal];
    
    

}

- (UIImageView*)bgImgVIiew{
    if (!_bgImgVIiew) {
        _bgImgVIiew = [[UIImageView alloc] init];
        _bgImgVIiew.image=KGetImage(@"familyXQBgImg");
        [self addSubview:_bgImgVIiew];
        [_bgImgVIiew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(KAdaptedHeight(250));
        }];
    }
    return _bgImgVIiew;
}

- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"未加载头像");
        _headImgView.layer.borderColor=kWhiteColor.CGColor;
        _headImgView.layer.borderWidth=1;
        _headImgView.layer.cornerRadius=KAdaptedWidth(70)/2;
        _headImgView.layer.masksToBounds=YES;
        [self addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(70), KAdaptedWidth(70)));
            make.leading.mas_equalTo(KAdaptedWidth(15));
//            make.bottom.mas_equalTo(KAdaptedHeight(-60));
            make.top.mas_equalTo(KAdaptedHeight(100));
        }];
    }
    return _headImgView;
}


- (UIButton *)nameBtn{
    if (!_nameBtn) {
        _nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nameBtn setTitle:getLanguage(@"昵称") forState:UIControlStateNormal];
        [_nameBtn setTitleColor:RGBA(0, 0, 0, 1) forState:UIControlStateNormal];
        _nameBtn.titleLabel.font=KFontA(18);
        [_nameBtn setImage:[UIImage imageNamed:@"editImg"] forState:UIControlStateNormal];
        [_nameBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _nameBtn.tag=100;
        _nameBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [self addSubview:_nameBtn];
        [_nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.iconView.mas_top);
                make.height.mas_equalTo(KAdaptedHeight(25));
                make.leading.mas_equalTo(self.iconView.mas_leading).offset(KAdaptedWidth(0));
                make.width.mas_equalTo(KAdaptedWidth(120));
        }];
        [_nameBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];
    }
    return _nameBtn;
}


//- (UILabel *)titleLabel1{
//    if (!_titleLabel1) {
//        _titleLabel1 = [[UILabel alloc] init];
//        _titleLabel1.text = getLanguage(@"昵称");
//        _titleLabel1.textColor = RGBA(0, 0, 0, 1);
//        _titleLabel1.font=KFont(15);
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_titleLabel1.text];
//        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
//        attchment.bounds=CGRectMake(5,-2,20,20);//设置frame
//            attchment.image=[UIImage imageNamed:@"familyGradeImg1"];//设置图片
//        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
//        [attributedString appendAttributedString:string]; //添加到尾部
//        _titleLabel1.attributedText = attributedString;
//        [self addSubview:_titleLabel1];
//        [_titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self.iconView.mas_top);
//            make.height.mas_equalTo(KAdaptedHeight(25));
//            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(15));
//            make.trailing.mas_equalTo(KAdaptedWidth(-120));
//
//        }];
//    }
//    return _titleLabel1;
//}


- (UIImageView*)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.image=KGetImage(@"familyGradeImg1");
        [self addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(60), KAdaptedWidth(15)));
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(15));
            make.centerY.mas_equalTo(self.headImgView.mas_centerY);
        }];
    }
    return _iconView;
}


- (UILabel *)IDLabel{
    if (!_IDLabel) {
        _IDLabel = [[UILabel alloc] init];
        _IDLabel.text = getLanguage(@"ID：0");
        _IDLabel.textColor = RGBA(153, 153, 153, 1);
        _IDLabel.font=KFont(13);
        [self addSubview:_IDLabel];
        [_IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconView.mas_bottom).offset(KAdaptedHeight(0));
            make.height.mas_equalTo(KAdaptedHeight(20));
            make.leading.mas_equalTo(self.nameBtn.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(self.mas_centerX);
            
            
        }];
    }
    return _IDLabel;
}



- (UIButton *)funtionBtn{
    if (!_funtionBtn) {
        _funtionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _funtionBtn.backgroundColor=RGBA(228, 240, 255, 1);
        [_funtionBtn setTitle:getLanguage(@"0") forState:UIControlStateNormal];
        [_funtionBtn setImage:KGetImage(@"familyNumImg") forState:UIControlStateNormal];
        [_funtionBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _funtionBtn.titleLabel.font=KFont(12);
        _funtionBtn.layer.cornerRadius=KAdaptedHeight(25/2);
        _funtionBtn.layer.masksToBounds=YES;
        _funtionBtn.tag=300;
        [_funtionBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _funtionBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [self addSubview:_funtionBtn];
        [_funtionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.IDLabel.mas_centerY);
                make.height.mas_equalTo(KAdaptedHeight(25));
                make.width.mas_equalTo(KAdaptedWidth(65));
                make.trailing.mas_equalTo(KAdaptedWidth(-15));

        }];
        [_funtionBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:3];
    }
    return _funtionBtn;
}


- (UIView *)bgBottomVIiew{
    if (!_bgBottomVIiew) {
        _bgBottomVIiew = [[UIView alloc] init];
        _bgBottomVIiew.backgroundColor = [UIColor whiteColor];
        _bgBottomVIiew.layer.masksToBounds=YES;
        _bgBottomVIiew.layer.cornerRadius=KAdaptedHeight(10);
        [self addSubview:_bgBottomVIiew];
        [_bgBottomVIiew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(-0));
            make.height.mas_equalTo(KAdaptedHeight(170));
            make.width.mas_equalTo(kWidth);
            make.bottom.mas_equalTo(KAdaptedHeight(20));
        
        }];
    }
    return _bgBottomVIiew;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = getLanguage(@"家族收益");
        _tipLabel.textColor = RGBA(0, 0,0, 1);
        _tipLabel.font=KFont(16);
        [self.bgBottomVIiew addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(20));
            make.height.mas_equalTo(KAdaptedHeight(30));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(self.mas_centerX);
            
            
        }];
    }
    return _tipLabel;
}


- (UIButton *)detailBtn{
    if (!_detailBtn) {
        _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detailBtn setTitle:getLanguage(@"收益明细") forState:UIControlStateNormal];
        [_detailBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        _detailBtn.titleLabel.font=KFont(14);
        _detailBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [_detailBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _detailBtn.tag=200;
        [self.bgBottomVIiew addSubview:_detailBtn];
        [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.tipLabel.mas_centerY);
                make.height.mas_equalTo(KAdaptedHeight(30));
                make.width.mas_equalTo(KAdaptedWidth(65));
                make.trailing.mas_equalTo(KAdaptedWidth(-15));

        }];
    }
    return _detailBtn;
}

- (UIView *)cententView{
    if (!_cententView) {
        _cententView = [[UIView alloc] init];
        _cententView.backgroundColor = RGBA(255, 255, 249, 1);
        _cententView.layer.masksToBounds=YES;
        _cententView.layer.cornerRadius=KAdaptedHeight(10);
        _cententView.layer.borderColor=RGBA(255, 251, 190, 1).CGColor;
        _cententView.layer.borderWidth=1;
        [self.bgBottomVIiew addSubview:_cententView];
        [_cententView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(KAdaptedHeight(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.bottom.mas_equalTo(KAdaptedHeight(-30));
        
        }];
    }
    return _cententView;
}


- (UILabel *)dayLabel{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.numberOfLines=0;
        _dayLabel.textAlignment=NSTextAlignmentCenter;
        NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"0\n%@",getLanguage(@"今日收益")]];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(18) range:NSMakeRange(0,2)];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(2,AttributedStr1.length-2)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(0, 0, 0, 1) range:NSMakeRange(0,2)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(102, 102, 102, 1) range:NSMakeRange(2,AttributedStr1.length-2)];
        _dayLabel.attributedText = AttributedStr1;
        _dayLabel.userInteractionEnabled=YES;
        _dayLabel.tag=100;
        [_dayLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
        [self.cententView addSubview:_dayLabel];
        [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.weekLabel.mas_width);
            make.height.mas_equalTo(self.weekLabel.mas_height);
            make.top.mas_equalTo(self.weekLabel.mas_top);
            make.leading.mas_equalTo(KAdaptedWidth(0));
        }];
    }
    return _dayLabel;
}

- (UIView *)lineOneView{
    if (!_lineOneView) {
        _lineOneView = [[UIView alloc] init];
        _lineOneView.backgroundColor =RGBA(241, 241, 241, 1);
        [self.cententView addSubview:_lineOneView];
        [_lineOneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.weekLabel.mas_leading);
            make.top.mas_equalTo(KAdaptedHeight(16));
            make.width.mas_equalTo(1);
            make.bottom.mas_equalTo(KAdaptedHeight(-16));
        
        }];
    }
    return _lineOneView;
}


- (UILabel *)weekLabel{
    if (!_weekLabel) {
        _weekLabel = [[UILabel alloc] init];
        _weekLabel.numberOfLines=0;
        _weekLabel.textAlignment=NSTextAlignmentCenter;
        NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"0\n%@",getLanguage(@"本周收益")]];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(18) range:NSMakeRange(0,2)];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(2,AttributedStr1.length-2)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(0, 0, 0, 1) range:NSMakeRange(0,2)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(102, 102, 102, 1) range:NSMakeRange(2,AttributedStr1.length-2)];
        _weekLabel.attributedText = AttributedStr1;
        _weekLabel.userInteractionEnabled=YES;
        _weekLabel.tag=200;
        [_weekLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
        [self.cententView addSubview:_weekLabel];
        [_weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((kWidth-KAdaptedWidth(30))/3, KAdaptedHeight(80)));
            make.centerX.mas_equalTo(KAdaptedWidth(0));
            make.top.mas_equalTo(KAdaptedHeight(0));
           
            
        }];
    }
    return _weekLabel;
}

- (UIView *)lineTwoView{
    if (!_lineTwoView) {
        _lineTwoView = [[UIView alloc] init];
        _lineTwoView.backgroundColor =RGBA(241, 241, 241, 1);
        [self.cententView addSubview:_lineTwoView];
        [_lineTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.weekLabel.mas_trailing);
            make.top.mas_equalTo(self.lineOneView.mas_top);
            make.bottom.mas_equalTo(self.lineOneView.mas_bottom);
            make.width.mas_equalTo(self.lineOneView.mas_width);
        
        }];
    }
    return _lineTwoView;
}



- (UILabel *)monthLabel{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.numberOfLines=0;
        _monthLabel.textAlignment=NSTextAlignmentCenter;
        NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"0\n%@",getLanguage(@"本月收益")]];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(18) range:NSMakeRange(0,2)];
        [AttributedStr1 addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(2,AttributedStr1.length-2)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(0, 0, 0, 1) range:NSMakeRange(0,2)];
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName value:RGBA(102, 102, 102, 1) range:NSMakeRange(2,AttributedStr1.length-2)];
        _monthLabel.attributedText = AttributedStr1;
        _monthLabel.userInteractionEnabled=YES;
        _monthLabel.tag=300;
        [_monthLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
        [self.cententView addSubview:_monthLabel];
        [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.weekLabel.mas_width);
            make.height.mas_equalTo(self.weekLabel.mas_height);
            make.top.mas_equalTo(self.weekLabel.mas_top);
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
        }];
    }
    return _monthLabel;
}










-(void)BtnClick:(UIButton *)sender{
   if([self.dicData[@"is_patriarch"] integerValue]==1){
       if(self.SenderBlock){
           self.SenderBlock(sender.tag);
       }
    }

}


-(void)tap:(UITapGestureRecognizer *)tapView{
    
    
}


@end
