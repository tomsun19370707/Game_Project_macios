//
//  EMO_MineTableViewCell.m
//  miliao
//
//  Created by 张世浩 on 2022/10/12.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_MineTableViewCell.h"

@interface EMO_MineTableViewCell()
Strong UIView *bgView;
Strong UIImageView *iconImgView;
Strong UILabel *nameLabel;
Strong UIImageView *rightImgView;


@end


@implementation EMO_MineTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor= RGBA(248, 248, 248, 1);
        [self bgView];
        
        [self iconImgView];
        [self nameLabel];
        [self rightImgView];
        
        
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    self.iconImgView.image=KGetImage(dicData[@"img"]);
    self.nameLabel.text=dicData[@"name"];
    
}

-(void)setTopAndBottom:(NSInteger)topAndBottom{
    _topAndBottom=topAndBottom;
    if(topAndBottom==1){
        [self.bgView roundTopCornersRadius:8];
    }else if (topAndBottom==2){
        [self.bgView roundBottomCornersRadius:8];
    }else{
        
    }
    
}




- (UIView *)bgView{
    if (!_bgView) {
//        _bgView = [[UIView alloc] init];
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(KAdaptedWidth(14), 0, kWidth-KAdaptedWidth(28), KAdaptedHeight(40))];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
//        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.mas_equalTo(KAdaptedHeight(0));
//            make.leading.mas_equalTo(KAdaptedWidth(14));
//            make.trailing.mas_equalTo(KAdaptedWidth(-14));
//
//        }];
     
        
    }
    return _bgView;
}

- (UIImageView*)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        [self.bgView addSubview:_iconImgView];
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(22), KAdaptedWidth(22)));
            make.leading.mas_equalTo(KAdaptedHeight(13.5));
            
        }];
    }
    return _iconImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = getLanguage(@"我的");
        _nameLabel.textColor = RGBA(34, 34, 34, 1);
        _nameLabel.font=KFont(15);
        [self.bgView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
            make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-30));
            make.height.mas_equalTo(KAdaptedHeight(25));
            
        }];
    }
    return _nameLabel;
}



- (UIImageView*)rightImgView{
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] init];
        _rightImgView.image=KGetImage(@"mineRightImg");
        [self.bgView addSubview:_rightImgView];
        [_rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(10), KAdaptedHeight(13)));
            make.trailing.mas_equalTo(KAdaptedHeight(-14.5));
            
        }];
    }
    return _rightImgView;
}


@end
