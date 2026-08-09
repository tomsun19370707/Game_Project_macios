//
//  MLChatRoomThemeGameOneGiftView.m
//  miliao
//

#import "MLChatRoomThemeGameOneGiftView.h"
#import "Global.h"
#import <Masonry/Masonry.h>
#import <UIImageView+WebCache.h>

@interface MLChatRoomThemeGameOneGiftView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *totalValueLabel;

@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *prizes;
@property (nonatomic, assign) NSInteger totalValue;

@end

@implementation MLChatRoomThemeGameOneGiftView

+ (void)showInView:(UIView *)parentView prizes:(NSArray<MLGameDrawResultModel *> *)prizes {
    MLChatRoomThemeGameOneGiftView *giftView = [[MLChatRoomThemeGameOneGiftView alloc] initWithFrame:parentView.bounds prizes:prizes];
    [parentView addSubview:giftView];
    [giftView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame prizes:(NSArray<MLGameDrawResultModel *> *)prizes {
    if (self = [super initWithFrame:frame]) {
        self.prizes = prizes;
        NSInteger sum = 0;
        if (prizes) {
            for (MLGameDrawResultModel *m in prizes) {
                sum += m.price;
            }
        }
        self.totalValue = sum;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 半透明黑色遮罩
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    // 点击背景遮罩关闭
    UITapGestureRecognizer *tapMask = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tapMask];
    
    // 玩法 1 原生奖池背景画框 (绑定专属重命名切图: theme_game_one_gift_bg)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_one_gift_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(KDialogAdaptedWidth(370));
        make.height.mas_equalTo(KDialogAdaptedWidth(568));
    }];
    
    // 返回/关闭按钮 (绑定专属重命名切图: theme_game_one_gift_back)
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_gift_back"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(15));
        make.leading.mas_equalTo(KDialogAdaptedWidth(15));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(31.5), KDialogAdaptedWidth(32.5)));
    }];
    
    // 总价值底部展示
    _totalValueLabel = [[UILabel alloc] init];
    _totalValueLabel.textColor = mHexRGB(0xFFEB3B);
    _totalValueLabel.font = KFontBoldA(12);
    _totalValueLabel.text = [NSString stringWithFormat:@"总价值：%ld钻石", (long)self.totalValue];
    [_bgImageView addSubview:_totalValueLabel];
    [_totalValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(15));
        make.centerX.mas_equalTo(_bgImageView);
    }];
    
    // 滚动列表 (top 60pt, 往上提高一些)
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = YES;
    [_bgImageView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(60));
        make.leading.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(_totalValueLabel.mas_top).offset(-KDialogAdaptedWidth(8));
    }];
    
    [self layoutGiftsInScrollView];
}

- (void)layoutGiftsInScrollView {
    if (!self.prizes || self.prizes.count == 0) return;
    
    NSInteger count = self.prizes.count;
    NSInteger colCount = 3;
    CGFloat itemW = KDialogAdaptedWidth(82.0f);
    CGFloat itemH = KDialogAdaptedWidth(96.0f);
    CGFloat sideMargin = KDialogAdaptedWidth(40.0f);
    CGFloat colGap = (KDialogAdaptedWidth(370.0f) - 2 * sideMargin - colCount * itemW) / (colCount - 1);
    CGFloat rowGap = KDialogAdaptedWidth(12.0f);
    
    NSInteger totalRows = (count + colCount - 1) / colCount;
    CGFloat totalH = totalRows * itemH + (totalRows - 1) * rowGap + KDialogAdaptedWidth(20);
    
    for (NSInteger i = 0; i < count; i++) {
        MLGameDrawResultModel *gift = self.prizes[i];
        
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
        
        // 绑定专属重命名卡片底座: theme_game_one_gift_item_bg
        UIImageView *cardBg = [[UIImageView alloc] init];
        cardBg.image = [UIImage imageNamed:@"theme_game_one_gift_item_bg"];
        cardBg.contentMode = UIViewContentModeScaleToFill;
        [itemBg addSubview:cardBg];
        [cardBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(itemBg);
        }];
        
        // 礼物图片
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
        
        // 98% 概率角标 (放大至 36x12 pt, 8.5pt Bold)
        UIImageView *tagBg = [[UIImageView alloc] init];
        tagBg.image = [UIImage imageNamed:@"theme_game_one_gift_item_tag_bg"];
        tagBg.contentMode = UIViewContentModeScaleToFill;
        [itemBg addSubview:tagBg];
        [tagBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-KDialogAdaptedWidth(4.5f));
            make.trailing.mas_equalTo(KDialogAdaptedWidth(4.5f));
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(36.0f), KDialogAdaptedWidth(12.0f)));
        }];
        
        UILabel *tagLabel = [[UILabel alloc] init];
        tagLabel.text = @"98%";
        tagLabel.textColor = kWhiteColor;
        tagLabel.font = KFontBoldA(8.5);
        tagLabel.textAlignment = NSTextAlignmentCenter;
        [tagBg addSubview:tagLabel];
        [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(tagBg);
        }];
        
        // 礼物名称 (智能缩放防截断，往下移动至 top 65pt)
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = mHexRGB(0xE1F5FE);
        nameLabel.font = KFontBoldA(9);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.minimumScaleFactor = 0.6;
        nameLabel.text = gift.name;
        [itemBg addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KDialogAdaptedWidth(65));
            make.leading.trailing.mas_equalTo(itemBg);
        }];
        
        // 钻石价格 (联动下沉)
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.textColor = mHexRGB(0xFFEB3B);
        priceLabel.font = KFontBoldA(9);
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)gift.price];
        [itemBg addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(KDialogAdaptedWidth(3));
            make.leading.trailing.mas_equalTo(itemBg);
        }];
    }
    
    _scrollView.contentSize = CGSizeMake(KDialogAdaptedWidth(370), totalH);
}

- (void)animateShow {
    self.alpha = 0.0;
    _bgImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
        self.bgImageView.transform = CGAffineTransformIdentity;
    }];
}

- (void)closeClick {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.bgImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
