//
//  EMO_ZuanRecordTableCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/5.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_ZuanRecordTableCell.h"

@interface EMO_ZuanRecordTableCell()
Strong UIView   *bgView;
Strong UILabel *contentLabel;
Strong UILabel *timeLabel;
Strong UIView   *lineView;

@end

@implementation EMO_ZuanRecordTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self bgView];
        [self timeLabel];
        [self contentLabel];
        [self lineView];
        
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    self.timeLabel.text=[Common isNull:dicData[@"createtime"]];
    NSString *str1=[Common isNull:dicData[@"memo"]];
    NSString *str2=[Common isNull:dicData[@"money"]];
    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",str1,str2]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(51, 1, 51, 1) range:NSMakeRange(0,str1.length)];
        [attributedString addAttribute:NSFontAttributeName value:KFontBold(13) range:NSMakeRange(0,str1.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(255, 111, 0, 1) range:NSMakeRange(str1.length,str2.length+1)];
    [attributedString addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(str1.length,str2.length+1)];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(255, 111, 0, 1) range:NSMakeRange(12,8)];
//    [attributedString addAttribute:NSFontAttributeName value:KFontBold(13) range:NSMakeRange(12,8)];
    _contentLabel.attributedText=attributedString;
    
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
            
        }];
    }
    return _bgView;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"2023-07-05 00:00";
        _timeLabel.textColor = RGBA(153, 153, 153, 1);
        _timeLabel.font=KFontA(12);
        _timeLabel.textAlignment=NSTextAlignmentRight;
        [self.bgView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.width.mas_equalTo(KAdaptedWidth(130));
        }];
    }
    return _timeLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = RGBA(51, 51, 51, 1);
        _contentLabel.font=KFontA(13);
        NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"礼物收益 棒棒糖*888  8888金币"]];
            [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(51, 1, 51, 1) range:NSMakeRange(0,4)];
            [attributedString addAttribute:NSFontAttributeName value:KFontBold(13) range:NSMakeRange(0,4)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(255, 111, 0, 1) range:NSMakeRange(4,8)];
        [attributedString addAttribute:NSFontAttributeName value:KFont(12) range:NSMakeRange(4,8)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:RGBA(255, 111, 0, 1) range:NSMakeRange(12,8)];
        [attributedString addAttribute:NSFontAttributeName value:KFontBold(13) range:NSMakeRange(12,8)];
        _contentLabel.attributedText=attributedString;
        [self.bgView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(self.timeLabel.mas_leading).offset(KAdaptedWidth(-5));
            
        }];
    }
    return _contentLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBA(248, 248, 248, 1);
        [self.bgView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(1);
            
        }];
    }
    return _lineView;
}


@end
