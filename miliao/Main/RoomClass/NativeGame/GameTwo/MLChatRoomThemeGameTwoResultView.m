#import "MLChatRoomThemeGameTwoResultView.h"
#import "Global.h"

#define KDialogAdaptedWidth(x) (isPadA ? ceilf((x) * (390.0 / 375.0)) : KAdaptedWidth(x))

@interface MLChatRoomThemeGameTwoResultView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *mergedGifts;
@property (nonatomic, assign) NSInteger totalValue;
@property (nonatomic, assign) NSInteger times;
@property (nonatomic, copy) void(^retryBlock)(void);

@end

@implementation MLChatRoomThemeGameTwoResultView

+ (void)showInView:(UIView *)parentView 
             gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
        totalValue:(NSInteger)value 
             times:(NSInteger)times
        retryBlock:(void(^)(void))retry {
    MLChatRoomThemeGameTwoResultView *resultView = [[MLChatRoomThemeGameTwoResultView alloc] initWithFrame:parentView.bounds 
                                                                                                    gifts:gifts 
                                                                                               totalValue:value 
                                                                                                    times:times
                                                                                               retryBlock:retry];
    [parentView addSubview:resultView];
    [resultView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame 
                        gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
                   totalValue:(NSInteger)value 
                        times:(NSInteger)times
                   retryBlock:(void(^)(void))retry {
    if (self = [super initWithFrame:frame]) {
        self.retryBlock = retry;
        self.totalValue = value;
        self.times = times;
        
        self.mergedGifts = [MLGameDrawResultModel mergeAndSortDrawGifts:gifts];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 点击外部空白 Mask 区域关闭弹窗 (对标安卓 dismissOnTouchOutside(true))
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_maskView addGestureRecognizer:tap];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    // 弹窗主体画框容器 (锁死 731:893 精准比例)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_two_result_main_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(KDialogAdaptedWidth(300.0f));
        make.height.mas_equalTo(_bgImageView.mas_width).multipliedBy(893.0f / 731.0f);
    }];
    
    // 滚动展示区 (上边缘往下降至 98.0f)
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(98.0f));
        make.leading.mas_equalTo(KDialogAdaptedWidth(26.0f));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(26.0f));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(54.0f));
    }];
    
    [self layoutGiftsInScrollView];
}

- (void)layoutGiftsInScrollView {
    for (UIView *sub in self.scrollView.subviews) {
        [sub removeFromSuperview];
    }
    
    if (self.mergedGifts.count == 0) return;
    
    // 对标 Android 提交 31：仅 1 个礼物卡片时单列居中，多于 1 个礼物卡片时 3 列自适应分布
    NSInteger colCount = (self.mergedGifts.count == 1) ? 1 : 3;
    
    CGFloat containerW = KDialogAdaptedWidth(300.0f - 52.0f); // 248pt 可用宽度
    CGFloat itemW = KDialogAdaptedWidth(72.0f);   // 卡片宽度
    CGFloat itemH = KDialogAdaptedWidth(100.0f);  // 卡片总高度 (包含 1:1 正方形底座及下方文字)
    CGFloat rowGap = KDialogAdaptedWidth(10.0f);
    
    CGFloat colGap = 0;
    CGFloat sideMargin = 0;
    
    if (colCount == 1) {
        sideMargin = (containerW - itemW) / 2.0f;
    } else {
        colGap = (containerW - colCount * itemW) / (colCount - 1);
        if (colGap < 0) colGap = 0;
    }
    
    for (int i = 0; i < self.mergedGifts.count; i++) {
        MLGameDrawResultModel *gift = self.mergedGifts[i];
        
        NSInteger row = i / colCount;
        NSInteger col = i % colCount;
        
        UIView *itemBg = [[UIView alloc] init];
        itemBg.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:itemBg];
        [itemBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(row * (itemH + rowGap));
            make.leading.mas_equalTo(sideMargin + col * (itemW + colGap));
            make.size.mas_equalTo(CGSizeMake(itemW, itemH));
        }];
        
        // 礼物底座切图 (148:148 1:1 正方形切图，原生 theme_game_two_result_gift_board)
        UIImageView *cardBg = [[UIImageView alloc] init];
        cardBg.image = [UIImage imageNamed:@"theme_game_two_result_gift_board"];
        cardBg.contentMode = UIViewContentModeScaleToFill;
        [itemBg addSubview:cardBg];
        [cardBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(itemW);
        }];
        
        // 礼物图标
        UIImageView *giftImg = [[UIImageView alloc] init];
        giftImg.contentMode = UIViewContentModeScaleAspectFit;
        [cardBg addSubview:giftImg];
        [giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(cardBg);
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(42), KDialogAdaptedWidth(42)));
        }];
        
        [giftImg sd_setImageWithURL:[NSURL URLWithString:[gift imageUrl]] placeholderImage:nil];
        
        // 组合显示名称与数量 (对标安卓提交 31: tv_prize_name 黑色 #333333 10sp，如 "神木仙果 x10")
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = mHexRGB(0x333333);
        nameLabel.font = KFontBoldA(10);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = (gift.num > 1) ? [NSString stringWithFormat:@"%@ x%ld", gift.name, (long)gift.num] : gift.name;
        [itemBg addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cardBg.mas_bottom).offset(KDialogAdaptedWidth(2.0f));
            make.leading.trailing.mas_equalTo(itemBg);
        }];
        
        // 售价 (对标安卓提交 31: tv_prize_value 红色 #FF3B30 9sp，如 "200钻石")
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.textColor = mHexRGB(0xFF3B30);
        priceLabel.font = KFontBoldA(9);
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)gift.price];
        [itemBg addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(KDialogAdaptedWidth(1.0f));
            make.leading.trailing.mas_equalTo(itemBg);
        }];
    }
    
    NSInteger totalRows = (self.mergedGifts.count + colCount - 1) / colCount;
    CGFloat contentH = totalRows * (itemH + rowGap) + KDialogAdaptedWidth(10);
    _scrollView.contentSize = CGSizeMake(containerW, contentH);
}

- (void)updateTimesTag:(NSInteger)times {
    self.times = times;
}

- (void)updateGifts:(NSArray<MLGameDrawResultModel *> *)gifts totalValue:(NSInteger)value times:(NSInteger)times {
    self.totalValue = value;
    self.mergedGifts = [MLGameDrawResultModel mergeAndSortDrawGifts:gifts];
    [self layoutGiftsInScrollView];
    [self updateTimesTag:times];
}

#pragma mark - 交互
- (void)retryClick {
    if (self.retryBlock) {
        self.retryBlock();
    }
}

- (void)closeClick {
    [self dismiss];
}

- (void)animateShow {
    self.alpha = 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        for (UIView *sub in self.superview.subviews) {
            if ([sub respondsToSelector:NSSelectorFromString(@"loadData")]) {
                [sub performSelector:NSSelectorFromString(@"loadData")];
            }
        }
        [self removeFromSuperview];
    }];
}

@end
