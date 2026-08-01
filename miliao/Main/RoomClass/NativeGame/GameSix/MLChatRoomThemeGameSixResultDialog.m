#import "MLChatRoomThemeGameSixResultDialog.h"
#import "MLTowerGameSixModels.h"
#import "MLThemeGameModel.h"
#import "Global.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface MLChatRoomThemeGameSixResultDialog ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *boardContainer;
@property (nonatomic, strong) UIImageView *boardBgImageView;

// 1. 顶部红焰层数标示
@property (nonatomic, strong) UIView *layerBarContainer;
@property (nonatomic, strong) UIImageView *layerBarBgImageView;
@property (nonatomic, strong) UILabel *layerInfoLabel;

// 2. 中间礼物及价值展示
@property (nonatomic, strong) UILabel *giftNameLabel;
@property (nonatomic, strong) UIImageView *resultItemBgImageView;
@property (nonatomic, strong) UIImageView *giftIconImageView;
@property (nonatomic, strong) UILabel *giftValueLabel;

// 3. 底部动作按钮
@property (nonatomic, strong) UIButton *continueActionButton;
@property (nonatomic, strong) UIButton *withdrawActionButton;

@property (nonatomic, strong) MLTowerGameSixRecastResultModel *resultModel;

@end

@implementation MLChatRoomThemeGameSixResultDialog

+ (instancetype)showInView:(UIView *)parentView resultModel:(MLTowerGameSixRecastResultModel *)resultModel {
    if (!parentView) {
        parentView = [UIApplication sharedApplication].keyWindow;
    }
    
    MLChatRoomThemeGameSixResultDialog *dialog = [[MLChatRoomThemeGameSixResultDialog alloc] initWithFrame:parentView.bounds resultModel:resultModel];
    [parentView addSubview:dialog];
    [dialog animateShow];
    return dialog;
}

- (instancetype)initWithFrame:(CGRect)frame resultModel:(MLTowerGameSixRecastResultModel *)resultModel {
    self = [super initWithFrame:frame];
    if (self) {
        _resultModel = resultModel;
        [self setupUI];
        [self renderData];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 0. 全屏半透明遮罩
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tapMask = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_maskView addGestureRecognizer:tapMask];
    
    // 1. 主面板 330 × 450 pt
    _boardContainer = [[UIView alloc] init];
    _boardContainer.userInteractionEnabled = YES;
    [self addSubview:_boardContainer];
    [_boardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(330), KDialogAdaptedWidth(450)));
    }];
    
    // 1.1 背景卷轴底框
    _boardBgImageView = [[UIImageView alloc] init];
    _boardBgImageView.image = [UIImage imageNamed:@"theme_game_six_result_bg"];
    _boardBgImageView.contentMode = UIViewContentModeScaleToFill;
    [_boardContainer addSubview:_boardBgImageView];
    [_boardBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_boardContainer);
    }];
    
    // 2. 顶部红焰层数背景条 (160x40pt, 顶距 80pt)
    _layerBarContainer = [[UIView alloc] init];
    [_boardContainer addSubview:_layerBarContainer];
    [_layerBarContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_boardContainer).offset(KDialogAdaptedWidth(64));
        make.centerX.mas_equalTo(_boardContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(181.5), KDialogAdaptedWidth(73.1)));
    }];
    
    _layerBarBgImageView = [[UIImageView alloc] init];
    _layerBarBgImageView.image = [UIImage imageNamed:@"theme_game_six_result_layer_bar"];
    _layerBarBgImageView.contentMode = UIViewContentModeScaleToFill;
    [_layerBarContainer addSubview:_layerBarBgImageView];
    [_layerBarBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_layerBarContainer);
    }];
    
    _layerInfoLabel = [[UILabel alloc] init];
    _layerInfoLabel.textColor = [UIColor whiteColor];
    _layerInfoLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(15)];
    _layerInfoLabel.textAlignment = NSTextAlignmentCenter;
    [_layerBarContainer addSubview:_layerInfoLabel];
    [_layerInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_layerBarContainer);
        make.centerY.mas_equalTo(_layerBarContainer).offset(KDialogAdaptedWidth(5));
    }];
    
    // 3. 礼物名称 (顶距 128pt)
    _giftNameLabel = [[UILabel alloc] init];
    _giftNameLabel.textColor = [UIColor whiteColor];
    _giftNameLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(13)];
    _giftNameLabel.textAlignment = NSTextAlignmentCenter;
    [_boardContainer addSubview:_giftNameLabel];
    [_giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_boardContainer).offset(KDialogAdaptedWidth(128));
        make.centerX.mas_equalTo(_boardContainer);
    }];
    
    // 4. 中奖礼物金环背景图 (185x185pt, 顶距 142pt)
    _resultItemBgImageView = [[UIImageView alloc] init];
    _resultItemBgImageView.image = [UIImage imageNamed:@"theme_game_six_result_item_bg"];
    _resultItemBgImageView.contentMode = UIViewContentModeScaleToFill;
    [_boardContainer addSubview:_resultItemBgImageView];
    [_resultItemBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_boardContainer).offset(KDialogAdaptedWidth(142));
        make.centerX.mas_equalTo(_boardContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(185), KDialogAdaptedWidth(185)));
    }];
    
    // 5. 礼物 Icon (78x78pt, 居中于金环圈内 顶距 188pt)
    _giftIconImageView = [[UIImageView alloc] init];
    _giftIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_boardContainer addSubview:_giftIconImageView];
    [_giftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_boardContainer).offset(KDialogAdaptedWidth(188));
        make.centerX.mas_equalTo(_boardContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(78), KDialogAdaptedWidth(78)));
    }];
    
    // 6. 钻石价值 (粉色 #E03875 加粗，顶距 300pt)
    _giftValueLabel = [[UILabel alloc] init];
    _giftValueLabel.textColor = [UIColor colorWithRed:0xE0/255.0 green:0x38/255.0 blue:0x75/255.0 alpha:1.0];
    _giftValueLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(12.5)];
    _giftValueLabel.textAlignment = NSTextAlignmentCenter;
    [_boardContainer addSubview:_giftValueLabel];
    [_giftValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_boardContainer).offset(KDialogAdaptedWidth(300));
        make.centerX.mas_equalTo(_boardContainer);
    }];
    
    // 7. 底部双按钮：【继续重铸】(左) & 【取回礼物】(右) (138x52pt, 底距 65pt)
    _continueActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_continueActionButton setBackgroundImage:[UIImage imageNamed:@"theme_game_six_btn_recast_continue"] forState:UIControlStateNormal];
    _continueActionButton.contentMode = UIViewContentModeScaleToFill;
    [_continueActionButton addTarget:self action:@selector(continueClick) forControlEvents:UIControlEventTouchUpInside];
    [_boardContainer addSubview:_continueActionButton];
    [_continueActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_boardContainer).offset(-KDialogAdaptedWidth(65));
        make.leading.mas_equalTo(_boardContainer).offset(KDialogAdaptedWidth(27));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(138), KDialogAdaptedWidth(52)));
    }];
    
    _withdrawActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_withdrawActionButton setBackgroundImage:[UIImage imageNamed:@"theme_game_six_btn_withdraw"] forState:UIControlStateNormal];
    _withdrawActionButton.contentMode = UIViewContentModeScaleToFill;
    [_withdrawActionButton addTarget:self action:@selector(withdrawClick) forControlEvents:UIControlEventTouchUpInside];
    [_boardContainer addSubview:_withdrawActionButton];
    [_withdrawActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_boardContainer).offset(-KDialogAdaptedWidth(65));
        make.trailing.mas_equalTo(_boardContainer).offset(-KDialogAdaptedWidth(27));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(138), KDialogAdaptedWidth(52)));
    }];
}

- (void)renderData {
    if (!_resultModel) return;
    
    // 1. 层数
    NSInteger layer = _resultModel.to_layer > 0 ? _resultModel.to_layer : 1;
    _layerInfoLabel.text = [NSString stringWithFormat:@"第 %ld 层", (long)layer];
    
    // 2. 礼物名称与图标
    if (_resultModel.gift) {
        _giftNameLabel.text = _resultModel.gift.name ?: @"珍宝塔礼物";
        if (_resultModel.gift.image && _resultModel.gift.image.length > 0) {
            [_giftIconImageView sd_setImageWithURL:[NSURL URLWithString:_resultModel.gift.image] placeholderImage:[UIImage imageNamed:@"theme_game_six_ic_token"]];
        }
        
        // 3. 价值格式化 (无小数点)
        double val = [_resultModel.gift.value doubleValue];
        _giftValueLabel.text = [NSString stringWithFormat:@"💎 %ld", (long)val];
    }
}

// MARK: - Actions

- (void)continueClick {
    [self dismiss];
    if (self.onContinueRecastBlock) {
        self.onContinueRecastBlock();
    }
}

- (void)withdrawClick {
    if (!_resultModel || !_resultModel.gift) {
        [self dismiss];
        return;
    }
    
    long long targetInventoryId = 0;
    if (_resultModel.gift.inventory_id > 0) {
        targetInventoryId = _resultModel.gift.inventory_id;
    } else if (_resultModel.inventory_id > 0) {
        targetInventoryId = _resultModel.inventory_id;
    }
    
    if (targetInventoryId > 0) {
        [self executeWithdrawApiWithInventoryId:targetInventoryId];
    } else {
        // 如果后端开奖接口未返回 inventory_id，自动请求暂存包检索匹配该礼物的 inventory_id 提取
        __weak typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:@"取回中..."];
        [[MLThemeGameModel new] fetchTowerGameSixTempInventoryWithSuccess:^(id _Nullable responseObj) {
            NSArray *tempList = (NSArray *)responseObj;
            long long matchedId = 0;
            if ([tempList isKindOfClass:[NSArray class]] && tempList.count > 0) {
                matchedId = ((MLCandidateItemModel *)tempList.firstObject).inventory_id;
                for (MLCandidateItemModel *item in tempList) {
                    if (item.gift_id == weakSelf.resultModel.gift.gift_id) {
                        matchedId = item.inventory_id;
                        break;
                    }
                }
            }
            if (matchedId > 0) {
                [weakSelf executeWithdrawApiWithInventoryId:matchedId];
            } else {
                [SVProgressHUD showInfoWithStatus:@"暂存包暂无可提取礼物"];
            }
        } failure:^(NSError * _Nullable error, NSString * _Nullable msg) {
            [SVProgressHUD showErrorWithStatus:msg ?: @"获取暂存背包失败"];
        }];
    }
}

- (void)executeWithdrawApiWithInventoryId:(long long)inventoryId {
    NSArray *items = @[@{
        @"inventory_id": @(inventoryId),
        @"num": @(1)
    }];
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"取回中..."];
    [[MLThemeGameModel new] withdrawTowerGameSixTempGiftsWithItems:items success:^(id _Nullable responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"取回成功"];
        [weakSelf dismiss];
        if (weakSelf.onWithdrawSuccessBlock) {
            weakSelf.onWithdrawSuccessBlock();
        }
    } failure:^(NSError * _Nullable error, NSString * _Nullable msg) {
        [SVProgressHUD showErrorWithStatus:msg ?: @"取回失败"];
    }];
}

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
