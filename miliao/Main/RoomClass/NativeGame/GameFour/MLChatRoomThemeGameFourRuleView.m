#import "MLChatRoomThemeGameFourRuleView.h"
#import "Global.h"
#import <Masonry/Masonry.h>

@interface MLChatRoomThemeGameFourRuleView ()

@property (nonatomic, copy) NSString *ruleContent;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *backgroundContainer;
@property (nonatomic, strong) UIView *contentClippingContainer;
@property (nonatomic, strong) UIImageView *ruleBgView;
@property (nonatomic, strong) UITextView *ruleTextView;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation MLChatRoomThemeGameFourRuleView

+ (void)showInView:(UIView *)parentView ruleContent:(NSString *)content {
    MLChatRoomThemeGameFourRuleView *ruleView = [[MLChatRoomThemeGameFourRuleView alloc] initWithFrame:parentView.bounds ruleContent:content];
    [parentView addSubview:ruleView];
    [ruleView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame ruleContent:(NSString *)content {
    if (self = [super initWithFrame:frame]) {
        self.ruleContent = content;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];

    // 1. Semi-transparent black mask view
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tap];

    // 2. Center popup container
    _backgroundContainer = [[UIView alloc] init];
    _backgroundContainer.backgroundColor = [UIColor clearColor];
    [self addSubview:_backgroundContainer];
    [_backgroundContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.85).priorityMedium();
        make.width.mas_lessThanOrEqualTo(KDialogAdaptedWidth(300)).priorityHigh();
        make.height.mas_equalTo(_backgroundContainer.mas_width).multipliedBy(998.0 / 602.0);
    }];

    // 3. Clipped Inner container
    _contentClippingContainer = [[UIView alloc] init];
    _contentClippingContainer.clipsToBounds = YES;
    [_backgroundContainer addSubview:_contentClippingContainer];
    [_contentClippingContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_backgroundContainer);
    }];

    // 3.1 Background image
    _ruleBgView = [[UIImageView alloc] init];
    _ruleBgView.contentMode = UIViewContentModeScaleToFill;
    _ruleBgView.image = [UIImage imageNamed:@"theme_game_four_rule_panel_bg"];
    [_contentClippingContainer addSubview:_ruleBgView];
    [_ruleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_contentClippingContainer);
    }];

    // 3.2 Scrollable text view for rules description
    _ruleTextView = [[UITextView alloc] init];
    _ruleTextView.backgroundColor = [UIColor clearColor];
    _ruleTextView.editable = NO;
    _ruleTextView.selectable = NO;
    _ruleTextView.showsVerticalScrollIndicator = NO;
    _ruleTextView.showsHorizontalScrollIndicator = NO;
    _ruleTextView.textContainerInset = UIEdgeInsetsZero;
    _ruleTextView.textContainer.lineFragmentPadding = 0;
    [_contentClippingContainer addSubview:_ruleTextView];
    [_ruleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(24));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(24));
        make.top.mas_equalTo(KDialogAdaptedWidth(115));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(50));
    }];

    // Populate rule text
    NSString *ruleText = self.ruleContent;
    if (ruleText.length == 0) {
        // Fallback default rules text
        ruleText = @"1. 玩法说明\n本活动共有三种不同档位的福袋可供开启：金色福袋、绿色福袋、蓝色福袋。\n• 金色福袋：每次开启消耗 1 把钥匙。\n• 绿色福袋：每次开启消耗 10 把钥匙。\n• 蓝色福袋：每次开启消耗 100 把钥匙。\n\n2. 钥匙获取\n用户可以使用钻石兑换游戏钥匙，兑换比例为：10 钻石 = 1 把钥匙。\n\n3. 奖励说明\n开启福袋将随机获得不同价值的精美礼物：\n• 金色福袋：概率产出普通及中级礼物。\n• 绿色福袋：高概率产出中级及高级礼物。\n• 蓝色福袋：极高概率产出高级及顶级稀有大奖。\n\n4. 补充说明\n• 获得的礼物将直接发放至您的个人背包中，可在语聊房内赠送给其他用户。\n• 榜单排行根据用户在一个自然周内开启福袋获得的礼物总价值进行排行，每周一凌晨自动重置。";
    }

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = KDialogAdaptedWidth(4); // Match lineSpacingExtra="4dp"
    
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName: kWhiteColor,
        NSFontAttributeName: [UIFont systemFontOfSize:KDialogAdaptedWidth(12)],
        NSParagraphStyleAttributeName: paragraphStyle
    };
    
    _ruleTextView.attributedText = [[NSAttributedString alloc] initWithString:ruleText attributes:attributes];

    // 4. Overlapping Top-Right Close Button
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"theme_game_four_rule_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundContainer addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentClippingContainer).offset(-KDialogAdaptedWidth(8));
        make.trailing.mas_equalTo(_contentClippingContainer).offset(KDialogAdaptedWidth(8));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(34), KDialogAdaptedWidth(36)));
    }];
}

#pragma mark - Animations

- (void)animateShow {
    self.alpha = 0;
    _backgroundContainer.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
        self.backgroundContainer.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)closeClick {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0;
        self.backgroundContainer.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
