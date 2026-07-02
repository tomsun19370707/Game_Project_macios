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
@property (nonatomic, strong) MLChatRoomMarqueeLabel *marqueeLabel;
@property (nonatomic, strong) MASConstraint *marqueeHeightConstraint;

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
    
    // 背景大图 (占位使用玩法二背景)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_two_clean_bg"];
    if (_bgImageView.image == nil) {
        _bgImageView.backgroundColor = mHexRGB(0x0E1920); // 玩法三深沉太空背景兜底
    }
    _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(self);
    }];
    
    // 左上角返回/关闭按钮 (跨玩法复用切图)
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"theme_game_two_rule_back"] forState:UIControlStateNormal];
    if ([_backButton imageForState:UIControlStateNormal] == nil) {
        [_backButton setTitle:@"✕" forState:UIControlStateNormal];
        [_backButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    }
    [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KAdaptedHeight(16));
        make.leading.mas_equalTo(KAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    // 记录按钮 (距右边缘 16 pt, top 16)
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordButton setImage:[UIImage imageNamed:@"theme_game_two_record_btn"] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_recordButton];
    [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KAdaptedHeight(16));
        make.trailing.mas_equalTo(-KAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    // 规则按钮 (位于记录按钮左侧 10 pt)
    _ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ruleButton setImage:[UIImage imageNamed:@"theme_game_two_rule_btn"] forState:UIControlStateNormal];
    [_ruleButton addTarget:self action:@selector(ruleClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_ruleButton];
    [_ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KAdaptedHeight(16));
        make.trailing.mas_equalTo(_recordButton.mas_leading).offset(-KAdaptedWidth(10));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    // 今日运势悬浮条 (挂载规则左侧 10 pt)
    UIView *fortuneBar = [[UIView alloc] init];
    fortuneBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    setViewCorner(fortuneBar, 11.5);
    fortuneBar.userInteractionEnabled = YES;
    [_bgImageView addSubview:fortuneBar];
    [fortuneBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_recordButton);
        make.trailing.mas_equalTo(_ruleButton.mas_leading).offset(-KAdaptedWidth(10));
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
    
    // 18宫格转盘底框容器 (品字环形对称布局，宽 316, 高 324)
    UIView *cardsContainer = [[UIView alloc] init];
    cardsContainer.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:cardsContainer];
    [cardsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgImageView);
        make.centerY.mas_equalTo(_bgImageView).offset(-KAdaptedHeight(30));
        make.size.mas_equalTo(CGSizeMake(316, 324));
    }];
    
    [self layout18GiftCardsInContainer:cardsContainer];
    
    // 资产状态栏容器 (放在转盘与底部按钮之间)
    UIView *assetContainer = [[UIView alloc] init];
    assetContainer.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:assetContainer];
    [assetContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgImageView);
        make.top.mas_equalTo(cardsContainer.mas_bottom).offset(KAdaptedHeight(15));
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(30);
    }];
    
    // 钻石栏 (挂左)
    UIImageView *diaIcon = [[UIImageView alloc] init];
    diaIcon.image = [UIImage imageNamed:@"theme_game_one_cover_diamond"];
    [assetContainer addSubview:diaIcon];
    [diaIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.centerY.mas_equalTo(assetContainer);
        make.size.mas_equalTo(CGSizeMake(30, 30));
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
    
    // 钥匙余额栏 (挂右)
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
    keyIcon.image = [UIImage imageNamed:@"theme_game_one_purchase_key_icon"];
    [assetContainer addSubview:keyIcon];
    [keyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(_keyBalanceLabel.mas_leading).offset(-4);
        make.centerY.mas_equalTo(assetContainer);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    // 底部“品”字形启航按钮组 (跨玩法复用按钮资源)
    _drawTenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawTenButton setImage:[UIImage imageNamed:@"theme_game_one_draw_ten"] forState:UIControlStateNormal];
    [_drawTenButton addTarget:self action:@selector(drawTenClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_drawTenButton];
    [_drawTenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgImageView);
        make.bottom.mas_equalTo(-KAdaptedHeight(40));
        make.size.mas_equalTo(CGSizeMake(112, 56));
    }];
    
    _drawOneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawOneButton setImage:[UIImage imageNamed:@"theme_game_one_draw_one"] forState:UIControlStateNormal];
    [_drawOneButton addTarget:self action:@selector(drawOneClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_drawOneButton];
    [_drawOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(_drawTenButton.mas_leading).offset(-KAdaptedWidth(12));
        make.centerY.mas_equalTo(_drawTenButton);
        make.size.mas_equalTo(CGSizeMake(112, 56));
    }];
    
    _drawHundredButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawHundredButton setImage:[UIImage imageNamed:@"theme_game_one_draw_hundred"] forState:UIControlStateNormal];
    [_drawHundredButton addTarget:self action:@selector(drawHundredClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_drawHundredButton];
    [_drawHundredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_drawTenButton.mas_trailing).offset(KAdaptedWidth(12));
        make.centerY.mas_equalTo(_drawTenButton);
        make.size.mas_equalTo(CGSizeMake(112, 56));
    }];
    
    // 全服中奖轮播跑马灯 (水平居中, 距顶部返回按钮底部 10 pt. 高度默认为 0 隐蔽)
    _marqueeLabel = [[MLChatRoomMarqueeLabel alloc] init];
    _marqueeLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    setViewCorner(_marqueeLabel, 11);
    [_bgImageView addSubview:_marqueeLabel];
    
    WeakSelf
    [_marqueeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wself.backButton.mas_bottom).offset(10);
        make.leading.mas_equalTo(24);
        make.trailing.mas_equalTo(-24);
        wself.marqueeHeightConstraint = make.height.mas_equalTo(0);
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

#pragma mark - 18宫格对称环状排布逻辑 (6x5 对齐)
- (void)layout18GiftCardsInContainer:(UIView *)container {
    CGFloat cardW = 46.0f;
    CGFloat cardH = 60.0f;
    CGFloat hGap = 8.0f;
    CGFloat vGap = 6.0f;
    
    for (int i = 0; i < 18; i++) {
        UIView *card = [[UIView alloc] init];
        card.backgroundColor = [UIColor clearColor];
        [container addSubview:card];
        [self.giftCardViews addObject:card];
        
        // 格子背景
        UIImageView *cardBg = [[UIImageView alloc] init];
        NSString *bgName = [NSString stringWithFormat:@"theme_game_one_gift_board_%d", (i % 4) + 1];
        cardBg.image = [UIImage imageNamed:bgName];
        cardBg.contentMode = UIViewContentModeScaleToFill;
        [card addSubview:cardBg];
        [cardBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(card);
        }];
        
        // 呼吸选定光圈层 (Tag 999)
        UIView *overlay = [[UIView alloc] init];
        overlay.layer.borderColor = mHexRGB(0xFFE400).CGColor;
        overlay.layer.borderWidth = 2.0;
        overlay.backgroundColor = [UIColor colorWithRed:1 green:0.9 blue:0 alpha:0.25];
        overlay.hidden = YES;
        overlay.tag = 999;
        [card addSubview:overlay];
        [overlay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(card);
        }];
        
        UIImageView *giftImg = [[UIImageView alloc] init];
        giftImg.contentMode = UIViewContentModeScaleAspectFit;
        [card addSubview:giftImg];
        [giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(card).insets(UIEdgeInsetsMake(4, 4, 16, 4));
        }];
        [self.giftImageViews addObject:giftImg];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont boldSystemFontOfSize:9.5];
        nameLabel.textColor = kWhiteColor;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        setViewCorner(nameLabel, 2);
        [card addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.mas_equalTo(card);
            make.height.mas_equalTo(14);
        }];
        [self.giftNameLabels addObject:nameLabel];
        
        // 6x5 环状排布：
        if (i < 6) {
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.leading.mas_equalTo(i * (cardW + hGap));
                make.size.mas_equalTo(CGSizeMake(cardW, cardH));
            }];
        } else if (i < 9) {
            int row = i - 5;
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(row * (cardH + vGap));
                make.trailing.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(cardW, cardH));
            }];
        } else if (i < 15) {
            int col = 14 - i;
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(4 * (cardH + vGap));
                make.leading.mas_equalTo(col * (cardW + hGap));
                make.size.mas_equalTo(CGSizeMake(cardW, cardH));
            }];
        } else {
            int row = 18 - i;
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(row * (cardH + vGap));
                make.leading.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(cardW, cardH));
            }];
        }
    }
}

#pragma mark - 数据请求
- (void)loadData {
    WeakSelf
    // 1. 获取个人资产
    [MLGameLotteryService getUserMoneyWithSuccess:^(MLGameUserMoneyModel *moneyModel) {
        wself.diamondBalanceLabel.text = moneyModel.diamond;
        wself.localKeyBalance = moneyModel.lottery_coin;
        [wself updateBalanceUI];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 2. 详情、价格
    [MLGameLotteryService getRoomDetailWithTypeId:self.typeId success:^(MLGameLotteryInfoModel *model) {
        wself.infoModel = model;
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 3. 18 格大奖列表
    [MLGameLotteryService getPrizesWithTypeId:self.typeId success:^(NSArray<MLGameDrawResultModel *> *list) {
        wself.prizesInPool = list;
        [wself renderGiftBoard];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 4. 今日运势 (星辰序章 typeId == 5 / lottery_id == 3)
    [MLGameLotteryService getFortuneLotteryListWithSuccess:^(NSArray<MLGameLotteryInfoModel *> *list) {
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
    
    // 5. 中奖广播跑马灯
    [MLGameLotteryService getLotteryWinLogWithTypeId:self.typeId page:1 pageSize:20 success:^(NSArray *list, NSInteger total) {
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
                NSString *fullText = [NSString stringWithFormat:@"恭喜 %@ 在星辰序章获得 %@", nickname, giftName];
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
        [wself.marqueeLabel stopScroll];
        [wself updateMarqueeHeight:0];
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
    NSInteger totalSteps = minRounds * 18 + targetIndex;
    
    // 清理光圈
    for (UIView *card in self.giftCardViews) {
        [card viewWithTag:999].hidden = YES;
    }
    
    NSInteger currentIndex = currentStep % 18;
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
    _backButton.enabled = !lock;
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
        re.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        WeakSelf
        re.dismissBlock = ^{
            [wself loadData];
        };
        [curVC presentViewController:re animated:NO completion:nil];
    }
}

- (void)backClick {
    if (self.isDrawing) return;
    [self dismiss];
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
