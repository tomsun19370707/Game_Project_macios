//
//  EMO_payView.m
//  MeetHer
//
//  Created by 张世浩 on 2023/2/10.
//

#import "EMO_payView.h"

@interface EMO_payView()



@end

@implementation EMO_payView


-(void)initView{
    [self iconImgView];
    [self selectImgView];
    [self nameLabel];
    [self selectBtn];
    
}

- (UIImageView*)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        [self addSubview:_iconImgView];
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(KAdaptedWidth(31));
            make.leading.mas_equalTo(KAdaptedWidth(15));
        }];
    }
    return _iconImgView;
}





- (UIImageView*)selectImgView{
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] init];
        [self addSubview:_selectImgView];
        [_selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
        }];
    }
    return _selectImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = RGBA(0, 0, 0, 1);
        _nameLabel.font=KFontBold(13);
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(KAdaptedWidth(10));
            make.trailing.mas_equalTo(self.selectImgView.mas_leading).offset(KAdaptedWidth(-10));
            make.top.bottom.mas_equalTo(0);
        }];
    }
    return _nameLabel;
}


- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_selectBtn];
        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(0);
            
        }];
    }
    return _selectBtn;
}



@end
