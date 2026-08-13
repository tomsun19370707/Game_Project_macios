//
//  MLChatRoomThemeGameFiveGiftView.m
//  miliao
//

#import "MLChatRoomThemeGameFiveGiftView.h"
#import "Global.h"
#import <Masonry/Masonry.h>

// ============================================================================
// MLChatRoomThemeGameFiveGiftCell (Grid item for each gift)
// ============================================================================
@interface MLChatRoomThemeGameFiveGiftCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *cellBg;
@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *badgeBgView;
@property (nonatomic, strong) UILabel *probabilityLabel;

- (void)configureWithModel:(MLGameDrawResultModel *)model;

@end

@implementation MLChatRoomThemeGameFiveGiftCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];

    _cellBg = [[UIImageView alloc] init];
    _cellBg.image = [UIImage imageNamed:@"theme_game_five_gift_cell_bg"];
    _cellBg.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_cellBg];
    [_cellBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];

    _giftImageView = [[UIImageView alloc] init];
    _giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_giftImageView];
    [_giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(14));
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(46), KDialogAdaptedWidth(46)));
    }];

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = kWhiteColor;
    _nameLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(9)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_giftImageView.mas_bottom).offset(KDialogAdaptedWidth(5));
        make.leading.trailing.mas_equalTo(self.contentView);
    }];

    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = mHexRGB(0x61D0FF); // Light blue
    _priceLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(8.5)];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(KDialogAdaptedWidth(3));
        make.leading.trailing.mas_equalTo(self.contentView);
    }];

    // 右上角概率角标挂载 (SUAS 375pt Masonry 布局)
    _badgeBgView = [[UIImageView alloc] init];
    _badgeBgView.image = [UIImage imageNamed:@"theme_game_five_gift_badge_bg"];
    _badgeBgView.contentMode = UIViewContentModeScaleToFill;
    _badgeBgView.hidden = YES;
    [self.contentView addSubview:_badgeBgView];
    [_badgeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(32), KDialogAdaptedWidth(12)));
    }];

    _probabilityLabel = [[UILabel alloc] init];
    _probabilityLabel.textColor = kWhiteColor;
    _probabilityLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(6.5)];
    _probabilityLabel.textAlignment = NSTextAlignmentCenter;
    _probabilityLabel.adjustsFontSizeToFitWidth = YES;
    _probabilityLabel.minimumScaleFactor = 0.6;
    [_badgeBgView addSubview:_probabilityLabel];
    [_probabilityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_badgeBgView);
    }];
}

- (void)configureWithModel:(MLGameDrawResultModel *)model {
    _nameLabel.text = model.name;
    _priceLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)model.price];

    NSURL *url = [NSURL URLWithString:[model imageUrl]];
    if ([_giftImageView respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
        [_giftImageView performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@"theme_game_five_placeholder"]];
    } else {
        _giftImageView.image = [UIImage imageNamed:@"theme_game_five_placeholder"];
    }

    NSString *probStr = [model displayProbability];
    if (probStr && probStr.length > 0) {
        _badgeBgView.hidden = NO;
        _probabilityLabel.text = probStr;
    } else {
        _badgeBgView.hidden = YES;
    }
}

@end

// ============================================================================
// MLChatRoomThemeGameFiveGiftView Main Implementation
// ============================================================================
@interface MLChatRoomThemeGameFiveGiftView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *prizes;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *backgroundContainer;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation MLChatRoomThemeGameFiveGiftView

+ (void)showInView:(UIView *)parentView typeId:(NSInteger)typeId prizes:(NSArray<MLGameDrawResultModel *> *)prizes {
    // Avoid duplicated dialog views
    for (UIView *subview in parentView.subviews) {
        if ([subview isKindOfClass:[MLChatRoomThemeGameFiveGiftView class]]) {
            return;
        }
    }

    MLChatRoomThemeGameFiveGiftView *giftView = [[MLChatRoomThemeGameFiveGiftView alloc] initWithFrame:parentView.bounds typeId:typeId prizes:prizes];
    [parentView addSubview:giftView];
    [giftView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame typeId:(NSInteger)typeId prizes:(NSArray<MLGameDrawResultModel *> *)prizes {
    if (self = [super initWithFrame:frame]) {
        self.typeId = typeId;
        self.prizes = prizes;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];

    // 1. Semi-transparent black mask view
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tap];

    // 2. Aspect-ratio locked container centered on screen (740:944 ratio, capped width 310 pt)
    _backgroundContainer = [[UIView alloc] init];
    _backgroundContainer.backgroundColor = [UIColor clearColor];
    [self addSubview:_backgroundContainer];
    [_backgroundContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.85).priorityMedium();
        make.width.mas_lessThanOrEqualTo(KDialogAdaptedWidth(310)).priorityHigh();
        make.height.mas_equalTo(_backgroundContainer.mas_width).multipliedBy(944.0 / 740.0);
    }];

    // 2.1 Background Image
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_five_gift_popup_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [_backgroundContainer addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_backgroundContainer);
    }];

    // 2.2 Close Button
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"theme_game_five_gift_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundContainer addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(35));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(30));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(20), KDialogAdaptedWidth(20)));
    }];

    // 2.3 Grid collection view
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(KDialogAdaptedWidth(77), KDialogAdaptedWidth(101));
    layout.minimumLineSpacing = KDialogAdaptedWidth(8);
    layout.minimumInteritemSpacing = KDialogAdaptedWidth(6);
    layout.sectionInset = UIEdgeInsetsZero;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[MLChatRoomThemeGameFiveGiftCell class] forCellWithReuseIdentifier:@"MLChatRoomThemeGameFiveGiftCell"];
    [_backgroundContainer addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_backgroundContainer);
        make.top.mas_equalTo(KDialogAdaptedWidth(115));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(45));
        make.width.mas_equalTo(KDialogAdaptedWidth(243));
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.prizes.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLChatRoomThemeGameFiveGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MLChatRoomThemeGameFiveGiftCell" forIndexPath:indexPath];
    if (indexPath.item < self.prizes.count) {
        [cell configureWithModel:self.prizes[indexPath.item]];
    }
    return cell;
}

#pragma mark - Show / Dismiss Animations

- (void)animateShow {
    self.alpha = 0;
    _backgroundContainer.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
        self.backgroundContainer.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)closeClick {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0;
        self.backgroundContainer.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
