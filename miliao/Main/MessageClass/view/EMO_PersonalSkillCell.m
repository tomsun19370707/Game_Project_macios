//
//  EMO_PersonalSkillCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/26.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_PersonalSkillCell.h"

@interface EMO_PersonalSkillCell ()

Strong UIView *bgView;
Strong UIImageView *iconImagView;
Strong UILabel *titleLabel;
Strong UILabel *contentLabel;

Strong UIView *voiceBgView;
Strong UIButton *voiceBtn;
Strong UIButton *playBtn;

Strong NSDictionary *dicData;
Strong NSIndexPath *rowIndex;

@end

@implementation EMO_PersonalSkillCell

-(NSDictionary *)dicData{
    if(!_dicData){
        _dicData=[NSDictionary dictionary];
    }
    return _dicData;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor=RGBA(248, 248, 248, 1);
        [self bgView];
        [self iconImagView];
        [self titleLabel];
        [self contentLabel];
        [self voiceBgView];
        [self voiceBtn];
        [self playBtn];
        
    }
    return self;
}

-(void)setPlay:(BOOL)play{
    _play=play;
    self.playBtn.selected=play;
    
}

-(void)cellDicData:(NSDictionary *)dicData andIndex:(NSIndexPath *)indexPath{
    self.dicData=dicData;
    self.rowIndex=indexPath;
    
    [self.iconImagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"skill_image"]]]placeholderImage:KGetImage(@"songImg")];
    self.titleLabel.text=[Common isNull:dicData[@"skill_name"]];
    self.contentLabel.text=[Common isNull:dicData[@"desc"]];
    [self.voiceBtn setTitle:[NSString stringWithFormat:@"%@s",dicData[@"times"]] forState:UIControlStateNormal];
    
    
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

- (UIImageView*)iconImagView{
    if (!_iconImagView) {
        _iconImagView = [[UIImageView alloc] init];
        _iconImagView.image=KGetImage(@"songImg");
        [self.bgView addSubview:_iconImagView];
        [_iconImagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(50), KAdaptedHeight(50)));
            make.leading.mas_equalTo(KAdaptedWidth(15));
        }];
    }
    return _iconImagView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"唱歌";
        _titleLabel.font=KFontBold(14);
        _titleLabel.textColor = RGBA(51, 51, 51, 1);
        [self.bgView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImagView.mas_top);
            make.bottom.mas_equalTo(self.iconImagView.mas_centerY);
            make.leading.mas_equalTo(self.iconImagView.mas_trailing).offset(KAdaptedWidth(12));
            make.trailing.mas_equalTo(self.bgView.mas_trailing).offset(KAdaptedWidth(-90));
            
        }];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"人美声甜欢迎来听我唱歌哦~";
        _contentLabel.font=KFont(13);
        _contentLabel.textColor = RGBA(102, 102, 102, 1);
        [self.bgView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
            make.bottom.mas_equalTo(self.iconImagView.mas_bottom);
            make.leading.mas_equalTo(self.titleLabel.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(self.titleLabel.mas_trailing).offset(KAdaptedWidth(-0));
            
        }];
    }
    return _contentLabel;
}


- (UIView *)voiceBgView{
    if (!_voiceBgView) {
        _voiceBgView = [[UIView alloc] init];
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,KAdaptedWidth(70),KAdaptedHeight(25));
        gl.startPoint = CGPointMake(0, 0.5);
        gl.endPoint = CGPointMake(1, 0.5);
        gl.colors = @[(__bridge id)BaseMainColor.CGColor, (__bridge id)RGBA(255, 238, 1, 1).CGColor];
        gl.locations = @[@(0), @(1.0f)];
        [_voiceBgView.layer addSublayer:gl];
        _voiceBgView.userInteractionEnabled=YES;
        [self.bgView addSubview:_voiceBgView];
        [_voiceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KAdaptedHeight(25));
            make.width.mas_equalTo(KAdaptedWidth(70));
            make.trailing.mas_equalTo(KAdaptedWidth(-10));
            make.centerY.mas_equalTo(self.iconImagView.mas_centerY);
            
        }];
        setViewCorner(_voiceBgView, KAdaptedHeight(25)/2);
    }
    return _voiceBgView;
}

- (UIButton *)voiceBtn{
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBtn setTitle:@"5s" forState:UIControlStateNormal];
        [_voiceBtn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        _voiceBtn.titleLabel.font=KFontA(12);
        [_voiceBtn setImage:[UIImage imageNamed:@"voiceImg"] forState:UIControlStateNormal];
        [_voiceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.voiceBgView addSubview:_voiceBtn];
        [_voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(KAdaptedWidth(5));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(50), KAdaptedHeight(20)));
        }];
        [_voiceBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];
    }
    return _voiceBtn;
}


- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"playImg"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"stopImg"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.voiceBgView addSubview:_playBtn];
        [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(25), KAdaptedWidth(25)));
        }];
       
    }
    return _playBtn;
}


-(void)btnClick:(UIButton *)sender{
    
    self.playBtn.selected=!self.playBtn.selected;
    
    if(self.PlayVoiceBlock){
        self.PlayVoiceBlock(self.dicData, self.playBtn.selected,self.rowIndex);
    }
//https://heart-chat.oss-cn-beijing.aliyuncs.com/uploads/20230705/a312df7abb1d21f6caee92a0b8e53482.mp3
    
    
    
}






@end
