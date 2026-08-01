#import "MLThemeGameSixRecordCell.h"
#import "Global.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MLThemeGameSixRecordCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // 1. 卡片金框背景图 (theme_game_six_record_item_bg / 礼物背景图.png)
    _cardBgImageView = [[UIImageView alloc] init];
    _cardBgImageView.image = [UIImage imageNamed:@"theme_game_six_record_item_bg"];
    _cardBgImageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_cardBgImageView];
    [_cardBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    // 2. 礼物 Icon (44x44 pt 居中下移)
    _giftIconImageView = [[UIImageView alloc] init];
    _giftIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_giftIconImageView];
    [_giftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView).offset(KDialogAdaptedWidth(3));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(44), KDialogAdaptedWidth(44)));
    }];
    
    // 3. 礼物名称与数量组合文本 (底栏粉红文本下移)
    _giftNameLabel = [[UILabel alloc] init];
    _giftNameLabel.textColor = [UIColor colorWithRed:0xE0/255.0 green:0x38/255.0 blue:0x75/255.0 alpha:1.0];
    _giftNameLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(10.5)];
    _giftNameLabel.textAlignment = NSTextAlignmentCenter;
    _giftNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_giftNameLabel];
    [_giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).offset(KDialogAdaptedWidth(3));
        make.leading.mas_equalTo(self.contentView).offset(KDialogAdaptedWidth(2));
        make.trailing.mas_equalTo(self.contentView).offset(-KDialogAdaptedWidth(2));
    }];
}

- (void)renderRecordWithGiftName:(NSString *)giftName count:(NSInteger)count imageUrl:(NSString *)imageUrl {
    NSString *displayName = giftName.length > 0 ? giftName : @"珍宝塔礼物";
    if (count > 1) {
        displayName = [NSString stringWithFormat:@"%@ x%ld", displayName, (long)count];
    }
    _giftNameLabel.text = displayName;
    
    if (imageUrl.length > 0) {
        [_giftIconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    } else {
        _giftIconImageView.image = [UIImage imageNamed:@"theme_game_one_gift_board_1"];
    }
}

@end
