//
//  MLChatRoomGameCenterDialog.m
//  miliao
//
//  Created by AI Assistant on 2026/9/3.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "MLChatRoomGameCenterDialog.h"
#import "MLChatRoomGameCenterCell.h"
#import "MLChatRoomGameCenterItem.h"

// Game Views
#import "MLChatRoomThemeGameOneView.h"
#import "MLChatRoomThemeGameTwoView.h"
#import "MLChatRoomThemeGameThreeView.h"
#import "MLChatRoomThemeGameFourView.h"
#import "MLChatRoomThemeGameFiveView.h"
#import "MLChatRoomThemeGameSixView.h"
#import "RunGamaViewController.h"
#import "ZXNavigationController.h"
#import "SRWKWebViewController.h"
#import "CFMultiplierGamesVC.h"

#import "FFHomeHandel.h"
#import "DZCX_NetAPIPaths.h"
#import "AppDelegate.h"
#import "ObjectTool.h"
#import "Global.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD.h>

@interface MLChatRoomGameCenterDialog () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *panelContainer;
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIButton *tabAllBtn;
@property (nonatomic, strong) UIButton *tabEntertainmentBtn;
@property (nonatomic, strong) UIButton *tabFunBtn;
@property (nonatomic, strong) UIStackView *tabStackView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<MLChatRoomGameCenterItem *> *nativeItems;
@property (nonatomic, strong) NSMutableArray<MLChatRoomGameCenterItem *> *h5Items;
@property (nonatomic, strong) NSMutableArray<MLChatRoomGameCenterItem *> *allItems;
@property (nonatomic, strong) NSMutableArray<MLChatRoomGameCenterItem *> *displayItems;

@property (nonatomic, assign) NSInteger currentTabIndex; // 0: 全部, 1: 娱乐, 2: 趣味

@end

@implementation MLChatRoomGameCenterDialog

+ (void)showInView:(nullable UIView *)parentView {
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
        targetView = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    }
    if (!targetView) return;
    
    MLChatRoomGameCenterDialog *dialog = [[MLChatRoomGameCenterDialog alloc] initWithFrame:targetView.bounds];
    [targetView addSubview:dialog];
    [dialog animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _nativeItems = [NSMutableArray array];
        _h5Items = [NSMutableArray array];
        _allItems = [NSMutableArray array];
        _displayItems = [NSMutableArray array];
        _currentTabIndex = 0;
        
        [self setupNativeItems];
        [self setupUI];
        [self selectTabWithIndex:0];
        [self fetchH5LotteryDisks];
    }
    return self;
}

#pragma mark - 1. 构建原生 9 款展开玩法
- (void)setupNativeItems {
    [_nativeItems removeAllObjects];
    
    // 6 大原生玩法 + 动物赛跑
    [_nativeItems addObject:[MLChatRoomGameCenterItem nativeItemWithName:@"寻梦之旅"
                                                           localIconName:@"native_game_one_preview"
                                                                    type:1
                                                               bagTypeId:0
                                                                category:MLChatRoomGameCategoryEntertainment]];
    
    [_nativeItems addObject:[MLChatRoomGameCenterItem nativeItemWithName:@"神木栖灵"
                                                           localIconName:@"theme_game_two_entry_icon"
                                                                    type:2
                                                               bagTypeId:0
                                                                category:MLChatRoomGameCategoryEntertainment]];
    
    [_nativeItems addObject:[MLChatRoomGameCenterItem nativeItemWithName:@"星辰序章"
                                                           localIconName:@"theme_game_three_entry_icon"
                                                                    type:3
                                                               bagTypeId:0
                                                                category:MLChatRoomGameCategoryEntertainment]];
    
    [_nativeItems addObject:[MLChatRoomGameCenterItem nativeItemWithName:@"奇妙星球"
                                                           localIconName:@"theme_game_five_entry_icon"
                                                                    type:5
                                                               bagTypeId:0
                                                                category:MLChatRoomGameCategoryEntertainment]];
    
    [_nativeItems addObject:[MLChatRoomGameCenterItem nativeItemWithName:@"玲珑珍宝塔"
                                                           localIconName:@"theme_game_six_entry_icon"
                                                                    type:6
                                                               bagTypeId:0
                                                                category:MLChatRoomGameCategoryEntertainment]];
    
    [_nativeItems addObject:[MLChatRoomGameCenterItem nativeItemWithName:@"动物赛跑"
                                                           localIconName:@"UY_Saipao"
                                                                    type:7
                                                               bagTypeId:0
                                                                category:MLChatRoomGameCategoryEntertainment]];
    
    // ⭐️ 扁平化展开三色福袋独立子项
    [_nativeItems addObject:[MLChatRoomGameCenterItem nativeItemWithName:@"青玉福袋"
                                                           localIconName:@"theme_game_four_bag_green"
                                                                    type:4
                                                               bagTypeId:8
                                                                category:MLChatRoomGameCategoryEntertainment]];
    
    [_nativeItems addObject:[MLChatRoomGameCenterItem nativeItemWithName:@"碧海福袋"
                                                           localIconName:@"theme_game_four_bag_blue"
                                                                    type:4
                                                               bagTypeId:9
                                                                category:MLChatRoomGameCategoryEntertainment]];
    
    [_nativeItems addObject:[MLChatRoomGameCenterItem nativeItemWithName:@"鎏金福袋"
                                                           localIconName:@"theme_game_four_bag_yellow"
                                                                    type:4
                                                               bagTypeId:10
                                                                category:MLChatRoomGameCategoryEntertainment]];
    
    [self rebuildAllItems];
}

#pragma mark - 2. 异步拉取后端 H5 抽奖盘与倍率盘并平铺
- (void)fetchH5LotteryDisks {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"page_size"] = @"1000";
    parameter[@"page"] = @"1";
    
    WeakSelf;
    // 1. H5 抽奖盘列表
    [FFHomeHandel customeNoPageListRequestHandle:parameter apiStr:lottery_get_rooms success:^(NSMutableArray<NSDictionary *> *dataArr) {
        if (dataArr && [dataArr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in dataArr) {
                if (![dict isKindOfClass:[NSDictionary class]]) continue;
                NSInteger gameId = [dict[@"id"] integerValue];
                NSString *name = dict[@"name"] ?: @"H5抽奖盘";
                NSString *imgUrl = dict[@"image"] ?: @"";
                // 过滤 id < 8 且非旧版寻梦的 H5 抽奖盘
                if (gameId < 8 && ![name containsString:@"寻梦"]) {
                    [wself.h5Items addObject:[MLChatRoomGameCenterItem remoteItemWithName:name
                                                                                 imageUrl:imgUrl
                                                                                     type:8
                                                                                 h5DiskId:[NSString stringWithFormat:@"%ld", (long)gameId]
                                                                           multiplierMode:0
                                                                                 category:MLChatRoomGameCategoryFun
                                                                                  rawDict:dict]];
                }
            }
            [wself rebuildAllItems];
            [wself selectTabWithIndex:wself.currentTabIndex];
        }
    } failure:^{
    }];
    
    // 2. 倍率盘列表
    [FFHomeHandel customeNoPageListRequestHandle:parameter apiStr:lottery_get_rooms_new success:^(NSMutableArray<NSDictionary *> *dataArr) {
        if (dataArr && [dataArr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in dataArr) {
                if (![dict isKindOfClass:[NSDictionary class]]) continue;
                NSInteger gameId = [dict[@"id"] integerValue];
                NSString *name = dict[@"name"] ?: @"倍率盘";
                NSString *imgUrl = dict[@"image"] ?: @"";
                NSInteger mode = [dict[@"mode"] integerValue];
                [wself.h5Items addObject:[MLChatRoomGameCenterItem remoteItemWithName:name
                                                                             imageUrl:imgUrl
                                                                                 type:9
                                                                             h5DiskId:[NSString stringWithFormat:@"%ld", (long)gameId]
                                                                       multiplierMode:mode
                                                                             category:MLChatRoomGameCategoryFun
                                                                              rawDict:dict]];
            }
            [wself rebuildAllItems];
            [wself selectTabWithIndex:wself.currentTabIndex];
        }
    } failure:^{
    }];
}

- (void)rebuildAllItems {
    [_allItems removeAllObjects];
    [_allItems addObjectsFromArray:_nativeItems];
    [_allItems addObjectsFromArray:_h5Items];
}

#pragma mark - 3. UI 布局 (SUAS / CVCS 语义容器系统规范)
- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 1. 半透明黑色遮罩
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _maskView.userInteractionEnabled = YES;
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tapMask = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMaskTapped)];
    [_maskView addGestureRecognizer:tapMask];
    
    // 2. 固定比例机甲面板容器 (608:859 真实切图比例自适应，最大宽 344 pt)
    _panelContainer = [[UIView alloc] init];
    _panelContainer.backgroundColor = [UIColor clearColor];
    _panelContainer.userInteractionEnabled = YES;
    [self addSubview:_panelContainer];
    
    CGFloat panelWidth = MIN(ScreenWidth - KAdaptedWidth(32), 344.0);
    [_panelContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(panelWidth);
        make.height.mas_equalTo(self.panelContainer.mas_width).multipliedBy(859.0 / 608.0);
    }];
    
    // 3. 机甲底图 (铺满面板，ScaleToFill 绝不变形)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"bg_chat_room_game_center_dialog"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [_panelContainer addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.panelContainer);
    }];
    
    // 4. 顶部 Tab 锚定参考标尺 (14.2% 面板高度，避开顶部金属发光标题)
    UIView *tabGuideView = [[UIView alloc] init];
    tabGuideView.userInteractionEnabled = NO;
    tabGuideView.hidden = YES;
    [_panelContainer addSubview:tabGuideView];
    [tabGuideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.panelContainer);
        make.height.mas_equalTo(self.panelContainer).multipliedBy(0.142);
    }];
    
    // 5. 顶部 Tab 栏：全部 / 娱乐 / 趣味
    _tabAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tabAllBtn setImage:[UIImage imageNamed:@"tab_game_center_all"] forState:UIControlStateNormal];
    _tabAllBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_tabAllBtn addTarget:self action:@selector(onTabAllClick) forControlEvents:UIControlEventTouchUpInside];
    
    _tabEntertainmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tabEntertainmentBtn setImage:[UIImage imageNamed:@"tab_game_center_entertainment"] forState:UIControlStateNormal];
    _tabEntertainmentBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_tabEntertainmentBtn addTarget:self action:@selector(onTabEntertainmentClick) forControlEvents:UIControlEventTouchUpInside];
    
    _tabFunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tabFunBtn setImage:[UIImage imageNamed:@"tab_game_center_fun"] forState:UIControlStateNormal];
    _tabFunBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_tabFunBtn addTarget:self action:@selector(onTabFunClick) forControlEvents:UIControlEventTouchUpInside];
    
    _tabStackView = [[UIStackView alloc] initWithArrangedSubviews:@[_tabAllBtn, _tabEntertainmentBtn, _tabFunBtn]];
    _tabStackView.axis = UILayoutConstraintAxisHorizontal;
    _tabStackView.spacing = KAdaptedWidth(8);
    _tabStackView.distribution = UIStackViewDistributionFillEqually;
    [_panelContainer addSubview:_tabStackView];
    
    [_tabStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tabGuideView.mas_bottom);
        make.left.mas_equalTo(self.panelContainer).offset(KAdaptedWidth(16));
        make.right.mas_equalTo(self.panelContainer).offset(KAdaptedWidth(-16));
        make.height.mas_equalTo(KAdaptedWidth(32));
    }];
    
    // 6. 3 列网格 CollectionView 列表视口
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = KAdaptedWidth(6);
    layout.minimumLineSpacing = KAdaptedWidth(8);
    // 动态计算 itemSize 以精准填满 3 列
    CGFloat usableWidth = panelWidth - KAdaptedWidth(32); // 左右留白各 16
    CGFloat itemW = floor((usableWidth - KAdaptedWidth(12)) / 3.0); // 2 个间距 6
    CGFloat itemH = floor(itemW * (96.0 / 88.0));
    layout.itemSize = CGSizeMake(itemW, itemH);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[MLChatRoomGameCenterCell class] forCellWithReuseIdentifier:@"MLChatRoomGameCenterCell"];
    [_panelContainer addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tabStackView.mas_bottom).offset(KAdaptedWidth(10));
        make.left.mas_equalTo(self.panelContainer).offset(KAdaptedWidth(16));
        make.right.mas_equalTo(self.panelContainer).offset(KAdaptedWidth(-16));
        make.bottom.mas_equalTo(self.panelContainer).offset(KAdaptedWidth(-18));
    }];
}

#pragma mark - 4. Tab 切换
- (void)selectTabWithIndex:(NSInteger)index {
    _currentTabIndex = index;
    _tabAllBtn.alpha = (index == 0) ? 1.0 : 0.45;
    _tabEntertainmentBtn.alpha = (index == 1) ? 1.0 : 0.45;
    _tabFunBtn.alpha = (index == 2) ? 1.0 : 0.45;
    
    [_displayItems removeAllObjects];
    if (index == 0) {
        [_displayItems addObjectsFromArray:_allItems];
    } else if (index == 1) {
        for (MLChatRoomGameCenterItem *item in _allItems) {
            if (item.category == MLChatRoomGameCategoryEntertainment) {
                [_displayItems addObject:item];
            }
        }
    } else if (index == 2) {
        for (MLChatRoomGameCenterItem *item in _allItems) {
            if (item.category == MLChatRoomGameCategoryFun) {
                [_displayItems addObject:item];
            }
        }
    }
    [_collectionView reloadData];
}

- (void)onTabAllClick { [self selectTabWithIndex:0]; }
- (void)onTabEntertainmentClick { [self selectTabWithIndex:1]; }
- (void)onTabFunClick { [self selectTabWithIndex:2]; }

#pragma mark - 5. CollectionView 代理与路由一键直达
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _displayItems.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLChatRoomGameCenterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MLChatRoomGameCenterCell" forIndexPath:indexPath];
    if (indexPath.item < _displayItems.count) {
        [cell configWithItem:_displayItems[indexPath.item]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item >= _displayItems.count) return;
    MLChatRoomGameCenterItem *item = _displayItems[indexPath.item];
    if (!item.isEnabled) return;
    
    UIView *parent = self.superview;
    [self animateDismissWithCompletion:^{
        [self launchGameWithItem:item parentView:parent];
    }];
}

- (void)launchGameWithItem:(MLChatRoomGameCenterItem *)item parentView:(UIView *)parentView {
    switch (item.type) {
        case 1: // 寻梦之旅
            [MLChatRoomThemeGameOneView showInView:parentView typeId:11];
            break;
        case 2: // 神木栖灵
            [MLChatRoomThemeGameTwoView showInView:parentView typeId:12];
            break;
        case 3: // 星辰序章
            [MLChatRoomThemeGameThreeView showInView:parentView typeId:13];
            break;
        case 4: // 三色福袋直达 (青玉 8 / 碧海 9 / 鎏金 10)
            [MLChatRoomThemeGameFourView showInView:parentView typeId:(item.bagTypeId > 0 ? item.bagTypeId : 8)];
            break;
        case 5: // 奇妙星球
            [MLChatRoomThemeGameFiveView showInView:parentView typeId:14];
            break;
        case 6: // 玲珑珍宝塔
            [MLChatRoomThemeGameSixView showInView:parentView typeId:15];
            break;
        case 7: { // 动物赛跑
            RunGamaViewController *vc = [[RunGamaViewController alloc] initWithInfoDic:@{}];
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            ZXNavigationController *nav = [[ZXNavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [[ObjectTool SharedSettings].currentVC presentViewController:nav animated:NO completion:nil];
            break;
        }
        case 8: { // H5 网页抽奖盘直达 (全屏展开)
            NSString *token = UserDefaultsGet(kToken) ?: @"";
            NSString *url = [NSString stringWithFormat:@"%@?token=%@&id=%@", lottery_lottery_h5, token, item.h5DiskId ?: @"1"];
            SRWKWebViewController *load = [[SRWKWebViewController alloc] init];
            load.mainURL = url;
            load.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            [[ObjectTool SharedSettings].currentVC addChildViewController:load];
            [load showInView:[ObjectTool SharedSettings].currentVC.view];
            break;
        }
        case 9: { // 倍率盘直达
            CFMultiplierGamesVC *re = [[CFMultiplierGamesVC alloc] init];
            re.rewardId = item.h5DiskId ?: @"1";
            re.vcType = (int)item.multiplierMode;
            re.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            [[ObjectTool SharedSettings].currentVC addChildViewController:re];
            [re showInView:[ObjectTool SharedSettings].currentVC.view];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 6. 动画显示与隐藏
- (void)animateShow {
    self.panelContainer.transform = CGAffineTransformMakeScale(0.85, 0.85);
    self.panelContainer.alpha = 0.0;
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.panelContainer.transform = CGAffineTransformIdentity;
        self.panelContainer.alpha = 1.0;
    } completion:nil];
}

- (void)animateDismissWithCompletion:(nullable void (^)(void))completion {
    [UIView animateWithDuration:0.2 animations:^{
        self.panelContainer.transform = CGAffineTransformMakeScale(0.85, 0.85);
        self.panelContainer.alpha = 0.0;
        self.maskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) completion();
    }];
}

- (void)onMaskTapped {
    [self animateDismissWithCompletion:nil];
}

@end
