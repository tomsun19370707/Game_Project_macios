//
//  MLChatRoomThemeGameSixFusionDialog.m
//  miliao
//
//  Created for Game 6 (玲珑珍宝塔) 门票黑曜石直购与兑换弹窗.
//

#import "MLChatRoomThemeGameSixFusionDialog.h"
#import "MLChatRoomThemeGameSixObsidianExchangeDialog.h"
#import "MLThemeGameModel.h"
#import "MLTowerGameSixModels.h"
#import "NetworkRequest.h"
#import "DZCX_NetAPIPaths.h"
#import "Global.h"
#import "BaseModel.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface MLGameSixTokenCardView : UIView

@property (nonatomic, strong) UIView *cardContainer;
@property (nonatomic, strong) UIImageView *tokenImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *priceBox;
@property (nonatomic, strong) UIImageView *obsidianIcon;
@property (nonatomic, strong) UILabel *priceLabel;

- (void)configureWithTier:(NSInteger)tier name:(NSString *)name price:(NSInteger)price isSelected:(BOOL)isSelected;

@end

@implementation MLGameSixTokenCardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        _cardContainer = [[UIView alloc] init];
        _cardContainer.userInteractionEnabled = NO;
        [self addSubview:_cardContainer];
        [_cardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        // 1. 木质令牌修长切图
        _tokenImageView = [[UIImageView alloc] init];
        _tokenImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_cardContainer addSubview:_tokenImageView];
        [_tokenImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(self.cardContainer);
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(52), KAdaptedWidth(88)));
        }];
        
        // 2. 令牌名称
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:11];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = mHexRGB(0xFFFFDF7C);
        [_cardContainer addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tokenImageView.mas_bottom).offset(2);
            make.left.right.mas_equalTo(self.cardContainer);
        }];
        
        // 3. 价格栏
        _priceBox = [[UIView alloc] init];
        _priceBox.backgroundColor = [UIColor clearColor];
        [_cardContainer addSubview:_priceBox];
        [_priceBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(1);
            make.centerX.mas_equalTo(self.cardContainer);
            make.height.mas_equalTo(14);
        }];
        
        _obsidianIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_game_six_obsidian"]];
        _obsidianIcon.contentMode = UIViewContentModeScaleAspectFit;
        [_priceBox addSubview:_obsidianIcon];
        [_obsidianIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(self.priceBox);
            make.size.mas_equalTo(CGSizeMake(11, 11));
        }];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont boldSystemFontOfSize:10];
        _priceLabel.textColor = [UIColor whiteColor];
        [_priceBox addSubview:_priceLabel];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.obsidianIcon.mas_right).offset(2);
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(self.priceBox);
        }];
    }
    return self;
}

- (void)configureWithTier:(NSInteger)tier name:(NSString *)name price:(NSInteger)price isSelected:(BOOL)isSelected {
    NSString *imageName = [NSString stringWithFormat:@"theme_game_six_token_tier_%ld", (long)tier];
    _tokenImageView.image = [UIImage imageNamed:imageName];
    _nameLabel.text = name;
    _priceLabel.text = [self formatPriceNumber:price];
    
    if (isSelected) {
        _cardContainer.transform = CGAffineTransformMakeScale(1.08, 1.08);
        _cardContainer.alpha = 1.0;
        _nameLabel.textColor = [UIColor whiteColor];
    } else {
        _cardContainer.transform = CGAffineTransformMakeScale(0.95, 0.95);
        _cardContainer.alpha = 0.65;
        _nameLabel.textColor = mHexRGB(0xFFFFDF7C);
    }
}

- (NSString *)formatPriceNumber:(double)num {
    if (num >= 1000000000000.0) {
        return [NSString stringWithFormat:@"%.2f万亿", num / 1000000000000.0];
    } else if (num >= 100000000.0) {
        return [NSString stringWithFormat:@"%.2f亿", num / 100000000.0];
    } else if (num >= 10000.0) {
        return [NSString stringWithFormat:@"%.2f万", num / 10000.0];
    } else {
        return [NSString stringWithFormat:@"%ld", (long)num];
    }
}

@end

#pragma mark - Main Fusion Dialog Implementation

@interface MLChatRoomThemeGameSixFusionDialog ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *boardContainer;
@property (nonatomic, strong) UIImageView *boardBgImageView;

// 顶部资产栏
@property (nonatomic, strong) UIView *topAssetBar;
@property (nonatomic, strong) UILabel *tvObsidianTitle;
@property (nonatomic, strong) UIImageView *ivObsidianIcon;
@property (nonatomic, strong) UILabel *tvTopObsidianBalance;
@property (nonatomic, strong) UIButton *btnExchangeObsidian;

// 5 级木质令牌横排
@property (nonatomic, strong) UIStackView *tokensStackView;
@property (nonatomic, strong) NSMutableArray<MLGameSixTokenCardView *> *tokenCards;

// 底部选中提示与融合按钮
@property (nonatomic, strong) UILabel *tvFusionSelectedBottom;
@property (nonatomic, strong) UIButton *fusionActionButton;

// 数据
@property (nonatomic, strong) MLThemeGameModel *gameModel;
@property (nonatomic, assign) NSInteger selectedTier; // 1~5
@property (nonatomic, assign) NSInteger selectedTicketTypeId;
@property (nonatomic, assign) NSInteger selectedPrice;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *defaultPrices;
@property (nonatomic, strong) NSMutableArray<NSString *> *defaultNames;
@property (nonatomic, copy) NSString *cachedRatioCoin;
@property (nonatomic, assign) NSTimeInterval lastClickTime;
@property (nonatomic, assign) BOOL isExchanging;

@end

@implementation MLChatRoomThemeGameSixFusionDialog

+ (instancetype)showInView:(nullable UIView *)parentView {
    UIView *targetView = parentView;
    if (!targetView) {
        targetView = [UIApplication sharedApplication].keyWindow;
    }
    if (!targetView) {
        for (UIWindow *w in [UIApplication sharedApplication].windows) {
            if (w.isKeyWindow) { targetView = w; break; }
        }
    }
    if (!targetView) {
        targetView = [UIApplication sharedApplication].windows.firstObject;
    }
    if (!targetView) return nil;
    
    for (UIView *sub in targetView.subviews) {
        if ([sub isKindOfClass:[MLChatRoomThemeGameSixFusionDialog class]]) {
            return (MLChatRoomThemeGameSixFusionDialog *)sub;
        }
    }
    
    MLChatRoomThemeGameSixFusionDialog *dialog = [[MLChatRoomThemeGameSixFusionDialog alloc] initWithFrame:targetView.bounds];
    [targetView addSubview:dialog];
    [dialog animateShow];
    return dialog;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _gameModel = [[MLThemeGameModel alloc] init];
        _tokenCards = [NSMutableArray array];
        _selectedTier = 1;
        _selectedPrice = 100;
        _selectedTicketTypeId = 1;
        _defaultPrices = [@[@100, @500, @1000, @2000, @5000] mutableCopy];
        _defaultNames = [@[@"一层令", @"二层令", @"三层令", @"四层令", @"五层令"] mutableCopy];
        _cachedRatioCoin = @"0";
        _stateVersion = 1;
        _hasActiveTicket = NO;
        
        [self setupUI];
        [self selectTier:1];
        [self loadWalletMoney];
        [self refreshBootstrapState];
    }
    return self;
}

#pragma mark - UI Setup (SUAS / CVCS 规范：614:879 画卷容器自适应)
- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 1. 半透明黑色遮罩
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _maskView.userInteractionEnabled = YES;
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    UITapGestureRecognizer *tapMask = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCloseClicked)];
    [_maskView addGestureRecognizer:tapMask];
    
    // 2. 画卷居中容器 (614:879，大屏 iPad 限宽 360)
    _boardContainer = [[UIView alloc] init];
    _boardContainer.backgroundColor = [UIColor clearColor];
    _boardContainer.userInteractionEnabled = YES;
    [self addSubview:_boardContainer];
    
    CGFloat panelWidth = MIN(ScreenWidth * 0.92, 360.0);
    CGFloat panelHeight = panelWidth * (879.0 / 614.0);
    [_boardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(panelWidth);
        make.height.mas_equalTo(panelHeight);
    }];
    
    // 3. 画卷背景
    _boardBgImageView = [[UIImageView alloc] init];
    _boardBgImageView.image = [UIImage imageNamed:@"theme_game_six_fusion_board_bg"];
    _boardBgImageView.contentMode = UIViewContentModeScaleToFill;
    _boardBgImageView.userInteractionEnabled = YES;
    [_boardContainer addSubview:_boardBgImageView];
    [_boardBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.boardContainer);
    }];
    
    // 4. 关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"theme_game_six_rule_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(onCloseClicked) forControlEvents:UIControlEventTouchUpInside];
    [_boardContainer addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KAdaptedWidth(26));
        make.right.mas_equalTo(-KAdaptedWidth(20));
        make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(28), KAdaptedWidth(28)));
    }];
    
    // 5. 顶部资产栏 (位于画卷顶部 ~10.5%)
    _topAssetBar = [[UIView alloc] init];
    _topAssetBar.backgroundColor = [UIColor clearColor];
    [_boardContainer addSubview:_topAssetBar];
    [_topAssetBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.boardContainer.mas_top).offset(panelHeight * 0.105);
        make.centerX.mas_equalTo(self.boardContainer);
        make.height.mas_equalTo(KAdaptedWidth(26));
    }];
    
    _tvObsidianTitle = [[UILabel alloc] init];
    _tvObsidianTitle.text = @"当前黑曜石:";
    _tvObsidianTitle.textColor = mHexRGB(0xFFFFDF7C);
    _tvObsidianTitle.font = [UIFont boldSystemFontOfSize:12];
    [_topAssetBar addSubview:_tvObsidianTitle];
    [_tvObsidianTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self.topAssetBar);
    }];
    
    _ivObsidianIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_game_six_obsidian"]];
    _ivObsidianIcon.contentMode = UIViewContentModeScaleAspectFit;
    [_topAssetBar addSubview:_ivObsidianIcon];
    [_ivObsidianIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tvObsidianTitle.mas_right).offset(4);
        make.centerY.mas_equalTo(self.topAssetBar);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    _tvTopObsidianBalance = [[UILabel alloc] init];
    _tvTopObsidianBalance.text = @"0";
    _tvTopObsidianBalance.textColor = [UIColor whiteColor];
    _tvTopObsidianBalance.font = [UIFont boldSystemFontOfSize:13];
    [_topAssetBar addSubview:_tvTopObsidianBalance];
    [_tvTopObsidianBalance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ivObsidianIcon.mas_right).offset(4);
        make.centerY.mas_equalTo(self.topAssetBar);
    }];
    
    _btnExchangeObsidian = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnExchangeObsidian setTitle:@"➕ 兑换" forState:UIControlStateNormal];
    [_btnExchangeObsidian setTitleColor:mHexRGB(0xFFFFDF7C) forState:UIControlStateNormal];
    _btnExchangeObsidian.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    _btnExchangeObsidian.layer.borderColor = mHexRGB(0xFFFFDF7C).CGColor;
    _btnExchangeObsidian.layer.borderWidth = 1.0;
    _btnExchangeObsidian.layer.cornerRadius = 11;
    _btnExchangeObsidian.layer.masksToBounds = YES;
    [_btnExchangeObsidian addTarget:self action:@selector(onExchangeObsidianClick) forControlEvents:UIControlEventTouchUpInside];
    [_topAssetBar addSubview:_btnExchangeObsidian];
    [_btnExchangeObsidian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tvTopObsidianBalance.mas_right).offset(8);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.topAssetBar);
        make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(54), KAdaptedWidth(22)));
    }];
    
    // 6. 5 级木质令牌单排平铺 (位于画卷中间 ~33%)
    _tokensStackView = [[UIStackView alloc] init];
    _tokensStackView.axis = UILayoutConstraintAxisHorizontal;
    _tokensStackView.distribution = UIStackViewDistributionFillEqually;
    _tokensStackView.spacing = KAdaptedWidth(2);
    [_boardContainer addSubview:_tokensStackView];
    [_tokensStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.boardContainer.mas_top).offset(panelHeight * 0.33);
        make.left.mas_equalTo(self.boardContainer).offset(KAdaptedWidth(14));
        make.right.mas_equalTo(self.boardContainer).offset(-KAdaptedWidth(14));
        make.height.mas_equalTo(KAdaptedWidth(130));
    }];
    
    for (NSInteger i = 1; i <= 5; i++) {
        MLGameSixTokenCardView *card = [[MLGameSixTokenCardView alloc] init];
        card.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTokenCardTapped:)];
        [card addGestureRecognizer:tap];
        [_tokensStackView addArrangedSubview:card];
        [_tokenCards addObject:card];
    }
    
    // 7. 当前选中消耗文本 (位于画卷 ~63%)
    _tvFusionSelectedBottom = [[UILabel alloc] init];
    _tvFusionSelectedBottom.textColor = mHexRGB(0xFFFFDF7C);
    _tvFusionSelectedBottom.font = [UIFont boldSystemFontOfSize:14];
    _tvFusionSelectedBottom.textAlignment = NSTextAlignmentCenter;
    _tvFusionSelectedBottom.text = @"当前选中: 100 黑曜石";
    [_boardContainer addSubview:_tvFusionSelectedBottom];
    [_tvFusionSelectedBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.boardContainer.mas_top).offset(panelHeight * 0.63);
        make.centerX.mas_equalTo(self.boardContainer);
    }];
    
    // 8. 核心操作「融合/兑换」按钮 (位于画卷 ~70%)
    _fusionActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fusionActionButton setImage:[UIImage imageNamed:@"theme_game_six_fusion_btn_action"] forState:UIControlStateNormal];
    _fusionActionButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_fusionActionButton addTarget:self action:@selector(onFusionActionClick) forControlEvents:UIControlEventTouchUpInside];
    [_boardContainer addSubview:_fusionActionButton];
    [_fusionActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.boardContainer.mas_top).offset(panelHeight * 0.70);
        make.centerX.mas_equalTo(self.boardContainer);
        make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(200), KAdaptedWidth(54)));
    }];
}

#pragma mark - Token Selection
- (void)onTokenCardTapped:(UITapGestureRecognizer *)tap {
    NSInteger tier = tap.view.tag;
    [self selectTier:tier];
}

- (MLTowerGameSixTicketTypeModel *)findTicketTypeByTier:(NSInteger)tier {
    if (!_ticketTypes || _ticketTypes.count == 0) return nil;
    for (MLTowerGameSixTicketTypeModel *model in _ticketTypes) {
        if (model.ticket_layer == tier || model.start_layer == tier) {
            return model;
        }
    }
    return nil;
}

- (NSInteger)getPriceForTier:(NSInteger)tier {
    MLTowerGameSixTicketTypeModel *model = [self findTicketTypeByTier:tier];
    if (model) {
        if (model.required_ratio_coin.length > 0 && [model.required_ratio_coin doubleValue] > 0) {
            return (NSInteger)[model.required_ratio_coin doubleValue];
        }
        if (model.ratio_coin_price.length > 0 && [model.ratio_coin_price doubleValue] > 0) {
            return (NSInteger)[model.ratio_coin_price doubleValue];
        }
        if (model.ticket_value.length > 0 && [model.ticket_value doubleValue] > 0) {
            return (NSInteger)[model.ticket_value doubleValue];
        }
    }
    if (tier >= 1 && tier <= _defaultPrices.count) {
        return [_defaultPrices[tier - 1] integerValue];
    }
    return 100;
}

- (void)setTicketTypes:(NSArray<MLTowerGameSixTicketTypeModel *> *)ticketTypes {
    _ticketTypes = ticketTypes;
    if (!ticketTypes || ticketTypes.count == 0) return;
    
    for (NSInteger i = 0; i < ticketTypes.count && i < 5; i++) {
        MLTowerGameSixTicketTypeModel *t = ticketTypes[i];
        NSInteger price = [self getPriceForTier:i + 1];
        if (price > 0 && i < _defaultPrices.count) {
            _defaultPrices[i] = @(price);
        }
        if (t.name.length > 0 && i < _defaultNames.count) {
            _defaultNames[i] = t.name;
        }
    }
    [self selectTier:_selectedTier];
}

- (void)selectTier:(NSInteger)tier {
    if (tier < 1 || tier > 5) tier = 1;
    _selectedTier = tier;
    
    // 动态通过 findTicketTypeByTier: 精准查找门票 ID，杜绝数组下标硬编码
    MLTowerGameSixTicketTypeModel *matchedBean = [self findTicketTypeByTier:tier];
    if (matchedBean && matchedBean.id > 0) {
        _selectedTicketTypeId = matchedBean.id;
    } else if (_ticketTypes && _ticketTypes.count >= tier) {
        _selectedTicketTypeId = _ticketTypes[tier - 1].id;
    } else {
        _selectedTicketTypeId = tier;
    }
    
    _selectedPrice = [self getPriceForTier:tier];
    
    for (NSInteger i = 0; i < _tokenCards.count; i++) {
        NSInteger curTier = i + 1;
        NSString *name = (i < _defaultNames.count) ? _defaultNames[i] : [NSString stringWithFormat:@"%ld层令", (long)curTier];
        NSInteger price = [self getPriceForTier:curTier];
        [_tokenCards[i] configureWithTier:curTier name:name price:price isSelected:(curTier == tier)];
    }
    
    _tvFusionSelectedBottom.text = [NSString stringWithFormat:@"当前选中: %@ 黑曜石", [self formatLargeNumber:_selectedPrice]];
}

#pragma mark - Network Loading
- (void)loadWalletMoney {
    WeakSelf;
    [NetworkRequest POST:user_getMoney parmeters:nil success:^(id responObject) {
        NSDictionary *data = nil;
        if ([responObject isKindOfClass:[BaseModel class]]) {
            BaseModel *baseModel = (BaseModel *)responObject;
            if ([baseModel.data isKindOfClass:[NSDictionary class]]) {
                data = (NSDictionary *)baseModel.data;
            }
        } else if ([responObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responObject;
            if ([dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                data = dict[@"data"];
            } else {
                data = dict;
            }
        }
        
        if (data) {
            wself.cachedRatioCoin = [NSString stringWithFormat:@"%@", data[@"ratio_coin"] ?: @"0"];
            double val = [wself.cachedRatioCoin doubleValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.tvTopObsidianBalance.text = [wself formatLargeNumber:val];
            });
        }
    } failture:^(NSError *error) {}];
}

- (void)refreshBootstrapState {
    WeakSelf;
    [_gameModel fetchTowerGameSixBootstrapWithRoomId:nil success:^(id data) {
        if ([data isKindOfClass:[MLTowerGameSixBootstrapModel class]]) {
            MLTowerGameSixBootstrapModel *bootstrap = (MLTowerGameSixBootstrapModel *)data;
            if (bootstrap.player) {
                wself.stateVersion = bootstrap.player.state_version ?: 1;
            }
            if (bootstrap.ticket_types && bootstrap.ticket_types.count > 0) {
                [wself setTicketTypes:bootstrap.ticket_types];
            }
            
            // 四重因子严格判定与双向复位（有票置 YES，无票或次数归零立即置 NO，死锁防御关键）
            BOOL active = (bootstrap.ticket != nil) &&
                          ([@"active" caseInsensitiveCompare:bootstrap.ticket.status ?: @""] == NSOrderedSame) &&
                          (bootstrap.token_count > 0) &&
                          (bootstrap.ticket.remaining_recasts > 0);
            wself.hasActiveTicket = active;
        } else if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *player = data[@"player"];
            if ([player isKindOfClass:[NSDictionary class]]) {
                wself.stateVersion = [player[@"state_version"] integerValue] ?: 1;
            }
            NSArray *ticketTypes = data[@"ticket_types"];
            if (ticketTypes && [ticketTypes isKindOfClass:[NSArray class]] && ticketTypes.count > 0) {
                NSArray *typeModels = [MLTowerGameSixTicketTypeModel mj_objectArrayWithKeyValuesArray:ticketTypes];
                [wself setTicketTypes:typeModels];
            }
            NSDictionary *ticket = data[@"ticket"];
            NSInteger tokenCount = [data[@"token_count"] integerValue];
            NSInteger remaining = 0;
            NSString *status = @"";
            if ([ticket isKindOfClass:[NSDictionary class]]) {
                status = ticket[@"status"] ?: @"";
                remaining = [ticket[@"remaining_recasts"] integerValue];
            }
            BOOL active = [ticket isKindOfClass:[NSDictionary class]] &&
                          ([@"active" caseInsensitiveCompare:status] == NSOrderedSame) &&
                          (tokenCount > 0) &&
                          (remaining > 0);
            wself.hasActiveTicket = active;
        }
    } failure:^(NSError *error, NSString * _Nullable msg) {}];
}

#pragma mark - Actions
- (void)onExchangeObsidianClick {
    WeakSelf;
    [MLChatRoomThemeGameSixObsidianExchangeDialog showInView:self.superview success:^{
        [wself loadWalletMoney];
    }];
}

- (void)onFusionActionClick {
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;
    if (_isExchanging || (now - _lastClickTime < 0.8)) return;
    _lastClickTime = now;
    
    // 1. 排他校验
    if (_hasActiveTicket) {
        [SVProgressHUD showImage:nil status:@"⚠️ 当前已有进行中的令牌挑战，完成后方可购买"];
        return;
    }
    
    // 2. 余额校验
    double currentRatio = [_cachedRatioCoin doubleValue];
    if (currentRatio < _selectedPrice) {
        [SVProgressHUD showImage:nil status:@"黑曜石不足，请前往兑换"];
        [self onExchangeObsidianClick];
        return;
    }
    
    // 3. 提交纯净化直购
    _isExchanging = YES;
    [SVProgressHUD showWithStatus:@"兑换中..."];
    WeakSelf;
    [_gameModel exchangeTowerGameSixTicketWithTicketTypeId:_selectedTicketTypeId
                                              stateVersion:_stateVersion
                                                   success:^(id data) {
        wself.isExchanging = NO;
        NSString *tierName = (wself.selectedTier <= wself.defaultNames.count) ? wself.defaultNames[wself.selectedTier - 1] : @"门票";
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"✨ %@ 兑换成功！", tierName]];
        if (wself.onFusionSuccessBlock) {
            wself.onFusionSuccessBlock();
        }
        [wself animateDismissWithCompletion:nil];
    } failure:^(NSError *error, NSString * _Nullable errMsg) {
        wself.isExchanging = NO;
        [SVProgressHUD showImage:nil status:errMsg ?: @"兑换失败，请稍后再试"];
        if ([errMsg containsString:@"已有"] || [errMsg containsString:@"门票"] || [errMsg containsString:@"挑战"] || [errMsg containsString:@"已变更"]) {
            if (wself.onFusionSuccessBlock) {
                wself.onFusionSuccessBlock();
            }
            [wself animateDismissWithCompletion:nil];
        }
    }];
}

#pragma mark - Large Number Format
- (NSString *)formatLargeNumber:(double)num {
    if (num >= 1000000000000.0) {
        return [NSString stringWithFormat:@"%.2f万亿", num / 1000000000000.0];
    } else if (num >= 100000000.0) {
        return [NSString stringWithFormat:@"%.2f亿", num / 100000000.0];
    } else if (num >= 10000.0) {
        return [NSString stringWithFormat:@"%.2f万", num / 10000.0];
    } else {
        return [NSString stringWithFormat:@"%ld", (long)num];
    }
}

#pragma mark - Animation & Dismiss
- (void)animateShow {
    self.boardContainer.transform = CGAffineTransformMakeScale(0.85, 0.85);
    self.boardContainer.alpha = 0.0;
    self.maskView.alpha = 0.0;
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.boardContainer.transform = CGAffineTransformIdentity;
        self.boardContainer.alpha = 1.0;
        self.maskView.alpha = 1.0;
    } completion:nil];
}

- (void)animateDismissWithCompletion:(nullable void (^)(void))completion {
    [UIView animateWithDuration:0.2 animations:^{
        self.boardContainer.transform = CGAffineTransformMakeScale(0.85, 0.85);
        self.boardContainer.alpha = 0.0;
        self.maskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) completion();
    }];
}

- (void)onCloseClicked {
    [self animateDismissWithCompletion:nil];
}

@end
