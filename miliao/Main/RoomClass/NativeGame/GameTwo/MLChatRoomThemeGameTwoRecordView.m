#import "MLChatRoomThemeGameTwoRecordView.h"
#import "MLGameLotteryService.h"
#import "Global.h"

// ==========================================
// MLChatRoomThemeGameTwoRecordCell (记录行单元格)
// ==========================================
@interface MLChatRoomThemeGameTwoRecordCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
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
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.clipsToBounds = YES;
    setViewCorner(_avatarImageView, 18);
    [self.contentView addSubview:_avatarImageView];
    
    _nicknameLabel = [[UILabel alloc] init];
    _nicknameLabel.textColor = kWhiteColor;
    _nicknameLabel.font = KFontBoldA(13);
    [self.contentView addSubview:_nicknameLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
    _timeLabel.font = KFontA(11);
    [self.contentView addSubview:_timeLabel];
    
    _summaryLabel = [[UILabel alloc] init];
    _summaryLabel.textColor = mHexRGB(0xFFE400);
    _summaryLabel.font = KFontBoldA(12);
    _summaryLabel.textAlignment = NSTextAlignmentRight;
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
    
    if (_isMine) {
        _avatarImageView.hidden = YES;
        _nicknameLabel.hidden = YES;
        
        [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.leading.mas_equalTo(12);
            make.width.mas_equalTo(150);
        }];
        
        [_summaryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_timeLabel);
            make.trailing.mas_equalTo(-12);
        }];
    } else {
        _avatarImageView.hidden = NO;
        _nicknameLabel.hidden = NO;
        
        NSURL *avatarUrl = [NSURL URLWithString:data[@"avatar"] ?: @""];
        if ([_avatarImageView respondsToSelector:@selector(setImageWithURL:placeholder:)]) {
            [_avatarImageView performSelector:@selector(setImageWithURL:placeholder:) withObject:avatarUrl withObject:[UIImage imageNamed:@"theme_game_two_record_head"]];
        } else if ([_avatarImageView respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
            [_avatarImageView performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:avatarUrl withObject:[UIImage imageNamed:@"theme_game_two_record_head"]];
        } else {
            _avatarImageView.image = [UIImage imageNamed:@"theme_game_two_record_head"];
        }
        
        NSString *rawName = data[@"nickname"] ?: @"";
        if (rawName.length > 2) {
            NSString *prefix = [rawName substringToIndex:2];
            _nicknameLabel.text = [NSString stringWithFormat:@"%@***", prefix];
        } else {
            _nicknameLabel.text = rawName;
        }
        
        [_avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.leading.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        
        [_nicknameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_avatarImageView);
            make.leading.mas_equalTo(_avatarImageView.mas_trailing).offset(8);
            make.trailing.mas_equalTo(_summaryLabel.mas_leading).offset(-8);
        }];
        
        [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_avatarImageView);
            make.leading.mas_equalTo(_nicknameLabel);
            make.trailing.mas_equalTo(_nicknameLabel);
        }];
        
        [_summaryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_avatarImageView);
            make.trailing.mas_equalTo(-12);
            make.width.mas_greaterThanOrEqualTo(100);
        }];
    }
    
    for (UIView *sub in _giftsContainerView.subviews) {
        [sub removeFromSuperview];
    }
    
    if (_isExpanded) {
        _giftsContainerView.hidden = NO;
        NSArray *items = data[@"items"];
        
        CGFloat leftMargin = 12.0f;
        CGFloat topMargin = 8.0f;
        CGFloat itemW = 50.0f;
        CGFloat itemH = 65.0f;
        CGFloat hGap = 12.0f;
        CGFloat vGap = 8.0f;
        
        CGFloat containerLeft = _isMine ? 12 : 56;
        [_giftsContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_isMine ? _timeLabel.mas_bottom : _avatarImageView.mas_bottom).offset(10);
            make.leading.mas_equalTo(containerLeft);
            make.trailing.mas_equalTo(-12);
            make.bottom.mas_equalTo(-8);
        }];
        
        for (int i = 0; i < items.count; i++) {
            NSDictionary *gift = items[i];
            NSInteger row = i / 4;
            NSInteger col = i % 4;
            
            UIView *giftView = [[UIView alloc] init];
            [_giftsContainerView addSubview:giftView];
            [giftView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(topMargin + row * (itemH + vGap));
                make.leading.mas_equalTo(leftMargin + col * (itemW + hGap));
                make.size.mas_equalTo(CGSizeMake(itemW, itemH));
            }];
            
            UIImageView *giftImg = [[UIImageView alloc] init];
            giftImg.contentMode = UIViewContentModeScaleAspectFit;
            [giftView addSubview:giftImg];
            [giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.centerX.mas_equalTo(giftView);
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
            
            NSString *imgUrlStr = gift[@"pic"] ?: @"";
            if (imgUrlStr.length == 0) {
                imgUrlStr = gift[@"image"] ?: @"";
            }
            NSURL *url = [NSURL URLWithString:imgUrlStr];
            if ([giftImg respondsToSelector:@selector(setImageWithURL:placeholder:)]) {
                [giftImg performSelector:@selector(setImageWithURL:placeholder:) withObject:url withObject:[UIImage imageNamed:@""]];
            } else if ([giftImg respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
                [giftImg performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
            }
            
            UILabel *giftNum = [[UILabel alloc] init];
            giftNum.textColor = kWhiteColor;
            giftNum.backgroundColor = [UIColor redColor];
            giftNum.font = KFontA(9);
            giftNum.textAlignment = NSTextAlignmentCenter;
            giftNum.text = [NSString stringWithFormat:@"x%@", gift[@"num"] ?: @"1"];
            setViewCorner(giftNum, 5);
            [giftView addSubview:giftNum];
            [giftNum mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.trailing.mas_equalTo(giftImg);
                make.height.mas_equalTo(10);
                make.width.mas_greaterThanOrEqualTo(14);
            }];
            
            UILabel *giftName = [[UILabel alloc] init];
            giftName.textColor = [UIColor colorWithWhite:1 alpha:0.8];
            giftName.font = KFontA(9);
            giftName.textAlignment = NSTextAlignmentCenter;
            giftName.text = gift[@"name"] ?: @"";
            [giftView addSubview:giftName];
            [giftName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.leading.trailing.mas_equalTo(giftView);
            }];
        }
    } else {
        _giftsContainerView.hidden = YES;
        [_giftsContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_isMine ? _timeLabel.mas_bottom : _avatarImageView.mas_bottom);
            make.leading.trailing.mas_equalTo(self.contentView);
            make.height.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
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
    _bgImageView.image = [UIImage imageNamed:@"theme_game_two_record_board"];
    if (_bgImageView.image == nil) {
        _bgImageView.backgroundColor = mHexRGB(0x1B1923); // 深紫灰色调背景
    }
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    setViewCorner(_bgImageView, 12);
    [self addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(315, 470));
    }];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"theme_game_two_record_back"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(28);
        make.leading.mas_equalTo(32);
        make.size.mas_equalTo(CGSizeMake(34, 34));
    }];
    
    // 页签容器 (水平居中, 定位于高度 16.5% 处, 即约 77 pt)
    UIView *tabsContainer = [[UIView alloc] init];
    [_bgImageView addSubview:tabsContainer];
    [tabsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(77);
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(168, 32));
    }];
    
    _allRecordTab = [UIButton buttonWithType:UIButtonTypeCustom];
    [_allRecordTab setImage:[UIImage imageNamed:@"theme_game_two_record_tab_all_selected"] forState:UIControlStateNormal];
    [_allRecordTab addTarget:self action:@selector(allTabClick) forControlEvents:UIControlEventTouchUpInside];
    [tabsContainer addSubview:_allRecordTab];
    [_allRecordTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(80, 32));
    }];
    
    _myRecordTab = [UIButton buttonWithType:UIButtonTypeCustom];
    [_myRecordTab setImage:[UIImage imageNamed:@"theme_game_two_record_tab_mine"] forState:UIControlStateNormal];
    [_myRecordTab addTarget:self action:@selector(myTabClick) forControlEvents:UIControlEventTouchUpInside];
    [tabsContainer addSubview:_myRecordTab];
    [_myRecordTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(_allRecordTab.mas_trailing).offset(8);
        make.size.mas_equalTo(CGSizeMake(80, 32));
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.1];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[MLChatRoomThemeGameTwoRecordCell class] forCellReuseIdentifier:@"RecordCell"];
    [_bgImageView addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tabsContainer.mas_bottom).offset(12);
        make.leading.mas_equalTo(18);
        make.trailing.mas_equalTo(-18);
        make.bottom.mas_equalTo(-60); // 60pt bottom safety margin
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
    [_allRecordTab setImage:[UIImage imageNamed:@"theme_game_two_record_tab_all_selected"] forState:UIControlStateNormal];
    [_myRecordTab setImage:[UIImage imageNamed:@"theme_game_two_record_tab_mine"] forState:UIControlStateNormal];
    [self loadData];
}

- (void)myTabClick {
    if (self.showingMyRecord) return;
    self.showingMyRecord = YES;
    self.currentPage = 1;
    [_allRecordTab setImage:[UIImage imageNamed:@"theme_game_two_record_tab_all"] forState:UIControlStateNormal];
    [_myRecordTab setImage:[UIImage imageNamed:@"theme_game_two_record_tab_mine_selected"] forState:UIControlStateNormal];
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
        NSDictionary *data = self.recordList[indexPath.row];
        NSArray *items = data[@"items"];
        NSInteger rows = (items.count + 3) / 4;
        CGFloat giftsH = rows * 65.0f + (rows - 1) * 8.0f + 16.0f;
        return (self.showingMyRecord ? 35.0f : 55.0f) + giftsH;
    }
    return self.showingMyRecord ? 35.0f : 55.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *rowNum = @(indexPath.row);
    if ([self.expandedRowIds containsObject:rowNum]) {
        [self.expandedRowIds removeObject:rowNum];
    } else {
        [self.expandedRowIds addObject:rowNum];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
