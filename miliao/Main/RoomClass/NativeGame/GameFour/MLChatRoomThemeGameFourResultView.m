#import "MLChatRoomThemeGameFourResultView.h"
#import "Global.h"
#import <Masonry/Masonry.h>

@interface MLChatRoomThemeGameFourResultView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *panelContainer;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *contentClippingContainer;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *gridContainer;

@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *mergedGifts;
@property (nonatomic, assign) NSInteger totalValue;
@property (nonatomic, copy) void(^retryBlock)(void);

@end

@implementation MLChatRoomThemeGameFourResultView

+ (void)showInView:(UIView *)parentView 
             gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
        totalValue:(NSInteger)value 
        retryBlock:(void(^ _Nullable)(void))retry {
    MLChatRoomThemeGameFourResultView *resultView = [[MLChatRoomThemeGameFourResultView alloc] initWithFrame:parentView.bounds 
                                                                                                    gifts:gifts 
                                                                                               totalValue:value 
                                                                                               retryBlock:retry];
    [parentView addSubview:resultView];
    [resultView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame 
                        gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
                   totalValue:(NSInteger)value 
                   retryBlock:(void(^ _Nullable)(void))retry {
    if (self = [super initWithFrame:frame]) {
        self.retryBlock = retry;
        self.totalValue = value;
        // 1. 合并相同礼物的数量并按价值降序排列
        self.mergedGifts = [MLGameDrawResultModel mergeAndSortDrawGifts:gifts];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 1. 遮罩层
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tap];
    
    // 2. 主画框容器 (按背景图.png 750:730 真实像素长宽比锁定)
    _panelContainer = [[UIView alloc] init];
    _panelContainer.backgroundColor = [UIColor clearColor];
    _panelContainer.userInteractionEnabled = YES;
    [self addSubview:_panelContainer];
    [_panelContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.85).priorityMedium();
        make.width.mas_lessThanOrEqualTo(KDialogAdaptedWidth(320)).priorityHigh();
        make.height.mas_equalTo(_panelContainer.mas_width).multipliedBy(730.0 / 750.0);
    }];
    
    // 3. 内部裁剪容器
    _contentClippingContainer = [[UIView alloc] init];
    _contentClippingContainer.clipsToBounds = YES;
    [_panelContainer addSubview:_contentClippingContainer];
    [_contentClippingContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_panelContainer);
    }];
    
    // 4. 新中奖战报主画框背景图 (theme_game_four_new_result_main_bg: 750x730)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_four_new_result_main_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_contentClippingContainer addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_contentClippingContainer);
    }];
    
    // 5. 右上角关闭交互热区 (44×44pt)
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_panelContainer addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentClippingContainer.mas_top);
        make.trailing.mas_equalTo(_contentClippingContainer.mas_trailing);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(44), KDialogAdaptedWidth(44)));
    }];
    
    // 6. 内容滚动区 (top 110pt, bottom 20pt, margin 16pt)
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical = YES;
    [_contentClippingContainer addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(110));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(20));
        make.leading.mas_equalTo(KDialogAdaptedWidth(16));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(16));
    }];
    
    [self layoutResultGifts];
    
    UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [retryButton setImage:[UIImage imageNamed:@"theme_game_four_result_retry_btn"] forState:UIControlStateNormal];
    retryButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [retryButton addTarget:self action:@selector(retryClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:retryButton];
    [retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_panelContainer.mas_bottom).offset(KDialogAdaptedWidth(12.0f));
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(130.0f), KDialogAdaptedWidth(72.0f)));
    }];
}

- (void)layoutResultGifts {
    if (!self.mergedGifts || self.mergedGifts.count == 0) return;
    
    NSInteger size = self.mergedGifts.count;
    // 依中奖种数自适应列数：1种 -> 1列；2种 -> 2列；3种及以上 -> 3列
    NSInteger cols = (size == 1) ? 1 : ((size == 2) ? 2 : 3);
    NSInteger rows = (size + cols - 1) / cols;
    
    // 按 礼物背景.png 353:346 真实长宽比卡片尺寸 (58x56.8pt)，扩大行列间距 (colGap 18pt, rowGap 20pt)
    CGFloat itemW = KDialogAdaptedWidth(58.0f);
    CGFloat itemH = KDialogAdaptedWidth(56.8f);
    CGFloat iconSize = KDialogAdaptedWidth(30.0f);
    CGFloat colGap = KDialogAdaptedWidth(18.0f);
    CGFloat rowGap = KDialogAdaptedWidth(20.0f);
    
    _gridContainer = [[UIView alloc] init];
    _gridContainer.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_gridContainer];
    
    CGFloat totalW = cols * itemW + (cols - 1) * colGap;
    CGFloat totalH = rows * itemH + (rows - 1) * rowGap;
    [_gridContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_scrollView);
        make.centerX.mas_equalTo(_scrollView);
        make.width.mas_equalTo(totalW);
        make.height.mas_equalTo(totalH);
    }];
    
    for (int i = 0; i < self.mergedGifts.count; i++) {
        MLGameDrawResultModel *gift = self.mergedGifts[i];
        NSInteger row = i / cols;
        NSInteger col = i % cols;
        
        UIView *itemBg = [[UIView alloc] init];
        itemBg.backgroundColor = [UIColor clearColor];
        [_gridContainer addSubview:itemBg];
        [itemBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(row * (itemH + rowGap));
            make.leading.mas_equalTo(col * (itemW + colGap));
            make.size.mas_equalTo(CGSizeMake(itemW, itemH));
        }];
        
        // 1. 新卡片底座背景 (按 353:346 真实长宽比进一步缩小)
        UIImageView *cardBg = [[UIImageView alloc] init];
        cardBg.image = [UIImage imageNamed:@"theme_game_four_new_result_gift_card_bg"];
        cardBg.contentMode = UIViewContentModeScaleAspectFit;
        cardBg.userInteractionEnabled = YES;
        [itemBg addSubview:cardBg];
        [cardBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(itemBg);
        }];
        
        // 2. 礼物图标 (30x30 pt，进一步下移至 top 11pt)
        UIImageView *giftImg = [[UIImageView alloc] init];
        giftImg.contentMode = UIViewContentModeScaleAspectFit;
        [cardBg addSubview:giftImg];
        [giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KDialogAdaptedWidth(11));
            make.centerX.mas_equalTo(cardBg);
            make.size.mas_equalTo(CGSizeMake(iconSize, iconSize));
        }];
        
        NSURL *url = [NSURL URLWithString:[gift imageUrl]];
        if ([giftImg respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
            [giftImg performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
        } else if ([giftImg respondsToSelector:@selector(setImageWithURL:placeholder:)]) {
            [giftImg performSelector:@selector(setImageWithURL:placeholder:) withObject:url withObject:[UIImage imageNamed:@""]];
        }
        
        // 3. 礼物名称与数量 (白色 9.5pt 加粗，开启智能字号缩放防止截断)
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = kWhiteColor;
        nameLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(9.5)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.minimumScaleFactor = 0.6;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        if (gift.num > 1) {
            nameLabel.text = [NSString stringWithFormat:@"%@ x%ld", gift.name ?: @"", (long)gift.num];
        } else {
            nameLabel.text = gift.name ?: @"";
        }
        [cardBg addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(KDialogAdaptedWidth(4));
            make.leading.mas_equalTo(KDialogAdaptedWidth(1));
            make.trailing.mas_equalTo(-KDialogAdaptedWidth(1));
        }];
        
        // 4. 钻石价值 (淡金黄色 #FFF59D 8.5pt，开启智能字号缩放)
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.textColor = mHexRGB(0xFFF59D);
        valueLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(8.5)];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.adjustsFontSizeToFitWidth = YES;
        valueLabel.minimumScaleFactor = 0.7;
        valueLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)gift.price];
        [cardBg addSubview:valueLabel];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(KDialogAdaptedWidth(12));
            make.leading.mas_equalTo(KDialogAdaptedWidth(1));
            make.trailing.mas_equalTo(-KDialogAdaptedWidth(1));
        }];
    }
    
    _scrollView.contentSize = CGSizeMake(totalW, totalH);
}

- (void)animateShow {
    self.alpha = 0.0;
    _panelContainer.transform = CGAffineTransformMakeScale(0.85, 0.85);
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1.0;
        self.panelContainer.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)retryClick {
    void(^block)(void) = self.retryBlock;
    [self dismissWithCompletion:^{
        if (block) {
            block();
        }
    }];
}

- (void)closeClick {
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void(^)(void))completion {
    [UIView animateWithDuration:0.20 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0.0;
        self.panelContainer.transform = CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

@end

