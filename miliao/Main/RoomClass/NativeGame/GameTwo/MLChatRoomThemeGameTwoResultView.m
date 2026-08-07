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
    
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_two_result_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(375), KDialogAdaptedWidth(663)));
    }];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"theme_game_two_result_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(16));
        make.leading.mas_equalTo(KDialogAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(36), KDialogAdaptedWidth(36)));
    }];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(120));
        make.leading.mas_equalTo(KDialogAdaptedWidth(8));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(8));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(50));
    }];
    
    [self layoutGiftsInScrollView];
}

- (void)layoutGiftsInScrollView {
    CGFloat itemW = KDialogAdaptedWidth(78.0f);
    CGFloat cardH = KDialogAdaptedWidth(96.0f);
    CGFloat itemH = KDialogAdaptedWidth(114.0f);
    CGFloat colGap = KDialogAdaptedWidth(10.0f);
    CGFloat rowGap = KDialogAdaptedWidth(10.0f);
    CGFloat leftMargin = KDialogAdaptedWidth(8.5f);
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
        cardImg.image = [UIImage imageNamed:@"theme_game_two_result_item_bg"];
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
        nameLabel.textColor = kWhiteColor;
        nameLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(10)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = gift.name;
        [cardImg addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(giftImg.mas_bottom).offset(KDialogAdaptedWidth(2));
            make.leading.trailing.mas_equalTo(cardImg);
        }];
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.textColor = kWhiteColor;
        valueLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(10)];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)gift.price];
        [cardImg addSubview:valueLabel];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(KDialogAdaptedWidth(2));
            make.leading.trailing.mas_equalTo(cardImg);
        }];
        
        UIImageView *badgeBg = [[UIImageView alloc] init];
        badgeBg.image = [UIImage imageNamed:@"theme_game_two_result_item_badge"];
        [cardImg addSubview:badgeBg];
        [badgeBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cardImg);
            make.trailing.mas_equalTo(cardImg);
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(31), KDialogAdaptedWidth(11)));
        }];
        
        UILabel *badgeLabel = [[UILabel alloc] init];
        badgeLabel.text = @"98%";
        badgeLabel.textColor = kWhiteColor;
        badgeLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(8)];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        [badgeBg addSubview:badgeLabel];
        [badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(badgeBg);
        }];
        
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
    _scrollView.contentSize = CGSizeMake(KDialogAdaptedWidth(359), contentH);
}

- (void)updateTimesTag:(NSInteger)times {
    self.times = times;
    // 已经移除了底部的次数标签，此处为兼容性空实现
}

- (void)updateGifts:(NSArray<MLGameDrawResultModel *> *)gifts totalValue:(NSInteger)value times:(NSInteger)times {
    self.totalValue = value;
    self.mergedGifts = [MLGameDrawResultModel mergeAndSortDrawGifts:gifts];
    
    for (UIView *sub in self.scrollView.subviews) {
        [sub removeFromSuperview];
    }
    
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
