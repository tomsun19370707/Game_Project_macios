//
//  EMO_LikeTableViewCell.m
//  miliao
//
//  Created by 张世浩 on 2023/6/25.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_LikeTableViewCell.h"

@interface EMO_LikeTableViewCell()
Strong UIImageView *headimgView;
Strong UILabel *nickLabel;
Strong UILabel *contentlabel;
Strong UILabel *timeLabel;
Strong UIImageView *rightImgView;
Strong UILabel *dynamicLabel;
Strong UIView *lineView;

@end

@implementation EMO_LikeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor=kWhiteColor;
        [self headimgView];
        [self nickLabel];
        [self timeLabel];
        [self contentlabel];
        [self rightImgView];
        [self dynamicLabel];
        [self lineView];
        
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    [self.headimgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicData[@"avatar"]]] placeholderImage:KGetImage(@"未加载头像")];
    self.nickLabel.text=[NSString stringWithFormat:@"%@",dicData[@"nickname"]];
    self.contentlabel.text=[NSString stringWithFormat:@"%@",dicData[@"text"]];
    self.timeLabel.text=[NSString stringWithFormat:@"%@",dicData[@"createtime"]];
    
    
    NSString *str=[Common isNull:dicData[@"dynamic_image"]];
    if (str.length>0) {//type类型:1=图片,2=视频
        self.dynamicLabel.hidden=YES;
        self.rightImgView.hidden=NO;
//        if([dicData[@"lifes"][@"type"] integerValue]==2){
//            [self.rightImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?x-oss-process=video/snapshot,t_1000,f_jpg,w_375,h_667,m_fast",VERSION_HTTPS_SERVER,dicData[@"lifes"][@"imgs"]]] placeholderImage:KGetImage(@"未加载头像")];
//        }else{
//            NSArray *arr=[str componentsSeparatedByString:@","];
            [self.rightImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:KGetImage(@"未加载头像")];
//        }
    }else{
        self.dynamicLabel.hidden=NO;
        self.rightImgView.hidden=YES;
        self.dynamicLabel.text=[NSString stringWithFormat:@"%@",[Common isNull:dicData[@"dynamic_content"]]];
        
    }
    
    
    
}

- (UIImageView*)headimgView{
    if (!_headimgView) {
        _headimgView = [[UIImageView alloc] init];
        _headimgView.image=KGetImage(@"未加载头像");
        _headimgView.layer.cornerRadius=KAdaptedHeight(60)/2;
        _headimgView.layer.masksToBounds=YES;
        [self.contentView addSubview:_headimgView];
        [_headimgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(KAdaptedWidth(14));
            make.width.height.mas_equalTo(KAdaptedHeight(60));
            
            
        }];
    }
    return _headimgView;
}

- (UILabel *)nickLabel{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.text = @"昵称";
        _nickLabel.font=KFontBold(15);
        _nickLabel.textColor = RGBA(34, 34, 34, 1);
        [self.contentView addSubview:_nickLabel];
        [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headimgView.mas_top);
            make.leading.mas_equalTo(self.headimgView.mas_trailing).offset(KAdaptedWidth(14));
            make.trailing.mas_equalTo(KAdaptedWidth(-80));
            make.height.mas_equalTo(KAdaptedHeight(15));
        }];
    }
    return _nickLabel;
}





- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"2022-10-29 20:00";
        _timeLabel.font=KFont(12);
        _timeLabel.textColor = RGBA(153, 153, 153, 1);
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KAdaptedHeight(15));
            make.leading.mas_equalTo(self.nickLabel.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(self.nickLabel.mas_trailing).offset(KAdaptedWidth(0));
            make.bottom.mas_equalTo(self.headimgView.mas_bottom);
        }];
    }
    return _timeLabel;
}

- (UILabel *)contentlabel{
    if (!_contentlabel) {
        _contentlabel = [[UILabel alloc] init];
        _contentlabel.text = @"评论评论评论评论评论";
        _contentlabel.font=KFont(14);
        _contentlabel.textColor = RGBA(34, 34, 34, 1);
        _contentlabel.numberOfLines=0;
        [self.contentView addSubview:_contentlabel];
        [_contentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nickLabel.mas_bottom);
            make.leading.mas_equalTo(self.nickLabel.mas_leading).offset(KAdaptedWidth(0));
            make.trailing.mas_equalTo(self.nickLabel.mas_trailing);
            make.bottom.mas_equalTo(self.timeLabel.mas_top);
        }];
    }
    return _contentlabel;
}

- (UILabel *)dynamicLabel{
    if (!_dynamicLabel) {
        _dynamicLabel = [[UILabel alloc] init];
        _dynamicLabel.text = @"";
        _dynamicLabel.font=KFont(12);
        _dynamicLabel.textColor = RGBA(34, 34, 34, 1);
        _dynamicLabel.numberOfLines=0;
        _dynamicLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:_dynamicLabel];
        [_dynamicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KAdaptedWidth(75));
            make.width.mas_equalTo(KAdaptedWidth(75));
            make.trailing.mas_equalTo(KAdaptedWidth(-10));
            make.centerY.mas_equalTo(0);
        }];
    }
    return _dynamicLabel;
}


- (UIImageView*)rightImgView{
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] init];
        _rightImgView.image=KGetImage(@"未加载头像");
        _rightImgView.layer.cornerRadius=KAdaptedHeight(8);
        _rightImgView.layer.masksToBounds=YES;
        [self.contentView addSubview:_rightImgView];
        [_rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedHeight(75));
            make.trailing.mas_equalTo(KAdaptedWidth(-10));
            make.centerY.mas_equalTo(KAdaptedHeight(0));
            
        }];
    }
    return _rightImgView;
}


- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBA(248, 248, 248, 1);
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_equalTo(0);
            make.height.mas_equalTo(KAdaptedHeight(1));
            
        }];
    }
    return _lineView;
}



@end
