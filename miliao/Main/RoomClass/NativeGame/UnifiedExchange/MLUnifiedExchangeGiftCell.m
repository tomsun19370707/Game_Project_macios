//
//  MLUnifiedExchangeGiftCell.m
//  miliao
//
//  Created by PairProgramming on 2026/9/8.
//

#import "MLUnifiedExchangeGiftCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface MLUnifiedExchangeGiftCell ()

@property (nonatomic, strong) UIView *cardContainer;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, strong) UIView *selectedBorderView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation MLUnifiedExchangeGiftCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _cardContainer = [[UIView alloc] init];
    _cardContainer.layer.masksToBounds = YES;
    _cardContainer.layer.cornerRadius = 14.0;
    [self.contentView addSubview:_cardContainer];
    
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"unified_exchange_bg_gift_item"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    [_cardContainer addSubview:_bgImageView];
    
    _giftImageView = [[UIImageView alloc] init];
    _giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_cardContainer addSubview:_giftImageView];
    
    _selectedBorderView = [[UIView alloc] init];
    _selectedBorderView.layer.cornerRadius = 14.0;
    _selectedBorderView.layer.borderWidth = 2.0;
    _selectedBorderView.layer.borderColor = [UIColor colorWithRed:0x9D/255.0 green:0x72/255.0 blue:0xFF/255.0 alpha:1.0].CGColor;
    _selectedBorderView.backgroundColor = [UIColor colorWithRed:0x9D/255.0 green:0x72/255.0 blue:0xFF/255.0 alpha:0.12];
    _selectedBorderView.hidden = YES;
    [_cardContainer addSubview:_selectedBorderView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12.0] ?: [UIFont boldSystemFontOfSize:12.0];
    _nameLabel.textColor = [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1.0];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_nameLabel];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11.0] ?: [UIFont systemFontOfSize:11.0];
    _descLabel.textColor = [UIColor colorWithRed:0x88/255.0 green:0x88/255.0 blue:0x88/255.0 alpha:1.0];
    _descLabel.textAlignment = NSTextAlignmentCenter;
    _descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_descLabel];
    
    [_cardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(4);
        make.right.equalTo(self.contentView).offset(-4);
        make.height.mas_equalTo(96);
    }];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_cardContainer);
    }];
    
    [_giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_cardContainer);
        make.width.height.mas_equalTo(56);
    }];
    
    [_selectedBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_cardContainer);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cardContainer.mas_bottom).offset(4);
        make.left.equalTo(self.contentView).offset(2);
        make.right.equalTo(self.contentView).offset(-2);
        make.height.mas_equalTo(16);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(1);
        make.left.equalTo(self.contentView).offset(2);
        make.right.equalTo(self.contentView).offset(-2);
        make.height.mas_equalTo(15);
    }];
}

- (void)configureWithItem:(MLUnifiedExchangeItem *)item isSelected:(BOOL)isSelected {
    if (!item) return;
    
    [_giftImageView sd_setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:nil];
    _selectedBorderView.hidden = !isSelected;
    
    // 名称 * 拥有数量
    _nameLabel.text = [NSString stringWithFormat:@"%@*%ld", item.name ?: @"", (long)item.ownedNum];
    
    if (item.isBackpackGift) {
        double total = item.unitRatio * item.ownedNum;
        _descLabel.text = [NSString stringWithFormat:@"可换 %@ 黑曜石", [MLUnifiedExchangeItem formatLargeNumber:total]];
    } else {
        if (item.prizeCoin > 0) {
            _descLabel.text = [NSString stringWithFormat:@"%@ 元宝", [MLUnifiedExchangeItem formatLargeNumber:item.prizeCoin]];
        } else if (item.ratioCoin > 0) {
            _descLabel.text = [NSString stringWithFormat:@"%@ 黑曜石", [MLUnifiedExchangeItem formatLargeNumber:item.ratioCoin]];
        } else {
            _descLabel.text = @"暂不可兑";
        }
    }
}

@end
