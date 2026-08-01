//
//  MLChatRoomThemeGameSixPackDialog.m
//  miliao
//

#import "MLChatRoomThemeGameSixPackDialog.h"
#import "MLThemeGameSixPackGiftCell.h"
#import "MLThemeGameModel.h"
#import "Global.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>

static NSString * const kThemeGameSixPackCellReuseID = @"MLThemeGameSixPackGiftCell";

@interface MLChatRoomThemeGameSixPackDialog () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *boardContainer;
@property (nonatomic, strong) UIImageView *boardBgImageView;

// 1. HUD 容器
@property (nonatomic, strong) UIView *hudContainer;
@property (nonatomic, strong) UIButton *closeButton;

// 2. Gameplay 内容容器 (3列 CollectionView)
@property (nonatomic, strong) UIView *gameplayContainer;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *emptyHintLabel;

// 3. Action 操作容器
@property (nonatomic, strong) UIView *actionContainer;
@property (nonatomic, strong) UIButton *selectAllButton;
@property (nonatomic, strong) UIButton *withdrawActionButton;

// 数据集合
@property (nonatomic, strong) NSMutableArray<MLTowerGameSixTempInventoryModel *> *dataList;
@property (nonatomic, strong) NSMutableSet<MLTowerGameSixTempInventoryModel *> *selectedSet;

@end

@implementation MLChatRoomThemeGameSixPackDialog

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
    
    MLChatRoomThemeGameSixPackDialog *dialog = [[MLChatRoomThemeGameSixPackDialog alloc] initWithFrame:targetView.bounds];
    [targetView addSubview:dialog];
    [dialog animateShow];
    return dialog;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _dataList = [NSMutableArray array];
        _selectedSet = [NSMutableSet set];
        [self setupUI];
        [self loadTempInventory];
    }
    return self;
}

- (void)loadTempInventory {
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [[MLThemeGameModel sharedInstance] fetchTowerGameSixTempInventoryWithSuccess:^(id _Nullable responseObj) {
        [SVProgressHUD dismiss];
        [weakSelf.dataList removeAllObjects];
        [weakSelf.selectedSet removeAllObjects];
        
        if ([responseObj isKindOfClass:[NSArray class]]) {
            [weakSelf.dataList addObjectsFromArray:responseObj];
        }
        
        weakSelf.emptyHintLabel.hidden = (weakSelf.dataList.count > 0);
        weakSelf.collectionView.hidden = (weakSelf.dataList.count == 0);
        [weakSelf.collectionView reloadData];
        [weakSelf updateSelectAllButtonState];
    } failure:^(NSError * _Nonnull error, NSString * _Nullable msg) {
        [SVProgressHUD dismiss];
        weakSelf.emptyHintLabel.hidden = NO;
        weakSelf.collectionView.hidden = YES;
        [SVProgressHUD showInfoWithStatus:msg ?: @"加载暂存包失败"];
    }];
}

- (void)updateSelectAllButtonState {
    BOOL isAll = (self.dataList.count > 0 && self.selectedSet.count == self.dataList.count);
    [self.selectAllButton setTitle:isAll ? @"取消全选" : @"全选" forState:UIControlStateNormal];
}

#pragma mark - UI Setup (SUAS 375x812pt & ALURS Standard)

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
    
    // 1. 主背板容器 (330pt 宽，按弹窗背景图片比例 330:480 缩放)
    _boardContainer = [[UIView alloc] init];
    _boardContainer.userInteractionEnabled = YES;
    [self addSubview:_boardContainer];
    
    CGFloat boardWidth = KDialogAdaptedWidth(330);
    CGFloat boardHeight = boardWidth * (480.0 / 330.0);
    
    [_boardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(boardWidth, boardHeight));
    }];
    
    // 背景大图 (theme_game_six_pack_bg / 弹窗背景.png)
    _boardBgImageView = [[UIImageView alloc] init];
    _boardBgImageView.image = [UIImage imageNamed:@"theme_game_six_pack_bg"];
    _boardBgImageView.contentMode = UIViewContentModeScaleToFill;
    [_boardContainer addSubview:_boardBgImageView];
    [_boardBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_boardContainer);
    }];
    
    // 1.1 HUD 容器 (左上角关闭按钮)
    _hudContainer = [[UIView alloc] init];
    [_boardContainer addSubview:_hudContainer];
    [_hudContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(_boardContainer);
        make.height.mas_equalTo(KDialogAdaptedWidth(50));
    }];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"theme_game_six_pack_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_hudContainer addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(8));
        make.leading.mas_equalTo(KDialogAdaptedWidth(8));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(32), KDialogAdaptedWidth(32)));
    }];
    
    // 2. Action 决策容器 (底部全选与取回按钮)
    _actionContainer = [[UIView alloc] init];
    [_boardContainer addSubview:_actionContainer];
    [_actionContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_boardContainer).offset(-KDialogAdaptedWidth(26));
        make.leading.trailing.mas_equalTo(_boardContainer);
        make.height.mas_equalTo(KDialogAdaptedWidth(44));
    }];
    
    // 2.1 全选复选按钮
    _selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
    [_selectAllButton setTitleColor:[UIColor colorWithRed:0x44/255.0 green:0x22/255.0 blue:0x11/255.0 alpha:1.0] forState:UIControlStateNormal];
    _selectAllButton.titleLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(14)];
    [_selectAllButton addTarget:self action:@selector(selectAllClick) forControlEvents:UIControlEventTouchUpInside];
    [_actionContainer addSubview:_selectAllButton];
    [_selectAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_actionContainer);
        make.leading.mas_equalTo(_actionContainer).offset(KDialogAdaptedWidth(30));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(80), KDialogAdaptedWidth(36)));
    }];
    
    // 2.2 取回礼物按钮 (theme_game_six_btn_withdraw / 取回礼物.png)
    _withdrawActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_withdrawActionButton setBackgroundImage:[UIImage imageNamed:@"theme_game_six_btn_withdraw"] forState:UIControlStateNormal];
    _withdrawActionButton.contentMode = UIViewContentModeScaleToFill;
    [_withdrawActionButton addTarget:self action:@selector(withdrawClick) forControlEvents:UIControlEventTouchUpInside];
    [_actionContainer addSubview:_withdrawActionButton];
    [_withdrawActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_actionContainer);
        make.trailing.mas_equalTo(_actionContainer).offset(-KDialogAdaptedWidth(26));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(126), KDialogAdaptedWidth(36)));
    }];
    
    // 3. Gameplay 内容区 (3列 CollectionView)
    _gameplayContainer = [[UIView alloc] init];
    [_boardContainer addSubview:_gameplayContainer];
    [_gameplayContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_hudContainer.mas_bottom).offset(KDialogAdaptedWidth(28));
        make.bottom.mas_equalTo(_actionContainer.mas_top).offset(-KDialogAdaptedWidth(10));
        make.leading.mas_equalTo(_boardContainer).offset(KDialogAdaptedWidth(20));
        make.trailing.mas_equalTo(_boardContainer).offset(-KDialogAdaptedWidth(20));
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = KDialogAdaptedWidth(8);
    layout.minimumInteritemSpacing = KDialogAdaptedWidth(6);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[MLThemeGameSixPackGiftCell class] forCellWithReuseIdentifier:kThemeGameSixPackCellReuseID];
    [_gameplayContainer addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_gameplayContainer);
    }];
    
    // 空数据提示
    _emptyHintLabel = [[UILabel alloc] init];
    _emptyHintLabel.text = @"暂存背包空空如也~";
    _emptyHintLabel.textColor = [UIColor colorWithRed:0x88/255.0 green:0x66/255.0 blue:0x44/255.0 alpha:1.0];
    _emptyHintLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(13)];
    _emptyHintLabel.textAlignment = NSTextAlignmentCenter;
    _emptyHintLabel.hidden = YES;
    [_gameplayContainer addSubview:_emptyHintLabel];
    [_emptyHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_gameplayContainer);
    }];
}

#pragma mark - UICollectionView Delegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLThemeGameSixPackGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kThemeGameSixPackCellReuseID forIndexPath:indexPath];
    if (indexPath.item < self.dataList.count) {
        MLTowerGameSixTempInventoryModel *model = self.dataList[indexPath.item];
        BOOL isSelected = [self.selectedSet containsObject:model];
        [cell configureWithModel:model isSelected:isSelected];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat totalW = KDialogAdaptedWidth(290);
    CGFloat cellW = (totalW - KDialogAdaptedWidth(12)) / 3.0;
    CGFloat cellH = cellW * (108.0 / 88.0);
    return CGSizeMake(cellW, cellH);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataList.count) {
        MLTowerGameSixTempInventoryModel *model = self.dataList[indexPath.item];
        if ([self.selectedSet containsObject:model]) {
            [self.selectedSet removeObject:model];
        } else {
            [self.selectedSet addObject:model];
        }
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [self updateSelectAllButtonState];
    }
}

#pragma mark - User Actions

- (void)selectAllClick {
    BOOL isAll = (self.dataList.count > 0 && self.selectedSet.count == self.dataList.count);
    [self.selectedSet removeAllObjects];
    if (!isAll) {
        [self.selectedSet addObjectsFromArray:self.dataList];
    }
    [self.collectionView reloadData];
    [self updateSelectAllButtonState];
}

- (void)withdrawClick {
    if (self.selectedSet.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请先选择需要提取的礼物"];
        return;
    }
    
    NSMutableArray *itemsArr = [NSMutableArray array];
    for (MLTowerGameSixTempInventoryModel *item in self.selectedSet) {
        [itemsArr addObject:@{
            @"inventory_id": @(item.inventory_id),
            @"num": @(item.num > 0 ? item.num : 1)
        }];
    }
    
    [SVProgressHUD showWithStatus:@"正在提取礼物..."];
    __weak typeof(self) weakSelf = self;
    [[MLThemeGameModel sharedInstance] withdrawTowerGameSixTempGiftsWithItems:itemsArr success:^(id _Nullable responseObj) {
        [SVProgressHUD showSuccessWithStatus:@"✨ 提取成功！礼物已成功放入全局大背包"];
        if (weakSelf.onWithdrawSuccessBlock) {
            weakSelf.onWithdrawSuccessBlock();
        }
        [weakSelf loadTempInventory];
    } failure:^(NSError * _Nonnull error, NSString * _Nullable msg) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:msg ?: @"提取失败，请重试"];
    }];
}

- (void)closeClick {
    [self dismiss];
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

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.boardContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
