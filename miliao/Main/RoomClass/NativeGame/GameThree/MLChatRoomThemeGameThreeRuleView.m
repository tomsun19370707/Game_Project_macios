#import "MLChatRoomThemeGameThreeRuleView.h"
#import "Global.h"
#import <Masonry/Masonry.h>

@interface MLChatRoomThemeGameThreeRuleView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MLChatRoomThemeGameThreeRuleView

+ (void)showInView:(UIView *)parentView {
    MLChatRoomThemeGameThreeRuleView *ruleView = [[MLChatRoomThemeGameThreeRuleView alloc] initWithFrame:parentView.bounds];
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
    // 占位资源使用玩法二规则背景
    _bgImageView.image = [UIImage imageNamed:@"theme_game_two_rule_clean"];
    if (_bgImageView.image == nil) {
         _bgImageView.backgroundColor = mHexRGB(0x111C24); // 玩法三深靛蓝底色
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
    _titleLabel.text = @"星辰规则";
    _titleLabel.textColor = mHexRGB(0xFFE400);
    _titleLabel.font = KFontBoldA(18);
    [_bgImageView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.centerX.mas_equalTo(_bgImageView);
    }];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.backgroundColor = [UIColor clearColor];
    // 占位使用玩法一/二返回按钮
    [_closeButton setImage:[UIImage imageNamed:@"theme_game_two_rule_back"] forState:UIControlStateNormal];
    if ([_closeButton imageForState:UIControlStateNormal] == nil) {
        [_closeButton setTitle:@"✕" forState:UIControlStateNormal];
        [_closeButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    }
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
                          "1. 星辰序章（玩法三）每次启航将消耗指定数量的钥匙代币。\n"
                          "2. 玩家可以点击底部的“启航1次”、“启航10次”、“启航100次”发起探索。\n"
                          "3. 启航后会播放星辰旋转动画，减速停靠在最终落点，之后弹出结算页面并刷新余额。\n\n"
                          "【星辰奖池】\n"
                          "1. 星辰转盘上分布着 18 个星辰格子，对应当前的 18 个稀有大奖。\n"
                          "2. 中奖概率和奖励配置完全遵循后台游戏规则。";
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
