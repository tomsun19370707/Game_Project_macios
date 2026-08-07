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
#import "MLChatRoomThemeGameFiveRecordView.h"
#import "MLChatRoomThemeGameFivePurchaseView.h"
#import "MLChatRoomThemeGameFiveFortuneView.h"
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
@property (nonatomic, assign) NSInteger fortuneConsume;
@property (nonatomic, assign) NSInteger fortuneProduce;
@property (nonatomic, strong) MLGameLotteryInfoModel *infoModel;

// 全服中奖跑马灯视图与数据
@property (nonatomic, strong) UIView *marqueeContainer;
@property (nonatomic, strong) UILabel *marqueeCurrentLabel;
@property (nonatomic, strong) UILabel *marqueeNextLabel;
@property (nonatomic, strong) NSTimer *marqueeTimer;
@property (nonatomic, strong) NSArray<NSDictionary *> *marqueeDataList;
@property (nonatomic, assign) NSInteger marqueeCurrentIndex;

// Marquee Spin Animation States
@property (nonatomic, strong) NSTimer *spinTimer;
@property (nonatomic, assign) NSInteger currentHighlightIndex;
@property (nonatomic, assign) NSInteger totalSpinSteps;
@property (nonatomic, assign) NSInteger currentSpinStep;
@property (nonatomic, assign) NSInteger targetLandingIndex;
@property (nonatomic, assign) NSInteger currentDrawCount;
@property (nonatomic, copy) void(^spinCompletionBlock)(void);

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
        self.typeId = typeId > 0 ? typeId : 14;
        self.cardViews = [NSMutableArray array];
        _currentHighlightIndex = -1;
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

    // 今日运势入口 (右上角上方 70pt x 30pt 胶囊)
    CGFloat fortuneW = KDialogAdaptedWidth(70.0f);
    CGFloat fortuneH = KDialogAdaptedWidth(30.0f);
    UIView *fortuneBar = [[UIView alloc] init];
    fortuneBar.userInteractionEnabled = YES;
    [self addSubview:fortuneBar];
    [fortuneBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_backgroundContainer.mas_top).offset(-KDialogAdaptedWidth(6));
        make.trailing.mas_equalTo(_backgroundContainer.mas_trailing).offset(-KDialogAdaptedWidth(12));
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
    
    UILabel *fortuneLabel = [[UILabel alloc] init];
    fortuneLabel.text = @"今日运势";
    fortuneLabel.textColor = kWhiteColor;
    fortuneLabel.font = [UIFont boldSystemFontOfSize:11];
    fortuneLabel.textAlignment = NSTextAlignmentCenter;
    [fortuneBar addSubview:fortuneLabel];
    [fortuneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(fortuneBar);
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

    // Marquee View Container (百分比 32.5% 高度锚定，左右受控于 _giftButton 与 _ruleButton)
    _marqueeContainer = [[UIView alloc] init];
    _marqueeContainer.clipsToBounds = YES;
    _marqueeContainer.hidden = YES;
    [_backgroundContainer addSubview:_marqueeContainer];
    [_marqueeContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_backgroundContainer.mas_top).offset(KDialogAdaptedWidth(540 * 0.325));
        make.leading.mas_equalTo(_giftButton.mas_trailing).offset(KDialogAdaptedWidth(10));
        make.trailing.mas_equalTo(_ruleButton.mas_leading).offset(-KDialogAdaptedWidth(10));
        make.height.mas_equalTo(KDialogAdaptedWidth(28));
    }];

    _marqueeCurrentLabel = [[UILabel alloc] init];
    _marqueeCurrentLabel.textColor = [UIColor whiteColor];
    _marqueeCurrentLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(13.5)];
    _marqueeCurrentLabel.textAlignment = NSTextAlignmentCenter;
    [_marqueeContainer addSubview:_marqueeCurrentLabel];
    [_marqueeCurrentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_marqueeContainer);
    }];

    _marqueeNextLabel = [[UILabel alloc] init];
    _marqueeNextLabel.textColor = [UIColor whiteColor];
    _marqueeNextLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(13.5)];
    _marqueeNextLabel.textAlignment = NSTextAlignmentCenter;
    _marqueeNextLabel.hidden = YES;
    [_marqueeContainer addSubview:_marqueeNextLabel];
    [_marqueeNextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_marqueeContainer);
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
    [_drawOneButton setBackgroundImage:[UIImage imageNamed:@"theme_game_five_draw_one_bg"] forState:UIControlStateNormal];
    [_drawOneButton addTarget:self action:@selector(drawOneClick) forControlEvents:UIControlEventTouchUpInside];
    _drawOneButton.adjustsImageWhenHighlighted = NO;
    [_actionContainer addSubview:_drawOneButton];
    
    UIImageView *drawOneTextIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme_game_five_draw_one_text"]];
    drawOneTextIv.contentMode = UIViewContentModeScaleAspectFit;
    drawOneTextIv.userInteractionEnabled = NO;
    [_drawOneButton addSubview:drawOneTextIv];
    [drawOneTextIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_drawOneButton);
        make.width.mas_equalTo(KDialogAdaptedWidth(66));
    }];

    // Middle Ten Draw Button (2360 diamonds)
    _drawTenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawTenButton setBackgroundImage:[UIImage imageNamed:@"theme_game_five_draw_ten_bg"] forState:UIControlStateNormal];
    [_drawTenButton addTarget:self action:@selector(drawTenClick) forControlEvents:UIControlEventTouchUpInside];
    _drawTenButton.adjustsImageWhenHighlighted = NO;
    [_actionContainer addSubview:_drawTenButton];
    
    UIImageView *drawTenTextIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme_game_five_draw_ten_text"]];
    drawTenTextIv.contentMode = UIViewContentModeScaleAspectFit;
    drawTenTextIv.userInteractionEnabled = NO;
    [_drawTenButton addSubview:drawTenTextIv];
    [drawTenTextIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_drawTenButton);
        make.width.mas_equalTo(KDialogAdaptedWidth(66));
    }];

    // Right Hundred Draw Button (23600 diamonds)
    _drawHundredButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawHundredButton setBackgroundImage:[UIImage imageNamed:@"theme_game_five_draw_hundred_bg"] forState:UIControlStateNormal];
    [_drawHundredButton addTarget:self action:@selector(drawHundredClick) forControlEvents:UIControlEventTouchUpInside];
    _drawHundredButton.adjustsImageWhenHighlighted = NO;
    [_actionContainer addSubview:_drawHundredButton];
    
    UIImageView *drawHundredTextIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme_game_five_draw_hundred_text"]];
    drawHundredTextIv.contentMode = UIViewContentModeScaleAspectFit;
    drawHundredTextIv.userInteractionEnabled = NO;
    [_drawHundredButton addSubview:drawHundredTextIv];
    [drawHundredTextIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_drawHundredButton);
        make.width.mas_equalTo(KDialogAdaptedWidth(66));
    }];

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
    UITapGestureRecognizer *keyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyPurchaseClick)];
    [_keyBarView addGestureRecognizer:keyTap];
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
    [self loadMarqueeData];
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
        strongSelf.diamondBalanceLabel.text = MLFormatLargeNumber(diamondDouble);
        strongSelf.localKeyBalance = moneyModel.lottery_coin;
        strongSelf.keyBalanceLabel.text = MLFormatLargeNumber((double)strongSelf.localKeyBalance);
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
    
    // 4. Load fortune data
    [MLGameLotteryService getFortuneLotteryListWithSuccess:^(NSArray<MLGameLotteryInfoModel *> *list) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf || !list || ![list isKindOfClass:[NSArray class]]) return;
        for (MLGameLotteryInfoModel *model in list) {
            if (model.typeId == strongSelf.typeId || [model.name containsString:@"砸蛋"]) {
                strongSelf.fortuneConsume = (NSInteger)model.consume_diamonds;
                strongSelf.fortuneProduce = (NSInteger)model.produce_diamonds;
                break;
            }
        }
    }];
}

- (void)fortuneClick {
    [MLChatRoomThemeGameFiveFortuneView showInView:self.superview consume:self.fortuneConsume produce:self.fortuneProduce];
}



- (void)updateBalanceUI {
    _keyBalanceLabel.text = MLFormatLargeNumber((double)_localKeyBalance);
}

- (void)renderGiftBoard {
    for (int i = 0; i < _cardViews.count; i++) {
        MLChatRoomThemeGameFiveCard *card = _cardViews[i];
        BOOL isYellow = (i == self.currentHighlightIndex);
        if (i < self.prizesInPool.count) {
            [card configureWithModel:self.prizesInPool[i] isYellow:isYellow];
        } else {
            [card configureWithModel:nil isYellow:isYellow];
        }
    }
}

#pragma mark - Marquee Spin Animation Controls

- (void)updateCardHighlightIndex:(NSInteger)highlightIndex {
    for (NSInteger i = 0; i < self.cardViews.count; i++) {
        MLChatRoomThemeGameFiveCard *card = self.cardViews[i];
        MLGameDrawResultModel *model = (i < self.prizesInPool.count) ? self.prizesInPool[i] : nil;
        [card configureWithModel:model isYellow:(i == highlightIndex)];
    }
}

- (void)resetCardHighlights {
    self.currentHighlightIndex = -1;
    [self updateCardHighlightIndex:-1];
}

- (void)startPhase1UniformSpin {
    [self stopSpinTimer];
    __weak typeof(self) weakSelf = self;
    self.spinTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        strongSelf.currentHighlightIndex = (strongSelf.currentHighlightIndex + 1) % 16;
        [strongSelf updateCardHighlightIndex:strongSelf.currentHighlightIndex];
    }];
}

- (void)startPhase2DecelerateSpinToTargetIndex:(NSInteger)targetIndex drawCount:(NSInteger)drawCount completion:(void(^)(void))completion {
    [self stopSpinTimer];
    self.spinCompletionBlock = completion;
    self.targetLandingIndex = targetIndex;
    self.currentDrawCount = drawCount;
    
    // 依据 drawCount 动态差异化 baseSteps 圈数 (100抽: 4步 / 10抽: 8步 / 1抽: 16步)
    NSInteger baseSteps = (drawCount >= 100) ? 4 : ((drawCount >= 10) ? 8 : 16);
    NSInteger extraSteps = (targetIndex - self.currentHighlightIndex + 16) % 16;
    self.totalSpinSteps = baseSteps + extraSteps;
    self.currentSpinStep = 0;
    
    [self scheduleNextDecelerateStep];
}

- (void)scheduleNextDecelerateStep {
    if (self.currentSpinStep >= self.totalSpinSteps) {
        self.currentHighlightIndex = self.targetLandingIndex;
        [self updateCardHighlightIndex:self.targetLandingIndex];
        if (self.spinCompletionBlock) {
            self.spinCompletionBlock();
            self.spinCompletionBlock = nil;
        }
        return;
    }
    
    self.currentHighlightIndex = (self.currentHighlightIndex + 1) % 16;
    [self updateCardHighlightIndex:self.currentHighlightIndex];
    self.currentSpinStep++;
    
    // 依据 drawCount 计算渐进阻尼延迟 (100连抽: 15ms->80ms; 10连抽: 20ms->150ms; 1抽: 30ms->250ms)
    double progress = (double)self.currentSpinStep / (double)self.totalSpinSteps;
    double startDelay = (self.currentDrawCount >= 100) ? 0.015 : ((self.currentDrawCount >= 10) ? 0.020 : 0.030);
    double endDelayDelta = (self.currentDrawCount >= 100) ? 0.065 : ((self.currentDrawCount >= 10) ? 0.130 : 0.220);
    double delay = startDelay + endDelayDelta * (progress * progress);
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf && strongSelf.isDrawing) {
            [strongSelf scheduleNextDecelerateStep];
        }
    });
}

- (void)stopSpinTimer {
    if (self.spinTimer) {
        [self.spinTimer invalidate];
        self.spinTimer = nil;
    }
}

#pragma mark - Click Action Handlers

- (void)giftClick {
    if (self.isDrawing) return;
    [MLChatRoomThemeGameFiveGiftView showInView:self.superview typeId:self.typeId prizes:self.prizesInPool];
}

- (void)ruleClick {
    if (self.isDrawing) return;
    [MLChatRoomThemeGameFiveRuleView showInView:self.superview ruleContent:self.infoModel.content];
}

- (void)recordClick {
    if (self.isDrawing) return;
    [MLChatRoomThemeGameFiveRecordView showInView:self.superview typeId:self.typeId];
}

- (void)keyPurchaseClick {
    if (self.isDrawing) return;
    __weak typeof(self) weakSelf = self;
    [MLChatRoomThemeGameFivePurchaseView showInView:self.superview infoModel:self.infoModel purchaseSuccess:^(NSInteger newKeyBalance) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.localKeyBalance = newKeyBalance;
            [strongSelf updateBalanceUI];
        }
    }];
}

- (void)rechargeClick {
    if (self.isDrawing) return;
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
    self.currentDrawCount = times;
    
    // Optimistic local key balance deduction
    self.localKeyBalance -= requiredKeys;
    [self updateBalanceUI];
    
    // 1. 【0ms 瞬间响应】Start Phase 1 uniform card spin (0 -> 1 -> ... -> 15)
    [self startPhase1UniformSpin];
    
    // 2. Perform lottery request
    __weak typeof(self) weakSelf = self;
    [MLGameLotteryService drawWithTypeId:self.typeId times:times success:^(NSArray<MLGameDrawResultModel *> *list, NSInteger totalValue, NSInteger logId) {
        // 3. 在 GCD 后台子线程寻找最高价奖品 targetIndex 落点
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSInteger targetIndex = 0;
            if (list && list.count > 0 && weakSelf.prizesInPool && weakSelf.prizesInPool.count > 0) {
                MLGameDrawResultModel *highestPrize = nil;
                for (MLGameDrawResultModel *prize in list) {
                    if (!highestPrize || prize.price > highestPrize.price) {
                        highestPrize = prize;
                    }
                }
                if (highestPrize) {
                    for (NSInteger i = 0; i < weakSelf.prizesInPool.count; i++) {
                        if (weakSelf.prizesInPool[i].price == highestPrize.price || [weakSelf.prizesInPool[i].name isEqualToString:highestPrize.name]) {
                            targetIndex = i;
                            break;
                        }
                    }
                }
            }
            
            // 4. 切回主线程启动 Phase 2 微分降速并拉起结果弹窗
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                
                [strongSelf startPhase2DecelerateSpinToTargetIndex:targetIndex drawCount:times completion:^{
                    strongSelf.isDrawing = NO;
                    [MLChatRoomThemeGameFiveResultView showInView:strongSelf.superview gifts:list totalValue:totalValue];
                    [strongSelf loadData];
                }];
            });
        });
    } failure:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf stopSpinTimer];
            [strongSelf resetCardHighlights];
            strongSelf.isDrawing = NO;
            strongSelf.localKeyBalance += requiredKeys; // Rollback
            [strongSelf updateBalanceUI];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
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
    if (self.isDrawing) return;
    CGPoint point = [gesture locationInView:self];
    if (!CGRectContainsPoint(_backgroundContainer.frame, point)) {
        [self closeClick];
    }
}

- (void)closeClick {
    if (self.isDrawing) return;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0;
        self.backgroundContainer.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        [self stopMarqueeTimer];
        [self stopSpinTimer];
        [self removeFromSuperview];
    }];
}

- (void)removeFromSuperview {
    [self stopMarqueeTimer];
    [self stopSpinTimer];
    [super removeFromSuperview];
}

- (void)dealloc {
    [self stopMarqueeTimer];
    [self stopSpinTimer];
}

#pragma mark - 全服中奖消息广播跑马灯与垂直翻页

- (void)loadMarqueeData {
    __weak typeof(self) weakSelf = self;
    [MLGameLotteryService getLotteryWinLogWithTypeId:self.typeId page:1 pageSize:20 success:^(NSArray *list, NSInteger total) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        if (list && [list isKindOfClass:[NSArray class]] && list.count > 0) {
            strongSelf.marqueeDataList = list;
            strongSelf.marqueeCurrentIndex = 0;
            strongSelf.marqueeContainer.hidden = NO;
            [strongSelf updateMarqueeLabel:strongSelf.marqueeCurrentLabel withItem:list[0]];
            [strongSelf startMarqueeTimer];
        } else {
            strongSelf.marqueeContainer.hidden = YES;
            [strongSelf stopMarqueeTimer];
        }
    } failure:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        strongSelf.marqueeContainer.hidden = YES;
        [strongSelf stopMarqueeTimer];
    }];
}

- (void)updateMarqueeLabel:(UILabel *)label withItem:(NSDictionary *)item {
    if (!item || ![item isKindOfClass:[NSDictionary class]] || !label) return;
    NSString *nickname = item[@"nickname"] ?: @"";
    NSString *giftName = item[@"name"] ?: @"";
    NSString *text = [NSString stringWithFormat:@"恭喜 %@ 抽中 %@", nickname, giftName];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, text.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:KDialogAdaptedWidth(13.5)] range:NSMakeRange(0, text.length)];
    
    UIColor *goldColor = [UIColor colorWithRed:0xFF/255.0 green:0xE6/255.0 blue:0x6F/255.0 alpha:1.0];
    NSRange nickRange = [text rangeOfString:nickname];
    if (nickRange.location != NSNotFound) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:goldColor range:nickRange];
    }
    NSRange giftRange = [text rangeOfString:giftName options:NSBackwardsSearch];
    if (giftRange.location != NSNotFound) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:goldColor range:giftRange];
    }
    label.attributedText = attrStr;
}

- (void)startMarqueeTimer {
    [self stopMarqueeTimer];
    if (!self.marqueeDataList || self.marqueeDataList.count <= 1) return;
    
    __weak typeof(self) weakSelf = self;
    self.marqueeTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf || !strongSelf.marqueeDataList || strongSelf.marqueeDataList.count == 0) return;
        [strongSelf showNextMarqueeItem];
    }];
}

- (void)showNextMarqueeItem {
    if (!self.marqueeDataList || self.marqueeDataList.count == 0) return;
    NSInteger nextIndex = (self.marqueeCurrentIndex + 1) % self.marqueeDataList.count;
    NSDictionary *nextItem = self.marqueeDataList[nextIndex];
    [self updateMarqueeLabel:self.marqueeNextLabel withItem:nextItem];
    
    CGFloat containerH = KDialogAdaptedWidth(28);
    self.marqueeNextLabel.transform = CGAffineTransformMakeTranslation(0, containerH);
    self.marqueeNextLabel.hidden = NO;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.marqueeCurrentLabel.transform = CGAffineTransformMakeTranslation(0, -containerH);
        weakSelf.marqueeNextLabel.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        strongSelf.marqueeCurrentIndex = nextIndex;
        strongSelf.marqueeCurrentLabel.attributedText = strongSelf.marqueeNextLabel.attributedText;
        strongSelf.marqueeCurrentLabel.transform = CGAffineTransformIdentity;
        strongSelf.marqueeNextLabel.hidden = YES;
        strongSelf.marqueeNextLabel.transform = CGAffineTransformIdentity;
    }];
}

- (void)stopMarqueeTimer {
    if (self.marqueeTimer) {
        [self.marqueeTimer invalidate];
        self.marqueeTimer = nil;
    }
}

@end
