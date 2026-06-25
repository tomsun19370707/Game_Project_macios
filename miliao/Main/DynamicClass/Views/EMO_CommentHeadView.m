//
//  EMO_CommentHeadView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/17.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_CommentHeadView.h"

@interface EMO_CommentHeadView()
Strong UIView *bgView;
Strong UIImageView *headImgView;
Strong UILabel *nameLabel;
Strong UILabel *contentLabel;
Strong UILabel *timeLabel;
Strong UIButton *moreBtn;
Strong UIButton *likeBtn;

Strong UIButton *clickBtn;


@end

@implementation EMO_CommentHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self bgView];
        [self headImgView];
        [self nameLabel];
        [self contentLabel];
        [self moreBtn];
        [self likeBtn];
        [self clickBtn];
        
    }
    return self;
}

-(void)setDicData:(NSMutableDictionary *)dicData{
    _dicData=dicData;
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"avatar"]]]placeholderImage:KGetImage(@"未加载头像")];
    self.nameLabel.text=[Common isNull:dicData[@"nickname"]];
    self.timeLabel.text=[Common isNull:dicData[@"createtime"]];
    [self.likeBtn setTitle:[Common isNull:dicData[@"like_num"]] forState:UIControlStateNormal];
    self.contentLabel.text=[Common isNull:dicData[@"comment"]];
    
    if([self.dicData[@"is_like"] integerValue]==1){
        self.likeBtn.selected=YES;
        
    }
    [self.likeBtn setTitle:[Common isNull:self.dicData[@"like_num"]] forState:UIControlStateNormal];
    
}







- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(KAdaptedWidth(0));
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
        }];
    }
    return _bgView;
}

- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        [self.bgView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedWidth(40));
            make.top.mas_equalTo(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(15));
        }];
        setViewCorner(_headImgView, KAdaptedWidth(20));
    }
    return _headImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"昵称";
        _nameLabel.font=KFontA(14);
        _nameLabel.textColor = RGBA(102, 102, 102, 1);
        [self.bgView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgView.mas_top);
            make.trailing.mas_equalTo(KAdaptedWidth(-100));
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(8));
            make.height.mas_equalTo(KAdaptedHeight(30));
        }];
    }
    return _nameLabel;
}






- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"内容";
        _contentLabel.font=KFontA(14);
        _contentLabel.textColor = RGBA(0, 0, 0, 1);
        _contentLabel.numberOfLines=0;
        [self.bgView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedHeight(5));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.leading.mas_equalTo(self.nameLabel.mas_leading).offset(KAdaptedWidth(0));
            make.bottom.mas_equalTo(KAdaptedHeight(-35));
        }];
    }
    return _contentLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"2023-01-01";
        _timeLabel.font=KFontA(12);
        _timeLabel.textColor = RGBA(153, 153, 153, 1);
        [self.bgView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KAdaptedHeight(35));
            make.trailing.mas_equalTo(self.nameLabel.mas_trailing);
            make.leading.mas_equalTo(self.nameLabel.mas_leading).offset(KAdaptedWidth(0));
            make.bottom.mas_equalTo(KAdaptedHeight(0));
        }];
    }
    return _timeLabel;
}


- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageNamed:@"dynamicMoreImg"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.tag=100;
        _moreBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [self.bgView addSubview:_moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.width.height.mas_equalTo(KAdaptedHeight(25));
            make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
            
        }];
    }
    return _moreBtn;
}

- (UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setTitle:@"11" forState:UIControlStateNormal];
        [_likeBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        [_likeBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateSelected];
        _likeBtn.titleLabel.font=KFontA(11);
        [_likeBtn setImage:[UIImage imageNamed:@"LikeNoImg"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"likeSelectImg"] forState:UIControlStateSelected];
        [_likeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _likeBtn.tag=200;
        _likeBtn.selected=NO;
        _likeBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [self.bgView addSubview:_likeBtn];
        [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(30));
            make.width.mas_equalTo(KAdaptedWidth(85));
            make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
            
        }];
    }
    return _likeBtn;
}

- (UIButton *)clickBtn{
    if (!_clickBtn) {
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clickBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _clickBtn.tag=300;
        [self.bgView addSubview:_clickBtn];
        [_clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.nameLabel.mas_trailing);
            make.leading.mas_equalTo(self.nameLabel.mas_leading);
            make.top.bottom.mas_equalTo(0);
            
        }];
    }
    return _clickBtn;
}






-(void)btnClick:(UIButton *)sender{

        if(self.BtnClick){
            self.BtnClick(self.dicData, sender.tag);
        }
    

}






@end
