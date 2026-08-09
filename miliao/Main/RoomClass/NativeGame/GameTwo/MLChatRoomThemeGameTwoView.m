#import "MLChatRoomThemeGameTwoView.h"
#import "MLGameLotteryService.h"
#import "RoomFloatingWindow.h"
#import "AppDelegate.h"
#import "MLChatRoomThemeGameTwoResultView.h"
#import "MLChatRoomThemeGameTwoGiftView.h"
#import "MLChatRoomThemeGameOneResultView.h"
#import "MLChatRoomThemeGameTwoRuleView.h"
#import "MLChatRoomThemeGameTwoRecordView.h"
#import "MLChatRoomThemeGameTwoPurchaseView.h"
#import "MLChatRoomThemeGameTwoFortuneView.h"
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

@interface MLChatRoomThemeGameTwoView ()

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIButton *ruleButton;
@property (nonatomic, strong) UIButton *recordButton;

@property (nonatomic, strong) UILabel *keyBalanceLabel;
@property (nonatomic, strong) UIButton *keyPlusButton;
@property (nonatomic, strong) UIButton *keyBar;
@property (nonatomic, strong) UILabel *diamondBalanceLabel;
@property (nonatomic, strong) UIButton *diamondPlusButton;
@property (nonatomic, strong) UIButton *diamondBar;

@property (nonatomic, strong) UIButton *drawOneButton;
@property (nonatomic, strong) UIButton *drawTenButton;
@property (nonatomic, strong) UIButton *drawHundredButton;

@property (nonatomic, strong) NSMutableArray<UIView *> *peachCardViews;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *peachFrameImageViews;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *peachGlowImageViews;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *peachImageViews;

@property (nonatomic, strong) MLGameLotteryInfoModel *infoModel;
@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *prizeList;

@property (nonatomic, assign) BOOL isDrawing;
@property (nonatomic, assign) NSInteger localKeyBalance;
@property (nonatomic, assign) NSInteger lastDrawTimes;
@property (nonatomic, assign) NSInteger lastDrawCost;

// SVGA 播放器与临时存储
@property (nonatomic, strong) SVGAPlayer *svgaPlayer;
@property (nonatomic, strong) SVGAVideoEntity *cachedVideoItem;
@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *pendingGifts;
@property (nonatomic, assign) NSInteger pendingTotalValue;
@property (nonatomic, assign) NSInteger consumeValue;
@property (nonatomic, assign) NSInteger produceValue;

@property (nonatomic, strong) UIView *hudContainer;
@property (nonatomic, strong) UIView *gameplayContainer;
@property (nonatomic, strong) UIView *actionContainer;
@property (nonatomic, strong) UILabel *fortuneLabel;

// CADisplayLink 单摆驱动
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@interface MLChatRoomThemeGameTwoView () <SVGAPlayerDelegate>
@end

@implementation MLChatRoomThemeGameTwoView

+ (void)showInView:(UIView *)parentView typeId:(NSInteger)typeId {
    MLChatRoomThemeGameTwoView *gameView = [[MLChatRoomThemeGameTwoView alloc] initWithFrame:parentView.bounds typeId:typeId];
    [parentView addSubview:gameView];
    [gameView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame typeId:(NSInteger)typeId {
    if (self = [super initWithFrame:frame]) {
        self.typeId = typeId > 0 ? typeId : 12;
        self.isDrawing = NO;
        self.localKeyBalance = 0;
        self.consumeValue = 0;
        self.produceValue = 0;
        self.peachCardViews = [NSMutableArray array];
        self.peachFrameImageViews = [NSMutableArray array];
        self.peachGlowImageViews = [NSMutableArray array];
        self.peachImageViews = [NSMutableArray array];
        [self setupUI];
        [self loadData];
        [self preloadSVGAAnimation];
        
        // 隐藏语音悬浮窗
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.roomViewController && appDelegate.roomViewController.floatingWindow) {
            appDelegate.roomViewController.floatingWindow.hidden = YES;
        }
    }
    return self;
}

#pragma mark - SVGA 预加载与常驻背景播放
- (void)preloadSVGAAnimation {
    SVGAParser *parser = [[SVGAParser alloc] init];
    NSURL *svgaURL = [[NSBundle mainBundle] URLForResource:@"theme_game_two_draw" withExtension:@"svga"];
    if (!svgaURL) {
        svgaURL = [[NSBundle mainBundle] URLForResource:@"theme_game_two_harvest" withExtension:@"svga"];
    }
    if (svgaURL) {
        WeakSelf
        [parser parseWithURL:svgaURL completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            wself.cachedVideoItem = videoItem;
            if (wself.svgaPlayer) {
                wself.svgaPlayer.videoItem = videoItem;
                [wself.svgaPlayer startAnimation];
            }
        } failureBlock:nil];
    }
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 暗色背景蒙层
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _maskView.userInteractionEnabled = YES;
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMaskTap:)];
    [_maskView addGestureRecognizer:tap];
    
    // 背景大图 (锁定 375:655.5 pt，即 750:1311 px 比例自适应居中，防变形与漂移)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_two_clean_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(KDialogAdaptedWidth(375));
        make.height.mas_equalTo(KDialogAdaptedWidth(655.5));
    }];
    
    // 实例化 SVGA 常驻背景流光 (CVCS Index 0 最底层堆叠，置于 _bgImageView 正上方、各功能容器正下方)
    self.svgaPlayer = [[SVGAPlayer alloc] init];
    self.svgaPlayer.contentMode = UIViewContentModeScaleToFill;
    self.svgaPlayer.userInteractionEnabled = NO;
    self.svgaPlayer.loops = 0; // 无限常驻背景流光循环
    [_bgImageView addSubview:self.svgaPlayer];
    [self.svgaPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_bgImageView);
    }];
    
    // 实例化 CVCS 语义容器树
    _hudContainer = [[UIView alloc] init];
    _hudContainer.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:_hudContainer];
    [_hudContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(KDialogAdaptedWidth(152));
    }];
    
    _gameplayContainer = [[UIView alloc] init];
    _gameplayContainer.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:_gameplayContainer];
    [_gameplayContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_hudContainer.mas_bottom);
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(KDialogAdaptedWidth(370));
    }];
    
    _actionContainer = [[UIView alloc] init];
    _actionContainer.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:_actionContainer];
    [_actionContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(_gameplayContainer.mas_bottom).offset(-KDialogAdaptedWidth(40));
    }];
    
    
    
    // 记录按钮 (放置于 _hudContainer，宽度 48 pt，高度 50 pt，符合 143:148 的实际切图比例)
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"theme_game_two_record_btn"] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
    [_hudContainer addSubview:_recordButton];
    [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(105));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(30));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(48), KDialogAdaptedWidth(50)));
    }];
    
    // 规则按钮 (放置于 _hudContainer，宽度 55 pt，高度 50 pt，符合 163:148 的实际切图比例)
    _ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ruleButton setBackgroundImage:[UIImage imageNamed:@"theme_game_two_rule_btn"] forState:UIControlStateNormal];
    [_ruleButton addTarget:self action:@selector(ruleClick) forControlEvents:UIControlEventTouchUpInside];
    [_hudContainer addSubview:_ruleButton];
    [_ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(105));
        make.leading.mas_equalTo(KDialogAdaptedWidth(30));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(55), KDialogAdaptedWidth(50)));
    }];
    
    // 1. 容器外正上方左侧【奖品池】悬浮条 (放置于 self 最外层，宽 70, 高 30，悬浮于 _bgImageView 外部正上方)
    CGFloat poolW = KDialogAdaptedWidth(70.0f);
    CGFloat poolH = KDialogAdaptedWidth(30.0f);
    UIView *giftPoolBar = [[UIView alloc] init];
    giftPoolBar.userInteractionEnabled = YES;
    [self addSubview:giftPoolBar];
    [giftPoolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_bgImageView.mas_top).offset(-KDialogAdaptedWidth(6));
        make.leading.mas_equalTo(_bgImageView.mas_leading).offset(KDialogAdaptedWidth(12));
        make.size.mas_equalTo(CGSizeMake(poolW, poolH));
    }];
    
    CAGradientLayer *poolGrad = [CAGradientLayer layer];
    poolGrad.frame = CGRectMake(0, 0, poolW, poolH);
    poolGrad.colors = @[(__bridge id)mHexRGB(0xFFA800).CGColor, (__bridge id)mHexRGB(0xE67E00).CGColor, (__bridge id)mHexRGB(0xC85A00).CGColor];
    poolGrad.startPoint = CGPointMake(0.5, 0);
    poolGrad.endPoint = CGPointMake(0.5, 1);
    poolGrad.cornerRadius = KDialogAdaptedWidth(15.0f);
    [giftPoolBar.layer addSublayer:poolGrad];
    
    giftPoolBar.layer.borderColor = mHexRGB(0xFFE57F).CGColor;
    giftPoolBar.layer.borderWidth = 1.5;
    giftPoolBar.layer.cornerRadius = KDialogAdaptedWidth(15.0f);
    giftPoolBar.clipsToBounds = YES;
    
    UITapGestureRecognizer *poolTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(giftPoolClick)];
    [giftPoolBar addGestureRecognizer:poolTap];
    
    UILabel *poolLabel = [[UILabel alloc] init];
    poolLabel.text = @"奖品池";
    poolLabel.textColor = kWhiteColor;
    poolLabel.font = [UIFont boldSystemFontOfSize:11];
    poolLabel.textAlignment = NSTextAlignmentCenter;
    [giftPoolBar addSubview:poolLabel];
    [poolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(giftPoolBar);
    }];

    // 2. 容器外正上方右侧【今日运势】悬浮条 (放置于 self 最外层，宽 70, 高 30，悬浮于 _bgImageView 外部正上方)
    CGFloat fortuneW = KDialogAdaptedWidth(70.0f);
    CGFloat fortuneH = KDialogAdaptedWidth(30.0f);
    UIView *fortuneBar = [[UIView alloc] init];
    fortuneBar.userInteractionEnabled = YES;
    [self addSubview:fortuneBar];
    [fortuneBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_bgImageView.mas_top).offset(-KDialogAdaptedWidth(6));
        make.trailing.mas_equalTo(_bgImageView.mas_trailing).offset(-KDialogAdaptedWidth(12));
        make.size.mas_equalTo(CGSizeMake(fortuneW, fortuneH));
    }];
    
    CAGradientLayer *fortuneGrad = [CAGradientLayer layer];
    fortuneGrad.frame = CGRectMake(0, 0, fortuneW, fortuneH);
    fortuneGrad.colors = @[(__bridge id)mHexRGB(0xFFA800).CGColor, (__bridge id)mHexRGB(0xE67E00).CGColor, (__bridge id)mHexRGB(0xC85A00).CGColor];
    fortuneGrad.startPoint = CGPointMake(0.5, 0);
    fortuneGrad.endPoint = CGPointMake(0.5, 1);
    fortuneGrad.cornerRadius = KDialogAdaptedWidth(15.0f);
    [fortuneBar.layer addSublayer:fortuneGrad];
    
    fortuneBar.layer.borderColor = mHexRGB(0xFFE57F).CGColor;
    fortuneBar.layer.borderWidth = 1.5;
    fortuneBar.layer.cornerRadius = KDialogAdaptedWidth(15.0f);
    fortuneBar.clipsToBounds = YES;
    
    UITapGestureRecognizer *fortuneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fortuneClick)];
    [fortuneBar addGestureRecognizer:fortuneTap];
    
    _fortuneLabel = [[UILabel alloc] init];
    _fortuneLabel.text = @"今日运势";
    _fortuneLabel.textColor = kWhiteColor;
    _fortuneLabel.font = [UIFont boldSystemFontOfSize:11];
    _fortuneLabel.textAlignment = NSTextAlignmentCenter;
    [fortuneBar addSubview:_fortuneLabel];
    [_fortuneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(fortuneBar);
    }];
    
    // 9个灵果的设计绝对位置 (对标 Android 坐标并除以 2)
    static const CGPoint PEACH_CENTERS[] = {
        {192.5f, 165.0f}, // 灵果 1 (主桃)
        {102.5f, 225.0f}, // 灵果 2
        {292.5f, 230.0f}, // 灵果 3
        {212.5f, 280.0f}, // 灵果 4
        {50.0f,  305.0f}, // 灵果 5
        {317.5f, 347.5f}, // 灵果 6
        {135.0f, 340.0f}, // 灵果 7
        {65.0f,  380.0f}, // 灵果 8
        {235.0f, 415.0f}  // 灵果 9
    };
    
    // 9个灵果从大到小的错落自适应尺寸 (对标 Android 缩放并乘以 0.6)
    static const CGSize PEACH_SIZES[] = {
        {63.0f, 63.0f}, // 灵果 1
        {45.0f, 45.0f}, // 灵果 2
        {45.0f, 45.0f}, // 灵果 3
        {36.0f, 36.0f}, // 灵果 4
        {39.0f, 39.0f}, // 灵果 5
        {42.0f, 42.0f}, // 灵果 6
        {36.0f, 36.0f}, // 灵果 7
        {39.0f, 39.0f}, // 灵果 8
        {48.0f, 48.0f}  // 灵果 9
    };
    
    // 对标 Android 提交 27 的 9 个灵果挂钩点 Y 轴百分比比例 PEACH_PIVOT_Y_RATIOS
    static const CGFloat PEACH_PIVOT_Y_RATIOS[] = {
        -0.1143f, // 灵果 1 (#1)
        -0.1250f, // 灵果 2 (#2)
        -0.1250f, // 灵果 3 (#3)
        -0.1667f, // 灵果 4 (#4)
        -0.1538f, // 灵果 5 (#5)
        -0.1429f, // 灵果 6 (#6)
        -0.1667f, // 灵果 7 (#7)
         0.0000f, // 灵果 8 (#8)
        -0.1250f  // 灵果 9 (#9)
    };
    
    for (int i = 0; i < 9; i++) {
        UIView *card = [[UIView alloc] init];
        [_gameplayContainer addSubview:card];
        [self.peachCardViews addObject:card];
        
        CGPoint center = PEACH_CENTERS[i];
        CGSize size = PEACH_SIZES[i];
        CGFloat ratio = PEACH_PIVOT_Y_RATIOS[i];
        
        // 精确抵消 iOS 设置 anchorPoint (0.5, 0.0 + ratio) 引起的 Y 轴整体下移位移
        CGFloat anchorYShift = (0.0f + ratio - 0.5f) * size.height;
        
        [card mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgImageView.mas_leading).offset(KDialogAdaptedWidth(center.x));
            make.centerY.mas_equalTo(_bgImageView.mas_top).offset(KDialogAdaptedWidth(center.y + anchorYShift));
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(size.width), KDialogAdaptedWidth(size.height)));
        }];
        
        // 设置挂钩点 anchorPoint (X为中点 0.5，Y为 0.0 + 比率)
        card.layer.anchorPoint = CGPointMake(0.5f, 0.0f + ratio);
        
        // 最底层发光光圈 (方案A: 隐藏外围半透明发光背景)
        UIImageView *glowView = [[UIImageView alloc] init];
        glowView.image = [UIImage imageNamed:@"theme_game_two_center_fruit"];
        glowView.contentMode = UIViewContentModeScaleToFill;
        glowView.hidden = YES;
        [card addSubview:glowView];
        [glowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(card);
        }];
        [self.peachGlowImageViews addObject:glowView];
        
        // 中层底盘 (隐藏半透明矩形框)
        UIImageView *frameView = [[UIImageView alloc] init];
        frameView.image = [UIImage imageNamed:@"theme_game_two_center_frame"];
        frameView.contentMode = UIViewContentModeScaleToFill;
        frameView.hidden = YES;
        [card addSubview:frameView];
        [frameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(card);
        }];
        [self.peachFrameImageViews addObject:frameView];
        
        // 最顶层礼物图 (带 5 pt 自适应缩进边距)
        UIImageView *giftImg = [[UIImageView alloc] init];
        giftImg.contentMode = UIViewContentModeScaleAspectFit;
        [card addSubview:giftImg];
        [giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(card).insets(UIEdgeInsetsMake(KDialogAdaptedWidth(5), KDialogAdaptedWidth(5), KDialogAdaptedWidth(5), KDialogAdaptedWidth(5)));
        }];
        [self.peachImageViews addObject:giftImg];
    }
    
    // 启动 2D 物理单摆摇摆微动效引擎
    [self startSwingAnimationEngine];
    
    // 三档抽奖按钮包装容器 (放置于 _actionContainer)
    UIView *btnGroupContainer = [[UIView alloc] init];
    [_actionContainer addSubview:btnGroupContainer];
    [btnGroupContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_actionContainer);
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(26));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(332), KDialogAdaptedWidth(78)));
    }];
    
    // 抽奖 1 次
    UIView *oneWrapper = [[UIView alloc] init];
    [btnGroupContainer addSubview:oneWrapper];
    [oneWrapper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(KDialogAdaptedWidth(104));
    }];
    
    _drawOneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawOneButton setBackgroundImage:[UIImage imageNamed:@"theme_game_two_draw1_btn"] forState:UIControlStateNormal];
    [_drawOneButton addTarget:self action:@selector(drawOneClick) forControlEvents:UIControlEventTouchUpInside];
    [oneWrapper addSubview:_drawOneButton];
    [_drawOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(KDialogAdaptedWidth(52));
    }];
    
    UIView *onePriceContainer = [[UIView alloc] init];
    onePriceContainer.userInteractionEnabled = NO;
    [oneWrapper addSubview:onePriceContainer];
    [onePriceContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_drawOneButton.mas_bottom).offset(KDialogAdaptedWidth(6));
        make.centerX.mas_equalTo(oneWrapper);
        make.height.mas_equalTo(KDialogAdaptedWidth(20));
    }];
    
    UIImageView *oneKeyIcon = [[UIImageView alloc] init];
    oneKeyIcon.image = [UIImage imageNamed:@"theme_game_one_purchase_key_icon"];
    [onePriceContainer addSubview:oneKeyIcon];
    [oneKeyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.centerY.mas_equalTo(onePriceContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(18), KDialogAdaptedWidth(18)));
    }];
    
    UILabel *oneCostLabel = [[UILabel alloc] init];
    oneCostLabel.textColor = mHexRGB(0xFF8FA8);
    oneCostLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(16)];
    oneCostLabel.text = @"x1";
    [onePriceContainer addSubview:oneCostLabel];
    [oneCostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(oneKeyIcon.mas_trailing).offset(KDialogAdaptedWidth(4));
        make.trailing.mas_equalTo(0);
        make.centerY.mas_equalTo(onePriceContainer);
    }];
    
    // 抽奖 10 次
    UIView *tenWrapper = [[UIView alloc] init];
    [btnGroupContainer addSubview:tenWrapper];
    [tenWrapper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(oneWrapper.mas_trailing).offset(KDialogAdaptedWidth(10));
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(KDialogAdaptedWidth(104));
    }];
    
    _drawTenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawTenButton setBackgroundImage:[UIImage imageNamed:@"theme_game_two_draw10_btn"] forState:UIControlStateNormal];
    [_drawTenButton addTarget:self action:@selector(drawTenClick) forControlEvents:UIControlEventTouchUpInside];
    [tenWrapper addSubview:_drawTenButton];
    [_drawTenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(KDialogAdaptedWidth(52));
    }];
    
    UIView *tenPriceContainer = [[UIView alloc] init];
    tenPriceContainer.userInteractionEnabled = NO;
    [tenWrapper addSubview:tenPriceContainer];
    [tenPriceContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_drawTenButton.mas_bottom).offset(KDialogAdaptedWidth(6));
        make.centerX.mas_equalTo(tenWrapper);
        make.height.mas_equalTo(KDialogAdaptedWidth(20));
    }];
    
    UIImageView *tenKeyIcon = [[UIImageView alloc] init];
    tenKeyIcon.image = [UIImage imageNamed:@"theme_game_one_purchase_key_icon"];
    [tenPriceContainer addSubview:tenKeyIcon];
    [tenKeyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.centerY.mas_equalTo(tenPriceContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(18), KDialogAdaptedWidth(18)));
    }];
    
    UILabel *tenCostLabel = [[UILabel alloc] init];
    tenCostLabel.textColor = mHexRGB(0xFF8FA8);
    tenCostLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(16)];
    tenCostLabel.text = @"x10";
    [tenPriceContainer addSubview:tenCostLabel];
    [tenCostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(tenKeyIcon.mas_trailing).offset(KDialogAdaptedWidth(4));
        make.trailing.mas_equalTo(0);
        make.centerY.mas_equalTo(tenPriceContainer);
    }];
    
    // 抽奖 100 次
    UIView *hundredWrapper = [[UIView alloc] init];
    [btnGroupContainer addSubview:hundredWrapper];
    [hundredWrapper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(tenWrapper.mas_trailing).offset(KDialogAdaptedWidth(10));
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(KDialogAdaptedWidth(104));
    }];
    
    _drawHundredButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawHundredButton setBackgroundImage:[UIImage imageNamed:@"theme_game_two_draw100_btn"] forState:UIControlStateNormal];
    [_drawHundredButton addTarget:self action:@selector(drawHundredClick) forControlEvents:UIControlEventTouchUpInside];
    [hundredWrapper addSubview:_drawHundredButton];
    [_drawHundredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(KDialogAdaptedWidth(52));
    }];
    
    UIView *hundredPriceContainer = [[UIView alloc] init];
    hundredPriceContainer.userInteractionEnabled = NO;
    [hundredWrapper addSubview:hundredPriceContainer];
    [hundredPriceContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_drawHundredButton.mas_bottom).offset(KDialogAdaptedWidth(6));
        make.centerX.mas_equalTo(hundredWrapper);
        make.height.mas_equalTo(KDialogAdaptedWidth(20));
    }];
    
    UIImageView *hundredKeyIcon = [[UIImageView alloc] init];
    hundredKeyIcon.image = [UIImage imageNamed:@"theme_game_one_purchase_key_icon"];
    [hundredPriceContainer addSubview:hundredKeyIcon];
    [hundredKeyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.centerY.mas_equalTo(hundredPriceContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(18), KDialogAdaptedWidth(18)));
    }];
    
    UILabel *hundredCostLabel = [[UILabel alloc] init];
    hundredCostLabel.textColor = mHexRGB(0xFF8FA8);
    hundredCostLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(16)];
    hundredCostLabel.text = @"x100";
    [hundredPriceContainer addSubview:hundredCostLabel];
    [hundredCostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(hundredKeyIcon.mas_trailing).offset(KDialogAdaptedWidth(4));
        make.trailing.mas_equalTo(0);
        make.centerY.mas_equalTo(hundredPriceContainer);
    }];
    
    // 资产显示栏 (钻石与祝灵珠)：高度 32 pt，靠底贴紧按钮组上方 12 pt (放置于 _actionContainer)
    UIView *assetContainer = [[UIView alloc] init];
    [_actionContainer addSubview:assetContainer];
    [assetContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(btnGroupContainer.mas_top).offset(-KDialogAdaptedWidth(24));
        make.leading.mas_equalTo(KDialogAdaptedWidth(18));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(18));
        make.height.mas_equalTo(KDialogAdaptedWidth(32));
    }];
    
    // 钻石栏 (挂左)
    _diamondBar = [UIButton buttonWithType:UIButtonTypeCustom];
    _diamondBar.backgroundColor = [UIColor clearColor];
    [_diamondBar addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
    [assetContainer addSubview:_diamondBar];
    
    UIImageView *diaIcon = [[UIImageView alloc] init];
    diaIcon.image = [UIImage imageNamed:@"theme_game_two_diamond_icon"];
    diaIcon.contentMode = UIViewContentModeScaleAspectFit;
    diaIcon.userInteractionEnabled = NO;
    [_diamondBar addSubview:diaIcon];
    
    _diamondBalanceLabel = [[UILabel alloc] init];
    _diamondBalanceLabel.textColor = kWhiteColor;
    _diamondBalanceLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(12)];
    _diamondBalanceLabel.text = @"0";
    _diamondBalanceLabel.userInteractionEnabled = NO;
    [_diamondBar addSubview:_diamondBalanceLabel];
    
    _diamondPlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_diamondPlusButton setBackgroundImage:[UIImage imageNamed:@"theme_game_two_plus_icon"] forState:UIControlStateNormal];
    _diamondPlusButton.userInteractionEnabled = NO;
    [_diamondBar addSubview:_diamondPlusButton];
    
    // Set all layout constraints
    [_diamondBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.centerY.mas_equalTo(assetContainer);
        make.height.mas_equalTo(assetContainer);
        make.trailing.mas_equalTo(_diamondPlusButton.mas_trailing);
    }];
    
    [diaIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.centerY.mas_equalTo(_diamondBar);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(26), KDialogAdaptedWidth(26)));
    }];
    
    [_diamondBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(diaIcon.mas_trailing).offset(KDialogAdaptedWidth(4));
        make.centerY.mas_equalTo(_diamondBar);
    }];
    
    [_diamondPlusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_diamondBalanceLabel.mas_trailing).offset(KDialogAdaptedWidth(4));
        make.centerY.mas_equalTo(_diamondBar);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(22), KDialogAdaptedWidth(22)));
    }];
    
    // 祝灵珠栏 (挂右)
    _keyBar = [UIButton buttonWithType:UIButtonTypeCustom];
    _keyBar.backgroundColor = [UIColor clearColor];
    [_keyBar addTarget:self action:@selector(openPurchaseDialog) forControlEvents:UIControlEventTouchUpInside];
    [assetContainer addSubview:_keyBar];
    
    _keyPlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_keyPlusButton setBackgroundImage:[UIImage imageNamed:@"theme_game_two_plus_icon"] forState:UIControlStateNormal];
    _keyPlusButton.userInteractionEnabled = NO;
    [_keyBar addSubview:_keyPlusButton];
    
    _keyBalanceLabel = [[UILabel alloc] init];
    _keyBalanceLabel.textColor = kWhiteColor;
    _keyBalanceLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(12)];
    _keyBalanceLabel.text = @"0";
    _keyBalanceLabel.userInteractionEnabled = NO;
    [_keyBar addSubview:_keyBalanceLabel];
    
    UIImageView *keyIcon = [[UIImageView alloc] init];
    keyIcon.image = [UIImage imageNamed:@"theme_game_one_purchase_key_icon"];
    keyIcon.contentMode = UIViewContentModeScaleAspectFit;
    keyIcon.userInteractionEnabled = NO;
    [_keyBar addSubview:keyIcon];
    
    // Set all layout constraints
    [_keyBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(0);
        make.centerY.mas_equalTo(assetContainer);
        make.height.mas_equalTo(assetContainer);
        make.leading.mas_equalTo(keyIcon.mas_leading);
    }];
    
    [_keyPlusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(0);
        make.centerY.mas_equalTo(_keyBar);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(22), KDialogAdaptedWidth(22)));
    }];
    
    [_keyBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(_keyPlusButton.mas_leading).offset(-KDialogAdaptedWidth(4));
        make.centerY.mas_equalTo(_keyBar);
    }];
    
    [keyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(_keyBalanceLabel.mas_leading).offset(-KDialogAdaptedWidth(4));
        make.centerY.mas_equalTo(_keyBar);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(24), KDialogAdaptedWidth(24)));
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - 数据拉取与图片绑定
- (void)loadData {
    WeakSelf
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
    
    NSInteger queryTypeId = (self.typeId == 6 || self.typeId == 8) ? 7 : self.typeId;
    
    // 2. 获取详情和价格
    [MLGameLotteryService getRoomDetailWithTypeId:queryTypeId success:^(MLGameLotteryInfoModel *model) {
        if (!wself) return;
        if (!model || model == (id)[NSNull null] || ![model isKindOfClass:[MLGameLotteryInfoModel class]]) {
            return;
        }
        wself.infoModel = model;
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 3. 获取 9 个灵果大奖的奖池配图
    [MLGameLotteryService getPrizesWithTypeId:queryTypeId success:^(NSArray<MLGameDrawResultModel *> *list) {
        if (!wself) return;
        if (!list || ![list isKindOfClass:[NSArray class]]) {
            return;
        }
        wself.prizeList = list;
        [wself renderPrizePeaches];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 4. 获取今日运势数据 (对接 typeId == 4 / lottery_id == 2)
    [MLGameLotteryService getFortuneLotteryListWithSuccess:^(NSArray<MLGameLotteryInfoModel *> *list) {
        if (!wself) return;
        if (!list || ![list isKindOfClass:[NSArray class]]) {
            return;
        }
        for (MLGameLotteryInfoModel *model in list) {
            if (model.typeId == wself.typeId || [model.name containsString:@"神木"]) {
                wself.consumeValue = model.consume_diamonds;
                wself.produceValue = model.produce_diamonds;
                break;
            }
        }
    } failure:^(NSError *error) {
        // 静默失败
    }];
}

- (void)renderPrizePeaches {
    if (self.prizeList.count == 0) return;
    
    for (int i = 0; i < self.peachImageViews.count; i++) {
        UIImageView *peachImg = self.peachImageViews[i];
        if (i < self.prizeList.count) {
            MLGameDrawResultModel *prize = self.prizeList[i];
            NSURL *url = [NSURL URLWithString:[prize imageUrl]];
            if ([peachImg respondsToSelector:@selector(setImageWithURL:placeholder:)]) {
                [peachImg performSelector:@selector(setImageWithURL:placeholder:) withObject:url withObject:[UIImage imageNamed:@""]];
            } else if ([peachImg respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
                [peachImg performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
            }
            peachImg.hidden = NO;
        } else {
            peachImg.hidden = YES;
        }
    }
}

- (void)updateBalanceUI {
    self.keyBalanceLabel.text = MLFormatLargeNumber((double)self.localKeyBalance);
}

#pragma mark - 抽奖业务 (带乐观扣减和超时防刷回滚)
- (void)drawWithTimes:(NSInteger)times cost:(NSInteger)cost {
    if (self.localKeyBalance < cost) {
        [SVProgressHUD showErrorWithStatus:@"钥匙不足，请先购买"];
        [self openPurchaseDialog];
        return;
    }
    
    // 1. 开启防连击/防误触加锁，拦截 Dismiss 手势
    self.isDrawing = YES;
    [self lockButtons:YES];
    
    // 2. 本地乐观扣减钥匙余额并刷新 UI
    self.localKeyBalance -= cost;
    [self updateBalanceUI];
    self.lastDrawTimes = times;
    self.lastDrawCost = cost;
    
    // 3. 并发调用接口发包 (0ms 极速响应)
    WeakSelf
    NSInteger queryTypeId = (self.typeId == 6 || self.typeId == 8) ? 7 : self.typeId;
    [MLGameLotteryService drawWithTypeId:queryTypeId times:times success:^(NSArray<MLGameDrawResultModel *> *list, NSInteger totalValue, NSInteger logId) {
        // 4. 在 GCD 后台子线程解包与解析列表数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!wself) return;
                
                MLChatRoomThemeGameTwoResultView *activeResultView = nil;
                for (UIView *sub in wself.superview.subviews) {
                    if ([sub isKindOfClass:[MLChatRoomThemeGameTwoResultView class]]) {
                        activeResultView = (MLChatRoomThemeGameTwoResultView *)sub;
                        break;
                    }
                }
                
                if (activeResultView) {
                    [activeResultView updateGifts:list totalValue:totalValue times:times];
                    [wself lockButtons:NO];
                    wself.isDrawing = NO;
                    [wself loadData]; // 静默更新资产
                } else {
                    [wself handleDrawSuccessWithGifts:list totalValue:totalValue logId:logId times:times];
                }
            });
        });
    } failure:^(NSError *error) {
        [wself lockButtons:NO];
        wself.isDrawing = NO;
        
        // 5. 计费安全防御：若超时(NSURLErrorTimedOut)绝不回滚钥匙；若断网/报错，立刻把钥匙加回并重置UI
        if (error.code == NSURLErrorTimedOut) {
            [SVProgressHUD showInfoWithStatus:@"服务器繁忙，结果可能稍后到账，请去记录或背包查看"];
        } else {
            wself.localKeyBalance += cost;
            [wself updateBalanceUI];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
}

- (void)startSVGAAnimationInstantWithTimes:(NSInteger)times {
    if (self.svgaPlayer == nil) {
        self.svgaPlayer = [[SVGAPlayer alloc] init];
        self.svgaPlayer.delegate = self;
        self.svgaPlayer.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.svgaPlayer];
        [self.svgaPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_bgImageView);
        }];
    }
    
    self.svgaPlayer.alpha = 1.0;
    self.svgaPlayer.hidden = NO;
    
    // 100 连抽配置无限循环 (由 API 响应控制 0.15s 淡出即切)
    if (times >= 100) {
        self.svgaPlayer.loops = 0;
    } else {
        self.svgaPlayer.loops = 1;
    }
    
    if (self.cachedVideoItem) {
        self.svgaPlayer.videoItem = self.cachedVideoItem;
        [self.svgaPlayer startAnimation];
    } else {
        // 缓存不可用时兜底在线异步加载
        SVGAParser *parser = [[SVGAParser alloc] init];
        NSURL *svgaURL = [[NSBundle mainBundle] URLForResource:@"theme_game_two_harvest" withExtension:@"svga"];
        if (!svgaURL) {
            svgaURL = [[NSBundle mainBundle] URLForResource:@"theme_game_two_draw" withExtension:@"svga"];
        }
        if (svgaURL) {
            WeakSelf
            [parser parseWithURL:svgaURL completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
                wself.cachedVideoItem = videoItem;
                wself.svgaPlayer.videoItem = videoItem;
                [wself.svgaPlayer startAnimation];
            } failureBlock:nil];
        }
    }
}

- (void)stopSVGAAnimationImmediately {
    if (self.svgaPlayer) {
        [self.svgaPlayer stopAnimation];
        self.svgaPlayer.hidden = YES;
        self.svgaPlayer.alpha = 1.0;
    }
}

- (void)handleDrawSuccessWithGifts:(NSArray<MLGameDrawResultModel *> *)gifts totalValue:(NSInteger)totalValue logId:(NSInteger)logId times:(NSInteger)times {
    self.pendingGifts = gifts;
    self.pendingTotalValue = totalValue;
    
    // 收到 HTTP 响应成功回调，瞬间极速唤起战报弹窗，彻底移除死等等待
    [self showResultWithGifts:gifts totalValue:totalValue];
}

- (void)lockButtons:(BOOL)lock {
    self.drawOneButton.enabled = !lock;
    self.drawTenButton.enabled = !lock;
    self.drawHundredButton.enabled = !lock;
    self.ruleButton.enabled = !lock;
    self.recordButton.enabled = !lock;
}

#pragma mark - SVGAPlayerDelegate
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    player.hidden = YES;
    [self showResultWithGifts:self.pendingGifts totalValue:self.pendingTotalValue];
}

- (void)showResultWithGifts:(NSArray<MLGameDrawResultModel *> *)gifts totalValue:(NSInteger)totalValue {
    [self lockButtons:NO];
    self.isDrawing = NO;
    
    // 弹出恭喜获得结果页 (去重合并列表展示，并且支持快速连抽)
    WeakSelf
    [MLChatRoomThemeGameTwoResultView showInView:self.superview 
                                           gifts:gifts 
                                      totalValue:totalValue 
                                           times:self.lastDrawTimes
                                      retryBlock:^{
        [wself drawWithTimes:wself.lastDrawTimes cost:wself.lastDrawCost];
    }];
    
    [self loadData]; 
}

#pragma mark - 点击事件与交互逻辑
- (void)drawOneClick {
    [self drawWithTimes:1 cost:200];
}

- (void)drawTenClick {
    [self drawWithTimes:10 cost:2000];
}

- (void)drawHundredClick {
    [self drawWithTimes:100 cost:20000];
}

- (void)ruleClick {
    [MLChatRoomThemeGameTwoRuleView showInView:self.superview ruleContent:self.infoModel.content];
}

- (void)recordClick {
    [MLChatRoomThemeGameTwoRecordView showInView:self.superview typeId:self.typeId];
}

- (void)giftPoolClick {
    if (self.isDrawing) return;
    [MLChatRoomThemeGameTwoGiftView showInView:self.superview gifts:self.prizeList];
}

- (void)fortuneClick {
    [MLChatRoomThemeGameTwoFortuneView showInView:self.superview consume:self.consumeValue produce:self.produceValue];
}

- (void)openPurchaseDialog {
    WeakSelf
    [MLChatRoomThemeGameTwoPurchaseView showInView:self.superview infoModel:self.infoModel purchaseSuccess:^(NSInteger newKeyBalance) {
        wself.localKeyBalance = newKeyBalance;
        [wself updateBalanceUI];
    }];
}

#pragma mark - CADisplayLink 2D Physical Pendulum Swing Engine
- (void)startSwingAnimationEngine {
    [self stopSwingAnimationEngine];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onSwingUpdate:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopSwingAnimationEngine {
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)onSwingUpdate:(CADisplayLink *)link {
    CFTimeInterval currentTime = CACurrentMediaTime();
    static const CGFloat MAX_SWING_ANGLE_RAD = 6.0f * M_PI / 180.0f; // 最大摆角 6.0 度
    static const CGFloat SWING_FREQUENCY = 0.3f; // 摆动频率 0.3 Hz
    
    for (int i = 0; i < self.peachCardViews.count; i++) {
        UIView *card = self.peachCardViews[i];
        CGFloat phase = i * 0.35f; // 从左至右错峰相角
        CGFloat angleRad = MAX_SWING_ANGLE_RAD * sin(currentTime * 2.0 * M_PI * SWING_FREQUENCY + phase);
        card.transform = CGAffineTransformMakeRotation(angleRad);
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow) {
        [self startSwingAnimationEngine];
    } else {
        [self stopSwingAnimationEngine];
    }
}

- (void)dealloc {
    [self stopSwingAnimationEngine];
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
        return;
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
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.roomViewController && appDelegate.roomViewController.floatingWindow) {
        appDelegate.roomViewController.floatingWindow.hidden = NO;
    }
}

@end
