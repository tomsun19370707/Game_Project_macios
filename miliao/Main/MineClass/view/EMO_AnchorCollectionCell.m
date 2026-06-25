//
//  EMO_AnchorCollectionCell.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/29.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_AnchorCollectionCell.h"

@interface EMO_AnchorCollectionCell()

Strong UIImageView *headImgView;
Strong UILabel *nameLabel;


@end

@implementation EMO_AnchorCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self headImgView];
        [self nameLabel];
    }
    
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[Common isNull:dicData[@"avatar"]]]placeholderImage:KGetImage(@"womanDefaultImg")];
    
    self.nameLabel.text=[Common isNull:dicData[@"nickname"]];
}

- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"womanDefaultImg");
        [self.contentView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.mas_equalTo(0);
            make.width.height.mas_equalTo(KAdaptedWidth(50));
            
        }];
        setViewCorner(_headImgView, KAdaptedWidth(25));
    }
    return _headImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"昵称";
        _nameLabel.font=KFontA(12);
        _nameLabel.textColor = RGBA(0, 0, 0, 1);
        _nameLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.headImgView.mas_bottom).offset(KAdaptedHeight(5));
        }];
    }
    return _nameLabel;
}



@end
