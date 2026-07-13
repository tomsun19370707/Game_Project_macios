#import "MLChatRoomThemeGameThreeRecordView.h"
#import "MLGameLotteryService.h"
#import "Global.h"

// ==========================================
// MLChatRoomThemeGameThreeRecordCell (记录行单元格)
// ==========================================
@interface MLChatRoomThemeGameThreeRecordCell : UITableViewCell

@property (nonatomic, strong) UIImageView *cardBgImageView;
@property (nonatomic, strong) UIImageView *avatarBgView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *giftBgFrameView;
@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, strong) UIView *textContainer;
@property (nonatomic, strong) UILabel *giftNameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *diamondIcon;

@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, strong) NSDictionary *recordData;

- (void)configureWithData:(NSDictionary *)data isMine:(BOOL)isMine isExpanded:(BOOL)expanded;

@end

@implementation MLChatRoomThemeGameThreeRecordCell

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
    _cardBgImageView.contentMode = UIViewContentModeScaleToFill;
    _cardBgImageView.image = [UIImage imageNamed:@"theme_game_three_record_bg"];
    [self.contentView addSubview:_cardBgImageView];
    
    [_cardBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, KDialogAdaptedWidth(8), 0));
    }];
    
    _avatarBgView = [[UIImageView alloc] init];
    _avatarBgView.contentMode = UIViewContentModeScaleAspectFit;
    _avatarBgView.image = [UIImage imageNamed:@"theme_game_three_record_avatar_bg"];
    [_cardBgImageView addSubview:_avatarBgView];
    
    [_avatarBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(14));
        make.centerY.mas_equalTo(_cardBgImageView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(44), KDialogAdaptedWidth(44)));
    }];
    
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.clipsToBounds = YES;
    setViewCorner(_avatarImageView, KDialogAdaptedWidth(16));
    [_avatarBgView addSubview:_avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_avatarBgView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(32), KDialogAdaptedWidth(32)));
    }];
    
    _nicknameLabel = [[UILabel alloc] init];
    _nicknameLabel.textColor = kWhiteColor;
    _nicknameLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(13)];
    [_cardBgImageView addSubview:_nicknameLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
    _timeLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(11)];
    [_cardBgImageView addSubview:_timeLabel];
    
    _giftBgFrameView = [[UIImageView alloc] init];
    _giftBgFrameView.contentMode = UIViewContentModeScaleAspectFit;
    _giftBgFrameView.image = [UIImage imageNamed:@"theme_game_three_record_gift_bg"];
    [_cardBgImageView addSubview:_giftBgFrameView];
    
    [_giftBgFrameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(14));
        make.centerY.mas_equalTo(_cardBgImageView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(50), KDialogAdaptedWidth(50)));
    }];
    
    _giftImageView = [[UIImageView alloc] init];
    _giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_giftBgFrameView addSubview:_giftImageView];
    [_giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_giftBgFrameView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(36), KDialogAdaptedWidth(36)));
    }];
    
    _textContainer = [[UIView alloc] init];
    [_cardBgImageView addSubview:_textContainer];
    
    _giftNameLabel = [[UILabel alloc] init];
    _giftNameLabel.textColor = kWhiteColor;
    _giftNameLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(12)];
    [_textContainer addSubview:_giftNameLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = mHexRGB(0xE9F2FF);
    _priceLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(11)];
    [_textContainer addSubview:_priceLabel];
    
    _diamondIcon = [[UIImageView alloc] init];
    _diamondIcon.contentMode = UIViewContentModeScaleAspectFit;
    _diamondIcon.image = [UIImage imageNamed:@"theme_game_three_diamond_icon"];
    [_textContainer addSubview:_diamondIcon];
}

- (void)configureWithData:(NSDictionary *)data isMine:(BOOL)isMine isExpanded:(BOOL)expanded {
    _recordData = data;
    _isMine = isMine;
    
    _timeLabel.text = data[@"create_time"];
    
    if (_isMine) {
        _avatarBgView.hidden = YES;
        _nicknameLabel.hidden = YES;
        _timeLabel.hidden = YES;
        
        [_textContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KDialogAdaptedWidth(14));
            make.centerY.mas_equalTo(_cardBgImageView);
            make.trailing.mas_lessThanOrEqualTo(_giftBgFrameView.mas_leading).offset(-KDialogAdaptedWidth(12));
        }];
        
        _giftNameLabel.textAlignment = NSTextAlignmentLeft;
        [_giftNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.mas_equalTo(_textContainer);
            make.trailing.mas_lessThanOrEqualTo(_textContainer);
        }];
        
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_giftNameLabel.mas_bottom).offset(KDialogAdaptedWidth(3));
            make.leading.bottom.mas_equalTo(_textContainer);
        }];
        
        [_diamondIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_priceLabel);
            make.leading.mas_equalTo(_priceLabel.mas_trailing).offset(KDialogAdaptedWidth(4));
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(12), KDialogAdaptedWidth(12)));
        }];
    } else {
        _avatarBgView.hidden = NO;
        _nicknameLabel.hidden = NO;
        _timeLabel.hidden = NO;
        
        NSURL *avatarUrl = [NSURL URLWithString:data[@"avatar"] ?: @""];
        if ([_avatarImageView respondsToSelector:@selector(setImageWithURL:placeholder:)]) {
            [_avatarImageView performSelector:@selector(setImageWithURL:placeholder:) withObject:avatarUrl withObject:[UIImage imageNamed:@"theme_game_one_record_head"]];
        } else if ([_avatarImageView respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
            [_avatarImageView performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:avatarUrl withObject:[UIImage imageNamed:@"theme_game_one_record_head"]];
        } else {
            _avatarImageView.image = [UIImage imageNamed:@"theme_game_one_record_head"];
        }
        
        NSString *rawName = data[@"nickname"] ?: @"";
        if (rawName.length > 2) {
            NSString *prefix = [rawName substringToIndex:2];
            _nicknameLabel.text = [NSString stringWithFormat:@"%@***", prefix];
        } else {
            _nicknameLabel.text = rawName;
        }
        
        [_avatarBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KDialogAdaptedWidth(14));
            make.centerY.mas_equalTo(_cardBgImageView);
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(44), KDialogAdaptedWidth(44)));
        }];
        
        [_nicknameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_avatarBgView.mas_top).offset(KDialogAdaptedWidth(2));
            make.leading.mas_equalTo(_avatarBgView.mas_trailing).offset(KDialogAdaptedWidth(12));
            make.trailing.mas_equalTo(_textContainer.mas_leading).offset(-KDialogAdaptedWidth(8));
        }];
        
        [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_avatarBgView.mas_bottom).offset(-KDialogAdaptedWidth(2));
            make.leading.mas_equalTo(_nicknameLabel);
            make.trailing.mas_equalTo(_nicknameLabel);
        }];
        
        [_textContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(_giftBgFrameView.mas_leading).offset(-KDialogAdaptedWidth(12));
            make.centerY.mas_equalTo(_cardBgImageView);
            make.leading.mas_greaterThanOrEqualTo(_nicknameLabel.mas_trailing).offset(KDialogAdaptedWidth(8));
        }];
        
        _giftNameLabel.textAlignment = NSTextAlignmentRight;
        [_giftNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(_textContainer);
        }];
        
        _priceLabel.textAlignment = NSTextAlignmentRight;
        [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_giftNameLabel.mas_bottom).offset(KDialogAdaptedWidth(3));
            make.bottom.mas_equalTo(_textContainer);
        }];
        
        [_diamondIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_priceLabel);
            make.trailing.mas_equalTo(_textContainer);
            make.leading.mas_equalTo(_priceLabel.mas_trailing).offset(KDialogAdaptedWidth(4));
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(12), KDialogAdaptedWidth(12)));
        }];
    }
    
    _giftNameLabel.text = data[@"gift_name"] ?: @"";
    _priceLabel.text = [NSString stringWithFormat:@"%@", data[@"gift_price"] ?: @"0"];
    
    NSURL *giftUrl = [NSURL URLWithString:data[@"gift_image"] ?: @""];
    if ([_giftImageView respondsToSelector:@selector(setImageWithURL:placeholder:)]) {
        [_giftImageView performSelector:@selector(setImageWithURL:placeholder:) withObject:giftUrl withObject:[UIImage imageNamed:@""]];
    } else if ([_giftImageView respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
        [_giftImageView performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:giftUrl withObject:[UIImage imageNamed:@""]];
    }
}

@end




// ==========================================
// MLChatRoomThemeGameThreeRecordView
// ==========================================
@interface MLChatRoomThemeGameThreeRecordView () <UITableViewDelegate, UITableViewDataSource>

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

@implementation MLChatRoomThemeGameThreeRecordView

+ (void)showInView:(UIView *)parentView typeId:(NSInteger)typeId {
    MLChatRoomThemeGameThreeRecordView *recordView = [[MLChatRoomThemeGameThreeRecordView alloc] initWithFrame:parentView.bounds typeId:typeId];
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
    _bgImageView.image = [UIImage imageNamed:@"theme_game_three_record_clean"];
    if (_bgImageView.image == nil) {
        _bgImageView.backgroundColor = mHexRGB(0x1B1923); // 深紫灰色调背景
    }
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    setViewCorner(_bgImageView, 12);
    [self addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(_bgImageView.mas_width).multipliedBy(1312.0 / 750.0);
    }];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"theme_game_three_record_back"] forState:UIControlStateNormal];
    if ([_closeButton backgroundImageForState:UIControlStateNormal] == nil) {
        [_closeButton setTitle:@"✕" forState:UIControlStateNormal];
        [_closeButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    }
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(28));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(18));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(51), KDialogAdaptedWidth(51)));
    }];
    
    // 页签容器 (水平居中, 定位于高度约 96 pt 处)
    UIView *tabsContainer = [[UIView alloc] init];
    [_bgImageView addSubview:tabsContainer];
    [tabsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(96));
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(168), KDialogAdaptedWidth(32)));
    }];
    
    _allRecordTab = [UIButton buttonWithType:UIButtonTypeCustom];
    [_allRecordTab setImage:[UIImage imageNamed:@"theme_game_three_record_tab_all_selected"] forState:UIControlStateNormal];
    [_allRecordTab addTarget:self action:@selector(allTabClick) forControlEvents:UIControlEventTouchUpInside];
    [tabsContainer addSubview:_allRecordTab];
    [_allRecordTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(80), KDialogAdaptedWidth(32)));
    }];
    
    _myRecordTab = [UIButton buttonWithType:UIButtonTypeCustom];
    [_myRecordTab setImage:[UIImage imageNamed:@"theme_game_three_record_tab_mine"] forState:UIControlStateNormal];
    [_myRecordTab addTarget:self action:@selector(myTabClick) forControlEvents:UIControlEventTouchUpInside];
    [tabsContainer addSubview:_myRecordTab];
    [_myRecordTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(_allRecordTab.mas_trailing).offset(KDialogAdaptedWidth(8));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(80), KDialogAdaptedWidth(32)));
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.1];
    _tableView.separatorInset = UIEdgeInsetsMake(0, KDialogAdaptedWidth(12), 0, KDialogAdaptedWidth(12));
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[MLChatRoomThemeGameThreeRecordCell class] forCellReuseIdentifier:@"RecordCell"];
    [_bgImageView addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tabsContainer.mas_bottom).offset(KDialogAdaptedWidth(12));
        make.leading.mas_equalTo(KDialogAdaptedWidth(24));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(24));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(36));
    }];
}

- (void)loadData {
    NSString *userType = self.showingMyRecord ? @"my" : @"all";
    WeakSelf
    [MLGameLotteryService getDrawLogWithTypeId:self.typeId 
                                      userType:userType 
                                          page:self.currentPage 
                                      pageSize:30 
                                       success:^(NSArray *list, NSInteger total) {
        NSMutableArray *flatList = [NSMutableArray array];
        for (id logItem in list) {
            if ([logItem isKindOfClass:[NSDictionary class]]) {
                NSArray *items = logItem[@"items"];
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
                        NSMutableDictionary *flatItem = [NSMutableDictionary dictionary];
                        flatItem[@"avatar"] = logItem[@"avatar"] ?: @"";
                        flatItem[@"nickname"] = logItem[@"nickname"] ?: @"";
                        flatItem[@"create_time"] = logItem[@"create_time"] ?: @"";
                        flatItem[@"gift_id"] = @(gId);
                        flatItem[@"gift_name"] = name;
                        flatItem[@"gift_price"] = gift[@"gift_price"] ?: gift[@"price"] ?: @(0);
                        flatItem[@"gift_image"] = gift[@"gift_image"] ?: gift[@"image"] ?: gift[@"pic"] ?: @"";
                        flatItem[@"num"] = gift[@"gift_num"] ?: gift[@"num"] ?: @(1);
                        [flatList addObject:flatItem];
                    }
                }
            }
        }
        
        if (wself.currentPage == 1) {
            [wself.recordList removeAllObjects];
            [wself.expandedRowIds removeAllObjects];
        }
        [wself.recordList addObjectsFromArray:flatList];
        [wself.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)allTabClick {
    if (!self.showingMyRecord) return;
    self.showingMyRecord = NO;
    self.currentPage = 1;
    [_allRecordTab setImage:[UIImage imageNamed:@"theme_game_three_record_tab_all_selected"] forState:UIControlStateNormal];
    [_myRecordTab setImage:[UIImage imageNamed:@"theme_game_three_record_tab_mine"] forState:UIControlStateNormal];
    [self loadData];
}

- (void)myTabClick {
    if (self.showingMyRecord) return;
    self.showingMyRecord = YES;
    self.currentPage = 1;
    [_allRecordTab setImage:[UIImage imageNamed:@"theme_game_three_record_tab_all"] forState:UIControlStateNormal];
    [_myRecordTab setImage:[UIImage imageNamed:@"theme_game_three_record_tab_mine_selected"] forState:UIControlStateNormal];
    [self loadData];
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLChatRoomThemeGameThreeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCell" forIndexPath:indexPath];
    NSDictionary *data = self.recordList[indexPath.row];
    [cell configureWithData:data isMine:self.showingMyRecord isExpanded:NO];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KDialogAdaptedWidth(70);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 拍平模式下，点击不触发展开
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
