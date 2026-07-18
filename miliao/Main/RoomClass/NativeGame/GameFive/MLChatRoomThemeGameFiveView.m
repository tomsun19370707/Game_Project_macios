//
//  MLChatRoomThemeGameFiveView.m
//  miliao
//

#import "MLChatRoomThemeGameFiveView.h"
#import "MLGameLotteryService.h"
#import "Global.h"
#import "UIViewController+CurViewController.h"
#import "CFMWalletDiamondRechargeVc.h"
#import "MLChatRoomThemeGameFiveGiftView.h"
#import "MLChatRoomThemeGameFiveRuleView.h"
#import "MLChatRoomThemeGameFiveResultView.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD.h>

// Forward declaration of internal card cell subclass
@interface MLChatRoomThemeGameFiveCard : UIView

@property (nonatomic, strong) UIImageView *cardBg;
@property (nonatomic, strong) UIImageView *valueBarBg;
@property (nonatomic, strong) UILabel *valueTextLabel;
@property (nonatomic, strong) UIImageView *diamondIcon;
@property (nonatomic, strong) UIImageView *giftIcon;
@property (nonatomic, strong) UILabel *giftNameLabel;

- (void)configureWithModel:(nullable MLGameDrawResultModel *)prize isYellow:(BOOL)isYellow;

@end

@implementation MLChatRoomThemeGameFiveCard

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];

    _cardBg = [[UIImageView alloc] init];
    _cardBg.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_cardBg];
    [_cardBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

    // Value bar background at top
    _valueBarBg = [[UIImageView alloc] init];
    _valueBarBg.image = [UIImage imageNamed:@"theme_game_five_value_bg"];
    _valueBarBg.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_valueBarBg];
    [_valueBarBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(30), KDialogAdaptedWidth(8.5)));
    }];

    // Small diamond inside value bar on the right
    _diamondIcon = [[UIImageView alloc] init];
    _diamondIcon.image = [UIImage imageNamed:@"theme_game_five_small_diamond"];
    _diamondIcon.contentMode = UIViewContentModeScaleAspectFit;
    [_valueBarBg addSubview:_diamondIcon];
    [_diamondIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(2));
        make.centerY.mas_equalTo(_valueBarBg);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(7.5), KDialogAdaptedWidth(6)));
    }];

    // Value text inside value bar
    _valueTextLabel = [[UILabel alloc] init];
    _valueTextLabel.textColor = mHexRGB(0xFFE400); // Yellow gold
    _valueTextLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(6.5)];
    _valueTextLabel.textAlignment = NSTextAlignmentRight;
    _valueTextLabel.text = @"0";
    [_valueBarBg addSubview:_valueTextLabel];
    [_valueTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(2));
        make.trailing.mas_equalTo(_diamondIcon.mas_leading).offset(-KDialogAdaptedWidth(1));
        make.centerY.mas_equalTo(_valueBarBg);
    }];

    // Centered gift icon
    _giftIcon = [[UIImageView alloc] init];
    _giftIcon.contentMode = UIViewContentModeScaleAspectFit;
    _giftIcon.image = [UIImage imageNamed:@"theme_game_five_placeholder"];
    [self addSubview:_giftIcon];
    [_giftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(26), KDialogAdaptedWidth(26)));
    }];

    // Gift name label at the bottom
    _giftNameLabel = [[UILabel alloc] init];
    _giftNameLabel.textColor = kWhiteColor;
    _giftNameLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(7)];
    _giftNameLabel.textAlignment = NSTextAlignmentCenter;
    _giftNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _giftNameLabel.text = @"-";
    [self addSubview:_giftNameLabel];
    [_giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(4));
        make.leading.trailing.mas_equalTo(self);
    }];
}

- (void)configureWithModel:(nullable MLGameDrawResultModel *)prize isYellow:(BOOL)isYellow {
    if (isYellow) {
        _cardBg.image = [UIImage imageNamed:@"theme_game_five_card_bg_yellow"];
    } else {
        _cardBg.image = [UIImage imageNamed:@"theme_game_five_card_bg_blue"];
    }

    if (prize) {
        _giftNameLabel.text = prize.name;
        _valueTextLabel.text = [NSString stringWithFormat:@"%ld", (long)prize.price];
        
        NSURL *url = [NSURL URLWithString:[prize imageUrl]];
        if ([_giftIcon respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
            [_giftIcon performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@"theme_game_five_placeholder"]];
        } else {
            _giftIcon.image = [UIImage imageNamed:@"theme_game_five_placeholder"];
        }
    } else {
        _giftNameLabel.text = @"-";
        _valueTextLabel.text = @"0";
        _giftIcon.image = [UIImage imageNamed:@"theme_game_five_placeholder"];
    }
}

@end

// ============================================================================
// MLChatRoomThemeGameFiveView Main Board Class
// ============================================================================
@interface MLChatRoomThemeGameFiveView ()

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *backgroundContainer;
@property (nonatomic, strong) UIImageView *bgImageView;

// HUD Buttons
@property (nonatomic, strong) UIButton *giftButton;
@property (nonatomic, strong) UIButton *ruleButton;
@property (nonatomic, strong) UIButton *recordButton;

// Gameplay Cards
@property (nonatomic, strong) UIView *gameplayContainer;
@property (nonatomic, strong) NSMutableArray<MLChatRoomThemeGameFiveCard *> *cardViews;
@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *prizesInPool;

// Actions & Status Bars
@property (nonatomic, strong) UIView *actionContainer;
@property (nonatomic, strong) UIButton *drawOneButton;
@property (nonatomic, strong) UIButton *drawTenButton;
@property (nonatomic, strong) UIButton *drawHundredButton;

@property (nonatomic, strong) UIView *statusBar;
@property (nonatomic, strong) UIImageView *keyBarView;
@property (nonatomic, strong) UIImageView *keyIcon;
@property (nonatomic, strong) UILabel *keyBalanceLabel;

@property (nonatomic, strong) UIImageView *diamondBarView;
@property (nonatomic, strong) UIImageView *diamondIcon;
@property (nonatomic, strong) UILabel *diamondBalanceLabel;

@property (nonatomic, strong) UIButton *rechargeButton;

// Local Balances & States
@property (nonatomic, assign) BOOL isDrawing;
@property (nonatomic, assign) NSInteger localKeyBalance;
@property (nonatomic, strong) MLGameLotteryInfoModel *infoModel;

@end

@implementation MLChatRoomThemeGameFiveView

+ (void)showInView:(UIView *)parentView typeId:(NSInteger)typeId {
    // Prevent duplicated layout instances
    for (UIView *subview in parentView.subviews) {
        if ([subview isKindOfClass:[MLChatRoomThemeGameFiveView class]]) {
            return;
        }
    }
    
    MLChatRoomThemeGameFiveView *gameView = [[MLChatRoomThemeGameFiveView alloc] initWithFrame:parentView.bounds typeId:typeId];
    [parentView addSubview:gameView];
    [gameView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame typeId:(NSInteger)typeId {
    if (self = [super initWithFrame:frame]) {
        self.typeId = typeId;
        self.cardViews = [NSMutableArray array];
        [self setupUI];
        [self loadData];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];

    // 1. Semi-transparent overlay mask
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _maskView.userInteractionEnabled = YES;
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMaskTap:)];
    [_maskView addGestureRecognizer:tap];

    // 2. Background Container (Locked aspect ratio 750:1182, bottom-aligned, maximum width 390 pt)
    _backgroundContainer = [[UIView alloc] init];
    _backgroundContainer.backgroundColor = [UIColor clearColor];
    _backgroundContainer.userInteractionEnabled = YES;
    [self addSubview:_backgroundContainer];
    [_backgroundContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self).priorityMedium();
        make.width.mas_lessThanOrEqualTo(390).priorityHigh();
        make.height.mas_equalTo(_backgroundContainer.mas_width).multipliedBy(1182.0 / 750.0);
    }];

    // 2.1 Background main image
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_five_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [_backgroundContainer addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_backgroundContainer);
    }];

    // Left Gift Button
    _giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_giftButton setBackgroundImage:[UIImage imageNamed:@"theme_game_five_btn_gift"] forState:UIControlStateNormal];
    [_giftButton addTarget:self action:@selector(giftClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundContainer addSubview:_giftButton];
    [_giftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(125));
        make.leading.mas_equalTo(KDialogAdaptedWidth(5));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(53.5), KDialogAdaptedWidth(44.5)));
    }];

    // Right Rule Button
    _ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ruleButton setBackgroundImage:[UIImage imageNamed:@"theme_game_five_btn_rule"] forState:UIControlStateNormal];
    [_ruleButton addTarget:self action:@selector(ruleClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundContainer addSubview:_ruleButton];
    [_ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(125));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(5));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(53.5), KDialogAdaptedWidth(44.5)));
    }];

    // Right Record Button (Below Rule)
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"theme_game_five_btn_record"] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundContainer addSubview:_recordButton];
    [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_ruleButton.mas_bottom).offset(KDialogAdaptedWidth(5));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(5));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(53), KDialogAdaptedWidth(44.5)));
    }];

    // 4. Gameplay Container (4x4 Grid layout)
    _gameplayContainer = [[UIView alloc] init];
    _gameplayContainer.backgroundColor = [UIColor clearColor];
    [_backgroundContainer addSubview:_gameplayContainer];
    [_gameplayContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_backgroundContainer);
        make.top.mas_equalTo(_backgroundContainer.mas_top).offset(KDialogAdaptedWidth(200));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(246.5), KDialogAdaptedWidth(244)));
    }];

    // Layout 16 cards inside the gameplay container
    CGFloat cardW = 51.5f;
    CGFloat cardH = 56.5f;
    CGFloat gapX = 13.5f;
    CGFloat gapY = 6.0f;

    for (int i = 0; i < 16; i++) {
        int row = i / 4;
        int col = i % 4;
        
        MLChatRoomThemeGameFiveCard *card = [[MLChatRoomThemeGameFiveCard alloc] init];
        BOOL isYellow = NO; // All rows use blue background cards
        [card configureWithModel:nil isYellow:isYellow];
        
        [_gameplayContainer addSubview:card];
        [_cardViews addObject:card];
        
        [card mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KDialogAdaptedWidth(cardW));
            make.height.mas_equalTo(KDialogAdaptedWidth(cardH));
            make.leading.mas_equalTo(col * KDialogAdaptedWidth(cardW + gapX));
            make.top.mas_equalTo(row * KDialogAdaptedWidth(cardH + gapY));
        }];
    }

    // 5. Action Container (Draw buttons and status balance bars)
    _actionContainer = [[UIView alloc] init];
    _actionContainer.backgroundColor = [UIColor clearColor];
    [_backgroundContainer addSubview:_actionContainer];
    [_actionContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(_backgroundContainer);
        make.height.mas_equalTo(KDialogAdaptedWidth(115));
    }];

    // Left Single Draw Button (236 diamonds)
    _drawOneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawOneButton setBackgroundImage:[UIImage imageNamed:@"theme_game_five_draw_1"] forState:UIControlStateNormal];
    [_drawOneButton addTarget:self action:@selector(drawOneClick) forControlEvents:UIControlEventTouchUpInside];
    _drawOneButton.adjustsImageWhenHighlighted = NO;
    [_actionContainer addSubview:_drawOneButton];

    // Middle Ten Draw Button (2360 diamonds)
    _drawTenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawTenButton setBackgroundImage:[UIImage imageNamed:@"theme_game_five_draw_10"] forState:UIControlStateNormal];
    [_drawTenButton addTarget:self action:@selector(drawTenClick) forControlEvents:UIControlEventTouchUpInside];
    _drawTenButton.adjustsImageWhenHighlighted = NO;
    [_actionContainer addSubview:_drawTenButton];

    // Right Hundred Draw Button (23600 diamonds)
    _drawHundredButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawHundredButton setBackgroundImage:[UIImage imageNamed:@"theme_game_five_draw_100"] forState:UIControlStateNormal];
    [_drawHundredButton addTarget:self action:@selector(drawHundredClick) forControlEvents:UIControlEventTouchUpInside];
    _drawHundredButton.adjustsImageWhenHighlighted = NO;
    [_actionContainer addSubview:_drawHundredButton];

    [_drawOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(5));
        make.leading.mas_equalTo(_actionContainer).offset(KDialogAdaptedWidth(10));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(115), KDialogAdaptedWidth(59)));
    }];

    [_drawTenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_drawOneButton);
        make.centerX.mas_equalTo(_actionContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(115), KDialogAdaptedWidth(59)));
    }];

    [_drawHundredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_drawOneButton);
        make.trailing.mas_equalTo(_actionContainer).offset(-KDialogAdaptedWidth(10));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(115), KDialogAdaptedWidth(59)));
    }];

    // 6. Bottom Status Bar (Height 25 pt, aligned bottom-17 pt)
    _statusBar = [[UIView alloc] init];
    _statusBar.backgroundColor = [UIColor clearColor];
    [_actionContainer addSubview:_statusBar];
    [_statusBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(17));
        make.leading.trailing.mas_equalTo(_actionContainer);
        make.height.mas_equalTo(KDialogAdaptedWidth(25));
    }];

    // Left Key Bar
    _keyBarView = [[UIImageView alloc] init];
    _keyBarView.image = [UIImage imageNamed:@"theme_game_five_bar_key"];
    _keyBarView.contentMode = UIViewContentModeScaleToFill;
    _keyBarView.userInteractionEnabled = YES;
    [_statusBar addSubview:_keyBarView];
    [_keyBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(10));
        make.centerY.mas_equalTo(_statusBar);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(96), KDialogAdaptedWidth(22)));
    }];

    _keyIcon = [[UIImageView alloc] init];
    _keyIcon.image = [UIImage imageNamed:@"theme_game_five_ic_key"];
    _keyIcon.contentMode = UIViewContentModeScaleAspectFit;
    [_keyBarView addSubview:_keyIcon];
    [_keyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(5));
        make.centerY.mas_equalTo(_keyBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(10.5), KDialogAdaptedWidth(14)));
    }];

    _keyBalanceLabel = [[UILabel alloc] init];
    _keyBalanceLabel.textColor = kWhiteColor;
    _keyBalanceLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(9.5)];
    _keyBalanceLabel.text = @"0";
    [_keyBarView addSubview:_keyBalanceLabel];
    [_keyBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_keyIcon.mas_trailing).offset(KDialogAdaptedWidth(3));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(5));
        make.centerY.mas_equalTo(_keyBarView);
    }];

    // Right Recharge Button
    _rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rechargeButton setBackgroundImage:[UIImage imageNamed:@"theme_game_five_btn_recharge"] forState:UIControlStateNormal];
    [_rechargeButton addTarget:self action:@selector(rechargeClick) forControlEvents:UIControlEventTouchUpInside];
    [_statusBar addSubview:_rechargeButton];
    [_rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(10));
        make.centerY.mas_equalTo(_statusBar);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(50), KDialogAdaptedWidth(18)));
    }];

    // Middle Diamond Bar
    _diamondBarView = [[UIImageView alloc] init];
    _diamondBarView.image = [UIImage imageNamed:@"theme_game_five_bar_diamond"];
    _diamondBarView.contentMode = UIViewContentModeScaleToFill;
    _diamondBarView.userInteractionEnabled = YES;
    [_statusBar addSubview:_diamondBarView];
    [_diamondBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_statusBar);
        make.centerY.mas_equalTo(_statusBar);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(166), KDialogAdaptedWidth(23)));
    }];

    _diamondIcon = [[UIImageView alloc] init];
    _diamondIcon.image = [UIImage imageNamed:@"theme_game_five_ic_diamond"];
    _diamondIcon.contentMode = UIViewContentModeScaleAspectFit;
    [_diamondBarView addSubview:_diamondIcon];
    [_diamondIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(6));
        make.centerY.mas_equalTo(_diamondBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(16), KDialogAdaptedWidth(13.5)));
    }];

    _diamondBalanceLabel = [[UILabel alloc] init];
    _diamondBalanceLabel.textColor = kWhiteColor;
    _diamondBalanceLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(10)];
    _diamondBalanceLabel.text = @"0";
    _diamondBalanceLabel.adjustsFontSizeToFitWidth = YES;
    _diamondBalanceLabel.minimumScaleFactor = 0.5;
    [_diamondBarView addSubview:_diamondBalanceLabel];
    [_diamondBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_diamondIcon.mas_trailing).offset(KDialogAdaptedWidth(4));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(8));
        make.centerY.mas_equalTo(_diamondBarView);
    }];
}

#pragma mark - Data Fetching & Refreshes

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    
    // 1. Fetch user asset balances
    [MLGameLotteryService getUserMoneyWithSuccess:^(MLGameUserMoneyModel *moneyModel) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf || !moneyModel) return;
        
        id diamondVal = moneyModel.diamond;
        double diamondDouble = 0.0;
        if (diamondVal && diamondVal != [NSNull null]) {
            diamondDouble = [diamondVal doubleValue];
        }
        NSInteger diamondInt = (NSInteger)diamondDouble;
        NSString *diamondStr = [NSString stringWithFormat:@"%ld", (long)diamondInt];
        strongSelf.diamondBalanceLabel.text = diamondStr;
        strongSelf.localKeyBalance = moneyModel.lottery_coin;
        [strongSelf updateBalanceUI];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 2. Load lottery rules & detail costs
    [MLGameLotteryService getRoomDetailWithTypeId:self.typeId success:^(MLGameLotteryInfoModel *model) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf || !model) return;
        strongSelf.infoModel = model;
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 3. Load 16 prize cards dynamically
    [MLGameLotteryService getPrizesWithTypeId:self.typeId success:^(NSArray<MLGameDrawResultModel *> *list) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf || !list) return;
        strongSelf.prizesInPool = list;
        [strongSelf renderGiftBoard];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)updateBalanceUI {
    NSString *keyStr = [NSString stringWithFormat:@"%ld", (long)_localKeyBalance];
    if (keyStr.length > 8) {
        keyStr = [NSString stringWithFormat:@"%@...", [keyStr substringToIndex:8]];
    }
    _keyBalanceLabel.text = keyStr;
}

- (void)renderGiftBoard {
    for (int i = 0; i < _cardViews.count; i++) {
        MLChatRoomThemeGameFiveCard *card = _cardViews[i];
        BOOL isYellow = NO;
        if (i < self.prizesInPool.count) {
            [card configureWithModel:self.prizesInPool[i] isYellow:isYellow];
        } else {
            [card configureWithModel:nil isYellow:isYellow];
        }
    }
}

#pragma mark - Click Action Handlers

- (void)giftClick {
    [MLChatRoomThemeGameFiveGiftView showInView:self.superview typeId:self.typeId prizes:self.prizesInPool];
}

- (void)ruleClick {
    [MLChatRoomThemeGameFiveRuleView showInView:self.superview ruleContent:self.infoModel.content];
}

- (void)recordClick {
    [SVProgressHUD showInfoWithStatus:getLanguage(@"记录开发中")];
}

- (void)keyPurchaseClick {
    [self rechargeClick];
}

- (void)rechargeClick {
    // Recharge redirection
    UIViewController *currVC = [UIViewController currentViewController];
    if (currVC) {
        CFMWalletDiamondRechargeVc *rechargeVC = [[CFMWalletDiamondRechargeVc alloc] init];
        __weak typeof(self) weakSelf = self;
        self.hidden = YES;
        rechargeVC.dismissBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf) {
                    strongSelf.hidden = NO;
                    [strongSelf loadData];
                }
            });
        };
        if (currVC.navigationController) {
            [currVC.navigationController pushViewController:rechargeVC animated:YES];
        } else {
            rechargeVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [currVC presentViewController:rechargeVC animated:NO completion:nil];
        }
    }
}

- (void)drawOneClick {
    [self performDrawWithTimes:1];
}

- (void)drawTenClick {
    [self performDrawWithTimes:10];
}

- (void)drawHundredClick {
    [self performDrawWithTimes:100];
}

- (void)performDrawWithTimes:(NSInteger)times {
    if (self.isDrawing) return;
    
    NSInteger requiredKeys = times;
    
    // Verify key balance
    if (self.localKeyBalance < requiredKeys) {
        [self keyPurchaseClick];
        return;
    }
    
    self.isDrawing = YES;
    
    // Optimistic local key balance deduction
    self.localKeyBalance -= requiredKeys;
    [self updateBalanceUI];
    
    // Perform lottery request
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [MLGameLotteryService drawWithTypeId:self.typeId times:times success:^(NSArray<MLGameDrawResultModel *> *list, NSInteger totalValue, NSInteger logId) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        [SVProgressHUD dismiss];
        strongSelf.isDrawing = NO;
        
        // Show result view and reload data
        [MLChatRoomThemeGameFiveResultView showInView:strongSelf.superview gifts:list totalValue:totalValue];
        [strongSelf loadData];
    } failure:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.isDrawing = NO;
            [strongSelf loadData];
        }
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - Show / Dismiss Animations

- (void)animateShow {
    self.alpha = 0;
    _backgroundContainer.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
        self.backgroundContainer.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)handleMaskTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    if (!CGRectContainsPoint(_backgroundContainer.frame, point)) {
        [self closeClick];
    }
}

- (void)closeClick {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0;
        self.backgroundContainer.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
