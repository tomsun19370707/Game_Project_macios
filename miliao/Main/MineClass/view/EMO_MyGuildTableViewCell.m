//
//  EMO_MyGuildTableViewCell.m
//  miliao
//
//  Created by 张世浩 on 2022/10/18.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_MyGuildTableViewCell.h"


@interface EMO_MyGuildTableViewCell()
Strong UIImageView *headImgView;
Strong UILabel *titleLabel1;
Strong UIImageView *iconImgView;
Strong UILabel *IDLabel;
Strong UIButton *funtionBtn;
//Strong UIView *lineView;

@end

@implementation EMO_MyGuildTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self headImgView];
        [self titleLabel1];
        [self iconImgView];
        [self IDLabel];
        [self funtionBtn];
//        [self lineView];
        
    }
    
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"image"]]] placeholderImage:KGetImage(@"未加载头像")];
    self.IDLabel.text=[NSString stringWithFormat:@"ID:%@",dicData[@"id"]];
    [self.funtionBtn setTitle:[Common isNull:dicData[@"num"]] forState:UIControlStateNormal];
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"family_level_image"]]] placeholderImage:KGetImage(@"familyGradeImg1")];
   
    
    self.titleLabel1.text = [NSString stringWithFormat:@"%@  ",dicData[@"name"]];
    CGSize textWidth = [self.titleLabel1.text sizeWithFont:KFont(15) maxSize:CGSizeMake(kWidth-KAdaptedWidth(100), CGFLOAT_MAX)];
    
    [self.titleLabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(textWidth.width+5);

    }];
    [self.titleLabel1 layoutIfNeeded];

    
    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel1.text];
//    NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
//    attchment.bounds=CGRectMake(5,-2,67,20);//设置frame
//    attchment.image=[UIImage imageNamed:dicData[@"iconImg"]];//设置图片
//    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
//    [attributedString appendAttributedString:string]; //添加到尾部
//    self.titleLabel1.attributedText = attributedString;
    
 

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


- (UILabel *)titleLabel1{
    if (!_titleLabel1) {
        _titleLabel1 = [[UILabel alloc] init];
        _titleLabel1.text = getLanguage(@"昵称");
        _titleLabel1.textColor = RGBA(0, 0, 0, 1);
        _titleLabel1.font=KFont(15);
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_titleLabel1.text];
//        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
//        attchment.bounds=CGRectMake(5,-2,67,20);//设置frame
//            attchment.image=[UIImage imageNamed:@"familyGradeImg1"];//设置图片
//        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
//        [attributedString appendAttributedString:string]; //添加到尾部
//        _titleLabel1.attributedText = attributedString;

        [self.contentView addSubview:_titleLabel1];
        [_titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(18.5));
            make.height.mas_equalTo(KAdaptedHeight(20));
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(12));
            make.width.mas_equalTo(KAdaptedWidth(50));
//            make.trailing.mas_equalTo(KAdaptedWidth(-120));
            
        }];
    }
    return _titleLabel1;
}

- (UIImageView*)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image=KGetImage(@"familyGradeImg1");
        [self.contentView addSubview:_iconImgView];
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.titleLabel1.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(65), KAdaptedWidth(20)));
            make.leading.mas_equalTo(self.titleLabel1.mas_trailing).offset(KAdaptedWidth(5));
            
        }];
    }
    return _iconImgView;
}



- (UILabel *)IDLabel{
    if (!_IDLabel) {
        _IDLabel = [[UILabel alloc] init];
        _IDLabel.text = getLanguage(@"ID：0");
        _IDLabel.textColor = RGBA(153, 153, 153, 1);
        _IDLabel.font=KFont(13);
        [self.contentView addSubview:_IDLabel];
        [_IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel1.mas_bottom).offset(KAdaptedHeight(10));
            make.bottom.mas_equalTo(KAdaptedHeight(-15));
            make.leading.mas_equalTo(self.titleLabel1.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(self.contentView.mas_centerX);
            
            
        }];
    }
    return _IDLabel;
}



- (UIButton *)funtionBtn{
    if (!_funtionBtn) {
        _funtionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_funtionBtn setTitle:getLanguage(@"0") forState:UIControlStateNormal];
        [_funtionBtn setImage:KGetImage(@"familyNumImg") forState:UIControlStateNormal];
        [_funtionBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _funtionBtn.titleLabel.font=KFont(12);
        _funtionBtn.layer.cornerRadius=KAdaptedHeight(25/2);
        _funtionBtn.layer.masksToBounds=YES;
        _funtionBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [self.contentView addSubview:_funtionBtn];
        [_funtionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
                make.height.mas_equalTo(KAdaptedHeight(25));
                make.width.mas_equalTo(KAdaptedWidth(120));
                make.trailing.mas_equalTo(KAdaptedWidth(-15));
            //
        }];
        [_funtionBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:3];
    }
    return _funtionBtn;
}




//- (UIView *)lineView{
//    if (!_lineView) {
//        _lineView = [[UIView alloc] init];
//        _lineView.backgroundColor = RGBA(238, 238, 238, 1);
//        [self.contentView addSubview:_lineView];
//        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(KAdaptedHeight(0));
//            make.height.mas_equalTo(KAdaptedHeight(0.5));
//            make.leading.mas_equalTo(KAdaptedWidth(14));
//            make.trailing.mas_equalTo(KAdaptedWidth(-14));
//
//        }];
//
//    }
//    return _lineView;
//}



-(void)BtnClick{
    
}


@end
