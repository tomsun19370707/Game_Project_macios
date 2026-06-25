//
//  EMO_RankingListTableCell.m
//  miliao
//
//  Created by 张世浩 on 2022/10/26.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_RankingListTableCell.h"


@interface EMO_RankingListTableCell()
Strong UIView *bgBottomView;
Strong UILabel *numLabel;
Strong UIImageView *numImgView;
Strong UIImageView *headImgView;
Strong UILabel *nameLabel;
Strong UILabel *moneyLabel;

@end



@implementation EMO_RankingListTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor=kClearColor;
        [self bgBottomView];
        [self numLabel];
        [self numImgView];
        [self headImgView];
        [self nameLabel];
        [self moneyLabel];
        
    }
    
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;

    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"avatar"]]] placeholderImage:KGetImage(@"未加载头像")];
    self.nameLabel.text=[NSString stringWithFormat:@"%@",dicData[@"nickname"]];
    NSString *mizuanStr3=[NSString stringWithFormat:@"%@",dicData[@"total_gift_contribute"]];
    if (self.titleSelectTag==1) {
        mizuanStr3=[NSString stringWithFormat:@"%@",dicData[@"total_gift_charm"]];
    }
    self.moneyLabel.text=[self getDealNumwithstring:mizuanStr3.length>0?mizuanStr3:@"" withNumCount:mizuanStr3.length];
    
}

- (NSString *)getDealNumwithstring:(NSString *)string withNumCount:(NSInteger)integer{
    if (string.length==0||[string isEqualToString:@"0"]) {
        return @"0";
    }
    if (string.length<5) {
        return string;
    }
    NSNumber *number = @([string floatValue]);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###0"];
    formatter.roundingMode = NSNumberFormatterRoundDown;
    formatter.maximumFractionDigits = 1;
    NSLog(@"%@", [formatter stringFromNumber:number]);
    return [NSString stringWithFormat:@"%@",[formatter stringFromNumber:number]];
}


-(void)setRowindex:(NSInteger)rowindex{
    
    if(rowindex<4){
        self.numImgView.image=[UIImage imageNamed:[NSString stringWithFormat:@"rankImg%ld",rowindex]];
        self.numLabel.hidden=YES;
        self.numImgView.hidden=NO;
    }else{
        self.numLabel.hidden=NO;
        self.numImgView.hidden=YES;
        self.numLabel.text=[NSString stringWithFormat:@"%ld",rowindex];
    }
    
}


- (UIView *)bgBottomView{
    if (!_bgBottomView) {
        _bgBottomView = [[UIView alloc] init];
//        _bgBottomView.backgroundColor=RGBA(178, 139, 254, 1);
        _bgBottomView.layer.cornerRadius=KAdaptedHeight(15);
        _bgBottomView.layer.masksToBounds=YES;
        [self.contentView addSubview:_bgBottomView];
        [_bgBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
            
        }];
    }
    return _bgBottomView;
}


- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.text = getLanguage(@"10");
        _numLabel.textColor = RGBA(51, 51, 51, 1);
        _numLabel.font=KFontBold(15);
//        _numLabel.textAlignment=NSTextAlignmentCenter;
        [self.bgBottomView addSubview:_numLabel];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.width.mas_equalTo(KAdaptedWidth(30));
            make.height.mas_equalTo(KAdaptedHeight(20));
            
        }];
    }
    return _numLabel;
}

- (UIImageView*)numImgView{
    if (!_numImgView) {
        _numImgView = [[UIImageView alloc] init];
        [self.bgBottomView addSubview:_numImgView];
        [_numImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.width.height.mas_equalTo(KAdaptedHeight(25));
            
        }];
    }
    return _numImgView;
}



- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"未加载头像");
        _headImgView.layer.cornerRadius=KAdaptedHeight(25);
        _headImgView.layer.masksToBounds=YES;
        [self.bgBottomView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(self.numLabel.mas_trailing).offset(KAdaptedWidth(5));
            make.width.height.mas_equalTo(KAdaptedHeight(50));
            
        }];
    }
    return _headImgView;
}



- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = getLanguage(@"贴心小棉袄");
        _nameLabel.textColor = RGBA(51, 51, 51, 1);
        _nameLabel.font=KFont(15);
//        _nameLabel.textAlignment=NSTextAlignmentCenter;
        [self.bgBottomView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(13));
            make.height.mas_equalTo(KAdaptedHeight(20));
            make.trailing.mas_equalTo(KAdaptedWidth(-120));
            
        }];
    }
    return _nameLabel;
}


- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = getLanguage(@"331512");
        _moneyLabel.textColor = RGBA(51, 51, 51, 1);
        _moneyLabel.font=KFont(13);
        _moneyLabel.textAlignment=NSTextAlignmentRight;
        [self.bgBottomView addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(KAdaptedWidth(10));
            make.height.mas_equalTo(KAdaptedHeight(20));
            make.trailing.mas_equalTo(KAdaptedWidth(-20));
        }];
    }
    return _moneyLabel;
}





@end
