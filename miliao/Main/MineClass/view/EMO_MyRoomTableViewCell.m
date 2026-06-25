//
//  EMO_MyRoomTableViewCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/4.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_MyRoomTableViewCell.h"

@interface EMO_MyRoomTableViewCell()
Strong UIView *showBgView;
Strong UIView *bgView;
Strong UIImageView *headImgView;
Strong UILabel *nameLabel;
Strong UIButton *typeBtn;
Strong UIButton *hotBtn;


@end

@implementation EMO_MyRoomTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor=RGBA(1, 1, 1, 0);
        self.contentView.backgroundColor=RGBA(246, 246, 246, 0);
        [self showBgView];
        [self bgView];
        [self headImgView];
        [self nameLabel];
        [self typeBtn];
        [self hotBtn];

        
    }
    return self;
}

-(void)setType:(BOOL)type{
    _type=type;
    self.hotBtn.hidden=type;
    
    
    
}


-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"image"]]]placeholderImage:KGetImage(@"list1")];
    self.nameLabel.text=[Common isNull:dicData[@"name"]];;
    [self.typeBtn setTitle:[Common isNull:dicData[@"uid"]] forState:UIControlStateNormal];
    [self.typeBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];
}


- (UIView *)showBgView{
    if (!_showBgView) {
        _showBgView = [[UIView alloc] init];
        _showBgView.layer.shadowColor = RGBA(162, 162, 162, 0.16).CGColor;
        _showBgView.layer.shadowOffset = CGSizeMake(0,0);
        _showBgView.layer.shadowOpacity = 1;
        _showBgView.layer.shadowRadius = 3;
        [self.contentView addSubview:_showBgView];
        [_showBgView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.mas_equalTo(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.bottom.mas_equalTo(KAdaptedWidth(-5));
        }];
    }
    return _showBgView;
}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderWidth = 1;
        _bgView.layer.borderColor = RGBA(255, 241, 217, 1).CGColor;
        _bgView.layer.cornerRadius=KAdaptedHeight(10);
        _bgView.layer.masksToBounds=YES;
        [self.showBgView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
        }];
        setViewCorner(_bgView, KAdaptedHeight(10));
    }
    return _bgView;
}


- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"list1");
        _headImgView.layer.cornerRadius=KAdaptedWidth(8);
        _headImgView.layer.masksToBounds=YES;
        [self.bgView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.leading.mas_equalTo(KAdaptedWidth(6));
            make.width.height.mas_equalTo(KAdaptedWidth(65));
            
        }];
    }
    return _headImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = getLanguage(@"昵称");
        _nameLabel.textColor = RGBA(51, 51, 51, 1);
        _nameLabel.font=KFont(14);
        [self.bgView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgView.mas_top);
            make.height.mas_equalTo(KAdaptedHeight(20));
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(10));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            
        }];
    }
    return _nameLabel;
}


- (UIButton *)typeBtn{
    if (!_typeBtn) {
        _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _typeBtn.backgroundColor=RGBA(254, 121, 119, 1);
        [_typeBtn setTitle:getLanguage(@"房间ID:1000") forState:UIControlStateNormal];
        [_typeBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        _typeBtn.titleLabel.font=KFontA(12);
        [_typeBtn setImage:[UIImage imageNamed:@"copyIconImg"] forState:UIControlStateNormal];
        _typeBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [_typeBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _typeBtn.tag=100;
        [self.bgView addSubview:_typeBtn];
        [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(100), KAdaptedHeight(25)));
            make.leading.mas_equalTo(self.nameLabel.mas_leading);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedHeight(6));
            
        }];
        [_typeBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];
    }
    return _typeBtn;
}

- (UIButton *)hotBtn{
    if (!_hotBtn) {
        _hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hotBtn setTitle:getLanguage(@"辞职") forState:UIControlStateNormal];
        [_hotBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        _hotBtn.titleLabel.font=KFont(13);
        _hotBtn.layer.borderColor=RGBA(155, 155, 155, 0.16).CGColor;
        _hotBtn.layer.borderWidth=1;
        [_hotBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _hotBtn.tag=200;
        [self.bgView addSubview:_hotBtn];
        [_hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(60), KAdaptedHeight(25)));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.centerY.mas_equalTo(self.typeBtn.mas_centerY);
            
        }];
        setViewCorner(_hotBtn, KAdaptedHeight(25)/2);
    }
    return _hotBtn;
}



-(void)BtnClick:(UIButton *)sender{
    if(sender.tag==100){
        UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
        pastboard.string = [NSString stringWithFormat:@"%@",self.typeBtn.titleLabel.text];
        [SVProgressHUD showSuccessWithStatus:getLanguage(@"已经复制到剪切板")];
    }else{
        if(self.BtnBlock){
            self.BtnBlock(self.dicData);
        }
        
    }
    
    

}



@end
