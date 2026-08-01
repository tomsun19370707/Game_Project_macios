#import "MLChatRoomThemeGameSixView.h"
#import "MLChatRoomThemeGameSixRuleDialog.h"
#import "MLChatRoomThemeGameSixFusionDialog.h"
#import "MLChatRoomThemeGameSixPackDialog.h"
#import "MLChatRoomThemeGameSixResultDialog.h"
#import "MLChatRoomThemeGameSixRecordDialog.h"
#import "MLThemeGameModel.h"
#import "Global.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface MLChatRoomThemeGameSixView ()

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, assign) NSInteger currentLayer; // 当前选中的塔层 (1~7)

// 遮罩与主容器
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *backgroundContainer;

// 1. HUD 容器 (顶栏资产与控制)
@property (nonatomic, strong) UIView *hudContainer;
@property (nonatomic, strong) UIView *diamondBar;
@property (nonatomic, strong) UIImageView *diamondIcon;
@property (nonatomic, strong) UILabel *diamondLabel;

@property (nonatomic, strong) UIView *keyBar;
@property (nonatomic, strong) UIImageView *keyIcon;
@property (nonatomic, strong) UILabel *keyLabel;

@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *ruleButton;

// 2. Gameplay 容器 (7层塔与右侧导航)
@property (nonatomic, strong) UIView *gameplayContainer;

// 右侧 7 层导航
@property (nonatomic, strong) UIView *verticalNavView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *layerButtons;
@property (nonatomic, strong) UIImageView *towerLinkBar;
@property (nonatomic, strong) UIImageView *layerProgressFill;

// 7 层宝塔礼物矩阵
@property (nonatomic, strong) NSMutableArray<UIView *> *pagodaRows;

// 3. Action 容器 (底栏抽奖与决策)
@property (nonatomic, strong) UIView *actionContainer;
@property (nonatomic, strong) UIButton *giftPackButton;
@property (nonatomic, strong) UIButton *fusionButton;

@property (nonatomic, strong) UIImageView *drawPanelBg;
@property (nonatomic, strong) UIImageView *tokenIcon;
@property (nonatomic, strong) UIButton *recastButton;
// 留作后续联网功能扩展:
// @property (nonatomic, strong) UIButton *drawOneButton;
// @property (nonatomic, strong) UIButton *drawTenButton;

@end

@implementation MLChatRoomThemeGameSixView

+ (void)showInView:(UIView *)parentView typeId:(NSInteger)typeId {
    UIView *targetView = parentView;
    if (!targetView) {
        targetView = [UIApplication sharedApplication].keyWindow;
    }
    if (!targetView) {
        for (UIWindow *w in [UIApplication sharedApplication].windows) {
            if (w.isKeyWindow) {
                targetView = w;
                break;
            }
        }
    }
    if (!targetView) {
        targetView = [UIApplication sharedApplication].windows.firstObject;
    }
    if (!targetView) {
        return;
    }
    
    MLChatRoomThemeGameSixView *view = [[MLChatRoomThemeGameSixView alloc] initWithFrame:targetView.bounds];
    view.typeId = typeId;
    [targetView addSubview:view];
    [view animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _currentLayer = 1;
        _layerButtons = [NSMutableArray array];
        _pagodaRows = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

#pragma mark - UI Setup (CVCS 4 Semantic Containers)

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 0. Mask View
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _maskView.userInteractionEnabled = YES;
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tap];
    
    // 1. Background Container (底盘大背景)
    _backgroundContainer = [[UIView alloc] init];
    _backgroundContainer.userInteractionEnabled = YES;
    [self addSubview:_backgroundContainer];
    
    // 锁定 375pt 宽度与 750:1385 比例，底部对齐
    CGFloat panelWidth = KDialogAdaptedWidth(375);
    CGFloat panelHeight = panelWidth * (1385.0 / 750.0);
    
    [_backgroundContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(panelWidth, panelHeight));
    }];
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"theme_game_six_main_bg"];
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    [_backgroundContainer addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_backgroundContainer);
    }];
    
    // 搭建四大语义子容器
    [self setupHUDContainer];
    [self setupGameplayContainer];
    [self setupActionContainer];
    
    // 初始设置第 1 层默认状态，并立即发起 bootstrap 请求同步服务端权威的 current_layer 与门票数据
    [self selectLayer:1 animated:NO];
    [self loadBootstrapData];
}

#pragma mark - 1. HUD Container (顶栏资产与控制)

- (void)setupHUDContainer {
    _hudContainer = [[UIView alloc] init];
    [_backgroundContainer addSubview:_hudContainer];
    [_hudContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(42));
        make.leading.trailing.mas_equalTo(_backgroundContainer);
        make.height.mas_equalTo(KDialogAdaptedWidth(80));
    }];
    
    // 左上角 - 中奖记录 (再缩小10%至48pt)
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"theme_game_six_btn_record"] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
    [_hudContainer addSubview:_recordButton];
    [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(3));
        make.leading.mas_equalTo(KDialogAdaptedWidth(6));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(48), KDialogAdaptedWidth(48)));
    }];
    
    // 右上角 - 规则 (再缩小10%至48pt)
    _ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ruleButton setBackgroundImage:[UIImage imageNamed:@"theme_game_six_btn_rule"] forState:UIControlStateNormal];
    [_ruleButton addTarget:self action:@selector(ruleClick) forControlEvents:UIControlEventTouchUpInside];
    [_hudContainer addSubview:_ruleButton];
    [_ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(3));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(6));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(48), KDialogAdaptedWidth(48)));
    }];
    
    // 钻石资产条 (再次下降10pt至24pt)
    _diamondBar = [[UIView alloc] init];
    _diamondBar.backgroundColor = [UIColor clearColor];
    [_hudContainer addSubview:_diamondBar];
    [_diamondBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_recordButton.mas_bottom).offset(KDialogAdaptedWidth(24));
        make.leading.mas_equalTo(KDialogAdaptedWidth(8));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(74), KDialogAdaptedWidth(22)));
    }];
    
    UIImageView *diamondBarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme_game_six_resource_bar_bg"]];
    diamondBarBg.contentMode = UIViewContentModeScaleToFill;
    [_diamondBar addSubview:diamondBarBg];
    [diamondBarBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_diamondBar);
    }];
    
    _diamondIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme_game_six_ic_diamond"]];
    [_diamondBar addSubview:_diamondIcon];
    [_diamondIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_diamondBar);
        make.leading.mas_equalTo(KDialogAdaptedWidth(6));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(14), KDialogAdaptedWidth(14)));
    }];
    
    _diamondLabel = [[UILabel alloc] init];
    _diamondLabel.text = @"100";
    _diamondLabel.textColor = kWhiteColor;
    _diamondLabel.font = KFontBoldA(11);
    _diamondLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_diamondBar addSubview:_diamondLabel];
    [_diamondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_diamondBar);
        make.leading.mas_equalTo(_diamondIcon.mas_trailing).offset(KDialogAdaptedWidth(4));
        make.trailing.mas_equalTo(_diamondBar).offset(-KDialogAdaptedWidth(4));
    }];
    
    // 钥匙资产条
    _keyBar = [[UIView alloc] init];
    _keyBar.backgroundColor = [UIColor clearColor];
    [_hudContainer addSubview:_keyBar];
    [_keyBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_diamondBar.mas_bottom).offset(KDialogAdaptedWidth(4));
        make.leading.mas_equalTo(KDialogAdaptedWidth(8));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(74), KDialogAdaptedWidth(22)));
    }];
    
    UIImageView *keyBarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme_game_six_resource_bar_bg"]];
    keyBarBg.contentMode = UIViewContentModeScaleToFill;
    [_keyBar addSubview:keyBarBg];
    [keyBarBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_keyBar);
    }];
    
    _keyIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme_game_six_ic_key"]];
    [_keyBar addSubview:_keyIcon];
    [_keyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_keyBar);
        make.leading.mas_equalTo(KDialogAdaptedWidth(6));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(14), KDialogAdaptedWidth(14)));
    }];
    
    _keyLabel = [[UILabel alloc] init];
    _keyLabel.text = @"100";
    _keyLabel.textColor = kWhiteColor;
    _keyLabel.font = KFontBoldA(11);
    _keyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_keyBar addSubview:_keyLabel];
    [_keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_keyBar);
        make.leading.mas_equalTo(_keyIcon.mas_trailing).offset(KDialogAdaptedWidth(4));
        make.trailing.mas_equalTo(_keyBar).offset(-KDialogAdaptedWidth(4));
    }];
}

#pragma mark - 2. Gameplay Container (7层塔与右侧导航)

- (void)setupGameplayContainer {
    _gameplayContainer = [[UIView alloc] init];
    [_backgroundContainer addSubview:_gameplayContainer];
    [_gameplayContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_hudContainer.mas_bottom).offset(KDialogAdaptedWidth(10));
        make.leading.trailing.mas_equalTo(_backgroundContainer);
        make.height.mas_equalTo(KDialogAdaptedWidth(410));
    }];
    
    // 右侧 7 层导航 (高度缩短5%至266pt)
    _verticalNavView = [[UIView alloc] init];
    [_gameplayContainer addSubview:_verticalNavView];
    [_verticalNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(6));
        make.width.mas_equalTo(KDialogAdaptedWidth(44));
        make.height.mas_equalTo(KDialogAdaptedWidth(266));
    }];
    
    _towerLinkBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme_game_six_tower_link_bar"]];
    [_verticalNavView addSubview:_towerLinkBar];
    [_towerLinkBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_verticalNavView);
        make.top.bottom.mas_equalTo(_verticalNavView);
        make.width.mas_equalTo(KDialogAdaptedWidth(14));
    }];
    
    // 绿能量柱 (Center-to-Center 分段延伸层叠于脊柱之上)
    _layerProgressFill = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme_game_six_tower_link_bar_green"]];
    _layerProgressFill.contentMode = UIViewContentModeScaleToFill;
    [_verticalNavView addSubview:_layerProgressFill];
    
    // 7 层按钮从上到下：7层 down to 1层
    CGFloat btnHeight = KDialogAdaptedWidth(36);
    CGFloat gap = (KDialogAdaptedWidth(266) - 7 * btnHeight) / 6.0;
    
    for (NSInteger i = 7; i >= 1; i--) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *imgName = [NSString stringWithFormat:@"theme_game_six_layer_%ld", (long)i];
        [btn setImage:[UIImage imageNamed:@"theme_game_six_layer_green"] ? : [UIImage imageNamed:imgName] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(layerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_verticalNavView addSubview:btn];
        
        NSInteger indexFromTop = 7 - i;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_verticalNavView);
            make.top.mas_equalTo(indexFromTop * (btnHeight + gap));
            make.size.mas_equalTo(CGSizeMake(btnHeight, btnHeight));
        }];
        [_layerButtons addObject:btn];
    }
    
    // 7 层宝塔礼物矩阵 (从上到下 7层到1层，呈梯形宽度分布)
    CGFloat rowWidthPercents[] = {0.44, 0.47, 0.49, 0.50, 0.52, 0.53, 0.62};
    CGFloat rowTopOffsets[] = {-40, 35, 110, 188, 265, 342, 440};
    
    for (int r = 0; r < 7; r++) {
        UIView *rowView = [[UIView alloc] init];
        [_gameplayContainer addSubview:rowView];
        
        CGFloat currentWidthPercent = rowWidthPercents[r];
        CGFloat currentTopOffset = rowTopOffsets[r];
        CGFloat width = KDialogAdaptedWidth(375) * currentWidthPercent;
        
        [rowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_gameplayContainer);
            make.top.mas_equalTo(KDialogAdaptedWidth(currentTopOffset));
            make.size.mas_equalTo(CGSizeMake(width, KDialogAdaptedWidth(40)));
        }];
        
        // 每层 5 个礼物卡片 (第7层缩小至29.5pt，第1层40.6pt，第2层34.5pt，第3层34.25pt，第4层33.3pt，第5层32.4pt)
        CGFloat cardSizes[] = {29.5, 32.0, 32.4, 33.3, 34.25, 34.5, 40.6};
        CGFloat baseCardSize = cardSizes[r];
        CGFloat cardSize = KDialogAdaptedWidth(baseCardSize);
        CGFloat cardGap = (width - 5 * cardSize) / 4.0;
        
        for (int c = 0; c < 5; c++) {
            UIImageView *cardBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme_game_six_gift_card_bg"]];
            cardBg.contentMode = UIViewContentModeScaleAspectFit;
            [rowView addSubview:cardBg];
            [cardBg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(rowView);
                make.leading.mas_equalTo(c * (cardSize + cardGap));
                make.size.mas_equalTo(CGSizeMake(cardSize, cardSize));
            }];
        }
        
        [_pagodaRows addObject:rowView];
    }
}

#pragma mark - 3. Action Container (底栏抽奖与决策)

- (void)setupActionContainer {
    _actionContainer = [[UIView alloc] init];
    [_backgroundContainer addSubview:_actionContainer];
    [_actionContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_backgroundContainer).offset(-KDialogAdaptedWidth(10));
        make.leading.trailing.mas_equalTo(_backgroundContainer);
        make.height.mas_equalTo(KDialogAdaptedWidth(290));
    }];
    
    // 礼物包 (左侧 - 100% 精确恢复最初绝对高度位置)
    _giftPackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_giftPackButton setBackgroundImage:[UIImage imageNamed:@"theme_game_six_btn_gift_pack"] forState:UIControlStateNormal];
    [_giftPackButton addTarget:self action:@selector(giftPackClick) forControlEvents:UIControlEventTouchUpInside];
    [_actionContainer addSubview:_giftPackButton];
    [_giftPackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(6));
        make.top.mas_equalTo(_actionContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(79), KDialogAdaptedWidth(79)));
    }];
    
    // 主页融合 (右侧 - 100% 精确恢复最初绝对高度位置)
    _fusionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fusionButton setBackgroundImage:[UIImage imageNamed:@"theme_game_six_btn_fusion"] forState:UIControlStateNormal];
    [_fusionButton addTarget:self action:@selector(fusionClick) forControlEvents:UIControlEventTouchUpInside];
    [_actionContainer addSubview:_fusionButton];
    [_fusionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(6));
        make.top.mas_equalTo(_actionContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(79), KDialogAdaptedWidth(79)));
    }];
    
    // 底部抽奖底图面板 (高度扩大20%至96pt，长度310pt保持不变)
    _drawPanelBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme_game_six_draw_area_bg"]];
    _drawPanelBg.userInteractionEnabled = YES;
    [_actionContainer addSubview:_drawPanelBg];
    [_drawPanelBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_actionContainer).offset(-KDialogAdaptedWidth(4));
        make.centerX.mas_equalTo(_actionContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(310), KDialogAdaptedWidth(96)));
    }];
    
    // 令牌图标 (往右平移10pt至30pt)
    _tokenIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme_game_six_ic_token"]];
    _tokenIcon.contentMode = UIViewContentModeScaleToFill;
    [_drawPanelBg addSubview:_tokenIcon];
    [_tokenIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_drawPanelBg);
        make.leading.mas_equalTo(KDialogAdaptedWidth(30));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(44), KDialogAdaptedWidth(54)));
    }];
    
    // 重铸按钮 (解除原图留白封锁，使用 setBackgroundImage + ScaleToFill 提升至 72pt)
    _recastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recastButton setBackgroundImage:[UIImage imageNamed:@"theme_game_six_btn_recast"] forState:UIControlStateNormal];
    _recastButton.contentMode = UIViewContentModeScaleToFill;
    _recastButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [_recastButton addTarget:self action:@selector(recastClick) forControlEvents:UIControlEventTouchUpInside];
    [_drawPanelBg addSubview:_recastButton];
    [_recastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_drawPanelBg);
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(20));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(72), KDialogAdaptedWidth(72)));
    }];
}

#pragma mark - Layer Selection & Energy Animation (1:1 安卓复刻)

- (void)selectLayer:(NSInteger)layer animated:(BOOL)animated {
    self.currentLayer = layer;
    if (layer < 1) layer = 1;
    if (layer > 7) layer = 7;
    
    // 1. 刷新 7 个按钮高亮放大动画 (当前层 scale 1.15, 非当前层 alpha 0.5)
    for (UIButton *btn in _layerButtons) {
        BOOL isSelected = (btn.tag == layer);
        [UIView animateWithDuration:(animated ? 0.25 : 0.0) animations:^{
            btn.alpha = isSelected ? 1.0f : 0.5f;
            if (isSelected) {
                btn.transform = CGAffineTransformMakeScale(1.15, 1.15);
            } else {
                btn.transform = CGAffineTransformIdentity;
            }
        }];
    }
    
    // 2. 动态计算绿充能能量柱 (layerProgressFill) 顶端延伸位置
    CGFloat btnHeight = KDialogAdaptedWidth(36);
    CGFloat totalHeight = KDialogAdaptedWidth(266);
    CGFloat gap = (totalHeight - 7 * btnHeight) / 6.0;
    
    NSInteger indexFromTop = 7 - layer;
    CGFloat targetTop = indexFromTop * (btnHeight + gap) + KDialogAdaptedWidth(18);
    if (layer == 7) {
        targetTop = 0; // 7层拉伸至最顶部
    }
    
    [_layerProgressFill mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_verticalNavView);
        make.bottom.mas_equalTo(_verticalNavView);
        make.top.mas_equalTo(targetTop);
        make.width.mas_equalTo(KDialogAdaptedWidth(10));
    }];
    
    if (animated) {
        _layerProgressFill.alpha = 0.6f;
        [UIView animateWithDuration:0.3 animations:^{
            [self.verticalNavView layoutIfNeeded];
            self.layerProgressFill.alpha = 1.0f;
        }];
    } else {
        [self.verticalNavView layoutIfNeeded];
        _layerProgressFill.alpha = 1.0f;
    }
}

- (void)layerBtnClick:(UIButton *)btn {
    [self selectLayer:btn.tag animated:YES];
}

#pragma mark - User Actions

- (void)recordClick {
    [MLChatRoomThemeGameSixRecordDialog showInView:self];
}

- (void)ruleClick {
    [MLChatRoomThemeGameSixRuleDialog showInView:self];
}

- (void)giftPackClick {
    MLChatRoomThemeGameSixPackDialog *dialog = [MLChatRoomThemeGameSixPackDialog showInView:self];
    __weak typeof(self) weakSelf = self;
    dialog.onWithdrawSuccessBlock = ^{
        [weakSelf loadBootstrapData];
    };
}

- (void)fusionClick {
    MLChatRoomThemeGameSixFusionDialog *dialog = [MLChatRoomThemeGameSixFusionDialog showInView:self];
    __weak typeof(self) weakSelf = self;
    dialog.onFusionSuccessBlock = ^{
        [weakSelf loadBootstrapData];
    };
}

- (void)recastClick {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在重铸抽奖..."];
    [[MLThemeGameModel sharedInstance] fetchTowerGameSixBootstrapWithRoomId:nil success:^(id _Nullable responseObj) {
        NSInteger freshStateVersion = 0;
        if ([responseObj isKindOfClass:[MLTowerGameSixBootstrapModel class]]) {
            MLTowerGameSixBootstrapModel *bsModel = (MLTowerGameSixBootstrapModel *)responseObj;
            if (bsModel.player) {
                freshStateVersion = bsModel.player.state_version;
            }
        } else if ([responseObj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *playerDict = ((NSDictionary *)responseObj)[@"player"];
            if ([playerDict isKindOfClass:[NSDictionary class]] && playerDict[@"state_version"] != nil) {
                freshStateVersion = [playerDict[@"state_version"] integerValue];
            }
        }
        
        [[MLThemeGameModel sharedInstance] recastTowerGameSixWithStateVersion:freshStateVersion success:^(id _Nullable responseObj) {
            [SVProgressHUD dismiss];
            MLTowerGameSixRecastResultModel *resultModel = [MLTowerGameSixRecastResultModel mj_objectWithKeyValues:responseObj];
            
            MLChatRoomThemeGameSixResultDialog *resultDialog = [MLChatRoomThemeGameSixResultDialog showInView:weakSelf resultModel:resultModel];
            resultDialog.onContinueRecastBlock = ^{
                [weakSelf recastClick];
            };
            resultDialog.onWithdrawSuccessBlock = ^{
                [weakSelf loadBootstrapData];
            };
            
            // 重新请求主页数据以刷新当前层数与剩余重铸次数
            [weakSelf loadBootstrapData];
        } failure:^(NSError * _Nonnull error, NSString * _Nullable msg) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:msg ?: @"重铸失败"];
        }];
    } failure:^(NSError * _Nonnull error, NSString * _Nullable msg) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:msg ?: @"网络请求失败"];
    }];
}

- (void)loadBootstrapData {
    [[MLThemeGameModel sharedInstance] fetchTowerGameSixBootstrapWithRoomId:nil success:^(MLTowerGameSixBootstrapModel * _Nullable bsModel) {
        if (bsModel && bsModel.player) {
            NSInteger layer = bsModel.player.current_layer > 0 ? bsModel.player.current_layer : 1;
            [self selectLayer:layer animated:YES];
        }
        if (bsModel && bsModel.ticket) {
            self.keyLabel.text = [NSString stringWithFormat:@"%ld", (long)bsModel.ticket.remaining_recasts];
        }
    } failure:nil];
}

#pragma mark - Presentation & Dismissal

- (void)animateShow {
    self.alpha = 0.0;
    _backgroundContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
        self.backgroundContainer.transform = CGAffineTransformIdentity;
    }];
}

- (void)closeClick {
    [self dismiss];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.backgroundContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
