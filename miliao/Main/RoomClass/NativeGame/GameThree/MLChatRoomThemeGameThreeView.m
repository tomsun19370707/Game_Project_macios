#import "MLChatRoomThemeGameThreeView.h"
#import "MLGameLotteryService.h"
#import "RoomFloatingWindow.h"
#import "AppDelegate.h"
#import "MLChatRoomThemeGameThreeResultView.h"
#import "MLChatRoomThemeGameThreeRuleView.h"
#import "MLChatRoomThemeGameThreeRecordView.h"
#import "MLChatRoomThemeGameThreePurchaseView.h"
#import "MLChatRoomThemeGameFortuneView.h"
#import "MLChatRoomMarqueeLabel.h"
#import "Global.h"
#import "UIViewController+CurViewController.h"
#import "CFMWalletDiamondRechargeVc.h"
#import <Masonry/Masonry.h>

@interface MLChatRoomThemeGameThreeView ()

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *ringImageView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIButton *ruleButton;
@property (nonatomic, strong) UIButton *recordButton;

@property (nonatomic, strong) UIView *diamondBarView;
@property (nonatomic, strong) UIView *keyBarView;

@property (nonatomic, strong) UILabel *keyBalanceLabel;
@property (nonatomic, strong) UIButton *keyPlusButton;
@property (nonatomic, strong) UILabel *diamondBalanceLabel;
@property (nonatomic, strong) UIButton *diamondPlusButton;

@property (nonatomic, strong) UIButton *drawOneButton;
@property (nonatomic, strong) UIButton *drawTenButton;
@property (nonatomic, strong) UIButton *drawHundredButton;

@property (nonatomic, strong) NSMutableArray<UIView *> *giftCardViews;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *giftImageViews;
@property (nonatomic, strong) NSMutableArray<UILabel *> *giftNameLabels;

@property (nonatomic, strong) MLGameLotteryInfoModel *infoModel;
@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *prizesInPool;

@property (nonatomic, assign) BOOL isDrawing;
@property (nonatomic, assign) NSInteger localKeyBalance;
@property (nonatomic, assign) NSInteger lastDrawTimes;
@property (nonatomic, assign) NSInteger lastDrawCost;

@property (nonatomic, assign) NSInteger consumeValue;
@property (nonatomic, assign) NSInteger produceValue;

@end

@implementation MLChatRoomThemeGameThreeView

+ (void)showInView:(UIView *)parentView typeId:(NSInteger)typeId {
    MLChatRoomThemeGameThreeView *gameView = [[MLChatRoomThemeGameThreeView alloc] initWithFrame:parentView.bounds typeId:typeId];
    [parentView addSubview:gameView];
    [gameView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame typeId:(NSInteger)typeId {
    if (self = [super initWithFrame:frame]) {
        self.typeId = typeId;
        self.giftCardViews = [NSMutableArray array];
        self.giftImageViews = [NSMutableArray array];
        self.giftNameLabels = [NSMutableArray array];
        
        [self setupUI];
        [self loadData];
        
        // 隐藏常驻最顶层的语音悬浮球
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
    
    // 背景大图 (锁定 750:1267 比例，在宽屏设备上限宽 390 pt 居中，防拉伸与漂移)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_three_clean_bg"];
    if (_bgImageView.image == nil) {
        _bgImageView.backgroundColor = mHexRGB(0x0E1920); // 玩法三太空背景色兜底
    }
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(self).priorityMedium();
        make.width.mas_lessThanOrEqualTo(390).priorityHigh();
        make.height.mas_equalTo(_bgImageView.mas_width).multipliedBy(1267.0 / 750.0);
    }];
    
    // 头部信息与控制区语义容器 (HUDContainer)
    UIView *hudContainer = [[UIView alloc] init];
    hudContainer.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:hudContainer];
    [hudContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(_bgImageView);
        make.height.mas_equalTo(KDialogAdaptedWidth(150));
    }];

    // 规则说明按钮 (左侧悬浮, 对齐 375x812 pt 视口)
    _ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ruleButton setBackgroundImage:[UIImage imageNamed:@"theme_game_three_rule_btn"] forState:UIControlStateNormal];
    [_ruleButton addTarget:self action:@selector(ruleClick) forControlEvents:UIControlEventTouchUpInside];
    [hudContainer addSubview:_ruleButton];
    [_ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(104));
        make.leading.mas_equalTo(KDialogAdaptedWidth(4));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(67.146f), KDialogAdaptedWidth(30.324f)));
    }];

    // 游戏记录按钮 (右侧悬浮, 对齐 375x812 pt 视口)
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"theme_game_three_record_btn"] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
    [hudContainer addSubview:_recordButton];
    [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(104));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(4));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(67.146f), KDialogAdaptedWidth(30.324f)));
    }];
    
    // 今日运势悬浮条 (挂载在大背景最右上角，飘出面板顶边缘)
    UIView *fortuneBar = [[UIView alloc] init];
    fortuneBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    setViewCorner(fortuneBar, KDialogAdaptedWidth(15));
    fortuneBar.userInteractionEnabled = YES;
    [_bgImageView addSubview:fortuneBar];
    [fortuneBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-KDialogAdaptedWidth(38));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(70), KDialogAdaptedWidth(30)));
    }];
    
    UITapGestureRecognizer *fortuneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fortuneClick)];
    [fortuneBar addGestureRecognizer:fortuneTap];
    
    UILabel *fortuneLabel = [[UILabel alloc] init];
    fortuneLabel.text = @"今日运势";
    fortuneLabel.textColor = mHexRGB(0xE1F5FE);
    fortuneLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(11)];
    fortuneLabel.textAlignment = NSTextAlignmentCenter;
    [fortuneBar addSubview:fortuneLabel];
    [fortuneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(fortuneBar);
    }];
    
    // 圆环背景底座 (置于转盘后层，对齐大背景)
    _ringImageView = [[UIImageView alloc] init];
    _ringImageView.image = [UIImage imageNamed:@"theme_game_three_ring_bg"];
    [_bgImageView addSubview:_ringImageView];
    [_ringImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgImageView.mas_leading).offset(KDialogAdaptedWidth(187.5f));
        make.centerY.mas_equalTo(_bgImageView.mas_top).offset(KDialogAdaptedWidth(298.0f));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(371.8f), KDialogAdaptedWidth(371.8f)));
    }];
    
    // 吉祥物角色 (同心对齐圆环底板，完全防漂移)
    UIImageView *characterView = [[UIImageView alloc] init];
    characterView.image = [UIImage imageNamed:@"theme_game_three_character"];
    characterView.contentMode = UIViewContentModeScaleAspectFit;
    [_bgImageView addSubview:characterView];
    [characterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_ringImageView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(220.5), KDialogAdaptedWidth(259.5)));
    }];
    
    // 8宫格转盘底框容器 (全屏等比对齐背景图)
    UIView *cardsContainer = [[UIView alloc] init];
    cardsContainer.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:cardsContainer];
    [cardsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_bgImageView);
    }];
    
    [self layout8GiftCardsInContainer:cardsContainer];
    
    // 底部“品”字形启航按钮容器 (ActionContainer 底座)
    UIView *drawButtonsContainer = [[UIView alloc] init];
    [_bgImageView addSubview:drawButtonsContainer];
    [drawButtonsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgImageView);
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(14));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(256), KDialogAdaptedWidth(112)));
    }];
    
    // 百祥落盘 (100次 - 中间靠上)
    _drawHundredButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawHundredButton setImage:[UIImage imageNamed:@"theme_game_three_draw100_btn"] forState:UIControlStateNormal];
    [_drawHundredButton addTarget:self action:@selector(drawHundredClick) forControlEvents:UIControlEventTouchUpInside];
    [drawButtonsContainer addSubview:_drawHundredButton];
    [_drawHundredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(drawButtonsContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(104), KDialogAdaptedWidth(60)));
    }];
    
    // 钻石余额栏 (左对齐，距底盘左边缘 18 pt，悬浮在抽奖容器上方 18 pt)
    _diamondBarView = [[UIView alloc] init];
    _diamondBarView.backgroundColor = [UIColor colorWithRed:106.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:0.48];
    setViewCorner(_diamondBarView, KDialogAdaptedWidth(4));
    [_bgImageView addSubview:_diamondBarView];
    [_diamondBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(18));
        make.bottom.mas_equalTo(drawButtonsContainer.mas_top).offset(-KDialogAdaptedWidth(18));
        make.height.mas_equalTo(KDialogAdaptedWidth(28));
    }];
    
    UIImageView *diaIcon = [[UIImageView alloc] init];
    diaIcon.image = [UIImage imageNamed:@"theme_game_three_diamond_icon"];
    [_diamondBarView addSubview:diaIcon];
    [diaIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(6));
        make.centerY.mas_equalTo(_diamondBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(32), KDialogAdaptedWidth(32)));
    }];
    
    _diamondBalanceLabel = [[UILabel alloc] init];
    _diamondBalanceLabel.textColor = kWhiteColor;
    _diamondBalanceLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(13)];
    _diamondBalanceLabel.text = @"0";
    [_diamondBarView addSubview:_diamondBalanceLabel];
    [_diamondBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(diaIcon.mas_trailing).offset(KDialogAdaptedWidth(4));
        make.centerY.mas_equalTo(_diamondBarView);
    }];
    
    _diamondPlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_diamondPlusButton setImage:[UIImage imageNamed:@"theme_game_three_plus_icon"] forState:UIControlStateNormal];
    [_diamondPlusButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
    [_diamondBarView addSubview:_diamondPlusButton];
    [_diamondPlusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_diamondBalanceLabel.mas_trailing).offset(KDialogAdaptedWidth(6));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(6));
        make.centerY.mas_equalTo(_diamondBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(28), KDialogAdaptedWidth(28)));
    }];
    
    // 钥匙余额栏 (右对齐，距底盘右边缘 18 pt，悬浮在抽奖容器上方 18 pt)
    _keyBarView = [[UIView alloc] init];
    _keyBarView.backgroundColor = [UIColor colorWithRed:106.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:0.48];
    setViewCorner(_keyBarView, KDialogAdaptedWidth(4));
    [_bgImageView addSubview:_keyBarView];
    [_keyBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(18));
        make.bottom.mas_equalTo(drawButtonsContainer.mas_top).offset(-KDialogAdaptedWidth(18));
        make.height.mas_equalTo(KDialogAdaptedWidth(28));
    }];
    
    UIImageView *keyIcon = [[UIImageView alloc] init];
    keyIcon.image = [UIImage imageNamed:@"theme_game_three_purchase_key_icon"];
    [_keyBarView addSubview:keyIcon];
    [keyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(6));
        make.centerY.mas_equalTo(_keyBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(30), KDialogAdaptedWidth(30)));
    }];
    
    _keyBalanceLabel = [[UILabel alloc] init];
    _keyBalanceLabel.textColor = kWhiteColor;
    _keyBalanceLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(12)];
    _keyBalanceLabel.text = @"0";
    [_keyBarView addSubview:_keyBalanceLabel];
    [_keyBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(keyIcon.mas_trailing).offset(KDialogAdaptedWidth(4));
        make.centerY.mas_equalTo(_keyBarView);
    }];
    
    _keyPlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_keyPlusButton setImage:[UIImage imageNamed:@"theme_game_three_plus_icon"] forState:UIControlStateNormal];
    [_keyPlusButton addTarget:self action:@selector(openPurchaseDialog) forControlEvents:UIControlEventTouchUpInside];
    [_keyBarView addSubview:_keyPlusButton];
    [_keyPlusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_keyBalanceLabel.mas_trailing).offset(KDialogAdaptedWidth(6));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(6));
        make.centerY.mas_equalTo(_keyBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(28), KDialogAdaptedWidth(28)));
    }];
    
    // 一星纳福 (1次 - 底部靠左)
    _drawOneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawOneButton setImage:[UIImage imageNamed:@"theme_game_three_draw1_btn"] forState:UIControlStateNormal];
    [_drawOneButton addTarget:self action:@selector(drawOneClick) forControlEvents:UIControlEventTouchUpInside];
    [drawButtonsContainer addSubview:_drawOneButton];
    [_drawOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(104), KDialogAdaptedWidth(60)));
    }];
    
    // 十运齐聚 (10次 - 底部靠右)
    _drawTenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawTenButton setImage:[UIImage imageNamed:@"theme_game_three_draw10_btn"] forState:UIControlStateNormal];
    [_drawTenButton addTarget:self action:@selector(drawTenClick) forControlEvents:UIControlEventTouchUpInside];
    [drawButtonsContainer addSubview:_drawTenButton];
    [_drawTenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(104), KDialogAdaptedWidth(60)));
    }];
}

#pragma mark - 8宫格转盘底框容器 (圆形排布布局)
- (void)layout8GiftCardsInContainer:(UIView *)container {
    static const CGPoint SLOT_CENTERS[] = {
        {187.5f, 164.0f},   // 1 (0度)
        {268.45f, 203.25f}, // 2 (45度)
        {302.0f, 298.0f},   // 3 (90度)
        {268.45f, 392.75f}, // 4 (135度)
        {187.5f, 432.0f},   // 5 (180度)
        {106.55f, 392.75f}, // 6 (225度)
        {73.0f, 298.0f},    // 7 (270度)
        {106.55f, 203.25f}  // 8 (315度)
    };
    
    for (int i = 0; i < 8; i++) {
        UIView *card = [[UIView alloc] init];
        card.backgroundColor = [UIColor clearColor];
        [container addSubview:card];
        [self.giftCardViews addObject:card];
        
        // 格子底板背景 (正圆/正方形 62x62 pt 对齐顶边缘)
        UIImageView *cardBg = [[UIImageView alloc] init];
        cardBg.image = [UIImage imageNamed:@"theme_game_three_gift_board"];
        cardBg.contentMode = UIViewContentModeScaleToFill;
        [card addSubview:cardBg];
        [cardBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(card);
            make.height.mas_equalTo(KDialogAdaptedWidth(62));
        }];
        
        // 呼吸选定光圈层 (绑定于圆形 cardBg, Tag 999)
        UIView *overlay = [[UIView alloc] init];
        overlay.layer.borderColor = mHexRGB(0xFFE400).CGColor;
        overlay.layer.borderWidth = 2.0;
        overlay.backgroundColor = [UIColor colorWithRed:1 green:0.9 blue:0 alpha:0.25];
        overlay.layer.cornerRadius = KDialogAdaptedWidth(31.0f);
        overlay.clipsToBounds = YES;
        overlay.hidden = YES;
        overlay.tag = 999;
        [card addSubview:overlay];
        [overlay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(cardBg);
        }];
        
        // 礼物小图 (居中嵌套在圆形 cardBg 内部，内边距 6 pt)
        UIImageView *giftImg = [[UIImageView alloc] init];
        giftImg.contentMode = UIViewContentModeScaleAspectFit;
        [card addSubview:giftImg];
        [giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(cardBg).insets(UIEdgeInsetsMake(KDialogAdaptedWidth(6), KDialogAdaptedWidth(6), KDialogAdaptedWidth(6), KDialogAdaptedWidth(6)));
        }];
        [self.giftImageViews addObject:giftImg];
        
        // 礼物名称标签 (居中位于圆形底盘下方)
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(7.5)];
        nameLabel.textColor = mHexRGB(0xE6EAFE);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [card addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cardBg.mas_bottom).offset(KDialogAdaptedWidth(0.5f));
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(KDialogAdaptedWidth(7.5));
        }];
        [self.giftNameLabels addObject:nameLabel];
        
        // 价格标签 (居中位于名称标签下方)
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(6.5)];
        priceLabel.textColor = mHexRGB(0xFFE66F);
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.tag = 888; // tag for dynamic pricing binding
        [card addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(KDialogAdaptedWidth(0.5f));
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(KDialogAdaptedWidth(6.5));
        }];
        
        CGPoint center = SLOT_CENTERS[i];
        [card mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(container.mas_leading).offset(KDialogAdaptedWidth(center.x));
            make.centerY.mas_equalTo(container.mas_top).offset(KDialogAdaptedWidth(center.y));
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(62), KDialogAdaptedWidth(74)));
        }];
    }
}

#pragma mark - 数据请求
- (void)loadData {
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
        NSInteger diamondInt = (NSInteger)diamondDouble;
        wself.diamondBalanceLabel.text = [NSString stringWithFormat:@"%ld", (long)diamondInt];
        wself.localKeyBalance = moneyModel.lottery_coin;
        [wself updateBalanceUI];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 2. 详情、价格
    [MLGameLotteryService getRoomDetailWithTypeId:self.typeId success:^(MLGameLotteryInfoModel *model) {
        if (!wself) return;
        if (!model || model == (id)[NSNull null] || ![model isKindOfClass:[MLGameLotteryInfoModel class]]) {
            return;
        }
        wself.infoModel = model;
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 3. 18 格大奖列表
    [MLGameLotteryService getPrizesWithTypeId:self.typeId success:^(NSArray<MLGameDrawResultModel *> *list) {
        if (!wself) return;
        if (!list || ![list isKindOfClass:[NSArray class]]) {
            return;
        }
        wself.prizesInPool = list;
        [wself renderGiftBoard];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 4. 今日运势 (星辰序章 typeId == 5 / lottery_id == 3)
    [MLGameLotteryService getFortuneLotteryListWithSuccess:^(NSArray<MLGameLotteryInfoModel *> *list) {
        if (!wself) return;
        if (!list || ![list isKindOfClass:[NSArray class]]) {
            return;
        }
        for (MLGameLotteryInfoModel *model in list) {
            if (model.typeId == 3 || model.typeId == 5 || [model.name containsString:@"星辰"]) {
                wself.consumeValue = model.consume_diamonds;
                wself.produceValue = model.produce_diamonds;
                break;
            }
        }
    } failure:^(NSError *error) {
        // 静默
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
            nameLabel.text = prize.name;
        }
    }
}

- (void)updateBalanceUI {
    _keyBalanceLabel.text = [NSString stringWithFormat:@"%ld", (long)_localKeyBalance];
}

#pragma mark - 交互点击与抽奖逻辑
- (void)drawOneClick {
    [self drawWithTimes:1 cost:200];
}

- (void)drawTenClick {
    [self drawWithTimes:10 cost:2000];
}

- (void)drawHundredClick {
    [self drawWithTimes:100 cost:20000];
}

- (void)drawWithTimes:(NSInteger)times cost:(NSInteger)cost {
    if (self.isDrawing) return;
    
    if (self.localKeyBalance < cost) {
        [self openPurchaseDialog];
        return;
    }
    
    // 乐观扣钱
    self.isDrawing = YES;
    [self lockButtons:YES];
    
    self.lastDrawTimes = times;
    self.lastDrawCost = cost;
    
    NSInteger originalBalance = self.localKeyBalance;
    self.localKeyBalance -= cost;
    [self updateBalanceUI];
    
    WeakSelf
    [MLGameLotteryService drawWithTypeId:self.typeId times:times success:^(NSArray<MLGameDrawResultModel *> *list, NSInteger totalValue, NSInteger logId) {
        // 插值减速落点算法：寻找中奖奖品中价值最高的那个
        NSInteger targetIndex = 0;
        NSInteger maxPrice = -1;
        for (MLGameDrawResultModel *result in list) {
            NSInteger poolIndex = -1;
            for (NSInteger i = 0; i < wself.prizesInPool.count; i++) {
                if (wself.prizesInPool[i].giftId == result.giftId) {
                    poolIndex = i;
                    break;
                }
            }
            if (poolIndex != -1 && result.price > maxPrice) {
                maxPrice = result.price;
                targetIndex = poolIndex;
            }
        }
        
        if (maxPrice == -1) {
            targetIndex = 0;
        }
        
        // 执行减速旋转动画
        [wself runDeceleratingAnimationToTargetIndex:targetIndex completion:^{
            [wself lockButtons:NO];
            wself.isDrawing = NO;
            // 清理光圈
            for (UIView *card in wself.giftCardViews) {
                [card viewWithTag:999].hidden = YES;
            }
            // 模态弹框结算
            [MLChatRoomThemeGameThreeResultView showInView:wself.superview gifts:list totalValue:totalValue times:times retryBlock:^{
                [wself drawWithTimes:times cost:cost];
            }];
            [wself loadData];
        }];
        
    } failure:^(NSError *error) {
        // 报错回滚
        wself.localKeyBalance = originalBalance;
        [wself updateBalanceUI];
        wself.isDrawing = NO;
        [wself lockButtons:NO];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - 最高价落点插值减速旋转算法
- (void)runDeceleratingAnimationToTargetIndex:(NSInteger)targetIndex completion:(void(^)(void))completion {
    [self runDeceleratingAnimationStep:0 target:targetIndex completion:completion];
}

- (void)runDeceleratingAnimationStep:(NSInteger)currentStep target:(NSInteger)targetIndex completion:(void(^)(void))completion {
    NSInteger minRounds = 2;
    NSInteger totalSteps = minRounds * 8 + targetIndex;
    
    // 清理光圈
    for (UIView *card in self.giftCardViews) {
        [card viewWithTag:999].hidden = YES;
    }
    
    NSInteger currentIndex = currentStep % 8;
    if (currentIndex < self.giftCardViews.count) {
        UIView *currentCard = self.giftCardViews[currentIndex];
        [currentCard viewWithTag:999].hidden = NO;
    }
    
    if (currentStep >= totalSteps) {
        if (completion) {
            completion();
        }
        return;
    }
    
    double progress = (double)(currentStep + 1) / (double)totalSteps;
    double delay = 0.04 + 0.35 * pow(progress, 2.5); // 渐进阻尼减速效果
    
    WeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wself runDeceleratingAnimationStep:currentStep + 1 target:targetIndex completion:completion];
    });
}

- (void)lockButtons:(BOOL)lock {
    _drawOneButton.enabled = !lock;
    _drawTenButton.enabled = !lock;
    _drawHundredButton.enabled = !lock;
}

- (void)ruleClick {
    [MLChatRoomThemeGameThreeRuleView showInView:self.superview];
}

- (void)recordClick {
    [MLChatRoomThemeGameThreeRecordView showInView:self.superview typeId:self.typeId];
}

- (void)fortuneClick {
    [MLChatRoomThemeGameFortuneView showInView:self.superview consume:self.consumeValue produce:self.produceValue];
}

- (void)openPurchaseDialog {
    WeakSelf
    [MLChatRoomThemeGameThreePurchaseView showInView:self.superview infoModel:self.infoModel purchaseSuccess:^(NSInteger newKeyBalance) {
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
    if (self.isDrawing) return;
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
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.roomViewController && appDelegate.roomViewController.floatingWindow) {
        appDelegate.roomViewController.floatingWindow.hidden = NO;
    }
}

@end
