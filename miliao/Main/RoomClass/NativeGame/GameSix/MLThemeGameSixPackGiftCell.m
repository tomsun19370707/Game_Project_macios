//
//  MLThemeGameSixPackGiftCell.m
//  miliao
//

#import "MLThemeGameSixPackGiftCell.h"
#import "Global.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface MLThemeGameSixPackGiftCell ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIView *selectedMaskView;
@property (nonatomic, strong) UIImageView *checkMarkImageView;

@end

@implementation MLThemeGameSixPackGiftCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // 1. 卡片背景图 (theme_game_six_pack_item_bg / 礼物背景.png)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_six_pack_item_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    // 2. 顶栏礼物名称
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(9)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(10));
        make.leading.mas_equalTo(KDialogAdaptedWidth(8));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(26));
    }];
    
    // 3. 右上角数量标记 (如 x4)
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(9)];
    _countLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_countLabel];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(10));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(8));
    }];
    
    // 4. 中间礼物 Icon 图片 (AspectFit 居中)
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView).centerOffset(CGPointMake(0, -KDialogAdaptedWidth(2)));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(42), KDialogAdaptedWidth(42)));
    }];
    
    // 5. 底栏 💎 钻石价值文本
    _valueLabel = [[UILabel alloc] init];
    _valueLabel.textColor = [UIColor colorWithRed:0xFF/255.0 green:0x44/255.0 blue:0x88/255.0 alpha:1.0];
    _valueLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(11)];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_valueLabel];
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).offset(-KDialogAdaptedWidth(8));
        make.centerX.mas_equalTo(self.contentView);
    }];
    
    // 6. 选中遮罩与对勾角标
    _selectedMaskView = [[UIView alloc] init];
    _selectedMaskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    _selectedMaskView.layer.cornerRadius = KDialogAdaptedWidth(8);
    _selectedMaskView.layer.borderWidth = KDialogAdaptedWidth(2.0);
    _selectedMaskView.layer.borderColor = [UIColor colorWithRed:0x88/255.0 green:0xFF/255.0 blue:0x88/255.0 alpha:1.0].CGColor;
    _selectedMaskView.hidden = YES;
    [self.contentView addSubview:_selectedMaskView];
    [_selectedMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    _checkMarkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme_game_six_rule_check"] ? : [UIImage imageNamed:@"theme_game_six_ic_token"]];
    _checkMarkImageView.contentMode = UIViewContentModeScaleAspectFit;
    _checkMarkImageView.hidden = YES;
    [self.contentView addSubview:_checkMarkImageView];
    [_checkMarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(4));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(4));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(16), KDialogAdaptedWidth(16)));
    }];
}

- (void)configureWithModel:(MLTowerGameSixTempInventoryModel *)model isSelected:(BOOL)isSelected {
    if (!model) return;
    
    _nameLabel.text = model.name ?: @"暂存礼物";
    _countLabel.text = [NSString stringWithFormat:@"x%ld", (long)(model.num > 0 ? model.num : 1)];
    
    NSString *valStr = model.unit_value ?: @"0";
    double val = [valStr doubleValue];
    _valueLabel.text = [NSString stringWithFormat:@"💎 %.0f", val];
    
    if (model.image && model.image.length > 0) {
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"theme_game_six_ic_token"]];
    } else {
        _iconImageView.image = [UIImage imageNamed:@"theme_game_six_ic_token"];
    }
    
    _selectedMaskView.hidden = !isSelected;
    _checkMarkImageView.hidden = !isSelected;
    self.contentView.transform = isSelected ? CGAffineTransformMakeScale(1.03, 1.03) : CGAffineTransformIdentity;
}

@end
