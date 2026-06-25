//
//  EMO_RoomAnnouncementView.m
//  miliao
//
//  Created by 张世浩 on 2022/10/21.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_RoomAnnouncementView.h"

@interface EMO_RoomAnnouncementView()<UITextViewDelegate>
//Strong UIView *bgView;
Strong UIImageView *bgImgView;
Strong UILabel *titleLabel;
Strong UILabel *contentLabel;
Strong UITextView *contentView;



@end


@implementation EMO_RoomAnnouncementView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor=[UIColor clearColor];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [self addGestureRecognizer:singleTap];
        
    }
    return self;
}

-(void)initView{
    [self bgImgView];
    [self titleLabel];
    [self contentView];
    
}

-(void)upData{
    self.contentView.text=[NSString stringWithFormat:@"%@",[Common isNull:[MLRoomInformationModel currentAccount].notice]];
}


- (UIImageView*)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
//        _bgImgView.image=KGetImage(@"RoomAnnouncementImg");
        _bgImgView.backgroundColor=RGBA(255, 255, 255, 0.9);
        [self addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(150));
            make.leading.mas_equalTo(KAdaptedWidth(37.5));
            make.trailing.mas_equalTo(KAdaptedWidth(-37.5));
            make.bottom.mas_equalTo(KAdaptedHeight(-180));
            
        }];
        setViewCorner(_bgImgView, KAdaptedHeight(10));
    }
    return _bgImgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = getLanguage(@"房间公告");
        _titleLabel.textColor = RGBA(51, 51, 51, 1);
        _titleLabel.font=KFont(14);
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgImgView.mas_top).offset(KAdaptedHeight(30));
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(30));
            
            
        }];
    }
    return _titleLabel;
}


- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];

        _contentLabel.textColor = RGBA(51, 51, 51, 1);
        _contentLabel.font=KFont(14);
        _contentLabel.textAlignment=NSTextAlignmentCenter;
        
        _contentLabel.numberOfLines=0;
        [_contentLabel sizeToFit];
        [self addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(KAdaptedHeight(10));
            make.leading.mas_equalTo(KAdaptedWidth(24+37.5));
            make.trailing.mas_equalTo(KAdaptedWidth(-24-37.5));
            make.bottom.mas_equalTo(self.bgImgView.mas_bottom).offset(KAdaptedHeight(-20));
            
            
        }];
    }
    return _contentLabel;
}


-(UITextView*)contentView{
    if (!_contentView) {
        _contentView = [[UITextView alloc] init];
        _contentView.text=[NSString stringWithFormat:@"%@",[Common isNull:[MLRoomInformationModel currentAccount].notice]];
        
        _contentView.textColor = RGBA(51, 51, 51, 1);
        _contentView.backgroundColor=kClearColor;
        _contentView.font=KFontA(12);
        _contentView.textAlignment=NSTextAlignmentCenter;
        _contentView.delegate=self;
        _contentView.editable=NO;
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(KAdaptedHeight(25));
            make.leading.mas_equalTo(KAdaptedWidth(24+37.5));
            make.trailing.mas_equalTo(KAdaptedWidth(-24-37.5));
            make.bottom.mas_equalTo(self.bgImgView.mas_bottom).offset(KAdaptedHeight(-30));
            
        }];
    }
    return _contentView;
}





//- (void)loadData:(id)obj{
//    CGSize announcementLBSize = [[MLRoomInformationModel currentAccount].room_intro sizeWithFont:Font(13) With:self.width - 40];
//
//    _announcementLB.text = [MLRoomInformationModel currentAccount].room_intro;
//    _announcementViewH.constant = announcementLBSize.height + 60;
//
//}

- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}


//
//- (UIView *)bgView{
//    if (!_bgView) {
//        _bgView = [[UIView alloc] init];
//        _bgView.backgroundColor = [UIColor clearColor];
//        [self addSubview:_bgView];
//        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        }];
//    }
//    return _bgView;
//}



@end
