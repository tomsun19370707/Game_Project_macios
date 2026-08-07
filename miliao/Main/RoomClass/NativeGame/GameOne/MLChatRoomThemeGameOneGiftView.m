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
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSArray<MLGameDrawResultModel *> *prizes;

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
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 半透明黑色遮罩
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    // 点击背景遮罩关闭
    UITapGestureRecognizer *tapMask = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tapMask];
    
    // 复用 玩法 1 原生结果背景画框 (theme_game_one_new_result_bg: 740 x 1136)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_one_new_result_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(KDialogAdaptedWidth(370));
        make.height.mas_equalTo(KDialogAdaptedWidth(568));
    }];
    
    // 返回/关闭按钮 (theme_game_one_new_result_back)
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_new_result_back"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(15));
        make.leading.mas_equalTo(KDialogAdaptedWidth(15));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(31.5), KDialogAdaptedWidth(32.5)));
    }];
    
    // 标题【奖品池】
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"奖品池";
    _titleLabel.textColor = mHexRGB(0xFFE57F);
    _titleLabel.font = KFontBoldA(16);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bgImageView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_closeButton);
        make.centerX.mas_equalTo(_bgImageView);
    }];
    
    // 滚动轴
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    [_bgImageView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(70));
        make.leading.mas_equalTo(KDialogAdaptedWidth(20));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(20));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(25));
    }];
    
    [self layout4ColumnGridPrizes];
}

- (void)layout4ColumnGridPrizes {
    if (!self.prizes || self.prizes.count == 0) return;
    
    NSInteger count = self.prizes.count;
    NSInteger cols = 4; // 4 列网格
    CGFloat colMargin = KDialogAdaptedWidth(8.0);
    CGFloat rowMargin = KDialogAdaptedWidth(12.0);
    
    CGFloat containerW = KDialogAdaptedWidth(330.0); // 370 - 2*20
    CGFloat itemW = (containerW - (cols - 1) * colMargin) / (CGFloat)cols;
    CGFloat itemH = KDialogAdaptedWidth(82.0);
    
    UIView *contentContainer = [[UIView alloc] init];
    [_scrollView addSubview:contentContainer];
    
    for (NSInteger i = 0; i < count; i++) {
        MLGameDrawResultModel *model = self.prizes[i];
        NSInteger row = i / cols;
        NSInteger col = i % cols;
        
        CGFloat left = col * (itemW + colMargin);
        CGFloat top = row * (itemH + rowMargin);
        
        UIView *card = [[UIView alloc] initWithFrame:CGRectMake(left, top, itemW, itemH)];
        card.clipsToBounds = YES;
        [contentContainer addSubview:card];
        
        // 轮流卡牌背景 (theme_game_one_gift_board_1~4)
        UIImageView *boardBg = [[UIImageView alloc] init];
        NSString *bgName = [NSString stringWithFormat:@"theme_game_one_gift_board_%ld", (long)(i % 4) + 1];
        boardBg.image = [UIImage imageNamed:bgName];
        boardBg.contentMode = UIViewContentModeScaleToFill;
        [card addSubview:boardBg];
        [boardBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(card);
        }];
        
        // 卡牌内缩边距 礼物图标
        UIImageView *iconImg = [[UIImageView alloc] init];
        iconImg.contentMode = UIViewContentModeScaleAspectFit;
        NSString *imgUrl = [model imageUrl];
        if (imgUrl && imgUrl.length > 0) {
            [iconImg sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        }
        [card addSubview:iconImg];
        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KDialogAdaptedWidth(6));
            make.centerX.mas_equalTo(card);
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(40), KDialogAdaptedWidth(40)));
        }];
        
        // 礼物名称
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = model.name ?: @"";
        nameLabel.textColor = kWhiteColor;
        nameLabel.font = [UIFont systemFontOfSize:9.0 weight:UIFontWeightMedium];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [card addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(iconImg.mas_bottom).offset(KDialogAdaptedWidth(2));
            make.leading.trailing.mas_equalTo(card);
        }];
        
        // 💎 钻石价值
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.text = [NSString stringWithFormat:@"%ld💎", (long)model.price];
        priceLabel.textColor = mHexRGB(0xFFE57F);
        priceLabel.font = [UIFont boldSystemFontOfSize:8.5];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        [card addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(KDialogAdaptedWidth(1));
            make.leading.trailing.mas_equalTo(card);
        }];
    }
    
    NSInteger totalRows = (count + cols - 1) / cols;
    CGFloat totalH = totalRows * itemH + (totalRows - 1) * rowMargin;
    
    contentContainer.frame = CGRectMake(0, 0, containerW, totalH);
    _scrollView.contentSize = CGSizeMake(containerW, totalH);
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
