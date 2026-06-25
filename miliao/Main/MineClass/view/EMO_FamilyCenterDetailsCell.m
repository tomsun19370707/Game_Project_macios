//
//  EMO_FamilyCenterDetailsCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/4.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_FamilyCenterDetailsCell.h"

@interface EMO_FamilyCenterDetailsCell ()
Strong UIView *bgView;
Strong UIImageView *headOneImgView;
Strong UIImageView *headTwoImgView;
Strong UILabel *nameLabel;
Strong UILabel *contentLabel;
Strong UILabel *timeLabel;
Strong UILabel *moneyLabel;
Strong UIView *lineView;


@end

@implementation EMO_FamilyCenterDetailsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){

        [self bgView];
        [self headOneImgView];
        [self headTwoImgView];
        [self timeLabel];
        [self nameLabel];
        [self moneyLabel];
        [self contentLabel];
        [self lineView];
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    [self.headTwoImgView sd_setImageWithURL:[NSURL URLWithString:[Common isNull:dicData[@"avatar"]]] placeholderImage:KGetImage(@"未加载头像")];
    
    [self.headOneImgView sd_setImageWithURL:[NSURL URLWithString:[Common isNull:dicData[@"to_avatar"]]] placeholderImage:KGetImage(@"未加载头像")];
    
    self.nameLabel.text=[NSString stringWithFormat:@"%@",dicData[@"nickname"]];
    self.timeLabel.text=[NSString stringWithFormat:@"%@",dicData[@"createtime_text"]];
    NSString *giftStr=[NSString stringWithFormat:@"%@*%@",dicData[@"gift_name"],dicData[@"gift_num"]];
    self.contentLabel.text=[NSString stringWithFormat:@"打赏 %@ %@",dicData[@"to_nickname"],giftStr];
    self.moneyLabel.text=[NSString stringWithFormat:@"%ld",[dicData[@"gift_price"] integerValue]];
    
    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.contentLabel.text]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1) range:NSMakeRange(0,self.contentLabel.text.length-giftStr.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(255, 111, 0, 1) range:NSMakeRange(self.contentLabel.text.length-giftStr.length,giftStr.length)];
    [attributedString addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(0,self.contentLabel.text.length)];
    self.contentLabel.attributedText=attributedString;
}

-(void)setFamilyDicData:(NSDictionary *)familyDicData{
    _familyDicData=familyDicData;
    [self.headTwoImgView sd_setImageWithURL:[NSURL URLWithString:[Common isNull:familyDicData[@"from_user_avatar"]]] placeholderImage:KGetImage(@"未加载头像")];
    
    [self.headOneImgView sd_setImageWithURL:[NSURL URLWithString:[Common isNull:familyDicData[@"to_user_avatar"]]] placeholderImage:KGetImage(@"未加载头像")];
    self.nameLabel.text=[NSString stringWithFormat:@"%@",familyDicData[@"from_user_nickname"]];
    self.timeLabel.text=[NSString stringWithFormat:@"%@",familyDicData[@"createtime_text"]];
    self.moneyLabel.text=[NSString stringWithFormat:@"%ld",[familyDicData[@"family_price"] integerValue]];
    NSString *giftStr=[NSString stringWithFormat:@"%@*%@",familyDicData[@"gift_name"],familyDicData[@"gift_num"]];
    self.contentLabel.text=[NSString stringWithFormat:@"打赏 %@ %@",familyDicData[@"to_user_nickname"],giftStr];
    
    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.contentLabel.text]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1) range:NSMakeRange(0,self.contentLabel.text.length-giftStr.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(255, 111, 0, 1) range:NSMakeRange(self.contentLabel.text.length-giftStr.length,giftStr.length)];
    [attributedString addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(0,self.contentLabel.text.length)];
    self.contentLabel.attributedText=attributedString;
    
    
}



- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            make.bottom.mas_equalTo(KAdaptedHeight(0));
            
        }];
    }
    return _bgView;
}

- (UIImageView*)headOneImgView{
    if (!_headOneImgView) {
        _headOneImgView = [[UIImageView alloc] init];
        _headOneImgView.image=KGetImage(@"未加载头像");
        [self.bgView addSubview:_headOneImgView];
        [_headOneImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedWidth(55));
            make.leading.mas_equalTo(KAdaptedWidth(43));
            make.centerY.mas_equalTo(KAdaptedHeight(0));
        }];
        setViewCorner(_headOneImgView, KAdaptedWidth(55)/2);
    }
    return _headOneImgView;
}
- (UIImageView*)headTwoImgView{
    if (!_headTwoImgView) {
        _headTwoImgView = [[UIImageView alloc] init];
        _headTwoImgView.image=KGetImage(@"未加载头像");
        _headTwoImgView.layer.borderColor=kWhiteColor.CGColor;
        _headTwoImgView.layer.borderWidth=1;
        [self.bgView addSubview:_headTwoImgView];
        [_headTwoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedWidth(55));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.centerY.mas_equalTo(KAdaptedHeight(0));
        }];
        setViewCorner(_headTwoImgView, KAdaptedWidth(55)/2);
    }
    return _headTwoImgView;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"2023-05-27 13:00";
        _timeLabel.textColor = RGBA(153, 153, 153, 1);
        _timeLabel.font=KFont(12);
        _timeLabel.textAlignment=NSTextAlignmentRight;
        [self.bgView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headOneImgView.mas_top);
            make.width.mas_equalTo(KAdaptedWidth(120));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.bottom.mas_equalTo(self.headOneImgView.mas_centerY);
            
        }];
    }
    return _timeLabel;
}


- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"昵称";
        _nameLabel.textColor = RGBA(0, 0, 0, 1);
        _nameLabel.font=KFont(15);
        _nameLabel.textAlignment=NSTextAlignmentLeft;
        [self.bgView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.mas_equalTo(self.headOneImgView.mas_top);
            make.leading.mas_equalTo(self.headOneImgView.mas_trailing).offset(KAdaptedWidth(10));
            make.trailing.mas_equalTo(self.timeLabel.mas_leading).offset(KAdaptedWidth(-10));
            make.bottom.mas_equalTo(self.headOneImgView.mas_centerY);
            
        }];
    }
    return _nameLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"0金币";
        _moneyLabel.textColor = RGBA(255, 111, 0, 1);
        _moneyLabel.font=KFontBold(13);
        _moneyLabel.textAlignment=NSTextAlignmentRight;
        [self.bgView addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headOneImgView.mas_centerY);
            make.width.mas_equalTo(KAdaptedWidth(80));
            make.trailing.mas_equalTo(self.timeLabel.mas_trailing);
            make.bottom.mas_equalTo(self.headOneImgView.mas_bottom);
            
        }];
    }
    return _moneyLabel;
}


- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"打赏 似月是你 棒棒糖*30";
        _contentLabel.textColor = RGBA(51, 51, 51, 1);
        _contentLabel.font=KFont(13);
        _contentLabel.textAlignment=NSTextAlignmentLeft;
        [self.bgView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.mas_equalTo(self.headOneImgView.mas_centerY);
            make.leading.mas_equalTo(self.nameLabel.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(self.moneyLabel.mas_leading).offset(KAdaptedWidth(-10));
            make.bottom.mas_equalTo(self.headOneImgView.mas_bottom);
            
        }];
    }
    return _contentLabel;
}



- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBA(248, 248, 248, 1);
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            make.bottom.mas_equalTo(KAdaptedHeight(0));
            
        }];
    }
    return _lineView;
}






@end
