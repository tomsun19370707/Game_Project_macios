//
//  MLChatRoomThemeGameSixGiftDialog.m
//  miliao
//

#import "MLChatRoomThemeGameSixGiftDialog.h"
#import "MLThemeGameSixGiftCell.h"
#import "Global.h"
#import <Masonry/Masonry.h>

static NSString * const kThemeGameSixGiftCellReuseID = @"MLThemeGameSixGiftCell";

@interface MLThemeGameSixTabButton : UIButton
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation MLThemeGameSixTabButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[
            (id)[UIColor colorWithRed:0xFF/255.0 green:0x8F/255.0 blue:0x00/255.0 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0xFF/255.0 green:0xD5/255.0 blue:0x4F/255.0 alpha:1.0].CGColor
        ];
        _gradientLayer.startPoint = CGPointMake(0.5, 0);
        _gradientLayer.endPoint = CGPointMake(0.5, 1);
        [self.layer insertSublayer:_gradientLayer atIndex:0];
        _gradientLayer.hidden = YES;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _gradientLayer.frame = self.bounds;
    self.layer.cornerRadius = self.bounds.size.height / 2.0;
    _gradientLayer.cornerRadius = self.bounds.size.height / 2.0;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    _gradientLayer.hidden = !selected;
    if (selected) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = 0;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(12)];
    } else {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
        self.layer.borderWidth = 0.8;
        [self setTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(12)];
    }
}

@end

@interface MLChatRoomThemeGameSixGiftDialog () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *boardContainer;
@property (nonatomic, strong) UIImageView *boardBgImageView;

// 1. HUD 容器
@property (nonatomic, strong) UIView *hudContainer;
@property (nonatomic, strong) UIButton *closeButton;

// 2. Tab 容器 (1~7 层等宽平铺)
@property (nonatomic, strong) UIView *tabContainer;
@property (nonatomic, strong) UIStackView *tabStackView;
@property (nonatomic, strong) NSMutableArray<MLThemeGameSixTabButton *> *tabButtons;

// 3. Gameplay 内容容器 (3列网格卡片)
@property (nonatomic, strong) UIView *gameplayContainer;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *emptyHintLabel;

// 数据
@property (nonatomic, strong) NSArray<MLTowerLayerInfoModel *> *layers;
@property (nonatomic, assign) NSInteger currentSelectedLayer; // 1~7
@property (nonatomic, strong) NSArray<MLTowerGiftModel *> *currentGifts;

@end

@implementation MLChatRoomThemeGameSixGiftDialog

+ (nullable instancetype)showInView:(nullable UIView *)parentView
                             layers:(nullable NSArray<MLTowerLayerInfoModel *> *)layers
                       initialLayer:(NSInteger)initialLayer {
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
    
    for (UIView *sub in targetView.subviews) {
        if ([sub isKindOfClass:[MLChatRoomThemeGameSixGiftDialog class]]) {
            return (MLChatRoomThemeGameSixGiftDialog *)sub;
        }
    }
    
    MLChatRoomThemeGameSixGiftDialog *dialog = [[MLChatRoomThemeGameSixGiftDialog alloc] initWithFrame:targetView.bounds layers:layers initialLayer:initialLayer];
    [targetView addSubview:dialog];
    [dialog animateShow];
    return dialog;
}

- (instancetype)initWithFrame:(CGRect)frame
                       layers:(nullable NSArray<MLTowerLayerInfoModel *> *)layers
                 initialLayer:(NSInteger)initialLayer {
    if (self = [super initWithFrame:frame]) {
        _layers = layers ?: @[];
        _currentSelectedLayer = (initialLayer >= 1 && initialLayer <= 7) ? initialLayer : 1;
        _tabButtons = [NSMutableArray array];
        _currentGifts = @[];
        [self setupUI];
        [self selectLayer:_currentSelectedLayer];
    }
    return self;
}

#pragma mark - UI Setup (SUAS 375x812pt & ALURS Standard)

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 0. 全屏半透明遮罩 (Alpha 0.5)
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _maskView.userInteractionEnabled = YES;
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tapMask = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tapMask];
    
    // 1. 主背板容器 (320 × 440 pt，居中)
    _boardContainer = [[UIView alloc] init];
    _boardContainer.userInteractionEnabled = YES;
    [self addSubview:_boardContainer];
    
    CGFloat boardWidth = KDialogAdaptedWidth(320);
    CGFloat boardHeight = KDialogAdaptedWidth(440);
    
    [_boardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(boardWidth, boardHeight));
    }];
    
    // 背景大图 (theme_game_six_pack_bg)
    _boardBgImageView = [[UIImageView alloc] init];
    _boardBgImageView.image = [UIImage imageNamed:@"theme_game_six_pack_bg"];
    _boardBgImageView.contentMode = UIViewContentModeScaleToFill;
    [_boardContainer addSubview:_boardBgImageView];
    [_boardBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_boardContainer);
    }];
    
    // 2. HUD 容器 (左上角关闭按钮)
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
    
    // 3. Tab 容器 (单行等宽自适应平铺 1~7 层，向下沉降至 84pt 避开金边顶框)
    _tabContainer = [[UIView alloc] init];
    [_boardContainer addSubview:_tabContainer];
    [_tabContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_boardContainer).offset(KDialogAdaptedWidth(84));
        make.leading.mas_equalTo(_boardContainer).offset(KDialogAdaptedWidth(20));
        make.trailing.mas_equalTo(_boardContainer).offset(-KDialogAdaptedWidth(20));
        make.height.mas_equalTo(KDialogAdaptedWidth(28));
    }];
    
    _tabStackView = [[UIStackView alloc] init];
    _tabStackView.axis = UILayoutConstraintAxisHorizontal;
    _tabStackView.distribution = UIStackViewDistributionFillEqually;
    _tabStackView.spacing = KDialogAdaptedWidth(4);
    [_tabContainer addSubview:_tabStackView];
    [_tabStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_tabContainer);
    }];
    
    NSArray *titles = @[@"一", @"二", @"三", @"四", @"五", @"六", @"七"];
    for (NSInteger i = 0; i < titles.count; i++) {
        MLThemeGameSixTabButton *btn = [MLThemeGameSixTabButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 1;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onTabClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_tabStackView addArrangedSubview:btn];
        [_tabButtons addObject:btn];
    }
    
    // 4. Gameplay 容器 (3列网格卡片，底部纯净留白 20pt，无多余按钮)
    _gameplayContainer = [[UIView alloc] init];
    [_boardContainer addSubview:_gameplayContainer];
    [_gameplayContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tabContainer.mas_bottom).offset(KDialogAdaptedWidth(8));
        make.leading.mas_equalTo(_boardContainer).offset(KDialogAdaptedWidth(16));
        make.trailing.mas_equalTo(_boardContainer).offset(-KDialogAdaptedWidth(16));
        make.bottom.mas_equalTo(_boardContainer).offset(-KDialogAdaptedWidth(20));
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(KDialogAdaptedWidth(86), KDialogAdaptedWidth(106));
    layout.minimumInteritemSpacing = KDialogAdaptedWidth(6);
    layout.minimumLineSpacing = KDialogAdaptedWidth(8);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[MLThemeGameSixGiftCell class] forCellWithReuseIdentifier:kThemeGameSixGiftCellReuseID];
    [_gameplayContainer addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_gameplayContainer);
    }];
    
    // 空态占位
    _emptyHintLabel = [[UILabel alloc] init];
    _emptyHintLabel.text = @"奖品池数据加载中...";
    _emptyHintLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    _emptyHintLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(12)];
    _emptyHintLabel.textAlignment = NSTextAlignmentCenter;
    _emptyHintLabel.hidden = YES;
    [_gameplayContainer addSubview:_emptyHintLabel];
    [_emptyHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_gameplayContainer);
    }];
}

#pragma mark - Tab & Layer Switching

- (void)onTabClicked:(UIButton *)sender {
    [self selectLayer:sender.tag];
}

- (void)selectLayer:(NSInteger)layer {
    if (layer < 1 || layer > 7) return;
    _currentSelectedLayer = layer;
    
    // 1. 更新 Tab 按钮选中与非选中高亮
    for (MLThemeGameSixTabButton *btn in self.tabButtons) {
        btn.selected = (btn.tag == layer);
    }
    
    // 2. 匹配对应层的 5 个奖品模型
    MLTowerLayerInfoModel *matchedLayer = nil;
    for (MLTowerLayerInfoModel *layerModel in self.layers) {
        if (layerModel.layer == layer) {
            matchedLayer = layerModel;
            break;
        }
    }
    
    if (matchedLayer && matchedLayer.gifts && matchedLayer.gifts.count > 0) {
        _currentGifts = matchedLayer.gifts;
        _emptyHintLabel.hidden = YES;
        _collectionView.hidden = NO;
    } else {
        _currentGifts = @[];
        _emptyHintLabel.hidden = NO;
        _collectionView.hidden = YES;
    }
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource & Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.currentGifts.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLThemeGameSixGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kThemeGameSixGiftCellReuseID forIndexPath:indexPath];
    if (indexPath.item < self.currentGifts.count) {
        [cell configureWithModel:self.currentGifts[indexPath.item]];
    }
    return cell;
}

#pragma mark - Actions & Animation

- (void)closeClick {
    [self dismiss];
}

- (void)animateShow {
    self.alpha = 0.0;
    _boardContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1.0;
        self.boardContainer.transform = CGAffineTransformIdentity;
    } completion:nil];
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
