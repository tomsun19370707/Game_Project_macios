//
//  EMO_TaskTableViewCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/30.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_TaskTableViewCell.h"

@interface EMO_TaskTableViewCell ()
Strong UIView *bgVIew;
Strong UIImageView *headImgView;
Strong UILabel *nameLabel;
Strong UIButton *sendBtn;

@end

@implementation EMO_TaskTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor=kClearColor;
        [self bgVIew];
        [self headImgView];
        [self sendBtn];
        [self nameLabel];
        
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"image"]]]placeholderImage:KGetImage(@"未加载头像")];
    self.nameLabel.text=[Common isNull:dicData[@"name"]];
    if([dicData[@"is_finish"] integerValue]==1){
        self.sendBtn.userInteractionEnabled=NO;
        [self.sendBtn setTitle:getLanguage(@"已完成") forState:UIControlStateNormal];
        self.sendBtn.backgroundColor=RGBA(241, 241, 241, 1);
        [self.sendBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        self.sendBtn.layer.borderColor=RGBA(155, 155, 155, 0.16).CGColor;
    }else{
        self.sendBtn.userInteractionEnabled=YES;
        [self.sendBtn setTitle:getLanguage(@"去完成") forState:UIControlStateNormal];
        self.sendBtn.backgroundColor=RGBA(247, 212, 91, 0.12);
        [self.sendBtn setTitleColor:RGBA(226, 176, 4, 1) forState:UIControlStateNormal];
        self.sendBtn.layer.borderColor=BaseMainColor.CGColor;
    }
    
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
        _sendBtn.backgroundColor=RGBA(247, 212, 91, 0.12);
        [_sendBtn setTitle:getLanguage(@"去完成") forState:UIControlStateNormal];
        [_sendBtn setTitleColor:RGBA(226, 176, 4, 1) forState:UIControlStateNormal];
        _sendBtn.titleLabel.font=KFontA(13);
        _sendBtn.layer.borderWidth=1;
        _sendBtn.layer.borderColor=BaseMainColor.CGColor;
        _sendBtn.layer.cornerRadius=KAdaptedHeight(25)/2;
        _sendBtn.layer.masksToBounds=YES;
        [_sendBtn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bgVIew addSubview:_sendBtn];
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(25));
            make.width.mas_equalTo(KAdaptedWidth(60));
        }];
    }
    return _sendBtn;
}




- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"任务名称";
        _nameLabel.textColor = RGBA(0, 0, 0, 1);
        _nameLabel.font=KFont(14);
        _nameLabel.textAlignment=NSTextAlignmentLeft;
        [self.bgVIew addSubview:_nameLabel];
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
