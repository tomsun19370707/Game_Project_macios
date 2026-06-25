//
//  EMO_RechargeRecordCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/27.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_RechargeRecordCell.h"

@interface EMO_RechargeRecordCell()

Strong UIView *bgView;
Strong UILabel *titleLabel;
Strong UILabel *timeLabel;
Strong UILabel *moneyLabel;
Strong UILabel *reasonLabel;
Strong UILabel *statusLabel;
@end

@implementation EMO_RechargeRecordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor=kClearColor;
        [self bgView];
        [self titleLabel];
        [self reasonLabel];
        [self timeLabel];
//        [self statusLabel];
        [self moneyLabel];
        
        
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    self.timeLabel.text=[Common isNull:dicData[@"createtime"]];
    if([dicData[@"type"] integerValue]==1){
        self.titleLabel.text=[Common isNull:dicData[@"memo"]];
        self.moneyLabel.text=[NSString stringWithFormat:@"%@金币",dicData[@"money"]];
    }else{
//        self.titleLabel.text=[NSString stringWithFormat:@"提现至%@(%@)",dicData[@"type_text"],dicData[@"status_text"]];
        self.titleLabel.text=[NSString stringWithFormat:@"提现至%@",dicData[@"type_text"]];
//        self.statusLabel.text=[NSString stringWithFormat:@"%@",dicData[@"status_text"]];
        self.moneyLabel.text=[NSString stringWithFormat:@"¥%@",dicData[@"money"]];
        if([dicData[@"status"] integerValue]==2){
//            self.reasonLabel.text=[NSString stringWithFormat:@"驳回原因:%@",dicData[@"reasons"]];
            [self.reasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(KAdaptedHeight(5));
            }];
        }else{
//            self.reasonLabel.text=@"";
            [self.reasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(KAdaptedHeight(5));
            }];
        }
        [self.reasonLabel layoutIfNeeded];
    }
    
    
    
}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.bottom.mas_equalTo(KAdaptedHeight(0));
        }];
        setViewCorner(_bgView, KAdaptedHeight(10));
    }
    return _bgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = getLanguage(@"充值金币");
        _titleLabel.textColor = RGBA(51, 51, 51, 1);
        _titleLabel.font=KFont(14);
        [self.bgView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-150));
//            make.bottom.mas_equalTo(self.bgView.mas_centerY);
            make.height.mas_equalTo(KAdaptedHeight(30));
            
        }];
    }
    return _titleLabel;
}

- (UILabel *)reasonLabel{
    if (!_reasonLabel) {
        _reasonLabel = [[UILabel alloc] init];
//        _reasonLabel.text = @"驳回原因";
        _reasonLabel.textColor = RGBA(153, 153, 153, 1);
        _reasonLabel.font=KFont(13);
        [self.bgView addSubview:_reasonLabel];
        [_reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(self.titleLabel.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(self.titleLabel.mas_trailing);
            make.height.mas_equalTo(KAdaptedHeight(5));
            
        }];
    }
    return _reasonLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"02月06日  16:34";
        _timeLabel.textColor = RGBA(153, 153, 153, 1);
        _timeLabel.font=KFont(13);
        [self.bgView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
            make.leading.mas_equalTo(self.titleLabel.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(self.titleLabel.mas_trailing);
//         make.bottom.mas_equalTo(KAdaptedHeight(0));
            make.bottom.mas_equalTo(self.reasonLabel.mas_top).offset(0);
            
        }];
    }
    return _timeLabel;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.text = @"申请中";
        _statusLabel.textColor = RGBA(51, 51, 51, 1);
        _statusLabel.font=KFont(13);
        _statusLabel.textAlignment=NSTextAlignmentLeft;
        [self.bgView addSubview:_statusLabel];
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
            make.leading.mas_equalTo(self.titleLabel.mas_trailing).offset(KAdaptedWidth(0));
            make.width.mas_equalTo(KAdaptedWidth(60));
            make.height.mas_equalTo(KAdaptedHeight(30));
            
        }];
    }
    return _statusLabel;
}


- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"0元";
        _moneyLabel.textColor = RGBA(51, 51, 51, 1);
        _moneyLabel.font=KFont(14);
        _moneyLabel.textAlignment=NSTextAlignmentRight;
        [self.bgView addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
            make.leading.mas_equalTo(self.titleLabel.mas_trailing).offset(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(30));
            
        }];
    }
    return _moneyLabel;
}


@end
