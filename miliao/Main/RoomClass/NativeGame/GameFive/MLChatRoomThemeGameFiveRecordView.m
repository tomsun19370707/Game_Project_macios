//
//  MLChatRoomThemeGameFiveRecordView.m
//  miliao
//

#import "MLChatRoomThemeGameFiveRecordView.h"
#import "Global.h"
#import "MLGameLotteryService.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD.h>

@interface MLChatRoomThemeGameFiveRecordSection : NSObject

@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *gifts;

@end

@implementation MLChatRoomThemeGameFiveRecordSection

- (instancetype)init {
    if (self = [super init]) {
        _gifts = [NSMutableArray array];
    }
    return self;
}

@end


@interface MLChatRoomThemeGameFiveRecordView ()

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *backgroundContainer;
@property (nonatomic, strong) UIView *contentClippingContainer;
@property (nonatomic, strong) UIImageView *recordBgView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollContentView;
@property (nonatomic, strong) UILabel *emptyLabel;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) NSMutableArray<MLChatRoomThemeGameFiveRecordSection *> *sections;

@end

@implementation MLChatRoomThemeGameFiveRecordView

+ (void)showInView:(UIView *)parentView typeId:(NSInteger)typeId {
    MLChatRoomThemeGameFiveRecordView *recordView = [[MLChatRoomThemeGameFiveRecordView alloc] initWithFrame:parentView.bounds typeId:typeId];
    [parentView addSubview:recordView];
    [recordView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame typeId:(NSInteger)typeId {
    if (self = [super initWithFrame:frame]) {
        self.typeId = typeId;
        self.sections = [NSMutableArray array];
        [self setupUI];
        [self loadData];
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

    // 2. Center popup container (Ratio 686:988)
    _backgroundContainer = [[UIView alloc] init];
    _backgroundContainer.backgroundColor = [UIColor clearColor];
    [self addSubview:_backgroundContainer];
    [_backgroundContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(KDialogAdaptedWidth(270));
        make.height.mas_equalTo(_backgroundContainer.mas_width).multipliedBy(988.0 / 686.0);
    }];

    // 3. Clipped Inner container
    _contentClippingContainer = [[UIView alloc] init];
    _contentClippingContainer.clipsToBounds = YES;
    [_backgroundContainer addSubview:_contentClippingContainer];
    [_contentClippingContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_backgroundContainer);
    }];

    // 3.1 Background image
    _recordBgView = [[UIImageView alloc] init];
    _recordBgView.contentMode = UIViewContentModeScaleToFill;
    _recordBgView.image = [UIImage imageNamed:@"theme_game_five_record_bg"];
    [_contentClippingContainer addSubview:_recordBgView];
    [_recordBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_contentClippingContainer);
    }];

    // 3.2 Scrollable container for date sections & gift cards
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_contentClippingContainer addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(68));
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(40));
        make.leading.trailing.mas_equalTo(0);
    }];

    // 3.3 Empty state label
    _emptyLabel = [[UILabel alloc] init];
    _emptyLabel.text = @"暂无近7天游戏记录";
    _emptyLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    _emptyLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(12)];
    _emptyLabel.textAlignment = NSTextAlignmentCenter;
    _emptyLabel.hidden = YES;
    [_contentClippingContainer addSubview:_emptyLabel];
    [_emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_scrollView);
    }];

    // 4. Overlapping Top-Right Close Button
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"theme_game_five_record_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundContainer addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentClippingContainer).offset(KDialogAdaptedWidth(10));
        make.trailing.mas_equalTo(_contentClippingContainer).offset(-KDialogAdaptedWidth(10));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(24), KDialogAdaptedWidth(24)));
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

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [MLGameLotteryService getDrawLogWithTypeId:self.typeId userType:@"my" page:1 pageSize:50 success:^(NSArray *list, NSInteger total) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        [strongSelf.sections removeAllObjects];
        
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateFormatter *dfFull = [[NSDateFormatter alloc] init];
        dfFull.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        NSDateFormatter *dfDateOnly = [[NSDateFormatter alloc] init];
        dfDateOnly.dateFormat = @"yyyy-MM-dd";
        
        NSMutableDictionary<NSString *, MLChatRoomThemeGameFiveRecordSection *> *sectionMap = [NSMutableDictionary dictionary];
        NSMutableArray<NSString *> *dateKeysOrder = [NSMutableArray array];

        if (list && list.count > 0) {
            for (NSDictionary *dict in list) {
                NSString *createTime = dict[@"create_time"] ?: (dict[@"createtime"] ?: @"");
                NSDate *itemDate = [dfFull dateFromString:createTime];
                if (!itemDate && createTime.length >= 10) {
                    itemDate = [dfDateOnly dateFromString:[createTime substringToIndex:10]];
                }
                
                // Filter: Only keep records within recent 7 days
                if (itemDate) {
                    NSDateComponents *comp = [calendar components:NSCalendarUnitDay fromDate:itemDate toDate:now options:0];
                    if (comp.day > 7) {
                        continue; // Skip logs older than 7 days
                    }
                }
                
                NSString *dateKey = @"";
                if (createTime.length >= 10) {
                    dateKey = [createTime substringToIndex:10];
                } else {
                    dateKey = [dfDateOnly stringFromDate:[NSDate date]];
                }

                MLChatRoomThemeGameFiveRecordSection *section = sectionMap[dateKey];
                if (!section) {
                    section = [[MLChatRoomThemeGameFiveRecordSection alloc] init];
                    section.dateString = dateKey;
                    sectionMap[dateKey] = section;
                    [dateKeysOrder addObject:dateKey];
                }

                // 优先读取 prizes 节点，为空降级读取 items 节点
                id itemsObj = dict[@"prizes"];
                if (!itemsObj || itemsObj == [NSNull null]) {
                    itemsObj = dict[@"items"];
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
                if (items.count > 0) {
                    [section.gifts addObjectsFromArray:items];
                }
            }
            
            for (NSString *key in dateKeysOrder) {
                MLChatRoomThemeGameFiveRecordSection *sec = sectionMap[key];
                if (sec.gifts.count > 0) {
                    [strongSelf.sections addObject:sec];
                }
            }
        }
        
        strongSelf.emptyLabel.hidden = (strongSelf.sections.count > 0);
        [strongSelf renderSections];
    } failure:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        strongSelf.emptyLabel.hidden = (strongSelf.sections.count > 0);
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)renderSections {
    if (_scrollContentView) {
        [_scrollContentView removeFromSuperview];
        _scrollContentView = nil;
    }

    if (self.sections.count == 0) return;

    _scrollContentView = [[UIView alloc] init];
    _scrollContentView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_scrollContentView];

    CGFloat contentW = KDialogAdaptedWidth(232.0f);
    
    [_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(_scrollView);
        make.centerX.mas_equalTo(_scrollView);
        make.width.mas_equalTo(contentW);
    }];

    UIView *lastView = nil;
    NSInteger cols = 3;
    CGFloat itemW = KDialogAdaptedWidth(72.0f);
    CGFloat itemH = KDialogAdaptedWidth(56.0f); // 151 / 196 ratio (~0.77)
    CGFloat gapX = KDialogAdaptedWidth(8.0f);
    CGFloat gapY = KDialogAdaptedWidth(8.0f);

    for (int s = 0; s < self.sections.count; s++) {
        MLChatRoomThemeGameFiveRecordSection *section = self.sections[s];

        // 1. Date Header Label
        UILabel *dateHeader = [[UILabel alloc] init];
        dateHeader.text = section.dateString;
        dateHeader.textColor = [UIColor colorWithWhite:1.0 alpha:0.95];
        dateHeader.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(10.5)];
        [_scrollContentView addSubview:dateHeader];

        [dateHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.mas_equalTo(lastView.mas_bottom).offset(KDialogAdaptedWidth(14));
            } else {
                make.top.mas_equalTo(_scrollContentView).offset(KDialogAdaptedWidth(2));
            }
            make.leading.mas_equalTo(_scrollContentView).offset(KDialogAdaptedWidth(2));
        }];

        // 2. Gift Items Grid Container for this date
        NSInteger giftCount = section.gifts.count;
        NSInteger rows = (giftCount + cols - 1) / cols;
        CGFloat gridH = rows * itemH + (rows - 1) * gapY;

        UIView *gridBox = [[UIView alloc] init];
        gridBox.backgroundColor = [UIColor clearColor];
        [_scrollContentView addSubview:gridBox];

        [gridBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(dateHeader.mas_bottom).offset(KDialogAdaptedWidth(8));
            make.leading.trailing.mas_equalTo(_scrollContentView);
            make.height.mas_equalTo(gridH);
        }];

        for (int i = 0; i < giftCount; i++) {
            NSDictionary *gift = section.gifts[i];
            NSInteger row = i / cols;
            NSInteger col = i % cols;

            UIView *itemBg = [[UIView alloc] init];
            itemBg.backgroundColor = [UIColor clearColor];
            [gridBox addSubview:itemBg];
            [itemBg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(row * (itemH + gapY));
                make.leading.mas_equalTo(col * (itemW + gapX));
                make.size.mas_equalTo(CGSizeMake(itemW, itemH));
            }];

            // Gift Card Background Image (196x151)
            UIImageView *cardBg = [[UIImageView alloc] init];
            cardBg.image = [UIImage imageNamed:@"theme_game_five_record_gift_bg"];
            cardBg.contentMode = UIViewContentModeScaleToFill;
            [itemBg addSubview:cardBg];
            [cardBg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(itemBg);
            }];

            // Gift Thumbnail Image
            UIImageView *giftImg = [[UIImageView alloc] init];
            giftImg.contentMode = UIViewContentModeScaleAspectFit;
            [itemBg addSubview:giftImg];
            [giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(KDialogAdaptedWidth(4));
                make.centerX.mas_equalTo(itemBg);
                make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(30), KDialogAdaptedWidth(30)));
            }];

            NSString *iconPath = gift[@"pic"] ?: (gift[@"image"] ?: @"");
            NSURL *url = [NSURL URLWithString:iconPath];
            if ([giftImg respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)]) {
                [giftImg performSelector:@selector(sd_setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
            } else if ([giftImg respondsToSelector:@selector(setImageWithURL:placeholderImage:)]) {
                [giftImg performSelector:@selector(setImageWithURL:placeholderImage:) withObject:url withObject:[UIImage imageNamed:@""]];
            }

            // Gift Name & Count label
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.textColor = kWhiteColor;
            nameLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(8.5)];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            NSInteger num = [gift[@"num"] integerValue];
            if (num <= 0) num = 1;
            nameLabel.text = num > 1 ? [NSString stringWithFormat:@"%@ x%ld", gift[@"name"] ?: @"", (long)num] : (gift[@"name"] ?: @"");
            nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [itemBg addSubview:nameLabel];
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-KDialogAdaptedWidth(4));
                make.leading.mas_equalTo(KDialogAdaptedWidth(2));
                make.trailing.mas_equalTo(-KDialogAdaptedWidth(2));
            }];
        }

        lastView = gridBox;
    }

    if (lastView) {
        [_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(lastView.mas_bottom).offset(KDialogAdaptedWidth(12));
        }];
    }
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

@end
