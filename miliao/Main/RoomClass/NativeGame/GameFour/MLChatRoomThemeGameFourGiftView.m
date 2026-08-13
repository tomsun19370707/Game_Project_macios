#import "MLChatRoomThemeGameFourGiftView.h"
#import "Global.h"
#import <Masonry/Masonry.h>

@interface MLChatRoomThemeGameFourGiftView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *panelContainer;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *contentClippingContainer;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *gridContainer;

@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *mergedGifts;
@property (nonatomic, assign) NSInteger totalValue;

@end

@implementation MLChatRoomThemeGameFourGiftView

+ (void)showInView:(UIView *)parentView 
             gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
        totalValue:(NSInteger)value {
    MLChatRoomThemeGameFourGiftView *giftView = [[MLChatRoomThemeGameFourGiftView alloc] initWithFrame:parentView.bounds 
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
    
    // 1. 半透明遮罩
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:maskTap];
    
    // 2. 主画框容器 (比例锁定 602:992，宽度 80%，上限 290pt)
    _panelContainer = [[UIView alloc] init];
    _panelContainer.backgroundColor = [UIColor clearColor];
    _panelContainer.userInteractionEnabled = YES;
    [self addSubview:_panelContainer];
    [_panelContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.80).priorityMedium();
        make.width.mas_lessThanOrEqualTo(KDialogAdaptedWidth(290)).priorityHigh();
        make.height.mas_equalTo(_panelContainer.mas_width).multipliedBy(992.0 / 602.0);
    }];
    
    // 3. 内部裁剪容器
    _contentClippingContainer = [[UIView alloc] init];
    _contentClippingContainer.clipsToBounds = YES;
    [_panelContainer addSubview:_contentClippingContainer];
    [_contentClippingContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_panelContainer);
    }];
    
    // 4. 面板背景图 (绑定奖池专属重命名资源: theme_game_four_gift_panel_bg)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_four_gift_panel_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    [_contentClippingContainer addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_contentClippingContainer);
    }];
    
    // 5. 关闭按钮 (绑定奖池专属重命名资源: theme_game_four_gift_close, 34×36pt，-8pt 溢出悬挂)
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"theme_game_four_gift_close"] forState:UIControlStateNormal];
    _closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    _closeButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_panelContainer addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentClippingContainer.mas_top).offset(-KDialogAdaptedWidth(8));
        make.trailing.mas_equalTo(_contentClippingContainer.mas_trailing).offset(KDialogAdaptedWidth(8));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(34), KDialogAdaptedWidth(36)));
    }];
    
    // 6. 滚动列表视口 (top 75pt, bottom 52pt, margin 16pt)
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical = YES;
    [_contentClippingContainer addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(75));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(52));
        make.leading.mas_equalTo(KDialogAdaptedWidth(16));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(16));
    }];
    
    [self layoutGiftsInScrollView];
}

- (void)layoutGiftsInScrollView {
    if (!self.mergedGifts || self.mergedGifts.count == 0) return;
    
    NSInteger colCount = 3;
    NSInteger totalRows = (self.mergedGifts.count + colCount - 1) / colCount;
    
    CGFloat itemW = KDialogAdaptedWidth(72.0f);
    CGFloat itemH = KDialogAdaptedWidth(108.0f);
    CGFloat colGap = KDialogAdaptedWidth(8.0f);
    CGFloat rowGap = KDialogAdaptedWidth(10.0f);
    CGFloat iconSize = KDialogAdaptedWidth(48.0f);
    
    _gridContainer = [[UIView alloc] init];
    _gridContainer.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_gridContainer];
    
    CGFloat totalW = colCount * itemW + (colCount - 1) * colGap;
    CGFloat totalH = totalRows * itemH + (totalRows - 1) * rowGap;
    [_gridContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_scrollView);
        make.centerX.mas_equalTo(_scrollView);
        make.width.mas_equalTo(totalW);
        make.height.mas_equalTo(totalH);
    }];
    
    for (int i = 0; i < self.mergedGifts.count; i++) {
        MLGameDrawResultModel *gift = self.mergedGifts[i];
        NSInteger row = i / colCount;
        NSInteger col = i % colCount;
        
        UIView *itemBg = [[UIView alloc] init];
        itemBg.backgroundColor = [UIColor clearColor];
        [_gridContainer addSubview:itemBg];
        [itemBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(row * (itemH + rowGap));
            make.leading.mas_equalTo(col * (itemW + colGap));
            make.size.mas_equalTo(CGSizeMake(itemW, itemH));
        }];
        
        // 卡片底座背景 (绑定奖池专属重命名资源: theme_game_four_gift_card_bg)
        UIImageView *cardBg = [[UIImageView alloc] init];
        cardBg.image = [UIImage imageNamed:@"theme_game_four_gift_card_bg"];
        cardBg.contentMode = UIViewContentModeScaleToFill;
        cardBg.userInteractionEnabled = YES;
        [itemBg addSubview:cardBg];
        [cardBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(itemBg);
        }];
        
        // 礼物图标 (48x48 pt)
        UIImageView *giftImg = [[UIImageView alloc] init];
        giftImg.contentMode = UIViewContentModeScaleAspectFit;
        [cardBg addSubview:giftImg];
        [giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KDialogAdaptedWidth(14));
            make.centerX.mas_equalTo(cardBg);
            make.size.mas_equalTo(CGSizeMake(iconSize, iconSize));
        }];
        
        NSURL *url = [NSURL URLWithString:[gift imageUrl]];
        if ([giftImg respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
            [giftImg performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
        } else if ([giftImg respondsToSelector:@selector(setImageWithURL:placeholder:)]) {
            [giftImg performSelector:@selector(setImageWithURL:placeholder:) withObject:url withObject:[UIImage imageNamed:@""]];
        }
        
        // 礼物名称
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = kWhiteColor;
        nameLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(10)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = gift.name;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [cardBg addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-KDialogAdaptedWidth(24));
            make.leading.mas_equalTo(KDialogAdaptedWidth(4));
            make.trailing.mas_equalTo(-KDialogAdaptedWidth(4));
        }];
        
        // 钻石价值
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.textColor = mHexRGB(0xFFF59D);
        valueLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(9)];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)gift.price];
        [cardBg addSubview:valueLabel];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-KDialogAdaptedWidth(8));
            make.leading.mas_equalTo(KDialogAdaptedWidth(4));
            make.trailing.mas_equalTo(-KDialogAdaptedWidth(4));
        }];
        
        // 概率角标 (扩大至 34x13.5 pt, 往右微移至 trailing 2pt)
        UIImageView *badgeBg = [[UIImageView alloc] init];
        badgeBg.image = [UIImage imageNamed:@"theme_game_four_gift_percent_tag_bg"];
        badgeBg.contentMode = UIViewContentModeScaleToFill;
        [cardBg addSubview:badgeBg];
        [badgeBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KDialogAdaptedWidth(2));
            make.trailing.mas_equalTo(KDialogAdaptedWidth(2));
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(34), KDialogAdaptedWidth(13.5)));
        }];
        
        UILabel *badgeLabel = [[UILabel alloc] init];
        badgeLabel.textColor = kWhiteColor;
        badgeLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(9)];
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
    }
    
    _scrollView.contentSize = CGSizeMake(totalW, totalH);
}

#pragma mark - 交互

- (void)closeClick {
    [self dismiss];
}

- (void)animateShow {
    self.alpha = 0.0;
    _panelContainer.transform = CGAffineTransformMakeScale(0.85, 0.85);
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1.0;
        self.panelContainer.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.panelContainer.transform = CGAffineTransformMakeScale(0.85, 0.85);
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
