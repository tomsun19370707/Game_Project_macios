#import "MLChatRoomThemeGameOneRuleView.h"
#import "Global.h"

@interface MLChatRoomThemeGameOneRuleView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MLChatRoomThemeGameOneRuleView

+ (void)showInView:(UIView *)parentView {
    MLChatRoomThemeGameOneRuleView *ruleView = [[MLChatRoomThemeGameOneRuleView alloc] initWithFrame:parentView.bounds];
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
    _bgImageView.image = [UIImage imageNamed:@"theme_game_one_rule_popup"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    setViewCorner(_bgImageView, 12);
    [self addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(315, 360));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"玩法规则";
    _titleLabel.textColor = mHexRGB(0xFFE400);
    _titleLabel.font = KFontBoldA(18);
    [_bgImageView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.centerX.mas_equalTo(_bgImageView);
    }];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"theme_game_one_result_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = kWhiteColor;
    _textView.font = KFontA(13);
    _textView.editable = NO;
    _textView.selectable = NO;
    
    NSString *ruleText = @"【玩法说明】\n"
                          "1. 寻梦之旅（玩法一）每次抽奖需消耗指定数量的钥匙代币。\n"
                          "2. 系统包含18格礼物转盘，抽奖时跑马灯将根据算法最终停靠在相应的礼物格子上。\n\n"
                          "【寻梦保底】\n"
                          "1. 每次抽奖均可积累寻梦值（保底值），寻梦值上限为200点。\n"
                          "2. 当寻梦值达到200点时，下一次抽奖将在本地触发保底判定，重置寻梦值为0，且强制定格在第1格大奖。\n\n"
                          "【高级兑换】\n"
                          "1. 您可以使用在游戏里产出的宝石碎片与藏宝图进行高级礼物兑换。\n"
                          "2. 投入藏宝图越多，兑换成功率越高。单张藏宝图将按配置提供固定成功率，最高可达100%。\n"
                          "3. 若不投入任何藏宝图，成功率为0%且必定失败（仍将扣除宝石碎片）。";
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
