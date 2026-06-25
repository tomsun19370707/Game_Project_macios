//
//  EMO_EditUserMsgTableViewCell.m
//  miliao
//
//  Created by 张世浩 on 2022/10/13.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_EditUserMsgTableViewCell.h"

@interface EMO_EditUserMsgTableViewCell()

@property(nonatomic,strong) UIView * bgView;
@property(nonatomic,strong) UILabel * nameLabel;
@property(nonatomic,strong) UILabel * contentLabel;

@property(nonatomic,strong) UIImageView * rightImgView;
@property(nonatomic,strong) UIView * lineView;

@end


@implementation EMO_EditUserMsgTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor= RGBA(248, 248, 248, 1);
        [self bgView];
        [self nameLabel];
        [self rightImgView];
        [self headImgView];
        [self contentLabel];
        [self lineView];
        
        
    }
    return self;
}


-(void)setChangeStr:(NSString *)changeStr{
    _changeStr=changeStr;
    self.contentLabel.text=changeStr;
    
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    self.nameLabel.text=[NSString stringWithFormat:@"%@",dicData[@"name"]];
    self.contentLabel.text=[NSString stringWithFormat:@"%@",dicData[@"data"]];
    
    if ([dicData[@"change"] integerValue]==0) {
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"data"]]]placeholderImage:KGetImage(@"manDefaultImg")];
        self.contentLabel.hidden=YES;
        self.headImgView.hidden=NO;
    }else{
        self.contentLabel.hidden=NO;
        self.headImgView.hidden=YES;
    }
    
    
}




- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_equalTo(KAdaptedHeight(0));
//            make.bottom.mas_equalTo(KAdaptedWidth(-1));
    
        }];
    
    }
    return _bgView;
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
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(self.bgView.mas_centerX);
            make.height.mas_equalTo(self.bgView.mas_height);
            
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
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(11), KAdaptedWidth(11)));
            make.trailing.mas_equalTo(KAdaptedHeight(-14.5));
            
        }];
    }
    return _rightImgView;
}

- (UIImageView*)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.image=KGetImage(@"manDefaultImg");
        [self.bgView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(50), KAdaptedWidth(50)));
            make.trailing.mas_equalTo(self.rightImgView.mas_leading).offset(KAdaptedHeight(-5));
            
        }];
        setViewCorner(_headImgView, KAdaptedWidth(25));
    }
    return _headImgView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = getLanguage(@"内容");
        _contentLabel.textColor = RGBA(153, 153, 153, 1);
        _contentLabel.font=KFont(10);
        _contentLabel.textAlignment=NSTextAlignmentRight;
        [self.bgView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
            make.trailing.mas_equalTo(self.rightImgView.mas_leading).offset(KAdaptedWidth(-5.5));
            make.leading.mas_equalTo(self.nameLabel.mas_trailing);
            make.height.mas_equalTo(self.nameLabel.mas_height);
            
        }];
    }
    return _contentLabel;
}



- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBA(248, 248, 248, 1);
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(KAdaptedHeight(0));
            make.height.mas_equalTo(KAdaptedHeight(0.5));
            make.leading.mas_equalTo(KAdaptedWidth(14));
            make.trailing.mas_equalTo(KAdaptedWidth(-14));
    
        }];
    
    }
    return _lineView;
}









@end
