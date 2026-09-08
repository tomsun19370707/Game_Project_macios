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

+ (MLTowerGameSixRecastResultModel *)createFromCurrentReward:(MLTowerGameSixCurrentRewardModel *)reward
                                                   canRecast:(NSInteger)canRecast
                                                    canClaim:(NSInteger)canClaim
                                                stateVersion:(NSInteger)stateVersion {
    if (!reward) return nil;
    MLTowerGameSixRecastResultModel *model = [[MLTowerGameSixRecastResultModel alloc] init];
    model.ticket_id = reward.ticket_id;
    model.draw_id = reward.draw_id;
    model.can_recast = canRecast;
    model.can_claim = canClaim;
    model.state_version = stateVersion;
    model.position = reward.position;
    model.to_layer = reward.to_layer;
    model.current_reward = reward;
    
    MLCandidateItemModel *gift = [[MLCandidateItemModel alloc] init];
    gift.gift_id = reward.gift_id;
    gift.name = reward.name;
    gift.image = reward.image;
    gift.value = reward.value;
    gift.position = reward.position;
    model.gift = gift;
    return model;
}

+ (instancetype)showInView:(UIView *)parentView
             currentReward:(MLTowerGameSixCurrentRewardModel *)reward
                 canRecast:(NSInteger)canRecast
                  canClaim:(NSInteger)canClaim
              stateVersion:(NSInteger)stateVersion {
    MLTowerGameSixRecastResultModel *model = [self createFromCurrentReward:reward canRecast:canRecast canClaim:canClaim stateVersion:stateVersion];
    return [self showInView:parentView resultModel:model];
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
    
    // 7. 底部双按钮 (方案 A: 严格左右固定布局)：【获取礼物】(左) & 【继续重铸】(右) (138x52pt, 底距 65pt)
    _withdrawActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_withdrawActionButton setBackgroundImage:[UIImage imageNamed:@"theme_game_six_btn_withdraw"] forState:UIControlStateNormal];
    _withdrawActionButton.contentMode = UIViewContentModeScaleToFill;
    [_withdrawActionButton addTarget:self action:@selector(withdrawClick) forControlEvents:UIControlEventTouchUpInside];
    [_boardContainer addSubview:_withdrawActionButton];
    [_withdrawActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_boardContainer).offset(-KDialogAdaptedWidth(65));
        make.leading.mas_equalTo(_boardContainer).offset(KDialogAdaptedWidth(27));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(138), KDialogAdaptedWidth(52)));
    }];
    
    _continueActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_continueActionButton setBackgroundImage:[UIImage imageNamed:@"theme_game_six_btn_recast_continue"] forState:UIControlStateNormal];
    _continueActionButton.contentMode = UIViewContentModeScaleToFill;
    [_continueActionButton addTarget:self action:@selector(continueClick) forControlEvents:UIControlEventTouchUpInside];
    [_boardContainer addSubview:_continueActionButton];
    [_continueActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_boardContainer).offset(-KDialogAdaptedWidth(65));
        make.trailing.mas_equalTo(_boardContainer).offset(-KDialogAdaptedWidth(27));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(138), KDialogAdaptedWidth(52)));
    }];
}

- (void)renderData {
    if (!_resultModel) return;
    
    // 1. 层数
    NSInteger layer = _resultModel.to_layer > 0 ? _resultModel.to_layer : (_resultModel.current_reward && _resultModel.current_reward.to_layer > 0 ? _resultModel.current_reward.to_layer : 1);
    _layerInfoLabel.text = [NSString stringWithFormat:@"第 %ld 层", (long)layer];
    
    // 2. 礼物名称
    if (_resultModel.gift && _resultModel.gift.name.length > 0) {
        _giftNameLabel.text = _resultModel.gift.name;
    } else if (_resultModel.current_reward && _resultModel.current_reward.name.length > 0) {
        _giftNameLabel.text = _resultModel.current_reward.name;
    } else {
        _giftNameLabel.text = @"珍宝塔礼物";
    }
    
    // 3. 礼物图标
    NSString *iconUrl = (_resultModel.gift && _resultModel.gift.image.length > 0) ? _resultModel.gift.image : (_resultModel.current_reward ? _resultModel.current_reward.image : nil);
    if (iconUrl.length > 0) {
        [_giftIconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"theme_game_six_ic_token"]];
    } else {
        _giftIconImageView.image = [UIImage imageNamed:@"theme_game_six_ic_token"];
    }
    
    // 4. 钻石价值 (无小数点)
    NSString *rawVal = (_resultModel.gift && _resultModel.gift.value.length > 0) ? _resultModel.gift.value : (_resultModel.current_reward ? _resultModel.current_reward.value : nil);
    double val = [rawVal doubleValue];
    _giftValueLabel.text = [NSString stringWithFormat:@"💎 %ld", (long)val];
    
    // 5. 驱动按钮状态 (方案 A: 严格保持原位坐标不变，不可重铸时原地置灰并禁用)
    BOOL canRecast = (_resultModel.can_recast == 1);
    BOOL canClaim = (_resultModel.can_claim == 1 || _resultModel.current_reward != nil);
    _continueActionButton.alpha = canRecast ? 1.0f : 0.4f;
    _withdrawActionButton.alpha = canClaim ? 1.0f : 0.4f;
}

// MARK: - Actions

- (void)continueClick {
    if (_resultModel && _resultModel.can_recast == 0) {
        [SVProgressHUD showInfoWithStatus:@"当前不可继续重铸，请获取礼物"];
        return;
    }
    [self dismiss];
    if (self.onContinueRecastBlock) {
        self.onContinueRecastBlock();
    }
}

- (void)withdrawClick {
    [self dismiss];
    NSInteger ticketId = _resultModel ? _resultModel.ticket_id : 0;
    long long drawId = _resultModel ? _resultModel.draw_id : 0;
    NSInteger stateVersion = _resultModel ? _resultModel.state_version : 0;
    if (_resultModel && _resultModel.current_reward) {
        if (_resultModel.current_reward.ticket_id > 0) ticketId = _resultModel.current_reward.ticket_id;
        if (_resultModel.current_reward.draw_id > 0) drawId = _resultModel.current_reward.draw_id;
    }
    
    if (self.onClaimRewardBlock) {
        self.onClaimRewardBlock(ticketId, drawId, stateVersion);
    } else if (self.onWithdrawSuccessBlock) {
        self.onWithdrawSuccessBlock();
    }
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
