//
//  MLChatRoomThemeGameFourView.m
//  miliao
//

#import "MLChatRoomThemeGameFourView.h"
#import "MLGameLotteryService.h"
#import "RoomFloatingWindow.h"
#import "AppDelegate.h"
#import "MLChatRoomThemeGameFourFortuneView.h"
#import "Global.h"
#import "UIViewController+CurViewController.h"
#import "CFMWalletDiamondRechargeVc.h"
#import <Masonry/Masonry.h>
#import "SVGAPlayer.h"
#import "SVGAParser.h"
#import <SVProgressHUD.h>

// Forward declarations for placeholders to be implemented next
#import "MLChatRoomThemeGameFourPurchaseView.h"
#import "MLChatRoomThemeGameFourResultView.h"
#import "MLChatRoomThemeGameFourGiftView.h"
#import "MLChatRoomThemeGameFourRecordView.h"
#import "MLChatRoomThemeGameFourRuleView.h"
#import "MLChatRoomThemeGameFourRankView.h"

@interface MLChatRoomThemeGameFourView () <SVGAPlayerDelegate>

@property (nonatomic, assign) NSInteger typeId; // 8: 青玉, 9: 碧海, 10: 鎏金
@property (nonatomic, copy) NSString *themeColorName; // "green", "blue", "yellow"

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *backgroundContainer;
@property (nonatomic, strong) SVGAPlayer *svgaPlayer;
@property (nonatomic, copy, nullable) void (^svgaCompletionBlock)(void);
@property (nonatomic, assign) CFTimeInterval drawStartTime;
@property (nonatomic, assign) BOOL hasPendingDrawResult;
@property (nonatomic, strong, nullable) NSArray<MLGameDrawResultModel *> *pendingResultList;
@property (nonatomic, assign) NSInteger pendingTotalValue;

// Containers
@property (nonatomic, strong) UIView *hudContainer;
@property (nonatomic, strong) UIView *actionContainer;

// Main Central Bag Image
@property (nonatomic, strong) UIImageView *ivMainBg;

// Floating Fortune Button
@property (nonatomic, strong) UIView *fortuneBar;
@property (nonatomic, strong) UILabel *fortuneLabel;

// HUD Elements
@property (nonatomic, strong) UIButton *rankButton;
@property (nonatomic, strong) UIButton *ruleButton;
@property (nonatomic, strong) UIButton *recordButton;

// Action Elements
@property (nonatomic, strong) UIImageView *diamondBarView;
@property (nonatomic, strong) UIImageView *diamondIcon;
@property (nonatomic, strong) UILabel *diamondBalanceLabel;
@property (nonatomic, strong) UIButton *diamondPlusButton;

@property (nonatomic, strong) UIImageView *keyBarView;
@property (nonatomic, strong) UIImageView *keyIcon;
@property (nonatomic, strong) UILabel *keyBalanceLabel;
@property (nonatomic, strong) UIButton *keyPlusButton;

@property (nonatomic, strong) UIButton *drawOneButton;
@property (nonatomic, strong) UIButton *drawTenButton;
@property (nonatomic, strong) UIButton *drawHundredButton;

// State properties
@property (nonatomic, assign) BOOL isDrawing;
@property (nonatomic, strong) MLGameLotteryInfoModel *infoModel;
@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *prizesInPool;
@property (nonatomic, assign) NSInteger localKeyBalance;
@property (nonatomic, assign) NSInteger consumeValue;
@property (nonatomic, assign) NSInteger produceValue;

@end

@implementation MLChatRoomThemeGameFourView

+ (void)showInView:(UIView *)parentView typeId:(NSInteger)typeId {
    if (!parentView) return;
    
    // Remove existing if any to prevent overlaying
    for (UIView *subview in parentView.subviews) {
        if ([subview isKindOfClass:[MLChatRoomThemeGameFourView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    MLChatRoomThemeGameFourView *gameView = [[MLChatRoomThemeGameFourView alloc] initWithFrame:parentView.bounds typeId:typeId];
    [parentView addSubview:gameView];
    [gameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(parentView);
    }];
    [gameView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame typeId:(NSInteger)typeId {
    self = [super initWithFrame:frame];
    if (self) {
        _typeId = typeId > 0 ? typeId : 8;
        
        // Map typeId to theme color suffix
        if (_typeId == 8) {
            _themeColorName = @"green";
        } else if (_typeId == 9) {
            _themeColorName = @"blue";
        } else {
            _themeColorName = @"yellow"; // Default 10
        }
        
        [self setupUI];
        [self loadData];
        
        // Hide top floating voice bubble window if active
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.roomViewController && appDelegate.roomViewController.floatingWindow) {
            appDelegate.roomViewController.floatingWindow.hidden = YES;
        }
    }
    return self;
}

- (NSString *)getThemeImageName:(NSString *)baseName {
    return [NSString stringWithFormat:@"theme_game_four_%@_%@", self.themeColorName, baseName];
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 1. Dark Overlay Mask
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _maskView.userInteractionEnabled = YES;
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMaskTap:)];
    [_maskView addGestureRecognizer:tap];
    
    // 2. Background Container (Locked aspect ratio 750:1200, bottom-aligned, maximum width 390 pt)
    _backgroundContainer = [[UIView alloc] init];
    _backgroundContainer.backgroundColor = [UIColor clearColor];
    _backgroundContainer.userInteractionEnabled = YES;
    [self addSubview:_backgroundContainer];
    [_backgroundContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self).priorityMedium();
        make.width.mas_lessThanOrEqualTo(390).priorityHigh();
        make.height.mas_equalTo(_backgroundContainer.mas_width).multipliedBy(1200.0 / 750.0);
    }];
    
    // 3. SVGAPlayer Layer (Placed on the top level of the screen overlay, loop=1)
    _svgaPlayer = [[SVGAPlayer alloc] init];
    _svgaPlayer.loops = 1;
    _svgaPlayer.delegate = self;
    _svgaPlayer.contentMode = UIViewContentModeScaleAspectFit;
    _svgaPlayer.hidden = YES;
    [self addSubview:_svgaPlayer];
    [_svgaPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backgroundContainer.mas_top).offset(-KDialogAdaptedWidth(145));
        make.leading.trailing.mas_equalTo(_backgroundContainer);
        make.height.mas_equalTo(_backgroundContainer.mas_width).multipliedBy(1396.0 / 750.0);
    }];
    
    // Pre-parse corresponding SVGA resource to avoid delay when drawing
    SVGAParser *parser = [[SVGAParser alloc] init];
    NSString *svgaName = [NSString stringWithFormat:@"theme_game_four_%@_draw", self.themeColorName];
    NSURL *svgaURL = [[NSBundle mainBundle] URLForResource:svgaName withExtension:@"svga"];
    if (svgaURL) {
        __weak typeof(self) weakSelf = self;
        [parser parseWithURL:svgaURL completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                strongSelf.svgaPlayer.videoItem = videoItem;
            }
        } failureBlock:nil];
    }
    
    // 4. Central Bag Background Image (Locked aspect ratio 1:1, Y top margin 67.5 pt)
    _ivMainBg = [[UIImageView alloc] init];
    _ivMainBg.image = [UIImage imageNamed:[self getThemeImageName:@"bg"]];
    _ivMainBg.contentMode = UIViewContentModeScaleAspectFit;
    [_backgroundContainer addSubview:_ivMainBg];
    [_ivMainBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(_backgroundContainer);
        make.top.mas_equalTo(_backgroundContainer).offset(KDialogAdaptedWidth(67.5));
        make.height.mas_equalTo(_backgroundContainer.mas_width);
    }];
    
    // 1. 容器外正上方左侧【奖品池】悬浮条 (宽 70, 高 30. 悬浮在左上角外侧，与右侧今日运势 100% 对称)
    CGFloat poolW = KDialogAdaptedWidth(70.0f);
    CGFloat poolH = KDialogAdaptedWidth(30.0f);
    UIView *giftPoolBar = [[UIView alloc] init];
    giftPoolBar.userInteractionEnabled = YES;
    [self addSubview:giftPoolBar];
    [giftPoolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_backgroundContainer.mas_top).offset(-KDialogAdaptedWidth(6));
        make.leading.mas_equalTo(_backgroundContainer.mas_leading).offset(KDialogAdaptedWidth(12));
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

    // 5. Today's Fortune entrance (floating outside top right)
    CGFloat fortuneW = KDialogAdaptedWidth(70.0f);
    CGFloat fortuneH = KDialogAdaptedWidth(30.0f);
    _fortuneBar = [[UIView alloc] init];
    _fortuneBar.userInteractionEnabled = YES;
    [self addSubview:_fortuneBar];
    [_fortuneBar mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [_fortuneBar.layer addSublayer:fortuneGrad];
    
    _fortuneBar.layer.borderColor = mHexRGB(0xFFE57F).CGColor;
    _fortuneBar.layer.borderWidth = 1.5;
    _fortuneBar.layer.cornerRadius = KDialogAdaptedWidth(15.0f);
    _fortuneBar.clipsToBounds = YES;
    
    UITapGestureRecognizer *fortuneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fortuneClick)];
    [_fortuneBar addGestureRecognizer:fortuneTap];
    
    _fortuneLabel = [[UILabel alloc] init];
    _fortuneLabel.text = @"今日运势";
    _fortuneLabel.textColor = kWhiteColor;
    _fortuneLabel.font = [UIFont boldSystemFontOfSize:11];
    _fortuneLabel.textAlignment = NSTextAlignmentCenter;
    [_fortuneBar addSubview:_fortuneLabel];
    [_fortuneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_fortuneBar);
    }];
    
    // 6. HUD Container (Top bar area)
    _hudContainer = [[UIView alloc] init];
    _hudContainer.backgroundColor = [UIColor clearColor];
    [_backgroundContainer addSubview:_hudContainer];
    [_hudContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(_backgroundContainer);
        make.height.mas_equalTo(KDialogAdaptedWidth(150));
    }];
    
    // Leaderboard button (Top Left)
    _rankButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rankButton setBackgroundImage:[UIImage imageNamed:[self getThemeImageName:@"rank"]] forState:UIControlStateNormal];
    [_rankButton addTarget:self action:@selector(rankClick) forControlEvents:UIControlEventTouchUpInside];
    [_hudContainer addSubview:_rankButton];
    [_rankButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(30));
        make.leading.mas_equalTo(KDialogAdaptedWidth(20));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(76), KDialogAdaptedWidth(74)));
    }];
    
    // Rules button (Top Right)
    _ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ruleButton setBackgroundImage:[UIImage imageNamed:[self getThemeImageName:@"rule"]] forState:UIControlStateNormal];
    [_ruleButton addTarget:self action:@selector(ruleClick) forControlEvents:UIControlEventTouchUpInside];
    [_hudContainer addSubview:_ruleButton];
    [_ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(30));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(20));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(76), KDialogAdaptedWidth(74)));
    }];
    
    // Records button (Below Rules)
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordButton setBackgroundImage:[UIImage imageNamed:[self getThemeImageName:@"record"]] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
    [_hudContainer addSubview:_recordButton];
    [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_ruleButton.mas_bottom).offset(KDialogAdaptedWidth(10));
        make.centerX.mas_equalTo(_ruleButton);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(76), KDialogAdaptedWidth(72)));
    }];
    
    // 7. Action Container (Bottom asset & control area)
    _actionContainer = [[UIView alloc] init];
    _actionContainer.backgroundColor = [UIColor clearColor];
    [_backgroundContainer addSubview:_actionContainer];
    [_actionContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(_backgroundContainer);
        make.top.mas_equalTo(_backgroundContainer.mas_top).offset(KDialogAdaptedWidth(365));
    }];
    
    // Diamond Bar View (Left side of asset bar)
    _diamondBarView = [[UIImageView alloc] init];
    _diamondBarView.image = [UIImage imageNamed:[self getThemeImageName:@"asset_bg"]];
    _diamondBarView.contentMode = UIViewContentModeScaleToFill;
    _diamondBarView.userInteractionEnabled = YES;
    [_actionContainer addSubview:_diamondBarView];
    [_diamondBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(24));
        make.top.mas_equalTo(KDialogAdaptedWidth(10)); // Offset from ActionContainer top (375 pt from absolute top)
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(100), KDialogAdaptedWidth(26)));
    }];
    
    UITapGestureRecognizer *diaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(diamondRechargeClick)];
    [_diamondBarView addGestureRecognizer:diaTap];
    
    _diamondIcon = [[UIImageView alloc] init];
    _diamondIcon.image = [UIImage imageNamed:[self getThemeImageName:@"diamond"]];
    _diamondIcon.contentMode = UIViewContentModeScaleAspectFit;
    [_diamondBarView addSubview:_diamondIcon];
    [_diamondIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(6));
        make.centerY.mas_equalTo(_diamondBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(18), KDialogAdaptedWidth(15)));
    }];
    
    _diamondPlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_diamondPlusButton setImage:[UIImage imageNamed:[self getThemeImageName:@"plus"]] forState:UIControlStateNormal];
    [_diamondPlusButton addTarget:self action:@selector(diamondRechargeClick) forControlEvents:UIControlEventTouchUpInside];
    [_diamondBarView addSubview:_diamondPlusButton];
    [_diamondPlusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(4));
        make.centerY.mas_equalTo(_diamondBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(12), KDialogAdaptedWidth(12)));
    }];
    
    _diamondBalanceLabel = [[UILabel alloc] init];
    _diamondBalanceLabel.text = @"0";
    _diamondBalanceLabel.textColor = kWhiteColor;
    _diamondBalanceLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(11)];
    _diamondBalanceLabel.textAlignment = NSTextAlignmentCenter;
    _diamondBalanceLabel.lineBreakMode = NSLineBreakByClipping;
    [_diamondBarView addSubview:_diamondBalanceLabel];
    [_diamondBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_diamondIcon.mas_trailing).offset(KDialogAdaptedWidth(2));
        make.trailing.mas_equalTo(_diamondPlusButton.mas_leading).offset(-KDialogAdaptedWidth(2));
        make.centerY.mas_equalTo(_diamondBarView);
    }];
    
    // Key Bar View (Right side of asset bar)
    _keyBarView = [[UIImageView alloc] init];
    _keyBarView.image = [UIImage imageNamed:[self getThemeImageName:@"asset_bg"]];
    _keyBarView.contentMode = UIViewContentModeScaleToFill;
    _keyBarView.userInteractionEnabled = YES;
    [_actionContainer addSubview:_keyBarView];
    [_keyBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(24));
        make.top.mas_equalTo(_diamondBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(100), KDialogAdaptedWidth(26)));
    }];
    
    UITapGestureRecognizer *keyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyPurchaseClick)];
    [_keyBarView addGestureRecognizer:keyTap];
    
    _keyIcon = [[UIImageView alloc] init];
    _keyIcon.image = [UIImage imageNamed:[self getThemeImageName:@"key"]];
    _keyIcon.contentMode = UIViewContentModeScaleAspectFit;
    [_keyBarView addSubview:_keyIcon];
    [_keyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(6));
        make.centerY.mas_equalTo(_keyBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(11), KDialogAdaptedWidth(15)));
    }];
    
    _keyPlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_keyPlusButton setImage:[UIImage imageNamed:[self getThemeImageName:@"plus"]] forState:UIControlStateNormal];
    [_keyPlusButton addTarget:self action:@selector(keyPurchaseClick) forControlEvents:UIControlEventTouchUpInside];
    [_keyBarView addSubview:_keyPlusButton];
    [_keyPlusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(4));
        make.centerY.mas_equalTo(_keyBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(12), KDialogAdaptedWidth(12)));
    }];
    
    _keyBalanceLabel = [[UILabel alloc] init];
    _keyBalanceLabel.text = @"0";
    _keyBalanceLabel.textColor = kWhiteColor;
    _keyBalanceLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(11)];
    _keyBalanceLabel.textAlignment = NSTextAlignmentCenter;
    _keyBalanceLabel.lineBreakMode = NSLineBreakByClipping;
    [_keyBarView addSubview:_keyBalanceLabel];
    [_keyBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_keyIcon.mas_trailing).offset(KDialogAdaptedWidth(2));
        make.trailing.mas_equalTo(_keyPlusButton.mas_leading).offset(-KDialogAdaptedWidth(2));
        make.centerY.mas_equalTo(_keyBarView);
    }];
    
    // Draw Buttons (Spread horizontal chain)
    _drawOneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawOneButton setBackgroundImage:[UIImage imageNamed:[self getThemeImageName:@"draw1"]] forState:UIControlStateNormal];
    [_drawOneButton addTarget:self action:@selector(drawOneClick) forControlEvents:UIControlEventTouchUpInside];
    _drawOneButton.adjustsImageWhenHighlighted = NO;
    [_actionContainer addSubview:_drawOneButton];
    
    _drawTenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawTenButton setBackgroundImage:[UIImage imageNamed:[self getThemeImageName:@"draw10"]] forState:UIControlStateNormal];
    [_drawTenButton addTarget:self action:@selector(drawTenClick) forControlEvents:UIControlEventTouchUpInside];
    _drawTenButton.adjustsImageWhenHighlighted = NO;
    [_actionContainer addSubview:_drawTenButton];
    
    _drawHundredButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawHundredButton setBackgroundImage:[UIImage imageNamed:[self getThemeImageName:@"draw100"]] forState:UIControlStateNormal];
    [_drawHundredButton addTarget:self action:@selector(drawHundredClick) forControlEvents:UIControlEventTouchUpInside];
    _drawHundredButton.adjustsImageWhenHighlighted = NO;
    [_actionContainer addSubview:_drawHundredButton];
    
    [_drawOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_diamondBarView.mas_bottom).offset(KDialogAdaptedWidth(25));
        make.leading.mas_equalTo(_actionContainer).offset(KDialogAdaptedWidth(13));
        make.height.mas_equalTo(_drawOneButton.mas_width).multipliedBy(104.0 / 200.0);
    }];
    
    [_drawTenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_drawOneButton);
        make.leading.mas_equalTo(_drawOneButton.mas_trailing).offset(KDialogAdaptedWidth(8));
        make.width.mas_equalTo(_drawOneButton);
        make.height.mas_equalTo(_drawOneButton);
    }];
    
    [_drawHundredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_drawOneButton);
        make.leading.mas_equalTo(_drawTenButton.mas_trailing).offset(KDialogAdaptedWidth(8));
        make.trailing.mas_equalTo(_actionContainer).offset(-KDialogAdaptedWidth(13));
        make.width.mas_equalTo(_drawOneButton);
        make.height.mas_equalTo(_drawOneButton);
    }];
    
    // Define equal width chain
    [_drawOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@[_drawTenButton, _drawHundredButton]);
    }];
}

#pragma mark - Network API Calls
- (void)loadData {
    __weak typeof(self) weakSelf = self;
    
    // 1. Load User balances
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
    
    // 2. Load lottery info/costs details
    [MLGameLotteryService getRoomDetailWithTypeId:self.typeId success:^(MLGameLotteryInfoModel *model) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf || !model) return;
        strongSelf.infoModel = model;
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 3. Load today's fortune (对应当前 typeId = 8:青玉, 9:碧海, 10:鎏金 各自独立运势)
    [MLGameLotteryService getFortuneLotteryListWithSuccess:^(NSArray<MLGameLotteryInfoModel *> *list) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf || !list) return;
        
        for (MLGameLotteryInfoModel *model in list) {
            BOOL isMatch = (model.typeId == strongSelf.typeId);
            if (!isMatch) {
                if (strongSelf.typeId == 8 && [model.name containsString:@"青玉"]) isMatch = YES;
                if (strongSelf.typeId == 9 && [model.name containsString:@"碧海"]) isMatch = YES;
                if (strongSelf.typeId == 10 && [model.name containsString:@"鎏金"]) isMatch = YES;
            }
            if (isMatch) {
                strongSelf.consumeValue = model.consume_diamonds;
                strongSelf.produceValue = model.produce_diamonds;
                break;
            }
        }
    } failure:nil];
    
    // 4. Load prize pool
    [MLGameLotteryService getPrizesWithTypeId:self.typeId success:^(NSArray<MLGameDrawResultModel *> *prizes) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.prizesInPool = prizes;
        }
    } failure:nil];
}

- (void)updateBalanceUI {
    NSString *keyStr = [NSString stringWithFormat:@"%ld", (long)_localKeyBalance];
    if (keyStr.length > 6) {
        keyStr = [NSString stringWithFormat:@"%@...", [keyStr substringToIndex:6]];
    }
    _keyBalanceLabel.text = keyStr;
}

#pragma mark - Button Actions

- (void)rankClick {
    [MLChatRoomThemeGameFourRankView showInView:self.superview typeId:self.typeId];
}

- (void)ruleClick {
    if (!self.infoModel) {
        [self loadData];
        return;
    }
    [MLChatRoomThemeGameFourRuleView showInView:self.superview ruleContent:self.infoModel.content]; // content field stores rules text returned by server
}

- (void)recordClick {
    [MLChatRoomThemeGameFourRecordView showInView:self.superview typeId:self.typeId];
}

- (void)giftPoolClick {
    if (self.isDrawing) return;
    NSInteger totalVal = 0;
    if (self.prizesInPool) {
        for (MLGameDrawResultModel *m in self.prizesInPool) {
            totalVal += m.price;
        }
    }
    [MLChatRoomThemeGameFourGiftView showInView:self.superview gifts:self.prizesInPool totalValue:totalVal];
}

- (void)fortuneClick {
    [MLChatRoomThemeGameFourFortuneView showInView:self.superview consume:self.consumeValue produce:self.produceValue];
}

- (void)diamondRechargeClick {
    UIViewController *curVC = [UIViewController currentViewController];
    if (curVC) {
        CFMWalletDiamondRechargeVc *re = [[CFMWalletDiamondRechargeVc alloc] init];
        __weak typeof(self) weakSelf = self;
        self.hidden = YES;
        re.dismissBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
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

- (void)keyPurchaseClick {
    if (!self.infoModel) {
        [self loadData];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [MLChatRoomThemeGameFourPurchaseView showInView:self.superview infoModel:self.infoModel purchaseSuccess:^(NSInteger newKeyBalance) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.localKeyBalance = newKeyBalance;
            [strongSelf updateBalanceUI];
        }
    }];
}

- (NSInteger)getCoinCostForCount:(NSInteger)count {
    if (self.infoModel && self.infoModel.coin_cost_opt.count > 0) {
        for (MLGameLotteryOptModel *opt in self.infoModel.coin_cost_opt) {
            if (opt.nums == count) {
                return opt.coin_cost;
            }
        }
    }
    return count; // 缺省默认：1次开销1把钥匙
}

- (void)drawOneClick {
    NSInteger cost = [self getCoinCostForCount:1];
    [self drawWithTimes:1 cost:cost];
}

- (void)drawTenClick {
    NSInteger cost = [self getCoinCostForCount:10];
    [self drawWithTimes:10 cost:cost];
}

- (void)drawHundredClick {
    NSInteger cost = [self getCoinCostForCount:100];
    [self drawWithTimes:100 cost:cost];
}

- (void)drawWithTimes:(NSInteger)times cost:(NSInteger)cost {
    if (self.isDrawing) return;
    
    // Verify key balance
    if (self.localKeyBalance < cost) {
        [self keyPurchaseClick];
        return;
    }
    
    self.isDrawing = YES;
    [self lockButtons:YES];
    
    // Optimistic local balance deduction
    NSInteger originalBalance = self.localKeyBalance;
    self.localKeyBalance -= cost;
    [self updateBalanceUI];
    
    // Reset pending flags & record startTime
    self.drawStartTime = CACurrentMediaTime();
    self.hasPendingDrawResult = NO;
    self.pendingResultList = nil;
    self.pendingTotalValue = 0;
    self.svgaCompletionBlock = nil;
    
    // 1. 【0ms 瞬间响应】点击 0ms 瞬间循环播放 SVGA 开启/蓄力动画，消灭等待停顿感
    if (self.svgaPlayer.videoItem) {
        self.svgaPlayer.alpha = 1.0;
        self.svgaPlayer.loops = 0; // 循环播放模式，等待网络 API 响应
        self.svgaPlayer.hidden = NO;
        [self.svgaPlayer startAnimation];
    }
    
    // 2. 并发发起网络抽奖 API
    __weak typeof(self) weakSelf = self;
    [MLGameLotteryService drawWithTypeId:self.typeId times:times success:^(NSArray<MLGameDrawResultModel *> *list, NSInteger totalValue, NSInteger logId) {
        // 3. 在 GCD 后台子线程解析与组装中奖数据模型
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                
                strongSelf.hasPendingDrawResult = YES;
                strongSelf.pendingResultList = list;
                strongSelf.pendingTotalValue = totalValue;
                
                void (^showResultBlock)(void) = ^{
                    [strongSelf lockButtons:NO];
                    strongSelf.isDrawing = NO;
                    [MLChatRoomThemeGameFourResultView showInView:strongSelf.superview gifts:strongSelf.pendingResultList totalValue:strongSelf.pendingTotalValue];
                    [strongSelf loadData];
                    strongSelf.pendingResultList = nil;
                    strongSelf.pendingTotalValue = 0;
                    strongSelf.hasPendingDrawResult = NO;
                };
                
                // 4. 引入与 Android 端一致的 minAnimationDuration (100抽: 600ms / 10抽: 1000ms / 1抽: 1500ms) 防闪烁保护
                if (strongSelf.svgaPlayer.videoItem && !strongSelf.svgaPlayer.hidden) {
                    CFTimeInterval elapsed = CACurrentMediaTime() - strongSelf.drawStartTime;
                    CFTimeInterval minDuration = (times >= 100) ? 0.6 : ((times >= 10) ? 1.0 : 1.5);
                    CFTimeInterval remaining = MAX(0.0, minDuration - elapsed);
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(remaining * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        // 保护时长到达后，启动 0.15s alpha 渐隐淡出无缝唤起结果弹窗
                        [UIView animateWithDuration:0.15 animations:^{
                            strongSelf.svgaPlayer.alpha = 0.0;
                        } completion:^(BOOL finished) {
                            [strongSelf.svgaPlayer stopAnimation];
                            strongSelf.svgaPlayer.hidden = YES;
                            strongSelf.svgaPlayer.alpha = 1.0;
                            showResultBlock();
                        }];
                    });
                } else {
                    // Fallback immediately if SVGA player was not active
                    showResultBlock();
                }
            });
        });
        
    } failure:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            if (strongSelf.svgaPlayer) {
                [strongSelf.svgaPlayer stopAnimation];
                strongSelf.svgaPlayer.hidden = YES;
                strongSelf.svgaPlayer.alpha = 1.0;
            }
            strongSelf.hasPendingDrawResult = NO;
            strongSelf.pendingResultList = nil;
            strongSelf.pendingTotalValue = 0;
            strongSelf.svgaCompletionBlock = nil;
            
            // Rollback optimistic deduction on error
            strongSelf.localKeyBalance = originalBalance;
            [strongSelf updateBalanceUI];
            strongSelf.isDrawing = NO;
            [strongSelf lockButtons:NO];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
}

- (void)lockButtons:(BOOL)lock {
    self.drawOneButton.enabled = !lock;
    self.drawTenButton.enabled = !lock;
    self.drawHundredButton.enabled = !lock;
    self.rankButton.enabled = !lock;
    self.ruleButton.enabled = !lock;
    self.recordButton.enabled = !lock;
    self.diamondPlusButton.enabled = !lock;
    self.keyPlusButton.enabled = !lock;
}

#pragma mark - SVGAPlayerDelegate
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    self.svgaPlayer.hidden = YES;
    [self.svgaPlayer stopAnimation];
    
    if (self.svgaCompletionBlock) {
        void (^block)(void) = self.svgaCompletionBlock;
        self.svgaCompletionBlock = nil;
        block();
    }
}

#pragma mark - Close animations
- (void)animateShow {
    self.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)handleMaskTap:(UITapGestureRecognizer *)sender {
    if (self.isDrawing) return; // Prevent closing in the middle of drawing
    [self dismiss];
}

- (void)dismiss {
    if (_svgaPlayer) {
        [_svgaPlayer stopAnimation];
        _svgaPlayer.hidden = YES;
    }
    _svgaCompletionBlock = nil;
    _pendingResultList = nil;
    _hasPendingDrawResult = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        // Restore voice floating bubble window
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.roomViewController && appDelegate.roomViewController.floatingWindow) {
            appDelegate.roomViewController.floatingWindow.hidden = NO;
        }
        [self removeFromSuperview];
    }];
}

- (void)dealloc {
    if (_svgaPlayer) {
        [_svgaPlayer stopAnimation];
        _svgaPlayer.hidden = YES;
    }
    _svgaCompletionBlock = nil;
}

@end
