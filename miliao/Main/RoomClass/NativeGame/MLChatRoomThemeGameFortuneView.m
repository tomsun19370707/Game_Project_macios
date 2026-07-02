#import "MLChatRoomThemeGameFortuneView.h"
#import "Global.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

@interface MLChatRoomThemeGameFortuneView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UILabel *consumeTitleLabel;
@property (nonatomic, strong) UILabel *consumeValueLabel;

@property (nonatomic, strong) UILabel *produceTitleLabel;
@property (nonatomic, strong) UILabel *produceValueLabel;

@property (nonatomic, strong) UILabel *yieldTitleLabel;
@property (nonatomic, strong) UILabel *yieldValueLabel;

@property (nonatomic, assign) NSInteger consumeValue;
@property (nonatomic, assign) NSInteger produceValue;

@end

@implementation MLChatRoomThemeGameFortuneView

+ (void)showInView:(UIView *)parentView consume:(NSInteger)consume produce:(NSInteger)produce {
    UIView *targetView = parentView;
    if (!targetView) {
        targetView = [UIApplication sharedApplication].keyWindow;
    }
    if (!targetView) {
        for (UIWindow *w in [UIApplication sharedApplication].windows) {
            if (w.isKeyWindow) {
                targetView = w;
                break;
            }
        }
    }
    if (!targetView) {
        targetView = [UIApplication sharedApplication].windows.firstObject;
    }
    if (!targetView) {
        return;
    }
    
    MLChatRoomThemeGameFortuneView *view = [[MLChatRoomThemeGameFortuneView alloc] initWithFrame:targetView.bounds consume:consume produce:produce];
    [targetView addSubview:view];
    [view animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame consume:(NSInteger)consume produce:(NSInteger)produce {
    if (self = [super initWithFrame:frame]) {
        self.consumeValue = consume;
        self.produceValue = produce;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _maskView.userInteractionEnabled = YES;
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tap];
    
    // 背景板
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_fortune_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(280, 226));
    }];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"今日运势";
    titleLabel.textColor = kWhiteColor;
    titleLabel.font = KFontBoldA(16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bgImageView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24);
        make.centerX.mas_equalTo(_bgImageView);
    }];
    
    // 容器视图，用以垂直布局三行
    UIView *contentContainer = [[UIView alloc] init];
    contentContainer.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:contentContainer];
    [contentContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(20);
        make.leading.mas_equalTo(24);
        make.trailing.mas_equalTo(-24);
        make.bottom.mas_equalTo(-24);
    }];
    
    // 1. 今日消耗
    _consumeTitleLabel = [[UILabel alloc] init];
    _consumeTitleLabel.text = @"今日消耗";
    _consumeTitleLabel.textColor = mHexRGB(0xE1F5FE);
    _consumeTitleLabel.font = [UIFont systemFontOfSize:14];
    [contentContainer addSubview:_consumeTitleLabel];
    [_consumeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.leading.mas_equalTo(12);
    }];
    
    _consumeValueLabel = [[UILabel alloc] init];
    _consumeValueLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)self.consumeValue];
    _consumeValueLabel.textColor = mHexRGB(0xFFD54F);
    _consumeValueLabel.font = KFontBoldA(14);
    _consumeValueLabel.textAlignment = NSTextAlignmentRight;
    [contentContainer addSubview:_consumeValueLabel];
    [_consumeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_consumeTitleLabel);
        make.trailing.mas_equalTo(-12);
    }];
    
    // 2. 今日获得
    _produceTitleLabel = [[UILabel alloc] init];
    _produceTitleLabel.text = @"今日获得";
    _produceTitleLabel.textColor = mHexRGB(0xE1F5FE);
    _produceTitleLabel.font = [UIFont systemFontOfSize:14];
    [contentContainer addSubview:_produceTitleLabel];
    [_produceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_consumeTitleLabel.mas_bottom).offset(16);
        make.leading.mas_equalTo(12);
    }];
    
    _produceValueLabel = [[UILabel alloc] init];
    _produceValueLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)self.produceValue];
    _produceValueLabel.textColor = mHexRGB(0xFFD54F);
    _produceValueLabel.font = KFontBoldA(14);
    _produceValueLabel.textAlignment = NSTextAlignmentRight;
    [contentContainer addSubview:_produceValueLabel];
    [_produceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_produceTitleLabel);
        make.trailing.mas_equalTo(-12);
    }];
    
    // 3. 今日盈利率
    _yieldTitleLabel = [[UILabel alloc] init];
    _yieldTitleLabel.text = @"今日盈利率";
    _yieldTitleLabel.textColor = mHexRGB(0xE1F5FE);
    _yieldTitleLabel.font = [UIFont systemFontOfSize:14];
    [contentContainer addSubview:_yieldTitleLabel];
    [_yieldTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_produceTitleLabel.mas_bottom).offset(16);
        make.leading.mas_equalTo(12);
    }];
    
    _yieldValueLabel = [[UILabel alloc] init];
    _yieldValueLabel.textColor = mHexRGB(0x4CAF50);
    _yieldValueLabel.font = KFontBoldA(16);
    _yieldValueLabel.textAlignment = NSTextAlignmentRight;
    [contentContainer addSubview:_yieldValueLabel];
    [_yieldValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_yieldTitleLabel);
        make.trailing.mas_equalTo(-12);
    }];
    
    // 盈利率计算 (防除零保护)
    if (self.consumeValue <= 0) {
        _yieldValueLabel.text = @"0%";
    } else {
        double yield = (double)self.produceValue / self.consumeValue * 100.0;
        if (yield == (long)yield) {
            _yieldValueLabel.text = [NSString stringWithFormat:@"%ld%%", (long)yield];
        } else {
            _yieldValueLabel.text = [NSString stringWithFormat:@"%.1f%%", yield];
        }
    }
    
    // 关闭按钮
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"theme_game_fortune_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgImageView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

#pragma mark - Actions & Animation

- (void)animateShow {
    self.alpha = 0.0;
    _bgImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    _closeButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.0;
        self.bgImageView.transform = CGAffineTransformIdentity;
        self.closeButton.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)closeClick {
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void (^ _Nullable)(void))completion {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.bgImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.closeButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

@end

#pragma mark - RCConversationCell Category for onlineView

@implementation RCConversationCell (OnlineViewCategory)

- (UIView *)onlineView {
    UIView *view = objc_getAssociatedObject(self, _cmd);
    if (!view) {
        view = [[UIView alloc] init];
        [self.contentView addSubview:view];
        
        if ([self respondsToSelector:@selector(headerImageView)]) {
            UIView *avatar = [self performSelector:@selector(headerImageView)];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.trailing.mas_equalTo(avatar);
                make.size.mas_equalTo(CGSizeMake(10, 10));
            }];
            view.layer.cornerRadius = 5;
            view.layer.masksToBounds = YES;
        } else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(12);
                make.top.mas_equalTo(12);
                make.size.mas_equalTo(CGSizeMake(10, 10));
            }];
        }
        objc_setAssociatedObject(self, _cmd, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return view;
}

@end
