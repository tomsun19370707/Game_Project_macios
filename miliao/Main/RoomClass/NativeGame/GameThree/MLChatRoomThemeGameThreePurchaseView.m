#import "MLChatRoomThemeGameThreePurchaseView.h"
#import "MLGameLotteryService.h"
#import "CFMWalletDiamondRechargeVc.h"
#import "Global.h"

@interface MLChatRoomThemeGameThreePurchaseView ()

@property (nonatomic, copy) void(^purchaseSuccessBlock)(NSInteger);

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *closeButton;

// 顶部余额指示栏 (钻石/祝灵珠)
@property (nonatomic, strong) UIImageView *diamondBarView;
@property (nonatomic, strong) UIImageView *diamondIconView;
@property (nonatomic, strong) UILabel *diamondBalanceLabel;

@property (nonatomic, strong) UIImageView *keyBarView;
@property (nonatomic, strong) UIImageView *keyIconView;
@property (nonatomic, strong) UILabel *keyBalanceLabel;

// 中部商品展示框组
@property (nonatomic, strong) UIImageView *boardLeftView; // 左侧钥匙背板
@property (nonatomic, strong) UIImageView *boardGiftView; // 右侧礼物赠送背板
@property (nonatomic, strong) UIImageView *plusIconView;  // 中间加号

// 4档快捷选择按钮组
@property (nonatomic, strong) UIButton *optOneButton;
@property (nonatomic, strong) UIButton *optTenButton;
@property (nonatomic, strong) UIButton *optHundredButton;
@property (nonatomic, strong) UIButton *optOtherButton;
@property (nonatomic, strong) NSArray<UIButton *> *optButtons;

@property (nonatomic, strong) UILabel *selectedCountLabel; // 选定数量指示 Label

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, assign) NSInteger selectedCount; // 选择购买的钥匙数量
@property (nonatomic, assign) NSInteger localDiamonds; // 本地钻石余额
@property (nonatomic, assign) NSInteger localKeys; // 本地钥匙余额

@end

@implementation MLChatRoomThemeGameThreePurchaseView

+ (void)showInView:(UIView *)parentView 
            infoModel:(MLGameLotteryInfoModel *)info 
     purchaseSuccess:(void(^)(NSInteger))success {
    MLChatRoomThemeGameThreePurchaseView *view = [[MLChatRoomThemeGameThreePurchaseView alloc] initWithFrame:parentView.bounds infoModel:info purchaseSuccess:success];
    [parentView addSubview:view];
    [view animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame 
                    infoModel:(MLGameLotteryInfoModel *)info 
             purchaseSuccess:(void(^)(NSInteger))success {
    if (self = [super initWithFrame:frame]) {
        self.purchaseSuccessBlock = success;
        self.selectedCount = 1; // 默认买1个
        
        [self setupUI];
        [self loadUserMoney];
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
    
    // Background Container (width: 372pt, height: based on 1047/740 aspect ratio)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_three_purchase_bg"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(KDialogAdaptedWidth(372));
        make.height.mas_equalTo(_bgImageView.mas_width).multipliedBy(1047.0 / 740.0);
    }];
    
    // HUDContainer (top bar and close button)
    UIView *hudContainer = [[UIView alloc] init];
    [_bgImageView addSubview:hudContainer];
    [hudContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(KDialogAdaptedWidth(150));
    }];
    
    // Close button
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"theme_game_three_purchase_back"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [hudContainer addSubview:_closeButton];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(59));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(23));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(42), KDialogAdaptedWidth(42)));
    }];
    
    // Balances Container
    UIView *balancesContainer = [[UIView alloc] init];
    [hudContainer addSubview:balancesContainer];
    [balancesContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(110));
        make.centerX.mas_equalTo(hudContainer);
        make.width.mas_equalTo(KDialogAdaptedWidth(270)); // 120 + 30 + 120
        make.height.mas_equalTo(KDialogAdaptedWidth(30));
    }];
    
    // Diamond Bar View
    _diamondBarView = [[UIImageView alloc] init];
    _diamondBarView.image = [UIImage imageNamed:@"theme_game_three_purchase_num_bg"];
    _diamondBarView.contentMode = UIViewContentModeScaleToFill;
    _diamondBarView.userInteractionEnabled = YES;
    [balancesContainer addSubview:_diamondBarView];
    [_diamondBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(KDialogAdaptedWidth(120));
    }];
    
    // Add tap gesture to diamond bar for recharge
    UITapGestureRecognizer *rechargeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rechargeClick)];
    [_diamondBarView addGestureRecognizer:rechargeTap];
    
    _diamondIconView = [[UIImageView alloc] init];
    _diamondIconView.image = [UIImage imageNamed:@"theme_game_three_purchase_diamond_icon"];
    _diamondIconView.contentMode = UIViewContentModeScaleAspectFit;
    [_diamondBarView addSubview:_diamondIconView];
    [_diamondIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(6));
        make.centerY.mas_equalTo(_diamondBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(28), KDialogAdaptedWidth(28)));
    }];
    
    // Plus icon in diamond bar to match Android
    UIImageView *diamondPlusIcon = [[UIImageView alloc] init];
    diamondPlusIcon.image = [UIImage imageNamed:@"theme_game_three_ic_plus"];
    if (diamondPlusIcon.image == nil) {
        diamondPlusIcon.image = [UIImage imageNamed:@"theme_game_three_purchase_plus"];
    }
    diamondPlusIcon.contentMode = UIViewContentModeScaleAspectFit;
    [_diamondBarView addSubview:diamondPlusIcon];
    [diamondPlusIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(6));
        make.centerY.mas_equalTo(_diamondBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(22), KDialogAdaptedWidth(22)));
    }];
    
    _diamondBalanceLabel = [[UILabel alloc] init];
    _diamondBalanceLabel.textColor = kWhiteColor;
    _diamondBalanceLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(13)];
    _diamondBalanceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _diamondBalanceLabel.text = @"0";
    [_diamondBarView addSubview:_diamondBalanceLabel];
    [_diamondBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_diamondIconView.mas_trailing).offset(KDialogAdaptedWidth(2));
        make.trailing.mas_equalTo(diamondPlusIcon.mas_leading).offset(-KDialogAdaptedWidth(2));
        make.centerY.mas_equalTo(_diamondBarView);
    }];
    
    // Key Bar View
    _keyBarView = [[UIImageView alloc] init];
    _keyBarView.image = [UIImage imageNamed:@"theme_game_three_purchase_num_bg"];
    _keyBarView.contentMode = UIViewContentModeScaleToFill;
    [balancesContainer addSubview:_keyBarView];
    [_keyBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(KDialogAdaptedWidth(120));
    }];
    
    _keyIconView = [[UIImageView alloc] init];
    _keyIconView.image = [UIImage imageNamed:@"theme_game_three_purchase_key_icon"];
    _keyIconView.contentMode = UIViewContentModeScaleAspectFit;
    [_keyBarView addSubview:_keyIconView];
    [_keyIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(6));
        make.centerY.mas_equalTo(_keyBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(28), KDialogAdaptedWidth(28)));
    }];
    
    _keyBalanceLabel = [[UILabel alloc] init];
    _keyBalanceLabel.textColor = kWhiteColor;
    _keyBalanceLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(13)];
    _keyBalanceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _keyBalanceLabel.text = @"0";
    [_keyBarView addSubview:_keyBalanceLabel];
    [_keyBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_keyIconView.mas_trailing).offset(KDialogAdaptedWidth(2));
        make.trailing.mas_equalTo(_keyBarView.mas_trailing).offset(-KDialogAdaptedWidth(8));
        make.centerY.mas_equalTo(_keyBarView);
    }];
    
    // GameplayContainer (middle gifts display)
    UIView *gameplayContainer = [[UIView alloc] init];
    [_bgImageView addSubview:gameplayContainer];
    [gameplayContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hudContainer.mas_bottom).offset(KDialogAdaptedWidth(36));
        make.centerX.mas_equalTo(_bgImageView);
        make.width.mas_equalTo(KDialogAdaptedWidth(296)); // 120 + 56 + 120 = 296
        make.height.mas_equalTo(KDialogAdaptedWidth(120));
    }];
    
    _boardLeftView = [[UIImageView alloc] init];
    _boardLeftView.image = [UIImage imageNamed:@"theme_game_three_purchase_frame_left"];
    _boardLeftView.contentMode = UIViewContentModeScaleToFill;
    [gameplayContainer addSubview:_boardLeftView];
    [_boardLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(KDialogAdaptedWidth(120));
    }];
    
    _boardGiftView = [[UIImageView alloc] init];
    _boardGiftView.image = [UIImage imageNamed:@"theme_game_three_purchase_frame_right"];
    _boardGiftView.contentMode = UIViewContentModeScaleToFill;
    [gameplayContainer addSubview:_boardGiftView];
    [_boardGiftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(KDialogAdaptedWidth(120));
    }];
    
    _plusIconView = [[UIImageView alloc] init];
    _plusIconView.image = [UIImage imageNamed:@"theme_game_three_purchase_plus"];
    _plusIconView.contentMode = UIViewContentModeScaleAspectFit;
    [gameplayContainer addSubview:_plusIconView];
    [_plusIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(gameplayContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(20), KDialogAdaptedWidth(20)));
    }];
    
    // ActionContainer (bottom buttons, confirm and input count)
    UIView *actionContainer = [[UIView alloc] init];
    [_bgImageView addSubview:actionContainer];
    [actionContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(gameplayContainer.mas_bottom).offset(KDialogAdaptedWidth(24));
        make.leading.trailing.bottom.mas_equalTo(0);
    }];
    
    // 4 option buttons
    _optOneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optOneButton setBackgroundImage:[UIImage imageNamed:@"theme_game_three_purchase_one_normal"] forState:UIControlStateNormal];
    [_optOneButton setBackgroundImage:[UIImage imageNamed:@"theme_game_three_purchase_one"] forState:UIControlStateSelected];
    _optOneButton.selected = YES;
    _optOneButton.alpha = 1.0f;
    [_optOneButton addTarget:self action:@selector(optClick:) forControlEvents:UIControlEventTouchUpInside];
    [actionContainer addSubview:_optOneButton];
    
    _optTenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optTenButton setBackgroundImage:[UIImage imageNamed:@"theme_game_three_purchase_ten_normal"] forState:UIControlStateNormal];
    [_optTenButton setBackgroundImage:[UIImage imageNamed:@"theme_game_three_purchase_ten"] forState:UIControlStateSelected];
    _optTenButton.alpha = 0.55f;
    [_optTenButton addTarget:self action:@selector(optClick:) forControlEvents:UIControlEventTouchUpInside];
    [actionContainer addSubview:_optTenButton];
    
    _optHundredButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optHundredButton setBackgroundImage:[UIImage imageNamed:@"theme_game_three_purchase_hundred_normal"] forState:UIControlStateNormal];
    [_optHundredButton setBackgroundImage:[UIImage imageNamed:@"theme_game_three_purchase_hundred"] forState:UIControlStateSelected];
    _optHundredButton.alpha = 0.55f;
    [_optHundredButton addTarget:self action:@selector(optClick:) forControlEvents:UIControlEventTouchUpInside];
    [actionContainer addSubview:_optHundredButton];
    
    _optOtherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optOtherButton setBackgroundImage:[UIImage imageNamed:@"theme_game_three_purchase_other_normal"] forState:UIControlStateNormal];
    [_optOtherButton setBackgroundImage:[UIImage imageNamed:@"theme_game_three_purchase_other"] forState:UIControlStateSelected];
    _optOtherButton.alpha = 0.55f;
    [_optOtherButton addTarget:self action:@selector(optClick:) forControlEvents:UIControlEventTouchUpInside];
    [actionContainer addSubview:_optOtherButton];
    
    _optButtons = @[_optOneButton, _optTenButton, _optHundredButton, _optOtherButton];
    
    CGFloat btnW = KDialogAdaptedWidth(76);
    CGFloat btnH = KDialogAdaptedWidth(47);
    CGFloat optGap = KDialogAdaptedWidth(6);
    
    [_optTenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.trailing.mas_equalTo(actionContainer.mas_centerX).offset(-optGap/2.0);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    [_optOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.trailing.mas_equalTo(_optTenButton.mas_leading).offset(-optGap);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    [_optHundredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(actionContainer.mas_centerX).offset(optGap/2.0);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    [_optOtherButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(_optHundredButton.mas_trailing).offset(optGap);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    // Selection box container (width: 120pt, height: 32pt)
    UIImageView *numBoxView = [[UIImageView alloc] init];
    numBoxView.image = [UIImage imageNamed:@"theme_game_three_purchase_num_bg"];
    numBoxView.contentMode = UIViewContentModeScaleToFill;
    numBoxView.userInteractionEnabled = YES;
    [actionContainer addSubview:numBoxView];
    [numBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_optOneButton.mas_bottom).offset(KDialogAdaptedWidth(8));
        make.centerX.mas_equalTo(actionContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(120), KDialogAdaptedWidth(32)));
    }];
    
    // Text Label showing selection
    _selectedCountLabel = [[UILabel alloc] init];
    _selectedCountLabel.textColor = mHexRGB(0xFFDB83);
    _selectedCountLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(12)];
    _selectedCountLabel.text = @"已选择: 1 个";
    [numBoxView addSubview:_selectedCountLabel];
    [_selectedCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(numBoxView);
    }];
    
    // Confirm Purchase Button
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setImage:[UIImage imageNamed:@"theme_game_three_purchase_confirm"] forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmPurchaseClick) forControlEvents:UIControlEventTouchUpInside];
    [actionContainer addSubview:_confirmButton];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(actionContainer.mas_bottom).offset(-KDialogAdaptedWidth(18));
        make.centerX.mas_equalTo(actionContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(260), KDialogAdaptedWidth(86)));
    }];
}

#pragma mark - 数据拉取
- (void)loadUserMoney {
    WeakSelf
    [MLGameLotteryService getUserMoneyWithSuccess:^(MLGameUserMoneyModel *model) {
        wself.localDiamonds = [model.diamond doubleValue];
        wself.localKeys = model.lottery_coin;
        [wself updateBalanceUI];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)updateBalanceUI {
    _diamondBalanceLabel.text = MLFormatLargeNumber((double)self.localDiamonds);
    _keyBalanceLabel.text = MLFormatLargeNumber((double)self.localKeys);
}

#pragma mark - 档位点击
- (void)optClick:(UIButton *)sender {
    for (UIButton *btn in _optButtons) {
        btn.selected = (btn == sender);
        btn.alpha = (btn == sender) ? 1.0f : 0.55f;
    }
    
    if (sender == _optOneButton) {
        self.selectedCount = 1;
        self.selectedCountLabel.text = @"已选择: 1 个";
    } else if (sender == _optTenButton) {
        self.selectedCount = 10;
        self.selectedCountLabel.text = @"已选择: 10 个";
    } else if (sender == _optHundredButton) {
        self.selectedCount = 100;
        self.selectedCountLabel.text = @"已选择: 100 个";
    } else if (sender == _optOtherButton) {
        [self showCustomInputAlert];
    }
}

#pragma mark - 自定义输入 Alert
- (void)showCustomInputAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"自定义购买数量"
                                                                   message:@"请输入购买数量"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入要购买的钥匙数量";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        if (self.selectedCount > 0 && self.selectedCount != 1 && self.selectedCount != 10 && self.selectedCount != 100) {
            textField.text = [NSString stringWithFormat:@"%ld", (long)self.selectedCount];
        }
    }];
    
    WeakSelf
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (wself.selectedCount != 1 && wself.selectedCount != 10 && wself.selectedCount != 100) {
            [wself optClick:wself.optOneButton];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields.firstObject;
        NSString *inputStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSInteger count = [inputStr integerValue];
        if (count <= 0) {
            [SVProgressHUD showErrorWithStatus:@"购买数量必须大于0"];
            [wself optClick:wself.optOneButton];
            return;
        }
        if (count > 9999) {
            [SVProgressHUD showErrorWithStatus:@"单次购买不能超过 9999 个"];
            [wself optClick:wself.optOneButton];
            return;
        }
        wself.selectedCount = count;
        wself.selectedCountLabel.text = [NSString stringWithFormat:@"已选择: %ld 个", (long)count];
    }]];
    
    UIViewController *curVC = [UIViewController currentViewController];
    if (curVC) {
        [curVC presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - 执行购买
- (void)confirmPurchaseClick {
    NSInteger buyCount = self.selectedCount;
    if (buyCount <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择购买数量"];
        return;
    }
    
    NSInteger costDiamonds = buyCount * 10;
    if (self.localDiamonds < costDiamonds) {
        [SVProgressHUD showErrorWithStatus:@"钻石余额不足，请前往充值"];
        return;
    }
    
    _confirmButton.enabled = NO;
    WeakSelf
    [MLGameLotteryService diamondChangeLotteryCoinWithDiamondCount:costDiamonds success:^(id responseObject) {
        wself.confirmButton.enabled = YES;
        
        // 成功购买后禁止自动关闭弹窗，在本地扣除并刷新
        wself.localDiamonds -= costDiamonds;
        wself.localKeys += buyCount;
        [wself updateBalanceUI];
        
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"成功兑换 %ld 把钥匙", (long)buyCount]];
        
        if (wself.purchaseSuccessBlock) {
            wself.purchaseSuccessBlock(wself.localKeys);
        }
    } failure:^(NSError *error) {
        wself.confirmButton.enabled = YES;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - 充值路由
- (void)rechargeClick {
    UIViewController *curVC = [UIViewController currentViewController];
    if (curVC) {
        CFMWalletDiamondRechargeVc *re = [[CFMWalletDiamondRechargeVc alloc] init];
        WeakSelf
        
        // 隐藏当前购买弹窗
        self.hidden = YES;
        
        // 查找并隐藏游戏大底面板 (MLChatRoomThemeGameThreeView)
        __block UIView *gameMainView = nil;
        for (UIView *view in self.superview.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"MLChatRoomThemeGameThreeView")]) {
                gameMainView = view;
                gameMainView.hidden = YES;
                break;
            }
        }
        
        re.dismissBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(wself) strongSelf = wself;
                if (strongSelf) {
                    // 恢复显示弹窗 and 主面板
                    strongSelf.hidden = NO;
                    if (gameMainView) {
                        gameMainView.hidden = NO;
                        // 重新刷新主面板余额数据
                        SEL loadDataSel = NSSelectorFromString(@"loadData");
                        if ([gameMainView respondsToSelector:loadDataSel]) {
                            IMP imp = [gameMainView methodForSelector:loadDataSel];
                            void (*func)(id, SEL) = (void *)imp;
                            func(gameMainView, loadDataSel);
                        }
                    }
                    // 弹窗重新加载最新余额
                    [strongSelf loadUserMoney];
                }
            });
        };
        
        if (curVC.navigationController) {
            [curVC.navigationController pushViewController:re animated:YES];
        } else {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:re];
            [curVC presentViewController:nav animated:YES completion:nil];
        }
    }
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
