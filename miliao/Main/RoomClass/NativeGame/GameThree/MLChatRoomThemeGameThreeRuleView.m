#import "MLChatRoomThemeGameThreeRuleView.h"
#import "Global.h"
#import <Masonry/Masonry.h>

@interface MLChatRoomThemeGameThreeRuleView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) NSString *ruleContent;

@end

@implementation MLChatRoomThemeGameThreeRuleView

+ (void)showInView:(UIView *)parentView {
    [self showInView:parentView ruleContent:nil];
}

+ (void)showInView:(UIView *)parentView ruleContent:(nullable NSString *)ruleContent {
    MLChatRoomThemeGameThreeRuleView *ruleView = [[MLChatRoomThemeGameThreeRuleView alloc] initWithFrame:parentView.bounds ruleContent:ruleContent];
    [parentView addSubview:ruleView];
    [ruleView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame ruleContent:nil];
}

- (instancetype)initWithFrame:(CGRect)frame ruleContent:(nullable NSString *)ruleContent {
    if (self = [super initWithFrame:frame]) {
        _ruleContent = ruleContent;
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
    // 使用玩法三规则图片背景 (包含全部预渲染好的标题与规则文字)
    _bgImageView.image = [UIImage imageNamed:@"theme_game_three_rule_clean"];
    if (_bgImageView.image == nil) {
         _bgImageView.backgroundColor = mHexRGB(0x111C24); // 玩法三深靛蓝底色
    }
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    setViewCorner(_bgImageView, 12);
    [self addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(self).offset(-KDialogAdaptedWidth(32)).priorityMedium();
        make.width.mas_lessThanOrEqualTo(KDialogAdaptedWidth(344)).priorityHigh();
        make.height.mas_equalTo(_bgImageView.mas_width).multipliedBy(1312.0 / 750.0);
    }];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.backgroundColor = [UIColor clearColor];
    // 使用玩法三专用返回按钮
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"theme_game_three_rule_back"] forState:UIControlStateNormal];
    if ([_closeButton backgroundImageForState:UIControlStateNormal] == nil) {
        [_closeButton setTitle:@"✕" forState:UIControlStateNormal];
        [_closeButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    }
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(28));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(18));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(51), KDialogAdaptedWidth(51)));
    }];
    
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = kWhiteColor;
    _textView.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(12)];
    _textView.editable = NO;
    _textView.selectable = NO;
    
    NSString *defaultText = @"【玩法说明】\n"
                            "1. 魔法星盘包含不同属性星座奖池；\n"
                            "2. 选择单抽或多抽消耗指定数量的钥匙/宝石；\n"
                            "3. 祈愿获得专属星座礼物。";
    _textView.text = (_ruleContent && _ruleContent.length > 0) ? _ruleContent : defaultText;
    [_bgImageView addSubview:_textView];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgImageView.mas_top).offset(KDialogAdaptedWidth(90));
        make.leading.mas_equalTo(KDialogAdaptedWidth(36));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(36));
        make.height.mas_equalTo(KDialogAdaptedWidth(440));
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
