#import "MLChatRoomThemeGameOneExchangeView.h"
#import "MLGameLotteryService.h"
#import "FFHomeHandel.h"
#import "Global.h"
#import "MLNetWorkHelper.h"

@interface MLChatRoomThemeGameOneExchangeView ()

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) NSArray *exchangeConfigs; // 兑换配置列表
@property (nonatomic, assign) NSInteger activeConfigIndex; // 当前选中的页签索引

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView; // 344 * 528 pt

@property (nonatomic, strong) UIImageView *timeIconView; // 倒计时图标
@property (nonatomic, strong) NSMutableArray<UIButton *> *tabButtons;

// 终极奖品礼物大外框 (theme_game_one_exchange_gift_large.png, 106 * 104 pt)
@property (nonatomic, strong) UIImageView *giftLargeFrameView;
@property (nonatomic, strong) UIImageView *targetGiftImageView; // 56 * 56 pt
@property (nonatomic, strong) UILabel *targetGiftNameLabel;

// 高级底座 (theme_game_one_exchange_board.png, 284 * 133 pt)
@property (nonatomic, strong) UIImageView *exchangeBoardView;

// 左右消耗小框 (theme_game_one_exchange_gift_small.png, 64 * 65 pt)
@property (nonatomic, strong) UIImageView *leftSmallBoxView;
@property (nonatomic, strong) UIImageView *rightSmallBoxView;

@property (nonatomic, strong) UIImageView *leftIconView; // 钻石碎片
@property (nonatomic, strong) UIImageView *rightIconView; // 藏宝图
@property (nonatomic, strong) UILabel *leftCostLabel; // gem_cost/owned
@property (nonatomic, strong) UILabel *rightCostLabel; // card_invested/owned

@property (nonatomic, strong) UIButton *cardSelectButton; // 透明的覆盖在右小框上的循环点击按钮
@property (nonatomic, strong) UILabel *successRateLabel;
@property (nonatomic, strong) UIButton *confirmExchangeButton; // 244 * 49 pt

@property (nonatomic, assign) NSInteger selectedCardCount; // 投入的藏宝图数量
@property (nonatomic, assign) NSInteger maxOwnedCards; // 用户拥有的最大藏宝图数
@property (nonatomic, assign) NSInteger ownedGemCount; // 拥有的宝石碎片数

@end

@implementation MLChatRoomThemeGameOneExchangeView

+ (void)showInView:(UIView *)parentView typeId:(NSInteger)typeId {
    MLChatRoomThemeGameOneExchangeView *exchangeView = [[MLChatRoomThemeGameOneExchangeView alloc] initWithFrame:parentView.bounds typeId:typeId];
    [parentView addSubview:exchangeView];
    [exchangeView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame typeId:(NSInteger)typeId {
    if (self = [super initWithFrame:frame]) {
        self.typeId = typeId;
        self.activeConfigIndex = 0;
        self.selectedCardCount = 0;
        self.maxOwnedCards = 5; // 默认兜底 5 张
        self.ownedGemCount = 0;
        self.tabButtons = [NSMutableArray array];
        
        [self setupUI];
        [self loadExchangeData];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tap];
    
    // 背景弹窗 (344 * 528 pt, AspectFit 填充，禁止拉伸)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_one_exchange_popup_board"];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(344, 528));
    }];
    
    // 倒计时图标 (theme_game_one_exchange_time.png, 28 * 34 pt, 距顶 21 pt, 距右 30 pt)
    _timeIconView = [[UIImageView alloc] init];
    _timeIconView.image = [UIImage imageNamed:@"theme_game_one_exchange_time"];
    _timeIconView.contentMode = UIViewContentModeScaleAspectFit;
    [_bgImageView addSubview:_timeIconView];
    [_timeIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(21);
        make.trailing.mas_equalTo(-30);
        make.size.mas_equalTo(CGSizeMake(28, 34));
    }];
    
    // 5页签选择栏 (星辰/皓月/银河/荣耀/传奇)
    // 宽度 54, 高度 23. 距顶 74. 页签左起点为 18/82/146/210/274
    NSArray *tabSelectedNames = @[
        @"theme_game_one_exchange_tab_star_selected",
        @"theme_game_one_exchange_tab_moon_selected",
        @"theme_game_one_exchange_tab_galaxy_selected",
        @"theme_game_one_exchange_tab_glory_selected",
        @"theme_game_one_exchange_tab_legend_selected"
    ];
    NSArray *tabNormalNames = @[
        @"theme_game_one_exchange_tab_star_normal",
        @"theme_game_one_exchange_tab_moon_normal",
        @"theme_game_one_exchange_tab_galaxy_normal",
        @"theme_game_one_exchange_tab_glory_normal",
        @"theme_game_one_exchange_tab_legend_normal"
    ];
    
    NSArray *tabLeftOffsets = @[@18, @82, @146, @210, @274];
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:tabNormalNames[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:tabSelectedNames[i]] forState:UIControlStateSelected];
        btn.tag = i;
        [btn addTarget:self action:@selector(tabClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgImageView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(74);
            make.leading.mas_equalTo([tabLeftOffsets[i] floatValue]);
            make.size.mas_equalTo(CGSizeMake(54, 23));
        }];
        [self.tabButtons addObject:btn];
    }
    
    // 终极奖品礼物大外框 (theme_game_one_exchange_gift_large.png, 106 * 104 pt, 距顶 126 pt, 居中)
    _giftLargeFrameView = [[UIImageView alloc] init];
    _giftLargeFrameView.image = [UIImage imageNamed:@"theme_game_one_exchange_gift_large"];
    _giftLargeFrameView.contentMode = UIViewContentModeScaleToFill;
    [_bgImageView addSubview:_giftLargeFrameView];
    [_giftLargeFrameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(126);
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(106, 104));
    }];
    
    // 内藏礼物图片 (宽 56, 高 56 pt, 距大框顶 14 pt, 居中)
    _targetGiftImageView = [[UIImageView alloc] init];
    _targetGiftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_giftLargeFrameView addSubview:_targetGiftImageView];
    [_targetGiftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.centerX.mas_equalTo(_giftLargeFrameView);
        make.size.mas_equalTo(CGSizeMake(56, 56));
    }];
    
    _targetGiftNameLabel = [[UILabel alloc] init];
    _targetGiftNameLabel.textColor = kWhiteColor;
    _targetGiftNameLabel.font = [UIFont boldSystemFontOfSize:11];
    _targetGiftNameLabel.textAlignment = NSTextAlignmentCenter;
    [_giftLargeFrameView addSubview:_targetGiftNameLabel];
    [_targetGiftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.leading.trailing.mas_equalTo(_giftLargeFrameView);
    }];
    
    // 高级底座 (theme_game_one_exchange_board.png, 284 * 133 pt, 距顶 238 pt, 居中)
    _exchangeBoardView = [[UIImageView alloc] init];
    _exchangeBoardView.image = [UIImage imageNamed:@"theme_game_one_exchange_board"];
    _exchangeBoardView.contentMode = UIViewContentModeScaleToFill;
    _exchangeBoardView.userInteractionEnabled = YES;
    [_bgImageView addSubview:_exchangeBoardView];
    [_exchangeBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(238);
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(284, 133));
    }];
    
    // 左侧消耗小框 (theme_game_one_exchange_gift_small.png, 64 * 65 pt, 距顶 270 pt, 距左 68 pt)
    _leftSmallBoxView = [[UIImageView alloc] init];
    _leftSmallBoxView.image = [UIImage imageNamed:@"theme_game_one_exchange_gift_small"];
    _leftSmallBoxView.contentMode = UIViewContentModeScaleToFill;
    [_bgImageView addSubview:_leftSmallBoxView];
    [_leftSmallBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(270);
        make.leading.mas_equalTo(_bgImageView.mas_leading).offset(68);
        make.size.mas_equalTo(CGSizeMake(64, 65));
    }];
    
    // 钻石碎片图标 (30 * 30 pt, 距小框顶 8 pt, 居中)
    _leftIconView = [[UIImageView alloc] init];
    _leftIconView.image = [UIImage imageNamed:@"theme_game_one_cover_diamond"];
    _leftIconView.contentMode = UIViewContentModeScaleAspectFit;
    [_leftSmallBoxView addSubview:_leftIconView];
    [_leftIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.centerX.mas_equalTo(_leftSmallBoxView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    _leftCostLabel = [[UILabel alloc] init];
    _leftCostLabel.textColor = mHexRGB(0xFFE400);
    _leftCostLabel.font = [UIFont boldSystemFontOfSize:10];
    _leftCostLabel.textAlignment = NSTextAlignmentCenter;
    [_leftSmallBoxView addSubview:_leftCostLabel];
    [_leftCostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-6);
        make.leading.trailing.mas_equalTo(_leftSmallBoxView);
    }];
    
    // 右侧消耗小框 (theme_game_one_exchange_gift_small.png, 64 * 65 pt, 距顶 270 pt, 距右 68 pt)
    _rightSmallBoxView = [[UIImageView alloc] init];
    _rightSmallBoxView.image = [UIImage imageNamed:@"theme_game_one_exchange_gift_small"];
    _rightSmallBoxView.contentMode = UIViewContentModeScaleToFill;
    _rightSmallBoxView.userInteractionEnabled = YES;
    [_bgImageView addSubview:_rightSmallBoxView];
    [_rightSmallBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(270);
        make.trailing.mas_equalTo(_bgImageView.mas_trailing).offset(-68);
        make.size.mas_equalTo(CGSizeMake(64, 65));
    }];
    
    // 藏宝图图标 (30 * 30 pt, 距小框顶 8 pt, 居中)
    _rightIconView = [[UIImageView alloc] init];
    _rightIconView.image = [UIImage imageNamed:@"theme_game_one_cover_box"];
    _rightIconView.contentMode = UIViewContentModeScaleAspectFit;
    [_rightSmallBoxView addSubview:_rightIconView];
    [_rightIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.centerX.mas_equalTo(_rightSmallBoxView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    _rightCostLabel = [[UILabel alloc] init];
    _rightCostLabel.textColor = mHexRGB(0xFFE400);
    _rightCostLabel.font = [UIFont boldSystemFontOfSize:10];
    _rightCostLabel.textAlignment = NSTextAlignmentCenter;
    [_rightSmallBoxView addSubview:_rightCostLabel];
    [_rightCostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-6);
        make.leading.trailing.mas_equalTo(_rightSmallBoxView);
    }];
    
    // 中间加号 (theme_game_one_exchange_plus.png, 19 * 19 pt, 距顶 292 pt, 居中)
    UIImageView *plusIcon = [[UIImageView alloc] init];
    plusIcon.image = [UIImage imageNamed:@"theme_game_one_exchange_plus"];
    plusIcon.contentMode = UIViewContentModeScaleAspectFit;
    [_bgImageView addSubview:plusIcon];
    [plusIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(292);
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(19, 19));
    }];
    
    // 右小框上的透明覆盖点击按钮
    _cardSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cardSelectButton.backgroundColor = [UIColor clearColor];
    [_cardSelectButton addTarget:self action:@selector(cardSelectClick) forControlEvents:UIControlEventTouchUpInside];
    [_rightSmallBoxView addSubview:_cardSelectButton];
    [_cardSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_rightSmallBoxView);
    }];
    
    // 成功率显示 Label (放置在底座下方，高 20, 距顶 390, 居中)
    _successRateLabel = [[UILabel alloc] init];
    _successRateLabel.textColor = mHexRGB(0xFFE400);
    _successRateLabel.font = KFontBoldA(12);
    _successRateLabel.textAlignment = NSTextAlignmentCenter;
    _successRateLabel.text = @"兑换成功率: 0%";
    [_bgImageView addSubview:_successRateLabel];
    [_successRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(390);
        make.centerX.mas_equalTo(_bgImageView);
    }];
    
    // 确认兑换大按钮 (theme_game_one_exchange_confirm.png, 244 * 49 pt, 距顶 444 pt, 居中)
    _confirmExchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmExchangeButton setImage:[UIImage imageNamed:@"theme_game_one_exchange_confirm"] forState:UIControlStateNormal];
    [_confirmExchangeButton addTarget:self action:@selector(confirmExchangeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_confirmExchangeButton];
    [_confirmExchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(444);
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(244, 49));
    }];
}

- (void)initMockConfigs {
    self.exchangeConfigs = @[
        @{
            @"exchange_id": @(3000244),
            @"type_id": @(self.typeId),
            @"tab_name": @"星辰",
            @"gift_id": @(244),
            @"gift": @{
                @"id": @(244),
                @"name": @"星辰礼物",
                @"pic": @"",
                @"price": @(52000000)
            },
            @"gem_gift_id": @(107),
            @"gem_cost": @(10),
            @"card_gift_id": @(107),
            @"success_rate": @(10),
            @"is_virtual": @(1)
        },
        @{
            @"exchange_id": @(3000245),
            @"type_id": @(self.typeId),
            @"tab_name": @"皓月",
            @"gift_id": @(245),
            @"gift": @{
                @"id": @(245),
                @"name": @"皓月礼物",
                @"pic": @"",
                @"price": @(52000000)
            },
            @"gem_gift_id": @(107),
            @"gem_cost": @(20),
            @"card_gift_id": @(107),
            @"success_rate": @(20),
            @"is_virtual": @(1)
        }
    ];
}

#pragma mark - 数据请求

- (void)loadExchangeData {
    // 1. 获取个人钻石碎片/藏宝图资产
    // 静默加载，拉取最新配置后再读取对应 gift_id 匹配
    WeakSelf
    [MLGameLotteryService exchangeConfigWithTypeId:self.typeId success:^(id responseObject) {
        if (responseObject && responseObject != [NSNull null] && [responseObject isKindOfClass:[NSArray class]] && [(NSArray *)responseObject count] > 0) {
            wself.exchangeConfigs = responseObject;
        } else {
            [wself initMockConfigs];
        }
        [wself renderTabs];
        [wself selectActiveTab];
        
        if (wself.exchangeConfigs.count > 0) {
            id config = wself.exchangeConfigs.firstObject;
            if (config && config != [NSNull null] && [config isKindOfClass:[NSDictionary class]]) {
                NSInteger gemId = [config[@"gem_gift_id"] integerValue];
                NSInteger cardId = [config[@"card_gift_id"] integerValue];
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"page"] = @"1";
                params[@"size"] = @"100";
                params[@"is_send"] = @"1";
                
                NSString *bagUrl = [NSString stringWithFormat:@"%@api/user/getMyKnapsack", VERSION_HTTPS_SERVER];
                [MLNetWorkHelper POST:bagUrl parameters:[MLGameLotteryService buildParams:params] success:^(id bagResponse) {
                    if (bagResponse && [bagResponse[@"code"] integerValue] == 1) {
                        NSArray *dataArr = bagResponse[@"data"];
                        NSInteger foundGem = 0;
                        NSInteger foundCard = 0;
                        for (id item in dataArr) {
                            if ([item isKindOfClass:[NSDictionary class]]) {
                                NSInteger gId = [item[@"gift_id"] integerValue];
                                NSInteger num = [item[@"nums"] integerValue];
                                if (gId == gemId) {
                                    foundGem = num;
                                }
                                if (gId == cardId) {
                                    foundCard = num;
                                }
                            }
                        }
                        wself.ownedGemCount = foundGem;
                        wself.maxOwnedCards = foundCard;
                        [wself selectActiveTab];
                    }
                } failure:nil];
            }
        }
    } failure:^(NSError *error) {
        [wself initMockConfigs];
        [wself renderTabs];
        [wself selectActiveTab];
    }];
}

- (void)renderTabs {
    for (int i = 0; i < self.tabButtons.count; i++) {
        UIButton *btn = self.tabButtons[i];
        if (i < self.exchangeConfigs.count) {
            btn.hidden = NO;
        } else {
            btn.hidden = YES;
        }
    }
    [self selectActiveTab];
}

- (void)selectActiveTab {
    if (self.exchangeConfigs.count == 0) return;
    
    if (self.activeConfigIndex >= self.exchangeConfigs.count) {
        self.activeConfigIndex = 0;
    }
    
    // 页签高亮
    for (int i = 0; i < self.tabButtons.count; i++) {
        self.tabButtons[i].selected = (i == self.activeConfigIndex);
    }
    
    NSDictionary *activeConfig = self.exchangeConfigs[self.activeConfigIndex];
    if (activeConfig == nil || activeConfig == [NSNull null] || ![activeConfig isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSDictionary *gift = activeConfig[@"gift"];
    if (gift == nil || gift == [NSNull null] || ![gift isKindOfClass:[NSDictionary class]]) {
        gift = nil;
    }
    
    _targetGiftNameLabel.text = gift ? (gift[@"name"] ?: @"高级礼物") : @"高级礼物";
    
    NSString *giftPic = gift ? (gift[@"pic"] ?: @"") : @"";
    if (giftPic.length == 0 && gift) {
        giftPic = gift[@"image"] ?: @"";
    }
    NSURL *url = [NSURL URLWithString:giftPic];
    if ([_targetGiftImageView respondsToSelector:@selector(setImageWithURL:placeholder:)]) {
        [_targetGiftImageView performSelector:@selector(setImageWithURL:placeholder:) withObject:url withObject:[UIImage imageNamed:@""]];
    } else if ([_targetGiftImageView respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
        [_targetGiftImageView performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
    }
    
    // 钻石碎片消耗 (gem_cost / gem_owned)
    NSInteger gemCost = [activeConfig[@"gem_cost"] integerValue];
    _leftCostLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)gemCost, (long)self.ownedGemCount];
    
    // 投入的藏宝图置零
    self.selectedCardCount = 0;
    [self updateSuccessRateUI];
}

- (void)tabClick:(UIButton *)sender {
    if (sender.tag < self.exchangeConfigs.count) {
        self.activeConfigIndex = sender.tag;
        [self selectActiveTab];
    }
}

#pragma mark - 循环点击藏宝图 (0 -> 1 -> 2 -> ... -> max -> 0)

- (void)cardSelectClick {
    if (self.exchangeConfigs.count == 0) return;
    
    self.selectedCardCount += 1;
    if (self.selectedCardCount > self.maxOwnedCards) {
        self.selectedCardCount = 0;
    }
    
    [self updateSuccessRateUI];
}

- (void)updateSuccessRateUI {
    // 藏宝图投入 (card_invested / card_owned)
    _rightCostLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)self.selectedCardCount, (long)self.maxOwnedCards];
    
    if (self.exchangeConfigs.count == 0) {
        _successRateLabel.text = @"兑换成功率: 0%";
        return;
    }
    NSDictionary *activeConfig = self.exchangeConfigs[self.activeConfigIndex];
    NSInteger baseRate = [activeConfig[@"success_rate"] integerValue];
    
    NSInteger finalRate = 0;
    if (self.selectedCardCount == 0) {
        finalRate = 0;
    } else {
        finalRate = MIN(100, baseRate * self.selectedCardCount);
    }
    _successRateLabel.text = [NSString stringWithFormat:@"兑换成功率: %ld%%", (long)finalRate];
}

#pragma mark - 执行兑换

- (void)confirmExchangeClick {
    if (self.exchangeConfigs.count == 0) return;
    
    NSDictionary *activeConfig = self.exchangeConfigs[self.activeConfigIndex];
    NSInteger configId = [activeConfig[@"exchange_id"] integerValue];
    
    _confirmExchangeButton.enabled = NO;
    WeakSelf
    [MLGameLotteryService exchangeGiftWithExchangeId:configId 
                                           cardCount:self.selectedCardCount 
                                             success:^(BOOL isSuccess, MLGameDrawResultModel *gift, NSInteger remainCard, NSInteger remainGem, NSString *msg) {
        wself.confirmExchangeButton.enabled = YES;
        
        wself.maxOwnedCards = remainCard;
        wself.ownedGemCount = remainGem;
        
        if (wself.selectedCardCount > remainCard) {
            wself.selectedCardCount = remainCard;
        }
        [wself selectActiveTab]; // 重新加载数据渲染
        
        if (isSuccess) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"兑换成功！已获得: %@", gift.name]];
        } else {
            [SVProgressHUD showInfoWithStatus:msg.length > 0 ? msg : @"兑换失败了，再试一次吧"];
        }
    } failure:^(NSError *error) {
        wself.confirmExchangeButton.enabled = YES;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - Animation & Close

- (void)animateShow {
    self.alpha = 0.0;
    _bgImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
        self.bgImageView.transform = CGAffineTransformIdentity;
    }];
}

- (void)closeClick {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.bgImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
