#import "MLChatRoomThemeGameOneRuleView.h"
#import "Global.h"

@interface MLChatRoomThemeGameOneRuleView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) NSString *ruleContent;

@end

@implementation MLChatRoomThemeGameOneRuleView

+ (void)showInView:(UIView *)parentView {
    [self showInView:parentView ruleContent:nil];
}

+ (void)showInView:(UIView *)parentView ruleContent:(nullable NSString *)ruleContent {
    MLChatRoomThemeGameOneRuleView *ruleView = [[MLChatRoomThemeGameOneRuleView alloc] initWithFrame:parentView.bounds ruleContent:ruleContent];
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
    _bgImageView.image = [UIImage imageNamed:@"theme_game_one_rule_popup"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    setViewCorner(_bgImageView, KDialogAdaptedWidth(12));
    [self addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(343), KDialogAdaptedWidth(527)));
    }];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_rule_back"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bgImageView.mas_top).offset(KDialogAdaptedWidth(37));
        make.leading.mas_equalTo(KDialogAdaptedWidth(14));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(42), KDialogAdaptedWidth(44)));
    }];
    
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = kWhiteColor;
    _textView.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(12)];
    _textView.editable = NO;
    _textView.selectable = NO;
    
    NSString *defaultText = @"【玩法说明】\n"
                            "1. 寻梦之旅（玩法一）每次抽奖需消耗指定数量的钥匙代币。\n"
                            "2. 系统包含18格礼物转盘，抽奖时跑马灯将根据算法最终停靠在相应的礼物格子上。\n\n"
                            "【寻梦保底】\n"
                            "1. 每次抽奖均可积累寻梦值（保底值），寻梦值上限为200点。\n"
                            "2. 当寻梦值达到200点时，下一次抽奖将在本地触发保底判定，重置寻梦值为0，且强制定格在第1格大奖。\n\n"
                            "【高级兑换】\n"
                            "1. 您可以使用在游戏里产出的宝石碎片与藏宝图进行高级礼物兑换。\n"
                            "2. 投入藏宝图越多，兑换成功率越高。单张藏宝图将按配置提供固定成功率，最高可达100%。\n"
                            "3. 若不投入任何藏宝图，成功率为0%且必定失败（仍将扣除宝石碎片）。";
    _textView.text = (_ruleContent && _ruleContent.length > 0) ? _ruleContent : defaultText;
    [_bgImageView addSubview:_textView];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgImageView.mas_top).offset(KDialogAdaptedWidth(85));
        make.leading.mas_equalTo(KDialogAdaptedWidth(36));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(36));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(45));
    }];
}

- (void)animateShow {
    self.alpha = 0.0;
    _bgImageView.transform = CGAffineTransformMakeTranslation(0, KDialogAdaptedWidth(527));
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
        self.bgImageView.transform = CGAffineTransformIdentity;
    }];
}

- (void)closeClick {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
        _bgImageView.transform = CGAffineTransformMakeTranslation(0, KDialogAdaptedWidth(527));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
