//
//  EMO_MessageHeadView.m
//  miliao
//
//  Created by 张世浩 on 2022/11/12.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_MessageHeadView.h"


@interface EMO_MessageHeadView()
Strong UIImageView *headBgImgView;

Strong UIButton *sysImgBtn;
Strong UIButton *kefuBtn;
Strong UIButton *messageNumBtn;
Strong UIButton *likeBtn;
Strong UIButton *collectBtn;


Strong UILabel *titleLabel;
Strong UILabel *contentLabel;
Strong UILabel *timeLabel;



@end


@implementation EMO_MessageHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

-(void)initView{
    [self headBgImgView];
    [self likeBtn];
    [self sysImgBtn];
    [self collectBtn];
    [self messageNumBtn];
    
    CGFloat margin = (SCREENWIDTH - 45 *2) / 3.0 ;
    self.sysImgBtn.centerX = 45.0;
    self.kefuBtn.centerX = 45.0 + margin;
    self.likeBtn.centerX = 45.0 + margin * 2;
    self.collectBtn.centerX = 45.0 + margin * 3;
    
//    [self titleLabel];
//    [self contentLabel];
//    [self timeLabel];
    
    int count = [[RCCoreClient sharedCoreClient]getUnreadCount:@[@(ConversationType_SYSTEM)]];
    if (count>0) {
        self.messageNumBtn.badgeValue=[NSString stringWithFormat:@"%d",count];
        self.messageNumBtn.badge.hidden=NO;
    }else{
        self.messageNumBtn.badge.hidden=YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBadge) name:@"tabbarAddBadge" object:nil];
    
    
}
- (void)addBadge{
    int count = [[RCCoreClient sharedCoreClient]getUnreadCount:@[@(ConversationType_SYSTEM)]];
    if (count>0) {
        self.messageNumBtn.badgeValue=[NSString stringWithFormat:@"%d",count];
        self.messageNumBtn.badge.hidden=NO;
    }else{
        self.messageNumBtn.badge.hidden=YES;
    }
}




- (UIImageView*)headBgImgView{
    if (!_headBgImgView) {
        _headBgImgView = [[UIImageView alloc] init];
        _headBgImgView.image=KGetImage(@"mineHeadBgImg"); 
        [self addSubview:_headBgImgView];
        [_headBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(0));
            make.top.mas_equalTo(0);
            make.trailing.mas_equalTo(0);
//            make.height.mas_equalTo(KAdaptedHeight(150));
            make.bottom.mas_equalTo(0);
        }];
    }
    return _headBgImgView;
}

- (UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setTitle:getLanguage(@"收到的喜欢") forState:UIControlStateNormal];
        [_likeBtn setTitleColor:RGBA(51, 51, 51, 1) forState:0];
        _likeBtn.titleLabel.font=KFontA(12);
        [_likeBtn setImage:[UIImage imageNamed:@"likeMsgImg"] forState:UIControlStateNormal];
        [_likeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _likeBtn.tag=200;
        _likeBtn.frame = CGRectMake(0, 40, 75, 80);
        [self addSubview:_likeBtn];
        [_likeBtn setImagePositionWithType:SSImagePositionTypeTop spacing:10];
    }
    return _likeBtn;
}


- (UIButton *)sysImgBtn{
    if (!_sysImgBtn) {
        _sysImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sysImgBtn setTitle:getLanguage(@"系统消息") forState:UIControlStateNormal];
        [_sysImgBtn setTitleColor:RGBA(51, 51, 51, 1) forState:0];
        _sysImgBtn.titleLabel.font=KFontA(12);
        [_sysImgBtn setImage:[UIImage imageNamed:@"sysMsgImg"] forState:UIControlStateNormal];
        [_sysImgBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _sysImgBtn.tag=100;
        _sysImgBtn.frame = CGRectMake(0, 40, 75, 80);
        [self addSubview:_sysImgBtn];
        [_sysImgBtn setImagePositionWithType:SSImagePositionTypeTop spacing:10];
    }
    return _sysImgBtn;
}

- (UIButton *)collectBtn{
    if (!_collectBtn) {
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectBtn setTitle:getLanguage(@"我的收藏") forState:UIControlStateNormal];
        [_collectBtn setTitleColor:RGBA(51, 51, 51, 1) forState:0];
        _collectBtn.titleLabel.font=KFontA(12);
        [_collectBtn setImage:[UIImage imageNamed:@"collectMsgImg"] forState:UIControlStateNormal];
        [_collectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _collectBtn.tag=300;
        _collectBtn.frame = CGRectMake(0, 40, 75, 80);
        [self addSubview:_collectBtn];
        [_collectBtn setImagePositionWithType:SSImagePositionTypeTop spacing:10];
    }
    return _collectBtn;
}

-(UIButton *)kefuBtn
{
    if (!_kefuBtn) {
        _kefuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_kefuBtn setTitle:getLanguage(@"在线客服") forState:UIControlStateNormal];
        [_kefuBtn setTitleColor:RGBA(51, 51, 51, 1) forState:0];
        _kefuBtn.titleLabel.font=KFontA(12);
        [_kefuBtn setImage:[UIImage imageNamed:@"kefuMark"] forState:UIControlStateNormal];
        [_kefuBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _kefuBtn.tag=3000;
        _kefuBtn.frame = CGRectMake(0, 40, 75, 80);
        [self addSubview:_kefuBtn];
        [_kefuBtn setImagePositionWithType:SSImagePositionTypeTop spacing:10];
    }
    return _kefuBtn;
}


- (UIButton *)messageNumBtn{
    if (!_messageNumBtn) {
        _messageNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageNumBtn.badgeBGColor=kRedColor;
        _messageNumBtn.size=CGSizeMake(15, 15);
        _messageNumBtn.badgeFont=KFont(10);
        _messageNumBtn.badgeOriginX=15;
        [self addSubview:_messageNumBtn];
        [_messageNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.sysImgBtn.mas_top).offset(KAdaptedHeight(15));
            make.trailing.mas_equalTo(self.sysImgBtn.mas_trailing).offset(KAdaptedWidth(-15));
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(15);
            
        }];
    }
    return _messageNumBtn;
}





-(void)btnClick:(UIButton *)sender{
    if(sender.tag==100){
        self.messageNumBtn.badgeValue=[NSString stringWithFormat:@"0"];
        self.messageNumBtn.badge.hidden=YES;
        [[RCCoreClient sharedCoreClient] clearConversations:@[ @(ConversationType_SYSTEM)]];
    }
    if(self.BtnBlock){
        self.BtnBlock(sender.tag);
    }
    
}





- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = getLanguage(@"官方消息");
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        _titleLabel.font=KFont(13);
        _titleLabel.textColor = RGBA(34, 34, 34, 1);
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.headBgImgView.mas_trailing).offset(KAdaptedWidth(13));
            make.trailing.mas_equalTo(KAdaptedWidth(-130));
            make.top.mas_equalTo(self.headBgImgView.mas_top);
            make.bottom.mas_equalTo(self.headBgImgView.mas_centerY);
        }];
        
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = getLanguage(@"2022-07-25 18:02");
        _timeLabel.textAlignment=NSTextAlignmentRight;
        _timeLabel.font=KFont(10);
        _timeLabel.textColor = RGBA(153, 153, 153, 1);
        [self addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.titleLabel.mas_trailing);
            make.trailing.mas_equalTo(KAdaptedWidth(-14));
            make.top.mas_equalTo(self.titleLabel.mas_top);
            make.bottom.mas_equalTo(self.titleLabel.mas_bottom);
        }];
        
    }
    return _timeLabel;
}




- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = getLanguage(@"您有一个新的官方消息");
        _contentLabel.textAlignment=NSTextAlignmentLeft;
        _contentLabel.font=KFont(11);
        _contentLabel.textColor = RGBA(102, 102, 102, 1);
        [self addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.titleLabel.mas_leading);
            make.trailing.mas_equalTo(self.titleLabel.mas_trailing);
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
            make.bottom.mas_equalTo(self.headBgImgView.mas_bottom);
        }];
        
    }
    return _contentLabel;
}




@end
