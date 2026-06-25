//
//  EMO_FaminlCenterTableCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/4.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_FaminlCenterTableCell.h"
@interface EMO_FaminlCenterTableCell()

Strong UIView *bgView;
Strong UIImageView *headImgView;
Strong UILabel *nameLabel;
Strong UIButton *sendBtn;
Strong UIButton *agreeBtn;
Strong UIView *lineView;

@end

@implementation EMO_FaminlCenterTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor=kClearColor;
        [self bgView];
        [self headImgView];
        [self sendBtn];
        [self agreeBtn];
        [self nameLabel];
        [self lineView];
    }
    return self;
}

-(void)setType:(NSInteger)type{
    _type=type;
    if(type==2){
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,KAdaptedWidth(60),KAdaptedHeight(30));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)RGBA(227, 227, 227, 1).CGColor,(__bridge id)RGBA(227, 227, 227, 1).CGColor];
        gl.locations = @[@(0.0),@(1.0f)];
        [self.agreeBtn.layer addSublayer:gl];
        [self.agreeBtn.layer insertSublayer:gl atIndex:1];
        [self.agreeBtn setTitle:getLanguage(@"踢出") forState:UIControlStateNormal];
        [self.agreeBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        
        
        self.sendBtn.backgroundColor=RGBA(247, 212, 91, 0.06);
        [self.sendBtn setTitle:getLanguage(@"流水") forState:UIControlStateNormal];
        [self.sendBtn setTitleColor:BaseMainColor forState:UIControlStateNormal];
        self.sendBtn.layer.borderColor=BaseMainColor.CGColor;
        self.sendBtn.layer.borderWidth=1;
    }else{
//        CAGradientLayer *gl = [CAGradientLayer layer];
//        gl.frame = CGRectMake(0,0,KAdaptedWidth(60),KAdaptedHeight(30));
//        gl.startPoint = CGPointMake(0.5, 0);
//        gl.endPoint = CGPointMake(0.5, 1);
//        gl.colors = @[(__bridge id)RGBA(247, 212, 91, 0.59).CGColor,(__bridge id)RGBA(255, 238, 1, 1).CGColor];
//        gl.locations = @[@(0.0),@(1.0f)];
//        [self.agreeBtn.layer addSublayer:gl];
//        [self.agreeBtn setTitle:getLanguage(@"同意") forState:UIControlStateNormal];
//        [self.agreeBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        
    }
    
    
    
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;

    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"avatar"]]]placeholderImage:KGetImage(@"未加载头像")];
    self.nameLabel.text=[Common isNull:dicData[@"nickname"]];
    
    
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
//        setViewCorner(_bgView, KAdaptedHeight(10));
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


- (UIButton *)agreeBtn{
    if (!_agreeBtn) {
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,KAdaptedWidth(60),KAdaptedHeight(30));
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);
        gl.colors = @[(__bridge id)RGBA(247, 212, 91, 0.59).CGColor,(__bridge id)RGBA(255, 238, 1, 1).CGColor];
        gl.locations = @[@(0.0),@(1.0f)];
        [self.agreeBtn.layer addSublayer:gl];
        _agreeBtn.layer.cornerRadius = KAdaptedHeight(30)/2;
        _agreeBtn.layer.masksToBounds=YES;
        [_agreeBtn setTitle:getLanguage(@"同意") forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _agreeBtn.titleLabel.font=KFontA(14);
        [_agreeBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _agreeBtn.tag=100;
        [self.bgView addSubview:_agreeBtn];
        [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(30));
            make.width.mas_equalTo(KAdaptedWidth(60));
        }];
    }
    return _agreeBtn;
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.backgroundColor=RGBA(241, 241, 241, 1);
        _sendBtn.layer.cornerRadius = KAdaptedHeight(30)/2;
        _sendBtn.layer.masksToBounds=YES;
        [_sendBtn setTitle:getLanguage(@"拒绝") forState:UIControlStateNormal];
        [_sendBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _sendBtn.titleLabel.font=KFontA(14);
        [_sendBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.tag=200;
        [self.bgView addSubview:_sendBtn];
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.agreeBtn.mas_centerY);
            make.trailing.mas_equalTo(self.agreeBtn.mas_leading).offset(KAdaptedWidth(-10));
            make.height.mas_equalTo(self.agreeBtn.mas_height);
            make.width.mas_equalTo(self.agreeBtn.mas_width);
        }];
    }
    return _sendBtn;
}



- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"昵称";
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

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBA(248, 248, 248, 1);
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.bottom.mas_equalTo(KAdaptedHeight(0));
            
        }];
    }
    return _lineView;
}




-(void)BtnClick:(UIButton *)sender{
    if(self.BtnBlock){
        self.BtnBlock(self.dicData,sender.tag);
    }
}




@end
