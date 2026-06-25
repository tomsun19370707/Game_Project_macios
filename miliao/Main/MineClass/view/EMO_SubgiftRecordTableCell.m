//
//  EMO_SubgiftRecordTableCell.m
//  miliao
//
//  Created by 张世浩 on 2022/10/17.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_SubgiftRecordTableCell.h"


@interface EMO_SubgiftRecordTableCell()
Strong UIImageView *headImgView;
Strong UILabel *titleLabel1;
Strong UILabel *IDLabel;
Strong UILabel *timeLabel;
Strong UILabel *moneyLabel;
Strong UIView *lineView;

@end

@implementation EMO_SubgiftRecordTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self headImgView];
        [self titleLabel1];
        [self IDLabel];
        [self timeLabel];
        [self moneyLabel];
        [self lineView];
        
    }
    
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"to_user_avatar"]]] placeholderImage:KGetImage(@"未加载头像")];
    self.titleLabel1.text = [NSString stringWithFormat:@"%@  ",dicData[@"to_user_nickname"]];
    self.IDLabel.text = [NSString stringWithFormat:@"%@  ",dicData[@"uuid"]];
//    self.timeLabel.text=[NSString stringWithFormat:@"%@",[Common time:[dicData[@"createtime"] stringValue] andShowHoursMinutes:YES]];
    self.timeLabel.text=[NSString stringWithFormat:@"%@",dicData[@"createtime"]];
    self.moneyLabel.text=[NSString stringWithFormat:@"%@  ",dicData[@"money"]];
    

    
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
        _titleLabel1.text = getLanguage(@"");
        _titleLabel1.textColor = RGBA(34, 34, 34, 1);
        _titleLabel1.font=KFont(14);
        [self.contentView addSubview:_titleLabel1];
        [_titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(18.5));
            make.height.mas_equalTo(KAdaptedHeight(20));
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(12));
//            make.width.mas_equalTo(KAdaptedWidth(230));
            make.trailing.mas_equalTo(KAdaptedWidth(-120));
            
        }];
    }
    return _titleLabel1;
}


- (UILabel *)IDLabel{
    if (!_IDLabel) {
        _IDLabel = [[UILabel alloc] init];
        _IDLabel.text = getLanguage(@"ID:");
        _IDLabel.textColor = RGBA(153, 153, 153, 1);
        _IDLabel.font=KFont(12);
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

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = getLanguage(@"2022-05-05 16:32:32");
        _timeLabel.textColor = RGBA(153, 153, 153, 1);
        _timeLabel.font=KFont(12);
        _timeLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.IDLabel.mas_top).offset(KAdaptedHeight(0));
            make.bottom.mas_equalTo(self.IDLabel.mas_bottom);
            make.leading.mas_equalTo(self.IDLabel.mas_trailing).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            
        }];
    }
    return _timeLabel;
}


- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = getLanguage(@"0.00");
        _moneyLabel.textColor = RGBA(51, 51, 51, 1);
        _moneyLabel.font=KFont(15);
        _moneyLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel1.mas_top);
            make.height.mas_equalTo(self.titleLabel1.mas_height);
            make.leading.mas_equalTo(self.titleLabel1.mas_trailing);
            make.trailing.mas_equalTo(-KAdaptedWidth(15));
            
        }];
    }
    return _moneyLabel;
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






@end
