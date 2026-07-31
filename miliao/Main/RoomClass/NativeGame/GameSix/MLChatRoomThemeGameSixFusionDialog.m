//
//  MLChatRoomThemeGameSixFusionDialog.m
//  miliao
//
//  Created for Game 6 (玲珑珍宝塔) 门票融合说明与合成弹窗.
//

#import "MLChatRoomThemeGameSixFusionDialog.h"
#import "MLGlobalGiftSelectorPicker.h"
#import "MLThemeGameModel.h"
#import "Global.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface MLChatRoomThemeGameSixFusionDialog ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *boardContainer;
@property (nonatomic, strong) UIImageView *boardBgImageView;

// 1. 顶部 3 配方槽位区
@property (nonatomic, strong) UIView *topSlotsContainer;
@property (nonatomic, strong) NSMutableArray<UIButton *> *slotButtons;
@property (nonatomic, strong) UILabel *tvFusionThresholdTop;
@property (nonatomic, strong) UILabel *tvFusionSelectedBottom;

// 2. 中间融合动作按钮
@property (nonatomic, strong) UIButton *fusionActionButton;

// 3. 底部背包待选面板区
@property (nonatomic, strong) UIView *bottomPackPanelContainer;
@property (nonatomic, strong) UIImageView *packPanelBgImageView;
@property (nonatomic, strong) UIButton *prevButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) NSMutableArray<UIButton *> *itemButtons;

// 4. 真实 UI 节点引用数组
@property (nonatomic, strong) NSMutableArray<UIImageView *> *slotImageViews;
@property (nonatomic, strong) NSMutableArray<UILabel *> *slotNameLabels;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *tempImageViews;

// 5. 真实数据源模型
@property (nonatomic, strong) MLTowerGameSixFusionCandidateModel *candidateModel;
@property (nonatomic, strong) NSMutableArray<MLCandidateItemModel *> *selectedGlobalSlots;
@property (nonatomic, strong) NSMutableSet<MLCandidateItemModel *> *selectedTempSet;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *checkMarkImageViews;
@property (nonatomic, assign) NSInteger tempPageIndex;

@end

@implementation MLChatRoomThemeGameSixFusionDialog

+ (instancetype)showInView:(nullable UIView *)parentView {
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
        return nil;
    }
    
    MLChatRoomThemeGameSixFusionDialog *dialog = [[MLChatRoomThemeGameSixFusionDialog alloc] initWithFrame:targetView.bounds];
    [targetView addSubview:dialog];
    [dialog animateShow];
    return dialog;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _slotButtons = [NSMutableArray array];
        _itemButtons = [NSMutableArray array];
        _slotImageViews = [NSMutableArray array];
        _slotNameLabels = [NSMutableArray array];
        _tempImageViews = [NSMutableArray array];
        _checkMarkImageViews = [NSMutableArray array];
        _selectedTempSet = [NSMutableSet set];
        _selectedGlobalSlots = [NSMutableArray arrayWithObjects:[NSNull null], [NSNull null], [NSNull null], nil];
        [self setupUI];
        [self loadCandidatesData];
    }
    return self;
}

- (void)loadCandidatesData {
    [SVProgressHUD show];
    [[MLThemeGameModel sharedInstance] fetchTowerGameSixFusionCandidatesWithSuccess:^(MLTowerGameSixFusionCandidateModel * _Nullable model) {
        [SVProgressHUD dismiss];
        if (model) {
            self.candidateModel = model;
            [self refreshDataUI];
        }
    } failure:^(NSError * _Nonnull error, NSString * _Nullable msg) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:msg ?: @"未登录或网络异常，已展示试用面板"];
    }];
}

- (void)refreshDataUI {
    if (!self.candidateModel) return;
    
    if (_candidateModel.threshold_value) {
        _tvFusionThresholdTop.text = [NSString stringWithFormat:@"融合门槛: 💎 %@", _candidateModel.threshold_value];
    }
    
    // 1. 动态连线 3 个槽位选中的礼物
    double totalVal = 0.0;
    for (int i = 0; i < 3; i++) {
        UIImageView *iconIV = _slotImageViews[i];
        UILabel *nameLb = _slotNameLabels[i];
        id slotObj = self.selectedGlobalSlots[i];
        
        if ([slotObj isKindOfClass:[MLCandidateItemModel class]]) {
            MLCandidateItemModel *item = (MLCandidateItemModel *)slotObj;
            nameLb.text = item.name ?: @"未选择";
            if (item.unit_value) {
                totalVal += [item.unit_value doubleValue];
            }
            if (item.image && item.image.length > 0) {
                [iconIV sd_setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:[UIImage imageNamed:@"theme_game_six_btn_gift_pack"]];
            }
        } else {
            nameLb.text = @"待选择";
            iconIV.image = nil;
        }
    }
    
    // 1.1 加上选中的暂存包礼物价值
    for (MLCandidateItemModel *tItem in self.selectedTempSet) {
        if (tItem.unit_value) {
            totalVal += [tItem.unit_value doubleValue];
        }
    }
    
    // 2. 实时刷新底部选中总价值提示 (100% 服务端接口权威驱动)
    double threshold = [_candidateModel.threshold_value doubleValue];
    if (threshold > 0 && totalVal >= threshold) {
        _tvFusionSelectedBottom.text = [NSString stringWithFormat:@"当前选中: 💎 %.2f (已达标)", totalVal];
        _tvFusionSelectedBottom.textColor = [UIColor colorWithRed:0x88/255.0 green:0xFF/255.0 blue:0x88/255.0 alpha:1.0];
    } else {
        _tvFusionSelectedBottom.text = [NSString stringWithFormat:@"当前选中: 💎 %.2f", totalVal];
        _tvFusionSelectedBottom.textColor = [UIColor colorWithRed:255/255.0 green:223/255.0 blue:124/255.0 alpha:1.0];
    }
    
    // 向后端 POST /fusion_preview 异步拉取服务端权威判责数据并实时覆盖
    [self requestServerFusionPreviewCheck];
    
    // 3. 动态连线暂存包真实候选礼物 (支持多页翻页展示与强烈高对比度选中特效)
    NSArray *tempList = _candidateModel.temp_inventory;
    NSInteger startIndex = self.tempPageIndex * 3;
    for (int j = 0; j < _tempImageViews.count; j++) {
        UIImageView *tempIV = _tempImageViews[j];
        UIButton *itemBtn = _itemButtons[j];
        UIImageView *checkMarkIV = _checkMarkImageViews[j];
        NSInteger itemIdx = startIndex + j;
        
        if (itemIdx < tempList.count) {
            MLCandidateItemModel *tempItem = tempList[itemIdx];
            tempIV.hidden = NO;
            itemBtn.hidden = NO;
            if (tempItem.image && tempItem.image.length > 0) {
                [tempIV sd_setImageWithURL:[NSURL URLWithString:tempItem.image] placeholderImage:[UIImage imageNamed:@"theme_game_six_ic_token"]];
            }
            
            BOOL isSelected = [self.selectedTempSet containsObject:tempItem];
            if (isSelected) {
                // 选中状态：高亮亮绿金发光边框、放大10%、全透明度1.0、显示右角标Checkmark
                itemBtn.alpha = 1.0f;
                itemBtn.transform = CGAffineTransformMakeScale(1.10, 1.10);
                itemBtn.layer.borderWidth = KDialogAdaptedWidth(2.5);
                itemBtn.layer.borderColor = [UIColor colorWithRed:0x88/255.0 green:0xFF/255.0 blue:0x88/255.0 alpha:1.0].CGColor;
                itemBtn.layer.cornerRadius = KDialogAdaptedWidth(8);
                checkMarkIV.hidden = NO;
            } else {
                // 未选中状态：暗淡半透明alpha=0.45、原始尺寸1.0、无边框、隐藏角标
                itemBtn.alpha = 0.45f;
                itemBtn.transform = CGAffineTransformIdentity;
                itemBtn.layer.borderWidth = 0.0;
                checkMarkIV.hidden = YES;
            }
        } else {
            tempIV.hidden = YES;
            tempIV.image = nil;
            itemBtn.hidden = YES;
            checkMarkIV.hidden = YES;
        }
    }
}

#pragma mark - UI Setup (SUAS 375x812pt & ALURS Constraint Contract)

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 0. 全屏半透明遮罩
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _maskView.userInteractionEnabled = YES;
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tap];
    
    // 1. 融合卷轴主背板容器 (锁死 614:879 高宽比与 330pt 适配宽度)
    _boardContainer = [[UIView alloc] init];
    _boardContainer.userInteractionEnabled = YES;
    [self addSubview:_boardContainer];
    
    CGFloat boardWidth = KDialogAdaptedWidth(330);
    CGFloat boardHeight = boardWidth * (879.0 / 614.0);
    
    [_boardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(boardWidth, boardHeight));
    }];
    
    // 卷轴背景图 (theme_game_six_fusion_board_bg)
    _boardBgImageView = [[UIImageView alloc] init];
    _boardBgImageView.image = [UIImage imageNamed:@"theme_game_six_fusion_board_bg"];
    _boardBgImageView.contentMode = UIViewContentModeScaleToFill;
    [_boardContainer addSubview:_boardBgImageView];
    [_boardBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_boardContainer);
    }];
    
    // 1.1 顶部门槛提醒 (初始为 --，100% 等待服务器接口动态返回)
    _tvFusionThresholdTop = [[UILabel alloc] init];
    _tvFusionThresholdTop.text = @"融合门槛: 💎 --";
    _tvFusionThresholdTop.textColor = [UIColor colorWithRed:255/255.0 green:223/255.0 blue:124/255.0 alpha:1.0];
    _tvFusionThresholdTop.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(11)];
    _tvFusionThresholdTop.textAlignment = NSTextAlignmentCenter;
    [_boardContainer addSubview:_tvFusionThresholdTop];
    [_tvFusionThresholdTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_boardContainer.mas_top).offset(boardHeight * 0.10 - KDialogAdaptedWidth(2));
        make.centerX.mas_equalTo(_boardContainer);
    }];

    // 2. 顶部 3 配方槽位区 (缩小2%至92.7x94.9pt)
    _topSlotsContainer = [[UIView alloc] init];
    [_boardContainer addSubview:_topSlotsContainer];
    [_topSlotsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(boardHeight * 0.10);
        make.centerX.mas_equalTo(_boardContainer);
        make.height.mas_equalTo(KDialogAdaptedWidth(94.9));
    }];
    
    UIView *lastSlotView = nil;
    for (int i = 0; i < 3; i++) {
        UIButton *slotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [slotBtn setBackgroundImage:[UIImage imageNamed:@"theme_game_six_fusion_slot_frame"] forState:UIControlStateNormal];
        slotBtn.contentMode = UIViewContentModeScaleToFill;
        slotBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        slotBtn.tag = i + 1;
        [slotBtn addTarget:self action:@selector(slotClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topSlotsContainer addSubview:slotBtn];
        [_slotButtons addObject:slotBtn];
        
        // 槽位中间礼物 Icon 图片 (真实状态下初始为空)
        UIImageView *giftIconImageView = [[UIImageView alloc] init];
        giftIconImageView.contentMode = UIViewContentModeScaleAspectFit;
        giftIconImageView.image = nil;
        [slotBtn addSubview:giftIconImageView];
        [_slotImageViews addObject:giftIconImageView];
        [giftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(slotBtn);
            make.top.mas_equalTo(KDialogAdaptedWidth(20));
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(48), KDialogAdaptedWidth(48)));
        }];
        
        // 槽位底部加粗玫粉名字标签 (初始未选择状态显示 "待选择")
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"待选择";
        nameLabel.textColor = [UIColor colorWithRed:0xE0/255.0 green:0x38/255.0 blue:0x75/255.0 alpha:1.0];
        nameLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(8.5)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [slotBtn addSubview:nameLabel];
        [_slotNameLabels addObject:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(slotBtn).offset(-KDialogAdaptedWidth(4));
            make.centerX.mas_equalTo(slotBtn);
        }];

        [slotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_topSlotsContainer);
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(92.7), KDialogAdaptedWidth(94.9)));
            if (lastSlotView) {
                make.leading.mas_equalTo(lastSlotView.mas_trailing).offset(KDialogAdaptedWidth(6));
            } else {
                make.leading.mas_equalTo(_topSlotsContainer);
            }
        }];
        lastSlotView = slotBtn;
    }
    if (lastSlotView) {
        [_topSlotsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(lastSlotView.mas_trailing);
        }];
    }
    
    // 3. 中间融合操作按钮 (Top 36% 区域 210x56pt)
    _fusionActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fusionActionButton setBackgroundImage:[UIImage imageNamed:@"theme_game_six_fusion_btn_action"] forState:UIControlStateNormal];
    _fusionActionButton.contentMode = UIViewContentModeScaleToFill;
    _fusionActionButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [_fusionActionButton addTarget:self action:@selector(submitFusion) forControlEvents:UIControlEventTouchUpInside];
    [_boardContainer addSubview:_fusionActionButton];
    [_fusionActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(boardHeight * 0.36);
        make.centerX.mas_equalTo(_boardContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(210), KDialogAdaptedWidth(56)));
    }];
    
    // 3.1 底部当前选中价值提醒 (初始未选择礼物价值为 0.00)
    _tvFusionSelectedBottom = [[UILabel alloc] init];
    _tvFusionSelectedBottom.text = @"当前选中: 💎 0.00";
    _tvFusionSelectedBottom.textColor = [UIColor colorWithRed:255/255.0 green:223/255.0 blue:124/255.0 alpha:1.0];
    _tvFusionSelectedBottom.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(10)];
    _tvFusionSelectedBottom.textAlignment = NSTextAlignmentCenter;
    [_boardContainer addSubview:_tvFusionSelectedBottom];
    [_tvFusionSelectedBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_fusionActionButton.mas_bottom).offset(KDialogAdaptedWidth(4));
        make.centerX.mas_equalTo(_boardContainer);
    }];
    
    // 4. 底部背包待选面板区 (Top 53% ~ 91% 区域)
    _bottomPackPanelContainer = [[UIView alloc] init];
    _bottomPackPanelContainer.clipsToBounds = NO; // 允许两侧指示箭头向外突出 -16pt
    [_boardContainer addSubview:_bottomPackPanelContainer];
    [_bottomPackPanelContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(boardHeight * 0.53);
        make.height.mas_equalTo(boardHeight * (0.91 - 0.53));
        make.leading.mas_equalTo(KDialogAdaptedWidth(30));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(30));
    }];
    
    _packPanelBgImageView = [[UIImageView alloc] init];
    _packPanelBgImageView.image = [UIImage imageNamed:@"theme_game_six_fusion_pack_panel_bg"];
    _packPanelBgImageView.contentMode = UIViewContentModeScaleToFill;
    [_bottomPackPanelContainer addSubview:_packPanelBgImageView];
    [_packPanelBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_bottomPackPanelContainer);
    }];
    
    // 4.1 左指示箭头按钮 (放大10%至52.8x40.7pt，向外突出 -16pt)
    _prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_prevButton setBackgroundImage:[UIImage imageNamed:@"theme_game_six_fusion_btn_prev"] forState:UIControlStateNormal];
    _prevButton.contentMode = UIViewContentModeScaleToFill;
    _prevButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [_prevButton addTarget:self action:@selector(prevClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPackPanelContainer addSubview:_prevButton];
    [_prevButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(26));
        make.leading.mas_equalTo(-KDialogAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(52.8), KDialogAdaptedWidth(40.7)));
    }];
    
    // 4.2 右指示箭头按钮 (放大10%至52.8x40.7pt，向外突出 16pt)
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setBackgroundImage:[UIImage imageNamed:@"theme_game_six_fusion_btn_next"] forState:UIControlStateNormal];
    _nextButton.contentMode = UIViewContentModeScaleToFill;
    _nextButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [_nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPackPanelContainer addSubview:_nextButton];
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(26));
        make.trailing.mas_equalTo(KDialogAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(52.8), KDialogAdaptedWidth(40.7)));
    }];
    
    // 4.3 底部 3 个待选背包礼物卡槽 (放大10%至79.2x81.4pt，间距 8pt，向下偏移20pt)
    UIView *itemsRowView = [[UIView alloc] init];
    [_bottomPackPanelContainer addSubview:itemsRowView];
    [itemsRowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bottomPackPanelContainer).offset(KDialogAdaptedWidth(20));
        make.centerX.mas_equalTo(_bottomPackPanelContainer);
        make.height.mas_equalTo(KDialogAdaptedWidth(81.4));
    }];
    
    UIView *lastItemView = nil;
    for (int j = 0; j < 3; j++) {
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemBtn setBackgroundImage:[UIImage imageNamed:@"theme_game_six_fusion_item_frame"] forState:UIControlStateNormal];
        itemBtn.contentMode = UIViewContentModeScaleToFill;
        itemBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        itemBtn.tag = j + 1;
        [itemBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [itemsRowView addSubview:itemBtn];
        [_itemButtons addObject:itemBtn];
        
        UIImageView *tempIV = [[UIImageView alloc] init];
        tempIV.contentMode = UIViewContentModeScaleAspectFit;
        [itemBtn addSubview:tempIV];
        [_tempImageViews addObject:tempIV];
        [tempIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(itemBtn);
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(44), KDialogAdaptedWidth(44)));
        }];
        
        // 选中右角标 Checkmark
        UIImageView *checkMarkIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme_game_six_rule_check"] ? : [UIImage imageNamed:@"theme_game_six_ic_token"]];
        checkMarkIV.contentMode = UIViewContentModeScaleAspectFit;
        checkMarkIV.hidden = YES;
        [itemBtn addSubview:checkMarkIV];
        [_checkMarkImageViews addObject:checkMarkIV];
        [checkMarkIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KDialogAdaptedWidth(4));
            make.trailing.mas_equalTo(-KDialogAdaptedWidth(4));
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(16), KDialogAdaptedWidth(16)));
        }];
        
        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(itemsRowView);
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(79.2), KDialogAdaptedWidth(81.4)));
            if (lastItemView) {
                make.leading.mas_equalTo(lastItemView.mas_trailing).offset(KDialogAdaptedWidth(8));
            } else {
                make.leading.mas_equalTo(itemsRowView);
            }
        }];
        lastItemView = itemBtn;
    }
    if (lastItemView) {
        [itemsRowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(lastItemView.mas_trailing);
        }];
    }
}

#pragma mark - User Interaction Callbacks

- (void)submitFusion {
    NSMutableArray *allSelected = [NSMutableArray array];
    double totalVal = 0.0;
    
    for (id slotObj in self.selectedGlobalSlots) {
        if ([slotObj isKindOfClass:[MLCandidateItemModel class]]) {
            MLCandidateItemModel *item = (MLCandidateItemModel *)slotObj;
            [allSelected addObject:item];
            if (item.unit_value) {
                totalVal += [item.unit_value doubleValue];
            }
        }
    }
    
    for (MLCandidateItemModel *tItem in self.selectedTempSet) {
        [allSelected addObject:tItem];
        if (tItem.unit_value) {
            totalVal += [tItem.unit_value doubleValue];
        }
    }
    
    if (allSelected.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请先选择需要融合的礼物"];
        return;
    }
    
    double threshold = [_candidateModel.threshold_value doubleValue];
    if (threshold > 0 && totalVal < threshold) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"所选礼物总价值(💎%.2f)未达到门槛(💎%@)，无法融合", totalVal, _candidateModel.threshold_value ?: @"--"]];
        return;
    }
    
    // 提交前先从服务器请求最新 /bootstrap，获取 100% 准确最新的 state_version (包含 0 初始版本)
    [SVProgressHUD showWithStatus:@"正在校验最新游戏状态..."];
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
        
        NSMutableArray *globalArr = [NSMutableArray array];
        NSMutableArray *tempArr = [NSMutableArray array];
        
        for (MLCandidateItemModel *cItem in allSelected) {
            NSDictionary *itemDict = @{
                @"inventory_id": @(cItem.inventory_id),
                @"num": @(1)
            };
            if ([@"temp" isEqualToString:cItem.source]) {
                [tempArr addObject:itemDict];
            } else {
                [globalArr addObject:itemDict];
            }
        }
        
        [SVProgressHUD showWithStatus:@"正在提交门票合成..."];
        [[MLThemeGameModel sharedInstance] exchangeTowerGameSixTicketWithGlobalItems:globalArr tempItems:tempArr stateVersion:freshStateVersion success:^(id _Nullable responseObj) {
            [SVProgressHUD showSuccessWithStatus:@"✨ 门票融合成功！已获得 7 次重铸机会"];
            if (self.onFusionSuccessBlock) {
                self.onFusionSuccessBlock();
            }
            [self dismiss];
        } failure:^(NSError * _Nonnull error, NSString * _Nullable msg) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:msg ?: @"门票合成失败"];
        }];
    } failure:^(NSError * _Nonnull error, NSString * _Nullable msg) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:msg ?: @"校验游戏状态失败"];
    }];
}

- (void)requestServerFusionPreviewCheck {
    NSMutableArray *items = [NSMutableArray array];
    for (id slotObj in self.selectedGlobalSlots) {
        if ([slotObj isKindOfClass:[MLCandidateItemModel class]]) {
            MLCandidateItemModel *item = (MLCandidateItemModel *)slotObj;
            [items addObject:@{
                @"inventory_id": @(item.inventory_id),
                @"source": item.source ?: @"global"
            }];
        }
    }
    for (MLCandidateItemModel *tItem in self.selectedTempSet) {
        [items addObject:@{
            @"inventory_id": @(tItem.inventory_id),
            @"source": @"temp"
        }];
    }
    if (items.count == 0) return;
    
    [[MLThemeGameModel sharedInstance] previewTowerGameSixFusionWithItems:items success:^(id _Nullable responseObj) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            NSString *serverTotalVal = responseObj[@"total_value"];
            BOOL isEligible = [responseObj[@"is_eligible"] boolValue];
            if (serverTotalVal) {
                if (isEligible) {
                    self.tvFusionSelectedBottom.text = [NSString stringWithFormat:@"当前选中: 💎 %@ (已达标)", serverTotalVal];
                    self.tvFusionSelectedBottom.textColor = [UIColor colorWithRed:0x88/255.0 green:0xFF/255.0 blue:0x88/255.0 alpha:1.0];
                } else {
                    self.tvFusionSelectedBottom.text = [NSString stringWithFormat:@"当前选中: 💎 %@", serverTotalVal];
                    self.tvFusionSelectedBottom.textColor = [UIColor colorWithRed:255/255.0 green:223/255.0 blue:124/255.0 alpha:1.0];
                }
            }
        }
    } failure:nil];
}

- (void)prevClick {
    if (self.tempPageIndex > 0) {
        self.tempPageIndex--;
        [self refreshDataUI];
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"暂存包已切换至第 %ld 页", (long)(self.tempPageIndex + 1)]];
    } else {
        [SVProgressHUD showInfoWithStatus:@"暂存包已经是第一页了"];
    }
}

- (void)nextClick {
    NSArray *tempList = _candidateModel.temp_inventory;
    NSInteger maxPages = MAX(1, (tempList ? (tempList.count + 2) / 3 : 1));
    if (self.tempPageIndex < maxPages - 1) {
        self.tempPageIndex++;
        [self refreshDataUI];
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"暂存包已切换至第 %ld 页", (long)(self.tempPageIndex + 1)]];
    } else {
        [SVProgressHUD showInfoWithStatus:@"暂存包已经是最后一页了"];
    }
}

- (void)slotClick:(UIButton *)btn {
    NSInteger slotIndex = btn.tag - 1;
    [self showGlobalGiftSelector:slotIndex];
}

- (void)showGlobalGiftSelector:(NSInteger)slotIndex {
    NSArray<MLCandidateItemModel *> *globalList = _candidateModel.global_inventory;
    if (!globalList || globalList.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"大背包中暂无可用候选礼物"];
        return;
    }
    
    // 1:1 还原 temp/样式.png，同行放置“清空此槽位”与“取消”
    [MLGlobalGiftSelectorPicker showWithSlotIndex:slotIndex items:globalList selectBlock:^(MLCandidateItemModel * _Nullable selectedItem, BOOL isClear) {
        if (isClear) {
            self.selectedGlobalSlots[slotIndex] = [NSNull null];
            [self refreshDataUI];
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"已清空槽位 %ld", (long)(slotIndex + 1)]];
        } else if (selectedItem) {
            self.selectedGlobalSlots[slotIndex] = selectedItem;
            [self refreshDataUI];
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"已将 [%@] 放入槽位 %ld", selectedItem.name ?: @"", (long)(slotIndex + 1)]];
        }
    }];
}

- (void)itemClick:(UIButton *)btn {
    NSInteger itemIndex = self.tempPageIndex * 3 + (btn.tag - 1);
    NSArray *tempList = _candidateModel.temp_inventory;
    if (tempList && itemIndex < tempList.count) {
        MLCandidateItemModel *chosenItem = tempList[itemIndex];
        if ([self.selectedTempSet containsObject:chosenItem]) {
            [self.selectedTempSet removeObject:chosenItem];
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"取消选择 [%@]", chosenItem.name ?: @"礼物"]];
        } else {
            [self.selectedTempSet addObject:chosenItem];
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"已选中 [%@]", chosenItem.name ?: @"礼物"]];
        }
        [self refreshDataUI];
    }
}

#pragma mark - Animations & Dismissal

- (void)animateShow {
    self.alpha = 0.0;
    _boardContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
        self.boardContainer.transform = CGAffineTransformIdentity;
    }];
}

- (void)closeClick {
    [self dismiss];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.boardContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
