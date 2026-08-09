//
//  MLChatRoomThemeGameTwoGiftView.m
//  miliao
//

#import "MLChatRoomThemeGameTwoGiftView.h"
#import "Global.h"
#import <Masonry/Masonry.h>
#import <UIImageView+WebCache.h>

#define KDialogAdaptedWidth(x) (isPadA ? ceilf((x) * (390.0 / 375.0)) : KAdaptedWidth(x))

@interface MLChatRoomThemeGameTwoGiftView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *totalValueLabel;

@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *mergedGifts;
@property (nonatomic, assign) NSInteger totalValue;

@end

@implementation MLChatRoomThemeGameTwoGiftView

+ (void)showInView:(UIView *)parentView gifts:(NSArray<MLGameDrawResultModel *> *)gifts {
    MLChatRoomThemeGameTwoGiftView *giftView = [[MLChatRoomThemeGameTwoGiftView alloc] initWithFrame:parentView.bounds gifts:gifts];
    [parentView addSubview:giftView];
    [giftView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame gifts:(NSArray<MLGameDrawResultModel *> *)gifts {
    if (self = [super initWithFrame:frame]) {
        NSInteger sum = 0;
        if (gifts) {
            for (MLGameDrawResultModel *m in gifts) {
                sum += m.price;
            }
        }
        self.totalValue = sum;
        self.mergedGifts = [MLGameDrawResultModel mergeAndSortDrawGifts:gifts];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 半透明遮罩
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    // 点击背景遮罩关闭
    UITapGestureRecognizer *tapMask = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tapMask];
    
    // 主画框背景 (绑定专属重命名资源: theme_game_two_gift_bg)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_two_gift_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(375), KDialogAdaptedWidth(663)));
    }];
    
    // 关闭按钮 (绑定专属重命名资源: theme_game_two_gift_close)
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"theme_game_two_gift_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(16));
        make.leading.mas_equalTo(KDialogAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(36), KDialogAdaptedWidth(36)));
    }];
    
    // 滚动列表
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
    if (!self.mergedGifts || self.mergedGifts.count == 0) return;
    
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
        
        // 绑定专属重命名卡片底座: theme_game_two_gift_item_bg
        UIImageView *cardImg = [[UIImageView alloc] init];
        cardImg.image = [UIImage imageNamed:@"theme_game_two_gift_item_bg"];
        cardImg.userInteractionEnabled = YES;
        [itemBg addSubview:cardImg];
        [cardImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(itemBg);
            make.height.mas_equalTo(cardH);
        }];
        
        // 礼物图片
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
        
        // 礼物名称 (智能防截断自适应，往下移动至 offset 6pt)
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = kWhiteColor;
        nameLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(10)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.minimumScaleFactor = 0.6;
        nameLabel.text = gift.name;
        [cardImg addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(giftImg.mas_bottom).offset(KDialogAdaptedWidth(6));
            make.leading.trailing.mas_equalTo(cardImg);
        }];
        
        // 钻石价格
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.textColor = kWhiteColor;
        valueLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(10)];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.adjustsFontSizeToFitWidth = YES;
        valueLabel.minimumScaleFactor = 0.7;
        valueLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)gift.price];
        [cardImg addSubview:valueLabel];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(KDialogAdaptedWidth(2));
            make.leading.trailing.mas_equalTo(cardImg);
        }];
        
        // 98% 概率角标 (绑定专属重命名资源: theme_game_two_gift_item_badge)
        UIImageView *badgeBg = [[UIImageView alloc] init];
        badgeBg.image = [UIImage imageNamed:@"theme_game_two_gift_item_badge"];
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
    }
    
    NSInteger totalRows = (self.mergedGifts.count + colCount - 1) / colCount;
    CGFloat contentH = totalRows * (itemH + rowGap) + rowGap;
    _scrollView.contentSize = CGSizeMake(KDialogAdaptedWidth(359), contentH);
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
