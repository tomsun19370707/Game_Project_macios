//
//  MLChatRoomThemeGameTwoFortuneView.m
//  miliao
//

#import "MLChatRoomThemeGameTwoFortuneView.h"
#import "MLGameLotteryService.h"
#import "Global.h"
#import <Masonry/Masonry.h>

@interface MLChatRoomThemeGameTwoFortuneView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;

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

@implementation MLChatRoomThemeGameTwoFortuneView

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
    
    MLChatRoomThemeGameTwoFortuneView *view = [[MLChatRoomThemeGameTwoFortuneView alloc] initWithFrame:targetView.bounds consume:consume produce:produce];
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
    
    // 1. Mask Overlap
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _maskView.userInteractionEnabled = YES;
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tap];
    
    // 2. Aspect-Ratio Locked Main Container (750:672 -> 320pt x 287pt)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_two_fortune_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(320), KDialogAdaptedWidth(287)));
    }];
    
    // 防点击穿透遮罩关闭
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgClick)];
    [_bgImageView addGestureRecognizer:bgTap];

    CGFloat itemW = KDialogAdaptedWidth(250.0f);
    CGFloat itemH = KDialogAdaptedWidth(56.0f);
    CGFloat marginX = KDialogAdaptedWidth(44.0f);

    // Item 1: 今日消耗
    _consumeBox = [[UIImageView alloc] init];
    _consumeBox.image = [UIImage imageNamed:@"theme_game_two_fortune_item_bg"];
    _consumeBox.contentMode = UIViewContentModeScaleToFill;
    _consumeBox.userInteractionEnabled = YES;
    [_bgImageView addSubview:_consumeBox];
    [_consumeBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgImageView.mas_top).offset(KDialogAdaptedWidth(72));
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(itemW, itemH));
    }];

    _consumeTitleLabel = [[UILabel alloc] init];
    _consumeTitleLabel.text = @"今日消耗";
    _consumeTitleLabel.textColor = mHexRGB(0xE0D8FF);
    _consumeTitleLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(12)];
    [_consumeBox addSubview:_consumeTitleLabel];
    [_consumeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_consumeBox.mas_leading).offset(marginX);
        make.centerY.mas_equalTo(_consumeBox);
    }];

    _consumeValueLabel = [[UILabel alloc] init];
    _consumeValueLabel.textColor = mHexRGB(0xFFE66F);
    _consumeValueLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(13)];
    _consumeValueLabel.textAlignment = NSTextAlignmentRight;
    _consumeValueLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _consumeValueLabel.text = [NSString stringWithFormat:@"%@钻石", MLFormatLargeNumber((double)self.consumeValue)];
    [_consumeBox addSubview:_consumeValueLabel];
    [_consumeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(_consumeBox.mas_trailing).offset(-marginX);
        make.centerY.mas_equalTo(_consumeBox);
        make.leading.mas_greaterThanOrEqualTo(_consumeTitleLabel.mas_trailing).offset(KDialogAdaptedWidth(6));
    }];

    // Item 2: 今日产出
    _produceBox = [[UIImageView alloc] init];
    _produceBox.image = [UIImage imageNamed:@"theme_game_two_fortune_item_bg"];
    _produceBox.contentMode = UIViewContentModeScaleToFill;
    _produceBox.userInteractionEnabled = YES;
    [_bgImageView addSubview:_produceBox];
    [_produceBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_consumeBox.mas_bottom).offset(KDialogAdaptedWidth(4));
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(itemW, itemH));
    }];

    _produceTitleLabel = [[UILabel alloc] init];
    _produceTitleLabel.text = @"今日产出";
    _produceTitleLabel.textColor = mHexRGB(0xE0D8FF);
    _produceTitleLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(12)];
    [_produceBox addSubview:_produceTitleLabel];
    [_produceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_produceBox.mas_leading).offset(marginX);
        make.centerY.mas_equalTo(_produceBox);
    }];

    _produceValueLabel = [[UILabel alloc] init];
    _produceValueLabel.textColor = mHexRGB(0xFFE66F);
    _produceValueLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(13)];
    _produceValueLabel.textAlignment = NSTextAlignmentRight;
    _produceValueLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _produceValueLabel.text = [NSString stringWithFormat:@"%@钻石", MLFormatLargeNumber((double)self.produceValue)];
    [_produceBox addSubview:_produceValueLabel];
    [_produceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(_produceBox.mas_trailing).offset(-marginX);
        make.centerY.mas_equalTo(_produceBox);
        make.leading.mas_greaterThanOrEqualTo(_produceTitleLabel.mas_trailing).offset(KDialogAdaptedWidth(6));
    }];

    // Item 3: 运势爆率
    _yieldBox = [[UIImageView alloc] init];
    _yieldBox.image = [UIImage imageNamed:@"theme_game_two_fortune_item_bg"];
    _yieldBox.contentMode = UIViewContentModeScaleToFill;
    _yieldBox.userInteractionEnabled = YES;
    [_bgImageView addSubview:_yieldBox];
    [_yieldBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_produceBox.mas_bottom).offset(KDialogAdaptedWidth(4));
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(itemW, itemH));
    }];

    _yieldTitleLabel = [[UILabel alloc] init];
    _yieldTitleLabel.text = @"运势爆率";
    _yieldTitleLabel.textColor = mHexRGB(0xE0D8FF);
    _yieldTitleLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(12)];
    [_yieldBox addSubview:_yieldTitleLabel];
    [_yieldTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_yieldBox.mas_leading).offset(marginX);
        make.centerY.mas_equalTo(_yieldBox);
    }];

    _yieldValueLabel = [[UILabel alloc] init];
    _yieldValueLabel.textColor = mHexRGB(0xFFE66F);
    _yieldValueLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(13)];
    _yieldValueLabel.textAlignment = NSTextAlignmentRight;
    _yieldValueLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    if (self.consumeValue <= 0) {
        _yieldValueLabel.text = @"0%";
    } else {
        double yield = (double)self.produceValue / (double)self.consumeValue * 100.0;
        if (fmod(yield, 1.0) == 0.0) {
            _yieldValueLabel.text = [NSString stringWithFormat:@"%.0f%%", yield];
        } else {
            _yieldValueLabel.text = [NSString stringWithFormat:@"%.1f%%", yield];
        }
    }
    [_yieldBox addSubview:_yieldValueLabel];
    [_yieldValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(_yieldBox.mas_trailing).offset(-marginX);
        make.centerY.mas_equalTo(_yieldBox);
        make.leading.mas_greaterThanOrEqualTo(_yieldTitleLabel.mas_trailing).offset(KDialogAdaptedWidth(6));
    }];
}

- (void)bgClick {
    // 消费面板点击事件，防止穿透
}

- (void)animateShow {
    self.alpha = 0.0;
    self.bgImageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1.0;
        self.bgImageView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)closeClick {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.bgImageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
