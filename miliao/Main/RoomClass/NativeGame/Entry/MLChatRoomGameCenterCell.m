//
//  MLChatRoomGameCenterCell.m
//  miliao
//
//  Created by AI Assistant on 2026/9/3.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "MLChatRoomGameCenterCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "Global.h"

@interface MLChatRoomGameCenterCell ()

@property (nonatomic, strong) UIImageView *bgFrameView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MLChatRoomGameCenterCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    _bgFrameView = [[UIImageView alloc] init];
    _bgFrameView.image = [UIImage imageNamed:@"bg_game_center_item_frame"];
    _bgFrameView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_bgFrameView];
    [_bgFrameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KAdaptedWidth(6));
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(56), KAdaptedWidth(56)));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:11];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(KAdaptedWidth(4));
        make.left.mas_equalTo(KAdaptedWidth(4));
        make.right.mas_equalTo(KAdaptedWidth(-4));
        make.bottom.mas_equalTo(KAdaptedWidth(-4));
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    // ⭐️ 核心防错位：复用时显式取消未完成的 SDWebImage 异步下载任务
    [_iconImageView sd_cancelCurrentImageLoad];
    _iconImageView.image = nil;
}

- (void)configWithItem:(MLChatRoomGameCenterItem *)item {
    if (!item) return;
    
    _titleLabel.text = item.name ?: @"";
    
    if (item.imageUrl.length > 0) {
        // 远程网络图片 (H5抽奖盘/倍率盘)
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl]
                          placeholderImage:[UIImage imageNamed:@"chat_room_plate_draw"]];
    } else {
        // 本地原生切图
        [_iconImageView sd_cancelCurrentImageLoad];
        if (item.localIconName.length > 0) {
            _iconImageView.image = [UIImage imageNamed:item.localIconName];
        } else {
            _iconImageView.image = [UIImage imageNamed:@"chat_room_plate_draw"];
        }
    }
    
    self.contentView.alpha = item.isEnabled ? 1.0 : 0.5;
}

@end
