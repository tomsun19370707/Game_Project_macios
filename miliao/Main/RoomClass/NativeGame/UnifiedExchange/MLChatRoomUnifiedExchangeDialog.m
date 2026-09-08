//
//  MLChatRoomUnifiedExchangeDialog.m
//  miliao
//
//  Created by PairProgramming on 2026/9/8.
//

#import "MLChatRoomUnifiedExchangeDialog.h"
#import "MLUnifiedExchangeGiftCell.h"
#import "MLChatRoomUnifiedExchangeConfirmDialog.h"
#import "Global.h"
#import "FFHomeHandel.h"
#import "DZCX_NetAPIPaths.h"
#import "NetworkRequest.h"
#import "HomeInfo.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface MLChatRoomUnifiedExchangeDialog () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *backgroundContainer;
@property (nonatomic, strong) UIImageView *bgImageView;

// 顶部双资产看板
@property (nonatomic, strong) UIView *topTabContainer;
@property (nonatomic, strong) UIImageView *tabBgImageView;
@property (nonatomic, strong) UIView *obsidianAssetView;
@property (nonatomic, strong) UIImageView *obsidianIconView;
@property (nonatomic, strong) UILabel *obsidianBalanceLabel;
@property (nonatomic, strong) UILabel *obsidianNameLabel;

@property (nonatomic, strong) UIView *ingotAssetView;
@property (nonatomic, strong) UIImageView *ingotIconView;
@property (nonatomic, strong) UILabel *ingotBalanceLabel;
@property (nonatomic, strong) UILabel *ingotNameLabel;

// 礼物区白色面板
@property (nonatomic, strong) UIView *contentContainer;
@property (nonatomic, strong) UIImageView *giftAreaBgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *emptyLabel;
@property (nonatomic, strong) UIButton *confirmExchangeBtn;

@property (nonatomic, strong) NSMutableArray<MLUnifiedExchangeItem *> *giftList;
@property (nonatomic, strong, nullable) MLUnifiedExchangeItem *selectedItem;

@property (nonatomic, assign) double cachedObsidian;
@property (nonatomic, assign) double cachedIngot;
@property (nonatomic, assign) CGFloat panelWidth;
@property (nonatomic, assign) CGFloat panelHeight;

@end

@implementation MLChatRoomUnifiedExchangeDialog

+ (instancetype)showInView:(nullable UIView *)parentView
               defaultMode:(MLUnifiedExchangeMode)mode
                   success:(nullable MLUnifiedExchangeSuccessBlock)successBlock {
    UIView *targetView = parentView;
    if (!targetView) {
        targetView = [UIApplication sharedApplication].keyWindow;
    }
    if (!targetView) return nil;
    
    MLChatRoomUnifiedExchangeDialog *dialog = [[MLChatRoomUnifiedExchangeDialog alloc] initWithFrame:targetView.bounds mode:mode];
    dialog.successBlock = successBlock;
    [targetView addSubview:dialog];
    [dialog animateShow];
    return dialog;
}

- (instancetype)initWithFrame:(CGRect)frame mode:(MLUnifiedExchangeMode)mode {
    self = [super initWithFrame:frame];
    if (self) {
        _currentMode = mode;
        _giftList = [NSMutableArray array];
        _cachedObsidian = 0;
        _cachedIngot = 0;
        [self setupUI];
        [self updateTabStyle];
        [self loadWalletData];
        [self loadGiftsData];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 背景遮罩
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapMask = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMaskTapped)];
    [_maskView addGestureRecognizer:tapMask];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 计算面板尺寸 (遵循规范：锁定 750:1623 切图真实比例，顶部留出安全间隙防溢出)
    CGFloat screenWidth = self.bounds.size.width > 0 ? self.bounds.size.width : [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = self.bounds.size.height > 0 ? self.bounds.size.height : [UIScreen mainScreen].bounds.size.height;
    
    CGFloat panelWidth = MIN(screenWidth, 430.0);
    
    CGFloat topSafe = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!keyWindow && [UIApplication sharedApplication].windows.count > 0) {
            keyWindow = [UIApplication sharedApplication].windows.firstObject;
        }
        topSafe = keyWindow.safeAreaInsets.top;
    }
    if (topSafe <= 0) {
        topSafe = 44.0;
    }
    
    CGFloat targetHeight = panelWidth * (1623.0 / 750.0);
    CGFloat maxHeight = screenHeight - topSafe - 12.0;
    CGFloat panelHeight = MIN(targetHeight, maxHeight);
    
    _panelWidth = panelWidth;
    _panelHeight = panelHeight;
    
    // 主容器 (锁定 750:1623 比例自适应，贴底对齐)
    _backgroundContainer = [[UIView alloc] init];
    _backgroundContainer.clipsToBounds = NO;
    [self addSubview:_backgroundContainer];
    [_backgroundContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(panelWidth);
        make.height.mas_equalTo(panelHeight);
    }];
    
    // 主面板背景底图
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"unified_exchange_bg_main"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    [_backgroundContainer addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backgroundContainer);
    }];
    
    // 顶部双资产看板容器 (721 × 233 比例)
    CGFloat tabHeight = (panelWidth - 28.0) * (233.0 / 721.0);
    _topTabContainer = [[UIView alloc] init];
    [_backgroundContainer addSubview:_topTabContainer];
    [_topTabContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundContainer).offset(40);
        make.left.equalTo(_backgroundContainer).offset(14);
        make.right.equalTo(_backgroundContainer).offset(-14);
        make.height.mas_equalTo(tabHeight);
    }];
    
    _tabBgImageView = [[UIImageView alloc] init];
    _tabBgImageView.image = [UIImage imageNamed:@"unified_exchange_tab_bg"];
    _tabBgImageView.contentMode = UIViewContentModeScaleToFill;
    [_topTabContainer addSubview:_tabBgImageView];
    [_tabBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_topTabContainer);
    }];
    
    // 中间分割锚点引导
    UIView *centerAnchor = [[UIView alloc] init];
    [_topTabContainer addSubview:centerAnchor];
    [centerAnchor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topTabContainer);
        make.top.bottom.equalTo(_topTabContainer);
        make.width.mas_equalTo(1);
    }];
    
    // 左半部分: 黑曜石资产
    _obsidianAssetView = [[UIView alloc] init];
    _obsidianAssetView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapObsidian = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onObsidianTabClick)];
    [_obsidianAssetView addGestureRecognizer:tapObsidian];
    [_topTabContainer addSubview:_obsidianAssetView];
    [_obsidianAssetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_topTabContainer);
        make.left.equalTo(_topTabContainer);
        make.right.equalTo(centerAnchor.mas_left);
    }];
    
    UIView *obsidianRow = [[UIView alloc] init];
    obsidianRow.userInteractionEnabled = NO;
    [_obsidianAssetView addSubview:obsidianRow];
    [obsidianRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_obsidianAssetView);
        make.centerY.equalTo(_obsidianAssetView).offset(-10);
        make.height.mas_equalTo(28);
    }];
    
    _obsidianIconView = [[UIImageView alloc] init];
    _obsidianIconView.image = [UIImage imageNamed:@"unified_exchange_ic_obsidian"];
    _obsidianIconView.contentMode = UIViewContentModeScaleAspectFit;
    [obsidianRow addSubview:_obsidianIconView];
    [_obsidianIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(obsidianRow);
        make.centerY.equalTo(obsidianRow);
        make.width.height.mas_equalTo(28);
    }];
    
    _obsidianBalanceLabel = [[UILabel alloc] init];
    _obsidianBalanceLabel.text = @"0";
    _obsidianBalanceLabel.textColor = [UIColor whiteColor];
    _obsidianBalanceLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20.0] ?: [UIFont boldSystemFontOfSize:20.0];
    [obsidianRow addSubview:_obsidianBalanceLabel];
    [_obsidianBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_obsidianIconView.mas_right).offset(6);
        make.right.equalTo(obsidianRow);
        make.centerY.equalTo(obsidianRow);
    }];
    
    _obsidianNameLabel = [[UILabel alloc] init];
    _obsidianNameLabel.text = @"黑曜石";
    _obsidianNameLabel.textColor = [UIColor colorWithRed:0x3D/255.0 green:0x29/255.0 blue:0x10/255.0 alpha:1.0];
    _obsidianNameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12.0] ?: [UIFont boldSystemFontOfSize:12.0];
    [_obsidianAssetView addSubview:_obsidianNameLabel];
    [_obsidianNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_obsidianAssetView);
        make.top.equalTo(obsidianRow.mas_bottom).offset(6);
    }];
    
    // 右半部分: 元宝资产
    _ingotAssetView = [[UIView alloc] init];
    _ingotAssetView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapIngot = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onIngotTabClick)];
    [_ingotAssetView addGestureRecognizer:tapIngot];
    [_topTabContainer addSubview:_ingotAssetView];
    [_ingotAssetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_topTabContainer);
        make.right.equalTo(_topTabContainer);
        make.left.equalTo(centerAnchor.mas_right);
    }];
    
    UIView *ingotRow = [[UIView alloc] init];
    ingotRow.userInteractionEnabled = NO;
    [_ingotAssetView addSubview:ingotRow];
    [ingotRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_ingotAssetView);
        make.centerY.equalTo(_ingotAssetView).offset(-10);
        make.height.mas_equalTo(28);
    }];
    
    _ingotIconView = [[UIImageView alloc] init];
    _ingotIconView.image = [UIImage imageNamed:@"unified_exchange_ic_ingot"];
    _ingotIconView.contentMode = UIViewContentModeScaleAspectFit;
    [ingotRow addSubview:_ingotIconView];
    [_ingotIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ingotRow);
        make.centerY.equalTo(ingotRow);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(22);
    }];
    
    _ingotBalanceLabel = [[UILabel alloc] init];
    _ingotBalanceLabel.text = @"0";
    _ingotBalanceLabel.textColor = [UIColor whiteColor];
    _ingotBalanceLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20.0] ?: [UIFont boldSystemFontOfSize:20.0];
    [ingotRow addSubview:_ingotBalanceLabel];
    [_ingotBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ingotIconView.mas_right).offset(6);
        make.right.equalTo(ingotRow);
        make.centerY.equalTo(ingotRow);
    }];
    
    _ingotNameLabel = [[UILabel alloc] init];
    _ingotNameLabel.text = @"元宝";
    _ingotNameLabel.textColor = [UIColor colorWithRed:0x19/255.0 green:0x28/255.0 blue:0x3D/255.0 alpha:1.0];
    _ingotNameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12.0] ?: [UIFont boldSystemFontOfSize:12.0];
    [_ingotAssetView addSubview:_ingotNameLabel];
    [_ingotNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_ingotAssetView);
        make.top.equalTo(ingotRow.mas_bottom).offset(6);
    }];
    
    // 礼物区白色面板容器
    _contentContainer = [[UIView alloc] init];
    [_backgroundContainer addSubview:_contentContainer];
    [_contentContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topTabContainer.mas_bottom).offset(10);
        make.left.equalTo(_backgroundContainer).offset(14);
        make.right.equalTo(_backgroundContainer).offset(-14);
        make.bottom.equalTo(_backgroundContainer).offset(-16);
    }];
    
    _giftAreaBgView = [[UIImageView alloc] init];
    _giftAreaBgView.image = [UIImage imageNamed:@"unified_exchange_bg_gift_area"];
    _giftAreaBgView.contentMode = UIViewContentModeScaleToFill;
    [_contentContainer addSubview:_giftAreaBgView];
    [_giftAreaBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contentContainer);
    }];
    
    // 标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"背包礼物兑换黑曜石";
    _titleLabel.textColor = [UIColor colorWithRed:0x22/255.0 green:0x22/255.0 blue:0x22/255.0 alpha:1.0];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18.0] ?: [UIFont boldSystemFontOfSize:18.0];
    [_contentContainer addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentContainer).offset(18);
        make.top.equalTo(_contentContainer).offset(16);
    }];
    
    // 关闭按钮 (高对比度纯黑加粗关闭叉)
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"unified_exchange_ic_close_black"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(onCloseClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentContainer addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.equalTo(_contentContainer).offset(-12);
        make.width.height.mas_equalTo(36);
    }];
    
    // 底部确定兑换按钮 (优先布局以供 collectionView 约束)
    _confirmExchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmExchangeBtn setImage:[UIImage imageNamed:@"unified_exchange_btn_confirm"] forState:UIControlStateNormal];
    [_confirmExchangeBtn addTarget:self action:@selector(onConfirmExchangeClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentContainer addSubview:_confirmExchangeBtn];
    [_confirmExchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_contentContainer).offset(-14);
        make.centerX.equalTo(_contentContainer);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(54);
    }];
    
    // 礼物九宫格/网格列表 (自适应三列网格宽度)
    CGFloat availableWidth = panelWidth - 28.0 - 20.0;
    CGFloat itemWidth = floor((availableWidth - 2 * 6.0) / 3.0);
    if (itemWidth < 100.0) itemWidth = 100.0;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 6;
    layout.minimumLineSpacing = 8;
    layout.itemSize = CGSizeMake(itemWidth, 132);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[MLUnifiedExchangeGiftCell class] forCellWithReuseIdentifier:@"MLUnifiedExchangeGiftCell"];
    [_contentContainer addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(_contentContainer).offset(10);
        make.right.equalTo(_contentContainer).offset(-10);
        make.bottom.equalTo(_confirmExchangeBtn.mas_top).offset(-10);
    }];
    
    // 空数据提示
    _emptyLabel = [[UILabel alloc] init];
    _emptyLabel.text = @"暂无可兑换礼物";
    _emptyLabel.textColor = [UIColor colorWithRed:0x99/255.0 green:0x99/255.0 blue:0x99/255.0 alpha:1.0];
    _emptyLabel.font = [UIFont systemFontOfSize:14.0];
    _emptyLabel.textAlignment = NSTextAlignmentCenter;
    _emptyLabel.hidden = YES;
    [_contentContainer addSubview:_emptyLabel];
    [_emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_collectionView);
    }];
}

- (void)updateTabStyle {
    if (_currentMode == MLUnifiedExchangeModeBackpack) {
        _titleLabel.text = @"背包礼物兑换黑曜石";
        _tabBgImageView.image = [UIImage imageNamed:@"unified_exchange_tab_bg"];
        _obsidianNameLabel.textColor = [UIColor colorWithRed:0x3D/255.0 green:0x29/255.0 blue:0x10/255.0 alpha:1.0];
        _ingotNameLabel.textColor = [UIColor colorWithRed:0x19/255.0 green:0x28/255.0 blue:0x3D/255.0 alpha:1.0];
        _obsidianAssetView.alpha = 1.0;
        _ingotAssetView.alpha = 0.7;
    } else {
        _titleLabel.text = @"元宝商城兑换礼物";
        _tabBgImageView.image = [UIImage imageNamed:@"unified_exchange_tab_bg_ingot"];
        _obsidianNameLabel.textColor = [UIColor colorWithRed:0x19/255.0 green:0x28/255.0 blue:0x3D/255.0 alpha:1.0];
        _ingotNameLabel.textColor = [UIColor colorWithRed:0x3D/255.0 green:0x29/255.0 blue:0x10/255.0 alpha:1.0];
        _obsidianAssetView.alpha = 0.7;
        _ingotAssetView.alpha = 1.0;
    }
}

#pragma mark - Actions

- (void)onObsidianTabClick {
    if (_currentMode == MLUnifiedExchangeModeBackpack) return;
    _currentMode = MLUnifiedExchangeModeBackpack;
    [self updateTabStyle];
    [self loadGiftsData];
}

- (void)onIngotTabClick {
    if (_currentMode == MLUnifiedExchangeModeMall) return;
    _currentMode = MLUnifiedExchangeModeMall;
    [self updateTabStyle];
    [self loadGiftsData];
}

- (void)onCloseClick {
    [self dismiss];
}

- (void)onMaskTapped {
    [self dismiss];
}

- (void)onConfirmExchangeClick {
    if (!_selectedItem) {
        [SVProgressHUD showImage:nil status:@"请先选择要兑换的礼物"];
        return;
    }
    [self showConfirmDialog:_selectedItem];
}

- (void)showConfirmDialog:(MLUnifiedExchangeItem *)item {
    __weak typeof(self) wself = self;
    [MLChatRoomUnifiedExchangeConfirmDialog showWithItem:item inView:self success:^{
        [wself loadWalletData];
        [wself loadGiftsData];
        if (wself.successBlock) {
            wself.successBlock();
        }
    }];
}

#pragma mark - Load Data

- (void)loadWalletData {
    __weak typeof(self) wself = self;
    [NetworkRequest POST:user_getMoney parmeters:nil success:^(id responObject) {
        NSDictionary *data = nil;
        if ([responObject isKindOfClass:[BaseModel class]]) {
            BaseModel *base = (BaseModel *)responObject;
            if ([base.data isKindOfClass:[NSDictionary class]]) {
                data = (NSDictionary *)base.data;
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
            id obsObj = data[@"ratio_coin"] ?: data[@"ratioCoin"];
            id ingotObj = data[@"prize_coin"] ?: data[@"prizeCoin"];
            wself.cachedObsidian = obsObj ? [obsObj doubleValue] : 0;
            wself.cachedIngot = ingotObj ? [ingotObj doubleValue] : 0;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.obsidianBalanceLabel.text = [MLUnifiedExchangeItem formatLargeNumber:wself.cachedObsidian];
                wself.ingotBalanceLabel.text = [MLUnifiedExchangeItem formatLargeNumber:wself.cachedIngot];
            });
        }
    } failture:^(NSError *error) {}];
}

- (void)loadGiftsData {
    if (_currentMode == MLUnifiedExchangeModeBackpack) {
        [self loadBackpackGifts];
    } else {
        [self loadMallGifts];
    }
}

- (void)loadBackpackGifts {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"is_send"] = @"1";
    params[@"page"] = @"1";
    params[@"page_size"] = @"1000";
    params[@"size"] = @"1000";
    if ([NSString NotNull:UserDefaultsGet(kToken)]) params[@"token"] = UserDefaultsGet(kToken);
    
    __weak typeof(self) wself = self;
    [NetworkRequest POSTNew:user_getMyKnapsack parmeters:params success:^(id responObject) {
        [wself.giftList removeAllObjects];
        wself.selectedItem = nil;
        
        NSArray *rawItems = nil;
        if ([responObject isKindOfClass:[NSDictionary class]]) {
            id dataObj = responObject[@"data"];
            if ([dataObj isKindOfClass:[NSArray class]]) {
                rawItems = (NSArray *)dataObj;
            } else if ([responObject[@"result"] isKindOfClass:[NSArray class]]) {
                rawItems = responObject[@"result"];
            }
        }
        
        if (rawItems && rawItems.count > 0) {
            for (NSInteger i = 0; i < rawItems.count; i++) {
                id raw = rawItems[i];
                NSDictionary *dict = nil;
                if ([raw isKindOfClass:[GoodListInfoModel class]]) {
                    dict = [(GoodListInfoModel *)raw mj_keyValues];
                } else if ([raw isKindOfClass:[NSDictionary class]]) {
                    dict = (NSDictionary *)raw;
                }
                if (dict) {
                    MLUnifiedExchangeItem *item = [MLUnifiedExchangeItem itemFromGiftDictionary:dict];
                    if (i == 0) {
                        item.isSelected = YES;
                        wself.selectedItem = item;
                    }
                    [wself.giftList addObject:item];
                }
            }
            wself.emptyLabel.hidden = YES;
            wself.collectionView.hidden = NO;
        } else {
            wself.emptyLabel.text = @"背包暂无可兑换的礼物";
            wself.emptyLabel.hidden = NO;
            wself.collectionView.hidden = YES;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.collectionView reloadData];
        });
    } failture:^(NSError *error) {
        wself.emptyLabel.text = @"获取礼物失败，请稍后重试";
        wself.emptyLabel.hidden = (wself.giftList.count > 0);
        wself.collectionView.hidden = (wself.giftList.count == 0);
    }];
}

- (void)loadMallGifts {
    // 关键并发逻辑：商城列表与背包持有量并行请求并绑定
    NSMutableDictionary *mallParams = [NSMutableDictionary dictionary];
    mallParams[@"page"] = @"1";
    mallParams[@"page_size"] = @"100";
    mallParams[@"type"] = @"9"; // 倍率盘/专属兑换礼物
    if ([NSString NotNull:UserDefaultsGet(kToken)]) mallParams[@"token"] = UserDefaultsGet(kToken);
    
    NSMutableDictionary *knapsackParams = [NSMutableDictionary dictionary];
    knapsackParams[@"page"] = @"1";
    knapsackParams[@"page_size"] = @"1000";
    knapsackParams[@"size"] = @"1000";
    // 注意：严禁带 is_send=1，以获取全部背包礼物库存
    if ([NSString NotNull:UserDefaultsGet(kToken)]) knapsackParams[@"token"] = UserDefaultsGet(kToken);
    
    __block NSArray *mallRawList = nil;
    __block NSArray *knapsackRawList = nil;
    
    dispatch_group_t group = dispatch_group_create();
    
    // 1. 请求商城列表
    dispatch_group_enter(group);
    [NetworkRequest POSTNew:gift_giftList parmeters:mallParams success:^(id responObject) {
        if ([responObject isKindOfClass:[NSDictionary class]]) {
            id dataObj = responObject[@"data"];
            if ([dataObj isKindOfClass:[NSDictionary class]]) {
                if ([dataObj[@"data"] isKindOfClass:[NSArray class]]) {
                    mallRawList = dataObj[@"data"];
                } else if ([dataObj[@"list"] isKindOfClass:[NSArray class]]) {
                    mallRawList = dataObj[@"list"];
                }
            } else if ([dataObj isKindOfClass:[NSArray class]]) {
                mallRawList = dataObj;
            } else if ([responObject[@"result"] isKindOfClass:[NSArray class]]) {
                mallRawList = responObject[@"result"];
            }
        }
        dispatch_group_leave(group);
    } failture:^(NSError *error) {
        dispatch_group_leave(group);
    }];
    
    // 2. 请求全量背包库存
    dispatch_group_enter(group);
    [NetworkRequest POSTNew:user_getMyKnapsack parmeters:knapsackParams success:^(id responObject) {
        if ([responObject isKindOfClass:[NSDictionary class]]) {
            id dataObj = responObject[@"data"];
            if ([dataObj isKindOfClass:[NSArray class]]) {
                knapsackRawList = dataObj;
            } else if ([responObject[@"result"] isKindOfClass:[NSArray class]]) {
                knapsackRawList = responObject[@"result"];
            }
        }
        dispatch_group_leave(group);
    } failture:^(NSError *error) {
        dispatch_group_leave(group);
    }];
    
    __weak typeof(self) wself = self;
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [wself.giftList removeAllObjects];
        wself.selectedItem = nil;
        
        // 构建背包持有量字典映射 (idCounts & nameCounts)
        NSMutableDictionary<NSNumber *, NSNumber *> *idCounts = [NSMutableDictionary dictionary];
        NSMutableDictionary<NSString *, NSNumber *> *nameCounts = [NSMutableDictionary dictionary];
        
        if (knapsackRawList && knapsackRawList.count > 0) {
            for (id item in knapsackRawList) {
                NSDictionary *dict = nil;
                if ([item isKindOfClass:[GoodListInfoModel class]]) {
                    dict = [(GoodListInfoModel *)item mj_keyValues];
                } else if ([item isKindOfClass:[NSDictionary class]]) {
                    dict = (NSDictionary *)item;
                }
                if (!dict) continue;
                
                NSInteger num = [dict[@"num"] integerValue] ?: [dict[@"nums"] integerValue];
                NSInteger giftId = [dict[@"gift_id"] integerValue];
                NSInteger itemId = [dict[@"id"] integerValue];
                NSString *name = [dict[@"name"] description];
                
                if (giftId > 0) {
                    NSInteger cur = [idCounts[@(giftId)] integerValue];
                    idCounts[@(giftId)] = @(cur + num);
                }
                if (itemId > 0) {
                    NSInteger cur = [idCounts[@(itemId)] integerValue];
                    idCounts[@(itemId)] = @(cur + num);
                }
                if (name.length > 0) {
                    NSString *trimmed = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSInteger cur = [nameCounts[trimmed] integerValue];
                    nameCounts[trimmed] = @(cur + num);
                }
            }
        }
        
        // 绑定商城列表
        if (mallRawList && mallRawList.count > 0) {
            for (id item in mallRawList) {
                NSDictionary *dict = nil;
                if ([item isKindOfClass:[NSDictionary class]]) {
                    dict = (NSDictionary *)item;
                }
                if (!dict) continue;
                
                NSInteger priceCoin = 0;
                if (dict[@"prize_coin"] != nil) {
                    priceCoin = [dict[@"prize_coin"] integerValue];
                } else if (dict[@"prizeCoin"] != nil) {
                    priceCoin = [dict[@"prizeCoin"] integerValue];
                } else if (dict[@"coin"] != nil) {
                    priceCoin = [dict[@"coin"] integerValue];
                }
                
                NSInteger ratioCoin = 0;
                if (dict[@"ratio_coin"] != nil) {
                    ratioCoin = [dict[@"ratio_coin"] integerValue];
                } else if (dict[@"ratioCoin"] != nil) {
                    ratioCoin = [dict[@"ratioCoin"] integerValue];
                }
                
                if (priceCoin <= 0 && ratioCoin <= 0) continue;
                
                NSInteger mallId = [dict[@"id"] integerValue];
                NSString *name = [dict[@"name"] description];
                NSString *trimmedName = name.length > 0 ? [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : @"";
                
                NSInteger owned = 0;
                if (mallId > 0 && idCounts[@(mallId)] != nil) {
                    owned = [idCounts[@(mallId)] integerValue];
                } else if (trimmedName.length > 0 && nameCounts[trimmedName] != nil) {
                    owned = [nameCounts[trimmedName] integerValue];
                }
                
                MLUnifiedExchangeItem *unifiedItem = [MLUnifiedExchangeItem itemFromMallDictionary:dict ownedCount:owned];
                if (wself.giftList.count == 0) {
                    unifiedItem.isSelected = YES;
                    wself.selectedItem = unifiedItem;
                }
                [wself.giftList addObject:unifiedItem];
            }
        }
        
        if (wself.giftList.count > 0) {
            wself.emptyLabel.hidden = YES;
            wself.collectionView.hidden = NO;
        } else {
            wself.emptyLabel.text = @"商城暂无可兑换的礼物";
            wself.emptyLabel.hidden = NO;
            wself.collectionView.hidden = YES;
        }
        
        [wself.collectionView reloadData];
    });
}

#pragma mark - UICollectionViewDelegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _giftList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLUnifiedExchangeGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MLUnifiedExchangeGiftCell" forIndexPath:indexPath];
    if (indexPath.item < _giftList.count) {
        MLUnifiedExchangeItem *item = _giftList[indexPath.item];
        [cell configureWithItem:item isSelected:item.isSelected];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item >= _giftList.count) return;
    MLUnifiedExchangeItem *clicked = _giftList[indexPath.item];
    
    if (clicked.isSelected) {
        // 二次点击已选中的礼物，直接弹出确认窗口
        [self showConfirmDialog:clicked];
        return;
    }
    
    for (MLUnifiedExchangeItem *it in _giftList) {
        it.isSelected = (it == clicked);
    }
    _selectedItem = clicked;
    [_collectionView reloadData];
}

#pragma mark - Show / Dismiss Animations

- (void)animateShow {
    _maskView.alpha = 0.0;
    CGFloat translationY = self.panelHeight > 0 ? self.panelHeight : 900.0;
    _backgroundContainer.transform = CGAffineTransformMakeTranslation(0, translationY);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.maskView.alpha = 1.0;
        self.backgroundContainer.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)dismiss {
    CGFloat translationY = self.panelHeight > 0 ? self.panelHeight : 900.0;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.maskView.alpha = 0.0;
        self.backgroundContainer.transform = CGAffineTransformMakeTranslation(0, translationY);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
