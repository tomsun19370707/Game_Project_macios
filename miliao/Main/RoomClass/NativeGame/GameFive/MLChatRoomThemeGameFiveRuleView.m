//
//  MLChatRoomThemeGameFiveRuleView.m
//  miliao
//

#import "MLChatRoomThemeGameFiveRuleView.h"
#import "Global.h"
#import <Masonry/Masonry.h>

@interface MLChatRoomThemeGameFiveRuleView ()

@property (nonatomic, copy) NSString *ruleContent;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *backgroundContainer;
@property (nonatomic, strong) UIView *contentClippingContainer;
@property (nonatomic, strong) UIImageView *ruleBgView;
@property (nonatomic, strong) UITextView *ruleTextView;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation MLChatRoomThemeGameFiveRuleView

+ (void)showInView:(UIView *)parentView {
    [self showInView:parentView ruleContent:nil];
}

+ (void)showInView:(UIView *)parentView ruleContent:(nullable NSString *)content {
    MLChatRoomThemeGameFiveRuleView *ruleView = [[MLChatRoomThemeGameFiveRuleView alloc] initWithFrame:parentView.bounds ruleContent:content];
    [parentView addSubview:ruleView];
    [ruleView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame ruleContent:(nullable NSString *)content {
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
        make.width.mas_equalTo(KDialogAdaptedWidth(270));
        make.height.mas_equalTo(_backgroundContainer.mas_width).multipliedBy(988.0 / 686.0);
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
    _ruleBgView.image = [UIImage imageNamed:@"theme_game_five_rule_bg"];
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
        make.leading.mas_equalTo(KDialogAdaptedWidth(22));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(22));
        make.top.mas_equalTo(KDialogAdaptedWidth(102));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(42));
    }];

    // Populate rule text
    NSString *ruleText = self.ruleContent;
    if (ruleText.length == 0) {
        // Fallback default rules text
        ruleText = @"1. 玩法说明\n本活动为奇妙星球探索活动，使用钻石兑换钥匙即可开启探索，获得精美礼物。\n\n2. 钻石兑换\n用户可兑换专属钥匙，兑换比例为：10 钻石 = 1 把钥匙。\n\n3. 奇妙探索\n• 开启 1 次探索：消耗 236 钻石，赠送金钥匙*23，赠送抽奖1次。\n• 开启 10 次探索：消耗 2360 钻石，赠送金钥匙*230，赠送抽奖10次。\n• 开启 100 次探索：消耗 23600 钻石，赠送金钥匙*2300，赠送抽奖100次。";
    }

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = KDialogAdaptedWidth(4);
    
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName: kWhiteColor,
        NSFontAttributeName: [UIFont systemFontOfSize:KDialogAdaptedWidth(12)],
        NSParagraphStyleAttributeName: paragraphStyle
    };
    
    _ruleTextView.attributedText = [[NSAttributedString alloc] initWithString:ruleText attributes:attributes];

    // 4. Overlapping Top-Right Close Button
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"theme_game_five_rule_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundContainer addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentClippingContainer).offset(KDialogAdaptedWidth(10));
        make.trailing.mas_equalTo(_contentClippingContainer).offset(-KDialogAdaptedWidth(10));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(24), KDialogAdaptedWidth(24)));
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
