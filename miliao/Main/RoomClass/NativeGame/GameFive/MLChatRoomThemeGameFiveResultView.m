//
//  MLChatRoomThemeGameFiveResultView.m
//  miliao
//

#import "MLChatRoomThemeGameFiveResultView.h"
#import "Global.h"
#import <Masonry/Masonry.h>

@interface MLChatRoomThemeGameFiveResultView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *backgroundContainer;
@property (nonatomic, strong) UIView *contentClippingContainer;
@property (nonatomic, strong) UIImageView *resultBg;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *gridContainer;

@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *mergedGifts;
@property (nonatomic, assign) NSInteger totalValue;
@property (nonatomic, copy) void(^retryBlock)(void);

@end

@implementation MLChatRoomThemeGameFiveResultView

+ (void)showInView:(UIView *)parentView 
             gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
        totalValue:(NSInteger)value 
        retryBlock:(void(^ _Nullable)(void))retry {
    MLChatRoomThemeGameFiveResultView *resultView = [[MLChatRoomThemeGameFiveResultView alloc] initWithFrame:parentView.bounds 
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
        self.mergedGifts = [MLGameDrawResultModel mergeAndSortDrawGifts:gifts];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 1. Semi-transparent mask background
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tap];
    
    // 2. Centered panel container (Ratio 659:789)
    _backgroundContainer = [[UIView alloc] init];
    _backgroundContainer.backgroundColor = [UIColor clearColor];
    [self addSubview:_backgroundContainer];
    [_backgroundContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(KDialogAdaptedWidth(280));
        make.height.mas_equalTo(_backgroundContainer.mas_width).multipliedBy(896.0 / 659.0);
    }];
    
    // 3. Inner clipped container
    _contentClippingContainer = [[UIView alloc] init];
    _contentClippingContainer.clipsToBounds = YES;
    [_backgroundContainer addSubview:_contentClippingContainer];
    [_contentClippingContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_backgroundContainer);
    }];
    
    // 4. Panel background image
    _resultBg = [[UIImageView alloc] init];
    _resultBg.image = [UIImage imageNamed:@"theme_game_five_result_bg"];
    _resultBg.contentMode = UIViewContentModeScaleToFill;
    [_contentClippingContainer addSubview:_resultBg];
    [_resultBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_contentClippingContainer);
    }];
    
    // 5. Scrollable container for dynamic gift cards
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_contentClippingContainer addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(100));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(38));
        make.leading.trailing.mas_equalTo(0);
    }];
    
    [self layoutResultGifts];
    
    // 6. Close button (Matches Rule View close button position)
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"theme_game_five_rule_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundContainer addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentClippingContainer).offset(KDialogAdaptedWidth(10));
        make.trailing.mas_equalTo(_contentClippingContainer).offset(-KDialogAdaptedWidth(10));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(28), KDialogAdaptedWidth(28)));
    }];
    
    UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [retryButton setImage:[UIImage imageNamed:@"theme_game_five_result_retry_btn"] forState:UIControlStateNormal];
    retryButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [retryButton addTarget:self action:@selector(retryClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:retryButton];
    [retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backgroundContainer.mas_bottom).offset(KDialogAdaptedWidth(12.0f));
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(140.0f), KDialogAdaptedWidth(58.0f)));
    }];
}

- (void)layoutResultGifts {
    if (self.mergedGifts.count == 0) return;
    
    NSInteger cols = MIN(3, self.mergedGifts.count);
    NSInteger rows = (self.mergedGifts.count + cols - 1) / cols;
    
    CGFloat itemW = KDialogAdaptedWidth(80.0f);
    CGFloat itemH = KDialogAdaptedWidth(105.0f);
    
    _gridContainer = [[UIView alloc] init];
    _gridContainer.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_gridContainer];
    
    CGFloat totalH = rows * itemH;
    [_gridContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(_scrollView);
        make.centerX.mas_equalTo(_scrollView);
        make.width.mas_equalTo(cols * itemW);
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
            make.top.mas_equalTo(row * itemH);
            make.leading.mas_equalTo(col * itemW);
            make.size.mas_equalTo(CGSizeMake(itemW, itemH));
        }];
        
        // Pedestal base image
        UIImageView *pedestalView = [[UIImageView alloc] init];
        pedestalView.image = [UIImage imageNamed:@"theme_game_five_result_pedestal"];
        pedestalView.contentMode = UIViewContentModeScaleAspectFit;
        [itemBg addSubview:pedestalView];
        [pedestalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KDialogAdaptedWidth(22));
            make.centerX.mas_equalTo(itemBg);
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(68), KDialogAdaptedWidth(52)));
        }];
        
        // Gift thumbnail image
        UIImageView *giftImg = [[UIImageView alloc] init];
        giftImg.contentMode = UIViewContentModeScaleAspectFit;
        [itemBg addSubview:giftImg];
        [giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KDialogAdaptedWidth(10));
            make.centerX.mas_equalTo(itemBg);
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(44), KDialogAdaptedWidth(44)));
        }];
        
        NSURL *url = [NSURL URLWithString:[gift imageUrl]];
        if ([giftImg respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
            [giftImg performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
        } else if ([giftImg respondsToSelector:@selector(setImageWithURL:placeholderImage:)]) {
            [giftImg performSelector:@selector(setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
        }
        
        // Gift Name + Quantity label
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = kWhiteColor;
        nameLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(9)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = gift.num > 1 ? [NSString stringWithFormat:@"%@ x%ld", gift.name, (long)gift.num] : gift.name;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [itemBg addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(pedestalView.mas_bottom).offset(KDialogAdaptedWidth(2));
            make.leading.trailing.mas_equalTo(itemBg);
        }];
        
        // Diamond Price label
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.textColor = mHexRGB(0x61D0FF); // Cyan light blue
        valueLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(8)];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)gift.price];
        [itemBg addSubview:valueLabel];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(KDialogAdaptedWidth(1));
            make.leading.trailing.mas_equalTo(itemBg);
        }];
    }
}

#pragma mark - Animations

- (void)animateShow {
    self.alpha = 0.0;
    _backgroundContainer.transform = CGAffineTransformMakeScale(0.85, 0.85);
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1.0;
        self.backgroundContainer.transform = CGAffineTransformIdentity;
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
        self.backgroundContainer.transform = CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

@end
