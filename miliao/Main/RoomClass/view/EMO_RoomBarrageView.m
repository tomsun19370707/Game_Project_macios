//
//  EMO_RoomBarrageView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/7.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_RoomBarrageView.h"
#import "MLRoomMSequenceModel.h"
#import "EMO_RotaryAlertView.h"

@interface EMO_RoomBarrageView()<SVGAPlayerDelegate,SDCycleScrollViewDelegate>

@property (strong, nonatomic)UIView       *keyBoardBgView;
@property (strong, nonatomic)UIButton       *EmojiBtn;
@property (strong, nonatomic)UIView       *lineView;

@property (strong, nonatomic)UIButton       *maiButton;//麦克风
@property (strong, nonatomic)UIButton       *soundButton;//听筒
@property (strong, nonatomic)UIButton       *setttingButton;
@property (strong, nonatomic)UIButton       *closeButton;


@property (nonatomic, assign) BOOL is_Sound;

Strong SDCycleScrollView *CarouselView;
Strong UIButton *chouJiangBtn,*saipaoBtn;
Strong NSMutableArray *cycleArr;

@end

static SVGAParser *parser;



@implementation EMO_RoomBarrageView

-(NSMutableArray *)cycleArr{
    if (!_cycleArr) {
        _cycleArr=[NSMutableArray array];
    }
    return _cycleArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
//        self.backgroundColor=[UIColor redColor];
        self.isPlay = YES;
        [self initView];
    }
    return self;
}

- (UIView *)keyBoardBgView{
    if (!_keyBoardBgView) {
        _keyBoardBgView = [[UIView alloc] init];
        _keyBoardBgView.layer.contents = (id)KGetImage(@"keyboardBgImg").CGImage;
        _keyBoardBgView.userInteractionEnabled=YES;
        [self addSubview:_keyBoardBgView];
        [_keyBoardBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.height.mas_equalTo(KAdaptedHeight(35));
            make.width.mas_equalTo(KAdaptedWidth(153));
            make.bottom.mas_equalTo(KAdaptedHeight(-15));
        }];
        
    }
    return _keyBoardBgView;
}

- (UIButton *)EmojiBtn{
    if (!_EmojiBtn) {
        _EmojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_EmojiBtn setImage:[UIImage imageNamed:@"EmojiIconIMg"] forState:UIControlStateNormal];
        [_EmojiBtn addTarget:self action:@selector(buttonAtTheBottomOfTheClick:) forControlEvents:UIControlEventTouchUpInside];
        _EmojiBtn.tag=4;
        [self.keyBoardBgView addSubview:_EmojiBtn];
        [_EmojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedWidth(22));
            make.centerY.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(KAdaptedWidth(10));
            
        }];
    }
    return _EmojiBtn;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBA(255, 255, 255, 0.2);
        [self.keyBoardBgView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.EmojiBtn.mas_top);
            make.bottom.mas_equalTo(self.EmojiBtn.mas_bottom);
            make.width.mas_equalTo(1);
            make.leading.mas_equalTo(self.EmojiBtn.mas_trailing).offset(KAdaptedWidth(5));
            
        }];
    }
    return _lineView;
}


- (UIButton *)keyboardButton{
    if (!_keyboardButton) {
        _keyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_keyboardButton setTitle:getLanguage(@"说点什么.....") forState:UIControlStateNormal];
        [_keyboardButton setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        _keyboardButton.titleLabel.font=KFontA(14);
        [_keyboardButton addTarget:self action:@selector(buttonAtTheBottomOfTheClick:) forControlEvents:UIControlEventTouchUpInside];
        _keyboardButton.tag=7;
        [self.keyBoardBgView addSubview:_keyboardButton];
        [_keyboardButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.trailing.mas_equalTo(0);
            make.leading.mas_equalTo(self.lineView.mas_trailing).offset(KAdaptedWidth(5));
        }];
    }
    return _keyboardButton;
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"closeImg"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(buttonAtTheBottomOfTheClick:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.tag=3;
        [self addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedWidth(40));
            make.height.mas_equalTo(KAdaptedHeight(35));
            make.trailing.mas_equalTo(KAdaptedWidth(-10));
            make.bottom.mas_equalTo(self.keyBoardBgView.mas_bottom);
            
        }];
    }
    return _closeButton;
}

- (UIButton *)giftBtn{
    if (!_giftBtn) {
        _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftBtn setImage:[UIImage imageNamed:@"roomGiftImg"] forState:UIControlStateNormal];
        [_giftBtn addTarget:self action:@selector(buttonAtTheBottomOfTheClick:) forControlEvents:UIControlEventTouchUpInside];
        _giftBtn.tag=6;
        [self addSubview:_giftBtn];
        [_giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.keyBoardBgView.mas_bottom);
            make.width.mas_equalTo(KAdaptedWidth(40));
            make.height.mas_equalTo(KAdaptedHeight(35));
            make.trailing.mas_equalTo(self.closeButton.mas_leading).offset(KAdaptedWidth(-6));
        }];
    }
    return _giftBtn;
}

- (UIButton *)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setImage:[UIImage imageNamed:@"UY_RoomMessage"] forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(buttonAtTheBottomOfTheClick:) forControlEvents:UIControlEventTouchUpInside];
        _messageBtn.tag=8;
        [self addSubview:_messageBtn];
        [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.keyBoardBgView.mas_bottom);
            make.width.mas_equalTo(KAdaptedWidth(40));
            make.height.mas_equalTo(KAdaptedHeight(35));
            make.trailing.mas_equalTo(self.giftBtn.mas_leading).offset(KAdaptedWidth(-6));
        }];
        
        _messageNum = [[UILabel alloc] init];
        _messageNum.textColor = UIColor.whiteColor;
        _messageNum.backgroundColor = [UIColor redColor];
        _messageNum.textAlignment = NSTextAlignmentCenter;
//        _messageNum.text = @"7";
        _messageNum.hidden = YES;
        _messageNum.font = KFont(10);
        [self addSubview:_messageNum];
        [_messageNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(20);
            make.width.mas_greaterThanOrEqualTo(20);
            make.left.equalTo(_messageBtn.mas_right).offset(-20);
            make.top.equalTo(_messageBtn.mas_top).offset(-10);
        }];
        setViewCorner(_messageNum, 10);
    }
    return _messageBtn;
}

- (UIButton *)setttingButton{
    if (!_setttingButton) {
        _setttingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setttingButton setImage:[UIImage imageNamed:@"roomSetingImg"] forState:UIControlStateNormal];
        [_setttingButton addTarget:self action:@selector(buttonAtTheBottomOfTheClick:) forControlEvents:UIControlEventTouchUpInside];
        _setttingButton.tag=2;
        [self addSubview:_setttingButton];
        [_setttingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.keyBoardBgView.mas_bottom);
            make.width.mas_equalTo(KAdaptedWidth(40));
            make.height.mas_equalTo(KAdaptedHeight(35));
            make.trailing.mas_equalTo(self.messageBtn.mas_leading).offset(KAdaptedWidth(-6));
            
        }];
    }
    return _setttingButton;
}


- (UIButton *)maiButton{
    if (!_maiButton) {
        _maiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_maiButton setImage:[UIImage imageNamed:@"MicrophoneOpenImg"] forState:UIControlStateNormal];
        [_maiButton addTarget:self action:@selector(buttonAtTheBottomOfTheClick:) forControlEvents:UIControlEventTouchUpInside];
        _maiButton.tag=1;
        [self addSubview:_maiButton];
    }
    return _maiButton;
}

- (UIButton *)soundButton{
    if (!_soundButton) {
        _soundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_soundButton setImage:[UIImage imageNamed:@"UY_RoomSound"] forState:UIControlStateNormal];
        [_soundButton setImage:[UIImage imageNamed:@"UY_RoomSoundG"] forState:UIControlStateSelected];
        [_soundButton addTarget:self action:@selector(buttonAtTheBottomOfTheClick:) forControlEvents:UIControlEventTouchUpInside];
        _soundButton.tag=100;
        [self addSubview:_soundButton];
    }
    return _soundButton;
}


- (UIButton *)shangmaiNumBtn{
    if (!_shangmaiNumBtn) {
        _shangmaiNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shangmaiNumBtn setTitle:[NSString stringWithFormat:@"排队%@人",[Common isNullNumber:[MLRoomInformationModel currentAccount].apply_nums]] forState:UIControlStateNormal];
//        [_shangmaiNumBtn setTitle:getLanguage(@"排队0人") forState:UIControlStateNormal];
        [_shangmaiNumBtn setTitleColor:RGBA(207, 221, 248, 1) forState:UIControlStateNormal];
        _shangmaiNumBtn.titleLabel.font=KFontA(12);
        [_shangmaiNumBtn addTarget:self action:@selector(buttonAtTheBottomOfTheClick:) forControlEvents:UIControlEventTouchUpInside];
        [_shangmaiNumBtn setBackgroundImage:KGetImage(@"peopleNumBtnImg") forState:UIControlStateNormal];
        _shangmaiNumBtn.tag=5;
        [self addSubview:_shangmaiNumBtn];
        [_shangmaiNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(KAdaptedHeight(-70));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(75), KAdaptedHeight(35)));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
        }];
    }
    return _shangmaiNumBtn;
}

-(void)initView{
    
    [self scycleData];
    [self CarouselView];
//    [self shangmaiNumBtn];
    [self chouJiangBtn];
    [self saipaoBtn];
    [self keyBoardBgView];
    [self EmojiBtn];
    [self lineView];
    [self keyboardButton];
    
    [self closeButton];
    [self giftBtn];
    [self setttingButton];
    [self maiButton];
    [self soundButton];
    
    _shangMai = @"1";
    _isMai = YES;
    _isVoice = YES;

    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KAdaptedWidth(0));
        make.height.mas_equalTo(KAdaptedHeight(35));
        make.trailing.mas_equalTo(KAdaptedWidth(0));
        make.bottom.mas_equalTo(self.keyBoardBgView.mas_bottom);
        
    }];
    
    [_giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.keyBoardBgView.mas_bottom);
        make.width.mas_equalTo(KAdaptedWidth(40));
        make.height.mas_equalTo(KAdaptedHeight(35));
        make.trailing.mas_equalTo(self.closeButton.mas_leading).offset(KAdaptedWidth(-6));
    }];
    
    [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.keyBoardBgView.mas_bottom);
        make.width.mas_equalTo(KAdaptedWidth(40));
        make.height.mas_equalTo(KAdaptedHeight(35));
        make.trailing.mas_equalTo(self.giftBtn.mas_leading).offset(KAdaptedWidth(-6));
    }];
    
    [_setttingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.keyBoardBgView.mas_bottom);
        make.width.mas_equalTo(KAdaptedWidth(40));
        make.height.mas_equalTo(KAdaptedHeight(35));
        make.trailing.mas_equalTo(self.messageBtn.mas_leading).offset(KAdaptedWidth(-6));
    }];
    
    [_soundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.messageBtn.mas_bottom);
        make.width.mas_equalTo(KAdaptedWidth(40));
        make.height.mas_equalTo(KAdaptedHeight(35));
        make.trailing.mas_equalTo(self.messageBtn.mas_leading).offset(KAdaptedWidth(-6));
    }];
    
    [_maiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.keyBoardBgView.mas_bottom);
        make.width.mas_equalTo(KAdaptedWidth(40));
        make.height.mas_equalTo(KAdaptedHeight(35));
        make.trailing.mas_equalTo(self.soundButton.mas_leading).offset(KAdaptedWidth(-6));
    }];
    
    self.closeButton.hidden=YES;
    self.shangmaiNumBtn.hidden=YES;
    self.setttingButton.hidden=NO;
    self.soundButton.hidden=YES;
    //1房主  2管理员 0一般用户
    if ([[MLRoomInformationModel currentAccount].user_type isEqualToString:@"1"]) {
        self.closeButton.hidden=NO;
        self.maiButton.hidden=NO;
        [self.closeButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedWidth(40));
            make.trailing.mas_equalTo(KAdaptedWidth(-10));
        }];
        [self.closeButton layoutIfNeeded];
    }else if ([[MLRoomInformationModel currentAccount].user_type isEqualToString:@"2"]){
        self.maiButton.hidden=YES;
        
    }else if ([[MLRoomInformationModel currentAccount].user_type isEqualToString:@"0"]){
        self.maiButton.hidden=YES;
        self.setttingButton.hidden=YES;
        self.soundButton.hidden=NO;
        [self.setttingButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KAdaptedWidth(0));
            make.trailing.mas_equalTo(self.messageBtn.mas_leading).offset(KAdaptedWidth(-0));
        }];
        [self.setttingButton layoutIfNeeded];
    }
}


- (void)boxTapGesture
{
    !self.sureClickBlock ?: self.sureClickBlock(10);
}
#pragma mark- SVGAPlayerDelegate
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player{
   
}
- (void)svgaPlayerDidAnimatedToFrame:(NSInteger)frame{
    
}
- (void)svgaPlayerDidAnimatedToPercentage:(CGFloat)percentage{
    
}

- (void)buttonAtTheBottomOfTheClick:(UIButton *)sender {
   
    if(sender.tag==1){
        NSLog(@"开麦or闭麦");
        [self kaiMai:self.isMai andType:666];
        return;
    }else if (sender.tag ==2){
        NSLog(@"房间设置");
    }else if (sender.tag==3){
        NSLog(@"关播");
    }else if (sender.tag==4){
        NSLog(@"表情");
    }else if (sender.tag==5){
        NSLog(@"排队上麦");
    }else if (sender.tag==6){
        NSLog(@"礼物");
    }else if (sender.tag==8){
        NSLog(@"消息");
    }else if (sender.tag==100){
        NSLog(@"关闭声音");
        self.soundButton.selected = !self.soundButton.selected;
        self.isPlay = !self.isPlay;
    }

    MYLog(@"%ld",sender.tag);
    !self.sureClickBlock ?: self.sureClickBlock(sender.tag);
    
}


-(void)kaiMai:(BOOL)Status andType:(NSInteger )type{
    _isMai=Status;
    if ([[MLRoomInformationModel currentAccount].user_type integerValue] == 1) {
        if (!_isMai) {
            [self.maiButton setImage:[UIImage imageNamed:@"MicrophoneOpenImg"] forState:UIControlStateNormal];
            _isMai = YES;
        }else{
            [self.maiButton setImage:[UIImage imageNamed:@"MicrophoneCloseImg"] forState:UIControlStateNormal];
            _isMai = NO;
        }
//        !self.sureClickBlock ?: self.sureClickBlock(1);
        !self.sureClickBlock ?: self.sureClickBlock(type);
        return;
    }
    if (_is_Sound) {
        //麦克风
        if (!_isMai) {
            [self.maiButton setImage:[UIImage imageNamed:@"MicrophoneOpenImg"] forState:UIControlStateNormal];
            _isMai = YES;
        }else{
            [self.maiButton setImage:[UIImage imageNamed:@"MicrophoneCloseImg"] forState:UIControlStateNormal];
            _isMai = NO;
        }
    }else{
        [self.maiButton setImage:[UIImage imageNamed:@"MicrophoneCloseImg"] forState:UIControlStateNormal];
        _isMai = NO;
    }
    !self.sureClickBlock ?: self.sureClickBlock(1);
}

- (void)setAdminBarrage{
    self.setttingButton.hidden=NO;
    [self.setttingButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KAdaptedWidth(40));
        make.trailing.mas_equalTo(self.messageBtn.mas_leading).offset(KAdaptedWidth(-6));
    }];
    [self.setttingButton layoutIfNeeded];
    if ([_shangMai isEqualToString:@"2"]) {
//        _musicButton.hidden = NO;
//        _maiButton.hidden = NO;
//        _scoreButton.hidden = YES;
//        _expressionButton.hidden = YES;
//        _moreButton.hidden = NO;
//        self.expressionButton.hidden = NO;
//        _keyboardRight.constant = 40;
//        self.maiLeft.constant = 53;
//        self.voiceLeft.constant = 53 + 40;
//        self.musicLeft.constant = 53 + 40 + 40;
//        self.moreLeft.constant = 53 + 40 + 40 + 40;
    }else{

//        _musicButton.hidden = YES;
//        _maiButton.hidden = YES;
//        _scoreButton.hidden = YES;
//        _moreButton.hidden = NO;
//        self.expressionButton.hidden = YES;
//        _shangMaiButton.hidden = NO;
//        _keyboardRight.constant = 0;
//        self.voiceLeft.constant = 53;
//        self.moreLeft.constant = 53 + 40;
//        self.maiWidth.constant=0;
    }
//    self.expressionButton.hidden = YES;
    [self layoutIfNeeded];
}

- (void)setNoAdminBarrage{
    
    self.setttingButton.hidden=YES;
    [self.setttingButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KAdaptedWidth(0));
        make.trailing.mas_equalTo(self.messageBtn.mas_leading).offset(KAdaptedWidth(-0));
    }];
    [self.setttingButton layoutIfNeeded];
    
    
    if ([_shangMai isEqualToString:@"2"]) {
//        _musicButton.hidden = NO;
//        _maiButton.hidden = NO;
//        _scoreButton.hidden = YES;
//        _expressionButton.hidden = YES;
//        _moreButton.hidden = YES;
//        self.expressionButton.hidden = NO;
//        _keyboardRight.constant = 40;
//        self.maiLeft.constant = 53;
//        self.voiceLeft.constant = 53 + 40;
//        self.musicLeft.constant = 53 + 40 + 40;
        
    }else{
//        _musicButton.hidden = YES;
//        _maiButton.hidden = YES;
//        _scoreButton.hidden = YES;
//        _expressionButton.hidden = YES;
//        _moreButton.hidden = YES;
//        _shangMaiButton.hidden  = NO;
//        _keyboardRight.constant = 0;
//        self.voiceLeft.constant = 53;
//        self.maiWidth.constant=0;
    }
//    self.expressionButton.hidden = YES;
    
    [self layoutIfNeeded];
}
///下麦
- (void)xiamaiSetUI{
    if ([[MLRoomInformationModel currentAccount].user_type isEqualToString:@"0"]) {
        self.maiButton.hidden=YES;
        self.shangMai = @"1";
    }
    else if ([[MLRoomInformationModel currentAccount].user_type isEqualToString:@"2"]){

        self.maiButton.hidden=YES;

        self.shangMai = @"1";
    }
    else if ([[MLRoomInformationModel currentAccount].user_type isEqualToString:@"1"]){

    }
    [self layoutIfNeeded];
}

///上麦成功
- (void)shangxiamaiSetUI{
    if ([[MLRoomInformationModel currentAccount].user_type isEqualToString:@"0"]) {

        self.maiButton.hidden=NO;
        self.shangMai = @"2";

        
    }
    else if ([[MLRoomInformationModel currentAccount].user_type isEqualToString:@"2"]){
        self.maiButton.hidden=NO;
        self.shangMai = @"2";
        

    }
    else if ([[MLRoomInformationModel currentAccount].user_type isEqualToString:@"1"]){
        self.maiButton.hidden = NO;
    }
    [self layoutIfNeeded];
}
- (void)setPaimaiWithArry:(NSArray *)arry{
    if (![_shangMai isEqualToString:@"2"]) {
        [arry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MLRoomMSequenceModel *model = (MLRoomMSequenceModel *)obj;
            
            if ([model.status integerValue] == 0) {
                self.shangMai = @"1";
//                [self.shangMaiButton setImage:[UIImage imageNamed:@"room_dibu_shangmai"] forState:UIControlStateNormal];
                *stop = YES;
            }else{
                self.shangMai = @"3";
//                [self.shangMaiButton setImage:[UIImage imageNamed:@"room_dibu_paimai"] forState:UIControlStateNormal];
            }
        }];
    }else{
        self.shangMai = @"2";
//        [self.shangMaiButton setImage:[UIImage imageNamed:@"room_dibu_xiamai"] forState:UIControlStateNormal];
    }
    
    [arry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MLRoomMSequenceModel *model = (MLRoomMSequenceModel *)obj;
        if ([model.uid integerValue] == [[UserManager userInfo].user_id integerValue]) {
            if ([model.type integerValue] == 0) {
                self.is_Sound = YES;
                if (self.isMai) {
                    [self.maiButton setImage:[UIImage imageNamed:@"MicrophoneOpenImg"] forState:UIControlStateNormal];
                    self.isMai = YES;
                }else{
                    [self.maiButton setImage:[UIImage imageNamed:@"MicrophoneCloseImg"] forState:UIControlStateNormal];
                    self.isMai = NO;
                }
            }else{
                self.is_Sound =NO;
                [self.maiButton setImage:[UIImage imageNamed:@"MicrophoneCloseImg"] forState:UIControlStateNormal];
                self.isMai = NO;
            }
        }
    }];
}
- (void)setIsVoice:(BOOL)isVoice{
    _isVoice = isVoice;
    if (_isVoice) {
//        [self.voiceButton setImage:[UIImage imageNamed:@"room_dibu_shengyin"] forState:UIControlStateNormal];
    }else{
//        [self.voiceButton setImage:[UIImage imageNamed:@"room_dibu_jingyin"] forState:UIControlStateNormal];
    }
}
- (void)isIfPuiet:(BOOL)puiet{

}
- (void)loadData:(id)obj{
    
}

///塔罗牌
- (IBAction)tlpClick:(UIButton *)sender {
 
}

///礼物
- (IBAction)liBaoClick:(UIButton *)sender {
    !self.sureClickBlock ?: self.sureClickBlock(10);
}

-(UIButton *)chouJiangBtn{
    if(!_chouJiangBtn){
        _chouJiangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chouJiangBtn setBackgroundImage:KGetImage(@"UY_ZhuanPan") forState:0];
        [_chouJiangBtn addTarget:self action:@selector(chouJiangClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_chouJiangBtn];
        [_chouJiangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(KAdaptedHeight(-180));
                make.size.mas_equalTo(CGSizeMake(KAdaptedHeight(80), KAdaptedHeight(80)));
                make.trailing.mas_equalTo(KAdaptedWidth(-15));
        }];
    }
    return _chouJiangBtn;
}
-(UIButton *)saipaoBtn{
    if(!_saipaoBtn){
        _saipaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saipaoBtn setBackgroundImage:KGetImage(@"UY_Saipao") forState:0];
        [_saipaoBtn addTarget:self action:@selector(saipaoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saipaoBtn];
        [_saipaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.chouJiangBtn.mas_bottom).offset(10);
                make.size.mas_equalTo(CGSizeMake(KAdaptedHeight(80), KAdaptedHeight(80)));
                make.trailing.mas_equalTo(KAdaptedWidth(-15));
        }];
    }
    return _saipaoBtn;
}
-(SDCycleScrollView *)CarouselView{
    if (!_CarouselView) {
        _CarouselView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _CarouselView.autoScrollTimeInterval = 5;
        _CarouselView.tag=300;
        _CarouselView.showPageControl=NO;
        _CarouselView.backgroundColor=kClearColor;
        [self addSubview:_CarouselView];
        [_CarouselView mas_makeConstraints:^(MASConstraintMaker *make) {
            
                make.bottom.mas_equalTo(KAdaptedHeight(-130));
                make.size.mas_equalTo(CGSizeMake(KAdaptedHeight(55), KAdaptedHeight(55)));
                make.trailing.mas_equalTo(KAdaptedWidth(-15));
            
        }];
        setViewCorner(_CarouselView, 10);
    }
    
    return _CarouselView;
}



- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//    if(self.scycleClickBlock){
//        self.scycleClickBlock(cycleScrollView.tag, index,self.cycleArr[index]);
//    }
    EMO_RotaryAlertView *rotaryView = [[EMO_RotaryAlertView alloc] init];
    [rotaryView requestGift];
    [rotaryView requestGiftChaoJi];
    [rotaryView viewShow];
}

#pragma mark 转盘数据 游戏视图
-(void)chouJiangClick{
    if(self.scycleClickBlock){
//        self.scycleClickBlock(300, 0,self.cycleArr[0]);//    数组为空会报错
        NSDictionary *dicData=[NSDictionary dictionary];
        self.scycleClickBlock(300, 0,dicData);
    }
}
#pragma mark 赛跑游戏数据 游戏视图
-(void)saipaoBtnClick{
    if(self.scycleClickBlock){
//        self.scycleClickBlock(300, 0,self.cycleArr[0]);//    数组为空会报错
        NSDictionary *dicData=[NSDictionary dictionary];
        self.scycleClickBlock(400, 0,dicData);
    }
}

-(void)scycleData{
    if([UserManager userInfo].is_show_draw){
//        self.cycleArr=[NSMutableArray arrayWithArray:@[@"prizeIconImg"]];
//        self.CarouselView.localizationImageNamesGroup =@[@"prizeIconImg"];
    }else{
        self.cycleArr=[NSMutableArray array];
        self.CarouselView.localizationImageNamesGroup =[[NSArray alloc] init];
    }
//    WeakSelf;
//    [HttpTool getCarouseWithParameters:@{@"type":@"3"} success:^(id response) {
//        if ([response[@"code"] intValue] == 1) {
//            NSMutableArray *imgArr=[NSMutableArray array];
//            wself.cycleArr=[NSMutableArray arrayWithArray:response[@"data"]];
//            for (NSDictionary *dic in wself.cycleArr) {
//                [imgArr addObject:dic[@"img"]];
//            }
//            wself.CarouselView.imageURLStringsGroup =imgArr;
//
//        }
//
//    } failure:^(NSError *error) {
//
//    }];
    
    
}







@end
