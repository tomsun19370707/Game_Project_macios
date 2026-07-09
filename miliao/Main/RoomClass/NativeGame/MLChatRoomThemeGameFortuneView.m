#import "MLChatRoomThemeGameFortuneView.h"
#import "Global.h"
#import <Masonry/Masonry.h>


@interface MLChatRoomThemeGameFortuneView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIImageView *consumeBox;
@property (nonatomic, strong) UILabel *consumeTitleLabel;
@property (nonatomic, strong) UILabel *consumeValueLabel;

@property (nonatomic, strong) UIImageView *produceBox;
@property (nonatomic, strong) UILabel *produceTitleLabel;
@property (nonatomic, strong) UILabel *produceValueLabel;

@property (nonatomic, strong) UIImageView *yieldBox;
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
    
    // 背景板 (300 x 330)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_fortune_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(300), KDialogAdaptedWidth(330)));
    }];

    // 1. 今日消耗
    _consumeBox = [[UIImageView alloc] init];
    _consumeBox.image = [UIImage imageNamed:@"theme_game_fortune_frame"];
    _consumeBox.contentMode = UIViewContentModeScaleToFill;
    _consumeBox.userInteractionEnabled = YES;
    [_bgImageView addSubview:_consumeBox];
    [_consumeBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgImageView.mas_top).offset(KDialogAdaptedWidth(75));
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(250), KDialogAdaptedWidth(54)));
    }];
    
    _consumeTitleLabel = [[UILabel alloc] init];
    _consumeTitleLabel.text = @"今日消耗：";
    _consumeTitleLabel.textColor = kWhiteColor;
    _consumeTitleLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(14)];
    [_consumeBox addSubview:_consumeTitleLabel];
    [_consumeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_consumeBox);
        make.leading.mas_equalTo(KDialogAdaptedWidth(20));
    }];
    
    _consumeValueLabel = [[UILabel alloc] init];
    _consumeValueLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)self.consumeValue];
    _consumeValueLabel.textColor = mHexRGB(0xFFEB3B);
    _consumeValueLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(14)];
    _consumeValueLabel.textAlignment = NSTextAlignmentRight;
    [_consumeBox addSubview:_consumeValueLabel];
    [_consumeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_consumeBox);
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(20));
    }];
    
    // 2. 今日产出
    _produceBox = [[UIImageView alloc] init];
    _produceBox.image = [UIImage imageNamed:@"theme_game_fortune_frame"];
    _produceBox.contentMode = UIViewContentModeScaleToFill;
    _produceBox.userInteractionEnabled = YES;
    [_bgImageView addSubview:_produceBox];
    [_produceBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_consumeBox.mas_bottom).offset(KDialogAdaptedWidth(12));
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(250), KDialogAdaptedWidth(54)));
    }];
    
    _produceTitleLabel = [[UILabel alloc] init];
    _produceTitleLabel.text = @"今日产出：";
    _produceTitleLabel.textColor = kWhiteColor;
    _produceTitleLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(14)];
    [_produceBox addSubview:_produceTitleLabel];
    [_produceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_produceBox);
        make.leading.mas_equalTo(KDialogAdaptedWidth(20));
    }];
    
    _produceValueLabel = [[UILabel alloc] init];
    _produceValueLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)self.produceValue];
    _produceValueLabel.textColor = mHexRGB(0xFFEB3B);
    _produceValueLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(14)];
    _produceValueLabel.textAlignment = NSTextAlignmentRight;
    [_produceBox addSubview:_produceValueLabel];
    [_produceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_produceBox);
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(20));
    }];
    
    // 3. 今日盈利率
    _yieldBox = [[UIImageView alloc] init];
    _yieldBox.image = [UIImage imageNamed:@"theme_game_fortune_frame"];
    _yieldBox.contentMode = UIViewContentModeScaleToFill;
    _yieldBox.userInteractionEnabled = YES;
    [_bgImageView addSubview:_yieldBox];
    [_yieldBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_produceBox.mas_bottom).offset(KDialogAdaptedWidth(12));
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(250), KDialogAdaptedWidth(54)));
    }];
    
    _yieldTitleLabel = [[UILabel alloc] init];
    _yieldTitleLabel.text = @"收益率：";
    _yieldTitleLabel.textColor = kWhiteColor;
    _yieldTitleLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(14)];
    [_yieldBox addSubview:_yieldTitleLabel];
    [_yieldTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_yieldBox);
        make.leading.mas_equalTo(KDialogAdaptedWidth(20));
    }];
    
    _yieldValueLabel = [[UILabel alloc] init];
    _yieldValueLabel.textColor = mHexRGB(0x00FFC4);
    _yieldValueLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(14)];
    _yieldValueLabel.textAlignment = NSTextAlignmentRight;
    [_yieldBox addSubview:_yieldValueLabel];
    [_yieldValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_yieldBox);
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(20));
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
    
    // 关闭按钮 (移至右上角)
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"theme_game_fortune_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(10));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(10));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(30), KDialogAdaptedWidth(30)));
    }];
}

#pragma mark - Actions & Animation

- (void)animateShow {
    self.alpha = 0.0;
    _bgImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.0;
        self.bgImageView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)closeClick {
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void (^ _Nullable)(void))completion {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.bgImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

@end

