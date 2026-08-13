#import "MLChatRoomThemeGameThreeGiftView.h"
#import "Global.h"

@interface MLChatRoomThemeGameThreeGiftView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *totalValueLabel;

@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *mergedGifts;
@property (nonatomic, assign) NSInteger totalValue;

@end

@implementation MLChatRoomThemeGameThreeGiftView

+ (void)showInView:(UIView *)parentView 
             gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
        totalValue:(NSInteger)value {
    MLChatRoomThemeGameThreeGiftView *giftView = [[MLChatRoomThemeGameThreeGiftView alloc] initWithFrame:parentView.bounds 
                                                                                                    gifts:gifts 
                                                                                               totalValue:value];
    [parentView addSubview:giftView];
    [giftView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame 
                        gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
                   totalValue:(NSInteger)value {
    if (self = [super initWithFrame:frame]) {
        self.totalValue = value;
        self.mergedGifts = [MLGameDrawResultModel mergeAndSortDrawGifts:gifts];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:maskTap];
    
    // BackgroundContainer
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_three_result_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(self).priorityMedium();
        make.width.mas_lessThanOrEqualTo(KDialogAdaptedWidth(375)).priorityHigh();
        make.height.mas_equalTo(_bgImageView.mas_width).multipliedBy(662.0 / 375.0);
    }];
    
    // HUDContainer (头部信息容器)
    UIView *hudContainer = [[UIView alloc] init];
    hudContainer.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:hudContainer];
    [hudContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(_bgImageView);
        make.height.mas_equalTo(KDialogAdaptedWidth(115));
    }];
    
    // 返回按钮 (在 72pt 基础上缩小 30% -> 50pt)
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"theme_game_three_result_close"] forState:UIControlStateNormal];
    _closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    _closeButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [hudContainer addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(28));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(14));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(50), KDialogAdaptedWidth(50)));
    }];
    
    // GameplayContainer (核心游戏物品展示区)
    UIView *gameplayContainer = [[UIView alloc] init];
    gameplayContainer.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:gameplayContainer];
    [gameplayContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hudContainer.mas_bottom);
        make.leading.trailing.mas_equalTo(_bgImageView);
        make.height.mas_equalTo(KDialogAdaptedWidth(480));
    }];
    
    // 滚动列表
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [gameplayContainer addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(gameplayContainer).insets(UIEdgeInsetsMake(0, KDialogAdaptedWidth(15), 0, KDialogAdaptedWidth(15)));
    }];
    
    [self layoutGiftsInScrollView];
    
    // ActionContainer (底部操作区)
    UIView *actionContainer = [[UIView alloc] init];
    actionContainer.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:actionContainer];
    [actionContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(gameplayContainer.mas_bottom);
        make.leading.trailing.bottom.mas_equalTo(_bgImageView);
    }];
    
    // 获得总价值
    _totalValueLabel = [[UILabel alloc] init];
    _totalValueLabel.textColor = mHexRGB(0xA34B16);
    _totalValueLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(13)];
    _totalValueLabel.textAlignment = NSTextAlignmentCenter;
    _totalValueLabel.text = [NSString stringWithFormat:@"总价值：%ld钻石", (long)self.totalValue];
    [actionContainer addSubview:_totalValueLabel];
    [_totalValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(12));
        make.centerX.mas_equalTo(actionContainer);
    }];
}

- (void)layoutGiftsInScrollView {
    CGFloat itemW = KDialogAdaptedWidth(78.0f);
    CGFloat cardH = KDialogAdaptedWidth(88.0f);
    CGFloat itemH = KDialogAdaptedWidth(108.0f);
    CGFloat colGap = KDialogAdaptedWidth(8.0f);
    CGFloat rowGap = KDialogAdaptedWidth(10.0f);
    CGFloat leftMargin = KDialogAdaptedWidth(5.0f);
    NSInteger colCount = 4;
    
    for (int i = 0; i < self.mergedGifts.count; i++) {
        MLGameDrawResultModel *gift = self.mergedGifts[i];
        
        NSInteger row = i / colCount;
        NSInteger col = i % colCount;
        
        UIView *itemBg = [[UIView alloc] init];
        itemBg.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:itemBg];
        [itemBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(row * (itemH + rowGap) + rowGap);
            make.leading.mas_equalTo(col * (itemW + colGap) + leftMargin);
            make.size.mas_equalTo(CGSizeMake(itemW, itemH));
        }];
        
        UIImageView *cardImg = [[UIImageView alloc] init];
        cardImg.image = [UIImage imageNamed:@"theme_game_three_result_item_bg"];
        cardImg.userInteractionEnabled = YES;
        [itemBg addSubview:cardImg];
        [cardImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(itemBg);
            make.height.mas_equalTo(cardH);
        }];
        
        UIImageView *giftImg = [[UIImageView alloc] init];
        giftImg.contentMode = UIViewContentModeScaleAspectFit;
        [cardImg addSubview:giftImg];
        [giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KDialogAdaptedWidth(8));
            make.centerX.mas_equalTo(cardImg);
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(48), KDialogAdaptedWidth(48)));
        }];
        
        NSURL *url = [NSURL URLWithString:[gift imageUrl]];
        if ([giftImg respondsToSelector:@selector(setImageWithURL:placeholder:)]) {
            [giftImg performSelector:@selector(setImageWithURL:placeholder:) withObject:url withObject:[UIImage imageNamed:@""]];
        } else if ([giftImg respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
            [giftImg performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
        }
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(10)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = gift.name;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [cardImg addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(giftImg.mas_bottom).offset(KDialogAdaptedWidth(2));
            make.leading.trailing.mas_equalTo(cardImg);
        }];
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.textColor = [UIColor blackColor];
        valueLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(10)];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)gift.price];
        [cardImg addSubview:valueLabel];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(KDialogAdaptedWidth(2));
            make.leading.trailing.mas_equalTo(cardImg);
        }];
        
        // 真实概率角标 (拓宽至 36x13 pt，开启智能微缩防截断)
        UIImageView *badgeBg = [[UIImageView alloc] init];
        badgeBg.image = [UIImage imageNamed:@"theme_game_three_result_item_badge"];
        [cardImg addSubview:badgeBg];
        [badgeBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cardImg);
            make.trailing.mas_equalTo(cardImg);
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(36.0f), KDialogAdaptedWidth(13.0f)));
        }];
        
        UILabel *badgeLabel = [[UILabel alloc] init];
        badgeLabel.textColor = kBlackColor;
        badgeLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(8)];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.adjustsFontSizeToFitWidth = YES;
        badgeLabel.minimumScaleFactor = 0.6;
        [badgeBg addSubview:badgeLabel];
        [badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(badgeBg);
        }];
        
        NSString *probStr = [gift displayProbability];
        if (probStr && probStr.length > 0) {
            badgeBg.hidden = NO;
            badgeLabel.text = probStr;
        } else {
            badgeBg.hidden = YES;
        }
        
        // 预览【奖品池】图鉴清单时隐藏卡片下方的数量数字 xN
        if (gift.num > 0) {
            UILabel *numLabel = [[UILabel alloc] init];
            numLabel.textColor = kWhiteColor;
            numLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(10)];
            numLabel.textAlignment = NSTextAlignmentCenter;
            numLabel.text = [NSString stringWithFormat:@"x%ld", (long)gift.num];
            [itemBg addSubview:numLabel];
            [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cardImg.mas_bottom).offset(KDialogAdaptedWidth(4));
                make.centerX.mas_equalTo(itemBg);
            }];
        }
    }
    
    NSInteger totalRows = (self.mergedGifts.count + colCount - 1) / colCount;
    CGFloat contentH = totalRows * (itemH + rowGap) + rowGap;
    _scrollView.contentSize = CGSizeMake(KDialogAdaptedWidth(345), contentH);
}

#pragma mark - 交互

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
