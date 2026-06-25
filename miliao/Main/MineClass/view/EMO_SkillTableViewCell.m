//
//  EMO_SkillTableViewCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/3.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_SkillTableViewCell.h"

@interface EMO_SkillTableViewCell()

Strong UIView *bgView;
Strong UIImageView *headImgView;
Strong UILabel *nameLabel;
Strong UIButton *sendBtn;

@end

@implementation EMO_SkillTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor=kClearColor;
        [self bgView];
        [self headImgView];
        [self sendBtn];
        [self nameLabel];
        
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    
//    _headImgView.image=KGetImage(@"未加载头像");
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"image"]]]placeholderImage:KGetImage(@"未加载头像")];
    self.nameLabel.text=[Common isNull:dicData[@"name"]];
    
    
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

- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"未加载头像");
        [self.bgView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedWidth(40));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.centerY.mas_equalTo(KAdaptedHeight(0));
        }];
        setViewCorner(_headImgView, KAdaptedWidth(40)/2);
    }
    return _headImgView;
}



- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,KAdaptedWidth(60),KAdaptedHeight(30));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)RGBA(247, 212, 91, 0.59).CGColor,(__bridge id)RGBA(255, 238, 1, 1).CGColor];
        gl.locations = @[@(0.0),@(1.0f)];
        [_sendBtn.layer addSublayer:gl];
        _sendBtn.layer.cornerRadius = KAdaptedHeight(30)/2;
        _sendBtn.layer.masksToBounds=YES;
        [_sendBtn setTitle:getLanguage(@"添加") forState:UIControlStateNormal];
        [_sendBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _sendBtn.titleLabel.font=KFontA(14);
        [_sendBtn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_sendBtn];
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(30));
            make.width.mas_equalTo(KAdaptedWidth(60));
        }];
    }
    return _sendBtn;
}




- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"技能名称";
        _nameLabel.textColor = RGBA(0, 0, 0, 1);
        _nameLabel.font=KFont(14);
        _nameLabel.textAlignment=NSTextAlignmentLeft;
        [self.bgView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(10));
            make.trailing.mas_equalTo(self.sendBtn.mas_leading).offset(KAdaptedWidth(-10));
            make.height.mas_equalTo(KAdaptedHeight(30));
            
        }];
    }
    return _nameLabel;
}


-(void)BtnClick{
    if(self.BtnBlock){
        self.BtnBlock(self.dicData);
    }
}




@end
