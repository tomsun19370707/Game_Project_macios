#import "MLChatRoomThemeGameTwoRecordView.h"
#import "MLGameLotteryService.h"
#import "Global.h"

// ==========================================
// MLChatRoomThemeGameTwoRecordCell (记录行单元格)
// ==========================================
@interface MLChatRoomThemeGameTwoRecordCell : UITableViewCell

@property (nonatomic, strong) UIImageView *cardBgImageView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *drawCountContainer;
@property (nonatomic, strong) UIImageView *fruitImageView;
@property (nonatomic, strong) UILabel *drawCountLabel;

@property (nonatomic, strong) UIImageView *giftBgImageView;
@property (nonatomic, strong) UIImageView *giftImageView;

@property (nonatomic, strong) UILabel *summaryLabel;
@property (nonatomic, strong) UIView *giftsContainerView;

@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, strong) NSDictionary *recordData;

- (void)configureWithData:(NSDictionary *)data isMine:(BOOL)isMine isExpanded:(BOOL)expanded;

@end

@implementation MLChatRoomThemeGameTwoRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _cardBgImageView = [[UIImageView alloc] init];
    _cardBgImageView.image = [UIImage imageNamed:@"theme_game_two_record_board"];
    _cardBgImageView.contentMode = UIViewContentModeScaleToFill;
    _cardBgImageView.userInteractionEnabled = NO;
    [self.contentView addSubview:_cardBgImageView];
    
    [_cardBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(KDialogAdaptedWidth(12));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(12));
        make.height.mas_equalTo(KDialogAdaptedWidth(70));
    }];
    
    _headImageView = [[UIImageView alloc] init];
    _headImageView.image = [UIImage imageNamed:@"theme_game_two_record_head"];
    _headImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_headImageView];
    
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.clipsToBounds = YES;
    [self.contentView addSubview:_avatarImageView];
    
    _nicknameLabel = [[UILabel alloc] init];
    _nicknameLabel.textColor = kWhiteColor;
    _nicknameLabel.font = KFontBoldA(14);
    [self.contentView addSubview:_nicknameLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    _timeLabel.font = KFontA(11);
    [self.contentView addSubview:_timeLabel];
    
    _drawCountContainer = [[UIView alloc] init];
    _drawCountContainer.userInteractionEnabled = NO;
    [self.contentView addSubview:_drawCountContainer];
    
    _fruitImageView = [[UIImageView alloc] init];
    _fruitImageView.image = [UIImage imageNamed:@"theme_game_two_record_fruit"];
    _fruitImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_drawCountContainer addSubview:_fruitImageView];
    
    _drawCountLabel = [[UILabel alloc] init];
    _drawCountLabel.textColor = kWhiteColor;
    _drawCountLabel.font = KFontBoldA(13);
    [_drawCountContainer addSubview:_drawCountLabel];
    
    [_fruitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.centerY.mas_equalTo(_drawCountContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(20), KDialogAdaptedWidth(20)));
    }];
    
    [_drawCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_fruitImageView.mas_trailing).offset(4);
        make.trailing.mas_equalTo(0);
        make.centerY.mas_equalTo(_drawCountContainer);
    }];
    
    _giftBgImageView = [[UIImageView alloc] init];
    _giftBgImageView.image = [UIImage imageNamed:@"theme_game_two_record_gift_bg"];
    _giftBgImageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_giftBgImageView];
    
    _giftImageView = [[UIImageView alloc] init];
    _giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_giftImageView];
    
    _summaryLabel = [[UILabel alloc] init];
    _summaryLabel.textColor = mHexRGB(0xFFE400);
    _summaryLabel.font = KFontBoldA(12);
    _summaryLabel.textAlignment = NSTextAlignmentRight;
    _summaryLabel.hidden = YES;
    [self.contentView addSubview:_summaryLabel];
    
    _giftsContainerView = [[UIView alloc] init];
    _giftsContainerView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.03];
    setViewCorner(_giftsContainerView, 6);
    _giftsContainerView.clipsToBounds = YES;
    [self.contentView addSubview:_giftsContainerView];
}

- (void)configureWithData:(NSDictionary *)data isMine:(BOOL)isMine isExpanded:(BOOL)expanded {
    _recordData = data;
    _isMine = isMine;
    _isExpanded = expanded;
    
    _timeLabel.text = data[@"create_time"];
    _summaryLabel.text = [NSString stringWithFormat:@"%@祝灵 (%@钻石)", data[@"draw_times"], data[@"total_value"]];
    
    NSArray *items = data[@"items"];
    // Sort items by price descending (from highest to lowest value)
    items = [items sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        NSInteger p1 = [obj1[@"price"] integerValue];
        NSInteger p2 = [obj2[@"price"] integerValue];
        if (p1 < p2) {
            return NSOrderedDescending;
        } else if (p1 > p2) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    NSDictionary *firstGift = items.firstObject;
    
    if (firstGift) {
        _giftBgImageView.hidden = NO;
        _giftImageView.hidden = NO;
        
        [_giftBgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_cardBgImageView);
            make.trailing.mas_equalTo(_cardBgImageView.mas_trailing).offset(-KDialogAdaptedWidth(12));
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(52), KDialogAdaptedWidth(48)));
        }];
        
        [_giftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_giftBgImageView);
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(36), KDialogAdaptedWidth(36)));
        }];
        
        NSString *imgUrlStr = firstGift[@"pic"] ?: @"";
        if (imgUrlStr.length == 0) {
            imgUrlStr = firstGift[@"image"] ?: @"";
        }
        NSURL *url = [NSURL URLWithString:imgUrlStr];
        if ([_giftImageView respondsToSelector:@selector(setImageWithURL:placeholder:)]) {
            [_giftImageView performSelector:@selector(setImageWithURL:placeholder:) withObject:url withObject:[UIImage imageNamed:@""]];
        } else if ([_giftImageView respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
            [_giftImageView performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
        }
    } else {
        _giftBgImageView.hidden = YES;
        _giftImageView.hidden = YES;
    }
    
    _drawCountLabel.text = [NSString stringWithFormat:@"x%@", data[@"draw_times"] ?: @"0"];
    [_drawCountContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_cardBgImageView);
        if (firstGift) {
            make.trailing.mas_equalTo(_giftBgImageView.mas_leading).offset(-KDialogAdaptedWidth(20));
        } else {
            make.trailing.mas_equalTo(_cardBgImageView.mas_trailing).offset(-KDialogAdaptedWidth(14));
        }
        make.height.mas_equalTo(KDialogAdaptedWidth(20));
    }];
    
    if (_isMine) {
        _headImageView.hidden = YES;
        _avatarImageView.hidden = YES;
        _nicknameLabel.hidden = YES;
        
        [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_cardBgImageView);
            make.leading.mas_equalTo(_cardBgImageView.mas_leading).offset(KDialogAdaptedWidth(14));
        }];
    } else {
        _headImageView.hidden = NO;
        _avatarImageView.hidden = NO;
        _nicknameLabel.hidden = NO;
        
        NSURL *avatarUrl = [NSURL URLWithString:data[@"avatar"] ?: @""];
        if ([_avatarImageView respondsToSelector:@selector(setImageWithURL:placeholder:)]) {
            [_avatarImageView performSelector:@selector(setImageWithURL:placeholder:) withObject:avatarUrl withObject:[UIImage imageNamed:@"default_header"]];
        } else if ([_avatarImageView respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
            [_avatarImageView performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:avatarUrl withObject:[UIImage imageNamed:@"default_header"]];
        } else {
            _avatarImageView.image = [UIImage imageNamed:@"default_header"];
        }
        
        NSString *rawName = data[@"nickname"] ?: @"";
        if (rawName.length > 2) {
            NSString *prefix = [rawName substringToIndex:2];
            _nicknameLabel.text = [NSString stringWithFormat:@"%@***", prefix];
        } else {
            _nicknameLabel.text = rawName;
        }
        
        [_headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_cardBgImageView);
            make.leading.mas_equalTo(_cardBgImageView.mas_leading).offset(KDialogAdaptedWidth(12));
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(52), KDialogAdaptedWidth(52)));
        }];
        
        [_avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_headImageView);
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(42), KDialogAdaptedWidth(42)));
        }];
        setViewCorner(_avatarImageView, KDialogAdaptedWidth(21));
        
        [_nicknameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headImageView).offset(KDialogAdaptedWidth(6));
            make.leading.mas_equalTo(_headImageView.mas_trailing).offset(KDialogAdaptedWidth(8));
            make.trailing.mas_equalTo(_drawCountContainer.mas_leading).offset(-KDialogAdaptedWidth(8));
        }];
        
        [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_headImageView).offset(-KDialogAdaptedWidth(6));
            make.leading.mas_equalTo(_nicknameLabel);
            make.trailing.mas_equalTo(_nicknameLabel);
        }];
    }
    
    for (UIView *sub in _giftsContainerView.subviews) {
        [sub removeFromSuperview];
    }
    
    if (_isExpanded) {
        _giftsContainerView.hidden = NO;
        
        CGFloat containerLeft = KDialogAdaptedWidth(14);
        [_giftsContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_cardBgImageView.mas_bottom).offset(KDialogAdaptedWidth(8));
            make.leading.mas_equalTo(containerLeft);
            make.trailing.mas_equalTo(-KDialogAdaptedWidth(14));
            make.bottom.mas_equalTo(-KDialogAdaptedWidth(8));
        }];
        
        CGFloat startY = KDialogAdaptedWidth(8.0f);
        CGFloat rowH = KDialogAdaptedWidth(28.0f);
        CGFloat gap = KDialogAdaptedWidth(4.0f);
        
        for (int i = 0; i < items.count; i++) {
            NSDictionary *gift = items[i];
            
            UIView *rowView = [[UIView alloc] init];
            [_giftsContainerView addSubview:rowView];
            [rowView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(startY + i * (rowH + gap));
                make.leading.mas_equalTo(KDialogAdaptedWidth(12));
                make.trailing.mas_equalTo(-KDialogAdaptedWidth(12));
                make.height.mas_equalTo(rowH);
            }];
            
            UIImageView *iconView = [[UIImageView alloc] init];
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            [rowView addSubview:iconView];
            [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(0);
                make.centerY.mas_equalTo(rowView);
                make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(20), KDialogAdaptedWidth(20)));
            }];
            
            NSString *imgUrlStr = gift[@"pic"] ?: gift[@"image"] ?: @"";
            NSURL *url = [NSURL URLWithString:imgUrlStr];
            if ([iconView respondsToSelector:@selector(setImageWithURL:placeholder:)]) {
                [iconView performSelector:@selector(setImageWithURL:placeholder:) withObject:url withObject:[UIImage imageNamed:@""]];
            } else if ([iconView respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
                [iconView performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
            }
            
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.textColor = kWhiteColor;
            nameLabel.font = KFontBoldA(12);
            nameLabel.text = gift[@"gift_name"] ?: gift[@"name"] ?: @"";
            [rowView addSubview:nameLabel];
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(iconView.mas_trailing).offset(KDialogAdaptedWidth(8));
                make.centerY.mas_equalTo(rowView);
            }];
            
            UILabel *countLabel = [[UILabel alloc] init];
            countLabel.textColor = [UIColor colorWithWhite:1 alpha:0.8];
            countLabel.font = KFontBoldA(11);
            countLabel.text = [NSString stringWithFormat:@"x%@", gift[@"num"] ?: @"1"];
            [rowView addSubview:countLabel];
            [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(0);
                make.centerY.mas_equalTo(rowView);
            }];
            
            UILabel *priceLabel = [[UILabel alloc] init];
            priceLabel.textColor = mHexRGB(0xFFE400);
            priceLabel.font = KFontBoldA(11);
            priceLabel.text = [NSString stringWithFormat:@"%@钻石", gift[@"price"] ?: @"0"];
            [rowView addSubview:priceLabel];
            [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(countLabel.mas_leading).offset(-KDialogAdaptedWidth(12));
                make.centerY.mas_equalTo(rowView);
            }];
        }
        
        UILabel *totalLabel = [[UILabel alloc] init];
        totalLabel.textColor = kWhiteColor;
        totalLabel.font = KFontBoldA(13);
        totalLabel.text = [NSString stringWithFormat:@"总价值：%@钻石", data[@"total_value"] ?: @"0"];
        [_giftsContainerView addSubview:totalLabel];
        [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(startY + items.count * (rowH + gap) + KDialogAdaptedWidth(4.0f));
            make.leading.mas_equalTo(KDialogAdaptedWidth(12));
            make.height.mas_equalTo(KDialogAdaptedWidth(30.0f));
        }];
    } else {
        _giftsContainerView.hidden = YES;
        [_giftsContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_cardBgImageView.mas_bottom);
            make.leading.trailing.mas_equalTo(self.contentView);
            make.height.mas_equalTo(0);
        }];
    }
}

@end


// ==========================================
// MLChatRoomThemeGameTwoRecordView
// ==========================================
@interface MLChatRoomThemeGameTwoRecordView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIButton *allRecordTab;
@property (nonatomic, strong) UIButton *myRecordTab;
@property (nonatomic, assign) BOOL showingMyRecord;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *recordList;
@property (nonatomic, strong) NSMutableSet<NSNumber *> *expandedRowIds;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation MLChatRoomThemeGameTwoRecordView

+ (void)showInView:(UIView *)parentView typeId:(NSInteger)typeId {
    MLChatRoomThemeGameTwoRecordView *recordView = [[MLChatRoomThemeGameTwoRecordView alloc] initWithFrame:parentView.bounds typeId:typeId];
    [parentView addSubview:recordView];
    [recordView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame typeId:(NSInteger)typeId {
    if (self = [super initWithFrame:frame]) {
        self.typeId = typeId;
        self.showingMyRecord = NO;
        self.currentPage = 1;
        self.recordList = [NSMutableArray array];
        self.expandedRowIds = [NSMutableSet set];
        
        [self setupUI];
        [self loadData];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tap];
    
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_two_record_clean"];
    if (_bgImageView.image == nil) {
        _bgImageView.backgroundColor = mHexRGB(0x1B1923); // 深紫灰色调背景
    }
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    setViewCorner(_bgImageView, 12);
    [self addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(self).offset(-KDialogAdaptedWidth(32)).priorityMedium();
        make.width.mas_lessThanOrEqualTo(KDialogAdaptedWidth(344));
        make.height.mas_equalTo(_bgImageView.mas_width).multipliedBy(1326.0 / 750.0);
    }];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"theme_game_two_record_back"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(28));
        make.leading.mas_equalTo(KDialogAdaptedWidth(32));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(44), KDialogAdaptedWidth(44)));
    }];
    
    // 页签容器 (水平居中, 定位于高度 16.5% 处, 即约 100 pt)
    UIView *tabsContainer = [[UIView alloc] init];
    [_bgImageView addSubview:tabsContainer];
    [tabsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(100));
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(210), KDialogAdaptedWidth(36)));
    }];
    
    _allRecordTab = [UIButton buttonWithType:UIButtonTypeCustom];
    [_allRecordTab setBackgroundImage:[UIImage imageNamed:@"theme_game_two_record_tab_all_selected"] forState:UIControlStateNormal];
    [_allRecordTab addTarget:self action:@selector(allTabClick) forControlEvents:UIControlEventTouchUpInside];
    [tabsContainer addSubview:_allRecordTab];
    [_allRecordTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(100), KDialogAdaptedWidth(36)));
    }];
    
    _myRecordTab = [UIButton buttonWithType:UIButtonTypeCustom];
    [_myRecordTab setBackgroundImage:[UIImage imageNamed:@"theme_game_two_record_tab_mine"] forState:UIControlStateNormal];
    [_myRecordTab addTarget:self action:@selector(myTabClick) forControlEvents:UIControlEventTouchUpInside];
    [tabsContainer addSubview:_myRecordTab];
    [_myRecordTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(100), KDialogAdaptedWidth(36)));
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[MLChatRoomThemeGameTwoRecordCell class] forCellReuseIdentifier:@"RecordCell"];
    [_bgImageView addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tabsContainer.mas_bottom).offset(KDialogAdaptedWidth(12));
        make.leading.mas_equalTo(KDialogAdaptedWidth(18));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(18));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(60)); // 60pt bottom safety margin
    }];
}

- (void)loadData {
    NSString *userType = self.showingMyRecord ? @"my" : @"all";
    WeakSelf
    NSInteger queryTypeId = (self.typeId == 6 || self.typeId == 8) ? 7 : self.typeId;
    [MLGameLotteryService getDrawLogWithTypeId:queryTypeId 
                                      userType:userType 
                                          page:self.currentPage 
                                      pageSize:30 
                                       success:^(NSArray *list, NSInteger total) {
        NSMutableArray *filteredList = [NSMutableArray array];
        for (id logItem in list) {
            if ([logItem isKindOfClass:[NSDictionary class]]) {
                NSArray *items = logItem[@"items"];
                NSMutableArray *filteredLogItems = [NSMutableArray array];
                for (NSDictionary *gift in items) {
                    NSInteger gId = [gift[@"gift_id"] integerValue];
                    if (gId == 0) {
                        gId = [gift[@"id"] integerValue];
                    }
                    NSString *name = gift[@"gift_name"] ?: @"";
                    if (name.length == 0) {
                        name = gift[@"name"] ?: @"";
                    }
                    if (gId != 0 && name.length > 0) {
                        [filteredLogItems addObject:gift];
                    }
                }
                if (filteredLogItems.count > 0) {
                    NSMutableDictionary *mutLogItem = [logItem mutableCopy];
                    mutLogItem[@"items"] = [filteredLogItems copy];
                    [filteredList addObject:mutLogItem];
                }
            }
        }
        
        if (wself.currentPage == 1) {
            [wself.recordList removeAllObjects];
            [wself.expandedRowIds removeAllObjects];
        }
        [wself.recordList addObjectsFromArray:filteredList];
        [wself.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)allTabClick {
    if (!self.showingMyRecord) return;
    self.showingMyRecord = NO;
    self.currentPage = 1;
    [_allRecordTab setBackgroundImage:[UIImage imageNamed:@"theme_game_two_record_tab_all_selected"] forState:UIControlStateNormal];
    [_myRecordTab setBackgroundImage:[UIImage imageNamed:@"theme_game_two_record_tab_mine"] forState:UIControlStateNormal];
    [self loadData];
}

- (void)myTabClick {
    if (self.showingMyRecord) return;
    self.showingMyRecord = YES;
    self.currentPage = 1;
    [_allRecordTab setBackgroundImage:[UIImage imageNamed:@"theme_game_two_record_tab_all"] forState:UIControlStateNormal];
    [_myRecordTab setBackgroundImage:[UIImage imageNamed:@"theme_game_two_record_tab_mine_selected"] forState:UIControlStateNormal];
    [self loadData];
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLChatRoomThemeGameTwoRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCell" forIndexPath:indexPath];
    NSDictionary *data = self.recordList[indexPath.row];
    BOOL expanded = [self.expandedRowIds containsObject:@(indexPath.row)];
    [cell configureWithData:data isMine:self.showingMyRecord isExpanded:expanded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL expanded = [self.expandedRowIds containsObject:@(indexPath.row)];
    if (expanded) {
        if (indexPath.row < self.recordList.count) {
            NSDictionary *data = self.recordList[indexPath.row];
            NSArray *items = data[@"items"];
            NSInteger count = items.count;
            CGFloat detailsH = count * KDialogAdaptedWidth(28.0f) + (count - 1) * KDialogAdaptedWidth(4.0f) + KDialogAdaptedWidth(8.0f) + KDialogAdaptedWidth(30.0f) + KDialogAdaptedWidth(16.0f);
            CGFloat finalHeight = KDialogAdaptedWidth(70.0f) + detailsH;
            return finalHeight;
        }
    }
    return KDialogAdaptedWidth(78.0f);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *rowNum = @(indexPath.row);
    if ([self.expandedRowIds containsObject:rowNum]) {
        [self.expandedRowIds removeObject:rowNum];
    } else {
        [self.expandedRowIds addObject:rowNum];
    }
    [tableView reloadData];
}

#pragma mark - Animation & Close
- (void)animateShow {
    self.alpha = 0.0;
    _bgImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
        self.bgImageView.transform = CGAffineTransformIdentity;
    }];
}

- (void)closeClick {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.bgImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
