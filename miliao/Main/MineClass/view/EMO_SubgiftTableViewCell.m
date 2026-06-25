//
//  EMO_SubgiftTableViewCell.m
//  miliao
//
//  Created by 张世浩 on 2022/10/17.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_SubgiftTableViewCell.h"

@interface EMO_SubgiftTableViewCell()

Strong UIImageView *headImgView;
Strong UILabel *nameLabel;
Strong UILabel *IDLabel;
Strong UIButton *relieveBtn;
Strong UIView *lineView;




@end


@implementation EMO_SubgiftTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self headImgView];
        [self nameLabel];
        [self IDLabel];
        [self relieveBtn];
//        [self lineView];
        
    }
    
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"avatar"]]] placeholderImage:KGetImage(@"未加载头像")];
    self.nameLabel.text=[NSString stringWithFormat:@"%@",dicData[@"nickname"]];
    if([dicData[@"uuid"] integerValue]>1){
        self.IDLabel.text=[NSString stringWithFormat:@"ID:%@",dicData[@"uuid"]];
    }else{
        self.IDLabel.text=[NSString stringWithFormat:@"ID:%@",dicData[@"id"]];
    }
    
}



- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"未加载头像");
        _headImgView.layer.cornerRadius=KAdaptedWidth(53/2);
        _headImgView.layer.masksToBounds=YES;
        [self.contentView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(53), KAdaptedWidth(53)));
            make.leading.mas_equalTo(KAdaptedHeight(15.5));
            
        }];
    }
    return _headImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = getLanguage(@"昵称");
        _nameLabel.textColor = RGBA(34, 34, 34, 1);
        _nameLabel.font=KFont(14);
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_nameLabel.text];
//        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
//        attchment.bounds=CGRectMake(5,-2,15,15);//设置frame
//            attchment.image=[UIImage imageNamed:@"manImg1"];//设置图片
//        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
//        [attributedString appendAttributedString:string]; //添加到尾部
//        _nameLabel.attributedText = attributedString;
//
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgView.mas_top);
            make.bottom.mas_equalTo(self.headImgView.mas_centerY).offset(KAdaptedWidth(0));
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(9.5));
            make.trailing.mas_equalTo(KAdaptedWidth(-100));
            
        }];
    }
    return _nameLabel;
}

- (UILabel *)IDLabel{
    if (!_IDLabel) {
        _IDLabel = [[UILabel alloc] init];
        _IDLabel.text = getLanguage(@"ID:");
        _IDLabel.textColor = RGBA(153, 153, 153, 1);
        _IDLabel.font=KFont(12);
        [self.contentView addSubview:_IDLabel];
        [_IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom);
            make.bottom.mas_equalTo(self.headImgView.mas_bottom).offset(KAdaptedWidth(0));
            make.leading.mas_equalTo(self.nameLabel.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(self.nameLabel.mas_trailing);
            
        }];
    }
    return _IDLabel;
}



- (UIButton *)relieveBtn{
    if (!_relieveBtn) {
        _relieveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,KAdaptedWidth(68),KAdaptedHeight(28));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)RGBA(247, 212, 91, 0.59).CGColor, (__bridge id)RGBA(255, 238, 1, 1).CGColor];
        gl.locations = @[@(0), @(1.0f)];
        _relieveBtn.layer.cornerRadius = 50;
        _relieveBtn.layer.shadowColor = RGBA(155, 155, 155, 0.16).CGColor;
        _relieveBtn.layer.shadowOffset = CGSizeMake(0,0);
        _relieveBtn.layer.shadowOpacity = 1;
        _relieveBtn.layer.shadowRadius = 2;
        [_relieveBtn.layer addSublayer:gl];
        _relieveBtn.layer.cornerRadius = KAdaptedHeight(28)/2;
        _relieveBtn.layer.masksToBounds=YES;
        [_relieveBtn setTitle:getLanguage(@"转赠") forState:UIControlStateNormal];
        [_relieveBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _relieveBtn.titleLabel.font=KFont(13);
        [_relieveBtn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_relieveBtn];
        [_relieveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-14.5));
            make.centerY.mas_equalTo(self.headImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(68), KAdaptedHeight(28)));
            
        }];
    }
    return _relieveBtn;
}


- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBA(238, 238, 238, 1);
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(KAdaptedHeight(0));
            make.height.mas_equalTo(KAdaptedHeight(0.5));
            make.leading.mas_equalTo(KAdaptedWidth(14));
            make.trailing.mas_equalTo(KAdaptedWidth(-14));
    
        }];
    
    }
    return _lineView;
}



-(void)BtnClick{
    if (self.BtnBlock) {
        self.BtnBlock(self.dicData);
    }
    
    
    
    
    
    
}


@end
