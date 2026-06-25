//
//  EMO_RoomHostView.m
//  miliao
//
//  Created by aa on 2019/6/14.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "EMO_RoomHostView.h"

#import "EMO_RoomHostUserView.h"

#import "MLRoomMSequenceModel.h"
#import "MLRoomMessageModel.h"
#import "BAButton.h"
#import "NSString+Size.h"
@interface EMO_RoomHostView ()

@property (nonatomic, strong) UIImageView    *hostIcon;//房主头像
@property (nonatomic, strong) UIImageView    *hostType;//麦位类型,闭麦,锁麦
//@property (nonatomic, strong) UIImageView    *hostLeave;//
@property (nonatomic, strong) UILabel        *hostName;//房主名字
@property(nonatomic, strong) UIButton  *meiliBtn;//魅力值
//@property (nonatomic, strong) UIImageView    *hostClose;
@property (nonatomic, strong) UIView                *hostBgView;
@property (nonatomic, strong) XLKWavePulsLayer      *hostWaveLayer;
@property (nonatomic, strong) NSTimer               *hostTimer;
@property (nonatomic, assign) int                   hostWaiTime;
@property (nonatomic, assign) CGFloat               hostT_length;
@property (nonatomic, strong) UIImageView           *hostExpreImage;
@property (nonatomic, strong) UIImageView           *hostIconBox;

@property (strong, nonatomic) EMO_RoomHostUserView   *roomHostView1;
@property (nonatomic, strong)        NSTimer        *timer1;
@property (nonatomic, assign) int                   waiTime1;
@property (nonatomic, assign) CGFloat               t_length1;


@property (strong, nonatomic) EMO_RoomHostUserView   *roomHostView2;
@property (nonatomic, strong) NSTimer               *timer2;
@property (nonatomic, assign) int                   waiTime2;
@property (nonatomic, assign) CGFloat               t_length2;


@property (strong, nonatomic) EMO_RoomHostUserView   *roomHostView3;
@property (nonatomic, strong) NSTimer               *timer3;
@property (nonatomic, assign) int                   waiTime3;
@property (nonatomic, assign) CGFloat               t_length3;


@property (strong, nonatomic) EMO_RoomHostUserView   *roomHostView4;
@property (nonatomic, strong) NSTimer               *timer4;
@property (nonatomic, assign) int                   waiTime4;
@property (nonatomic, assign) CGFloat               t_length4;


@property (strong, nonatomic)  EMO_RoomHostUserView   *roomHostView5;
@property (nonatomic, strong) NSTimer               *timer5;
@property (nonatomic, assign) int                   waiTime5;
@property (nonatomic, assign) CGFloat               t_length5;


@property (strong, nonatomic)  EMO_RoomHostUserView   *roomHostView6;
@property (nonatomic, strong) NSTimer               *timer6;
@property (nonatomic, assign) int                   waiTime6;
@property (nonatomic, assign) CGFloat               t_length6;


@property (strong, nonatomic)  EMO_RoomHostUserView   *roomHostView7;
@property (nonatomic, strong) NSTimer               *timer7;
@property (nonatomic, assign) int                   waiTime7;
@property (nonatomic, assign) CGFloat               t_length7;

@property (strong, nonatomic) EMO_RoomHostUserView *roomHostView8;
@property (nonatomic, strong) NSTimer               *timer8;
@property (nonatomic, assign) int                   waiTime8;
@property (nonatomic, assign) CGFloat               t_length8;

@property (weak, nonatomic) IBOutlet UIStackView *stackView1;
@property (weak, nonatomic) IBOutlet UIStackView *stackView2;

@property (nonatomic, strong) NSArray               *roomHostViews;
///排行榜
@property(nonatomic, strong) UIButton *jiangbeiView;
/////活力
//@property(nonatomic, strong) UIButton *huoLiBtn;
///房间公告
@property(nonatomic, strong) UIButton *noticeBtn;
//在线人数
@property(nonatomic, strong) UIView *peopleNumView;
@property(nonatomic, strong) UIButton *peopleNumBtn;

@end

@implementation EMO_RoomHostView

//- (UIButton *)musicBtn{
//    if (!_musicBtn) {
//        _musicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_musicBtn setImage:[UIImage imageNamed:@"musicImg"] forState:UIControlStateNormal];
//        [_musicBtn setTitle:getLanguage(@" 音乐") forState:UIControlStateNormal];
//        _musicBtn.titleLabel.font=KFont(12);
//        _musicBtn.layer.contents = (id) KGetImage(@"hotBgImg").CGImage;    // 如果需要背景透明加上下面这句
//        _musicBtn.layer.backgroundColor = [UIColor clearColor].CGColor;
//        _musicBtn.tag=666;
//        [_musicBtn addTarget:self action:@selector(musicClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_musicBtn];
//        [_musicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(70), KAdaptedHeight(25)));
//            make.top.mas_equalTo(KAdaptedHeight(10));
//            make.trailing.mas_equalTo(KAdaptedWidth(-15));
//
//        }];
//    }
//    return _musicBtn;
//}
//
//
- (UIButton *)jiangbeiView{
    if (!_jiangbeiView) {
        _jiangbeiView = [UIButton buttonWithType:UIButtonTypeCustom];
        _jiangbeiView.frame = CGRectMake(15, 10, 90, 24);
//        [_jiangbeiView setBackgroundImage:KGetImage(@"noticeBgIconImg") forState:UIControlStateNormal];
        [_jiangbeiView setTitle:getLanguage(@"排行榜") forState:UIControlStateNormal];
        [_jiangbeiView setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _jiangbeiView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _jiangbeiView.clipsToBounds = YES;
        _jiangbeiView.layer.cornerRadius = 12;
        _jiangbeiView.titleLabel.font = KFontA(11);
        [_jiangbeiView setImage:ImageNamed(@"rankingListImg") forState:UIControlStateNormal];
        _jiangbeiView.ba_padding = 3;
        _jiangbeiView.ba_buttonLayoutType = BAKit_ButtonLayoutTypeNormal;
        [_jiangbeiView addTarget:self action:@selector(handleJiangBeiClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jiangbeiView;
}

- (UIButton *)noticeBtn{
    if (!_noticeBtn) {
        _noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _noticeBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _noticeBtn.frame = CGRectMake(kWidth-55-15, 10, 55, 24);
        [_noticeBtn setTitle:getLanguage(@" 公告") forState:UIControlStateNormal];
        [_noticeBtn setTitleColor:RGBA(204, 219, 237, 1) forState:UIControlStateNormal];
//        [_noticeBtn setBackgroundImage:KGetImage(@"noticeBgIconImg") forState:UIControlStateNormal];
        _noticeBtn.clipsToBounds = YES;
        _noticeBtn.layer.cornerRadius = 12;
        _noticeBtn.titleLabel.font = KFontA(11);
        [_noticeBtn setImage:ImageNamed(@"noticeIconImg") forState:UIControlStateNormal];
        _noticeBtn.ba_padding = 3;
        _noticeBtn.ba_buttonLayoutType = BAKit_ButtonLayoutTypeNormal;
        [_noticeBtn addTarget:self action:@selector(handleNoticeClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noticeBtn;
}

- (UIView *)peopleNumView{
    if (!_peopleNumView) {
        _peopleNumView = [[UIView alloc] init];
        _peopleNumView.backgroundColor =kClearColor;
        [self addSubview:_peopleNumView];
        [_peopleNumView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-20));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(80), KAdaptedHeight(30)));
            make.top.mas_equalTo(KAdaptedHeight(50));
        }];
    }
    return _peopleNumView;
}

- (UIButton *)peopleNumBtn{
    if (!_peopleNumBtn) {
        _peopleNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_peopleNumBtn addTarget:self action:@selector(peopleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_peopleNumBtn];
        [_peopleNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.leading.bottom.trailing.mas_equalTo(0);
            make.top.mas_equalTo(self.peopleNumView.mas_top);
            make.leading.mas_equalTo(self.peopleNumView.mas_leading);
            make.trailing.mas_equalTo(self.peopleNumView.mas_trailing);
            make.bottom.mas_equalTo(self.peopleNumView.mas_bottom);
        }];
        
        UIButton *btn=[[UIButton alloc] init];
        [btn setImage:KGetImage(@"peopleNumIconImg") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(peopleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_peopleNumBtn addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(KAdaptedHeight(20));
        }];
    }
    return _peopleNumBtn;
}

-(void)musicClick{
    //音乐
    if (self.muscianBlock) {
        self.muscianBlock();
    }
}

- (void)handleJiangBeiClickEvent:(UIButton *)sender {
    //排行榜
    if (self.paiHangBangBlock) {
        self.paiHangBangBlock();
    }
}
///公告
- (void)handleNoticeClickEvent:(UIButton *)sender {
    if (self.noticeBlock) {
        self.noticeBlock();
    }
}
//在线人数
-(void)peopleBtnClick{
    if (self.peopleNumBlock) {
        self.peopleNumBlock();
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    ///主播麦位
    UIView *container = [[UIView alloc] init];
    [self addSubview:container];
    
    self.hostIcon = [[UIImageView alloc] init];
    self.hostIcon.backgroundColor = [UIColor clearColor];
    self.hostIcon.userInteractionEnabled = YES;
    [container addSubview:self.hostIcon];
    
    self.hostType = [[UIImageView alloc] init];
    self.hostType.backgroundColor = [UIColor clearColor];
    self.hostType.userInteractionEnabled = YES;
    [container addSubview:self.hostType];
    
    self.headIconImg = [[UIImageView alloc] init];
    self.headIconImg.backgroundColor = [UIColor clearColor];
    self.headIconImg.userInteractionEnabled = YES;
//    self.headIconImg.autoPlay = YES;
    [container addSubview:self.headIconImg];
    
    self.headSvgaImg=[[SVGAImageView alloc]init];
    self.headSvgaImg.contentMode=UIViewContentModeScaleToFill;
    self.headSvgaImg.autoPlay=YES;
    [container addSubview:self.headSvgaImg];
    
    ///主播名字
    self.hostName = [[UILabel alloc] init];
    self.hostName.textColor = [UIColor whiteColor];
    self.hostName.font = FONT_14;
    self.hostName.textAlignment = NSTextAlignmentCenter;
    [container addSubview:self.hostName];
   
    self.meiliBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.meiliBtn setBackgroundImage:KGetImage(@"roomMeiLiBgImg") forState:UIControlStateNormal];
    [self.meiliBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.meiliBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.meiliBtn.layer.cornerRadius = KAdaptedHeight(15)/2;
    self.meiliBtn.clipsToBounds = YES;
    self.meiliBtn.titleLabel.font = FONT_10;
    [self.meiliBtn setTitle:[self getDealNumwithstring:[MLRoomInformationModel currentAccount].meili] forState:UIControlStateNormal];
    
    
    
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(KAdaptedHeight(20));
        make.width.equalTo(@90);
        make.height.equalTo(@100);
    }];
    
    [self.hostIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).offset(12.5);
        make.top.equalTo(container).offset(8);
        make.right.equalTo(container).offset(-12.5);
        make.height.equalTo(self.hostIcon.mas_width);
    }];
    
    [self.hostType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).offset(12.5);
        make.top.equalTo(container).offset(8);
        make.right.equalTo(container).offset(-12.5);
        make.height.equalTo(self.hostIcon.mas_width);
    }];
    
    
    [self.headIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.hostIcon.mas_centerX);
        make.centerY.equalTo(self.hostIcon.mas_centerY);
        make.width.equalTo(self.hostIcon.mas_width).multipliedBy(1.2);
        make.height.equalTo(self.hostIcon.mas_height).multipliedBy(1.2);
    }];
    
    [self.headSvgaImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.hostIcon.mas_centerX);
        make.centerY.equalTo(self.hostIcon.mas_centerY);
        make.width.equalTo(self.hostIcon.mas_width).multipliedBy(1.2);
        make.height.equalTo(self.hostIcon.mas_height).multipliedBy(1.2);
        
    }];
    
    [self.hostName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.hostIcon);
//        make.top.equalTo(self.meiliBtn.mas_bottom).offset(5);
        make.top.equalTo(self.hostIcon.mas_bottom).offset(23);
        make.height.equalTo(@14);
    }];
    
//    [self.hostLeave mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.hostName);
//        make.right.equalTo(self.hostName.mas_left).offset(-5);
//        make.width.equalTo(@14);
////        make.width.equalTo(@30);
//        make.height.equalTo(@14);
//    }];
//
//    [self layoutIfNeeded];
//    [self.hostClose mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(13, 13));
//        make.centerX.equalTo(self.hostIcon).offset(sin(M_PI*45/180)*self.hostIcon.width/2.0);
//        make.centerY.equalTo(self.hostIcon).offset(sin(M_PI*45/180)*self.hostIcon.width/2.0);
//    }];
    
    [self.hostIcon sd_setImageWithURL:[NSURL URLWithString:[MLRoomInformationModel currentAccount].avatar]];
    
    if ([[MLRoomInformationModel currentAccount].avatar_frame_svga_file hasSuffix:@".svga"]||[[MLRoomInformationModel currentAccount].avatar_frame_svga_file hasSuffix:@".SVGA"]) {
        self.headSvgaImg.imageName=[MLRoomInformationModel currentAccount].avatar_frame_svga_file;
    }else{
        [self.headIconImg sd_setImageWithURL:[NSURL URLWithString:[MLRoomInformationModel currentAccount].avatar_frame_image]];
    }
    
//    self.headIconImg.imageName = [Common isNull:[MLRoomInformationModel currentAccount].zb_img];
    
    self.hostName.text = [MLRoomInformationModel currentAccount].nickname;
    self.hostIcon.userInteractionEnabled = YES;
    setViewCorner(self.hostIcon, (90-25)/2);
    setViewBorderAndColor(self.hostIcon, 1, kColorMain.CGColor);
//    if ([[MLRoomInformationModel currentAccount].uid_sound integerValue] == 1) {
//        self.hostClose.hidden = YES;
//    }else{
//        self.hostClose.hidden = NO;
//    }

    [self.hostIconBox sd_setImageWithURL:[NSURL URLWithString:[MLRoomInformationModel currentAccount].txk]];
    self.hostBgView.userInteractionEnabled = YES;
    [self addSubview:self.hostBgView];
    [self bringSubviewToFront:self.hostIcon];
//    [self bringSubviewToFront:self.hostLeave];
    [self.hostBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.hostIcon.mas_centerX);
        make.centerY.mas_equalTo(self.hostIcon.mas_centerY);
        make.height.mas_equalTo(self.hostIcon);
        make.width.mas_equalTo(self.hostIcon);
    }];
    [self.hostBgView.layer addSublayer:self.hostWaveLayer];
    [self sendSubviewToBack:self.hostBgView];
    self.hostWaveLayer.backgroundColor =RGBA(255, 255, 255, 1).CGColor;
//    self.hostWaveLayer.backgroundColor = MHColorFromHexString([MLRoomInformationModel currentAccount].mic_color).CGColor;
    [self.hostWaveLayer start];
    
    [self addSubview:self.hostIconBox];
    [self.hostIconBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hostIcon).offset(-8);
        make.bottom.mas_equalTo(self.hostIcon).offset(8);
        make.left.mas_equalTo(self.hostIcon).offset(-8);
        make.right.mas_equalTo(self.hostIcon).offset(8);
    }];
    [self addSubview:self.hostExpreImage];
    [self.hostExpreImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hostIcon).offset(-5);
        make.bottom.mas_equalTo(self.hostIcon).offset(5);
        make.left.mas_equalTo(self.hostIcon).offset(-5);
        make.right.mas_equalTo(self.hostIcon).offset(5);
    }];
    
    self.hostExpreImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
    [self.hostExpreImage addGestureRecognizer:singleTap];

     [self addSubview:self.meiliBtn];
     [self bringSubviewToFront:self.meiliBtn];
    
    [self.meiliBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hostIcon.mas_bottom).offset(3);
        make.centerX.mas_equalTo(self.hostIcon);
        make.height.mas_equalTo(KAdaptedHeight(15));
    }];
    
    self.stackView1.axis = UILayoutConstraintAxisHorizontal;
    self.stackView1.distribution = UIStackViewDistributionFillEqually;
    self.stackView1.spacing = 0;
    self.stackView1.alignment = UIStackViewAlignmentFill;
    
    [self.stackView1 addArrangedSubview:self.roomHostView1];
    [self.stackView1 addArrangedSubview:self.roomHostView2];
    [self.stackView1 addArrangedSubview:self.roomHostView3];
    [self.stackView1 addArrangedSubview:self.roomHostView4];
    
    self.stackView2.axis = UILayoutConstraintAxisHorizontal;
    self.stackView2.distribution = UIStackViewDistributionFillEqually;
    self.stackView2.spacing = 0;
    self.stackView2.alignment = UIStackViewAlignmentFill;
    
    [self.stackView2 addArrangedSubview:self.roomHostView5];
    [self.stackView2 addArrangedSubview:self.roomHostView6];
    [self.stackView2 addArrangedSubview:self.roomHostView7];
    [self.stackView2 addArrangedSubview:self.roomHostView8];
    
    [self.stackView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@102);
        make.bottom.equalTo(self.stackView2.mas_top);
    }];
    
    [self.stackView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stackView1.mas_bottom);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@102);
        make.bottom.equalTo(self);
    }];
    
    [self layoutIfNeeded];
    [self.roomHostViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EMO_RoomHostUserView *roomHostView = obj;
        roomHostView.hostIcon.layer.cornerRadius = CGRectGetWidth(roomHostView.hostIcon.frame)/2.0;
        roomHostView.hostIcon.layer.masksToBounds = YES;
        roomHostView.hostIcon.layer.borderWidth = 2.f;
        roomHostView.hostIcon.layer.borderColor = [UIColor clearColor].CGColor;
        roomHostView.tag = idx + 1;
        roomHostView.closeIcon.hidden = YES;
        
        UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [roomHostView addGestureRecognizer:singleTap2];
    }];
    
//    ///活力值
//    [self addSubview:self.huoLiBtn];
    ///公告
    [self addSubview:self.noticeBtn];
    ///排行榜
    [self addSubview:self.jiangbeiView];
    
    /////音乐
//    [self addSubview:self.musicBtn];
    
    
    [self peopleNumView];
//    if ([[MLRoomInformationModel currentAccount].user_type integerValue] == 1||[[MLRoomInformationModel currentAccount].user_type integerValue] ==2) {
//        self.musicBtn.hidden=NO;
//    }else{
//        self.musicBtn.hidden=YES;
//    }
    
 
    [self peopleNumBtn];
    
    
    
    
    
}

-(void)setOnlineUserArray:(NSMutableArray *)onlineUserArray{
    _onlineUserArray=onlineUserArray;
    [self.peopleNumView removeAllSubviews];    
    for (int i=0; i<(onlineUserArray.count>3?3:onlineUserArray.count); i++) {
        UIImageView *imageView=[[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",onlineUserArray[i][@"avatar"]]]placeholderImage:KGetImage(@"list2")];
        imageView.layer.borderColor=kWhiteColor.CGColor;
        imageView.layer.borderWidth=1;
        [self.peopleNumView addSubview:imageView];
        [self.peopleNumView sendSubviewToBack:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(14)*i);
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(KAdaptedWidth(20));
            
        }];
        setViewCorner(imageView, KAdaptedWidth(20)/2);
    }
    
    
    
}



- (NSString *)getDealNumwithstring:(NSString *)string{
    if (string.length==0||[string isEqualToString:@"0"]) {
        return @"0";
    }
    if (string.length<5) {
        return string;
    }
    NSNumber *number = @([string floatValue]/10000);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###0.0"];
    formatter.roundingMode = NSNumberFormatterRoundDown;
    formatter.maximumFractionDigits = 1;
    NSLog(@"%@", [formatter stringFromNumber:number]);
    return [NSString stringWithFormat:@"%@w",[formatter stringFromNumber:number]];
}
/**
 * MARK: 查看用户信息
 */
- (void)singleTapGesture:(UITapGestureRecognizer *)tap{
    
    EMO_RoomHostUserView *roomHostView = (EMO_RoomHostUserView *)tap.view;
    !self.roomHostViewClickBlock ?: self.roomHostViewClickBlock(roomHostView.tag);
}
- (void)setSequenceArray:(NSArray *)sequenceArray{
    _sequenceArray = sequenceArray;
    MLRoomMSequenceModel *mode=sequenceArray[0];
    if([mode.status integerValue]==2){
        if ([mode.avatar_frame_svga_file hasSuffix:@".svga"]||[mode.avatar_frame_svga_file hasSuffix:@".SVGA"]) {
            self.headSvgaImg.imageName=mode.avatar_frame_svga_file;
        }else{
            [self.headIconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",mode.avatar_frame_image]]];
        }
        self.headSvgaImg.hidden=NO;
        self.headIconImg.hidden=NO;
        self.meiliBtn.hidden=NO;
        self.hostType.image=KGetImage(@"");
        if([mode.type integerValue] == 1){
            self.hostType.image = [UIImage imageNamed:@"closeMaiImg"];
        }
        self.hostWaveLayer.hidden=NO;
    }
    else{
        self.hostWaveLayer.hidden=YES;
        self.headSvgaImg.hidden=YES;
        self.headIconImg.hidden=YES;
        self.meiliBtn.hidden=YES;
        if([mode.status integerValue]==1){
            self.hostType.image = [UIImage imageNamed:@"fengBiMaiImg"];
        }else{
            self.hostType.image = [UIImage imageNamed:@"shangMaiImg1"];
        }
        if([mode.type integerValue] == 1){
            self.hostType.image = [UIImage imageNamed:@"closeMaiImg"];
        }
    }
    
    [self.hostIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",mode.avatar]]];
    self.hostName.text=[Common isNull:mode.nickname];;
    [self.meiliBtn setTitle:[Common isNull:mode.user_charm] forState:UIControlStateNormal];
    [self.roomHostViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EMO_RoomHostUserView *roomHostView = (EMO_RoomHostUserView *)obj;
            roomHostView.backgroundColor = UIColor.clearColor;
            MLRoomMSequenceModel *model = sequenceArray[idx+1];
            //状态时2，表示麦位有人，否则没人
            //        [roomHostView.bottomLabel setTitle:model.meili forState:UIControlStateNormal];
            
            //        if ([model.meili integerValue]>1000) {
            //            [roomHostView.bottomLabel setTitle:[NSString stringWithFormat:@"%ldk",[model.meili integerValue]/1000] forState:UIControlStateNormal];
            //        }
        //status;//0空麦1锁麦2麦上有人
            if ([model.status integerValue] == 2) {
                roomHostView.headIconImg.hidden=NO;
                roomHostView.bottomLabel.hidden = NO;
                
                roomHostView.meiLiString = model.user_charm;
                [roomHostView.hostIcon sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
                if ([model.avatar_frame_svga_file hasSuffix:@".svga"]||[model.avatar_frame_svga_file hasSuffix:@".SVGA"]) {
                    roomHostView.headSvgaImg.hidden=NO;
                    roomHostView.headSvgaImg.imageName=model.avatar_frame_svga_file;
                }else{
                    [roomHostView.headIconImg sd_setImageWithURL:[NSURL URLWithString:model.avatar_frame_image]];
                }
                roomHostView.bgView.hidden = NO;
    //            设置魅力等级
                roomHostView.hostName.text = [NSString stringWithFormat:@" %@",model.nickname];
                if ([model.type intValue] ==0) {
                    roomHostView.closeIcon.hidden = YES;
                    roomHostView.bgView.hidden = NO;
                }else{
                    roomHostView.closeIcon.hidden = NO;
                    roomHostView.bgView.hidden = YES;
                }
                
                roomHostView.waveLayer.backgroundColor =kWhiteColor.CGColor;
                roomHostView.hostIconBox.hidden = NO;
    //            [roomHostView.hostIconBox sd_setImageWithURL:[NSURL URLWithString:model.txk]];
                
                [roomHostView.hostName mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(18);
                }];
                [roomHostView.hostName layoutIfNeeded];
                
            }else if ([model.status integerValue] == 1){//
                roomHostView.headSvgaImg.hidden=YES;
                roomHostView.headIconImg.hidden=YES;
                roomHostView.bottomLabel.hidden = YES;
                
                roomHostView.meiLiString = @"0";
                roomHostView.genderIcon.image = [UIImage imageNamed:@"room_xuhao_weizhi"];
                roomHostView.hostIcon.image = [UIImage imageNamed:@"fengBiMaiImg"];
                roomHostView.headIconImg.image = [UIImage imageNamed:@""];
                if(idx==0){
                    roomHostView.hostName.text=getLanguage(@"老板麦");
                }else{
                    roomHostView.hostName.text = [NSString stringWithFormat:@"%ld号麦",idx+1];
                }
//                roomHostView.hostName.text = [NSString stringWithFormat:@"%ld",idx+1];
        
                roomHostView.hostIcon.layer.borderColor = [UIColor clearColor].CGColor;
                roomHostView.closeIcon.hidden = YES;
                roomHostView.hostIconBox.hidden = YES;
                roomHostView.bgView.hidden = YES;
                [roomHostView.hostName mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(10);
                }];
                [roomHostView.hostName layoutIfNeeded];
            }else{
                //0空麦
                roomHostView.headSvgaImg.hidden=YES;
                roomHostView.headIconImg.hidden=YES;
                roomHostView.bottomLabel.hidden = YES;
                roomHostView.meiLiString = @"0";
                roomHostView.bottomLabel.hidden = YES;
                roomHostView.headIconImg.image = [UIImage imageNamed:@""];
                roomHostView.genderIcon.image = [UIImage imageNamed:@"room_xuhao_weizhi"];
                if(idx==0){
                    roomHostView.hostIcon.image = [UIImage imageNamed:@"shangMaiImg2"];
                    roomHostView.hostName.text=getLanguage(@"老板麦");
                }else{
                    roomHostView.hostIcon.image = [UIImage imageNamed:@"shangMaiImg1"];
                    roomHostView.hostName.text = [NSString stringWithFormat:@"%ld号麦",idx+1];
                }
                if([model.type integerValue] == 1){
                    roomHostView.hostIcon.image = [UIImage imageNamed:@"closeMaiImg"];
                }
                
//                roomHostView.hostName.text = [NSString stringWithFormat:@"%ld",idx+1];
                roomHostView.hostIcon.layer.borderColor = [UIColor clearColor].CGColor;
                roomHostView.closeIcon.hidden = YES;
                roomHostView.bgView.hidden = YES;
                roomHostView.hostIconBox.hidden = YES;
            }
            [roomHostView.hostName mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
            }];
            [roomHostView.hostName layoutIfNeeded];
    }];
    [self.hostBgView.layer addSublayer:self.hostWaveLayer];
    [self.hostWaveLayer start];
}
/////活力值
//- (void)setHuoliStr:(NSString *)huoliStr{
//    _huoliStr = huoliStr;
////    [self.huoLiBtn setTitle:[Common isNullNumber:huoliStr] forState:UIControlStateNormal];
//}

/////魅力值
//- (void)setMeiliStr:(NSString *)meiliStr{
//    _meiliStr = meiliStr;
//   float width =  [Common getStringWidthWithText:meiliStr font:FONT_10 viewHeight:20];
//    [self.meiliBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        if (width<50) {
//            make.width.mas_offset(50);
//        }else{
//            make.width.mas_offset(width+13);
//        }
//
//    }];
//    [self.meiliBtn setTitle:[NSString stringWithFormat:@" %@",meiliStr] forState:UIControlStateNormal];
//}

- (void)setWaveLayerToView{
    [self.roomHostView1.bgView.layer addSublayer:self.roomHostView1.waveLayer];
    [self.roomHostView1.waveLayer start];
    [self.roomHostView2.bgView.layer addSublayer:self.roomHostView2.waveLayer];
    [self.roomHostView2.waveLayer start];
    [self.roomHostView3.bgView.layer addSublayer:self.roomHostView3.waveLayer];
    [self.roomHostView3.waveLayer start];
    [self.roomHostView4.bgView.layer addSublayer:self.roomHostView4.waveLayer];
    [self.roomHostView4.waveLayer start];
    [self.roomHostView5.bgView.layer addSublayer:self.roomHostView5.waveLayer];
    [self.roomHostView5.waveLayer start];
    [self.roomHostView6.bgView.layer addSublayer:self.roomHostView6.waveLayer];
    [self.roomHostView6.waveLayer start];
    [self.roomHostView7.bgView.layer addSublayer:self.roomHostView7.waveLayer];
    [self.roomHostView7.waveLayer start];
    [self.roomHostView8.bgView.layer addSublayer:self.roomHostView8.waveLayer];
    [self.roomHostView8.waveLayer start];
    
    self.hostBgView.hidden = NO;
    [self.hostBgView.layer addSublayer:self.hostWaveLayer];
    [self.hostWaveLayer start];
}

- (void)setWaveLayerWithUid:(NSUInteger )uid open:(BOOL)volume sequenceArray:(NSArray *)sequenceArray{
    [self.roomHostViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EMO_RoomHostUserView *roomHostView = (EMO_RoomHostUserView *)obj;
        MLRoomMSequenceModel *model = sequenceArray[idx+1];
        
        if ([model.uid integerValue] == uid) {
            roomHostView.waveLayer.radius = 0;
        }
    }];
    
    //    MLRoomMSequenceModel *model = _sequenceArray[7];
    //
    //    if ([model.user_id integerValue] == uid) {
    //        self.managemenWaveLayer.radius = 0;
    //    }
    if ([[MLRoomInformationModel currentAccount].uuid integerValue] == uid) {
        self.hostWaveLayer.radius = 0;
    }
}
- (void)hostLeaveClick{
//    if ([[MLRoomInformationModel currentAccount].is_afk isEqualToString:@"1"]) {
//        self.hostLeave.hidden = NO;
//    }else{
//        self.hostLeave.hidden = YES;
//    }
}

- (void)setWaveLayerWithUid:(NSUInteger )uid volume:(NSUInteger )volume sequenceArray:(NSArray *)sequenceArray{
    NSInteger count = sequenceArray.count;
    
    MLRoomMSequenceModel *model1 = count>0? sequenceArray[0] : nil;
    if ([model1.uid integerValue] == uid) {
        if (volume == 0) {
            self.roomHostView1.waveLayer.radius = 0;
        }else{
            self.roomHostView1.waveLayer.radius = self.roomHostView1.width / 2 + volume/25.5 - 4;
        }
    }
    MLRoomMSequenceModel *model2 = count>1? sequenceArray[1] : nil;
    if ([model2.uid integerValue] == uid) {
        if (volume == 0) {
            self.roomHostView2.waveLayer.radius = 0;
        }else{
            self.roomHostView2.waveLayer.radius = self.roomHostView2.width / 2 + volume/25.5 - 4;
        }
    }
    MLRoomMSequenceModel *model3 = count>2? sequenceArray[2] : nil;
    if ([model3.uid integerValue] == uid) {
        if (volume == 0) {
            self.roomHostView3.waveLayer.radius = 0;
        }else{
            self.roomHostView3.waveLayer.radius = self.roomHostView3.width / 2 + volume/25.5 - 4;
        }
    }
    MLRoomMSequenceModel *model4 = count>3? sequenceArray[3] : nil;
    if ([model4.uid integerValue] == uid) {
        if (volume == 0) {
            self.roomHostView4.waveLayer.radius = 0;
        }else{
            self.roomHostView4.waveLayer.radius = self.roomHostView4.width / 2 + volume/25.5 - 4;
        }
    }
    MLRoomMSequenceModel *model5 = count>4? sequenceArray[4] : nil;
    if ([model5.uid integerValue] == uid) {
        if (volume == 0) {
            self.roomHostView5.waveLayer.radius = 0;
        }else{
            self.roomHostView5.waveLayer.radius = self.roomHostView5.width / 2 + volume/25.5 - 4;
        }
    }
    MLRoomMSequenceModel *model6 = count>5? sequenceArray[5] : nil;
    if ([model6.uid integerValue] == uid) {
        if (volume == 0) {
            self.roomHostView6.waveLayer.radius = 0;
        }else{
            self.roomHostView6.waveLayer.radius = self.roomHostView6.width / 2 + volume/25.5 - 4;
        }
    }
    MLRoomMSequenceModel *model7 = count>6? sequenceArray[6] : nil;
    if ([model7.uid integerValue] == uid) {
        if (volume == 0) {
            self.roomHostView7.waveLayer.radius = 0;
        }else{
            self.roomHostView7.waveLayer.radius = self.roomHostView7.width / 2 + volume/25.5 - 4;
        }
    }
    
    MLRoomMSequenceModel *model = count>7? sequenceArray[7] : nil;
    
    if ([model.uid integerValue] == uid)
    {
        if (volume == 0) {
            self.roomHostView8.waveLayer.radius = 0;
        }else{
            self.roomHostView8.waveLayer.radius = self.roomHostView8.width / 2 + volume/25.5 - 4;
        }
    }
    //    {
    //        if (volume == 0) {
    //            self.managemenWaveLayer.radius = 0;
    //        }else{
    //            self.managemenWaveLayer.radius = self.managementIcon.width / 2 + volume/25.5 + 6;
    //        }
    //    }
    if ([[MLRoomInformationModel currentAccount].uuid integerValue] == uid) {
        if (volume == 0) {
            self.hostWaveLayer.radius = 0;
        }else{
            self.hostWaveLayer.radius = self.hostIcon.width / 2 + volume/25.5 + 6;
        }
    }
}


- (CGRect )hostFrameWithUserID:(NSString *)userID idx:(NSInteger )idx{
    if ([userID integerValue] == [[MLRoomInformationModel currentAccount].uuid integerValue]) {
        return self.hostIcon.frame;
    }
    switch (idx) {
        case 0:
            return self.roomHostView1.frame;
            break;
        case 1:
            return self.roomHostView2.frame;
            break;
        case 2:
            return self.roomHostView3.frame;
            break;
        case 3:
            return self.roomHostView4.frame;
            break;
        case 4:
            return self.roomHostView5.frame;
            break;
        case 5:
            return self.roomHostView6.frame;
            break;
        case 6:
            return self.roomHostView7.frame;
            break;
        case 7:
            return self.roomHostView8.frame;
            //            return self.managementIcon.frame;
            break;
        default:
            break;
    }
    
    return self.hostIcon.frame;;
}

// 发送表情
- (void)shouEmojiToIcon:(MLRoomMessageModel *)model{
    
    MLRoomMSequenceModel *model1 = _sequenceArray[0];
    if ([model1.uid integerValue] == [model.user_id integerValue]) {
        [self.roomHostView1.expreImage sd_setImageWithURL:[NSURL URLWithString:model.emoji]];
        self.roomHostView1.expreImage.hidden = NO;
        [self.timer1 invalidate];
        self.waiTime1 = 0;
        self.t_length1 = [model.t_length floatValue];
        self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(updateWaitTime1)
                                                     userInfo:nil
                                                      repeats:YES];
    }
    MLRoomMSequenceModel *model2 = _sequenceArray[1];
    if ([model2.uid integerValue] == [model.user_id integerValue]) {
        [self.roomHostView2.expreImage sd_setImageWithURL:[NSURL URLWithString:model.emoji]];
        self.roomHostView2.expreImage.hidden = NO;
        [self.timer2 invalidate];
        self.waiTime2 = 0;
        self.t_length2 = [model.t_length floatValue];
        self.timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(updateWaitTime2)
                                                     userInfo:nil
                                                      repeats:YES];
    }
    MLRoomMSequenceModel *model3 = _sequenceArray[2];
    if ([model3.uid integerValue] == [model.user_id integerValue]) {
        [self.roomHostView3.expreImage sd_setImageWithURL:[NSURL URLWithString:model.emoji]];
        self.roomHostView3.expreImage.hidden = NO;
        [self.timer3 invalidate];
        self.waiTime3 = 0;
        self.t_length3 = [model.t_length floatValue];
        self.timer3 = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(updateWaitTime3)
                                                     userInfo:nil
                                                      repeats:YES];
    }
    MLRoomMSequenceModel *model4 = _sequenceArray[3];
    if ([model4.uid integerValue] == [model.user_id integerValue]) {
        [self.roomHostView4.expreImage sd_setImageWithURL:[NSURL URLWithString:model.emoji]];
        self.roomHostView4.expreImage.hidden = NO;
        [self.timer4 invalidate];
        self.waiTime4 = 0;
        self.t_length4 = [model.t_length floatValue];
        self.timer4 = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(updateWaitTime4)
                                                     userInfo:nil
                                                      repeats:YES];
    }
    MLRoomMSequenceModel *model5 = _sequenceArray[4];
    if ([model5.uid integerValue] == [model.user_id integerValue]) {
        [self.roomHostView5.expreImage sd_setImageWithURL:[NSURL URLWithString:model.emoji]];
        self.roomHostView5.expreImage.hidden = NO;
        [self.timer5 invalidate];
        self.waiTime5 = 0;
        self.t_length5 = [model.t_length floatValue];
        self.timer5 = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(updateWaitTime5)
                                                     userInfo:nil
                                                      repeats:YES];
    }
    MLRoomMSequenceModel *model6 = _sequenceArray[5];
    if ([model6.uid integerValue] == [model.user_id integerValue]) {
        [self.roomHostView6.expreImage sd_setImageWithURL:[NSURL URLWithString:model.emoji]];
        self.roomHostView6.expreImage.hidden = NO;
        [self.timer6 invalidate];
        self.waiTime6 = 0;
        self.t_length6 = [model.t_length floatValue];
        self.timer6 = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(updateWaitTime6)
                                                     userInfo:nil
                                                      repeats:YES];
    }
    MLRoomMSequenceModel *model7 = _sequenceArray[6];
    if ([model7.uid integerValue] == [model.user_id integerValue]) {
        [self.roomHostView7.expreImage sd_setImageWithURL:[NSURL URLWithString:model.emoji]];
        self.roomHostView7.expreImage.hidden = NO;
        [self.timer7 invalidate];
        self.waiTime7 = 0;
        self.t_length7 = [model.t_length floatValue];
        self.timer7 = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(updateWaitTime7)
                                                     userInfo:nil
                                                      repeats:YES];
    }
    MLRoomMSequenceModel *model8 = _sequenceArray[7];
    if ([model8.uid integerValue] == [model.user_id integerValue]) {
        [self.roomHostView8.expreImage sd_setImageWithURL:[NSURL URLWithString:model.emoji]];
        self.roomHostView8.expreImage.hidden = NO;
        [self.timer8 invalidate];
        self.waiTime8 = 0;
        self.t_length8 = [model.t_length floatValue];
        self.timer8 = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(updateWaitTime8)
                                                     userInfo:nil
                                                      repeats:YES];
    }
    //    MLRoomMSequenceModel *model8 = _sequenceArray[7];
    //    if ([model8.user_id integerValue] == [model.user_id integerValue]) {
    //        [self.managemenExpreImage sd_setImageWithURL:[NSURL URLWithString:model.emoji]];
    //        self.managemenExpreImage.hidden = NO;
    //        [self.managemenTimer invalidate];
    //        self.managemenWaiTime = 0;
    //        self.managemenT_length = [model.t_length floatValue];
    //        self.managemenTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
    //                                                               target:self
    //                                                             selector:@selector(managemenUpdateWaitTime)
    //                                                             userInfo:nil
    //                                                              repeats:YES];
    //
    //    }
    if ([[MLRoomInformationModel currentAccount].uuid integerValue] == [model.user_id integerValue]) {
        [self.hostExpreImage sd_setImageWithURL:[NSURL URLWithString:model.emoji]];
        self.hostExpreImage.hidden = NO;
        [self.hostTimer invalidate];
        self.hostWaiTime = 0;
        self.hostT_length = [model.t_length floatValue];
        self.hostTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(hostUpdateWaitTime)
                                                        userInfo:nil
                                                         repeats:YES];
    }
}
#pragma mark--开始计时
- (void)updateWaitTime1 {
    
    self.waiTime1 ++;
    if (self.waiTime1 >= self.t_length1) {
        [self.timer1 invalidate];
        self.timer1 = nil;
        self.roomHostView1.expreImage.hidden = YES;
    }
}
- (void)updateWaitTime2 {
    
    self.waiTime2 ++;
    if (self.waiTime2 >= self.t_length2) {
        [self.timer2 invalidate];
        self.timer2 = nil;
        self.roomHostView2.expreImage.hidden = YES;
    }
}
- (void)updateWaitTime3 {
    
    self.waiTime3 ++;
    if (self.waiTime3 >= self.t_length3) {
        [self.timer3 invalidate];
        self.timer3 = nil;
        self.roomHostView3.expreImage.hidden = YES;
    }
}
- (void)updateWaitTime4 {
    
    self.waiTime4 ++;
    if (self.waiTime4 >= self.t_length4) {
        [self.timer4 invalidate];
        self.timer4 = nil;
        self.roomHostView4.expreImage.hidden = YES;
    }
}
- (void)updateWaitTime5 {
    
    self.waiTime5 ++;
    if (self.waiTime5 >= self.t_length5) {
        [self.timer5 invalidate];
        self.timer5 = nil;
        self.roomHostView5.expreImage.hidden = YES;
    }
}
- (void)updateWaitTime6 {
    
    self.waiTime6 ++;
    if (self.waiTime6 >= self.t_length6) {
        [self.timer6 invalidate];
        self.timer6 = nil;
        self.roomHostView6.expreImage.hidden = YES;
    }
}
- (void)updateWaitTime7 {
    
    self.waiTime7 ++;
    if (self.waiTime7 >= self.t_length7) {
        [self.timer7 invalidate];
        self.timer7 = nil;
        self.roomHostView7.expreImage.hidden = YES;
    }
}
- (void)updateWaitTime8 {
    
    self.waiTime8 ++;
    if (self.waiTime8 >= self.t_length8) {
        [self.timer8 invalidate];
        self.timer8 = nil;
        self.roomHostView8.expreImage.hidden = YES;
    }
}
//- (void)managemenUpdateWaitTime {
//
//    self.managemenWaiTime ++;
//    if (self.managemenWaiTime >= self.managemenT_length) {
//        [self.managemenTimer invalidate];
//        self.managemenTimer = nil;
//        self.managemenExpreImage.hidden = YES;
//    }
//}
- (void)hostUpdateWaitTime {
    
    self.hostWaiTime ++;
    if (self.hostWaiTime >= self.hostT_length) {
        [self.hostTimer invalidate];
        self.hostTimer = nil;
        self.hostExpreImage.hidden = YES;
    }
}

- (void)loadData:(id)obj{
    [super loadData:obj];
}
- (XLKWavePulsLayer *)hostWaveLayer{
    if (_hostWaveLayer == nil) {
        _hostWaveLayer = [XLKWavePulsLayer layer];
        _hostWaveLayer.animationDuration = 6;
        _hostWaveLayer.haloLayerNumber = 6;
        _hostWaveLayer.fromValueForAlpha = 0.6;
        _hostWaveLayer.fromValueForRadius = 0.5;
        _hostWaveLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _hostWaveLayer.radius = 0;
//        _hostWaveLayer.position = CGPointMake(self.hostIcon.width / 2, self.hostIcon.height / 2);
        _hostWaveLayer.position = CGPointMake(self.hostBgView.width+KAdaptedWidth(30), self.hostBgView.height+KAdaptedHeight(30));
    }
    return _hostWaveLayer;
}
- (UIView *)hostBgView{
    if (!_hostBgView) {
        _hostBgView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor clearColor]];
    }
    return _hostBgView;
}
//- (XLKWavePulsLayer *)managemenWaveLayer{
//    if (_managemenWaveLayer == nil) {
//        _managemenWaveLayer = [XLKWavePulsLayer layer];
//        _managemenWaveLayer.animationDuration = 6;
//        _managemenWaveLayer.haloLayerNumber = 6;
//        _managemenWaveLayer.fromValueForAlpha = 0.6;
//        _managemenWaveLayer.fromValueForRadius = 0.5;
//        _managemenWaveLayer.backgroundColor = [UIColor whiteColor].CGColor;
//        _managemenWaveLayer.radius = self.hostIcon.width / 2 + 3;
//        _managemenWaveLayer.position = CGPointMake(self.managementIcon.width / 2, self.managementIcon.height / 2);
//    }
//    return _managemenWaveLayer;
//
//}
- (UIImageView *)hostExpreImage{
    if (!_hostExpreImage) {
        _hostExpreImage = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"" backguoundColor:[UIColor clearColor]];
    }
    return _hostExpreImage;
}
//- (UIView *)managemenBgView{
//    if (!_managemenBgView) {
//        _managemenBgView = [ControlCreator createView:nil rect:CGRectZero backguoundColor:[UIColor clearColor]];
//    }
//    return _managemenBgView;
//}
- (NSArray *)roomHostViews{
    if (!_roomHostViews) {
        _roomHostViews = @[self.roomHostView1, self.roomHostView2, self.roomHostView3, self.roomHostView4, self.roomHostView5, self.roomHostView6, self.roomHostView7,self.roomHostView8];
    }
    return _roomHostViews;
}
//- (UIImageView *)managemenExpreImage{
//    if (!_managemenExpreImage) {
//        _managemenExpreImage = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"" backguoundColor:[UIColor clearColor]];
//    }
//    return _managemenExpreImage;
//}

- (UIImageView *)hostIconBox{
    if (!_hostIconBox) {
        _hostIconBox = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"" backguoundColor:[UIColor clearColor]];
    }
    return _hostIconBox;
}
//- (UIImageView *)managemenIconBox{
//    if (!_managemenIconBox) {
//        _managemenIconBox = [ControlCreator createImageView:nil rect:CGRectZero imageName:@"" backguoundColor:[UIColor clearColor]];
//    }
//    return _managemenIconBox;
//}
- (EMO_RoomHostUserView *)roomHostView1
{
    if (!_roomHostView1) {
        _roomHostView1 = [[NSBundle mainBundle] loadNibNamed:@"EMO_RoomHostUserView" owner:nil options:nil].lastObject;
        _roomHostView1.mALB.text = @"1";
    }
    return _roomHostView1;
}
- (EMO_RoomHostUserView *)roomHostView2
{
    if (!_roomHostView2) {
        _roomHostView2 = [[NSBundle mainBundle] loadNibNamed:@"EMO_RoomHostUserView" owner:nil options:nil].lastObject;
        _roomHostView2.mALB.text = @"2";
    }
    return _roomHostView2;
}
- (EMO_RoomHostUserView *)roomHostView3
{
    if (!_roomHostView3) {
        _roomHostView3 = [[NSBundle mainBundle] loadNibNamed:@"EMO_RoomHostUserView" owner:nil options:nil].lastObject;
        _roomHostView3.mALB.text = @"3";
    }
    return _roomHostView3;
}
- (EMO_RoomHostUserView *)roomHostView4
{
    if (!_roomHostView4) {
        _roomHostView4 = [[NSBundle mainBundle] loadNibNamed:@"EMO_RoomHostUserView" owner:nil options:nil].lastObject;
        _roomHostView4.mALB.text = @"4";
    }
    return _roomHostView4;
}
- (EMO_RoomHostUserView *)roomHostView5
{
    if (!_roomHostView5) {
        _roomHostView5 = [[NSBundle mainBundle] loadNibNamed:@"EMO_RoomHostUserView" owner:nil options:nil].lastObject;
        _roomHostView5.mALB.text = @"5";
    }
    return _roomHostView5;
}
- (EMO_RoomHostUserView *)roomHostView6
{
    if (!_roomHostView6) {
        _roomHostView6 = [[NSBundle mainBundle] loadNibNamed:@"EMO_RoomHostUserView" owner:nil options:nil].lastObject;
        _roomHostView6.mALB.text = @"6";
    }
    return _roomHostView6;
}
- (EMO_RoomHostUserView *)roomHostView7
{
    if (!_roomHostView7) {
        _roomHostView7 = [[NSBundle mainBundle] loadNibNamed:@"EMO_RoomHostUserView" owner:nil options:nil].lastObject;
        _roomHostView7.mALB.text = @"7";
    }
    return _roomHostView7;
}
- (EMO_RoomHostUserView *)roomHostView8
{
    if (!_roomHostView8) {
        _roomHostView8 = [[NSBundle mainBundle] loadNibNamed:@"EMO_RoomHostUserView" owner:nil options:nil].lastObject;
        _roomHostView8.mALB.text = @"8";
    }
    return _roomHostView8;
}

/// 快速将图片转为灰度图（最简版）
- (UIImage *)grayImageWithOriginalImage:(UIImage *)originalImage {
    if (!originalImage) return nil;
    
    // 直接使用单色滤镜，一步到位
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectMono"];
    [filter setValue:[[CIImage alloc] initWithImage:originalImage] forKey:kCIInputImageKey];
    
    CIImage *outputImage = filter.outputImage;
    UIImage *grayImage = [UIImage imageWithCIImage:outputImage scale:originalImage.scale orientation:originalImage.imageOrientation];
    return grayImage;
}

-(void)setCurrentRoomInfo:(NSDictionary *)currentRoomInfo
{
    if (!_sequenceArray) {
        return;
    }
    MLRoomMSequenceModel *mode=_sequenceArray[0];
    
    /** 是否在房间里*/
    NSString *is_in_room = currentRoomInfo[@"room_info"][@"is_in_room"];
    
    WeakSelf
    if ([NSString NotNull:is_in_room] && is_in_room.intValue==0) {
        SDWebImageManager *manger = [SDWebImageManager sharedManager];
        [manger loadImageWithURL:[NSURL URLWithString:mode.avatar] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
            if (image) {
                wself.hostIcon.image = [wself grayImageWithOriginalImage:image];
            }
         }];
    }
}
@end
