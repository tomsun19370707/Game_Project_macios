//
//  EMO_InviteTableViewCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/30.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_InviteTableViewCell.h"

@interface EMO_InviteTableViewCell ()
Strong UIView *bgVIew;
Strong UIImageView *headImgView;
Strong UILabel *nameLabel;
Strong UILabel *moneyLabel;

@end


@implementation EMO_InviteTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor=kClearColor;
        [self bgVIew];
        [self headImgView];
        [self moneyLabel];
        [self nameLabel];
        
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;

    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"avatar"]]]placeholderImage:KGetImage(@"未加载头像")];
    self.nameLabel.text=[Common isNull:dicData[@"nickname"]];
    self.moneyLabel.text=[NSString stringWithFormat:@"%@元",dicData[@"price"]];
    
    
}



- (UIView *)bgVIew{
    if (!_bgVIew) {
        _bgVIew = [[UIView alloc] init];
        _bgVIew.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgVIew];
        [_bgVIew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.top.bottom.mas_equalTo(KAdaptedWidth(0));
        }];
    }
    return _bgVIew;
}

- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"未加载头像");
        [self.bgVIew addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedWidth(45));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.centerY.mas_equalTo(KAdaptedHeight(0));
        }];
        setViewCorner(_headImgView, KAdaptedWidth(45)/2);
    }
    return _headImgView;
}


- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"0元";
        _moneyLabel.textColor = RGBA(0, 0, 0, 1);
        _moneyLabel.font=KFont(14);
        _moneyLabel.textAlignment=NSTextAlignmentRight;
        [self.bgVIew addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(30));
            make.width.mas_equalTo(KAdaptedWidth(100));
            
        }];
    }
    return _moneyLabel;
}



- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"昵称";
        _nameLabel.textColor = RGBA(0, 0, 0, 1);
        _nameLabel.font=KFont(14);
        _nameLabel.textAlignment=NSTextAlignmentLeft;
        [self.bgVIew addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(10));
            make.trailing.mas_equalTo(self.moneyLabel.mas_leading).offset(KAdaptedWidth(-10));
            make.height.mas_equalTo(KAdaptedHeight(30));
            
        }];
    }
    return _nameLabel;
}



@end
