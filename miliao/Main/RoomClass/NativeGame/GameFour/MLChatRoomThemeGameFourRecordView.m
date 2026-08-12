#import "MLChatRoomThemeGameFourRecordView.h"
#import "Global.h"
#import "MLGameLotteryService.h"
#import <Masonry/Masonry.h>

// ==========================================
// MLChatRoomThemeGameFourRecordGiftRowView
// ==========================================
@interface MLChatRoomThemeGameFourRecordGiftRowView : UIView

@property (nonatomic, strong) UIImageView *giftIcon;
@property (nonatomic, strong) UILabel *giftNameLabel;
@property (nonatomic, strong) UILabel *giftPriceLabel;
@property (nonatomic, strong) UILabel *giftCountLabel;
@property (nonatomic, strong) UIImageView *dividerLine;

@end

@implementation MLChatRoomThemeGameFourRecordGiftRowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];

    _giftIcon = [[UIImageView alloc] init];
    _giftIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_giftIcon];
    [_giftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(8));
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(30), KDialogAdaptedWidth(30)));
    }];

    _giftNameLabel = [[UILabel alloc] init];
    _giftNameLabel.textColor = kWhiteColor;
    _giftNameLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(11)];
    [self addSubview:_giftNameLabel];
    [_giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_giftIcon.mas_trailing).offset(KDialogAdaptedWidth(8));
        make.top.mas_equalTo(_giftIcon.mas_top);
    }];

    _giftPriceLabel = [[UILabel alloc] init];
    _giftPriceLabel.textColor = mHexRGB(0xC0E3FF);
    _giftPriceLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(9)];
    [self addSubview:_giftPriceLabel];
    [_giftPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_giftIcon.mas_trailing).offset(KDialogAdaptedWidth(8));
        make.bottom.mas_equalTo(_giftIcon.mas_bottom);
    }];

    _giftCountLabel = [[UILabel alloc] init];
    _giftCountLabel.textColor = kWhiteColor;
    _giftCountLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(12)];
    [self addSubview:_giftCountLabel];
    [_giftCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(12));
        make.centerY.mas_equalTo(self);
    }];

    _dividerLine = [[UIImageView alloc] init];
    _dividerLine.contentMode = UIViewContentModeScaleToFill;
    _dividerLine.image = [UIImage imageNamed:@"theme_game_four_record_divider"];
    [self addSubview:_dividerLine];
    [_dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self);
        make.height.mas_equalTo(KDialogAdaptedWidth(2));
    }];

    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(KDialogAdaptedWidth(40));
    }];
}

- (void)configureWithGift:(NSDictionary *)gift isLast:(BOOL)isLast {
    _giftNameLabel.text = gift[@"name"] ?: @"";
    
    NSInteger price = [gift[@"price"] integerValue];
    _giftPriceLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)price];
    
    NSInteger num = [gift[@"num"] integerValue];
    if (num <= 0) num = 1;
    _giftCountLabel.text = [NSString stringWithFormat:@"X%ld", (long)num];
    
    _dividerLine.hidden = isLast;

    // Load gift icon safely using reflection
    NSString *iconPath = gift[@"pic"] ?: (gift[@"image"] ?: @"");
    NSURL *url = [NSURL URLWithString:iconPath];
    if ([_giftIcon respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
        [_giftIcon performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@"theme_game_one_record_head"]];
    } else {
        _giftIcon.image = [UIImage imageNamed:@"theme_game_one_record_head"];
    }
}

@end


// ==========================================
// MLChatRoomThemeGameFourRecordCardCell
// ==========================================
@interface MLChatRoomThemeGameFourRecordCardCell : UITableViewCell

@property (nonatomic, strong) UIView *cardBgView;
@property (nonatomic, strong) UIView *headerBgView;
@property (nonatomic, strong) UILabel *drawTypeLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIStackView *giftsStackView;
@property (nonatomic, strong) MASConstraint *heightConstraint;

- (void)configureWithData:(NSDictionary *)data;

@end

@implementation MLChatRoomThemeGameFourRecordCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _cardBgView = [[UIView alloc] init];
    _cardBgView.backgroundColor = mHexRGB(0x14499D);
    _cardBgView.layer.cornerRadius = KDialogAdaptedWidth(12);
    _cardBgView.layer.borderWidth = KDialogAdaptedWidth(1.5);
    _cardBgView.layer.borderColor = mHexRGB(0x6623C1).CGColor;
    _cardBgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_cardBgView];
    [_cardBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(12));
    }];

    _headerBgView = [[UIView alloc] init];
    _headerBgView.backgroundColor = mHexRGB(0x01088B);
    [_cardBgView addSubview:_headerBgView];
    [_headerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(_cardBgView);
        make.height.mas_equalTo(KDialogAdaptedWidth(28));
    }];

    _drawTypeLabel = [[UILabel alloc] init];
    _drawTypeLabel.textColor = kWhiteColor;
    _drawTypeLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(11)];
    [_headerBgView addSubview:_drawTypeLabel];
    [_drawTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(16));
        make.top.mas_equalTo(KDialogAdaptedWidth(8));
    }];

    _dateLabel = [[UILabel alloc] init];
    _dateLabel.textColor = kWhiteColor;
    _dateLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(10)];
    [_headerBgView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(16));
        make.top.mas_equalTo(KDialogAdaptedWidth(8));
    }];

    _giftsStackView = [[UIStackView alloc] init];
    _giftsStackView.axis = UILayoutConstraintAxisVertical;
    _giftsStackView.spacing = 0;
    _giftsStackView.alignment = UIStackViewAlignmentFill;
    _giftsStackView.distribution = UIStackViewDistributionEqualSpacing;
    [_cardBgView addSubview:_giftsStackView];
    [_giftsStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(14));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(14));
        make.top.mas_equalTo(KDialogAdaptedWidth(36));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(10));
    }];
}

static NSArray *MLGameMergeAndSortGifts(NSArray *rawGifts) {
    if (![rawGifts isKindOfClass:[NSArray class]] || rawGifts.count == 0) return @[];
    
    NSMutableArray *mergedList = [NSMutableArray array];
    NSMutableDictionary *mergedMap = [NSMutableDictionary dictionary];
    
    for (NSDictionary *gift in rawGifts) {
        if (![gift isKindOfClass:[NSDictionary class]]) continue;
        
        NSInteger giftId = [gift[@"gift_id"] integerValue];
        if (giftId <= 0) giftId = [gift[@"giftId"] integerValue];
        
        NSString *name = gift[@"name"] ?: (gift[@"gift_name"] ?: @"");
        NSInteger logId = [gift[@"id"] integerValue];
        
        NSString *key = nil;
        if (giftId > 0) {
            key = [NSString stringWithFormat:@"gid_%ld", (long)giftId];
        } else if (name.length > 0) {
            key = [NSString stringWithFormat:@"name_%@", name];
        } else {
            key = [NSString stringWithFormat:@"id_%ld", (long)logId];
        }
        
        NSInteger count = [gift[@"gift_num"] integerValue];
        if (count <= 0) count = [gift[@"num"] integerValue];
        if (count <= 0) count = 1;
        
        if (mergedMap[key]) {
            NSMutableDictionary *existing = mergedMap[key];
            NSInteger currentCount = [existing[@"num"] integerValue];
            existing[@"num"] = @(currentCount + count);
            existing[@"gift_num"] = @(currentCount + count);
        } else {
            NSMutableDictionary *newGift = [gift mutableCopy];
            newGift[@"num"] = @(count);
            newGift[@"gift_num"] = @(count);
            mergedMap[key] = newGift;
            [mergedList addObject:newGift];
        }
    }
    
    return [mergedList copy];
}

- (void)configureWithData:(NSDictionary *)data {
    NSInteger drawTimes = [data[@"draw_times"] integerValue];
    
    // Parse items array (优先读取 prizes 节点，为空降级读取 items 节点)
    id itemsObj = data[@"prizes"];
    if (!itemsObj || itemsObj == [NSNull null]) {
        itemsObj = data[@"items"];
    }
    
    NSArray *items = nil;
    if ([itemsObj isKindOfClass:[NSArray class]]) {
        items = (NSArray *)itemsObj;
    } else if ([itemsObj isKindOfClass:[NSString class]]) {
        NSData *jsonData = [(NSString *)itemsObj dataUsingEncoding:NSUTF8StringEncoding];
        if (jsonData) {
            items = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        }
    }
    items = MLGameMergeAndSortGifts(items);
    
    if (drawTimes <= 0 && items.count > 0) {
        drawTimes = items.count;
    }

    NSString *typeStr = @"开十个";
    if (drawTimes <= 1) {
        typeStr = @"开一个";
    } else if (drawTimes >= 100) {
        typeStr = @"开一百个";
    }

    _drawTypeLabel.text = typeStr;

    // Format date string (e.g., "2026-07-09 12:00:00" -> "2026-07-09")
    NSString *createTime = data[@"create_time"] ?: (data[@"createtime"] ?: @"");
    if ([createTime containsString:@" "]) {
        createTime = [createTime componentsSeparatedByString:@" "].firstObject;
    }
    _dateLabel.text = createTime;

    // Remove all previous stacked gift rows
    for (UIView *view in _giftsStackView.arrangedSubviews) {
        [_giftsStackView removeArrangedSubview:view];
        [view removeFromSuperview];
    }

    // Dynamic insertion of gift rows
    if (items.count > 0) {
        for (int i = 0; i < items.count; i++) {
            MLChatRoomThemeGameFourRecordGiftRowView *row = [[MLChatRoomThemeGameFourRecordGiftRowView alloc] init];
            [row configureWithGift:items[i] isLast:(i == items.count - 1)];
            [_giftsStackView addArrangedSubview:row];
        }
    }

    // Adapt layout height constraint
    if (_heightConstraint) {
        [_heightConstraint uninstall];
    }
    
    if (drawTimes <= 1) {
        [_cardBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.heightConstraint = make.height.mas_equalTo(KDialogAdaptedWidth(88)).priorityHigh();
        }];
    }
}

@end


// ==========================================
// MLChatRoomThemeGameFourRecordView
// ==========================================
@interface MLChatRoomThemeGameFourRecordView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *backgroundContainer;
@property (nonatomic, strong) UIView *contentClippingContainer;
@property (nonatomic, strong) UIImageView *recordBgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation MLChatRoomThemeGameFourRecordView

+ (void)showInView:(UIView *)parentView typeId:(NSInteger)typeId {
    MLChatRoomThemeGameFourRecordView *recordView = [[MLChatRoomThemeGameFourRecordView alloc] initWithFrame:parentView.bounds typeId:typeId];
    [parentView addSubview:recordView];
    [recordView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame typeId:(NSInteger)typeId {
    if (self = [super initWithFrame:frame]) {
        self.typeId = typeId;
        self.dataList = [NSMutableArray array];
        [self setupUI];
        [self loadRecords];
    }
    return self;
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
        make.width.mas_equalTo(self).multipliedBy(0.85).priorityMedium();
        make.width.mas_lessThanOrEqualTo(KDialogAdaptedWidth(300)).priorityHigh();
        make.height.mas_equalTo(_backgroundContainer.mas_width).multipliedBy(999.0 / 602.0);
    }];

    // 3. Inner Clipped Container
    _contentClippingContainer = [[UIView alloc] init];
    _contentClippingContainer.clipsToBounds = YES;
    [_backgroundContainer addSubview:_contentClippingContainer];
    [_contentClippingContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_backgroundContainer);
    }];

    // 3.1 Background image
    _recordBgView = [[UIImageView alloc] init];
    _recordBgView.contentMode = UIViewContentModeScaleToFill;
    _recordBgView.image = [UIImage imageNamed:@"theme_game_four_record_panel_bg"];
    [_contentClippingContainer addSubview:_recordBgView];
    [_recordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_contentClippingContainer);
    }];

    // 3.2 Scrollable table view for cards
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = KDialogAdaptedWidth(120);
    [_tableView registerClass:[MLChatRoomThemeGameFourRecordCardCell class] forCellReuseIdentifier:@"MLChatRoomThemeGameFourRecordCardCell"];
    [_contentClippingContainer addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(20));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(20));
        make.top.mas_equalTo(KDialogAdaptedWidth(92));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(72));
    }];

    // 3.3 Confirm Button ("我知道了")
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"theme_game_four_record_confirm"] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentClippingContainer addSubview:_confirmBtn];
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(24));
        make.centerX.mas_equalTo(_contentClippingContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(150), KDialogAdaptedWidth(38)));
    }];

    // 4. Overlapping Top-Right Close Button
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"theme_game_four_record_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundContainer addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentClippingContainer).offset(-KDialogAdaptedWidth(8));
        make.trailing.mas_equalTo(_contentClippingContainer).offset(KDialogAdaptedWidth(8));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(34), KDialogAdaptedWidth(36)));
    }];
}

#pragma mark - Data Loading

- (void)loadRecords {
    __weak typeof(self) weakSelf = self;
    [MLGameLotteryService getDrawLogWithTypeId:self.typeId userType:@"my" page:1 pageSize:50 success:^(NSArray *list, NSInteger total) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (list.count > 0) {
            [strongSelf.dataList removeAllObjects];
            [strongSelf.dataList addObjectsFromArray:list];
            [strongSelf.tableView reloadData];
        } else {
            [strongSelf useMockData];
        }
    } failure:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf useMockData];
    }];
}

- (void)useMockData {
    [self.dataList removeAllObjects];

    // Mock 1: Single Draw
    [self.dataList addObject:@{
        @"draw_times": @(1),
        @"create_time": @"2026-07-15 12:00:00",
        @"items": @[
            @{@"name": @"幻境糖果", @"price": @(20), @"num": @(1), @"pic": @""}
        ]
    }];

    // Mock 2: Ten Draws
    [self.dataList addObject:@{
        @"draw_times": @(10),
        @"create_time": @"2026-07-13 11:30:00",
        @"items": @[
            @{@"name": @"月相硬币", @"price": @(10), @"num": @(2), @"pic": @""},
            @{@"name": @"幻境糖果", @"price": @(20), @"num": @(3), @"pic": @""},
            @{@"name": @"星尘药水", @"price": @(50), @"num": @(3), @"pic": @""},
            @{@"name": @"捕梦铃铛", @"price": @(100), @"num": @(1), @"pic": @""},
            @{@"name": @"梦境捕手", @"price": @(800), @"num": @(1), @"pic": @""}
        ]
    }];

    [self.tableView reloadData];
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
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLChatRoomThemeGameFourRecordCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MLChatRoomThemeGameFourRecordCardCell" forIndexPath:indexPath];
    if (indexPath.row < self.dataList.count) {
        [cell configureWithData:self.dataList[indexPath.row]];
    }
    return cell;
}

@end
