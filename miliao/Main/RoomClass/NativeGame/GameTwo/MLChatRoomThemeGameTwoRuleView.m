#import "MLChatRoomThemeGameTwoRuleView.h"
#import "Global.h"

@interface MLChatRoomThemeGameTwoRuleView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MLChatRoomThemeGameTwoRuleView

+ (void)showInView:(UIView *)parentView {
    MLChatRoomThemeGameTwoRuleView *ruleView = [[MLChatRoomThemeGameTwoRuleView alloc] initWithFrame:parentView.bounds];
    [parentView addSubview:ruleView];
    [ruleView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tap];
    
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_two_rule_clean"];
    if (_bgImageView.image == nil) {
         _bgImageView.backgroundColor = mHexRGB(0x1F142E); // 玩法二深紫夜空色调兜底
    }
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    setViewCorner(_bgImageView, 12);
    [self addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(315, 360));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"神木规则";
    _titleLabel.textColor = mHexRGB(0xFFE400);
    _titleLabel.font = KFontBoldA(18);
    [_bgImageView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.centerX.mas_equalTo(_bgImageView);
    }];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"theme_game_two_rule_back"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(28);
        make.leading.mas_equalTo(32);
        make.size.mas_equalTo(CGSizeMake(34, 34));
    }];
    
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = kWhiteColor;
    _textView.font = KFontA(13);
    _textView.editable = NO;
    _textView.selectable = NO;
    
    NSString *ruleText = @"【玩法说明】\n"
                          "1. 神木栖灵（玩法二）每次祝灵将消耗指定数量的钥匙代币。\n"
                          "2. 玩家可以点击底部的“祝灵1次”、“祝灵10次”、“祝灵100次”发起祈福。\n"
                          "3. 点击祝灵后起播炫酷全屏动画，动画播放完毕直接发放奖励并展出结算页面。\n\n"
                          "【神木奖池】\n"
                          "1. 神木大树上静态悬挂展示着 9 个灵果，对应当前的 9 个主推稀有大奖。\n"
                          "2. 树上的灵果纯静态展示，不支持单手势点击单抽。所有中奖结果均通过底部的祝灵按钮触发计算，随机发落大奖。";
    _textView.text = ruleText;
    [_bgImageView addSubview:_textView];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(15);
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.bottom.mas_equalTo(-20);
    }];
}

- (void)animateShow {
    self.alpha = 0.0;
    _bgImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.2 animations:^{
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
