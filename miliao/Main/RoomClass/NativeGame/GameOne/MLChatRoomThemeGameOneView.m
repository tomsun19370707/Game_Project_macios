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

@property (nonatomic, strong) UIView *topContainer;
@property (nonatomic, strong) UIView *middleContainer;
@property (nonatomic, strong) UIView *bottomContainer;

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
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
@property (nonatomic, strong) UIImageView *luckyProgressBar;
@property (nonatomic, assign) NSInteger dreamValue;

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
// 18个格子上的奖品价格 Label
@property (nonatomic, strong) NSMutableArray<UILabel *> *giftPriceLabels;

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
        self.typeId = typeId > 0 ? typeId : 11;
        self.isDrawing = NO;
        self.currentStartIndex = 0;
        self.giftCardViews = [NSMutableArray array];
        self.giftImageViews = [NSMutableArray array];
        self.giftNameLabels = [NSMutableArray array];
        self.giftPriceLabels = [NSMutableArray array];
        
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
    
    // 背景大图 (锁定 740:1136 比例，在宽屏设备上限宽 390 pt，底部贴齐屏幕底部，防拉伸与漂移)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_one_clean_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        if (isPadA) {
            make.width.mas_equalTo(390);
        } else {
            make.width.mas_equalTo(self);
        }
        make.height.mas_equalTo(_bgImageView.mas_width).multipliedBy(1136.0 / 740.0);
    }];
    
    // SVGAPlayer 动效图层 (咬合背景图层，处于背景图最底层，其他按钮和卡片控件之下)
    self.svgaPlayer = [[SVGAPlayer alloc] init];
    self.svgaPlayer.loops = 0; // 无限循环播放
    self.svgaPlayer.contentMode = UIViewContentModeScaleAspectFit;
    self.svgaPlayer.hidden = YES;
    [_bgImageView addSubview:self.svgaPlayer];
    [self.svgaPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_bgImageView);
    }];
    
    // 异步预解析 SVGA 动画数据，避免抽奖点击时延迟
    SVGAParser *parser = [[SVGAParser alloc] init];
    NSURL *svgaURL = [[NSBundle mainBundle] URLForResource:@"theme_game_one_draw" withExtension:@"svga"];
    if (svgaURL) {
        WeakSelf
        [parser parseWithURL:svgaURL completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            if (wself) {
                wself.svgaPlayer.videoItem = videoItem;
            }
        } failureBlock:nil];
    }
    
    // --- 容器初始化与布局对齐 ---
    
    // 1. 顶部容器 (高度占 100 pt)
    _topContainer = [[UIView alloc] init];
    _topContainer.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:_topContainer];
    [_topContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(_bgImageView);
        make.height.mas_equalTo(KDialogAdaptedWidth(100));
    }];
    
    // 2. 底部容器 (高度占 180 pt)
    _bottomContainer = [[UIView alloc] init];
    _bottomContainer.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:_bottomContainer];
    [_bottomContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(_bgImageView);
        make.height.mas_equalTo(KDialogAdaptedWidth(180));
    }];
    
    // 3. 中部核心游戏容器 (填充剩余高度)
    _middleContainer = [[UIView alloc] init];
    _middleContainer.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:_middleContainer];
    [_middleContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topContainer.mas_bottom);
        make.bottom.mas_equalTo(_bottomContainer.mas_top);
        make.leading.trailing.mas_equalTo(_bgImageView);
    }];
    
    // --- 顶部容器子控件布局 ---
    
    // 记录按钮 (位于左上角, 宽 63, 高 26，改用背景图拉伸)
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_record_btn_brighter"] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
    [_topContainer addSubview:_recordButton];
    [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(16));
        make.leading.mas_equalTo(KDialogAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(63), KDialogAdaptedWidth(26)));
    }];
    
    // 规则按钮 (位于右上角, 宽 63, 高 26，改用背景图拉伸)
    _ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ruleButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_rule_btn_brighter"] forState:UIControlStateNormal];
    [_ruleButton addTarget:self action:@selector(ruleClick) forControlEvents:UIControlEventTouchUpInside];
    [_topContainer addSubview:_ruleButton];
    [_ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(16));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(63), KDialogAdaptedWidth(26)));
    }];
    
    // 今日运势悬浮条 (宽 70, 高 30. 悬浮在右上角外侧)
    UIView *fortuneBar = [[UIView alloc] init];
    fortuneBar.userInteractionEnabled = YES;
    [self addSubview:fortuneBar];
    
    CGFloat fortuneW = KDialogAdaptedWidth(70.0f);
    CGFloat fortuneH = KDialogAdaptedWidth(30.0f);
    [fortuneBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_bgImageView.mas_top).offset(-KDialogAdaptedWidth(6));
        make.trailing.mas_equalTo(_bgImageView.mas_trailing).offset(-KDialogAdaptedWidth(12));
        make.size.mas_equalTo(CGSizeMake(fortuneW, fortuneH));
    }];
    
    // 原生渐变背景 (#2A6CEE -> #1044BB)
    CAGradientLayer *fortuneGrad = [CAGradientLayer layer];
    fortuneGrad.frame = CGRectMake(0, 0, fortuneW, fortuneH);
    fortuneGrad.colors = @[(__bridge id)mHexRGB(0x2A6CEE).CGColor, (__bridge id)mHexRGB(0x1044BB).CGColor];
    fortuneGrad.startPoint = CGPointMake(0.5, 0);
    fortuneGrad.endPoint = CGPointMake(0.5, 1);
    fortuneGrad.cornerRadius = KDialogAdaptedWidth(15.0f);
    [fortuneBar.layer addSublayer:fortuneGrad];
    
    // 金色边框和圆角
    fortuneBar.layer.borderColor = mHexRGB(0xFFE57F).CGColor;
    fortuneBar.layer.borderWidth = 1.5;
    fortuneBar.layer.cornerRadius = KDialogAdaptedWidth(15.0f);
    fortuneBar.clipsToBounds = YES;
    
    UITapGestureRecognizer *fortuneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fortuneClick)];
    [fortuneBar addGestureRecognizer:fortuneTap];
    
    UILabel *fortuneLabel = [[UILabel alloc] init];
    fortuneLabel.text = @"今日运势";
    fortuneLabel.textColor = kWhiteColor;
    fortuneLabel.font = [UIFont boldSystemFontOfSize:11];
    fortuneLabel.textAlignment = NSTextAlignmentCenter;
    [fortuneBar addSubview:fortuneLabel];
    [fortuneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(fortuneBar);
    }];
    
    // 全服中奖轮播跑马灯 (水平居中, 距顶部 62 pt. 高度默认为 0 隐蔽)
    _marqueeLabel = [[MLChatRoomMarqueeLabel alloc] init];
    _marqueeLabel.backgroundColor = [UIColor clearColor];
    [_topContainer addSubview:_marqueeLabel];
    
    WeakSelf
    [_marqueeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(55));
        make.leading.mas_equalTo(KDialogAdaptedWidth(24));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(24));
        wself.marqueeHeightConstraint = make.height.mas_equalTo(0);
    }];
    
    // --- 中部容器子控件布局 ---
    
    // 18 宫格礼物卡片环形布局容器 (宽 332, 高 354 pt, 中轴线下移 12 pt 以防头部拥挤，高度缩小拉近纵向间距)
    UIView *cardsContainer = [[UIView alloc] init];
    [_middleContainer addSubview:cardsContainer];
    [cardsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_middleContainer);
        make.centerY.mas_equalTo(_middleContainer).offset(KDialogAdaptedWidth(12));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(332), KDialogAdaptedWidth(354)));
    }];
    
    [self layout18GiftCardsInContainer:cardsContainer];
    
    // 钻石余额条 (高 20 pt, 宽 82 pt. 整个区域作为可点击按钮以增加点击热区)
    UIButton *diamondBar = [UIButton buttonWithType:UIButtonTypeCustom];
    diamondBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [diamondBar addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
    setViewCorner(diamondBar, 10); // 10 pt 圆角 (一半高度)
    [cardsContainer addSubview:diamondBar];
    [diamondBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(72));
        make.centerX.mas_equalTo(cardsContainer.mas_centerX).offset(-KDialogAdaptedWidth(48));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(82), KDialogAdaptedWidth(20)));
    }];
    
    // 钻石图标 (14 * 14 pt)
    UIImageView *diaIcon = [[UIImageView alloc] init];
    diaIcon.image = [UIImage imageNamed:@"theme_game_one_cover_diamond"];
    [diamondBar addSubview:diaIcon];
    [diaIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(7));
        make.centerY.mas_equalTo(diamondBar);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(14), KDialogAdaptedWidth(14)));
    }];
    
    _diamondBalanceLabel = [[UILabel alloc] init];
    _diamondBalanceLabel.textColor = kWhiteColor;
    _diamondBalanceLabel.font = [UIFont boldSystemFontOfSize:10];
    _diamondBalanceLabel.text = @"0";
    [diamondBar addSubview:_diamondBalanceLabel];
    [_diamondBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(diaIcon.mas_trailing).offset(KDialogAdaptedWidth(2));
        make.centerY.mas_equalTo(diamondBar);
    }];
    
    _diamondPlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_diamondPlusButton setImage:[UIImage imageNamed:@"theme_game_one_plus_icon"] forState:UIControlStateNormal];
    _diamondPlusButton.userInteractionEnabled = NO; // 禁止直接接收事件，交由父容器按钮响应
    [diamondBar addSubview:_diamondPlusButton];
    [_diamondPlusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(6));
        make.centerY.mas_equalTo(diamondBar);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(14), KDialogAdaptedWidth(14)));
    }];
    
    // 钥匙余额条 (高 20 pt, 宽 82 pt. 整个区域作为可点击按钮以增加点击热区)
    UIButton *keyBar = [UIButton buttonWithType:UIButtonTypeCustom];
    keyBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [keyBar addTarget:self action:@selector(openPurchaseDialog) forControlEvents:UIControlEventTouchUpInside];
    setViewCorner(keyBar, 10); // 10 pt 圆角
    [cardsContainer addSubview:keyBar];
    [keyBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(72));
        make.centerX.mas_equalTo(cardsContainer.mas_centerX).offset(KDialogAdaptedWidth(48));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(82), KDialogAdaptedWidth(20)));
    }];
    
    // 钥匙图标 (14 * 14 pt)
    UIImageView *keyIcon = [[UIImageView alloc] init];
    keyIcon.image = [UIImage imageNamed:@"theme_game_one_cover_key"];
    [keyBar addSubview:keyIcon];
    [keyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(7));
        make.centerY.mas_equalTo(keyBar);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(14), KDialogAdaptedWidth(14)));
    }];
    
    _keyBalanceLabel = [[UILabel alloc] init];
    _keyBalanceLabel.textColor = kWhiteColor;
    _keyBalanceLabel.font = [UIFont boldSystemFontOfSize:10];
    _keyBalanceLabel.text = @"0";
    [keyBar addSubview:_keyBalanceLabel];
    [_keyBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(keyIcon.mas_trailing).offset(KDialogAdaptedWidth(2));
        make.centerY.mas_equalTo(keyBar);
    }];
    
    _keyPlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_keyPlusButton setImage:[UIImage imageNamed:@"theme_game_one_plus_icon"] forState:UIControlStateNormal];
    _keyPlusButton.userInteractionEnabled = NO; // 禁止直接接收事件，交由父容器按钮响应
    [keyBar addSubview:_keyPlusButton];
    [_keyPlusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(6));
        make.centerY.mas_equalTo(keyBar);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(14), KDialogAdaptedWidth(14)));
    }];
    
    // 底部寻梦值进度条 (使用 UIImageView 完美加载背景底图，高 23 pt，解决被压扁问题)
    _luckyProgressBar = [[UIImageView alloc] init];
    _luckyProgressBar.image = [UIImage imageNamed:@"theme_game_one_dream_bar"];
    _luckyProgressBar.contentMode = UIViewContentModeScaleToFill;
    [cardsContainer addSubview:_luckyProgressBar];
    [_luckyProgressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(cardsContainer);
        make.bottom.mas_equalTo(cardsContainer.mas_bottom).offset(-KDialogAdaptedWidth(105));
        make.width.mas_equalTo(KDialogAdaptedWidth(164));
        make.height.mas_equalTo(KDialogAdaptedWidth(23));
    }];
    
    _luckyTextLabel = [[UILabel alloc] init];
    _luckyTextLabel.textColor = kWhiteColor;
    _luckyTextLabel.font = [UIFont boldSystemFontOfSize:10];
    _luckyTextLabel.text = @"寻梦值: 0/200";
    [cardsContainer addSubview:_luckyTextLabel];
    [_luckyTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_luckyProgressBar);
        make.centerY.mas_equalTo(_luckyProgressBar);
    }];
    
    // 寻梦值提示文本
    UILabel *luckyTipLabel = [[UILabel alloc] init];
    luckyTipLabel.textColor = mHexRGB(0xF1F7FF);
    luckyTipLabel.font = [UIFont boldSystemFontOfSize:10];
    luckyTipLabel.textAlignment = NSTextAlignmentCenter;
    luckyTipLabel.numberOfLines = 2;
    luckyTipLabel.text = @"寻梦值达到200后\n下次必出500钻石及以上物品";
    [cardsContainer addSubview:luckyTipLabel];
    [luckyTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(cardsContainer);
        make.top.mas_equalTo(_luckyProgressBar.mas_bottom).offset(KDialogAdaptedWidth(4));
    }];
    
    // --- 底部操作及抽奖控制布局 ---
    
    // 底部“一/十/百”连横排抽奖按钮组 (三次收缩并放大：高 48 pt, 宽 96 pt，改用背景图以实现图片真实拉伸)
    _drawTenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawTenButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_draw_ten"] forState:UIControlStateNormal];
    [_drawTenButton addTarget:self action:@selector(drawTenClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomContainer addSubview:_drawTenButton];
    [_drawTenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bottomContainer);
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(33));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(96), KDialogAdaptedWidth(48)));
    }];
    
    _drawOneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawOneButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_draw_one"] forState:UIControlStateNormal];
    [_drawOneButton addTarget:self action:@selector(drawOneClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomContainer addSubview:_drawOneButton];
    [_drawOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(_drawTenButton.mas_leading).offset(-KDialogAdaptedWidth(14));
        make.centerY.mas_equalTo(_drawTenButton);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(96), KDialogAdaptedWidth(48)));
    }];
    
    _drawHundredButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawHundredButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_draw_hundred"] forState:UIControlStateNormal];
    [_drawHundredButton addTarget:self action:@selector(drawHundredClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomContainer addSubview:_drawHundredButton];
    [_drawHundredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_drawTenButton.mas_trailing).offset(KDialogAdaptedWidth(14));
        make.centerY.mas_equalTo(_drawTenButton);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(96), KDialogAdaptedWidth(48)));
    }];
    
    // 刷新奖池按钮 (高 22 pt, 宽 149 pt, 抬高 10 pt 以紧凑排版)
    _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_refreshButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_refresh_free_bar_origin"] forState:UIControlStateNormal];
    [_refreshButton addTarget:self action:@selector(refreshPoolClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomContainer addSubview:_refreshButton];
    [_refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_drawTenButton.mas_top).offset(-KDialogAdaptedWidth(25));
        make.leading.mas_equalTo(cardsContainer.mas_leading).offset(-KDialogAdaptedWidth(6));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(149), KDialogAdaptedWidth(22)));
    }];
    
    // 刷新小图标
    UIImageView *refreshIcon = [[UIImageView alloc] init];
    refreshIcon.image = [UIImage imageNamed:@"theme_game_one_refresh_btn"];
    refreshIcon.userInteractionEnabled = NO;
    [_refreshButton addSubview:refreshIcon];
    [refreshIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(3));
        make.centerY.mas_equalTo(_refreshButton);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(15), KDialogAdaptedWidth(15)));
    }];
    
    // “刷新奖池”文字
    UILabel *refreshTextLabel = [[UILabel alloc] init];
    refreshTextLabel.text = @"刷新奖池";
    refreshTextLabel.textColor = mHexRGB(0xF3FAFF);
    refreshTextLabel.font = [UIFont boldSystemFontOfSize:11.5];
    refreshTextLabel.userInteractionEnabled = NO;
    [_refreshButton addSubview:refreshTextLabel];
    [refreshTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(refreshIcon.mas_trailing).offset(KDialogAdaptedWidth(5));
        make.centerY.mas_equalTo(_refreshButton);
    }];
    
    // “本次刷新免费”提示文字
    UILabel *refreshFreeLabel = [[UILabel alloc] init];
    refreshFreeLabel.text = @"本次刷新免费";
    refreshFreeLabel.textColor = mHexRGB(0xF3FAFF);
    refreshFreeLabel.font = [UIFont boldSystemFontOfSize:11.5];
    refreshFreeLabel.userInteractionEnabled = NO;
    [_refreshButton addSubview:refreshFreeLabel];
    [refreshFreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(refreshTextLabel.mas_trailing).offset(KDialogAdaptedWidth(5));
        make.centerY.mas_equalTo(_refreshButton);
    }];
    
    // 藏宝图兑换按钮 (八次收缩：高 23 pt, 宽 125 pt，改用背景图拉伸)
    _exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_exchangeButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_exchange_btn"] forState:UIControlStateNormal];
    [_exchangeButton addTarget:self action:@selector(exchangeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomContainer addSubview:_exchangeButton];
    [_exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_refreshButton);
        make.trailing.mas_equalTo(cardsContainer.mas_trailing);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(125), KDialogAdaptedWidth(23)));
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
    // 宽 52，高 70。水平步长 56.0，垂直步长 71.0 pt (高精度比例还原，缩小纵向间距以防散架)
    CGFloat cardW = KDialogAdaptedWidth(52.0f);
    CGFloat cardH = KDialogAdaptedWidth(70.0f);
    CGFloat stepX = KDialogAdaptedWidth(56.0f);
    CGFloat stepY = KDialogAdaptedWidth(71.0f);
    
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
            make.edges.mas_equalTo(card).insets(UIEdgeInsetsMake(KDialogAdaptedWidth(2), KDialogAdaptedWidth(4), KDialogAdaptedWidth(20), KDialogAdaptedWidth(4)));
        }];
        [self.giftImageViews addObject:giftImg];
        
        // 卡片底部文字区域容器
        UIView *textContainer = [[UIView alloc] init];
        textContainer.backgroundColor = [UIColor clearColor];
        [card addSubview:textContainer];
        [textContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.mas_equalTo(card);
            make.height.mas_equalTo(KDialogAdaptedWidth(20));
        }];
        
        // 第二行：价格标签 (自底向上对齐，避免偏下超出格子边缘)
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.font = [UIFont systemFontOfSize:7.5];
        priceLabel.textColor = mHexRGB(0xFFE66F);
        priceLabel.textAlignment = NSTextAlignmentCenter;
        [textContainer addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-KDialogAdaptedWidth(2));
            make.leading.trailing.mas_equalTo(textContainer);
        }];
        [self.giftPriceLabels addObject:priceLabel];
        
        // 第一行：名称标签 (基于价格标签向上偏移)
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont boldSystemFontOfSize:8.5];
        nameLabel.textColor = mHexRGB(0xE6EAFE);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [textContainer addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(priceLabel.mas_top).offset(-KDialogAdaptedWidth(1));
            make.leading.trailing.mas_equalTo(textContainer);
        }];
        [self.giftNameLabels addObject:nameLabel];
        
        // 6x5 环状排布，顺时针成环 (ConstraintLayout 百分比高精度平移模型还原)：
        if (i < 6) {
            // 顶部横排 (col = 0..5, row = 0)
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.leading.mas_equalTo(i * stepX);
                make.size.mas_equalTo(CGSizeMake(cardW, cardH));
            }];
        } else if (i < 9) {
            // 右侧竖排 (col = 5, row = 1..3)
            int row = i - 5;
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(row * stepY);
                make.trailing.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(cardW, cardH));
            }];
        } else if (i < 15) {
            // 底部横排 (col = 5..0, row = 4)
            int col = 14 - i;
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(KDialogAdaptedWidth(284.0f)); // 4 * 71.0 pt
                make.leading.mas_equalTo(col * stepX);
                make.size.mas_equalTo(CGSizeMake(cardW, cardH));
            }];
        } else {
            // 左侧竖排 (col = 0, row = 3..1)
            int row = 18 - i;
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(row * stepY);
                make.leading.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(cardW, cardH));
            }];
        }
    }
}

#pragma mark - 数据请求
- (void)fetchUserAssets {
    WeakSelf
    // 1. 获取个人资产
    [MLGameLotteryService getUserMoneyWithSuccess:^(MLGameUserMoneyModel *moneyModel) {
        if (!wself) return;
        if (!moneyModel || moneyModel == (id)[NSNull null] || ![moneyModel isKindOfClass:[MLGameUserMoneyModel class]]) {
            return;
        }
        id diamondVal = moneyModel.diamond;
        double diamondDouble = 0.0;
        if (diamondVal && diamondVal != [NSNull null]) {
            diamondDouble = [diamondVal doubleValue];
        }
        wself.diamondBalanceLabel.text = MLFormatLargeNumber(diamondDouble);
        wself.localKeyBalance = moneyModel.lottery_coin;
        wself.keyBalanceLabel.text = MLFormatLargeNumber((double)wself.localKeyBalance);
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)loadData {
    [self fetchUserAssets];
    WeakSelf
    
    // 2. 详情、消耗档位 (寻梦值背景底图为静态 ImageView，仅更新文字，无 Progress 控制)
    [MLGameLotteryService getRoomDetailWithTypeId:self.typeId success:^(MLGameLotteryInfoModel *model) {
        if (!wself) return;
        if (!model || model == (id)[NSNull null] || ![model isKindOfClass:[MLGameLotteryInfoModel class]]) {
            return;
        }
        wself.infoModel = model;
        if (model.lucky > 0 || wself.dreamValue == 0) {
            wself.dreamValue = model.lucky;
        }
        wself.luckyTextLabel.text = [NSString stringWithFormat:@"寻梦值: %ld/200", (long)wself.dreamValue];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 3. 18 格奖池礼物列表与寻梦值初始化
    [MLGameLotteryService getPrizesWithTypeId:self.typeId successWithInfo:^(NSArray<MLGameDrawResultModel *> *list, NSInteger luckyValue, NSInteger luckyLimit) {
        if (!wself) return;
        if (luckyValue >= 0) {
            wself.dreamValue = luckyValue;
            NSInteger limit = luckyLimit > 0 ? luckyLimit : 200;
            wself.luckyTextLabel.text = [NSString stringWithFormat:@"寻梦值: %ld/%ld", (long)wself.dreamValue, (long)limit];
        }
        if (list && [list isKindOfClass:[NSArray class]]) {
            wself.prizesInPool = list;
            [wself renderGiftBoard];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 4. 获取今日运势数据 (对接 typeId == 3 / lottery_id == 7)
    [MLGameLotteryService getFortuneLotteryListWithSuccess:^(NSArray<MLGameLotteryInfoModel *> *list) {
        if (!wself) return;
        if (!list || ![list isKindOfClass:[NSArray class]]) {
            return;
        }
        for (MLGameLotteryInfoModel *model in list) {
            if (model.typeId == wself.typeId || [model.name containsString:@"寻梦"]) {
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
        if (!wself) return;
        if (!list || ![list isKindOfClass:[NSArray class]]) {
            return;
        }
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
        if (!wself) return;
        [wself.marqueeLabel stopScroll];
        [wself updateMarqueeHeight:0];
    }];
}

- (void)renderGiftBoard {
    if (self.prizesInPool.count == 0) return;
    
    for (int i = 0; i < self.giftImageViews.count; i++) {
        UIImageView *img = self.giftImageViews[i];
        UILabel *nameLabel = self.giftNameLabels[i];
        UILabel *priceLabel = self.giftPriceLabels[i];
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
            priceLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)prize.price];
            priceLabel.hidden = NO;
            nameLabel.superview.hidden = NO;
        } else {
            img.hidden = YES;
            nameLabel.hidden = YES;
            priceLabel.hidden = YES;
            nameLabel.superview.hidden = YES;
        }
    }
}

- (void)updateBalanceUI {
    self.keyBalanceLabel.text = MLFormatLargeNumber((double)self.localKeyBalance);
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
    
    // 判断抽奖前是否已处于 >= 200 的保底满额状态
    BOOL isGuarantee = (self.dreamValue >= 200);
    if (isGuarantee) {
        // 抽奖前已达到/超过 200，本次抽奖触发保底大奖，抽完后清零重置为 0
        self.dreamValue = 0;
    } else {
        // 未达保底，正常真实累加（如 121 + 100 = 221）
        self.dreamValue += times;
    }
    
    if (self.infoModel) {
        self.infoModel.lucky = self.dreamValue;
    }
    self.luckyTextLabel.text = [NSString stringWithFormat:@"寻梦值: %ld/200", (long)self.dreamValue];
    
    // 显示并启动 SVGA 循环播放动效
    self.svgaPlayer.hidden = NO;
    [self.svgaPlayer startAnimation];
    
    // 2. 立即启动无限匀速跑马灯 (Loading 态)
    [self startInfiniteRotation];
    
    // 3. 执行网络发包
    WeakSelf
    [MLGameLotteryService drawWithTypeId:self.typeId times:times successResponse:^(NSArray<MLGameDrawResultModel *> *list, NSInteger totalValue, NSInteger logId, MLGameDrawResponseModel * _Nullable responseModel) {
        if (!wself) return;
        
        // 实时同步服务端保底与寻梦值字段
        BOOL guaranteeTriggered = NO;
        if (responseModel) {
            guaranteeTriggered = (responseModel.guarantee_triggered == 1 || [responseModel.is_guarantee isEqualToString:@"1"] || [responseModel.is_guarantee.lowercaseString isEqualToString:@"true"]);
            if (guaranteeTriggered) {
                [SVProgressHUD showSuccessWithStatus:@"恭喜触发【寻梦保底】！"];
            }
            NSInteger luckyLimitVal = responseModel.lucky_limit > 0 ? responseModel.lucky_limit : 200;
            if (responseModel.lucky_value > 0 || guaranteeTriggered) {
                wself.dreamValue = responseModel.lucky_value;
            }
            wself.luckyTextLabel.text = [NSString stringWithFormat:@"寻梦值: %ld/%ld", (long)wself.dreamValue, (long)luckyLimitVal];
        }
        
        MLChatRoomThemeGameOneResultView *activeResultView = nil;
        for (UIView *sub in wself.superview.subviews) {
            if ([sub isKindOfClass:[MLChatRoomThemeGameOneResultView class]]) {
                activeResultView = (MLChatRoomThemeGameOneResultView *)sub;
                break;
            }
        }
        
        if (activeResultView) {
            [wself stopInfiniteRotation];
            if (wself.svgaPlayer) {
                [wself.svgaPlayer stopAnimation];
                wself.svgaPlayer.hidden = YES;
            }
            [activeResultView updateGifts:list totalValue:totalValue];
            [wself lockButtons:NO];
            wself.isDrawing = NO;
            [wself fetchUserAssets]; // 静默更新个人资产余额
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
        
        if (wself.svgaPlayer) {
            [wself.svgaPlayer stopAnimation];
            wself.svgaPlayer.hidden = YES;
        }
        
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
    
    if (self.svgaPlayer) {
        [self.svgaPlayer stopAnimation];
        self.svgaPlayer.hidden = YES;
    }
    
    [self realShowResult];
    [self fetchUserAssets];
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

- (void)getDrawConfigAtIndex:(NSInteger)index defaultTimes:(NSInteger)defaultTimes defaultCost:(NSInteger)defaultCost times:(NSInteger *)outTimes cost:(NSInteger *)outCost {
    if (self.infoModel && self.infoModel.coin_cost_opt.count > index) {
        MLGameLotteryOptModel *opt = self.infoModel.coin_cost_opt[index];
        if (outTimes) *outTimes = opt.nums;
        if (outCost) *outCost = opt.coin_cost;
    } else {
        if (outTimes) *outTimes = defaultTimes;
        if (outCost) *outCost = defaultCost;
    }
}

#pragma mark - 点击事件
- (void)drawOneClick {
    NSInteger times, cost;
    [self getDrawConfigAtIndex:0 defaultTimes:1 defaultCost:200 times:&times cost:&cost];
    [self drawWithTimes:times cost:cost];
}

- (void)drawTenClick {
    NSInteger times, cost;
    [self getDrawConfigAtIndex:1 defaultTimes:10 defaultCost:2000 times:&times cost:&cost];
    [self drawWithTimes:times cost:cost];
}

- (void)drawHundredClick {
    NSInteger times, cost;
    [self getDrawConfigAtIndex:2 defaultTimes:100 defaultCost:20000 times:&times cost:&cost];
    [self drawWithTimes:times cost:cost];
}

- (void)refreshPoolClick {
    self.refreshButton.enabled = NO;
    WeakSelf
    [MLGameLotteryService refreshPoolWithTypeId:self.typeId successWithInfo:^(NSArray<MLGameDrawResultModel *> *list, NSInteger diamondCost, NSString *newDiamondBalance, NSInteger luckyValue, NSInteger luckyLimit) {
        if (!wself) return;
        wself.refreshButton.enabled = YES;
        if (luckyValue >= 0) {
            wself.dreamValue = luckyValue;
            NSInteger limit = luckyLimit > 0 ? luckyLimit : 200;
            wself.luckyTextLabel.text = [NSString stringWithFormat:@"寻梦值: %ld/%ld", (long)wself.dreamValue, (long)limit];
        }
        wself.prizesInPool = list;
        [wself renderGiftBoard];
        [SVProgressHUD showSuccessWithStatus:@"已更新奖池"];
    } failure:^(NSError *error) {
        if (!wself) return;
        wself.refreshButton.enabled = YES;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)ruleClick {
    [MLChatRoomThemeGameOneRuleView showInView:self.superview ruleContent:self.infoModel.content];
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
        WeakSelf
        self.hidden = YES;
        re.dismissBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(wself) strongSelf = wself;
                if (strongSelf) {
                    strongSelf.hidden = NO;
                    [strongSelf loadData];
                }
            });
        };
        if (curVC.navigationController) {
            [curVC.navigationController pushViewController:re animated:YES];
        } else {
            re.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [curVC presentViewController:re animated:NO completion:nil];
        }
    }
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
