#import "MLChatRoomThemeGameTwoView.h"
#import "MLGameLotteryService.h"
#import "RoomFloatingWindow.h"
#import "AppDelegate.h"
#import "MLChatRoomThemeGameTwoResultView.h"
#import "MLChatRoomThemeGameTwoRuleView.h"
#import "MLChatRoomThemeGameTwoRecordView.h"
#import "MLChatRoomThemeGameTwoPurchaseView.h"
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

@interface MLChatRoomThemeGameTwoView ()

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *ruleButton;
@property (nonatomic, strong) UIButton *recordButton;

@property (nonatomic, strong) UILabel *keyBalanceLabel;
@property (nonatomic, strong) UIButton *keyPlusButton;
@property (nonatomic, strong) UILabel *diamondBalanceLabel;
@property (nonatomic, strong) UIButton *diamondPlusButton;

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
@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *pendingGifts;
@property (nonatomic, assign) NSInteger pendingTotalValue;
@property (nonatomic, assign) NSInteger consumeValue;
@property (nonatomic, assign) NSInteger produceValue;

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
        self.typeId = typeId;
        self.isDrawing = NO;
        self.peachCardViews = [NSMutableArray array];
        self.peachFrameImageViews = [NSMutableArray array];
        self.peachGlowImageViews = [NSMutableArray array];
        self.peachImageViews = [NSMutableArray array];
        [self setupUI];
        [self loadData];
        
        // 隐藏语音悬浮窗
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
    
    // 背景大图 (锁定 750:1311 比例，在宽屏设备上限宽 390 pt 居中，防拉伸变形与漂移)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_two_clean_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(self).priorityMedium();
        make.width.mas_lessThanOrEqualTo(390).priorityHigh();
        make.height.mas_equalTo(_bgImageView.mas_width).multipliedBy(1311.0 / 750.0);
    }];
    
    // 左上角返回/关闭按钮
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"theme_game_two_rule_back"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KAdaptedWidth(16));
        make.leading.mas_equalTo(KAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    // 记录按钮 (距右边缘 16 pt, top 16)
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordButton setImage:[UIImage imageNamed:@"theme_game_two_record_btn"] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_recordButton];
    [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KAdaptedWidth(16));
        make.trailing.mas_equalTo(-KAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    // 规则按钮 (位于记录按钮左侧 10 pt)
    _ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ruleButton setImage:[UIImage imageNamed:@"theme_game_two_rule_btn"] forState:UIControlStateNormal];
    [_ruleButton addTarget:self action:@selector(ruleClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_ruleButton];
    [_ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KAdaptedWidth(16));
        make.trailing.mas_equalTo(_recordButton.mas_leading).offset(-KAdaptedWidth(10));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    // 今日运势悬浮条 (宽 74, 高 23. 水平悬浮在规则/记录按钮组左侧 10 pt. 40% 半透明黑底, 圆角 11.5 pt)
    UIView *fortuneBar = [[UIView alloc] init];
    fortuneBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    setViewCorner(fortuneBar, 11.5);
    fortuneBar.userInteractionEnabled = YES;
    [_bgImageView addSubview:fortuneBar];
    [fortuneBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_bgImageView.mas_top).offset(-4);
        make.trailing.mas_equalTo(_bgImageView.mas_trailing).offset(-8);
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
    
    // 9个灵果的设计绝对位置
    static const CGPoint PEACH_CENTERS[] = {
        {150.0f, 185.0f}, // 灵果 1
        {105.0f, 235.0f}, // 灵果 2
        {195.0f, 235.0f}, // 灵果 3
        {70.0f, 290.0f},  // 灵果 4
        {148.0f, 280.0f}, // 灵果 5
        {230.0f, 290.0f}, // 灵果 6
        {100.0f, 350.0f}, // 灵果 7
        {200.0f, 350.0f}, // 灵果 8
        {148.0f, 395.0f}  // 灵果 9
    };
    
    // 9个灵果从大到小的错落自适应尺寸 (高保真还原)
    static const CGSize PEACH_SIZES[] = {
        {52.5f, 52.5f}, // 灵果 1 (主桃)
        {37.5f, 37.5f}, // 灵果 2
        {37.5f, 37.5f}, // 灵果 3
        {30.0f, 30.0f}, // 灵果 4 (小挂件)
        {32.5f, 32.5f}, // 灵果 5
        {35.0f, 35.0f}, // 灵果 6
        {30.0f, 30.0f}, // 灵果 7 (小挂件)
        {32.5f, 32.5f}, // 灵果 8
        {40.0f, 40.0f}  // 灵果 9
    };
    
    for (int i = 0; i < 9; i++) {
        UIView *card = [[UIView alloc] init];
        [_bgImageView addSubview:card];
        [self.peachCardViews addObject:card];
        
        CGPoint center = PEACH_CENTERS[i];
        CGSize size = PEACH_SIZES[i];
        [card mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgImageView.mas_leading).offset(KAdaptedWidth(center.x));
            make.centerY.mas_equalTo(_bgImageView.mas_top).offset(KAdaptedWidth(center.y));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(size.width), KAdaptedWidth(size.height)));
        }];
        
        // 最底层发光光圈
        UIImageView *glowView = [[UIImageView alloc] init];
        glowView.image = [UIImage imageNamed:@"theme_game_two_center_fruit"];
        glowView.contentMode = UIViewContentModeScaleToFill;
        [card addSubview:glowView];
        [glowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(card);
        }];
        [self.peachGlowImageViews addObject:glowView];
        
        // 中层底盘
        UIImageView *frameView = [[UIImageView alloc] init];
        frameView.image = [UIImage imageNamed:@"theme_game_two_center_frame"];
        frameView.contentMode = UIViewContentModeScaleToFill;
        [card addSubview:frameView];
        [frameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(card);
        }];
        [self.peachFrameImageViews addObject:frameView];
        
        // 最顶层礼物图 (带 5 pt 内缩边距)
        UIImageView *giftImg = [[UIImageView alloc] init];
        giftImg.contentMode = UIViewContentModeScaleAspectFit;
        [card addSubview:giftImg];
        [giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(card).insets(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
        [self.peachImageViews addObject:giftImg];
    }
    
    // 启动错峰浮游缓动
    [self startPeachFloatingAnimations];
    
    // 三档抽奖按钮组 (一连/十连/百连)：水平一排平铺底端。单个宽 104 pt，高 60 pt。间距 10 pt，避让 Safe Area 14 pt，整组水平居中。
    UIView *btnGroupContainer = [[UIView alloc] init];
    [_bgImageView addSubview:btnGroupContainer];
    [btnGroupContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgImageView);
        make.bottom.mas_equalTo(-KAdaptedWidth(14)); // 使用宽自适应避让
        make.size.mas_equalTo(CGSizeMake(332, 60)); // 104*3 + 10*2 = 332
    }];
    
    _drawOneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawOneButton setImage:[UIImage imageNamed:@"theme_game_two_draw1_btn"] forState:UIControlStateNormal];
    [_drawOneButton addTarget:self action:@selector(drawOneClick) forControlEvents:UIControlEventTouchUpInside];
    [btnGroupContainer addSubview:_drawOneButton];
    [_drawOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(104, 60));
    }];
    
    _drawTenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawTenButton setImage:[UIImage imageNamed:@"theme_game_two_draw10_btn"] forState:UIControlStateNormal];
    [_drawTenButton addTarget:self action:@selector(drawTenClick) forControlEvents:UIControlEventTouchUpInside];
    [btnGroupContainer addSubview:_drawTenButton];
    [_drawTenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_drawOneButton.mas_trailing).offset(10);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(104, 60));
    }];
    
    _drawHundredButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawHundredButton setImage:[UIImage imageNamed:@"theme_game_two_draw100_btn"] forState:UIControlStateNormal];
    [_drawHundredButton addTarget:self action:@selector(drawHundredClick) forControlEvents:UIControlEventTouchUpInside];
    [btnGroupContainer addSubview:_drawHundredButton];
    [_drawHundredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_drawTenButton.mas_trailing).offset(10);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(104, 60));
    }];
    
    // 资产显示栏 (钻石与祝灵珠)：高度 32 pt，距顶部 50 pt，左右边缘 18 pt。干净透明的线性布局。
    UIView *assetContainer = [[UIView alloc] init];
    [_bgImageView addSubview:assetContainer];
    [assetContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.leading.mas_equalTo(18);
        make.trailing.mas_equalTo(-18);
        make.height.mas_equalTo(32);
    }];
    
    // 钻石栏 (挂左)
    UIImageView *diaIcon = [[UIImageView alloc] init];
    diaIcon.image = [UIImage imageNamed:@"theme_game_two_diamond_icon"];
    [assetContainer addSubview:diaIcon];
    [diaIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.centerY.mas_equalTo(assetContainer);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    _diamondBalanceLabel = [[UILabel alloc] init];
    _diamondBalanceLabel.textColor = kWhiteColor;
    _diamondBalanceLabel.font = [UIFont systemFontOfSize:11];
    _diamondBalanceLabel.text = @"0";
    [assetContainer addSubview:_diamondBalanceLabel];
    [_diamondBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(diaIcon.mas_trailing).offset(4);
        make.centerY.mas_equalTo(assetContainer);
    }];
    
    _diamondPlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_diamondPlusButton setImage:[UIImage imageNamed:@"theme_game_two_plus_icon"] forState:UIControlStateNormal];
    [_diamondPlusButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
    [assetContainer addSubview:_diamondPlusButton];
    [_diamondPlusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_diamondBalanceLabel.mas_trailing).offset(4);
        make.centerY.mas_equalTo(assetContainer);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    // 祝灵珠栏 (挂右)
    _keyPlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_keyPlusButton setImage:[UIImage imageNamed:@"theme_game_two_plus_icon"] forState:UIControlStateNormal];
    [_keyPlusButton addTarget:self action:@selector(openPurchaseDialog) forControlEvents:UIControlEventTouchUpInside];
    [assetContainer addSubview:_keyPlusButton];
    [_keyPlusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(0);
        make.centerY.mas_equalTo(assetContainer);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    _keyBalanceLabel = [[UILabel alloc] init];
    _keyBalanceLabel.textColor = kWhiteColor;
    _keyBalanceLabel.font = [UIFont systemFontOfSize:11];
    _keyBalanceLabel.text = @"0";
    [assetContainer addSubview:_keyBalanceLabel];
    [_keyBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(_keyPlusButton.mas_leading).offset(-4);
        make.centerY.mas_equalTo(assetContainer);
    }];
    
    UIImageView *keyIcon = [[UIImageView alloc] init];
    keyIcon.image = [UIImage imageNamed:@"theme_game_one_purchase_key_icon"]; // 跨玩法复用钥匙图
    [assetContainer addSubview:keyIcon];
    [keyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(_keyBalanceLabel.mas_leading).offset(-4);
        make.centerY.mas_equalTo(assetContainer);
        make.size.mas_equalTo(CGSizeMake(30, 30));
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
        NSInteger diamondInt = (NSInteger)diamondDouble;
        wself.diamondBalanceLabel.text = [NSString stringWithFormat:@"%ld", (long)diamondInt];
        wself.localKeyBalance = moneyModel.lottery_coin;
        [wself updateBalanceUI];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 2. 获取详情和价格
    [MLGameLotteryService getRoomDetailWithTypeId:self.typeId success:^(MLGameLotteryInfoModel *model) {
        if (!wself) return;
        if (!model || model == (id)[NSNull null] || ![model isKindOfClass:[MLGameLotteryInfoModel class]]) {
            return;
        }
        wself.infoModel = model;
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 3. 获取 9 个灵果大奖的奖池配图
    [MLGameLotteryService getPrizesWithTypeId:self.typeId success:^(NSArray<MLGameDrawResultModel *> *list) {
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
            if (model.typeId == 2 || model.typeId == 4 || [model.name containsString:@"神木"]) {
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
    self.keyBalanceLabel.text = [NSString stringWithFormat:@"%ld", (long)self.localKeyBalance];
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
    
    // 3. 伴随 9 个果实交替 Alpha 闪烁
    [self startFruitFlashingAnimation];
    
    // 4. 调用接口发包
    WeakSelf
    [MLGameLotteryService drawWithTypeId:self.typeId times:times success:^(NSArray<MLGameDrawResultModel *> *list, NSInteger totalValue, NSInteger logId) {
        MLChatRoomThemeGameTwoResultView *activeResultView = nil;
        for (UIView *sub in wself.superview.subviews) {
            if ([sub isKindOfClass:[MLChatRoomThemeGameTwoResultView class]]) {
                activeResultView = (MLChatRoomThemeGameTwoResultView *)sub;
                break;
            }
        }
        
        if (activeResultView) {
            [wself stopFruitFlashingAnimation];
            [activeResultView updateGifts:list totalValue:totalValue times:times];
            [wself lockButtons:NO];
            wself.isDrawing = NO;
            [wself loadData]; // 静默更新资产
        } else {
            [wself playDrawAnimationWithGifts:list totalValue:totalValue logId:logId];
        }
    } failure:^(NSError *error) {
        [wself lockButtons:NO];
        wself.isDrawing = NO;
        [wself stopFruitFlashingAnimation];
        
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

- (void)lockButtons:(BOOL)lock {
    self.drawOneButton.enabled = !lock;
    self.drawTenButton.enabled = !lock;
    self.drawHundredButton.enabled = !lock;
    self.backButton.enabled = !lock;
    self.ruleButton.enabled = !lock;
    self.recordButton.enabled = !lock;
}

- (void)playDrawAnimationWithGifts:(NSArray<MLGameDrawResultModel *> *)gifts totalValue:(NSInteger)totalValue logId:(NSInteger)logId {
    self.pendingGifts = gifts;
    self.pendingTotalValue = totalValue;
    
    if (self.svgaPlayer == nil) {
        self.svgaPlayer = [[SVGAPlayer alloc] init];
        self.svgaPlayer.loops = 1;
        self.svgaPlayer.delegate = self;
        self.svgaPlayer.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.svgaPlayer];
        [self.svgaPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    self.svgaPlayer.hidden = NO;
    
    SVGAParser *parser = [[SVGAParser alloc] init];
    NSURL *svgaURL = [[NSBundle mainBundle] URLForResource:@"theme_game_two_harvest" withExtension:@"svga"];
    if (!svgaURL) {
        svgaURL = [[NSBundle mainBundle] URLForResource:@"theme_game_two_draw" withExtension:@"svga"];
    }
    
    if (svgaURL) {
        WeakSelf
        [parser parseWithURL:svgaURL completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            wself.svgaPlayer.videoItem = videoItem;
            [wself.svgaPlayer startAnimation];
        } failureBlock:^(NSError * _Nonnull error) {
            // 解析失败时，兜底直接展示结果
            wself.svgaPlayer.hidden = YES;
            [wself stopFruitFlashingAnimation];
            [wself showResultWithGifts:gifts totalValue:totalValue];
        }];
    } else {
        // 如果没有找到文件，兜底直接展示结果
        self.svgaPlayer.hidden = YES;
        [self stopFruitFlashingAnimation];
        [self showResultWithGifts:gifts totalValue:totalValue];
    }
}

#pragma mark - SVGAPlayerDelegate
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    player.hidden = YES;
    [self stopFruitFlashingAnimation];
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
    [MLChatRoomThemeGameTwoRuleView showInView:self.superview];
}

- (void)recordClick {
    [MLChatRoomThemeGameTwoRecordView showInView:self.superview typeId:self.typeId];
}

- (void)fortuneClick {
    [MLChatRoomThemeGameFortuneView showInView:self.superview consume:self.consumeValue produce:self.produceValue];
}

- (void)openPurchaseDialog {
    WeakSelf
    [MLChatRoomThemeGameTwoPurchaseView showInView:self.superview infoModel:self.infoModel purchaseSuccess:^(NSInteger newKeyBalance) {
        wself.localKeyBalance = newKeyBalance;
        [wself updateBalanceUI];
    }];
}

#pragma mark - Float & Flash Animations
- (void)startPeachFloatingAnimations {
    for (int i = 0; i < self.peachCardViews.count; i++) {
        UIView *card = self.peachCardViews[i];
        [card.layer removeAllAnimations];
        
        NSTimeInterval delay = i * 0.15;
        NSTimeInterval duration = 1.8 + (i % 5) * 0.1;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        animation.fromValue = @(0.0);
        animation.toValue = @(-2.5);
        animation.duration = duration;
        animation.repeatCount = HUGE_VALF;
        animation.autoreverses = YES;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.beginTime = CACurrentMediaTime() + delay;
        [card.layer addAnimation:animation forKey:@"peach_float"];
    }
}

- (void)startFruitFlashingAnimation {
    for (int i = 0; i < self.peachCardViews.count; i++) {
        UIView *card = self.peachCardViews[i];
        [card.layer removeAnimationForKey:@"peach_float"];
        
        CABasicAnimation *flash = [CABasicAnimation animationWithKeyPath:@"opacity"];
        flash.fromValue = @(1.0);
        flash.toValue = @(0.3);
        flash.duration = 0.2 + (i % 3) * 0.1;
        flash.repeatCount = HUGE_VALF;
        flash.autoreverses = YES;
        [card.layer addAnimation:flash forKey:@"peach_flash"];
    }
}

- (void)stopFruitFlashingAnimation {
    for (int i = 0; i < self.peachCardViews.count; i++) {
        UIView *card = self.peachCardViews[i];
        [card.layer removeAnimationForKey:@"peach_flash"];
        card.layer.opacity = 1.0;
    }
    [self startPeachFloatingAnimations];
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

- (void)backClick {
    if (self.isDrawing) {
        return;
    }
    [self dismiss];
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
