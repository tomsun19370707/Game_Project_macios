//
//  EMO_RoomMoreView.m
//  miliao
//
//  Created by 张世浩 on 2022/10/20.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_RoomMoreView.h"

@interface EMO_RoomMoreView()

Strong UIImageView *bgImgView;

Strong UIImageView *shareImgView;
Strong UILabel *shareLabel;
Strong UIButton *shareBtn;

Strong UIImageView *closeRoomImgView;
Strong UILabel *closeRoomLabel;
Strong UIButton *closeRoomBtn;

Strong UIImageView *reportRoomImgView;
Strong UILabel *reportRoomLabel;
Strong UIButton *reportRoomBtn;

Strong UIImageView *MaskAnimationImgView;
Strong UILabel *MaskAnimationLabel;
Strong UIButton *MaskAnimationBtn;

@end


@implementation EMO_RoomMoreView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor=[UIColor clearColor];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}

-(void)initView{
    [self bgImgView];
    
    [self shareImgView];
    [self shareLabel];
    [self shareBtn];

    [self closeRoomImgView];
    [self closeRoomLabel];
    [self closeRoomBtn];

    [self reportRoomImgView];
    [self reportRoomLabel];
    [self reportRoomBtn];
    
    [self MaskAnimationImgView];
    [self MaskAnimationLabel];
    [self MaskAnimationBtn];
    
}

- (UIImageView*)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
//        _bgImgView.image=KGetImage(@"moreBgImg");
        _bgImgView.backgroundColor=RGBA(255, 255, 255, 0.9);
        [self addSubview:_bgImgView];
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(-15));
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(110)+kSafeArea_Top);
        }];
        setViewCorner(_bgImgView, KAdaptedHeight(15));
    }
    return _bgImgView;
}


- (UIImageView*)shareImgView{
    if (!_shareImgView) {
        _shareImgView = [[UIImageView alloc] init];
        _shareImgView.image=KGetImage(@"shareRoomImg");
        [self addSubview:_shareImgView];
        [_shareImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(self.mas_leading).offset(KAdaptedWidth(kWidth/8-KAdaptedWidth(13)));
            make.leading.mas_equalTo(KAdaptedWidth(43));
            make.width.height.mas_equalTo(KAdaptedWidth(27));
            make.top.mas_equalTo(KAdaptedHeight(25)+kSafeArea_Top);
        }];
    }
    return _shareImgView;
}

- (UILabel *)shareLabel{
    if (!_shareLabel) {
        _shareLabel = [[UILabel alloc] init];
        _shareLabel.text = getLanguage(@"分享房间");
        _shareLabel.textColor = RGBA(51, 51, 51, 1);
        _shareLabel.font=KFont(13);
        _shareLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_shareLabel];
        [_shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.shareImgView.mas_centerX);
            make.width.mas_equalTo(kWidth/4);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(self.shareImgView.mas_bottom).offset(KAdaptedHeight(5));
            
            
        }];
    }
    return _shareLabel;
}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.tag=100;
        [self addSubview:_shareBtn];
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.shareImgView.mas_top);
            make.leading.mas_equalTo(self.shareLabel.mas_leading);
            make.trailing.mas_equalTo(self.shareLabel.mas_trailing);
            make.bottom.mas_equalTo(self.shareLabel.mas_bottom);;
            
        }];
    }
    return _shareBtn;
}



- (UIImageView*)closeRoomImgView{
    if (!_closeRoomImgView) {
        _closeRoomImgView = [[UIImageView alloc] init];
        _closeRoomImgView.image=KGetImage(@"closeRoomImg");
        [self addSubview:_closeRoomImgView];
        [_closeRoomImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.shareImgView.mas_width);
            make.height.mas_equalTo(self.shareImgView.mas_height);
            make.centerY.mas_equalTo(self.shareImgView.mas_centerY);
//            make.centerX.mas_equalTo(self.mas_leading).offset(KAdaptedWidth(kWidth/8*3-KAdaptedWidth(13)));
            make.leading.mas_equalTo(self.shareImgView.mas_trailing).offset(KAdaptedWidth(60));
            
        }];
    }
    return _closeRoomImgView;
}

- (UILabel *)closeRoomLabel{
    if (!_closeRoomLabel) {
        _closeRoomLabel = [[UILabel alloc] init];
        _closeRoomLabel.text = getLanguage(@"关闭房间");
        _closeRoomLabel.textColor = RGBA(51, 51, 51, 1);
        _closeRoomLabel.font=KFont(13);
        _closeRoomLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_closeRoomLabel];
        [_closeRoomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.shareLabel.mas_width);
            make.height.mas_equalTo(self.shareLabel.mas_height);
            make.centerY.mas_equalTo(self.shareLabel.mas_centerY);
            make.centerX.mas_equalTo(self.closeRoomImgView.mas_centerX);
            
        }];
    }
    return _closeRoomLabel;
}

- (UIButton *)closeRoomBtn{
    if (!_closeRoomBtn) {
        _closeRoomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeRoomBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _closeRoomBtn.tag=200;
        [self addSubview:_closeRoomBtn];
        [_closeRoomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.closeRoomImgView.mas_top);
            make.leading.mas_equalTo(self.closeRoomLabel.mas_leading);
            make.trailing.mas_equalTo(self.closeRoomLabel.mas_trailing);
            make.bottom.mas_equalTo(self.closeRoomLabel.mas_bottom);;
            
        }];
    }
    return _closeRoomBtn;
}



- (UIImageView*)reportRoomImgView{
    if (!_reportRoomImgView) {
        _reportRoomImgView = [[UIImageView alloc] init];
        _reportRoomImgView.image=KGetImage(@"reportRoomImg");
        [self addSubview:_reportRoomImgView];
        [_reportRoomImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.shareImgView.mas_width);
            make.height.mas_equalTo(self.shareImgView.mas_height);
            make.centerY.mas_equalTo(self.shareImgView.mas_centerY);
//            make.centerX.mas_equalTo(self.mas_leading).offset(KAdaptedWidth(kWidth/8*5-KAdaptedWidth(13)));
            make.leading.mas_equalTo(self.closeRoomImgView.mas_trailing).offset(KAdaptedWidth(60));
        }];
    }
    return _reportRoomImgView;
}

- (UILabel *)reportRoomLabel{
    if (!_reportRoomLabel) {
        _reportRoomLabel = [[UILabel alloc] init];
        _reportRoomLabel.text = getLanguage(@"举报房间");
        _reportRoomLabel.textColor = RGBA(51, 51, 51, 1);
        _reportRoomLabel.font=KFont(13);
        _reportRoomLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_reportRoomLabel];
        [_reportRoomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.shareLabel.mas_width);
            make.height.mas_equalTo(self.shareLabel.mas_height);
            make.centerY.mas_equalTo(self.shareLabel.mas_centerY);
            make.centerX.mas_equalTo(self.reportRoomImgView.mas_centerX);
        }];
    }
    return _reportRoomLabel;
}

- (UIButton *)reportRoomBtn{
    if (!_reportRoomBtn) {
        _reportRoomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reportRoomBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _reportRoomBtn.tag=300;
        [self addSubview:_reportRoomBtn];
        [_reportRoomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.reportRoomImgView.mas_top);
            make.leading.mas_equalTo(self.reportRoomLabel.mas_leading);
            make.trailing.mas_equalTo(self.reportRoomLabel.mas_trailing);
            make.bottom.mas_equalTo(self.reportRoomLabel.mas_bottom);;
            
        }];
    }
    return _reportRoomBtn;
}


- (UIImageView*)MaskAnimationImgView{
    if (!_MaskAnimationImgView) {
        _MaskAnimationImgView = [[UIImageView alloc] init];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:kIsOpenRoomGiftAnimation] integerValue]==1) {
            _MaskAnimationImgView.image = KGetImage(@"AnimationCloseImg");
        }else{
            _MaskAnimationImgView.image = KGetImage(@"AnimationImg");
        }
        [self addSubview:_MaskAnimationImgView];
        [_MaskAnimationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.shareImgView.mas_width);
            make.height.mas_equalTo(self.shareImgView.mas_height);
            make.centerY.mas_equalTo(self.shareImgView.mas_centerY);
//            make.centerX.mas_equalTo(self.mas_leading).offset(KAdaptedWidth(kWidth/8*7-KAdaptedWidth(13)));
            make.leading.mas_equalTo(self.reportRoomImgView.mas_trailing).offset(KAdaptedWidth(60));
        }];
    }
    return _MaskAnimationImgView;
}

- (UILabel *)MaskAnimationLabel{
    if (!_MaskAnimationLabel) {
        _MaskAnimationLabel = [[UILabel alloc] init];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:kIsOpenRoomGiftAnimation] integerValue]==1) {
            _MaskAnimationLabel.text = getLanguage(@"关闭特效");
        }else{
            _MaskAnimationLabel.text = getLanguage(@"开启特效");
        }
        
        _MaskAnimationLabel.textColor =  RGBA(51, 51, 51, 1);
        _MaskAnimationLabel.font=KFont(13);
        _MaskAnimationLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_MaskAnimationLabel];
        [_MaskAnimationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.shareLabel.mas_width);
            make.height.mas_equalTo(self.shareLabel.mas_height);
            make.centerY.mas_equalTo(self.shareLabel.mas_centerY);
            make.centerX.mas_equalTo(self.MaskAnimationImgView.mas_centerX);
        }];
    }
    return _MaskAnimationLabel;
}

- (UIButton *)MaskAnimationBtn{
    if (!_MaskAnimationBtn) {
        _MaskAnimationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_MaskAnimationBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _MaskAnimationBtn.tag=400;
        [self addSubview:_MaskAnimationBtn];
        [_MaskAnimationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.MaskAnimationImgView.mas_top);
            make.leading.mas_equalTo(self.MaskAnimationLabel.mas_leading);
            make.trailing.mas_equalTo(self.MaskAnimationLabel.mas_trailing);
            make.bottom.mas_equalTo(self.MaskAnimationLabel.mas_bottom);;
            
        }];
    }
    return _MaskAnimationBtn;
}


-(void)BtnClick:(UIButton *)sender{
    if(sender.tag==400){
        if ([self.MaskAnimationLabel.text containsString:getLanguage(@"关闭")]) {
            self.MaskAnimationLabel.text=getLanguage(@"开启特效");
            self.MaskAnimationImgView.image = KGetImage(@"AnimationImg");
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kIsOpenRoomGiftAnimation];
        }else{
            self.MaskAnimationLabel.text=getLanguage(@"关闭特效");
            self.MaskAnimationImgView.image = KGetImage(@"AnimationCloseImg");
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kIsOpenRoomGiftAnimation];
        }
       
    }
    if(self.BtnClick){
        self.BtnClick(sender.tag);
    }
    
    [self removeFromSuperview];
}

- (void)setIsMe:(BOOL)isMe
{
    self.closeRoomBtn.hidden = isMe;
    self.closeRoomLabel.hidden = isMe;
    self.closeRoomImgView.hidden = isMe;
    self.reportRoomBtn.hidden = isMe;
    self.reportRoomLabel.hidden = isMe;
    self.reportRoomImgView.hidden = isMe;
}

@end
