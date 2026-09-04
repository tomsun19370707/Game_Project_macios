//
//  MLChatRoomThemeGameSixObsidianExchangeDialog.m
//  miliao
//
//  Created for Game 6 (玲珑珍宝塔) 专属黑曜石兑换弹窗 (1:1 对齐安卓端设计与交互).
//  Copyright © 2026 EMO. All rights reserved.
//

#import "MLChatRoomThemeGameSixObsidianExchangeDialog.h"
#import "HomeInfo.h"
#import "Global.h"
#import "BaseModel.h"
#import "FFHomeHandel.h"
#import "DZCX_NetAPIPaths.h"
#import "NetworkRequest.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>

#pragma mark - Gift CollectionView Cell
@interface MLGameSixObsidianGiftCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;

- (void)configureWithItem:(id)item isSelected:(BOOL)isSelected;

@end

@implementation MLGameSixObsidianGiftCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"chatroom_ex_alert_bg"];
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
        _bgImageView.clipsToBounds = YES;
        _bgImageView.hidden = YES;
        [self.contentView addSubview:_bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.centerX.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(33, 33));
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = mHexRGB(0x333333);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(2);
            make.left.mas_equalTo(2);
            make.right.mas_equalTo(-2);
        }];
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:12];
        _countLabel.textColor = mHexRGB(0x666666);
        _countLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_countLabel];
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(0);
            make.left.mas_equalTo(2);
            make.right.mas_equalTo(-2);
        }];
    }
    return self;
}

- (void)configureWithItem:(id)item isSelected:(BOOL)isSelected {
    if (!item) return;
    NSString *name = @"礼物";
    NSString *imgUrl = @"";
    NSInteger num = 0;
    
    if ([item isKindOfClass:[GoodListInfoModel class]]) {
        GoodListInfoModel *model = (GoodListInfoModel *)item;
        name = model.gift_name.length > 0 ? model.gift_name : (model.name ?: @"礼物");
        imgUrl = model.gift_image.length > 0 ? model.gift_image : (model.icon ?: (model.images ?: (model.image ?: @"")));
        num = model.num > 0 ? model.num : (model.gift_num > 0 ? model.gift_num : model.exchange_num);
    } else if ([item isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)item;
        name = dict[@"name"] ?: (dict[@"gift_name"] ?: @"礼物");
        imgUrl = dict[@"image"] ?: (dict[@"gift_image"] ?: (dict[@"img"] ?: @""));
        num = [dict[@"nums"] integerValue] ?: ([dict[@"num"] integerValue] ?: [dict[@"exchange_num"] integerValue]);
    }
    
    _nameLabel.text = name;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"正方形"]];
    _countLabel.text = [NSString stringWithFormat:@"x%ld", (long)num];
    _bgImageView.hidden = !isSelected;
}

@end

#pragma mark - Main Obsidian Exchange Dialog Implementation
@interface MLChatRoomThemeGameSixObsidianExchangeDialog () <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *sheetContainer;

// 顶部标题栏 (48dp)
@property (nonatomic, strong) UIView *headerBar;
@property (nonatomic, strong) UIButton *btnBack;
@property (nonatomic, strong) UILabel *tvTitle;

// Tab 栏 (44dp)
@property (nonatomic, strong) UIView *tabBarView;
@property (nonatomic, strong) UIButton *btnTabDiamond;
@property (nonatomic, strong) UIButton *btnTabGift;
@property (nonatomic, strong) UIView *tabIndicator;
@property (nonatomic, strong) UIView *tabDivider;
@property (nonatomic, assign) NSInteger currentTabIndex; // 0: 钻石兑换, 1: 背包礼物兑换

// 容器 1: 钻石兑换
@property (nonatomic, strong) UIView *diamondContainer;
@property (nonatomic, strong) UILabel *tvDiamondBalance;
@property (nonatomic, strong) UILabel *tvObsidianBalance;
@property (nonatomic, strong) UITextField *tfDiamondNum;
@property (nonatomic, strong) UIView *lineDiamond;
@property (nonatomic, strong) UILabel *tvDiamondPercent;
@property (nonatomic, strong) UIButton *btnDiamondExchange;

// 容器 2: 背包礼物兑换
@property (nonatomic, strong) UIView *giftContainer;
@property (nonatomic, strong) UICollectionView *giftCollectionView;
@property (nonatomic, strong) UILabel *tvEmptyGifts;
@property (nonatomic, strong) UITextField *tfGiftNum;
@property (nonatomic, strong) UIView *lineGift;
@property (nonatomic, strong) UILabel *tvGiftPercent;
@property (nonatomic, strong) UIButton *btnGiftExchange;

// 业务数据
@property (nonatomic, strong) NSMutableArray *giftList;
@property (nonatomic, strong) id selectedGiftItem;
@property (nonatomic, assign) NSInteger selectedGiftIndex;
@property (nonatomic, copy) NSString *cachedDiamondBalance;
@property (nonatomic, copy) NSString *cachedObsidianBalance;
@property (nonatomic, assign) NSInteger diamondRatioCoinRate;
@property (nonatomic, assign) BOOL isExchanging;

@end

@implementation MLChatRoomThemeGameSixObsidianExchangeDialog

+ (instancetype)showInView:(nullable UIView *)parentView success:(nullable void (^)(void))success {
    UIView *targetView = parentView ?: [UIApplication sharedApplication].keyWindow;
    if (!targetView) {
        for (UIWindow *w in [UIApplication sharedApplication].windows) {
            if (w.isKeyWindow) { targetView = w; break; }
        }
    }
    if (!targetView) targetView = [UIApplication sharedApplication].windows.firstObject;
    if (!targetView) return nil;
    
    MLChatRoomThemeGameSixObsidianExchangeDialog *dialog = [[MLChatRoomThemeGameSixObsidianExchangeDialog alloc] initWithFrame:targetView.bounds];
    dialog.onExchangeSuccessBlock = success;
    [targetView addSubview:dialog];
    [dialog animateShow];
    return dialog;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _giftList = [NSMutableArray array];
        _selectedGiftIndex = -1;
        _cachedDiamondBalance = @"0";
        _cachedObsidianBalance = @"0";
        _diamondRatioCoinRate = 10;
        
        [self setupUI];
        [self registerKeyboardNotifications];
        [self switchTab:0];
        [self loadWalletData];
        [self loadConfigData];
        [self loadGiftsData];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI Setup
- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _maskView.userInteractionEnabled = YES;
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    UITapGestureRecognizer *tapMask = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCloseTapped)];
    [_maskView addGestureRecognizer:tapMask];
    
    _sheetContainer = [[UIView alloc] init];
    _sheetContainer.backgroundColor = [UIColor whiteColor];
    _sheetContainer.layer.cornerRadius = 16;
    _sheetContainer.layer.masksToBounds = YES;
    if (@available(iOS 11.0, *)) {
        _sheetContainer.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    }
    [self addSubview:_sheetContainer];
    
    CGFloat panelWidth = MIN(ScreenWidth, 360.0);
    [_sheetContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(panelWidth);
        make.bottom.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tapContainer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onContainerTapped)];
    tapContainer.cancelsTouchesInView = NO;
    tapContainer.delegate = self;
    [_sheetContainer addGestureRecognizer:tapContainer];
    
    _headerBar = [[UIView alloc] init];
    _headerBar.backgroundColor = [UIColor whiteColor];
    [_sheetContainer addSubview:_headerBar];
    [_headerBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.sheetContainer);
        make.height.mas_equalTo(48);
    }];
    
    _btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImg = [UIImage imageNamed:@"back_btn_black"] ?: [UIImage imageNamed:@"set_ed_back"];
    if (backImg) {
        [_btnBack setImage:backImg forState:UIControlStateNormal];
    } else {
        [_btnBack setTitle:@"〈" forState:UIControlStateNormal];
        [_btnBack setTitleColor:mHexRGB(0x333333) forState:UIControlStateNormal];
        _btnBack.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    [_btnBack addTarget:self action:@selector(onCloseTapped) forControlEvents:UIControlEventTouchUpInside];
    [_headerBar addSubview:_btnBack];
    [_btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(self.headerBar);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    _tvTitle = [[UILabel alloc] init];
    _tvTitle.text = @"黑曜石兑换";
    _tvTitle.textColor = mHexRGB(0x333333);
    _tvTitle.font = [UIFont boldSystemFontOfSize:16];
    _tvTitle.textAlignment = NSTextAlignmentCenter;
    [_headerBar addSubview:_tvTitle];
    [_tvTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.headerBar);
    }];
    
    _tabBarView = [[UIView alloc] init];
    _tabBarView.backgroundColor = [UIColor whiteColor];
    [_sheetContainer addSubview:_tabBarView];
    [_tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerBar.mas_bottom);
        make.left.right.mas_equalTo(self.sheetContainer);
        make.height.mas_equalTo(44);
    }];
    
    _btnTabDiamond = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnTabDiamond setTitle:@"钻石兑换" forState:UIControlStateNormal];
    [_btnTabDiamond setTitleColor:mHexRGB(0x333333) forState:UIControlStateNormal];
    _btnTabDiamond.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_btnTabDiamond addTarget:self action:@selector(onTabDiamondClicked) forControlEvents:UIControlEventTouchUpInside];
    [_tabBarView addSubview:_btnTabDiamond];
    [_btnTabDiamond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(self.tabBarView);
        make.width.mas_equalTo(self.tabBarView).multipliedBy(0.5);
    }];
    
    _btnTabGift = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnTabGift setTitle:@"背包礼物兑换" forState:UIControlStateNormal];
    [_btnTabGift setTitleColor:mHexRGB(0x666666) forState:UIControlStateNormal];
    _btnTabGift.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnTabGift addTarget:self action:@selector(onTabGiftClicked) forControlEvents:UIControlEventTouchUpInside];
    [_tabBarView addSubview:_btnTabGift];
    [_btnTabGift mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self.tabBarView);
        make.width.mas_equalTo(self.tabBarView).multipliedBy(0.5);
    }];
    
    _tabIndicator = [[UIView alloc] init];
    _tabIndicator.backgroundColor = mHexRGB(0x2A82E4);
    _tabIndicator.layer.cornerRadius = 1.5;
    [_tabBarView addSubview:_tabIndicator];
    [_tabIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.tabBarView.mas_bottom).offset(-2);
        make.centerX.mas_equalTo(self.btnTabDiamond);
        make.size.mas_equalTo(CGSizeMake(32, 3));
    }];
    
    _tabDivider = [[UIView alloc] init];
    _tabDivider.backgroundColor = mHexRGB(0xF0F0F0);
    [_sheetContainer addSubview:_tabDivider];
    [_tabDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tabBarView.mas_bottom);
        make.left.right.mas_equalTo(self.sheetContainer);
        make.height.mas_equalTo(1);
    }];
    
    [self setupDiamondContainer];
    [self setupGiftContainer];
}

- (void)setupDiamondContainer {
    _diamondContainer = [[UIView alloc] init];
    _diamondContainer.backgroundColor = [UIColor whiteColor];
    [_sheetContainer addSubview:_diamondContainer];
    [_diamondContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tabDivider.mas_bottom);
        make.left.right.mas_equalTo(self.sheetContainer);
        make.bottom.mas_equalTo(self.sheetContainer.mas_bottom).offset(-16);
    }];
    
    UIView *balanceRow = [[UIView alloc] init];
    [_diamondContainer addSubview:balanceRow];
    [balanceRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(24);
    }];
    
    UILabel *lblDiamondTitle = [[UILabel alloc] init];
    lblDiamondTitle.text = @"当前钻石余额：";
    lblDiamondTitle.textColor = mHexRGB(0x333333);
    lblDiamondTitle.font = [UIFont systemFontOfSize:14];
    [balanceRow addSubview:lblDiamondTitle];
    [lblDiamondTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(balanceRow);
    }];
    
    _tvDiamondBalance = [[UILabel alloc] init];
    _tvDiamondBalance.text = @"0";
    _tvDiamondBalance.textColor = mHexRGB(0xFF6F00);
    _tvDiamondBalance.font = [UIFont boldSystemFontOfSize:15];
    [balanceRow addSubview:_tvDiamondBalance];
    [_tvDiamondBalance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lblDiamondTitle.mas_right);
        make.centerY.mas_equalTo(balanceRow);
    }];
    
    _tvObsidianBalance = [[UILabel alloc] init];
    _tvObsidianBalance.text = @"0";
    _tvObsidianBalance.textColor = mHexRGB(0x8A2BE2);
    _tvObsidianBalance.font = [UIFont boldSystemFontOfSize:14];
    [balanceRow addSubview:_tvObsidianBalance];
    [_tvObsidianBalance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(balanceRow);
    }];
    
    UILabel *lblObsidianTitle = [[UILabel alloc] init];
    lblObsidianTitle.text = @"当前黑曜石：";
    lblObsidianTitle.textColor = mHexRGB(0x666666);
    lblObsidianTitle.font = [UIFont systemFontOfSize:13];
    [balanceRow addSubview:lblObsidianTitle];
    [lblObsidianTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.tvObsidianBalance.mas_left);
        make.centerY.mas_equalTo(balanceRow);
    }];
    
    _tfDiamondNum = [[UITextField alloc] init];
    _tfDiamondNum.placeholder = @"请输入兑换钻石数量";
    _tfDiamondNum.font = [UIFont systemFontOfSize:15];
    _tfDiamondNum.textColor = mHexRGB(0x333333);
    _tfDiamondNum.textAlignment = NSTextAlignmentCenter;
    _tfDiamondNum.keyboardType = UIKeyboardTypeNumberPad;
    _tfDiamondNum.delegate = self;
    [_tfDiamondNum addTarget:self action:@selector(onDiamondInputChanged) forControlEvents:UIControlEventEditingChanged];
    [_diamondContainer addSubview:_tfDiamondNum];
    [_tfDiamondNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(balanceRow.mas_bottom).offset(20);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(48);
    }];
    
    _lineDiamond = [[UIView alloc] init];
    _lineDiamond.backgroundColor = mHexRGB(0xDDDDDD);
    [_diamondContainer addSubview:_lineDiamond];
    [_lineDiamond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tfDiamondNum.mas_bottom);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(1);
    }];
    
    _tvDiamondPercent = [[UILabel alloc] init];
    _tvDiamondPercent.text = @"钻石：黑曜石 = 1:10";
    _tvDiamondPercent.textColor = mHexRGB(0x666666);
    _tvDiamondPercent.font = [UIFont systemFontOfSize:13];
    _tvDiamondPercent.textAlignment = NSTextAlignmentCenter;
    [_diamondContainer addSubview:_tvDiamondPercent];
    [_tvDiamondPercent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineDiamond.mas_bottom).offset(16);
        make.left.right.mas_equalTo(self.diamondContainer);
    }];
    
    _btnDiamondExchange = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnDiamondExchange setTitle:@"确定兑换" forState:UIControlStateNormal];
    [_btnDiamondExchange setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnDiamondExchange.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _btnDiamondExchange.backgroundColor = mHexRGB(0x2A82E4);
    _btnDiamondExchange.layer.cornerRadius = 23;
    _btnDiamondExchange.layer.masksToBounds = YES;
    [_btnDiamondExchange addTarget:self action:@selector(onConfirmDiamondExchange) forControlEvents:UIControlEventTouchUpInside];
    [_diamondContainer addSubview:_btnDiamondExchange];
    [_btnDiamondExchange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tvDiamondPercent.mas_bottom).offset(24);
        make.left.mas_equalTo(48);
        make.right.mas_equalTo(-48);
        make.height.mas_equalTo(46);
        make.bottom.mas_equalTo(self.diamondContainer.mas_bottom).offset(-16);
    }];
}

- (void)setupGiftContainer {
    _giftContainer = [[UIView alloc] init];
    _giftContainer.backgroundColor = [UIColor whiteColor];
    _giftContainer.hidden = YES;
    [_sheetContainer addSubview:_giftContainer];
    [_giftContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tabDivider.mas_bottom);
        make.left.right.mas_equalTo(self.sheetContainer);
        make.bottom.mas_equalTo(self.sheetContainer.mas_bottom).offset(-16);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(72, 72);
    layout.minimumInteritemSpacing = 8;
    layout.minimumLineSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
    
    _giftCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _giftCollectionView.backgroundColor = [UIColor clearColor];
    _giftCollectionView.showsHorizontalScrollIndicator = NO;
    _giftCollectionView.delegate = self;
    _giftCollectionView.dataSource = self;
    [_giftCollectionView registerClass:[MLGameSixObsidianGiftCell class] forCellWithReuseIdentifier:@"MLGameSixObsidianGiftCell"];
    [_giftContainer addSubview:_giftCollectionView];
    [_giftCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.right.mas_equalTo(self.giftContainer);
        make.height.mas_equalTo(76);
    }];
    
    _tvEmptyGifts = [[UILabel alloc] init];
    _tvEmptyGifts.text = @"暂无可用背包礼物";
    _tvEmptyGifts.textColor = mHexRGB(0x999999);
    _tvEmptyGifts.font = [UIFont systemFontOfSize:13];
    _tvEmptyGifts.textAlignment = NSTextAlignmentCenter;
    _tvEmptyGifts.userInteractionEnabled = NO;
    _tvEmptyGifts.hidden = YES;
    [_giftContainer addSubview:_tvEmptyGifts];
    [_tvEmptyGifts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.giftCollectionView);
    }];
    
    _tfGiftNum = [[UITextField alloc] init];
    _tfGiftNum.placeholder = @"请输入兑换礼物数量";
    _tfGiftNum.font = [UIFont systemFontOfSize:15];
    _tfGiftNum.textColor = mHexRGB(0x333333);
    _tfGiftNum.textAlignment = NSTextAlignmentCenter;
    _tfGiftNum.keyboardType = UIKeyboardTypeNumberPad;
    _tfGiftNum.delegate = self;
    [_tfGiftNum addTarget:self action:@selector(onGiftInputChanged) forControlEvents:UIControlEventEditingChanged];
    [_giftContainer addSubview:_tfGiftNum];
    [_tfGiftNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.giftCollectionView.mas_bottom).offset(12);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(48);
    }];
    
    _lineGift = [[UIView alloc] init];
    _lineGift.backgroundColor = mHexRGB(0xDDDDDD);
    [_giftContainer addSubview:_lineGift];
    [_lineGift mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tfGiftNum.mas_bottom);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(1);
    }];
    
    _tvGiftPercent = [[UILabel alloc] init];
    _tvGiftPercent.text = @"可兑换黑曜石：0";
    _tvGiftPercent.textColor = mHexRGB(0x666666);
    _tvGiftPercent.font = [UIFont systemFontOfSize:13];
    _tvGiftPercent.textAlignment = NSTextAlignmentCenter;
    [_giftContainer addSubview:_tvGiftPercent];
    [_tvGiftPercent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineGift.mas_bottom).offset(16);
        make.left.right.mas_equalTo(self.giftContainer);
    }];
    
    _btnGiftExchange = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnGiftExchange setTitle:@"确定兑换" forState:UIControlStateNormal];
    [_btnGiftExchange setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnGiftExchange.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _btnGiftExchange.backgroundColor = mHexRGB(0x2A82E4);
    _btnGiftExchange.layer.cornerRadius = 23;
    _btnGiftExchange.layer.masksToBounds = YES;
    [_btnGiftExchange addTarget:self action:@selector(onConfirmGiftExchange) forControlEvents:UIControlEventTouchUpInside];
    [_giftContainer addSubview:_btnGiftExchange];
    [_btnGiftExchange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tvGiftPercent.mas_bottom).offset(24);
        make.left.mas_equalTo(48);
        make.right.mas_equalTo(-48);
        make.height.mas_equalTo(46);
        make.bottom.mas_equalTo(self.giftContainer.mas_bottom).offset(-16);
    }];
}

#pragma mark - Tab 切换
- (void)switchTab:(NSInteger)tabIndex {
    _currentTabIndex = tabIndex;
    if (tabIndex == 0) {
        [_btnTabDiamond setTitleColor:mHexRGB(0x333333) forState:UIControlStateNormal];
        _btnTabDiamond.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_btnTabGift setTitleColor:mHexRGB(0x666666) forState:UIControlStateNormal];
        _btnTabGift.titleLabel.font = [UIFont systemFontOfSize:14];
        
        _diamondContainer.hidden = NO;
        _giftContainer.hidden = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.tabIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.tabBarView.mas_bottom).offset(-2);
                make.centerX.mas_equalTo(self.btnTabDiamond);
                make.size.mas_equalTo(CGSizeMake(32, 3));
            }];
            [self.tabBarView layoutIfNeeded];
        }];
    } else {
        [_btnTabGift setTitleColor:mHexRGB(0x333333) forState:UIControlStateNormal];
        _btnTabGift.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_btnTabDiamond setTitleColor:mHexRGB(0x666666) forState:UIControlStateNormal];
        _btnTabDiamond.titleLabel.font = [UIFont systemFontOfSize:14];
        
        _diamondContainer.hidden = YES;
        _giftContainer.hidden = NO;
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.tabIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.tabBarView.mas_bottom).offset(-2);
                make.centerX.mas_equalTo(self.btnTabGift);
                make.size.mas_equalTo(CGSizeMake(32, 3));
            }];
            [self.tabBarView layoutIfNeeded];
        }];
    }
}

- (void)onTabDiamondClicked { [self switchTab:0]; }
- (void)onTabGiftClicked { [self switchTab:1]; }

#pragma mark - 网络数据加载
- (void)loadWalletData {
    WeakSelf;
    [NetworkRequest POST:user_getMoney parmeters:nil success:^(id responObject) {
        NSDictionary *data = nil;
        if ([responObject isKindOfClass:[BaseModel class]]) {
            BaseModel *bm = (BaseModel *)responObject;
            data = [bm.data isKindOfClass:[NSDictionary class]] ? bm.data : nil;
        } else if ([responObject isKindOfClass:[NSDictionary class]]) {
            data = responObject[@"data"] ?: responObject;
        }
        
        if (data) {
            wself.cachedDiamondBalance = [NSString stringWithFormat:@"%@", data[@"diamond"] ?: @"0"];
            wself.cachedObsidianBalance = [NSString stringWithFormat:@"%@", data[@"ratio_coin"] ?: @"0"];
            dispatch_async(dispatch_get_main_queue(), ^{
                double diamondVal = [wself.cachedDiamondBalance doubleValue];
                double obsidianVal = [wself.cachedObsidianBalance doubleValue];
                wself.tvDiamondBalance.text = [wself formatLargeNumber:diamondVal];
                wself.tvObsidianBalance.text = [wself formatLargeNumber:obsidianVal];
            });
        }
    } failture:^(NSError *error) {}];
}

- (void)loadConfigData {
    WeakSelf;
    [NetworkRequest POST:index_config parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        if ([baseModel.data isKindOfClass:[NSDictionary class]]) {
            NSString *rateStr = baseModel.data[@"diamond_change_ratio_coin"];
            if (rateStr.length > 0 && [rateStr integerValue] > 0) {
                wself.diamondRatioCoinRate = [rateStr integerValue];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.tvDiamondPercent.text = [NSString stringWithFormat:@"钻石：黑曜石 = 1:%ld", (long)wself.diamondRatioCoinRate];
            });
        }
    } failture:^(NSError *error) {}];
}

- (void)loadGiftsData {
    WeakSelf;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @"1";
    params[@"size"] = @"1000";
    params[@"is_send"] = @"1";
    if ([NSString NotNull:UserDefaultsGet(kToken)]) params[@"token"] = UserDefaultsGet(kToken);
    
    [FFHomeHandel fetchPackageGiftList:params success:^(NSMutableArray *dataArr, NSString *pageNo, BOOL hasNextPage) {
        [wself.giftList removeAllObjects];
        if (dataArr && [dataArr isKindOfClass:[NSArray class]] && dataArr.count > 0) {
            [wself.giftList addObjectsFromArray:dataArr];
            wself.selectedGiftIndex = 0;
            wself.selectedGiftItem = wself.giftList.firstObject;
            wself.tvEmptyGifts.hidden = YES;
            wself.giftCollectionView.hidden = NO;
        } else {
            wself.selectedGiftIndex = -1;
            wself.selectedGiftItem = nil;
            wself.tvEmptyGifts.hidden = NO;
            wself.giftCollectionView.hidden = YES;
        }
        [wself.giftCollectionView reloadData];
        [wself updateGiftExchangeEstimate];
    } failure:^{
        wself.tvEmptyGifts.hidden = (wself.giftList.count > 0);
        wself.giftCollectionView.hidden = (wself.giftList.count == 0);
    }];
}

#pragma mark - 兑换业务逻辑
- (void)onDiamondInputChanged {}

- (void)onConfirmDiamondExchange {
    if (_isExchanging) return;
    NSString *inputStr = [_tfDiamondNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (inputStr.length == 0) { [SVProgressHUD showImage:nil status:@"请输入兑换钻石数量"]; return; }
    
    double diamondToExchange = [inputStr doubleValue];
    if (diamondToExchange <= 0) { [SVProgressHUD showImage:nil status:@"兑换数量需大于 0"]; return; }
    if (diamondToExchange > [_cachedDiamondBalance doubleValue]) { [SVProgressHUD showImage:nil status:@"钻石余额不足"]; return; }
    
    _isExchanging = YES;
    [SVProgressHUD showWithStatus:@"兑换中..."];
    WeakSelf;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"diamond"] = inputStr;
    [FFHomeHandel customeOprHandle:param apiStr:user_diamondChangeRatioCoin success:^(BaseModel *info) {
        wself.isExchanging = NO;
        [SVProgressHUD showSuccessWithStatus:@"✨ 黑曜石兑换成功！"];
        wself.tfDiamondNum.text = @"";
        [wself loadWalletData];
        if (wself.onExchangeSuccessBlock) wself.onExchangeSuccessBlock();
    } failure:^{ wself.isExchanging = NO; }];
}

- (void)onGiftInputChanged { [self updateGiftExchangeEstimate]; }

- (void)updateGiftExchangeEstimate {
    if (!_selectedGiftItem) {
        _tvGiftPercent.text = @"可兑换黑曜石：0";
        return;
    }
    NSString *inputStr = [_tfGiftNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger count = (inputStr.length > 0) ? [inputStr integerValue] : 1;
    
    double singleExchangeNum = 0;
    if ([_selectedGiftItem isKindOfClass:[GoodListInfoModel class]]) {
        GoodListInfoModel *model = (GoodListInfoModel *)_selectedGiftItem;
        singleExchangeNum = model.exchange_num > 0 ? model.exchange_num : [model.price doubleValue];
    } else if ([_selectedGiftItem isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)_selectedGiftItem;
        singleExchangeNum = [dict[@"exchange_num"] doubleValue] ?: [dict[@"price"] doubleValue];
    }
    _tvGiftPercent.text = [NSString stringWithFormat:@"可兑换黑曜石：%@", [self formatLargeNumber:singleExchangeNum * count]];
}

- (void)onConfirmGiftExchange {
    if (_isExchanging) return;
    if (!_selectedGiftItem) { [SVProgressHUD showImage:nil status:@"请选择要兑换的背包礼物"]; return; }
    
    NSString *inputStr = [_tfGiftNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (inputStr.length == 0) { [SVProgressHUD showImage:nil status:@"请输入兑换礼物数量"]; return; }
    NSInteger num = [inputStr integerValue];
    if (num <= 0) { [SVProgressHUD showImage:nil status:@"兑换数量需大于 0"]; return; }
    
    NSString *knapsackId = @"";
    NSInteger maxNum = 0;
    if ([_selectedGiftItem isKindOfClass:[GoodListInfoModel class]]) {
        GoodListInfoModel *model = (GoodListInfoModel *)_selectedGiftItem;
        knapsackId = model.knapsack_id.length > 0 ? model.knapsack_id : ([NSString stringWithFormat:@"%d", model.gift_id] ?: @"");
        maxNum = model.num > 0 ? model.num : (model.gift_num > 0 ? model.gift_num : model.exchange_num);
    } else if ([_selectedGiftItem isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)_selectedGiftItem;
        knapsackId = [NSString stringWithFormat:@"%@", dict[@"knapsack_id"] ?: (dict[@"gift_id"] ?: (dict[@"id"] ?: @""))];
        maxNum = [dict[@"nums"] integerValue] ?: [dict[@"num"] integerValue];
    }
    
    if (num > maxNum) { [SVProgressHUD showImage:nil status:@"背包礼物数量不足"]; return; }
    
    _isExchanging = YES;
    [SVProgressHUD showWithStatus:@"兑换中..."];
    WeakSelf;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"knapsack_id"] = knapsackId;
    param[@"nums"] = inputStr;
    if ([NSString NotNull:UserDefaultsGet(kToken)]) param[@"token"] = UserDefaultsGet(kToken);
    
    [FFHomeHandel customeOprHandle:param apiStr:gift_bagGiftExchangeRatioCoin success:^(BaseModel *info) {
        wself.isExchanging = NO;
        [SVProgressHUD showSuccessWithStatus:@"✨ 礼物兑换黑曜石成功！"];
        wself.tfGiftNum.text = @"";
        [wself loadWalletData];
        [wself loadGiftsData];
        if (wself.onExchangeSuccessBlock) wself.onExchangeSuccessBlock();
    } failure:^{ wself.isExchanging = NO; }];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { return _giftList.count; }

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLGameSixObsidianGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MLGameSixObsidianGiftCell" forIndexPath:indexPath];
    [cell configureWithItem:_giftList[indexPath.item] isSelected:(indexPath.item == _selectedGiftIndex)];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedGiftIndex = indexPath.item;
    _selectedGiftItem = _giftList[indexPath.item];
    [_giftCollectionView reloadData];
    [self updateGiftExchangeEstimate];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.giftCollectionView]) {
        return NO;
    }
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - Keyboard
- (void)registerKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)note {
    CGRect kbFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{ self.sheetContainer.transform = CGAffineTransformMakeTranslation(0, -kbFrame.size.height); }];
}

- (void)keyboardWillHide:(NSNotification *)note {
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{ self.sheetContainer.transform = CGAffineTransformIdentity; }];
}

#pragma mark - Animations
- (void)animateShow {
    self.maskView.alpha = 0.0;
    self.sheetContainer.transform = CGAffineTransformMakeTranslation(0, 400);
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 1.0;
        self.sheetContainer.transform = CGAffineTransformIdentity;
    }];
}

- (void)animateDismissWithCompletion:(nullable void (^)(void))completion {
    [self endEditing:YES];
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = 0.0;
        self.sheetContainer.transform = CGAffineTransformMakeTranslation(0, ScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) completion();
    }];
}

- (void)onCloseTapped { [self animateDismissWithCompletion:nil]; }
- (void)onContainerTapped { [self endEditing:YES]; }

#pragma mark - Large Number Format
- (NSString *)formatLargeNumber:(double)num {
    if (num >= 1000000000000.0) {
        double v = num / 1000000000000.0;
        NSString *str = [NSString stringWithFormat:@"%.2f", v];
        if ([str hasSuffix:@".00"]) str = [str substringToIndex:str.length - 3];
        return [NSString stringWithFormat:@"%@万亿", str];
    } else if (num >= 100000000.0) {
        double v = num / 100000000.0;
        NSString *str = [NSString stringWithFormat:@"%.2f", v];
        if ([str hasSuffix:@".00"]) str = [str substringToIndex:str.length - 3];
        return [NSString stringWithFormat:@"%@亿", str];
    } else if (num >= 10000.0) {
        double v = num / 10000.0;
        NSString *str = [NSString stringWithFormat:@"%.2f", v];
        if ([str hasSuffix:@".00"]) str = [str substringToIndex:str.length - 3];
        return [NSString stringWithFormat:@"%@万", str];
    } else {
        if (floor(num) == num) {
            return [NSString stringWithFormat:@"%ld", (long)num];
        } else {
            NSString *str = [NSString stringWithFormat:@"%.2f", num];
            if ([str hasSuffix:@".00"]) str = [str substringToIndex:str.length - 3];
            return str;
        }
    }
}

@end
