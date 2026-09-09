//
//  MLThemeGameSixGiftCell.m
//  miliao
//

#import "MLThemeGameSixGiftCell.h"
#import "Global.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface MLThemeGameSixBadgeView : UIView
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UILabel *label;
@end

@implementation MLThemeGameSixBadgeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[
            (id)[UIColor colorWithRed:0xFF/255.0 green:0xB3/255.0 blue:0x00/255.0 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0xFF/255.0 green:0x6F/255.0 blue:0x00/255.0 alpha:1.0].CGColor
        ];
        _gradientLayer.startPoint = CGPointMake(0, 0.5);
        _gradientLayer.endPoint = CGPointMake(1, 0.5);
        [self.layer insertSublayer:_gradientLayer atIndex:0];
        
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(7)];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self).insets(UIEdgeInsetsMake(KDialogAdaptedWidth(1), 0, KDialogAdaptedWidth(1), 0));
            make.leading.trailing.mas_equalTo(self).insets(UIEdgeInsetsMake(0, KDialogAdaptedWidth(3), 0, KDialogAdaptedWidth(3)));
        }];
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _gradientLayer.frame = self.bounds;
    
    // 对齐 Android 胶囊角标：右上角 5pt 圆角，左下角 6pt 圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomLeft)
                                                         cornerRadii:CGSizeMake(KDialogAdaptedWidth(5), KDialogAdaptedWidth(6))];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end

@interface MLThemeGameSixGiftCell ()

@property (nonatomic, strong) UIImageView *cardBgImageView;
@property (nonatomic, strong) UILabel *giftNameLabel;
@property (nonatomic, strong) UIImageView *giftIconImageView;
@property (nonatomic, strong) MLThemeGameSixBadgeView *badgeView;
@property (nonatomic, strong) UILabel *valueLabel;

@end

@implementation MLThemeGameSixGiftCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // 1. 卡片主背景图 (theme_game_six_pack_item_bg)
    _cardBgImageView = [[UIImageView alloc] init];
    _cardBgImageView.image = [UIImage imageNamed:@"theme_game_six_pack_item_bg"];
    _cardBgImageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_cardBgImageView];
    [_cardBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    // 2. 顶栏：礼物名称
    _giftNameLabel = [[UILabel alloc] init];
    _giftNameLabel.textColor = [UIColor whiteColor];
    _giftNameLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(10.5)];
    _giftNameLabel.textAlignment = NSTextAlignmentCenter;
    _giftNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_giftNameLabel];
    [_giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(KDialogAdaptedWidth(15));
        make.leading.mas_equalTo(self.contentView).offset(KDialogAdaptedWidth(4));
        make.trailing.mas_equalTo(self.contentView).offset(-KDialogAdaptedWidth(4));
    }];
    
    // 3. 中间：礼物高清 Icon
    _giftIconImageView = [[UIImageView alloc] init];
    _giftIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_giftIconImageView];
    [_giftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(KDialogAdaptedWidth(32));
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(46), KDialogAdaptedWidth(46)));
    }];
    
    // 4. 右上角：下落概率胶囊角标
    _badgeView = [[MLThemeGameSixBadgeView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_badgeView];
    [_badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(KDialogAdaptedWidth(1));
        make.trailing.mas_equalTo(self.contentView).offset(-KDialogAdaptedWidth(1));
        make.height.mas_greaterThanOrEqualTo(KDialogAdaptedWidth(12));
    }];
    
    // 5. 底栏：粉钻价值文本
    _valueLabel = [[UILabel alloc] init];
    _valueLabel.textColor = [UIColor colorWithRed:0xE0/255.0 green:0x38/255.0 blue:0x75/255.0 alpha:1.0];
    _valueLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(10)];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    _valueLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_valueLabel];
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).offset(-KDialogAdaptedWidth(8));
        make.centerX.mas_equalTo(self.contentView);
        make.leading.mas_greaterThanOrEqualTo(self.contentView).offset(KDialogAdaptedWidth(2));
        make.trailing.mas_lessThanOrEqualTo(self.contentView).offset(-KDialogAdaptedWidth(2));
    }];
}

- (void)configureWithModel:(nullable MLTowerGiftModel *)model {
    if (!model) return;
    
    // 1. 礼物名称
    _giftNameLabel.text = model.name.length > 0 ? model.name : @"珍宝礼物";
    
    // 2. 礼物图标
    if (model.image && model.image.length > 0) {
        [_giftIconImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"theme_game_six_ic_token"]];
    } else {
        _giftIconImageView.image = [UIImage imageNamed:@"theme_game_six_ic_token"];
    }
    
    // 3. 钻石价值 (格式化无小数点)
    NSString *rawVal = model.value.length > 0 ? model.value : (model.ratio_coin_value ?: @"0");
    double dVal = [rawVal doubleValue];
    _valueLabel.text = [NSString stringWithFormat:@"💎 %ld", (long)dVal];
    
    // 4. 概率角标格式化 (如 "50.0000" -> "50%", "2.0000" -> "2%")
    NSString *probStr = [MLThemeGameSixGiftCell formatProbability:model.probability_percent];
    if (probStr && probStr.length > 0) {
        _badgeView.hidden = NO;
        _badgeView.label.text = probStr;
    } else {
        _badgeView.hidden = YES;
    }
}

+ (nullable NSString *)formatProbability:(nullable NSString *)rawPercent {
    if (!rawPercent || rawPercent.length == 0) return nil;
    NSString *clean = [rawPercent stringByReplacingOccurrencesOfString:@"%" withString:@""];
    clean = [clean stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (clean.length == 0) return nil;
    
    double val = [clean doubleValue];
    if (val <= 0) return nil;
    if (val == (long)val) {
        return [NSString stringWithFormat:@"%ld%%", (long)val];
    } else {
        return [NSString stringWithFormat:@"%.1f%%", val];
    }
}

@end
