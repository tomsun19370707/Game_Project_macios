#import "MLChatRoomThemeGameOneResultView.h"
#import "Global.h"

@interface MLChatRoomThemeGameOneResultView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *totalValueLabel;

@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *mergedGifts;
@property (nonatomic, assign) NSInteger totalValue;
@property (nonatomic, assign) NSInteger drawCount;
@property (nonatomic, copy) void(^retryBlock)(void);

@end

@implementation MLChatRoomThemeGameOneResultView

+ (void)showInView:(UIView *)parentView 
             gifts:(NSArray<MLGameDrawResultModel *> *)gifts 
        totalValue:(NSInteger)value 
        retryBlock:(void(^)(void))retry {
    MLChatRoomThemeGameOneResultView *resultView = [[MLChatRoomThemeGameOneResultView alloc] initWithFrame:parentView.bounds 
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
        self.drawCount = gifts.count;
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
    _bgImageView.image = [UIImage imageNamed:@"theme_game_one_new_result_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(KDialogAdaptedWidth(370));
        make.height.mas_equalTo(KDialogAdaptedWidth(568));
    }];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_new_result_back"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(15));
        make.leading.mas_equalTo(KDialogAdaptedWidth(15));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(31.5), KDialogAdaptedWidth(32.5)));
    }];
    
    _totalValueLabel = [[UILabel alloc] init];
    _totalValueLabel.textColor = mHexRGB(0xFFEB3B);
    _totalValueLabel.font = KFontBoldA(12);
    _totalValueLabel.text = [NSString stringWithFormat:@"总价值：%ld钻石", (long)self.totalValue];
    [_bgImageView addSubview:_totalValueLabel];
    [_totalValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(15));
        make.centerX.mas_equalTo(_bgImageView);
    }];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = YES;
    [_bgImageView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(80));
        make.leading.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(_totalValueLabel.mas_top).offset(-KDialogAdaptedWidth(8));
    }];
    
    [self layoutGiftsInScrollView];
}

- (void)layoutGiftsInScrollView {
    CGFloat itemW = KDialogAdaptedWidth(67.5f);
    CGFloat itemH = KDialogAdaptedWidth(82.0f);
    CGFloat rowGap = KDialogAdaptedWidth(12.0f);
    CGFloat colGap = KDialogAdaptedWidth(10.0f); // 缩小列间距 (21.3 -> 10.0)
    CGFloat sideMargin = KDialogAdaptedWidth(35.0f); // 重新计算居中边距
    NSInteger colCount = 4;
    
    for (int i = 0; i < self.mergedGifts.count; i++) {
        MLGameDrawResultModel *gift = self.mergedGifts[i];
        
        NSInteger row = i / colCount;
        NSInteger col = i % colCount;
        
        UIView *itemBg = [[UIView alloc] init];
        itemBg.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:itemBg];
        [itemBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(row * (itemH + rowGap) + KDialogAdaptedWidth(10));
            make.leading.mas_equalTo(sideMargin + col * (itemW + colGap));
            make.size.mas_equalTo(CGSizeMake(itemW, itemH));
        }];
        
        UIImageView *cardBg = [[UIImageView alloc] init];
        cardBg.image = [UIImage imageNamed:@"theme_game_one_new_result_item_bg"];
        cardBg.contentMode = UIViewContentModeScaleToFill;
        [itemBg addSubview:cardBg];
        [cardBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(itemBg);
        }];
        
        UIImageView *giftImg = [[UIImageView alloc] init];
        giftImg.contentMode = UIViewContentModeScaleAspectFit;
        [itemBg addSubview:giftImg];
        [giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KDialogAdaptedWidth(10));
            make.centerX.mas_equalTo(itemBg);
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(48), KDialogAdaptedWidth(48)));
        }];
        
        NSURL *url = [NSURL URLWithString:[gift imageUrl]];
        if ([giftImg respondsToSelector:@selector(setImageWithURL:placeholder:)]) {
            [giftImg performSelector:@selector(setImageWithURL:placeholder:) withObject:url withObject:[UIImage imageNamed:@""]];
        } else if ([giftImg respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
            [giftImg performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
        }
        
        UIImageView *tagBg = [[UIImageView alloc] init];
        tagBg.image = [UIImage imageNamed:@"theme_game_one_new_result_item_tag_bg"];
        tagBg.contentMode = UIViewContentModeScaleToFill;
        [itemBg addSubview:tagBg];
        [tagBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-KDialogAdaptedWidth(4.5f));
            make.trailing.mas_equalTo(KDialogAdaptedWidth(4.5f));
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(29.5f), KDialogAdaptedWidth(9.0f)));
        }];
        
        UILabel *tagLabel = [[UILabel alloc] init];
        tagLabel.text = @"98%";
        tagLabel.textColor = kWhiteColor;
        tagLabel.font = KFontBoldA(7);
        tagLabel.textAlignment = NSTextAlignmentCenter;
        [tagBg addSubview:tagLabel];
        [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(tagBg);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = mHexRGB(0xE1F5FE);
        nameLabel.font = KFontBoldA(9);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = gift.name;
        [itemBg addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KDialogAdaptedWidth(58));
            make.leading.trailing.mas_equalTo(itemBg);
        }];
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.textColor = mHexRGB(0xFFEB3B);
        priceLabel.font = KFontBoldA(8);
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)gift.price];
        [itemBg addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KDialogAdaptedWidth(68));
            make.leading.trailing.mas_equalTo(itemBg);
        }];
    }
    
    NSInteger totalRows = (self.mergedGifts.count + colCount - 1) / colCount;
    CGFloat contentH = totalRows * (itemH + rowGap) + KDialogAdaptedWidth(20);
    _scrollView.contentSize = CGSizeMake(KDialogAdaptedWidth(370), contentH);
}

- (void)updateGifts:(NSArray<MLGameDrawResultModel *> *)gifts totalValue:(NSInteger)value {
    self.totalValue = value;
    self.drawCount = gifts.count;
    self.mergedGifts = [MLGameDrawResultModel mergeAndSortDrawGifts:gifts];
    
    for (UIView *sub in self.scrollView.subviews) {
        [sub removeFromSuperview];
    }
    
    self.totalValueLabel.text = [NSString stringWithFormat:@"总价值：%ld钻石", (long)self.totalValue];
    [self layoutGiftsInScrollView];
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
