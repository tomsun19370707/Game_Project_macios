//
//  EMO_LotteryCollectionViewCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/26.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_LotteryCollectionViewCell.h"

@interface EMO_LotteryCollectionViewCell()
Strong UIView *bgView;
Strong UIImageView *headImgView;
Strong UILabel *nameLabel;
Strong UILabel *contentLabel;

@end

@implementation EMO_LotteryCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self bgView];
        [self headImgView];
        [self nameLabel];
        [self contentLabel];
        
    }
    
    return self;
}


-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    
   
//    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"image"]]] placeholderImage:KGetImage(@"未加载图片")];
    
    if([dicData[@"type"] integerValue]==0){
        self.headImgView.image=KGetImage(@"giftIconImg2");
    }else if ([dicData[@"type"] integerValue]==1){
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[Common isNull:dicData[@"dress_image"]]]];
    }else if ([dicData[@"type"] integerValue]==2){
        self.headImgView.image=KGetImage(@"giftIconImg6");
    }else if ([dicData[@"type"] integerValue]==3){
        self.headImgView.image=KGetImage(@"giftIconImg3");
    }
    
    self.nameLabel.text=[NSString stringWithFormat:@"%@",dicData[@"type_text"]];

    self.contentLabel.text=[NSString stringWithFormat:@"%@",dicData[@"probability"]];
    
    
    
}




- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius=KAdaptedHeight(10);
//        _bgView.layer.borderColor=RGBA(234, 234, 234, 1).CGColor;
//        _bgView.layer.borderWidth=KAdaptedWidth(0.5);
        _bgView.layer.masksToBounds=YES;
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.trailing.mas_equalTo(0);
            
        }];
    }
    return _bgView;
}

- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"未加载头像");
        [self.bgView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(13));
            make.width.height.mas_equalTo(KAdaptedWidth(45));
            make.centerX.mas_equalTo(0);
            
        }];
    }
    return _headImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = getLanguage(@"名称");
        _nameLabel.textColor = RGBA(51, 51, 51, 1);
        _nameLabel.font=KFont(13);
        _nameLabel.textAlignment=NSTextAlignmentCenter;
        [self.bgView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgView.mas_bottom).offset(KAdaptedHeight(3));
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            make.height.mas_equalTo(KAdaptedHeight(25));
            
        }];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = getLanguage(@"概率");
        _contentLabel.textColor = RGBA(102, 102, 102, 1);
        _contentLabel.font=KFont(11);
        _contentLabel.textAlignment=NSTextAlignmentCenter;
        [self.bgView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(KAdaptedHeight(0));
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            make.bottom.mas_equalTo(KAdaptedHeight(-13));
            
        }];
    }
    return _contentLabel;
}







@end
