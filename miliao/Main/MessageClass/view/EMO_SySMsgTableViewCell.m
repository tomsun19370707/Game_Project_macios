//
//  EMO_SySMsgTableViewCell.m
//  miliao
//
//  Created by 张世浩 on 2023/6/25.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_SySMsgTableViewCell.h"

@interface EMO_SySMsgTableViewCell()
Strong UILabel *timeLabel;
Strong UIView *bgView;
Strong UIImageView *imgView;
Strong UILabel *contentLabel;


@end


@implementation EMO_SySMsgTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backgroundColor=RGBA(248, 248, 248, 1);
        [self timeLabel];
        [self bgView];
        [self imgView];
        [self contentLabel];
        
    }
    return self;
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    self.timeLabel.text=[Common isNull:dicData[@"createtime_text"]];
    self.contentLabel.text=[Common isNull:dicData[@"title"]];
    NSString *imageurl=[Common isNull:dicData[@"image"]];
    if([imageurl hasSuffix:@".png"]||[imageurl hasSuffix:@".PNG"]||[imageurl hasSuffix:@".jpg"]){
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[Common isNull:imageurl]]placeholderImage:KGetImage(@"sysBgImg")];
        self.imageView.hidden=NO;
        [self.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KAdaptedHeight(100));
        }];
    }else{
        self.imageView.hidden=YES;
        [self.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(KAdaptedHeight(0));
        }];
    }
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel=[[UILabel alloc] init];
        _timeLabel.textColor=RGBA(153, 153, 153, 1);
        _timeLabel.font=KFont(13);
        _timeLabel.text=getLanguage(@"2023-01-01");
        _timeLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(5));
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(20));
            
        }];
    }
    return _timeLabel;
}



- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.bottom.mas_equalTo(KAdaptedWidth(0));
        }];
        setViewCorner(_bgView, KAdaptedHeight(10));
    }
    return _bgView;
}

-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView=[[UIImageView alloc] init];
//        _imgView.image=KGetImage(@"sysBgImg");
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        [self.bgView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(KAdaptedWidth(0));
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(KAdaptedHeight(100));
//            make.bottom.mas_equalTo(-KAdaptedHeight(45));
            
        }];
    }
    return _imgView;
}


-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel=[[UILabel alloc] init];
        _contentLabel.textColor=RGBA(0, 0, 0, 1);
        _contentLabel.font=KFontBold(14);
        _contentLabel.text=getLanguage(@"系统消息通知");
        _contentLabel.numberOfLines=0;
        [self.bgView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imgView.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.mas_equalTo(self.bgView.mas_leading).offset(KAdaptedWidth(10));
            make.trailing.mas_equalTo(self.bgView.mas_trailing).offset(KAdaptedWidth(-10));
            make.bottom.mas_equalTo(-15);
            
        }];
    }
    return _contentLabel;
}





    

@end
