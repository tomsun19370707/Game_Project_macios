//
//  MLChatRoomThemeGameSixGlobalBackpackView.m
//  miliao
//
//  玩法6（玲珑珍宝塔）全局大背包候选礼物选择弹窗
//

#import "MLChatRoomThemeGameSixGlobalBackpackView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define KDialogAdaptedWidth(val) ((val) * (MIN([UIScreen mainScreen].bounds.size.width / 375.0, [UIScreen mainScreen].bounds.size.height / 812.0)))

#pragma mark - MLThemeGameSixGlobalBackpackCell

@interface MLThemeGameSixGlobalBackpackCell : UICollectionViewCell

@property (nonatomic, strong) UIView *cardBgView;
@property (nonatomic, strong) UIImageView *cardBgImageView;
@property (nonatomic, strong) UILabel *giftNameLabel;
@property (nonatomic, strong) UIImageView *giftIconImageView;
@property (nonatomic, strong) UILabel *giftValueLabel;
@property (nonatomic, strong) UILabel *giftCountLabel;

- (void)configureWithModel:(MLCandidateItemModel *)model;

@end

@implementation MLThemeGameSixGlobalBackpackCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // 1. 卡片背景容器 (76pt x 75pt, 比例 161:159)
    _cardBgView = [[UIView alloc] init];
    [self.contentView addSubview:_cardBgView];
    [_cardBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(76), KDialogAdaptedWidth(75)));
    }];
    
    _cardBgImageView = [[UIImageView alloc] init];
    _cardBgImageView.image = [UIImage imageNamed:@"theme_game_six_global_backpack_item_bg"];
    _cardBgImageView.contentMode = UIViewContentModeScaleToFill;
    [_cardBgView addSubview:_cardBgImageView];
    [_cardBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_cardBgView);
    }];
    
    // 顶栏：礼物名称
    _giftNameLabel = [[UILabel alloc] init];
    _giftNameLabel.textColor = [UIColor whiteColor];
    _giftNameLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(9.5)];
    _giftNameLabel.textAlignment = NSTextAlignmentCenter;
    [_cardBgView addSubview:_giftNameLabel];
    [_giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(6));
        make.leading.trailing.mas_equalTo(_cardBgView);
    }];
    
    // 中间：礼物 Icon
    _giftIconImageView = [[UIImageView alloc] init];
    _giftIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_cardBgView addSubview:_giftIconImageView];
    [_giftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_cardBgView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(34), KDialogAdaptedWidth(34)));
    }];
    
    // 底栏：价值数值 (💎 800)
    _giftValueLabel = [[UILabel alloc] init];
    _giftValueLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:59.0/255.0 blue:48.0/255.0 alpha:1.0]; // 红色 #FF3B30
    _giftValueLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(9.5)];
    _giftValueLabel.textAlignment = NSTextAlignmentCenter;
    [_cardBgView addSubview:_giftValueLabel];
    [_giftValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(6));
        make.leading.trailing.mas_equalTo(_cardBgView);
    }];
    
    // 2. 礼物数量 (解耦放置在卡片容器外部正下方, marginTop = 2pt)
    _giftCountLabel = [[UILabel alloc] init];
    _giftCountLabel.textColor = [UIColor whiteColor];
    _giftCountLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(12.0)]; // 放大数字字体至 12pt
    _giftCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_giftCountLabel];
    [_giftCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cardBgView.mas_bottom).offset(KDialogAdaptedWidth(2));
        make.centerX.mas_equalTo(self.contentView);
    }];
}

- (void)configureWithModel:(MLCandidateItemModel *)model {
    if (!model) return;
    
    _giftNameLabel.text = model.name.length > 0 ? model.name : @"礼物";
    _giftCountLabel.text = [NSString stringWithFormat:@"x%ld", (long)(model.num > 0 ? model.num : 1)];
    
    NSString *valStr = model.unit_value.length > 0 ? model.unit_value : @"0";
    double valDouble = [valStr doubleValue];
    if (valDouble == (long)valDouble) {
        valStr = [NSString stringWithFormat:@"%ld", (long)valDouble];
    }
    _giftValueLabel.text = [NSString stringWithFormat:@"💎 %@", valStr];
    
    if (model.image.length > 0) {
        [_giftIconImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    } else {
        _giftIconImageView.image = nil;
    }
}

@end

#pragma mark - MLChatRoomThemeGameSixGlobalBackpackView

@interface MLChatRoomThemeGameSixGlobalBackpackView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *panelContainer;
@property (nonatomic, strong) UIImageView *panelBgImageView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *emptyHintLabel;
@property (nonatomic, strong) UIButton *clearSlotButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NSArray<MLCandidateItemModel *> *candidateGifts;
@property (nonatomic, copy) MLGlobalBackpackSelectBlock selectBlock;
@property (nonatomic, copy) MLGlobalBackpackClearBlock clearBlock;

@end

@implementation MLChatRoomThemeGameSixGlobalBackpackView

+ (void)showInView:(UIView *)parentView 
    candidateGifts:(NSArray<MLCandidateItemModel *> *)gifts 
       selectBlock:(MLGlobalBackpackSelectBlock)selectBlock 
        clearBlock:(MLGlobalBackpackClearBlock)clearBlock {
    
    if (!parentView) {
        parentView = [UIApplication sharedApplication].keyWindow;
    }
    
    // 移除已有的相同弹窗
    for (UIView *subview in parentView.subviews) {
        if ([subview isKindOfClass:[MLChatRoomThemeGameSixGlobalBackpackView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    MLChatRoomThemeGameSixGlobalBackpackView *view = [[MLChatRoomThemeGameSixGlobalBackpackView alloc] initWithFrame:parentView.bounds candidateGifts:gifts selectBlock:selectBlock clearBlock:clearBlock];
    [parentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(parentView);
    }];
    [view animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame 
               candidateGifts:(NSArray<MLCandidateItemModel *> *)gifts 
                  selectBlock:(MLGlobalBackpackSelectBlock)selectBlock 
                   clearBlock:(MLGlobalBackpackClearBlock)clearBlock {
    self = [super initWithFrame:frame];
    if (self) {
        _candidateGifts = gifts ?: @[];
        _selectBlock = [selectBlock copy];
        _clearBlock = [clearBlock copy];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 1. 全屏点击遮罩
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _maskView.userInteractionEnabled = YES;
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
    [_maskView addGestureRecognizer:maskTap];
    
    // 2. 主面板 BackgroundContainer (310pt x 538pt, 宽高比 706:1224)
    _panelContainer = [[UIView alloc] init];
    _panelContainer.userInteractionEnabled = YES;
    [self addSubview:_panelContainer];
    [_panelContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(310), KDialogAdaptedWidth(538)));
    }];
    
    // 背景大图
    _panelBgImageView = [[UIImageView alloc] init];
    _panelBgImageView.image = [UIImage imageNamed:@"theme_game_six_global_backpack_bg"];
    _panelBgImageView.contentMode = UIViewContentModeScaleToFill;
    [_panelContainer addSubview:_panelBgImageView];
    [_panelBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_panelContainer);
    }];
    
    // 3. GameplayContainer - 3 列网格 UICollectionView (Padding: L28, R28, T60, B83)
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(KDialogAdaptedWidth(76), KDialogAdaptedWidth(95)); // 75pt卡片 + 2pt间距 + 18pt数量
    layout.minimumInteritemSpacing = KDialogAdaptedWidth(4);
    layout.minimumLineSpacing = KDialogAdaptedWidth(8);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[MLThemeGameSixGlobalBackpackCell class] forCellWithReuseIdentifier:@"MLThemeGameSixGlobalBackpackCell"];
    [_panelContainer addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(60));
        make.leading.mas_equalTo(KDialogAdaptedWidth(28));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(28));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(83));
    }];
    
    // 4. 空状态提示
    _emptyHintLabel = [[UILabel alloc] init];
    _emptyHintLabel.text = @"大背包中暂无可用候选礼物~";
    _emptyHintLabel.textColor = [UIColor colorWithRed:213.0/255.0 green:154.0/255.0 blue:101.0/255.0 alpha:1.0]; // #D59A65
    _emptyHintLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(12)];
    _emptyHintLabel.textAlignment = NSTextAlignmentCenter;
    _emptyHintLabel.hidden = (_candidateGifts.count > 0);
    [_panelContainer addSubview:_emptyHintLabel];
    [_emptyHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_panelContainer);
    }];
    
    // 5. ActionContainer - 底部双控制按钮
    // 左侧【清空槽位】按钮 (86pt x 26pt, Bottom: 52pt, Leading: 36pt)
    _clearSlotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clearSlotButton setTitle:@"清空槽位" forState:UIControlStateNormal];
    [_clearSlotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; // 改为黑色
    _clearSlotButton.titleLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(12.0)]; // 放大至 12pt
    [_clearSlotButton setBackgroundImage:[UIImage imageNamed:@"bg_theme_game_fortune_entrance"] forState:UIControlStateNormal];
    [_clearSlotButton addTarget:self action:@selector(clearSlotClick) forControlEvents:UIControlEventTouchUpInside];
    [_panelContainer addSubview:_clearSlotButton];
    [_clearSlotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(36));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(52));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(86), KDialogAdaptedWidth(26)));
    }];
    
    // 右侧【取消】按钮 (68pt x 26pt, Bottom: 52pt, Trailing: 36pt)
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; // 改为黑色
    _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(12.0)]; // 放大至 12pt
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"bg_theme_game_fortune_entrance"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_panelContainer addSubview:_cancelButton];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(36));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(52));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(68), KDialogAdaptedWidth(26)));
    }];
}

#pragma mark - UICollectionViewDelegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _candidateGifts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLThemeGameSixGlobalBackpackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MLThemeGameSixGlobalBackpackCell" forIndexPath:indexPath];
    if (indexPath.item < _candidateGifts.count) {
        [cell configureWithModel:_candidateGifts[indexPath.item]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < _candidateGifts.count) {
        MLCandidateItemModel *item = _candidateGifts[indexPath.item];
        if (_selectBlock) {
            _selectBlock(item);
        }
    }
    [self animateDismiss];
}

#pragma mark - Button Actions

- (void)clearSlotClick {
    if (_clearBlock) {
        _clearBlock();
    }
    [self animateDismiss];
}

- (void)cancelClick {
    [self animateDismiss];
}

#pragma mark - Animations

- (void)animateShow {
    _panelContainer.transform = CGAffineTransformMakeScale(0.7, 0.7);
    _panelContainer.alpha = 0;
    _maskView.alpha = 0;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.panelContainer.transform = CGAffineTransformIdentity;
        self.panelContainer.alpha = 1.0;
        self.maskView.alpha = 1.0;
    } completion:nil];
}

- (void)animateDismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.panelContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.panelContainer.alpha = 0;
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
