#import "MLChatRoomThemeGameOneView.h"
#import "MLGameLotteryService.h"
#import "RoomFloatingWindow.h"
#import "AppDelegate.h"
#import "MLChatRoomThemeGameOneResultView.h"
#import "MLChatRoomThemeGameOneRuleView.h"
#import "MLChatRoomThemeGameOneRecordView.h"
#import "MLChatRoomThemeGameOnePurchaseView.h"
#import "MLChatRoomThemeGameOneExchangeView.h"
#import "Global.h"

#if __has_include(<SVGAPlayer/SVGAPlayer.h>)
#import <SVGAPlayer/SVGAPlayer.h>
#import <SVGAPlayer/SVGAParser.h>
#else
#import "SVGAPlayer.h"
#import "SVGAParser.h"
#endif

@interface MLChatRoomThemeGameOneView ()

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *ruleButton;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIButton *exchangeButton;
@property (nonatomic, strong) NSTimer *rotationTimer;

@property (nonatomic, strong) UILabel *keyBalanceLabel;
@property (nonatomic, strong) UILabel *luckyTextLabel;
@property (nonatomic, strong) UIProgressView *luckyProgressBar;

@property (nonatomic, strong) UIButton *drawOneButton;
@property (nonatomic, strong) UIButton *drawTenButton;
@property (nonatomic, strong) UIButton *drawHundredButton;

// 18个格子的卡片 View
@property (nonatomic, strong) NSMutableArray<UIView *> *giftCardViews;
// 18个格子上的奖品图
@property (nonatomic, strong) NSMutableArray<UIImageView *> *giftImageViews;

@property (nonatomic, strong) MLGameLotteryInfoModel *infoModel;
@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *prizesInPool;

@property (nonatomic, assign) BOOL isDrawing;
@property (nonatomic, assign) NSInteger localKeyBalance;
@property (nonatomic, assign) NSInteger currentStartIndex;
@property (nonatomic, assign) NSInteger lastDrawTimes;
@property (nonatomic, assign) NSInteger lastDrawCost;

// 跑马灯计时器
@property (nonatomic, assign) NSInteger targetStopIndex;

// SVGA 播放与暂存
@property (nonatomic, strong) SVGAPlayer *svgaPlayer;
@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *pendingGifts;
@property (nonatomic, assign) NSInteger pendingTotalValue;

@end

@interface MLChatRoomThemeGameOneView () <SVGAPlayerDelegate>
@end

@implementation MLChatRoomThemeGameOneView

+ (void)showInView:(UIView *)parentView typeId:(NSInteger)typeId {
    MLChatRoomThemeGameOneView *gameView = [[MLChatRoomThemeGameOneView alloc] initWithFrame:parentView.bounds typeId:typeId];
    [parentView addSubview:gameView];
    [gameView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame typeId:(NSInteger)typeId {
    if (self = [super initWithFrame:frame]) {
        self.typeId = typeId;
        self.isDrawing = NO;
        self.currentStartIndex = 0;
        self.giftCardViews = [NSMutableArray array];
        self.giftImageViews = [NSMutableArray array];
        
        [self setupUI];
        [self loadData];
        
        // 隐藏常驻最顶层的语音悬浮球
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
    
    // 背景大图
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_one_clean_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(self);
    }];
    
    // 规则按钮
    _ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ruleButton setImage:[UIImage imageNamed:@"theme_game_one_rule_back"] forState:UIControlStateNormal];
    [_ruleButton addTarget:self action:@selector(ruleClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_ruleButton];
    [_ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KAdaptedHeight(16));
        make.leading.mas_equalTo(KAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    // 记录按钮
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordButton setImage:[UIImage imageNamed:@"theme_game_one_record_back"] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_recordButton];
    [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KAdaptedHeight(16));
        make.trailing.mas_equalTo(-KAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    // 刷新奖池按钮
    _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_refreshButton setImage:[UIImage imageNamed:@"theme_game_one_refresh_btn"] forState:UIControlStateNormal];
    [_refreshButton addTarget:self action:@selector(refreshPoolClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_refreshButton];
    [_refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_ruleButton.mas_bottom).offset(KAdaptedHeight(10));
        make.leading.mas_equalTo(KAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    // 兑换按钮
    _exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_exchangeButton setImage:[UIImage imageNamed:@"theme_game_one_exchange_btn"] forState:UIControlStateNormal];
    [_exchangeButton addTarget:self action:@selector(exchangeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_exchangeButton];
    [_exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_refreshButton.mas_bottom).offset(KAdaptedHeight(10));
        make.leading.mas_equalTo(KAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    // 18 宫格礼物卡片环形布局容器
    UIView *cardsContainer = [[UIView alloc] init];
    [_bgImageView addSubview:cardsContainer];
    [cardsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgImageView);
        make.top.mas_equalTo(KAdaptedHeight(180));
        make.size.mas_equalTo(CGSizeMake(316, 260)); // 包含 6*4 环状的总边界
    }];
    
    [self layout18GiftCardsInContainer:cardsContainer];
    
    // 底部寻梦值进度条
    _luckyProgressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _luckyProgressBar.progressTintColor = mHexRGB(0x00A2FF); // 蓝色进度条
    _luckyProgressBar.trackTintColor = [UIColor colorWithWhite:1 alpha:0.3];
    _luckyProgressBar.progress = 0.0;
    [_bgImageView addSubview:_luckyProgressBar];
    [_luckyProgressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgImageView);
        make.bottom.mas_equalTo(-KAdaptedHeight(140));
        make.width.mas_equalTo(KAdaptedWidth(220));
        make.height.mas_equalTo(8);
    }];
    
    _luckyTextLabel = [[UILabel alloc] init];
    _luckyTextLabel.textColor = kWhiteColor;
    _luckyTextLabel.font = KFontA(12);
    _luckyTextLabel.text = @"寻梦值: 0/200";
    [_bgImageView addSubview:_luckyTextLabel];
    [_luckyTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_luckyProgressBar);
        make.leading.mas_equalTo(_luckyProgressBar.mas_trailing).offset(6);
    }];
    
    // 钥匙余额显示
    _keyBalanceLabel = [[UILabel alloc] init];
    _keyBalanceLabel.textColor = kWhiteColor;
    _keyBalanceLabel.font = KFontA(14);
    _keyBalanceLabel.text = @"钥匙: --";
    [_bgImageView addSubview:_keyBalanceLabel];
    [_keyBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgImageView);
        make.bottom.mas_equalTo(_luckyProgressBar.mas_top).offset(-KAdaptedHeight(15));
    }];
    
    // 底部“品”字形抽奖按钮组
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
}

#pragma mark - 18宫格扁平环状排布逻辑 (高还原度)
- (void)layout18GiftCardsInContainer:(UIView *)container {
    // 宽 46，高 60。水平间距 8，垂直间距 6
    // 顶部横排 6 个 (索引 0~5)
    // 右侧竖排 2 个 (索引 6~7)
    // 底部横排 6 个 (索引 8~13)
    // 左侧竖排 2 个 (索引 14~17)
    CGFloat cardW = 46.0f;
    CGFloat cardH = 60.0f;
    CGFloat hGap = 8.0f;
    CGFloat vGap = 6.0f;
    
    for (int i = 0; i < 18; i++) {
        UIView *card = [[UIView alloc] init];
        card.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1]; // 默认底色
        setViewCorner(card, 4);
        [container addSubview:card];
        [self.giftCardViews addObject:card];
        
        UIImageView *giftImg = [[UIImageView alloc] init];
        giftImg.contentMode = UIViewContentModeScaleAspectFit;
        [card addSubview:giftImg];
        [giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(card).insets(UIEdgeInsetsMake(4, 4, 4, 4));
        }];
        [self.giftImageViews addObject:giftImg];
        
        // 分段设置约束
        if (i < 6) {
            // 顶部横排 (0 ~ 5)
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.leading.mas_equalTo(i * (cardW + hGap));
                make.size.mas_equalTo(CGSizeMake(cardW, cardH));
            }];
        } else if (i < 8) {
            // 右侧竖排 (6 ~ 7)
            int step = i - 5; // 1, 2
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(step * (cardH + vGap));
                make.trailing.mas_equalTo(0); // 对齐右边缘
                make.size.mas_equalTo(CGSizeMake(cardW, cardH));
            }];
        } else if (i < 14) {
            // 底部横排 (8 ~ 13)
            int step = 13 - i; // 5 ~ 0 逆序，使顺时针成环
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
                make.leading.mas_equalTo(step * (cardW + hGap));
                make.size.mas_equalTo(CGSizeMake(cardW, cardH));
            }];
        } else {
            // 左侧竖排 (14 ~ 17)
            int step = 17 - i; // 3 ~ 0 逆序，顺时针闭合
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo((step + 1) * (cardH + vGap));
                make.leading.mas_equalTo(0); // 对齐左边缘
                make.size.mas_equalTo(CGSizeMake(cardW, cardH));
            }];
        }
    }
}

#pragma mark - 数据请求
- (void)loadData {
    // 1. 详情、消耗档位和钥匙余额
    [MLGameLotteryService getRoomDetailWithTypeId:self.typeId success:^(MLGameLotteryInfoModel *model) {
        self.infoModel = model;
        self.localKeyBalance = model.lottery_coin;
        [self updateBalanceUI];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 2. 18 格奖池礼物列表
    [MLGameLotteryService getPrizesWithTypeId:self.typeId success:^(NSArray<MLGameDrawResultModel *> *list) {
        self.prizesInPool = list;
        [self renderGiftBoard];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)renderGiftBoard {
    if (self.prizesInPool.count == 0) return;
    
    for (int i = 0; i < self.giftImageViews.count; i++) {
        UIImageView *img = self.giftImageViews[i];
        if (i < self.prizesInPool.count) {
            MLGameDrawResultModel *prize = self.prizesInPool[i];
            NSURL *url = [NSURL URLWithString:[prize imageUrl]];
            if ([img respondsToSelector:@selector(setImageWithURL:placeholder:)]) {
                [img performSelector:@selector(setImageWithURL:placeholder:) withObject:url withObject:[UIImage imageNamed:@""]];
            } else if ([img respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
                [img performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
            }
            img.hidden = NO;
        } else {
            img.hidden = YES;
        }
    }
}

- (void)updateBalanceUI {
    self.keyBalanceLabel.text = [NSString stringWithFormat:@"钥匙: %ld", (long)self.localKeyBalance];
}

#pragma mark - 抽奖与跑马灯动画算法 (带减速步进)
- (void)drawWithTimes:(NSInteger)times cost:(NSInteger)cost {
    if (self.localKeyBalance < cost) {
        [SVProgressHUD showErrorWithStatus:@"钥匙不足，请先购买"];
        [self openPurchaseDialog];
        return;
    }
    
    self.isDrawing = YES;
    [self lockButtons:YES];
    
    // 1. 乐观扣减
    self.localKeyBalance -= cost;
    [self updateBalanceUI];
    self.lastDrawTimes = times;
    self.lastDrawCost = cost;
    
    // 2. 立即启动无限匀速跑马灯 (Loading 态)
    [self startInfiniteRotation];
    
    // 3. 执行网络发包
    [MLGameLotteryService drawWithTypeId:self.typeId times:times success:^(NSArray<MLGameDrawResultModel *> *list, NSInteger totalValue, NSInteger logId) {
        // 请求成功：定位最高价礼物的终点落点
        NSInteger targetIndex = [self findTargetStopIndexWithGifts:list];
        self.targetStopIndex = targetIndex;
        
        // 4. 接续进入插值减速旋转
        [self stopInfiniteRotation];
        [self transitionToDeceleratingRotationWithTargetIndex:targetIndex success:^{
            [self showResultWithGifts:list totalValue:totalValue logId:logId];
        }];
    } failure:^(NSError *error) {
        [self stopInfiniteRotation];
        [self lockButtons:NO];
        self.isDrawing = NO;
        
        // 5. 计费回滚防御
        if (error.code == NSURLErrorTimedOut) {
            [SVProgressHUD showInfoWithStatus:@"服务器繁忙，结果可能稍后到账，请去记录或背包查看"];
        } else {
            self.localKeyBalance += cost;
            [self updateBalanceUI];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
}

- (void)lockButtons:(BOOL)lock {
    self.drawOneButton.enabled = !lock;
    self.drawTenButton.enabled = !lock;
    self.drawHundredButton.enabled = !lock;
    self.refreshButton.enabled = !lock;
    self.exchangeButton.enabled = !lock;
}

#pragma mark - 寻找最高价值礼物索引
- (NSInteger)findTargetStopIndexWithGifts:(NSArray<MLGameDrawResultModel *> *)gifts {
    if (gifts.count == 0) return 0;
    
    // 1. 检索出 price 最大的礼物实体
    MLGameDrawResultModel *grandPrize = gifts.firstObject;
    for (MLGameDrawResultModel *item in gifts) {
        if (item.price > grandPrize.price) {
            grandPrize = item;
        }
    }
    
    // 2. 匹配在 18格奖池中对应的索引
    for (int i = 0; i < self.prizesInPool.count; i++) {
        MLGameDrawResultModel *poolItem = self.prizesInPool[i];
        if (poolItem.giftId == grandPrize.giftId) {
            return i;
        }
    }
    return 0;
}

#pragma mark - 跑马灯旋转驱动
- (void)startInfiniteRotation {
    [self stopInfiniteRotation];
    self.rotationTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(infiniteRotationStep) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.rotationTimer forMode:NSRunLoopCommonModes];
}

- (void)stopInfiniteRotation {
    if (self.rotationTimer) {
        [self.rotationTimer invalidate];
        self.rotationTimer = nil;
    }
}

- (void)infiniteRotationStep {
    NSInteger nextIdx = (self.currentStartIndex + 1) % 18;
    [self highlightGiftViewAtIndex:nextIdx];
}

- (void)transitionToDeceleratingRotationWithTargetIndex:(NSInteger)targetIndex success:(void(^)(void))completion {
    // 根据当前所在索引，计算出剩余总步数（再跑 2 圈 + 偏移目标）
    NSInteger currentIdx = self.currentStartIndex;
    NSInteger remainingSteps = (targetIndex - currentIdx + 18) % 18 + 36; // 跑 2 圈
    
    [self startDeceleratingStepWithStepIndex:0 
                               totalSteps:remainingSteps 
                             minDelayTime:0.08 
                             maxDelayTime:0.5 
                               completion:completion];
}

- (void)startDeceleratingStepWithStepIndex:(NSInteger)step 
                               totalSteps:(NSInteger)totalSteps 
                             minDelayTime:(NSTimeInterval)minDelay 
                             maxDelayTime:(NSTimeInterval)maxDelay 
                               completion:(void(^)(void))completion {
    if (step >= totalSteps) {
        if (completion) completion();
        return;
    }
    
    NSInteger highlightIndex = (self.currentStartIndex + step) % 18;
    [self highlightGiftViewAtIndex:highlightIndex];
    
    NSTimeInterval nextDelay = minDelay;
    NSInteger decayStartStep = totalSteps - 10; // 倒数 10 步开始指数减速
    if (step >= decayStartStep) {
        NSInteger progress = step - decayStartStep;
        nextDelay = minDelay + (maxDelay - minDelay) * pow((double)progress / 10.0, 2.0);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(nextDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startDeceleratingStepWithStepIndex:step + 1 
                                     totalSteps:totalSteps 
                                   minDelayTime:minDelay 
                                   maxDelayTime:maxDelay 
                                     completion:completion];
    });
}

- (void)highlightGiftViewAtIndex:(NSInteger)index {
    // 还原之前的卡片状态，并高亮当前的卡片 (发光、改变背景色或缩放)
    for (int i = 0; i < self.giftCardViews.count; i++) {
        UIView *card = self.giftCardViews[i];
        if (i == index) {
            card.backgroundColor = mHexRGB(0x00A2FF); // 高亮蓝色
            card.transform = CGAffineTransformMakeScale(1.08, 1.08);
        } else {
            card.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
            card.transform = CGAffineTransformIdentity;
        }
    }
    self.currentStartIndex = index;
}

- (void)showResultWithGifts:(NSArray<MLGameDrawResultModel *> *)gifts totalValue:(NSInteger)totalValue logId:(NSInteger)logId {
    self.pendingGifts = gifts;
    self.pendingTotalValue = totalValue;
    
    [self lockButtons:NO];
    self.isDrawing = NO;
    
    if (self.svgaPlayer == nil) {
        self.svgaPlayer = [[SVGAPlayer alloc] initWithFrame:self.bounds];
        self.svgaPlayer.loops = 1;
        self.svgaPlayer.delegate = self;
        [self addSubview:self.svgaPlayer];
    }
    self.svgaPlayer.hidden = NO;
    
    SVGAParser *parser = [[SVGAParser alloc] init];
    NSURL *svgaURL = [[NSBundle mainBundle] URLForResource:@"theme_game_one_draw" withExtension:@"svga"];
    if (svgaURL) {
        WeakSelf
        [parser parseWithURL:svgaURL completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            wself.svgaPlayer.videoItem = videoItem;
            [wself.svgaPlayer startAnimation];
        } failureBlock:^(NSError * _Nonnull error) {
            wself.svgaPlayer.hidden = YES;
            [wself realShowResult];
        }];
    } else {
        self.svgaPlayer.hidden = YES;
        [self realShowResult];
    }
    
    [self loadData];
}

- (void)realShowResult {
    WeakSelf
    [MLChatRoomThemeGameOneResultView showInView:self.superview 
                                           gifts:self.pendingGifts 
                                      totalValue:self.pendingTotalValue 
                                      retryBlock:^{
        [wself drawWithTimes:wself.lastDrawTimes cost:wself.lastDrawCost];
    }];
}

#pragma mark - SVGAPlayerDelegate
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    player.hidden = YES;
    [self realShowResult];
}

#pragma mark - 点击事件
- (void)drawOneClick {
    [self drawWithTimes:1 cost:200];
}

- (void)drawTenClick {
    [self drawWithTimes:10 cost:2000];
}

- (void)drawHundredClick {
    [self drawWithTimes:100 cost:20000];
}

- (void)refreshPoolClick {
    self.refreshButton.enabled = NO;
    [MLGameLotteryService refreshPoolWithTypeId:self.typeId success:^(NSArray<MLGameDrawResultModel *> *list, NSInteger diamondCost, NSString *newDiamondBalance) {
        self.refreshButton.enabled = YES;
        self.prizesInPool = list;
        [self renderGiftBoard];
        [SVProgressHUD showSuccessWithStatus:@"已更新奖池"];
    } failure:^(NSError *error) {
        self.refreshButton.enabled = YES;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)ruleClick {
    [MLChatRoomThemeGameOneRuleView showInView:self.superview];
}

- (void)recordClick {
    [MLChatRoomThemeGameOneRecordView showInView:self.superview typeId:self.typeId];
}

- (void)exchangeClick {
    [MLChatRoomThemeGameOneExchangeView showInView:self.superview typeId:self.typeId];
}

- (void)openPurchaseDialog {
    WeakSelf
    [MLChatRoomThemeGameOnePurchaseView showInView:self.superview infoModel:self.infoModel purchaseSuccess:^(NSInteger newKeyBalance) {
        wself.localKeyBalance = newKeyBalance;
        [wself updateBalanceUI];
    }];
}

- (void)handleMaskTap:(UITapGestureRecognizer *)sender {
    if (self.isDrawing) {
        return; // 抽奖期间屏蔽 Dismiss 蒙层点击
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
    
    // 恢复全局最小化悬浮球
    // 恢复全局最小化悬浮球
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.roomViewController && appDelegate.roomViewController.floatingWindow) {
        appDelegate.roomViewController.floatingWindow.hidden = NO;
    }
}

@end
