//
//  EMO_BlackListTableViewCell.m
//  miliao
//
//  Created by 张世浩 on 2022/10/14.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_BlackListTableViewCell.h"
#import "EMO_FriendsModel.h"

@interface EMO_BlackListTableViewCell()

Strong UIImageView *headImgView;
Strong UILabel *nameLabel;
//Strong UILabel *IDLabel;
Strong UIButton *relieveBtn;
Strong UIView *lineView;



@end

@implementation EMO_BlackListTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self headImgView];
        [self nameLabel];
//        [self IDLabel];
        [self relieveBtn];
        [self lineView];
        
    }
    
    return self;
}

-(void)setModel:(NSDictionary *)model{
    _model=model;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model[@"avatar"]]];
    self.nameLabel.text = model[@"nickname"];
//    self.IDLabel.text = NSStringFormat(@"ID:%@",model.friendID);
}



- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"未加载头像");
        _headImgView.layer.cornerRadius=KAdaptedWidth(53/2);
        _headImgView.layer.masksToBounds=YES;
        [self.contentView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(53), KAdaptedWidth(53)));
            make.leading.mas_equalTo(KAdaptedHeight(15.5));
            
        }];
    }
    return _headImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = getLanguage(@"昵称");
        _nameLabel.textColor = RGBA(0, 0, 0, 1);
        _nameLabel.font=KFontBold(15);
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImgView.mas_top);
            make.bottom.mas_equalTo(self.headImgView.mas_bottom).offset(KAdaptedWidth(0));
            make.leading.mas_equalTo(self.headImgView.mas_trailing).offset(KAdaptedWidth(10));
            make.trailing.mas_equalTo(KAdaptedWidth(-100));
            
        }];
    }
    return _nameLabel;
}

//- (UILabel *)IDLabel{
//    if (!_IDLabel) {
//        _IDLabel = [[UILabel alloc] init];
//        _IDLabel.text = getLanguage(@"ID:");
//        _IDLabel.textColor = RGBA(153, 153, 153, 1);
//        _IDLabel.font=KFont(12);
//        [self.contentView addSubview:_IDLabel];
//        [_IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.nameLabel.mas_bottom);
//            make.bottom.mas_equalTo(self.headImgView.mas_bottom).offset(KAdaptedWidth(0));
//            make.leading.mas_equalTo(self.nameLabel.mas_leading).offset(KAdaptedWidth(0));
//            make.trailing.mas_equalTo(self.nameLabel.mas_trailing);
//
//        }];
//    }
//    return _nameLabel;
//}



- (UIButton *)relieveBtn{
    if (!_relieveBtn) {
        _relieveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _relieveBtn.backgroundColor=RGBA(101, 190, 255, 1);
        [_relieveBtn setTitle:getLanguage(@"解除拉黑") forState:UIControlStateNormal];
        [_relieveBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        _relieveBtn.titleLabel.font=KFont(13);
        _relieveBtn.layer.borderColor=RGBA(155, 155, 155, 0.16).CGColor;
        _relieveBtn.layer.borderWidth=1;
        _relieveBtn.layer.cornerRadius=KAdaptedHeight(14);
        _relieveBtn.layer.masksToBounds=YES;
        [_relieveBtn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_relieveBtn];
        [_relieveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-14.5));
            make.centerY.mas_equalTo(self.headImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(68), KAdaptedHeight(28)));
            
        }];
    }
    return _relieveBtn;
}


- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBA(248, 248, 248, 1);
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(KAdaptedHeight(0));
            make.height.mas_equalTo(KAdaptedHeight(0.5));
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
    
        }];
    
    }
    return _lineView;
}



-(void)BtnClick{
    ! self.quDingButtonClickBlock ?: self.quDingButtonClickBlock(self.model);
}


@end
