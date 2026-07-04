#import "MLChatRoomThemeGameOneView.h"
#import "MLGameLotteryService.h"
#import "RoomFloatingWindow.h"
#import "AppDelegate.h"
#import "MLChatRoomThemeGameOneResultView.h"
#import "MLChatRoomThemeGameOneRuleView.h"
#import "MLChatRoomThemeGameOneRecordView.h"
#import "MLChatRoomThemeGameOnePurchaseView.h"
#import "MLChatRoomThemeGameOneExchangeView.h"
#import "MLChatRoomThemeGameFortuneView.h"
#import "MLChatRoomMarqueeLabel.h"
#import "Global.h"
#import "UIViewController+CurViewController.h"
#import "CFMWalletDiamondRechargeVc.h"

#if __has_include(<SVGAPlayer/SVGAPlayer.h>)
#import <SVGAPlayer/SVGAPlayer.h>
#import <SVGAPlayer/SVGAParser.h>
#else
#import "SVGAPlayer.h"
#import "SVGAParser.h"
#endif

#define KDialogAdaptedWidth(x) (isPadA ? ceilf((x) * (390.0 / 375.0)) : KAdaptedWidth(x))

@interface MLChatRoomThemeGameOneView ()

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *ruleButton;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIButton *exchangeButton;
@property (nonatomic, strong) NSTimer *rotationTimer;

@property (nonatomic, strong) UIImageView *refreshBgImageView;
@property (nonatomic, strong) UIImageView *refreshIconView;
@property (nonatomic, strong) UILabel *refreshTextLabel;

@property (nonatomic, strong) UILabel *keyBalanceLabel;
@property (nonatomic, strong) UIButton *keyPlusButton;
@property (nonatomic, strong) UILabel *luckyTextLabel;
@property (nonatomic, strong) UIProgressView *luckyProgressBar;

@property (nonatomic, strong) UILabel *diamondBalanceLabel;
@property (nonatomic, strong) UIButton *diamondPlusButton;

@property (nonatomic, strong) UIButton *drawOneButton;
@property (nonatomic, strong) UIButton *drawTenButton;
@property (nonatomic, strong) UIButton *drawHundredButton;

// 18个格子的卡片 View
@property (nonatomic, strong) NSMutableArray<UIView *> *giftCardViews;
// 18个格子上的奖品图
@property (nonatomic, strong) NSMutableArray<UIImageView *> *giftImageViews;
// 18个格子上的奖品名称 Label
@property (nonatomic, strong) NSMutableArray<UILabel *> *giftNameLabels;

@property (nonatomic, strong) MLGameLotteryInfoModel *infoModel;
@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *prizesInPool;

@property (nonatomic, assign) BOOL isDrawing;
@property (nonatomic, assign) NSInteger localKeyBalance;
@property (nonatomic, assign) NSInteger currentStartIndex;
@property (nonatomic, assign) NSInteger lastDrawTimes;
@property (nonatomic, assign) NSInteger lastDrawCost;

// 跑马灯计时器
@property (nonatomic, assign) NSInteger targetStopIndex;

// SVGA 播放与暂存
@property (nonatomic, strong) SVGAPlayer *svgaPlayer;
@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *pendingGifts;
@property (nonatomic, assign) NSInteger pendingTotalValue;
@property (nonatomic, assign) NSInteger consumeValue;
@property (nonatomic, assign) NSInteger produceValue;
@property (nonatomic, strong) MLChatRoomMarqueeLabel *marqueeLabel;
@property (nonatomic, strong) MASConstraint *marqueeHeightConstraint;

@end

@interface MLChatRoomThemeGameOneView () <SVGAPlayerDelegate>
@end

@implementation MLChatRoomThemeGameOneView

+ (void)showInView:(UIView *)parentView typeId:(NSInteger)typeId {
    MLChatRoomThemeGameOneView *gameView = [[MLChatRoomThemeGameOneView alloc] initWithFrame:parentView.bounds typeId:typeId];
    [parentView addSubview:gameView];
    [gameView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame typeId:(NSInteger)typeId {
    if (self = [super initWithFrame:frame]) {
        self.typeId = typeId;
        self.isDrawing = NO;
        self.currentStartIndex = 0;
        self.giftCardViews = [NSMutableArray array];
        self.giftImageViews = [NSMutableArray array];
        self.giftNameLabels = [NSMutableArray array];
        
        [self setupUI];
        [self loadData];
        
        // 隐藏常驻最顶层的语音悬浮球
        // 隐藏语音悬浮窗
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.roomViewController && appDelegate.roomViewController.floatingWindow) {
            appDelegate.roomViewController.floatingWindow.hidden = YES;
        }
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 暗色蒙层
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _maskView.userInteractionEnabled = YES;
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMaskTap:)];
    [_maskView addGestureRecognizer:tap];
    
    // 背景大图 (锁定 740:1136 比例，在宽屏设备上限宽 390 pt 居中，防拉伸与漂移)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_one_clean_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        if (isPadA) {
            make.width.mas_equalTo(390);
        } else {
            make.width.mas_equalTo(self);
        }
        make.height.mas_equalTo(_bgImageView.mas_width).multipliedBy(1136.0 / 740.0);
    }];
    
    // 左上角返回/关闭按钮 (theme_game_one_rule_back, 36 * 36)
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"theme_game_one_rule_back"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(16));
        make.leading.mas_equalTo(KDialogAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    // 记录按钮 (距右边缘 16 pt, top 16)
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordButton setImage:[UIImage imageNamed:@"theme_game_one_record_btn_brighter"] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_recordButton];
    [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(16));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    // 规则按钮 (位于记录按钮左侧 10 pt)
    _ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ruleButton setImage:[UIImage imageNamed:@"theme_game_one_rule_btn_brighter"] forState:UIControlStateNormal];
    [_ruleButton addTarget:self action:@selector(ruleClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_ruleButton];
    [_ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(16));
        make.trailing.mas_equalTo(_recordButton.mas_leading).offset(-KDialogAdaptedWidth(10));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    // 今日运势悬浮条 (宽 74, 高 23. 水平悬浮在规则/记录按钮组左侧 10 pt. 40% 半透明黑底, 圆角 11.5 pt)
    UIView *fortuneBar = [[UIView alloc] init];
    fortuneBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    setViewCorner(fortuneBar, 11.5);
    fortuneBar.userInteractionEnabled = YES;
    [_bgImageView addSubview:fortuneBar];
    [fortuneBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_recordButton);
        make.trailing.mas_equalTo(_ruleButton.mas_leading).offset(-KDialogAdaptedWidth(10));
        make.size.mas_equalTo(CGSizeMake(74, 23));
    }];
    
    UITapGestureRecognizer *fortuneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fortuneClick)];
    [fortuneBar addGestureRecognizer:fortuneTap];
    
    UILabel *fortuneLabel = [[UILabel alloc] init];
    fortuneLabel.text = @"今日运势";
    fortuneLabel.textColor = mHexRGB(0xE1F5FE);
    fortuneLabel.font = [UIFont systemFontOfSize:10];
    fortuneLabel.textAlignment = NSTextAlignmentCenter;
    [fortuneBar addSubview:fortuneLabel];
    [fortuneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(fortuneBar);
    }];
    
    // 刷新奖池按钮 (宽 90, 高 32. 距底 120 pt, 距左 24 pt)
    _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_refreshButton setImage:[UIImage imageNamed:@"theme_game_one_refresh_btn"] forState:UIControlStateNormal];
    [_refreshButton addTarget:self action:@selector(refreshPoolClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_refreshButton];
    [_refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(120));
        make.leading.mas_equalTo(KDialogAdaptedWidth(24));
        make.size.mas_equalTo(CGSizeMake(90, 32));
    }];
    
    // 藏宝图兑换按钮 (宽 90, 高 32. 距底 120 pt, 距右 24 pt)
    _exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_exchangeButton setImage:[UIImage imageNamed:@"theme_game_one_exchange_btn"] forState:UIControlStateNormal];
    [_exchangeButton addTarget:self action:@selector(exchangeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_exchangeButton];
    [_exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(120));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(24));
        make.size.mas_equalTo(CGSizeMake(90, 32));
    }];
    
    // 18 宫格礼物卡片环形布局容器 (宽 316, 高 324 pt, 距顶固定 140 pt)
    UIView *cardsContainer = [[UIView alloc] init];
    [_bgImageView addSubview:cardsContainer];
    [cardsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgImageView);
        make.top.mas_equalTo(KDialogAdaptedWidth(140));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(316), KDialogAdaptedWidth(324)));
    }];
    
    [self layout18GiftCardsInContainer:cardsContainer];
    
    // 底部寻梦值进度条
    _luckyProgressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _luckyProgressBar.progressTintColor = mHexRGB(0x00A2FF); // 蓝色进度条
    _luckyProgressBar.trackTintColor = [UIColor colorWithWhite:1 alpha:0.3];
    _luckyProgressBar.progress = 0.0;
    [_bgImageView addSubview:_luckyProgressBar];
    [_luckyProgressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgImageView);
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(140));
        make.width.mas_equalTo(KDialogAdaptedWidth(220));
        make.height.mas_equalTo(8);
    }];
    
    _luckyTextLabel = [[UILabel alloc] init];
    _luckyTextLabel.textColor = kWhiteColor;
    _luckyTextLabel.font = KFontA(12);
    _luckyTextLabel.text = @"寻梦值: 0/200";
    [_bgImageView addSubview:_luckyTextLabel];
    [_luckyTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_luckyProgressBar);
        make.leading.mas_equalTo(_luckyProgressBar.mas_trailing).offset(6);
    }];
    
    // 钻石余额条 (高 22 pt, 宽 90 pt. 距顶 50 pt, 距左 24 pt)
    UIView *diamondBar = [[UIView alloc] init];
    diamondBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    setViewCorner(diamondBar, 11); // 11 pt 圆角
    [_bgImageView addSubview:diamondBar];
    [diamondBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.leading.mas_equalTo(24);
        make.size.mas_equalTo(CGSizeMake(90, 22));
    }];
    
    // 钻石图标 (30 * 30 pt，悬浮出底板顶部)
    UIImageView *diaIcon = [[UIImageView alloc] init];
    diaIcon.image = [UIImage imageNamed:@"theme_game_one_cover_diamond"];
    [_bgImageView addSubview:diaIcon]; // 直接加在_bgImageView上防止被切除
    [diaIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(diamondBar.mas_leading).offset(-4);
        make.centerY.mas_equalTo(diamondBar);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    _diamondBalanceLabel = [[UILabel alloc] init];
    _diamondBalanceLabel.textColor = kWhiteColor;
    _diamondBalanceLabel.font = [UIFont systemFontOfSize:11];
    _diamondBalanceLabel.text = @"0";
    [diamondBar addSubview:_diamondBalanceLabel];
    [_diamondBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(24); // 避开 30x30 图标
        make.centerY.mas_equalTo(diamondBar);
    }];
    
    _diamondPlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_diamondPlusButton setImage:[UIImage imageNamed:@"theme_game_one_plus_icon"] forState:UIControlStateNormal];
    [_diamondPlusButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
    [diamondBar addSubview:_diamondPlusButton];
    [_diamondPlusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-4);
        make.centerY.mas_equalTo(diamondBar);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    // 钥匙余额条 (高 22 pt, 宽 90 pt. 距顶 50 pt, 距右 24 pt)
    UIView *keyBar = [[UIView alloc] init];
    keyBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    setViewCorner(keyBar, 11); // 11 pt 圆角
    [_bgImageView addSubview:keyBar];
    [keyBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.trailing.mas_equalTo(-24);
        make.size.mas_equalTo(CGSizeMake(90, 22));
    }];
    
    // 钥匙图标 (30 * 30 pt，悬浮出底板顶部)
    UIImageView *keyIcon = [[UIImageView alloc] init];
    keyIcon.image = [UIImage imageNamed:@"theme_game_one_cover_key"];
    [_bgImageView addSubview:keyIcon];
    [keyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(keyBar.mas_leading).offset(-4);
        make.centerY.mas_equalTo(keyBar);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    _keyBalanceLabel = [[UILabel alloc] init];
    _keyBalanceLabel.textColor = kWhiteColor;
    _keyBalanceLabel.font = [UIFont systemFontOfSize:11];
    _keyBalanceLabel.text = @"0";
    [keyBar addSubview:_keyBalanceLabel];
    [_keyBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(24); // 避开 30x30 图标
        make.centerY.mas_equalTo(keyBar);
    }];
    
    _keyPlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_keyPlusButton setImage:[UIImage imageNamed:@"theme_game_one_plus_icon"] forState:UIControlStateNormal];
    [_keyPlusButton addTarget:self action:@selector(openPurchaseDialog) forControlEvents:UIControlEventTouchUpInside];
    [keyBar addSubview:_keyPlusButton];
    [_keyPlusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-4);
        make.centerY.mas_equalTo(keyBar);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    // 底部“品”字形抽奖按钮组
    _drawTenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawTenButton setImage:[UIImage imageNamed:@"theme_game_one_draw_ten"] forState:UIControlStateNormal];
    [_drawTenButton addTarget:self action:@selector(drawTenClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_drawTenButton];
    [_drawTenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgImageView);
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(40));
        make.size.mas_equalTo(CGSizeMake(112, 56));
    }];
    
    _drawOneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawOneButton setImage:[UIImage imageNamed:@"theme_game_one_draw_one"] forState:UIControlStateNormal];
    [_drawOneButton addTarget:self action:@selector(drawOneClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_drawOneButton];
    [_drawOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(_drawTenButton.mas_leading).offset(-KDialogAdaptedWidth(12));
        make.centerY.mas_equalTo(_drawTenButton);
        make.size.mas_equalTo(CGSizeMake(112, 56));
    }];
    
    _drawHundredButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawHundredButton setImage:[UIImage imageNamed:@"theme_game_one_draw_hundred"] forState:UIControlStateNormal];
    [_drawHundredButton addTarget:self action:@selector(drawHundredClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_drawHundredButton];
    [_drawHundredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_drawTenButton.mas_trailing).offset(KDialogAdaptedWidth(12));
        make.size.mas_equalTo(CGSizeMake(112, 56));
    }];
    
    // 全服中奖轮播跑马灯 (水平居中, 距顶部返回按钮底部 10 pt. 高度默认为 0 隐蔽)
    _marqueeLabel = [[MLChatRoomMarqueeLabel alloc] init];
    _marqueeLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    setViewCorner(_marqueeLabel, 11);
    [_bgImageView addSubview:_marqueeLabel];
    
    WeakSelf
    [_marqueeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.backButton.mas_bottom).offset(10);
        make.leading.mas_equalTo(24);
        make.trailing.mas_equalTo(-24);
        wself.marqueeHeightConstraint = make.height.mas_equalTo(0);
    }];
}

- (void)updateMarqueeHeight:(CGFloat)height {
    [self.marqueeHeightConstraint uninstall];
    WeakSelf
    [self.marqueeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        wself.marqueeHeightConstraint = make.height.mas_equalTo(height);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [wself layoutIfNeeded];
    }];
}

#pragma mark - 18宫格对称环状排布逻辑 (6x5 完美对齐)
- (void)layout18GiftCardsInContainer:(UIView *)container {
    // 宽 46，高 60。水平间距 8，垂直间距 6
    // 整个容器应该设为 316 * 324 pt (对应 6x5 环状的总边界)
    CGFloat cardW = KDialogAdaptedWidth(46.0f);
    CGFloat cardH = KDialogAdaptedWidth(60.0f);
    CGFloat hGap = KDialogAdaptedWidth(8.0f);
    CGFloat vGap = KDialogAdaptedWidth(6.0f);
    
    for (int i = 0; i < 18; i++) {
        UIView *card = [[UIView alloc] init];
        card.backgroundColor = [UIColor clearColor];
        [container addSubview:card];
        [self.giftCardViews addObject:card];
        
        // 交替作为格子底层背景
        UIImageView *cardBg = [[UIImageView alloc] init];
        NSString *bgName = [NSString stringWithFormat:@"theme_game_one_gift_board_%d", (i % 4) + 1];
        cardBg.image = [UIImage imageNamed:bgName];
        cardBg.contentMode = UIViewContentModeScaleToFill;
        [card addSubview:cardBg];
        [cardBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(card);
        }];
        
        UIImageView *giftImg = [[UIImageView alloc] init];
        giftImg.contentMode = UIViewContentModeScaleAspectFit;
        [card addSubview:giftImg];
        [giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(card).insets(UIEdgeInsetsMake(KDialogAdaptedWidth(4), KDialogAdaptedWidth(4), KDialogAdaptedWidth(16), KDialogAdaptedWidth(4))); // 为底部名字留空
        }];
        [self.giftImageViews addObject:giftImg];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont boldSystemFontOfSize:9.5];
        nameLabel.textColor = kWhiteColor;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        setViewCorner(nameLabel, 2);
        [card addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.mas_equalTo(card);
            make.height.mas_equalTo(KDialogAdaptedWidth(14));
        }];
        [self.giftNameLabels addObject:nameLabel];
        
        // 6x5 环状排布，顺时针成环：
        // 0..5: 顶部横排 (col = 0..5, row = 0)
        // 6..8: 右侧竖排 (col = 5, row = 1..3)
        // 9..14: 底部横排 (col = 5..0, row = 4)
        // 15..17: 左侧竖排 (col = 0, row = 3..1)
        if (i < 6) {
            // 顶部横排
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.leading.mas_equalTo(i * (cardW + hGap));
                make.size.mas_equalTo(CGSizeMake(cardW, cardH));
            }];
        } else if (i < 9) {
            // 右侧竖排
            int row = i - 5; // 1, 2, 3
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(row * (cardH + vGap));
                make.trailing.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(cardW, cardH));
            }];
        } else if (i < 15) {
            // 底部横排
            int col = 14 - i; // 5, 4, 3, 2, 1, 0
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(4 * (cardH + vGap));
                make.leading.mas_equalTo(col * (cardW + hGap));
                make.size.mas_equalTo(CGSizeMake(cardW, cardH));
            }];
        } else {
            // 左侧竖排
            int row = 18 - i; // 3, 2, 1
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(row * (cardH + vGap));
                make.leading.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(cardW, cardH));
            }];
        }
    }
}

#pragma mark - 数据请求
- (void)loadData {
    WeakSelf
    // 1. 获取个人资产
    [MLGameLotteryService getUserMoneyWithSuccess:^(MLGameUserMoneyModel *moneyModel) {
        wself.diamondBalanceLabel.text = moneyModel.diamond;
        wself.localKeyBalance = moneyModel.lottery_coin;
        [wself updateBalanceUI];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 2. 详情、消耗档位
    [MLGameLotteryService getRoomDetailWithTypeId:self.typeId success:^(MLGameLotteryInfoModel *model) {
        wself.infoModel = model;
        wself.luckyProgressBar.progress = (double)model.lucky / 200.0;
        wself.luckyTextLabel.text = [NSString stringWithFormat:@"寻梦值: %ld/200", (long)model.lucky];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 3. 18 格奖池礼物列表
    [MLGameLotteryService getPrizesWithTypeId:self.typeId success:^(NSArray<MLGameDrawResultModel *> *list) {
        wself.prizesInPool = list;
        [wself renderGiftBoard];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 4. 获取今日运势数据 (对接 typeId == 3 / lottery_id == 7)
    [MLGameLotteryService getFortuneLotteryListWithSuccess:^(NSArray<MLGameLotteryInfoModel *> *list) {
        for (MLGameLotteryInfoModel *model in list) {
            if (model.typeId == 7 || model.typeId == 3 || [model.name containsString:@"寻梦"]) {
                wself.consumeValue = model.consume_diamonds;
                wself.produceValue = model.produce_diamonds;
                break;
            }
        }
    } failure:^(NSError *error) {
        // 静默失败
    }];
    
    // 5. 获取全服中奖广播跑马灯
    [MLGameLotteryService getLotteryWinLogWithTypeId:self.typeId page:1 pageSize:20 success:^(NSArray *list, NSInteger total) {
        if (list.count > 0) {
            NSMutableArray<NSAttributedString *> *items = [NSMutableArray array];
            for (NSDictionary *dict in list) {
                NSString *nickname = dict[@"nickname"] ?: @"";
                if (nickname.length > 0) {
                    if (nickname.length == 1) {
                        nickname = @"*";
                    } else if (nickname.length == 2) {
                        nickname = [NSString stringWithFormat:@"%@*", [nickname substringToIndex:1]];
                    } else {
                        nickname = [NSString stringWithFormat:@"%@***%@", [nickname substringToIndex:1], [nickname substringFromIndex:nickname.length - 1]];
                    }
                }
                NSString *giftName = dict[@"name"] ?: @"";
                NSString *fullText = [NSString stringWithFormat:@"恭喜 %@ 在寻梦之旅获得 %@", nickname, giftName];
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:fullText];
                [attrStr addAttribute:NSForegroundColorAttributeName value:mHexRGB(0xE1F5FE) range:NSMakeRange(0, fullText.length)];
                [attrStr addAttribute:NSFontAttributeName value:KFontBoldA(11) range:NSMakeRange(0, fullText.length)];
                
                NSRange nickRange = [fullText rangeOfString:nickname];
                if (nickRange.location != NSNotFound) {
                    [attrStr addAttribute:NSForegroundColorAttributeName value:mHexRGB(0xFFE66F) range:nickRange];
                }
                NSRange giftRange = [fullText rangeOfString:giftName options:NSBackwardsSearch];
                if (giftRange.location != NSNotFound) {
                    [attrStr addAttribute:NSForegroundColorAttributeName value:mHexRGB(0xFFE66F) range:giftRange];
                }
                [items addObject:attrStr];
            }
            [wself.marqueeLabel setMarqueeItems:items];
            [wself.marqueeLabel startScroll];
            [wself updateMarqueeHeight:24];
        } else {
            [wself.marqueeLabel stopScroll];
            [wself updateMarqueeHeight:0];
        }
    } failure:^(NSError *error) {
        [wself.marqueeLabel stopScroll];
        [wself updateMarqueeHeight:0];
    }];
}

- (void)renderGiftBoard {
    if (self.prizesInPool.count == 0) return;
    
    for (int i = 0; i < self.giftImageViews.count; i++) {
        UIImageView *img = self.giftImageViews[i];
        UILabel *nameLabel = self.giftNameLabels[i];
        if (i < self.prizesInPool.count) {
            MLGameDrawResultModel *prize = self.prizesInPool[i];
            NSURL *url = [NSURL URLWithString:[prize imageUrl]];
            if ([img respondsToSelector:@selector(setImageWithURL:placeholder:)]) {
                [img performSelector:@selector(setImageWithURL:placeholder:) withObject:url withObject:[UIImage imageNamed:@""]];
            } else if ([img respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
                [img performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
            }
            img.hidden = NO;
            nameLabel.text = prize.name;
            nameLabel.hidden = NO;
            nameLabel.superview.hidden = NO;
        } else {
            img.hidden = YES;
            nameLabel.hidden = YES;
            nameLabel.superview.hidden = YES;
        }
    }
}

- (void)updateBalanceUI {
    self.keyBalanceLabel.text = [NSString stringWithFormat:@"%ld", (long)self.localKeyBalance];
}

#pragma mark - 抽奖与跑马灯动画算法 (带减速步进)
- (void)drawWithTimes:(NSInteger)times cost:(NSInteger)cost {
    if (self.localKeyBalance < cost) {
        [SVProgressHUD showErrorWithStatus:@"钥匙不足，请先购买"];
        [self openPurchaseDialog];
        return;
    }
    
    self.isDrawing = YES;
    [self lockButtons:YES];
    
    // 1. 乐观扣减
    self.localKeyBalance -= cost;
    [self updateBalanceUI];
    self.lastDrawTimes = times;
    self.lastDrawCost = cost;
    
    // 2. 立即启动无限匀速跑马灯 (Loading 态)
    [self startInfiniteRotation];
    
    // 3. 执行网络发包
    WeakSelf
    [MLGameLotteryService drawWithTypeId:self.typeId times:times success:^(NSArray<MLGameDrawResultModel *> *list, NSInteger totalValue, NSInteger logId) {
        MLChatRoomThemeGameOneResultView *activeResultView = nil;
        for (UIView *sub in wself.superview.subviews) {
            if ([sub isKindOfClass:[MLChatRoomThemeGameOneResultView class]]) {
                activeResultView = (MLChatRoomThemeGameOneResultView *)sub;
                break;
            }
        }
        
        if (activeResultView) {
            [wself stopInfiniteRotation];
            [activeResultView updateGifts:list totalValue:totalValue];
            [wself lockButtons:NO];
            wself.isDrawing = NO;
            [wself loadData]; // 静默更新资产
        } else {
            // 请求成功：定位最高价礼物的终点落点
            NSInteger targetIndex = [wself findTargetStopIndexWithGifts:list];
            wself.targetStopIndex = targetIndex;
            
            // 4. 接续进入插值减速旋转
            [wself stopInfiniteRotation];
            [wself transitionToDeceleratingRotationWithTargetIndex:targetIndex success:^{
                [wself showResultWithGifts:list totalValue:totalValue logId:logId];
            }];
        }
    } failure:^(NSError *error) {
        [wself stopInfiniteRotation];
        [wself lockButtons:NO];
        wself.isDrawing = NO;
        
        // 5. 计费回滚防御
        if (error.code == NSURLErrorTimedOut) {
            [SVProgressHUD showInfoWithStatus:@"服务器繁忙，结果可能稍后到账，请去记录或背包查看"];
        } else {
            wself.localKeyBalance += cost;
            [wself updateBalanceUI];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
}

- (void)lockButtons:(BOOL)lock {
    self.drawOneButton.enabled = !lock;
    self.drawTenButton.enabled = !lock;
    self.drawHundredButton.enabled = !lock;
    self.refreshButton.enabled = !lock;
    self.exchangeButton.enabled = !lock;
}

#pragma mark - 寻找最高价值礼物索引
- (NSInteger)findTargetStopIndexWithGifts:(NSArray<MLGameDrawResultModel *> *)gifts {
    if (gifts.count == 0) return 0;
    
    // 1. 检索出 price 最大的礼物实体
    MLGameDrawResultModel *grandPrize = gifts.firstObject;
    for (MLGameDrawResultModel *item in gifts) {
        if (item.price > grandPrize.price) {
            grandPrize = item;
        }
    }
    
    // 2. 匹配在 18格奖池中对应的索引
    for (int i = 0; i < self.prizesInPool.count; i++) {
        MLGameDrawResultModel *poolItem = self.prizesInPool[i];
        if (poolItem.giftId == grandPrize.giftId) {
            return i;
        }
    }
    return 0;
}

#pragma mark - 跑马灯旋转驱动
- (void)startInfiniteRotation {
    [self stopInfiniteRotation];
    self.rotationTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(infiniteRotationStep) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.rotationTimer forMode:NSRunLoopCommonModes];
}

- (void)stopInfiniteRotation {
    if (self.rotationTimer) {
        [self.rotationTimer invalidate];
        self.rotationTimer = nil;
    }
}

- (void)infiniteRotationStep {
    NSInteger nextIdx = (self.currentStartIndex + 1) % 18;
    [self highlightGiftViewAtIndex:nextIdx];
}

- (void)transitionToDeceleratingRotationWithTargetIndex:(NSInteger)targetIndex success:(void(^)(void))completion {
    NSInteger currentIdx = self.currentStartIndex;
    NSInteger remainingSteps = (targetIndex - currentIdx + 18) % 18 + 36; // 跑 2 圈
    
    [self startDeceleratingStepWithStepIndex:0 
                                  baseIndex:currentIdx
                                 totalSteps:remainingSteps 
                               minDelayTime:0.08 
                               maxDelayTime:0.5 
                                 completion:completion];
}

- (void)startDeceleratingStepWithStepIndex:(NSInteger)step 
                                 baseIndex:(NSInteger)baseIdx
                                totalSteps:(NSInteger)totalSteps 
                              minDelayTime:(NSTimeInterval)minDelay 
                              maxDelayTime:(NSTimeInterval)maxDelay 
                                completion:(void(^)(void))completion {
    if (step >= totalSteps) {
        if (completion) completion();
        return;
    }
    
    NSInteger highlightIndex = (baseIdx + step) % 18;
    [self highlightGiftViewAtIndex:highlightIndex];
    
    NSTimeInterval nextDelay = minDelay;
    NSInteger decayStartStep = totalSteps - 10; // 倒数 10 步开始指数减速
    if (step >= decayStartStep) {
        NSInteger progress = step - decayStartStep;
        nextDelay = minDelay + (maxDelay - minDelay) * pow((double)progress / 10.0, 2.0);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(nextDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startDeceleratingStepWithStepIndex:step + 1 
                                     baseIndex:baseIdx
                                    totalSteps:totalSteps 
                                  minDelayTime:minDelay 
                                  maxDelayTime:maxDelay 
                                    completion:completion];
    });
}

- (void)highlightGiftViewAtIndex:(NSInteger)index {
    // 还原之前的卡片状态，并高亮当前的卡片 (添加高亮框或改变缩放)
    for (int i = 0; i < self.giftCardViews.count; i++) {
        UIView *card = self.giftCardViews[i];
        if (i == index) {
            card.layer.borderWidth = 2.0;
            card.layer.borderColor = mHexRGB(0x00A2FF).CGColor; // 高亮蓝色边框
            card.transform = CGAffineTransformMakeScale(1.08, 1.08);
        } else {
            card.layer.borderWidth = 0.0;
            card.transform = CGAffineTransformIdentity;
        }
    }
    self.currentStartIndex = index;
}

- (void)showResultWithGifts:(NSArray<MLGameDrawResultModel *> *)gifts totalValue:(NSInteger)totalValue logId:(NSInteger)logId {
    self.pendingGifts = gifts;
    self.pendingTotalValue = totalValue;
    
    [self lockButtons:NO];
    self.isDrawing = NO;
    
    if (self.svgaPlayer == nil) {
        self.svgaPlayer = [[SVGAPlayer alloc] initWithFrame:self.bounds];
        self.svgaPlayer.loops = 1;
        self.svgaPlayer.delegate = self;
        [self addSubview:self.svgaPlayer];
    }
    self.svgaPlayer.hidden = NO;
    
    SVGAParser *parser = [[SVGAParser alloc] init];
    NSURL *svgaURL = [[NSBundle mainBundle] URLForResource:@"theme_game_one_draw" withExtension:@"svga"];
    if (svgaURL) {
        WeakSelf
        [parser parseWithURL:svgaURL completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            wself.svgaPlayer.videoItem = videoItem;
            [wself.svgaPlayer startAnimation];
        } failureBlock:^(NSError * _Nonnull error) {
            wself.svgaPlayer.hidden = YES;
            [wself realShowResult];
        }];
    } else {
        self.svgaPlayer.hidden = YES;
        [self realShowResult];
    }
    
    [self loadData];
}

- (void)realShowResult {
    WeakSelf
    [MLChatRoomThemeGameOneResultView showInView:self.superview 
                                           gifts:self.pendingGifts 
                                      totalValue:self.pendingTotalValue 
                                      retryBlock:^{
        [wself drawWithTimes:wself.lastDrawTimes cost:wself.lastDrawCost];
    }];
}

#pragma mark - SVGAPlayerDelegate
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    player.hidden = YES;
    [self realShowResult];
}

#pragma mark - 点击事件
- (void)drawOneClick {
    [self drawWithTimes:1 cost:200];
}

- (void)drawTenClick {
    [self drawWithTimes:10 cost:2000];
}

- (void)drawHundredClick {
    [self drawWithTimes:100 cost:20000];
}

- (void)refreshPoolClick {
    self.refreshButton.enabled = NO;
    [MLGameLotteryService refreshPoolWithTypeId:self.typeId success:^(NSArray<MLGameDrawResultModel *> *list, NSInteger diamondCost, NSString *newDiamondBalance) {
        self.refreshButton.enabled = YES;
        self.prizesInPool = list;
        [self renderGiftBoard];
        [SVProgressHUD showSuccessWithStatus:@"已更新奖池"];
    } failure:^(NSError *error) {
        self.refreshButton.enabled = YES;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)ruleClick {
    [MLChatRoomThemeGameOneRuleView showInView:self.superview];
}

- (void)recordClick {
    [MLChatRoomThemeGameOneRecordView showInView:self.superview typeId:self.typeId];
}

- (void)fortuneClick {
    [MLChatRoomThemeGameFortuneView showInView:self.superview consume:self.consumeValue produce:self.produceValue];
}

- (void)exchangeClick {
    [MLChatRoomThemeGameOneExchangeView showInView:self.superview typeId:self.typeId];
}

- (void)openPurchaseDialog {
    WeakSelf
    [MLChatRoomThemeGameOnePurchaseView showInView:self.superview infoModel:self.infoModel purchaseSuccess:^(NSInteger newKeyBalance) {
        wself.localKeyBalance = newKeyBalance;
        [wself updateBalanceUI];
    }];
}

- (void)plusClick {
    UIViewController *curVC = [UIViewController currentViewController];
    if (curVC) {
        CFMWalletDiamondRechargeVc *re = [[CFMWalletDiamondRechargeVc alloc] init];
        re.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        WeakSelf
        re.dismissBlock = ^{
            [wself loadData];
        };
        [curVC presentViewController:re animated:NO completion:nil];
    }
}

- (void)backClick {
    if (self.isDrawing) {
        return; // 抽奖期间屏蔽返回按钮
    }
    [self dismiss];
}

- (void)handleMaskTap:(UITapGestureRecognizer *)sender {
    if (self.isDrawing) {
        return; // 抽奖期间屏蔽 Dismiss 蒙层点击
    }
    [self dismiss];
}

- (void)animateShow {
    self.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    
    // 恢复全局最小化悬浮球
    // 恢复全局最小化悬浮球
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.roomViewController && appDelegate.roomViewController.floatingWindow) {
        appDelegate.roomViewController.floatingWindow.hidden = NO;
    }
}

@end
