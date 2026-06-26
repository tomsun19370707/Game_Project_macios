#import "MLChatRoomThemeGameOneExchangeView.h"
#import "MLGameLotteryService.h"
#import "Global.h"

@interface MLChatRoomThemeGameOneExchangeView ()

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) NSArray *exchangeConfigs; // 兑换配置列表
@property (nonatomic, assign) NSInteger activeConfigIndex; // 当前选中的页签索引

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *titleLabel;

// 页签切换视图
@property (nonatomic, strong) UIScrollView *tabScrollView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *tabButtons;

// 兑换项展示
@property (nonatomic, strong) UIImageView *targetGiftImageView;
@property (nonatomic, strong) UILabel *targetGiftNameLabel;
@property (nonatomic, strong) UILabel *costChipsLabel; // 需要消耗碎片
@property (nonatomic, strong) UILabel *successRateLabel; // 兑换成功率

// 藏宝图调节区域
@property (nonatomic, strong) UIButton *cardSelectButton; // 代替输入框的循环单点击标签按钮
@property (nonatomic, strong) UILabel *ownedCardsLabel; // 拥有的藏宝图

@property (nonatomic, strong) UIButton *confirmExchangeButton;

@property (nonatomic, assign) NSInteger selectedCardCount; // 投入的藏宝图数量
@property (nonatomic, assign) NSInteger maxOwnedCards; // 用户拥有的最大藏宝图数 (从背包或后台拉取，默认兜底5张)
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
        self.maxOwnedCards = 5; // 默认拥有5张藏宝图以备无包裹数据时测试
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
    
    // 背景弹窗 (315 * 380)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_one_exchange_popup_board"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    setViewCorner(_bgImageView, 12);
    [self addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(315, 380));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"高级兑换";
    _titleLabel.textColor = mHexRGB(0xFFE400);
    _titleLabel.font = KFontBoldA(18);
    [_bgImageView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.mas_equalTo(_bgImageView);
    }];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"theme_game_one_result_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    // 页签滚动条
    _tabScrollView = [[UIScrollView alloc] init];
    _tabScrollView.showsHorizontalScrollIndicator = NO;
    [_bgImageView addSubview:_tabScrollView];
    [_tabScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(12);
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.height.mas_equalTo(35);
    }];
    
    // 中间的大型终极礼物展示卡片
    UIView *giftCardView = [[UIView alloc] init];
    giftCardView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.04];
    setViewCorner(giftCardView, 8);
    [_bgImageView addSubview:giftCardView];
    [giftCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tabScrollView.mas_bottom).offset(12);
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(280, 110));
    }];
    
    _targetGiftImageView = [[UIImageView alloc] init];
    _targetGiftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [giftCardView addSubview:_targetGiftImageView];
    [_targetGiftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.centerY.mas_equalTo(giftCardView);
        make.size.mas_equalTo(CGSizeMake(72, 72));
    }];
    
    _targetGiftNameLabel = [[UILabel alloc] init];
    _targetGiftNameLabel.textColor = kWhiteColor;
    _targetGiftNameLabel.font = KFontBoldA(15);
    _targetGiftNameLabel.text = @"加载中...";
    [giftCardView addSubview:_targetGiftNameLabel];
    [_targetGiftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_targetGiftImageView.mas_trailing).offset(16);
        make.top.mas_equalTo(22);
    }];
    
    _costChipsLabel = [[UILabel alloc] init];
    _costChipsLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7];
    _costChipsLabel.font = KFontA(12);
    _costChipsLabel.text = @"消耗碎片: --";
    [giftCardView addSubview:_costChipsLabel];
    [_costChipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_targetGiftNameLabel);
        make.top.mas_equalTo(_targetGiftNameLabel.mas_bottom).offset(8);
    }];
    
    _ownedCardsLabel = [[UILabel alloc] init];
    _ownedCardsLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
    _ownedCardsLabel.font = KFontA(11);
    _ownedCardsLabel.text = @"持有藏宝图: --";
    [_bgImageView addSubview:_ownedCardsLabel];
    [_ownedCardsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(giftCardView.mas_bottom).offset(15);
        make.leading.mas_equalTo(20);
    }];
    
    // 藏宝图循环点击标签按钮
    _cardSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cardSelectButton.backgroundColor = mHexRGB(0x00A2FF);
    setViewCorner(_cardSelectButton, 4);
    [_cardSelectButton setTitle:@"投入: 0 张" forState:UIControlStateNormal];
    [_cardSelectButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _cardSelectButton.titleLabel.font = KFontBoldA(13);
    [_cardSelectButton addTarget:self action:@selector(cardSelectClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_cardSelectButton];
    [_cardSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_ownedCardsLabel);
        make.trailing.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(100, 26));
    }];
    
    // 成功率显示
    _successRateLabel = [[UILabel alloc] init];
    _successRateLabel.textColor = mHexRGB(0xFFE400);
    _successRateLabel.font = KFontBoldA(14);
    _successRateLabel.text = @"兑换成功率: 0%";
    [_bgImageView addSubview:_successRateLabel];
    [_successRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_ownedCardsLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(_bgImageView);
    }];
    
    // 确认兑换按钮
    _confirmExchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmExchangeButton setImage:[UIImage imageNamed:@"theme_game_one_exchange_confirm"] forState:UIControlStateNormal];
    [_confirmExchangeButton addTarget:self action:@selector(confirmExchangeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_confirmExchangeButton];
    [_confirmExchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgImageView);
        make.bottom.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(260, 86));
    }];
}

#pragma mark - 数据请求
- (void)loadExchangeData {
    // 1. 获取用户资产（获取藏宝图和碎片余额，可以通过通用余额或背包接口；在这里我们从 getMoney 里的钻石/钥匙，我们也可以从 response 里读取卡片信息。如果没有，我们先默认拥有的藏宝图为 maxOwnedCards=5）
    [MLGameLotteryService getUserMoneyWithSuccess:^(MLGameUserMoneyModel *model) {
        // 卡片余额一般由具体的道具接口返回。我们在 exchange_gift 响应中能够返回最新的卡片和碎片余额。
    } failure:nil];
    
    // 2. 拉取兑换配置
    [MLGameLotteryService exchangeConfigWithTypeId:self.typeId success:^(id responseObject) {
        self.exchangeConfigs = responseObject;
        [self renderTabs];
        [self selectActiveTab];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)renderTabs {
    for (UIButton *btn in self.tabButtons) {
        [btn removeFromSuperview];
    }
    [self.tabButtons removeAllObjects];
    
    CGFloat nextX = 0;
    for (int i = 0; i < self.exchangeConfigs.count; i++) {
        NSDictionary *config = self.exchangeConfigs[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:config[@"tab_name"] ?: @"兑换项" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateNormal];
        [btn setTitleColor:mHexRGB(0xFFE400) forState:UIControlStateSelected];
        btn.titleLabel.font = KFontBoldA(13);
        btn.tag = i;
        [btn addTarget:self action:@selector(tabClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGSize size = [btn.currentTitle boundingRectWithSize:CGSizeMake(200, 35) 
                                                     options:NSStringDrawingUsesLineFragmentOrigin 
                                                  attributes:@{NSFontAttributeName: btn.titleLabel.font} 
                                                     context:nil].size;
        
        btn.frame = CGRectMake(nextX, 0, size.width + 24, 35);
        nextX += size.width + 32;
        
        [self.tabScrollView addSubview:btn];
        [self.tabButtons addObject:btn];
    }
    self.tabScrollView.contentSize = CGSizeMake(nextX, 35);
}

- (void)selectActiveTab {
    if (self.exchangeConfigs.count == 0) return;
    
    for (int i = 0; i < self.tabButtons.count; i++) {
        self.tabButtons[i].selected = (i == self.activeConfigIndex);
    }
    
    NSDictionary *activeConfig = self.exchangeConfigs[self.activeConfigIndex];
    NSDictionary *gift = activeConfig[@"gift"];
    
    _targetGiftNameLabel.text = gift[@"name"] ?: @"高级礼物";
    _costChipsLabel.text = [NSString stringWithFormat:@"需要宝石碎片: %@", activeConfig[@"gem_cost"]];
    
    NSURL *url = [NSURL URLWithString:gift[@"pic"] ?: @""];
    if ([_targetGiftImageView respondsToSelector:@selector(setImageWithURL:placeholder:)]) {
        [_targetGiftImageView performSelector:@selector(setImageWithURL:placeholder:) withObject:url withObject:[UIImage imageNamed:@"theme_game_one_exchange_gift_large"]];
    } else if ([_targetGiftImageView respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
        [_targetGiftImageView performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@"theme_game_one_exchange_gift_large"]];
    }
    
    // 重置选择卡片数
    self.selectedCardCount = 0;
    [self updateSuccessRateUI];
}

- (void)tabClick:(UIButton *)sender {
    self.activeConfigIndex = sender.tag;
    [self selectActiveTab];
}

#pragma mark - 循环单点击调节藏宝图数 (0 -> 1 -> 2 -> ... -> max -> 0)
- (void)cardSelectClick {
    if (self.exchangeConfigs.count == 0) return;
    
    self.selectedCardCount += 1;
    if (self.selectedCardCount > self.maxOwnedCards) {
        self.selectedCardCount = 0;
    }
    
    [self updateSuccessRateUI];
}

- (void)updateSuccessRateUI {
    [_cardSelectButton setTitle:[NSString stringWithFormat:@"投入: %ld 张", (long)self.selectedCardCount] forState:UIControlStateNormal];
    
    if (self.exchangeConfigs.count == 0) return;
    NSDictionary *activeConfig = self.exchangeConfigs[self.activeConfigIndex];
    NSInteger baseRate = [activeConfig[@"success_rate"] integerValue];
    
    NSInteger finalRate = 0;
    // 零藏宝图必败原则 (直接设定成功率为 0%)
    if (self.selectedCardCount == 0) {
        finalRate = 0;
    } else {
        finalRate = MIN(100, baseRate * self.selectedCardCount);
    }
    
    _successRateLabel.text = [NSString stringWithFormat:@"兑换成功率: %ld%%", (long)finalRate];
}

#pragma mark - 执行兑换 (零图必败校验)
- (void)confirmExchangeClick {
    if (self.exchangeConfigs.count == 0) return;
    NSDictionary *activeConfig = self.exchangeConfigs[self.activeConfigIndex];
    NSInteger configId = [activeConfig[@"exchange_id"] integerValue];
    
    _confirmExchangeButton.enabled = NO;
    // 调用交换服务
    [MLGameLotteryService exchangeGiftWithExchangeId:configId 
                                           cardCount:self.selectedCardCount 
                                             success:^(BOOL isSuccess, MLGameDrawResultModel *gift, NSInteger remainCard, NSInteger remainGem, NSString *msg) {
        self.confirmExchangeButton.enabled = YES;
        
        // 更新本地拥有的数量，实现连点无缝体验
        self.maxOwnedCards = remainCard;
        self.ownedGemCount = remainGem;
        self.ownedCardsLabel.text = [NSString stringWithFormat:@"持有藏宝图: %ld", (long)remainCard];
        
        if (self.selectedCardCount > remainCard) {
            self.selectedCardCount = remainCard;
        }
        [self updateSuccessRateUI];
        
        if (isSuccess) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"兑换成功！已获得: %@", gift.name]];
        } else {
            [SVProgressHUD showInfoWithStatus:msg.length > 0 ? msg : @"兑换失败了，再试一次吧"];
        }
    } failure:^(NSError *error) {
        self.confirmExchangeButton.enabled = YES;
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
