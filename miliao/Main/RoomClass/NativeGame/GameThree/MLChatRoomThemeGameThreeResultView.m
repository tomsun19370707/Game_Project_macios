#import "MLChatRoomThemeGameThreeResultView.h"
#import "Global.h"

@interface MLChatRoomThemeGameThreeResultView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *panelContainer;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *gridContainer;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *mergedGifts;
@property (nonatomic, assign) NSInteger totalValue;
@property (nonatomic, copy) void(^retryBlock)(void);

@end

@implementation MLChatRoomThemeGameThreeResultView

+ (void)showInView:(UIView *)parentView 
             gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
        totalValue:(NSInteger)value 
        retryBlock:(void(^)(void))retry {
    MLChatRoomThemeGameThreeResultView *resultView = [[MLChatRoomThemeGameThreeResultView alloc] initWithFrame:parentView.bounds 
                                                                                                    gifts:gifts 
                                                                                               totalValue:value 
                                                                                               retryBlock:retry];
    [parentView addSubview:resultView];
    [resultView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame 
                        gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
                   totalValue:(NSInteger)value 
                   retryBlock:(void(^)(void))retry {
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
    
    // 遮罩层
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:maskTap];
    
    // 玩法3 恭喜获得主面板容器 (比例锁定 642:896)
    _panelContainer = [[UIView alloc] init];
    _panelContainer.backgroundColor = [UIColor clearColor];
    _panelContainer.userInteractionEnabled = YES;
    [self addSubview:_panelContainer];
    [_panelContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.84).priorityMedium();
        make.width.mas_lessThanOrEqualTo(KDialogAdaptedWidth(310)).priorityHigh();
        make.height.mas_equalTo(_panelContainer.mas_width).multipliedBy(896.0 / 642.0);
    }];
    
    // 1. 主面板画框背景 (theme_game_three_new_result_main_bg: 642 x 896)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_three_new_result_main_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [_panelContainer addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_panelContainer);
    }];
    
    // 2. 关闭按钮 (theme_game_three_new_result_close_btn: 32x32 pt)
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"theme_game_three_new_result_close_btn"] forState:UIControlStateNormal];
    _closeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_panelContainer addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(18));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(18));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(32), KDialogAdaptedWidth(32)));
    }];
    
    // 3. 内容滚动区 (内 Margins: top 75, bottom 35, start 16, end 16)
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_panelContainer addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_panelContainer).offset(KDialogAdaptedWidth(75));
        make.bottom.mas_equalTo(_panelContainer).offset(-KDialogAdaptedWidth(35));
        make.leading.mas_equalTo(_panelContainer).offset(KDialogAdaptedWidth(16));
        make.trailing.mas_equalTo(_panelContainer).offset(-KDialogAdaptedWidth(16));
    }];
    
    [self layoutGiftsInScrollView];
    
    UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [retryButton setImage:[UIImage imageNamed:@"theme_game_three_result_retry_btn"] forState:UIControlStateNormal];
    retryButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [retryButton addTarget:self action:@selector(retryClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:retryButton];
    [retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_panelContainer.mas_bottom).offset(KDialogAdaptedWidth(12.0f));
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(150.0f), KDialogAdaptedWidth(55.0f)));
    }];
}

- (void)layoutGiftsInScrollView {
    if (!self.mergedGifts || self.mergedGifts.count == 0) return;
    
    NSInteger size = self.mergedGifts.count;
    // 依中奖种数自适应列数：1种 -> 1列；2种 -> 2列；3种及以上 -> 3列
    NSInteger cols = (size == 1) ? 1 : ((size == 2) ? 2 : 3);
    NSInteger rows = (size + cols - 1) / cols;
    
    CGFloat cellW = KDialogAdaptedWidth(88.0f);
    CGFloat cellH = KDialogAdaptedWidth(116.0f);
    CGFloat boardSize = KDialogAdaptedWidth(72.0f);
    CGFloat iconSize = KDialogAdaptedWidth(52.0f);
    
    _gridContainer = [[UIView alloc] init];
    _gridContainer.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_gridContainer];
    
    CGFloat totalH = rows * cellH;
    [_gridContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_scrollView);
        make.centerX.mas_equalTo(_scrollView);
        make.width.mas_equalTo(cols * cellW);
        make.height.mas_equalTo(totalH);
    }];
    
    for (int i = 0; i < self.mergedGifts.count; i++) {
        MLGameDrawResultModel *gift = self.mergedGifts[i];
        NSInteger row = i / cols;
        NSInteger col = i % cols;
        
        UIView *itemCell = [[UIView alloc] init];
        itemCell.backgroundColor = [UIColor clearColor];
        [_gridContainer addSubview:itemCell];
        [itemCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(row * cellH);
            make.leading.mas_equalTo(col * cellW);
            make.size.mas_equalTo(CGSizeMake(cellW, cellH));
        }];
        
        // 1. 方形 Icon 底座容器 (theme_game_three_new_result_gift_board: 72x72 pt)
        UIImageView *boardBg = [[UIImageView alloc] init];
        boardBg.image = [UIImage imageNamed:@"theme_game_three_new_result_gift_board"];
        boardBg.contentMode = UIViewContentModeScaleToFill;
        boardBg.userInteractionEnabled = YES;
        [itemCell addSubview:boardBg];
        [boardBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(itemCell);
            make.centerX.mas_equalTo(itemCell);
            make.size.mas_equalTo(CGSizeMake(boardSize, boardSize));
        }];
        
        // 礼物图标 (52x52 pt，居中)
        UIImageView *giftIcon = [[UIImageView alloc] init];
        giftIcon.contentMode = UIViewContentModeScaleAspectFit;
        [boardBg addSubview:giftIcon];
        [giftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(boardBg);
            make.size.mas_equalTo(CGSizeMake(iconSize, iconSize));
        }];
        
        NSURL *url = [NSURL URLWithString:[gift imageUrl]];
        if ([giftIcon respondsToSelector:@selector(setImageWithURL:placeholder:)]) {
            [giftIcon performSelector:@selector(setImageWithURL:placeholder:) withObject:url withObject:[UIImage imageNamed:@""]];
        } else if ([giftIcon respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
            [giftIcon performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
        }
        
        // 2. 礼物名称与数量 (如 星辰法杖 x98，白色 11pt 加粗)
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = kWhiteColor;
        nameLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(11)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        if (gift.num > 1) {
            nameLabel.text = [NSString stringWithFormat:@"%@ x%ld", gift.name ?: @"", (long)gift.num];
        } else {
            nameLabel.text = gift.name ?: @"";
        }
        [itemCell addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(boardBg.mas_bottom).offset(KDialogAdaptedWidth(3));
            make.leading.trailing.mas_equalTo(itemCell);
        }];
        
        // 3. 钻石价值 (暖金色 #FFE885 10pt)
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.textColor = mHexRGB(0xFFE885);
        valueLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(10)];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)gift.price];
        [itemCell addSubview:valueLabel];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(KDialogAdaptedWidth(1));
            make.leading.trailing.mas_equalTo(itemCell);
        }];
    }
    
    _scrollView.contentSize = CGSizeMake(cols * cellW, totalH);
}

#pragma mark - 交互
- (void)retryClick {
    void(^block)(void) = self.retryBlock;
    [self dismissWithCompletion:^{
        if (block) {
            block();
        }
    }];
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
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void(^)(void))completion {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        for (UIView *sub in self.superview.subviews) {
            if ([sub respondsToSelector:NSSelectorFromString(@"loadData")]) {
                [sub performSelector:NSSelectorFromString(@"loadData")];
            }
        }
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

@end
