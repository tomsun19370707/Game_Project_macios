#import "MLChatRoomThemeGameTwoRuleView.h"
#import "Global.h"

@interface MLChatRoomThemeGameTwoRuleView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) NSString *ruleContent;

@end

@implementation MLChatRoomThemeGameTwoRuleView

+ (void)showInView:(UIView *)parentView {
    [self showInView:parentView ruleContent:nil];
}

+ (void)showInView:(UIView *)parentView ruleContent:(nullable NSString *)ruleContent {
    MLChatRoomThemeGameTwoRuleView *ruleView = [[MLChatRoomThemeGameTwoRuleView alloc] initWithFrame:parentView.bounds ruleContent:ruleContent];
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
    _bgImageView.image = [UIImage imageNamed:@"theme_game_two_rule_clean"];
    if (_bgImageView.image == nil) {
         _bgImageView.backgroundColor = mHexRGB(0x1F142E); // 玩法二深紫夜空色调兜底
    }
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    setViewCorner(_bgImageView, 12);
    [self addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(self).offset(-KDialogAdaptedWidth(32)).priorityMedium();
        make.width.mas_lessThanOrEqualTo(KDialogAdaptedWidth(344));
        make.height.mas_equalTo(_bgImageView.mas_width).multipliedBy(1326.0 / 750.0);
    }];
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"theme_game_two_rule_back"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(28));
        make.leading.mas_equalTo(KDialogAdaptedWidth(32));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(44), KDialogAdaptedWidth(44)));
    }];
    
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = kWhiteColor;
    _textView.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(12)];
    _textView.editable = NO;
    _textView.selectable = NO;
    
    NSString *defaultText = @"【玩法说明】\n"
                            "1. 幸运转盘包含固定 9 格经典奖池；\n"
                            "2. 选择单抽或多抽消耗指定数量的宝石/钥匙；\n"
                            "3. 转盘定格即为获得的中奖礼物。";
    _textView.text = (_ruleContent && _ruleContent.length > 0) ? _ruleContent : defaultText;
    [_bgImageView addSubview:_textView];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgImageView.mas_top).offset(KDialogAdaptedWidth(125));
        make.leading.mas_equalTo(KDialogAdaptedWidth(36));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(36));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(45));
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
