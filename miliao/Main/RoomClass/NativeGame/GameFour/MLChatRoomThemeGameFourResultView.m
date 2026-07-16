#import "MLChatRoomThemeGameFourResultView.h"
#import "Global.h"
#import <Masonry/Masonry.h>

@interface MLChatRoomThemeGameFourResultView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *contentClippingContainer;
@property (nonatomic, strong) UIImageView *resultBg;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *gridContainer;

@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *mergedGifts;
@property (nonatomic, assign) NSInteger totalValue;

@end

@implementation MLChatRoomThemeGameFourResultView

+ (void)showInView:(UIView *)parentView 
             gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
        totalValue:(NSInteger)value {
    MLChatRoomThemeGameFourResultView *resultView = [[MLChatRoomThemeGameFourResultView alloc] initWithFrame:parentView.bounds 
                                                                                                    gifts:gifts 
                                                                                               totalValue:value];
    [parentView addSubview:resultView];
    [resultView animateShow];
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
    
    // 1. Semi-transparent mask background
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tap];
    
    // 2. Centered panel container (Ratio 602:992, max 290pt)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.backgroundColor = [UIColor clearColor];
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.80).priorityMedium();
        make.width.mas_lessThanOrEqualTo(KDialogAdaptedWidth(290)).priorityHigh();
        make.height.mas_equalTo(_bgImageView.mas_width).multipliedBy(992.0 / 602.0);
    }];
    
    // 3. Inner clipped container
    _contentClippingContainer = [[UIView alloc] init];
    _contentClippingContainer.clipsToBounds = YES;
    [_bgImageView addSubview:_contentClippingContainer];
    [_contentClippingContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_bgImageView);
    }];
    
    // 4. Panel background image
    _resultBg = [[UIImageView alloc] init];
    _resultBg.image = [UIImage imageNamed:@"theme_game_four_result_panel_bg_cropped"];
    _resultBg.contentMode = UIViewContentModeScaleToFill;
    [_contentClippingContainer addSubview:_resultBg];
    [_resultBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_contentClippingContainer);
    }];
    
    // 5. Close button (over-hanging outside clipped area)
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"theme_game_four_result_close"] forState:UIControlStateNormal];
    _closeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentClippingContainer.mas_top).offset(-KDialogAdaptedWidth(8));
        make.trailing.mas_equalTo(_contentClippingContainer.mas_trailing).offset(KDialogAdaptedWidth(8));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(34), KDialogAdaptedWidth(36)));
    }];
    
    // 6. Scrollable container for dynamic items
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_contentClippingContainer addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(80));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(80));
        make.leading.trailing.mas_equalTo(0);
    }];
    
    [self layoutResultGifts];
}

- (void)layoutResultGifts {
    if (self.mergedGifts.count == 0) return;
    
    NSInteger cols = MIN(3, self.mergedGifts.count);
    NSInteger rows = (self.mergedGifts.count + cols - 1) / cols;
    
    CGFloat itemW = KDialogAdaptedWidth(84.0f);
    CGFloat itemH = KDialogAdaptedWidth(128.0f);
    
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
        
        UIImageView *cardBg = [[UIImageView alloc] init];
        cardBg.image = [UIImage imageNamed:@"theme_game_four_result_gift_card_bg"];
        cardBg.contentMode = UIViewContentModeScaleToFill;
        cardBg.userInteractionEnabled = YES;
        [itemBg addSubview:cardBg];
        [cardBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(itemBg).insets(UIEdgeInsetsMake(KDialogAdaptedWidth(4), KDialogAdaptedWidth(4), KDialogAdaptedWidth(4), KDialogAdaptedWidth(4)));
        }];
        
        UIImageView *giftImg = [[UIImageView alloc] init];
        giftImg.contentMode = UIViewContentModeScaleAspectFit;
        [cardBg addSubview:giftImg];
        [giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KDialogAdaptedWidth(20));
            make.centerX.mas_equalTo(cardBg);
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(48), KDialogAdaptedWidth(48)));
        }];
        
        NSURL *url = [NSURL URLWithString:[gift imageUrl]];
        if ([giftImg respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
            [giftImg performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
        } else if ([giftImg respondsToSelector:@selector(setImageWithURL:placeholderImage:)]) {
            [giftImg performSelector:@selector(setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
        }
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = kWhiteColor;
        nameLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(9)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = gift.num > 1 ? [NSString stringWithFormat:@"%@ x%ld", gift.name, (long)gift.num] : gift.name;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [cardBg addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-KDialogAdaptedWidth(26));
            make.leading.mas_equalTo(KDialogAdaptedWidth(4));
            make.trailing.mas_equalTo(-KDialogAdaptedWidth(4));
        }];
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.textColor = mHexRGB(0xFFF59D);
        valueLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(8)];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)gift.price];
        [cardBg addSubview:valueLabel];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-KDialogAdaptedWidth(12));
            make.leading.mas_equalTo(KDialogAdaptedWidth(4));
            make.trailing.mas_equalTo(-KDialogAdaptedWidth(4));
        }];
        
        // Probability label overlay
        UIImageView *tagBg = [[UIImageView alloc] init];
        tagBg.image = [UIImage imageNamed:@"theme_game_four_result_percent_tag_bg"];
        tagBg.contentMode = UIViewContentModeScaleToFill;
        [cardBg addSubview:tagBg];
        [tagBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KDialogAdaptedWidth(3));
            make.trailing.mas_equalTo(KDialogAdaptedWidth(3));
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(35), KDialogAdaptedWidth(13.5)));
        }];
        
        UILabel *tagLabel = [[UILabel alloc] init];
        tagLabel.textColor = kWhiteColor;
        tagLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(9)];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.text = @"98%";
        [tagBg addSubview:tagLabel];
        [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(tagBg);
        }];
    }
}

- (void)animateShow {
    self.alpha = 0.0;
    _bgImageView.transform = CGAffineTransformMakeScale(0.85, 0.85);
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1.0;
        self.bgImageView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)closeClick {
    [UIView animateWithDuration:0.20 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0.0;
        self.bgImageView.transform = CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
