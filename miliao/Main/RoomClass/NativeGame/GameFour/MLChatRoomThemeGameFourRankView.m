#import "MLChatRoomThemeGameFourRankView.h"
#import "Global.h"
#import "MLGameLotteryService.h"
#import <Masonry/Masonry.h>
#import <UIImageView+WebCache.h>

// ==========================================
// MLChatRoomThemeGameFourRankCell
// ==========================================
@interface MLChatRoomThemeGameFourRankCell : UITableViewCell

@property (nonatomic, strong) UIImageView *dividerView;
@property (nonatomic, strong) UIView *rankContainer;
@property (nonatomic, strong) UIImageView *rankBadgeView;
@property (nonatomic, strong) UILabel *rankNumberLabel;

@property (nonatomic, strong) UIView *avatarContainer;
@property (nonatomic, strong) UIImageView *avatarFrameView;
@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *nicknameLabel;

// Three Lucky Bags
@property (nonatomic, strong) UIView *giftsContainer;
@property (nonatomic, strong) NSMutableArray<UIView *> *giftItemViews;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *giftIconViews;
@property (nonatomic, strong) NSMutableArray<UILabel *> *giftCountLabels;

- (void)configureWithModel:(MLGameFourRankingUserModel *)model;

@end

@implementation MLChatRoomThemeGameFourRankCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 1. Row Divider Line
    _dividerView = [[UIImageView alloc] init];
    _dividerView.contentMode = UIViewContentModeScaleToFill;
    _dividerView.image = [UIImage imageNamed:@"theme_game_four_rank_divider"];
    [self.contentView addSubview:_dividerView];
    [_dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(KDialogAdaptedWidth(2));
    }];

    // 2. Rank Medal/Number Container
    _rankContainer = [[UIView alloc] init];
    [self.contentView addSubview:_rankContainer];
    [_rankContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(8));
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(38), KDialogAdaptedWidth(23)));
    }];

    _rankBadgeView = [[UIImageView alloc] init];
    _rankBadgeView.contentMode = UIViewContentModeScaleAspectFit;
    [_rankContainer addSubview:_rankBadgeView];
    [_rankBadgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_rankContainer);
    }];

    _rankNumberLabel = [[UILabel alloc] init];
    _rankNumberLabel.textAlignment = NSTextAlignmentCenter;
    _rankNumberLabel.textColor = kWhiteColor;
    _rankNumberLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(14)];
    [_rankContainer addSubview:_rankNumberLabel];
    [_rankNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_rankContainer);
    }];

    // 3. Avatar with Border Frame
    _avatarContainer = [[UIView alloc] init];
    [self.contentView addSubview:_avatarContainer];
    [_avatarContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_rankContainer.mas_trailing).offset(KDialogAdaptedWidth(4));
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(32), KDialogAdaptedWidth(32)));
    }];

    _avatarFrameView = [[UIImageView alloc] init];
    _avatarFrameView.contentMode = UIViewContentModeScaleToFill;
    _avatarFrameView.image = [UIImage imageNamed:@"theme_game_four_rank_avatar_frame"];
    [_avatarContainer addSubview:_avatarFrameView];
    [_avatarFrameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_avatarContainer);
    }];

    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.layer.cornerRadius = KDialogAdaptedWidth(13);
    [_avatarContainer addSubview:_avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_avatarContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(26), KDialogAdaptedWidth(26)));
    }];

    // 4. Nickname
    _nicknameLabel = [[UILabel alloc] init];
    _nicknameLabel.textColor = kWhiteColor;
    _nicknameLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(13)];
    _nicknameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_nicknameLabel];
    [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_avatarContainer.mas_trailing).offset(KDialogAdaptedWidth(5));
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_lessThanOrEqualTo(KDialogAdaptedWidth(110));
    }];

    // 5. Gifts horizontal stack (fixed 3 lucky bags: Yellow, Green, Blue)
    _giftsContainer = [[UIView alloc] init];
    [self.contentView addSubview:_giftsContainer];
    [_giftsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(8));
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(110), KDialogAdaptedWidth(31)));
    }];

    _giftItemViews = [NSMutableArray array];
    _giftIconViews = [NSMutableArray array];
    _giftCountLabels = [NSMutableArray array];

    NSArray *bagIconNames = @[@"theme_game_four_bag_yellow", @"theme_game_four_bag_green", @"theme_game_four_bag_blue"];

    for (int i = 0; i < 3; i++) {
        UIView *itemBg = [[UIView alloc] init];
        itemBg.layer.contents = (__bridge id)[UIImage imageNamed:@"theme_game_four_rank_gift_bg"].CGImage;
        [_giftsContainer addSubview:itemBg];
        [_giftItemViews addObject:itemBg];

        [itemBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.leading.mas_equalTo(i * KDialogAdaptedWidth(38));
            make.width.mas_equalTo(KDialogAdaptedWidth(34));
        }];

        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        iconView.image = [UIImage imageNamed:bagIconNames[i]];
        [itemBg addSubview:iconView];
        [_giftIconViews addObject:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(itemBg);
            make.top.mas_equalTo(KDialogAdaptedWidth(2));
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(22), KDialogAdaptedWidth(20)));
        }];

        UIImageView *countBgView = [[UIImageView alloc] init];
        countBgView.contentMode = UIViewContentModeScaleToFill;
        countBgView.image = [UIImage imageNamed:@"theme_game_four_rank_count_bg"];
        [itemBg addSubview:countBgView];
        [countBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_equalTo(itemBg);
            make.height.mas_equalTo(KDialogAdaptedWidth(9));
        }];

        UILabel *countLabel = [[UILabel alloc] init];
        countLabel.textColor = mHexRGB(0x000000);
        countLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(7.5)];
        countLabel.textAlignment = NSTextAlignmentCenter;
        [itemBg addSubview:countLabel];
        [_giftCountLabels addObject:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(countBgView);
        }];
    }
}

- (void)configureWithModel:(MLGameFourRankingUserModel *)model {
    if (!model) return;
    
    NSInteger rank = model.rank;
    _nicknameLabel.text = model.nickname ?: @"";
    
    // SDWebImage 加载用户真实头像
    NSURL *url = [NSURL URLWithString:model.avatar ?: @""];
    if ([_avatarImageView respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
        [_avatarImageView performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@"theme_game_one_record_head"]];
    } else {
        _avatarImageView.image = [UIImage imageNamed:@"theme_game_one_record_head"];
    }

    // 前 3 名专属勋章与 4 名以后的数字排名
    if (rank == 1) {
        _rankBadgeView.hidden = NO;
        _rankNumberLabel.hidden = YES;
        _rankBadgeView.image = [UIImage imageNamed:@"theme_game_four_rank_1"];
    } else if (rank == 2) {
        _rankBadgeView.hidden = NO;
        _rankNumberLabel.hidden = YES;
        _rankBadgeView.image = [UIImage imageNamed:@"theme_game_four_rank_2"];
    } else if (rank == 3) {
        _rankBadgeView.hidden = NO;
        _rankNumberLabel.hidden = YES;
        _rankBadgeView.image = [UIImage imageNamed:@"theme_game_four_rank_3"];
    } else {
        _rankBadgeView.hidden = YES;
        _rankNumberLabel.hidden = NO;
        _rankNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)rank];
    }

    // 绑定右侧 3 种福袋抽奖次数 (青玉/碧海/鎏金)
    if (_giftCountLabels.count >= 3) {
        _giftCountLabels[0].text = [NSString stringWithFormat:@"x%ld", (long)model.type8_count];
        _giftCountLabels[1].text = [NSString stringWithFormat:@"x%ld", (long)model.type9_count];
        _giftCountLabels[2].text = [NSString stringWithFormat:@"x%ld", (long)model.type10_count];
    }
}

@end


// ==========================================
// MLChatRoomThemeGameFourRankView
// ==========================================
@interface MLChatRoomThemeGameFourRankView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *backgroundContainer;
@property (nonatomic, strong) UIView *contentClippingContainer;
@property (nonatomic, strong) UIImageView *rankBgView;
@property (nonatomic, strong) UIImageView *innerFrameView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *bottomTipsLabel;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) NSArray<MLGameFourRankingUserModel *> *rankList;

@end

@implementation MLChatRoomThemeGameFourRankView

+ (void)showInView:(UIView *)parentView typeId:(NSInteger)typeId {
    MLChatRoomThemeGameFourRankView *rankView = [[MLChatRoomThemeGameFourRankView alloc] initWithFrame:parentView.bounds typeId:typeId];
    [parentView addSubview:rankView];
    [rankView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame typeId:(NSInteger)typeId {
    if (self = [super initWithFrame:frame]) {
        self.typeId = typeId;
        [self setupUI];
        [self loadRankingData];
    }
    return self;
}

- (void)loadRankingData {
    WeakSelf
    [MLGameLotteryService getGameFourRankingWithLimit:100 success:^(NSArray<MLGameFourRankingUserModel *> *list) {
        if (!wself) return;
        if (list && [list isKindOfClass:[NSArray class]]) {
            wself.rankList = list;
            [wself.tableView reloadData];
        }
    } failure:nil];
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];

    // 1. Semi-transparent black mask view
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tap];

    // 2. Aspect Ratio Locked Background Panel
    _backgroundContainer = [[UIView alloc] init];
    _backgroundContainer.backgroundColor = [UIColor clearColor];
    [self addSubview:_backgroundContainer];
    [_backgroundContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.90).priorityMedium();
        make.width.mas_lessThanOrEqualTo(KDialogAdaptedWidth(330)).priorityHigh();
        make.height.mas_equalTo(_backgroundContainer.mas_width).multipliedBy(998.0 / 602.0);
    }];

    // 3. Inner Clipped Container
    _contentClippingContainer = [[UIView alloc] init];
    _contentClippingContainer.clipsToBounds = YES;
    [_backgroundContainer addSubview:_contentClippingContainer];
    [_contentClippingContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_backgroundContainer);
    }];

    // 3.1 Background image
    _rankBgView = [[UIImageView alloc] init];
    _rankBgView.contentMode = UIViewContentModeScaleToFill;
    _rankBgView.image = [UIImage imageNamed:@"theme_game_four_rank_panel_bg"];
    [_contentClippingContainer addSubview:_rankBgView];
    [_rankBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_contentClippingContainer);
    }];

    // 3.2 Inner content frame
    _innerFrameView = [[UIImageView alloc] init];
    _innerFrameView.contentMode = UIViewContentModeScaleToFill;
    _innerFrameView.image = [UIImage imageNamed:@"theme_game_four_rank_content_bg"];
    _innerFrameView.userInteractionEnabled = YES;
    [_contentClippingContainer addSubview:_innerFrameView];
    [_innerFrameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(20));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(20));
        make.top.mas_equalTo(KDialogAdaptedWidth(95));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(70));
    }];

    // 3.3 Scrollable table view for users list
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[MLChatRoomThemeGameFourRankCell class] forCellReuseIdentifier:@"MLChatRoomThemeGameFourRankCell"];
    [_innerFrameView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_innerFrameView).insets(UIEdgeInsetsMake(KDialogAdaptedWidth(8), KDialogAdaptedWidth(8), KDialogAdaptedWidth(8), KDialogAdaptedWidth(8)));
    }];

    // 3.4 Bottom Tip Label
    _bottomTipsLabel = [[UILabel alloc] init];
    _bottomTipsLabel.text = @"统计一个自然周的榜单";
    _bottomTipsLabel.textColor = [UIColor colorWithRed:169/255.0 green:242/255.0 blue:255/255.0 alpha:0.7];
    _bottomTipsLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(11)];
    _bottomTipsLabel.textAlignment = NSTextAlignmentCenter;
    [_contentClippingContainer addSubview:_bottomTipsLabel];
    [_bottomTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(24));
        make.centerX.mas_equalTo(_backgroundContainer);
    }];

    // 4. Overlapping Top-Right Close Button
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"theme_game_four_rank_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundContainer addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentClippingContainer).offset(-KDialogAdaptedWidth(8));
        make.trailing.mas_equalTo(_contentClippingContainer).offset(KDialogAdaptedWidth(8));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(34), KDialogAdaptedWidth(36)));
    }];
}

#pragma mark - Animations

- (void)animateShow {
    self.alpha = 0;
    _backgroundContainer.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
        self.backgroundContainer.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)closeClick {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0;
        self.backgroundContainer.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableViewDataSource / Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rankList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLChatRoomThemeGameFourRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MLChatRoomThemeGameFourRankCell" forIndexPath:indexPath];
    if (indexPath.row < self.rankList.count) {
        [cell configureWithModel:self.rankList[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KDialogAdaptedWidth(52);
}

@end
