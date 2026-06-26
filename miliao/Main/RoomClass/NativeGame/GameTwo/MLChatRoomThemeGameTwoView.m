#import "MLChatRoomThemeGameTwoView.h"
#import "UIImageView+AspectFitGeometry.h"
#import "MLGameLotteryService.h"
#import "RoomFloatingWindow.h"
#import "AppDelegate.h"
#import "MLChatRoomThemeGameTwoResultView.h"
#import "MLChatRoomThemeGameTwoRuleView.h"
#import "MLChatRoomThemeGameTwoRecordView.h"
#import "MLChatRoomThemeGameTwoPurchaseView.h"
#import "Global.h"

#if __has_include(<SVGAPlayer/SVGAPlayer.h>)
#import <SVGAPlayer/SVGAPlayer.h>
#import <SVGAPlayer/SVGAParser.h>
#else
#import "SVGAPlayer.h"
#import "SVGAParser.h"
#endif

// 9个灵果的设计绝对位置常量矩阵 (基于 750 * 1311 设计稿)
static const CGPoint PEACH_COORDS[] = {
    {385.0f, 330.0f}, // 灵果 1
    {205.0f, 450.0f}, // 灵果 2
    {585.0f, 460.0f}, // 灵果 3
    {425.0f, 560.0f}, // 灵果 4
    {100.0f, 610.0f}, // 灵果 5
    {635.0f, 695.0f}, // 灵果 6
    {270.0f, 680.0f}, // 灵果 7
    {130.0f, 760.0f}, // 灵果 8
    {470.0f, 830.0f}  // 灵果 9
};

// 原始设计大小 (宽度 = 高度)
static const CGFloat PEACH_SIZES[] = {
    105.0f, 75.0f, 75.0f, 60.0f, 65.0f, 70.0f, 60.0f, 65.0f, 80.0f
};

// 渲染物理缩放系数
static const CGFloat PEACH_RENDER_SCALE_FACTOR = 0.6f;

@interface MLChatRoomThemeGameTwoView ()

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIButton *ruleButton;
@property (nonatomic, strong) UIButton *recordButton;

@property (nonatomic, strong) UILabel *keyBalanceLabel;
@property (nonatomic, strong) UILabel *diamondBalanceLabel;
@property (nonatomic, strong) UIButton *diamondPlusButton;

@property (nonatomic, strong) UIButton *drawOneButton;
@property (nonatomic, strong) UIButton *drawTenButton;
@property (nonatomic, strong) UIButton *drawHundredButton;

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
    
    // 背景大图 (AspectFit 填充防变形)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_two_clean_bg"];
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
    [_ruleButton setImage:[UIImage imageNamed:@"theme_game_two_rule_btn"] forState:UIControlStateNormal];
    [_ruleButton addTarget:self action:@selector(ruleClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_ruleButton];
    [_ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KAdaptedHeight(16));
        make.leading.mas_equalTo(KAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    // 记录按钮
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordButton setImage:[UIImage imageNamed:@"theme_game_two_record_btn"] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_recordButton];
    [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KAdaptedHeight(16));
        make.trailing.mas_equalTo(-KAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    // 初始化 9 个灵果的挂机 UIImageView
    for (int i = 0; i < 9; i++) {
        UIImageView *peachImg = [[UIImageView alloc] init];
        peachImg.contentMode = UIViewContentModeScaleAspectFit;
        [_bgImageView addSubview:peachImg];
        [self.peachImageViews addObject:peachImg];
    }
    
    // 底部祝灵按钮组 (品字形分布)
    _drawTenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawTenButton setImage:[UIImage imageNamed:@"theme_game_two_draw10_btn"] forState:UIControlStateNormal];
    [_drawTenButton addTarget:self action:@selector(drawTenClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_drawTenButton];
    [_drawTenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgImageView);
        make.bottom.mas_equalTo(-KAdaptedHeight(60));
        make.size.mas_equalTo(CGSizeMake(112, 56));
    }];
    
    _drawOneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawOneButton setImage:[UIImage imageNamed:@"theme_game_two_draw1_btn"] forState:UIControlStateNormal];
    [_drawOneButton addTarget:self action:@selector(drawOneClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_drawOneButton];
    [_drawOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(_drawTenButton.mas_leading).offset(-KAdaptedWidth(12));
        make.centerY.mas_equalTo(_drawTenButton);
        make.size.mas_equalTo(CGSizeMake(112, 56));
    }];
    
    _drawHundredButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawHundredButton setImage:[UIImage imageNamed:@"theme_game_two_draw100_btn"] forState:UIControlStateNormal];
    [_drawHundredButton addTarget:self action:@selector(drawHundredClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_drawHundredButton];
    [_drawHundredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_drawTenButton.mas_trailing).offset(KAdaptedWidth(12));
        make.centerY.mas_equalTo(_drawTenButton);
        make.size.mas_equalTo(CGSizeMake(112, 56));
    }];
    
    // 钥匙余额显示
    _keyBalanceLabel = [[UILabel alloc] init];
    _keyBalanceLabel.textColor = kWhiteColor;
    _keyBalanceLabel.font = KFontA(14);
    _keyBalanceLabel.text = @"钥匙: --";
    [_bgImageView addSubview:_keyBalanceLabel];
    [_keyBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgImageView);
        make.bottom.mas_equalTo(_drawTenButton.mas_top).offset(-KAdaptedHeight(15));
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 当布局计算完毕后，重新换算并定位大树上的 9 个灵果物理中心点
    for (int i = 0; i < 9; i++) {
        CGPoint designPoint = PEACH_COORDS[i];
        CGFloat rawSize = PEACH_SIZES[i];
        
        CGSize viewSize = self.bgImageView.bounds.size;
        CGFloat scale = MIN(viewSize.width / 750.0f, viewSize.height / 1311.0f);
        CGFloat targetSize = rawSize * scale * PEACH_RENDER_SCALE_FACTOR;
        
        CGPoint physicalCenter = [self.bgImageView ml_calculatePhysicalCenterWithDesignX:designPoint.x 
                                                                                designY:designPoint.y 
                                                                            designWidth:750.0f 
                                                                           designHeight:1311.0f];
        
        UIImageView *peachImg = self.peachImageViews[i];
        peachImg.bounds = CGRectMake(0, 0, targetSize, targetSize);
        peachImg.center = physicalCenter;
    }
}

#pragma mark - 数据拉取与图片绑定
- (void)loadData {
    // 1. 获取详情和价格/钥匙余额
    [MLGameLotteryService getRoomDetailWithTypeId:self.typeId success:^(MLGameLotteryInfoModel *model) {
        self.infoModel = model;
        self.localKeyBalance = model.lottery_coin;
        [self updateBalanceUI];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
    // 2. 获取 9 个灵果大奖的奖池配图
    [MLGameLotteryService getPrizesWithTypeId:self.typeId success:^(NSArray<MLGameDrawResultModel *> *list) {
        self.prizeList = list;
        [self renderPrizePeaches];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
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
    self.keyBalanceLabel.text = [NSString stringWithFormat:@"钥匙: %ld", (long)self.localKeyBalance];
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
    
    // 3. 启动假跑马灯/Loading 等待状态旋转 (玩法1特有，玩法2直接全屏遮挡或播放静止等待动画)
    
    // 4. 调用接口发包
    [MLGameLotteryService drawWithTypeId:self.typeId times:times success:^(NSArray<MLGameDrawResultModel *> *list, NSInteger totalValue, NSInteger logId) {
        // 请求成功：不回滚，起播全屏 SVGA 动画
        [self playDrawAnimationWithGifts:list totalValue:totalValue logId:logId];
    } failure:^(NSError *error) {
        [self lockButtons:NO];
        self.isDrawing = NO;
        
        // 5. 计费安全防御：若超时(NSURLErrorTimedOut)绝不回滚钥匙；若断网/报错，立刻把钥匙加回并重置UI
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
}

- (void)playDrawAnimationWithGifts:(NSArray<MLGameDrawResultModel *> *)gifts totalValue:(NSInteger)totalValue logId:(NSInteger)logId {
    // 此时起播 theme_game_two_draw.svga 特效，动效播放完后展示结果
    self.pendingGifts = gifts;
    self.pendingTotalValue = totalValue;
    
    if (self.svgaPlayer == nil) {
        self.svgaPlayer = [[SVGAPlayer alloc] initWithFrame:self.bounds];
        self.svgaPlayer.loops = 1;
        self.svgaPlayer.delegate = self;
        [self addSubview:self.svgaPlayer];
    }
    self.svgaPlayer.hidden = NO;
    
    SVGAParser *parser = [[SVGAParser alloc] init];
    NSURL *svgaURL = [[NSBundle mainBundle] URLForResource:@"theme_game_two_draw" withExtension:@"svga"];
    if (svgaURL) {
        WeakSelf
        [parser parseWithURL:svgaURL completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            wself.svgaPlayer.videoItem = videoItem;
            [wself.svgaPlayer startAnimation];
        } failureBlock:^(NSError * _Nonnull error) {
            // 解析失败时，兜底直接展示结果
            wself.svgaPlayer.hidden = YES;
            [wself showResultWithGifts:gifts totalValue:totalValue];
        }];
    } else {
        // 如果没有找到文件，兜底直接展示结果
        self.svgaPlayer.hidden = YES;
        [self showResultWithGifts:gifts totalValue:totalValue];
    }
}

#pragma mark - SVGAPlayerDelegate
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    player.hidden = YES;
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

- (void)openPurchaseDialog {
    WeakSelf
    [MLChatRoomThemeGameTwoPurchaseView showInView:self.superview infoModel:self.infoModel purchaseSuccess:^(NSInteger newKeyBalance) {
        wself.localKeyBalance = newKeyBalance;
        [wself updateBalanceUI];
    }];
}

- (void)handleMaskTap:(UITapGestureRecognizer *)sender {
    if (self.isDrawing) {
        return; // 拦截背景 Tap，不允许在动画/抽奖期间关闭
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
    
    // 恢复全局悬浮窗显示
    // 恢复全局最小化悬浮球
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.roomViewController && appDelegate.roomViewController.floatingWindow) {
        appDelegate.roomViewController.floatingWindow.hidden = NO;
    }
}

@end
