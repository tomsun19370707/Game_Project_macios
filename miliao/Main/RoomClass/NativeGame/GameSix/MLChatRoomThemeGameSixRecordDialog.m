#import "MLChatRoomThemeGameSixRecordDialog.h"
#import "MLThemeGameSixRecordCell.h"
#import "MLThemeGameSixRecordDateHeader.h"
#import "MLThemeGameModel.h"
#import "Global.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>

static NSString * const kRecordCellReuseId = @"MLThemeGameSixRecordCell";
static NSString * const kRecordHeaderReuseId = @"MLThemeGameSixRecordDateHeader";

@interface MLChatRoomThemeGameSixRecordDialog () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *boardContainer;
@property (nonatomic, strong) UIImageView *boardBgImageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *emptyLabel;

/// 二维数据源: @[ @{@"date": @"2026.08.01", @"items": @[dict1, dict2]}, ... ]
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *sectionDataList;

@end

@implementation MLChatRoomThemeGameSixRecordDialog

+ (instancetype)showInView:(UIView *)parentView {
    UIView *targetView = parentView ?: [UIApplication sharedApplication].keyWindow;
    MLChatRoomThemeGameSixRecordDialog *dialog = [[MLChatRoomThemeGameSixRecordDialog alloc] initWithFrame:targetView.bounds];
    [targetView addSubview:dialog];
    [dialog animateShow];
    [dialog loadRecordsData];
    return dialog;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _sectionDataList = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 1. 半透明遮罩
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tapMask = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_maskView addGestureRecognizer:tapMask];
    
    // 2. 主卡片容器 (330x460 pt)
    _boardContainer = [[UIView alloc] init];
    [self addSubview:_boardContainer];
    [_boardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(330), KDialogAdaptedWidth(460)));
    }];
    
    _boardBgImageView = [[UIImageView alloc] init];
    _boardBgImageView.image = [UIImage imageNamed:@"theme_game_six_record_bg"];
    _boardBgImageView.contentMode = UIViewContentModeScaleToFill;
    [_boardContainer addSubview:_boardBgImageView];
    [_boardBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_boardContainer);
    }];
    
    // 3. 关闭按钮 (30x30 pt, 顶距 12pt, 左边距 12pt)
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"theme_game_six_record_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_boardContainer addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_boardContainer).offset(KDialogAdaptedWidth(12));
        make.leading.mas_equalTo(_boardContainer).offset(KDialogAdaptedWidth(12));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(30), KDialogAdaptedWidth(30)));
    }];
    
    // 4. UICollectionView 3 列网格列表
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = KDialogAdaptedWidth(6);
    layout.minimumInteritemSpacing = KDialogAdaptedWidth(4);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    [_collectionView registerClass:[MLThemeGameSixRecordCell class] forCellWithReuseIdentifier:kRecordCellReuseId];
    [_collectionView registerClass:[MLThemeGameSixRecordDateHeader class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:kRecordHeaderReuseId];
               
    [_boardContainer addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_boardContainer).offset(KDialogAdaptedWidth(88));
        make.leading.mas_equalTo(_boardContainer).offset(KDialogAdaptedWidth(20));
        make.trailing.mas_equalTo(_boardContainer).offset(-KDialogAdaptedWidth(20));
        make.bottom.mas_equalTo(_boardContainer).offset(-KDialogAdaptedWidth(56));
    }];
    
    // 5. 空状态提示
    _emptyLabel = [[UILabel alloc] init];
    _emptyLabel.text = @"暂无历史重铸记录";
    _emptyLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    _emptyLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(12)];
    _emptyLabel.textAlignment = NSTextAlignmentCenter;
    _emptyLabel.hidden = YES;
    [_boardContainer addSubview:_emptyLabel];
    [_emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_collectionView);
    }];
}

// MARK: - 数据加载与 500 条多页递归合并算法
- (void)loadRecordsData {
    [SVProgressHUD showWithStatus:@"正在加载记录..."];
    [self fetchRecordsRecursivelyWithPage:1 accumList:[NSMutableArray array]];
}

- (void)fetchRecordsRecursivelyWithPage:(NSInteger)page accumList:(NSMutableArray *)accumList {
    __weak typeof(self) weakSelf = self;
    [[MLThemeGameModel new] fetchTowerGameSixRecordsWithPage:page limit:100 type:@"draw" success:^(id _Nullable responseObj) {
        NSArray *rawList = nil;
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            rawList = responseObj[@"list"];
        } else if ([responseObj isKindOfClass:[NSArray class]]) {
            rawList = (NSArray *)responseObj;
        }
        
        if ([rawList isKindOfClass:[NSArray class]] && rawList.count > 0) {
            [accumList addObjectsFromArray:rawList];
            
            // 校验 7 天内时间限制
            NSTimeInterval sevenDaysAgo = [[NSDate date] timeIntervalSince1970] - 7 * 24 * 3600;
            NSDictionary *lastDict = rawList.lastObject;
            NSTimeInterval lastTime = [weakSelf parseTimeIntervalFromDict:lastDict];
            
            if (rawList.count >= 100 && page < 5 && (lastTime == 0 || lastTime >= sevenDaysAgo)) {
                [weakSelf fetchRecordsRecursivelyWithPage:page + 1 accumList:accumList];
                return;
            }
        }
        
        [SVProgressHUD dismiss];
        [weakSelf processAndGroupRecords:accumList];
    } failure:^(NSError * _Nullable error, NSString * _Nullable msg) {
        [SVProgressHUD dismiss];
        if (accumList.count > 0) {
            [weakSelf processAndGroupRecords:accumList];
        } else {
            [SVProgressHUD showInfoWithStatus:msg ?: @"获取历史记录失败"];
            weakSelf.emptyLabel.hidden = NO;
            weakSelf.collectionView.hidden = YES;
        }
    }];
}

- (NSTimeInterval)parseTimeIntervalFromDict:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]]) return 0;
    if (dict[@"created_at"] != nil) {
        NSTimeInterval val = [dict[@"created_at"] doubleValue];
        return val > 10000000000.0 ? val / 1000.0 : val;
    }
    NSString *timeStr = dict[@"create_time"] ?: (dict[@"createtime"] ?: dict[@"created_at_str"]);
    if ([timeStr isKindOfClass:[NSString class]] && timeStr.length > 0) {
        NSDateFormatter *sdf = [[NSDateFormatter alloc] init];
        sdf.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *d = [sdf dateFromString:timeStr];
        if (d) return [d timeIntervalSince1970];
    }
    return 0;
}

- (void)processAndGroupRecords:(NSArray *)rawList {
    NSTimeInterval sevenDaysAgo = [[NSDate date] timeIntervalSince1970] - 7 * 24 * 3600;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy.MM.dd";
    
    // 按 date -> (giftKey -> mutableDict) 结构进行同日合并去重
    NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, NSMutableDictionary *> *> *groupedMap = [NSMutableDictionary dictionary];
    NSMutableArray<NSString *> *dateKeysOrder = [NSMutableArray array];
    
    for (NSDictionary *dict in rawList) {
        if (![dict isKindOfClass:[NSDictionary class]]) continue;
        NSTimeInterval timeSec = [self parseTimeIntervalFromDict:dict];
        if (timeSec > 0 && timeSec < sevenDaysAgo) {
            continue; // 过滤 7 天前的历史
        }
        
        NSString *dateKey = timeSec > 0 ? [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeSec]] : @"最近记录";
        NSMutableDictionary *dateItemsMap = groupedMap[dateKey];
        if (!dateItemsMap) {
            dateItemsMap = [NSMutableDictionary dictionary];
            groupedMap[dateKey] = dateItemsMap;
            [dateKeysOrder addObject:dateKey];
        }
        
        NSDictionary *giftDict = dict[@"gift"];
        NSString *giftId = giftDict[@"gift_id"] ?: (giftDict[@"id"] ?: @"0");
        NSString *giftName = giftDict[@"name"] ?: @"珍宝塔礼物";
        NSString *giftKey = [NSString stringWithFormat:@"%@_%@", giftId, giftName];
        
        if (dateItemsMap[giftKey]) {
            NSMutableDictionary *existing = dateItemsMap[giftKey];
            NSInteger currentCount = [existing[@"count"] integerValue];
            existing[@"count"] = @(currentCount + 1);
        } else {
            NSMutableDictionary *newItem = [NSMutableDictionary dictionary];
            newItem[@"name"] = giftName;
            newItem[@"image"] = giftDict[@"image"] ?: @"";
            newItem[@"count"] = @(1);
            dateItemsMap[giftKey] = newItem;
        }
    }
    
    [_sectionDataList removeAllObjects];
    for (NSString *dateKey in dateKeysOrder) {
        NSMutableDictionary *dateItemsMap = groupedMap[dateKey];
        if (dateItemsMap && dateItemsMap.allValues.count > 0) {
            [_sectionDataList addObject:@{
                @"date": dateKey,
                @"items": dateItemsMap.allValues
            }];
        }
    }
    
    if (_sectionDataList.count == 0) {
        _emptyLabel.hidden = NO;
        _collectionView.hidden = YES;
    } else {
        _emptyLabel.hidden = YES;
        _collectionView.hidden = NO;
        [_collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource & DelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _sectionDataList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *items = _sectionDataList[section][@"items"];
    return items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLThemeGameSixRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRecordCellReuseId forIndexPath:indexPath];
    NSArray *items = _sectionDataList[indexPath.section][@"items"];
    NSDictionary *itemDict = items[indexPath.row];
    
    NSString *name = itemDict[@"name"];
    NSInteger count = [itemDict[@"count"] integerValue];
    NSString *image = itemDict[@"image"];
    
    [cell renderRecordWithGiftName:name count:count imageUrl:image];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MLThemeGameSixRecordDateHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kRecordHeaderReuseId forIndexPath:indexPath];
        NSString *dateStr = _sectionDataList[indexPath.section][@"date"];
        header.dateLabel.text = dateStr;
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat totalWidth = KDialogAdaptedWidth(290);
    CGFloat itemW = (totalWidth - KDialogAdaptedWidth(8)) / 3.0; // 3 列
    CGFloat itemH = itemW / 1.10582; // 匹配原图 209x189 真实比例 (1.106:1)
    return CGSizeMake(itemW, itemH);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(KDialogAdaptedWidth(290), KDialogAdaptedWidth(28));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, KDialogAdaptedWidth(10), 0);
}

#pragma mark - Animations

- (void)animateShow {
    self.alpha = 0.0;
    _boardContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
        self.boardContainer.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        self.boardContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
