#import "MLChatRoomThemeGameOneRecordView.h"
#import "MLGameLotteryService.h"
#import "Global.h"

#define KDialogAdaptedWidth(x) (isPadA ? ceilf((x) * (390.0 / 375.0)) : KAdaptedWidth(x))

// ==========================================
// MLChatRoomThemeGameOneRecordCell (卡片记录单元格)
// ==========================================
@interface MLChatRoomThemeGameOneRecordCell : UITableViewCell

@property (nonatomic, strong) UIImageView *cellBgImageView; // 行背景卡底 (排行背景.png)

// 头部栏信息
@property (nonatomic, strong) UIImageView *avatarFrameView; // 头像框底金环 (头像.png)
@property (nonatomic, strong) UIImageView *avatarImageView; // 真实头像
@property (nonatomic, strong) UILabel *nicknameLabel; // 昵称
@property (nonatomic, strong) UILabel *timeLabel; // 时间
@property (nonatomic, strong) UILabel *drawTimesLabel; // "寻10次"

// 礼物内容区域
@property (nonatomic, strong) UIView *giftsContainerView;

@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, strong) NSDictionary *recordData;
@property (nonatomic, strong) NSArray *mergedItems;

- (void)configureWithData:(NSDictionary *)data isMine:(BOOL)isMine isExpanded:(BOOL)expanded;
+ (CGFloat)cellHeightWithData:(NSDictionary *)data isMine:(BOOL)isMine isExpanded:(BOOL)expanded;

@end

@implementation MLChatRoomThemeGameOneRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 1. 卡片底盘背景 (排行背景.png, CapInsets 局部无损拉伸)
    _cellBgImageView = [[UIImageView alloc] init];
    _cellBgImageView.userInteractionEnabled = YES;
    
    // Top Cap = 40 (锁定紫色头部), Bottom Cap = 10, Left/Right = 15
    UIEdgeInsets insets = UIEdgeInsetsMake(KDialogAdaptedWidth(40), KDialogAdaptedWidth(15), KDialogAdaptedWidth(10), KDialogAdaptedWidth(15));
    _cellBgImageView.image = [[UIImage imageNamed:@"theme_game_one_record_rank_bg"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
    [self.contentView addSubview:_cellBgImageView];
    
    [_cellBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(6));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(6));
        make.leading.mas_equalTo(KDialogAdaptedWidth(12));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(12));
    }];
    
    // 2. 头像金圈底座 (头像.png)
    _avatarFrameView = [[UIImageView alloc] init];
    _avatarFrameView.image = [UIImage imageNamed:@"theme_game_one_record_avatar_frame"];
    _avatarFrameView.contentMode = UIViewContentModeScaleAspectFit;
    [_cellBgImageView addSubview:_avatarFrameView];
    [_avatarFrameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(8));
        make.leading.mas_equalTo(KDialogAdaptedWidth(12));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(36), KDialogAdaptedWidth(36)));
    }];
    
    // 真实头像 (圆裁)
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.clipsToBounds = YES;
    setViewCorner(_avatarImageView, KDialogAdaptedWidth(16));
    [_avatarFrameView addSubview:_avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_avatarFrameView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(32), KDialogAdaptedWidth(32)));
    }];
    
    // 昵称
    _nicknameLabel = [[UILabel alloc] init];
    _nicknameLabel.textColor = kWhiteColor;
    _nicknameLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(14)];
    [_cellBgImageView addSubview:_nicknameLabel];
    
    // 时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    _timeLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(12)];
    [_cellBgImageView addSubview:_timeLabel];
    
    // 寻宝次数
    _drawTimesLabel = [[UILabel alloc] init];
    _drawTimesLabel.textColor = kWhiteColor;
    _drawTimesLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(14)];
    _drawTimesLabel.textAlignment = NSTextAlignmentRight;
    [_cellBgImageView addSubview:_drawTimesLabel];
    
    // 3. 礼物纵向排列容器
    _giftsContainerView = [[UIView alloc] init];
    _giftsContainerView.backgroundColor = [UIColor clearColor];
    [_cellBgImageView addSubview:_giftsContainerView];
}

- (void)configureWithData:(NSDictionary *)data isMine:(BOOL)isMine isExpanded:(BOOL)expanded {
    _recordData = data;
    _isMine = isMine;
    _isExpanded = expanded;
    
    // 合并同种礼物
    NSArray *items = data[@"items"];
    NSMutableArray *mergedList = [NSMutableArray array];
    NSMutableDictionary *mergedDict = [NSMutableDictionary dictionary];
    for (NSDictionary *gift in items) {
        NSInteger gId = [gift[@"gift_id"] integerValue];
        if (gId == 0) {
            gId = [gift[@"id"] integerValue];
        }
        NSNumber *key = @(gId);
        if (mergedDict[key]) {
            NSMutableDictionary *existing = mergedDict[key];
            NSInteger count = [existing[@"num"] integerValue];
            NSInteger addCount = [gift[@"num"] integerValue];
            if (addCount <= 0) addCount = 1;
            existing[@"num"] = @(count + addCount);
        } else {
            NSMutableDictionary *clone = [gift mutableCopy];
            if ([clone[@"num"] integerValue] <= 0) {
                clone[@"num"] = @(1);
            }
            mergedDict[key] = clone;
            [mergedList addObject:clone];
        }
    }
    _mergedItems = [mergedList copy];
    
    // 头部排版
    _drawTimesLabel.text = [NSString stringWithFormat:@"寻%@次", data[@"draw_times"] ?: @"1"];
    _timeLabel.text = data[@"create_time"];
    
    if (_isMine) {
        // 我的记录下：隐藏头像与昵称
        _avatarFrameView.hidden = YES;
        _nicknameLabel.hidden = YES;
        
        [_drawTimesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KDialogAdaptedWidth(15));
            make.leading.mas_equalTo(KDialogAdaptedWidth(12));
        }];
        
        [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_drawTimesLabel);
            make.trailing.mas_equalTo(-KDialogAdaptedWidth(12));
        }];
    } else {
        // 全服记录下：显示头像、昵称
        _avatarFrameView.hidden = NO;
        _nicknameLabel.hidden = NO;
        
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
        
        [_avatarFrameView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KDialogAdaptedWidth(8));
            make.leading.mas_equalTo(KDialogAdaptedWidth(12));
            make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(36), KDialogAdaptedWidth(36)));
        }];
        
        [_nicknameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_avatarFrameView.mas_top).offset(KDialogAdaptedWidth(2));
            make.leading.mas_equalTo(_avatarFrameView.mas_trailing).offset(KDialogAdaptedWidth(8));
            make.trailing.mas_equalTo(_drawTimesLabel.mas_leading).offset(-KDialogAdaptedWidth(8));
        }];
        
        [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_avatarFrameView.mas_bottom).offset(-KDialogAdaptedWidth(2));
            make.leading.mas_equalTo(_nicknameLabel);
            make.trailing.mas_equalTo(_nicknameLabel);
        }];
        
        [_drawTimesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_avatarFrameView);
            make.trailing.mas_equalTo(-KDialogAdaptedWidth(12));
        }];
    }
    
    // 渲染礼物列表
    for (UIView *sub in _giftsContainerView.subviews) {
        [sub removeFromSuperview];
    }
    
    if (_isExpanded && _mergedItems.count > 0) {
        _giftsContainerView.hidden = NO;
        
        [_giftsContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KDialogAdaptedWidth(54)); // 刚好在紫色头部 54pt 之下
            make.leading.trailing.mas_equalTo(_cellBgImageView);
            make.bottom.mas_equalTo(-KDialogAdaptedWidth(8));
        }];
        
        CGFloat rowH = KDialogAdaptedWidth(54);
        CGFloat rowGap = KDialogAdaptedWidth(6);
        
        for (int i = 0; i < _mergedItems.count; i++) {
            NSDictionary *gift = _mergedItems[i];
            
            // 单行背景包裹容器 (使用 个人记录排名.png)
            UIImageView *rowBgView = [[UIImageView alloc] init];
            rowBgView.image = [UIImage imageNamed:@"theme_game_one_record_gift_row_bg"];
            rowBgView.userInteractionEnabled = YES;
            [_giftsContainerView addSubview:rowBgView];
            
            [rowBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(i * (rowH + rowGap));
                make.leading.mas_equalTo(KDialogAdaptedWidth(12));
                make.trailing.mas_equalTo(-KDialogAdaptedWidth(12));
                make.height.mas_equalTo(rowH);
            }];
            
            // 礼物金圈底座 (头像.png)
            UIImageView *giftFrameView = [[UIImageView alloc] init];
            giftFrameView.image = [UIImage imageNamed:@"theme_game_one_record_avatar_frame"];
            giftFrameView.contentMode = UIViewContentModeScaleAspectFit;
            [rowBgView addSubview:giftFrameView];
            [giftFrameView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(KDialogAdaptedWidth(12));
                make.centerY.mas_equalTo(rowBgView);
                make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(36), KDialogAdaptedWidth(36)));
            }];
            
            UIImageView *giftImg = [[UIImageView alloc] init];
            giftImg.contentMode = UIViewContentModeScaleAspectFit;
            [giftFrameView addSubview:giftImg];
            [giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(giftFrameView);
                make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(30), KDialogAdaptedWidth(30)));
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
            
            // 数量 (xN, 居右)
            UILabel *giftNumLabel = [[UILabel alloc] init];
            giftNumLabel.textColor = mHexRGB(0x81D4FA);
            giftNumLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(11)];
            giftNumLabel.text = [NSString stringWithFormat:@"x%@", gift[@"num"] ?: @"1"];
            [rowBgView addSubview:giftNumLabel];
            [giftNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(-KDialogAdaptedWidth(12));
                make.centerY.mas_equalTo(rowBgView);
            }];
            
            // 礼物名称与钻石价格 (金圈右侧, 垂直堆叠)
            UILabel *giftNameLabel = [[UILabel alloc] init];
            giftNameLabel.textColor = kWhiteColor;
            giftNameLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(12)];
            giftNameLabel.text = gift[@"name"] ?: @"";
            [rowBgView addSubview:giftNameLabel];
            [giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(giftFrameView.mas_top).offset(KDialogAdaptedWidth(1));
                make.leading.mas_equalTo(giftFrameView.mas_trailing).offset(KDialogAdaptedWidth(8));
                make.trailing.mas_equalTo(giftNumLabel.mas_leading).offset(-KDialogAdaptedWidth(8));
            }];
            
            NSInteger price = [gift[@"price"] integerValue];
            UILabel *giftPriceLabel = [[UILabel alloc] init];
            giftPriceLabel.textColor = mHexRGB(0xFFE400);
            giftPriceLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(11)];
            giftPriceLabel.text = [NSString stringWithFormat:@"%ld钻石", (long)price];
            [rowBgView addSubview:giftPriceLabel];
            [giftPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(giftFrameView.mas_bottom).offset(-KDialogAdaptedWidth(1));
                make.leading.mas_equalTo(giftNameLabel);
            }];
        }
    } else {
        _giftsContainerView.hidden = YES;
        [_giftsContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KDialogAdaptedWidth(54));
            make.leading.trailing.mas_equalTo(_cellBgImageView);
            make.height.mas_equalTo(0);
        }];
    }
}

+ (CGFloat)cellHeightWithData:(NSDictionary *)data isMine:(BOOL)isMine isExpanded:(BOOL)expanded {
    CGFloat baseH = KDialogAdaptedWidth(54) + KDialogAdaptedWidth(12); // 卡底上下 padding 加头部高
    if (expanded) {
        NSArray *items = data[@"items"];
        // 算合并后的礼物行数
        NSMutableSet *idSet = [NSMutableSet set];
        for (NSDictionary *item in items) {
            NSInteger gId = [item[@"gift_id"] integerValue];
            if (gId == 0) {
                gId = [item[@"id"] integerValue];
            }
            [idSet addObject:@(gId)];
        }
        NSInteger count = idSet.count;
        if (count > 0) {
            CGFloat detailsH = count * KDialogAdaptedWidth(54) + (count - 1) * KDialogAdaptedWidth(6) + KDialogAdaptedWidth(8);
            return baseH + detailsH;
        }
    }
    return baseH;
}

@end


// ==========================================
// MLChatRoomThemeGameOneRecordView (主视图)
// ==========================================
@interface MLChatRoomThemeGameOneRecordView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView; // 容器舱一 (BackgroundContainer)
@property (nonatomic, strong) UIView *hudContainer;      // 容器舱二 (HUDContainer)
@property (nonatomic, strong) UIView *gameplayContainer; // 容器舱三 (GameplayContainer)

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *allRecordTab;
@property (nonatomic, strong) UIButton *myRecordTab;
@property (nonatomic, assign) BOOL showingMyRecord;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *recordList;
@property (nonatomic, strong) NSMutableSet<NSNumber *> *expandedRowIds;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation MLChatRoomThemeGameOneRecordView

+ (void)showInView:(UIView *)parentView typeId:(NSInteger)typeId {
    MLChatRoomThemeGameOneRecordView *recordView = [[MLChatRoomThemeGameOneRecordView alloc] initWithFrame:parentView.bounds typeId:typeId];
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
    
    // 遮罩层
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tap];
    
    // 1. 弹窗大底座容器舱 (BackgroundContainer)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_one_record_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    setViewCorner(_bgImageView, KDialogAdaptedWidth(12));
    [self addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom);
        if (isPadA) {
            // 平板端限宽，等比缩放高度
            make.width.mas_equalTo(KDialogAdaptedWidth(344));
        } else {
            // 手机端左右间距 16pt (即宽 = 屏幕宽 - 32pt)
            make.width.mas_equalTo(self.mas_width).offset(-KDialogAdaptedWidth(32));
        }
        // 高度比锁定 740:1136
        make.height.mas_equalTo(_bgImageView.mas_width).multipliedBy(1136.0 / 740.0);
    }];
    
    // 2. 头部栏信息与控制区舱室 (HUDContainer)
    _hudContainer = [[UIView alloc] init];
    _hudContainer.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:_hudContainer];
    [_hudContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(_bgImageView);
        make.height.mas_equalTo(KDialogAdaptedWidth(100));
    }];
    
    // 返回按钮 (左上角)
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"theme_game_one_record_back"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_hudContainer addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(18));
        make.leading.mas_equalTo(KDialogAdaptedWidth(24));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(34), KDialogAdaptedWidth(34)));
    }];
    
    // 双 Tab 容器与按钮组
    UIView *tabBarView = [[UIView alloc] init];
    [_hudContainer addSubview:tabBarView];
    [tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(50));
        make.centerX.mas_equalTo(_hudContainer);
        make.height.mas_equalTo(KDialogAdaptedWidth(44));
    }];
    
    _allRecordTab = [UIButton buttonWithType:UIButtonTypeCustom];
    [_allRecordTab setImage:[UIImage imageNamed:@"theme_game_one_record_tab_all_selected"] forState:UIControlStateNormal];
    [_allRecordTab addTarget:self action:@selector(allTabClick) forControlEvents:UIControlEventTouchUpInside];
    [tabBarView addSubview:_allRecordTab];
    [_allRecordTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.mas_equalTo(tabBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(126), KDialogAdaptedWidth(44)));
    }];
    
    _myRecordTab = [UIButton buttonWithType:UIButtonTypeCustom];
    [_myRecordTab setImage:[UIImage imageNamed:@"theme_game_one_record_tab_mine_normal"] forState:UIControlStateNormal];
    [_myRecordTab addTarget:self action:@selector(myTabClick) forControlEvents:UIControlEventTouchUpInside];
    [tabBarView addSubview:_myRecordTab];
    [_myRecordTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.mas_equalTo(tabBarView);
        make.leading.mas_equalTo(_allRecordTab.mas_trailing).offset(KDialogAdaptedWidth(10));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(126), KDialogAdaptedWidth(44)));
    }];
    
    // 3. 内容滚动展示区舱室 (GameplayContainer)
    _gameplayContainer = [[UIView alloc] init];
    _gameplayContainer.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:_gameplayContainer];
    [_gameplayContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_hudContainer.mas_bottom).offset(KDialogAdaptedWidth(12));
        make.leading.mas_equalTo(KDialogAdaptedWidth(18));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(18));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(40)); // 安全距离全面屏手势
    }];
    
    // 列表 TableView (充满安全区)
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[MLChatRoomThemeGameOneRecordCell class] forCellReuseIdentifier:@"RecordCell"];
    [_gameplayContainer addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_gameplayContainer);
    }];
}

#pragma mark - 数据拉取
- (void)loadData {
    NSString *userType = self.showingMyRecord ? @"my" : @"all";
    WeakSelf
    [MLGameLotteryService getDrawLogWithTypeId:self.typeId 
                                       userType:userType 
                                           page:self.currentPage 
                                       pageSize:50 
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

#pragma mark - Tab 点击事件
- (void)allTabClick {
    if (!self.showingMyRecord) return;
    self.showingMyRecord = NO;
    self.currentPage = 1;
    [_allRecordTab setImage:[UIImage imageNamed:@"theme_game_one_record_tab_all_selected"] forState:UIControlStateNormal];
    [_myRecordTab setImage:[UIImage imageNamed:@"theme_game_one_record_tab_mine_normal"] forState:UIControlStateNormal];
    [self loadData];
}

- (void)myTabClick {
    if (self.showingMyRecord) return;
    self.showingMyRecord = YES;
    self.currentPage = 1;
    [_allRecordTab setImage:[UIImage imageNamed:@"theme_game_one_record_tab_all_normal"] forState:UIControlStateNormal];
    [_myRecordTab setImage:[UIImage imageNamed:@"theme_game_one_record_tab_mine_selected"] forState:UIControlStateNormal];
    [self loadData];
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLChatRoomThemeGameOneRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCell" forIndexPath:indexPath];
    NSDictionary *data = self.recordList[indexPath.row];
    BOOL expanded = [self.expandedRowIds containsObject:@(indexPath.row)];
    [cell configureWithData:data isMine:self.showingMyRecord isExpanded:expanded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = self.recordList[indexPath.row];
    BOOL expanded = [self.expandedRowIds containsObject:@(indexPath.row)];
    return [MLChatRoomThemeGameOneRecordCell cellHeightWithData:data isMine:self.showingMyRecord isExpanded:expanded];
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
