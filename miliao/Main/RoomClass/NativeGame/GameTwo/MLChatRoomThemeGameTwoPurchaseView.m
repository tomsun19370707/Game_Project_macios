#import "MLChatRoomThemeGameTwoPurchaseView.h"
#import "MLGameLotteryService.h"
#import "Global.h"
#import "CFMWalletDiamondRechargeVc.h"

@interface MLChatRoomThemeGameTwoPurchaseView () <UITextFieldDelegate>

@property (nonatomic, strong) MLGameLotteryInfoModel *infoModel;
@property (nonatomic, copy) void(^purchaseSuccessBlock)(NSInteger);

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UIButton *closeButton;

// 顶部余额指示栏 (钻石/祝灵珠)
@property (nonatomic, strong) UIButton *diamondBarView;
@property (nonatomic, strong) UIImageView *diamondIconView;
@property (nonatomic, strong) UILabel *diamondBalanceLabel;

@property (nonatomic, strong) UIImageView *keyBarView;
@property (nonatomic, strong) UIImageView *keyIconView;
@property (nonatomic, strong) UILabel *keyBalanceLabel;

// 中部商品展示框组
@property (nonatomic, strong) UIImageView *boardLeftView; // 左侧钥匙背板
@property (nonatomic, strong) UIImageView *boardGiftView; // 右侧礼物赠送背板
@property (nonatomic, strong) UILabel *plusIconView;  // 中间加号

// 4档快捷选择按钮组
@property (nonatomic, strong) UIButton *optOneButton;
@property (nonatomic, strong) UIButton *optTenButton;
@property (nonatomic, strong) UIButton *optHundredButton;
@property (nonatomic, strong) UIButton *optOtherButton;
@property (nonatomic, strong) NSArray<UIButton *> *optButtons;

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UILabel *costLabel;

@property (nonatomic, assign) NSInteger selectedCount; // 选择购买的钥匙数量
@property (nonatomic, assign) NSInteger localDiamonds; // 本地钻石余额
@property (nonatomic, assign) NSInteger localKeys; // 本地钥匙余额

@end

@implementation MLChatRoomThemeGameTwoPurchaseView

+ (void)showInView:(UIView *)parentView 
            infoModel:(MLGameLotteryInfoModel *)info 
     purchaseSuccess:(void(^)(NSInteger))success {
    MLChatRoomThemeGameTwoPurchaseView *view = [[MLChatRoomThemeGameTwoPurchaseView alloc] initWithFrame:parentView.bounds infoModel:info purchaseSuccess:success];
    [parentView addSubview:view];
    [view animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame 
                    infoModel:(MLGameLotteryInfoModel *)info 
             purchaseSuccess:(void(^)(NSInteger))success {
    if (self = [super initWithFrame:frame]) {
        self.infoModel = info;
        self.purchaseSuccessBlock = success;
        self.selectedCount = 1; // 默认买1个
        self.optButtons = [NSMutableArray array];
        
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
    
    // 背景外框 (315 * 312 pt)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_two_purchase_bg"];
    if (_bgImageView.image == nil) {
        _bgImageView.image = [UIImage imageNamed:@"theme_game_one_purchase_popup_board"];
    }
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(315), KDialogAdaptedWidth(312)));
    }];
    
    // 标题切图 (theme_game_two_purchase_title.png, 164 * 45 pt, 距顶 12 pt, 水平居中)
    _titleImageView = [[UIImageView alloc] init];
    _titleImageView.image = [UIImage imageNamed:@"theme_game_two_purchase_title"];
    _titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_bgImageView addSubview:_titleImageView];
    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(12));
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(164), KDialogAdaptedWidth(45)));
    }];
    
    // 右上角关闭按钮 (theme_game_two_purchase_back.png, 36 * 36 pt, 距顶 16 pt, 距右 16 pt)
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"theme_game_two_purchase_back"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(16));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(16));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(36), KDialogAdaptedWidth(36)));
    }];
    
    // 资产栏背景切图 (使用 resizableImage 确保拉伸不变形)
    UIImage *barBgImg = [[UIImage imageNamed:@"theme_game_two_purchase_bar_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4) resizingMode:UIImageResizingModeStretch];
    
    // 钻石余额指示栏 (对齐 Android 86 * 24 pt)
    _diamondBarView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_diamondBarView setBackgroundImage:barBgImg forState:UIControlStateNormal];
    [_diamondBarView addTarget:self action:@selector(diamondPlusClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_diamondBarView];
    [_diamondBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleImageView.mas_bottom).offset(KDialogAdaptedWidth(10));
        make.trailing.mas_equalTo(_bgImageView.mas_centerX).offset(-KDialogAdaptedWidth(20));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(86), KDialogAdaptedWidth(24)));
    }];
    
    _diamondIconView = [[UIImageView alloc] init];
    _diamondIconView.image = [UIImage imageNamed:@"theme_game_two_diamond_icon"];
    _diamondIconView.contentMode = UIViewContentModeScaleAspectFit;
    [_diamondBarView addSubview:_diamondIconView];
    [_diamondIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(4));
        make.centerY.mas_equalTo(_diamondBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(22), KDialogAdaptedWidth(22)));
    }];
    
    UIImageView *diamondPlus = [[UIImageView alloc] init];
    diamondPlus.image = [UIImage imageNamed:@"theme_game_two_plus_icon"];
    diamondPlus.contentMode = UIViewContentModeScaleAspectFit;
    [_diamondBarView addSubview:diamondPlus];
    [diamondPlus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(4));
        make.centerY.mas_equalTo(_diamondBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(18), KDialogAdaptedWidth(18)));
    }];
    
    _diamondBalanceLabel = [[UILabel alloc] init];
    _diamondBalanceLabel.textColor = kWhiteColor;
    _diamondBalanceLabel.font = [UIFont boldSystemFontOfSize:11];
    _diamondBalanceLabel.textAlignment = NSTextAlignmentCenter;
    _diamondBalanceLabel.adjustsFontSizeToFitWidth = YES;
    _diamondBalanceLabel.minimumScaleFactor = 0.5;
    _diamondBalanceLabel.text = @"0";
    [_diamondBarView addSubview:_diamondBalanceLabel];
    [_diamondBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_diamondIconView.mas_trailing).offset(2);
        make.trailing.mas_equalTo(diamondPlus.mas_leading).offset(-2);
        make.centerY.mas_equalTo(_diamondBarView);
    }];
    
    // 钥匙/祝灵珠余额指示栏 (对齐 Android 86 * 24 pt)
    _keyBarView = [[UIImageView alloc] init];
    _keyBarView.image = barBgImg;
    _keyBarView.contentMode = UIViewContentModeScaleToFill;
    [_bgImageView addSubview:_keyBarView];
    [_keyBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleImageView.mas_bottom).offset(KDialogAdaptedWidth(10));
        make.leading.mas_equalTo(_bgImageView.mas_centerX).offset(KDialogAdaptedWidth(20));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(86), KDialogAdaptedWidth(24)));
    }];
    
    _keyIconView = [[UIImageView alloc] init];
    _keyIconView.image = [UIImage imageNamed:@"theme_game_one_purchase_key_icon"];
    _keyIconView.contentMode = UIViewContentModeScaleAspectFit;
    [_keyBarView addSubview:_keyIconView];
    [_keyIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(4));
        make.centerY.mas_equalTo(_keyBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(22), KDialogAdaptedWidth(22)));
    }];
    
    _keyBalanceLabel = [[UILabel alloc] init];
    _keyBalanceLabel.textColor = kWhiteColor;
    _keyBalanceLabel.font = [UIFont boldSystemFontOfSize:11];
    _keyBalanceLabel.textAlignment = NSTextAlignmentCenter;
    _keyBalanceLabel.adjustsFontSizeToFitWidth = YES;
    _keyBalanceLabel.minimumScaleFactor = 0.5;
    _keyBalanceLabel.text = @"0";
    [_keyBarView addSubview:_keyBalanceLabel];
    [_keyBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_keyIconView.mas_trailing).offset(2);
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(4));
        make.centerY.mas_equalTo(_keyBarView);
    }];
    
    // 中部商品展示框组 (对齐 Android 相邻间距与位置)
    // 左侧钥匙展示背板: theme_game_two_purchase_frame_left.png (宽 97, 高 100 pt)
    _boardLeftView = [[UIImageView alloc] init];
    _boardLeftView.image = [UIImage imageNamed:@"theme_game_two_purchase_frame_left"];
    _boardLeftView.contentMode = UIViewContentModeScaleToFill;
    [_bgImageView addSubview:_boardLeftView];
    [_boardLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_diamondBarView.mas_bottom).offset(KDialogAdaptedWidth(16));
        make.trailing.mas_equalTo(_bgImageView.mas_centerX).offset(-KDialogAdaptedWidth(24));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(97), KDialogAdaptedWidth(100)));
    }];
    
    // 右侧礼物赠送背板: theme_game_two_purchase_frame_right.png (宽 97, 高 100 pt)
    _boardGiftView = [[UIImageView alloc] init];
    _boardGiftView.image = [UIImage imageNamed:@"theme_game_two_purchase_frame_right"];
    _boardGiftView.contentMode = UIViewContentModeScaleToFill;
    [_bgImageView addSubview:_boardGiftView];
    [_boardGiftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_diamondBarView.mas_bottom).offset(KDialogAdaptedWidth(16));
        make.leading.mas_equalTo(_bgImageView.mas_centerX).offset(KDialogAdaptedWidth(24));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(97), KDialogAdaptedWidth(100)));
    }];
    
    // 中间加号 (使用 UILabel 对齐 Android，字体颜色为棕褐色 #B2834E)
    _plusIconView = [[UILabel alloc] init];
    _plusIconView.text = @"+";
    _plusIconView.textColor = mHexRGB(0xB2834E);
    _plusIconView.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(36)];
    _plusIconView.textAlignment = NSTextAlignmentCenter;
    [_bgImageView addSubview:_plusIconView];
    [_plusIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_boardLeftView);
        make.centerX.mas_equalTo(_bgImageView);
    }];
    
    // 4档快捷选择按钮组 (1 / 10 / 100 / 其它)
    // 单按钮宽 60 pt，高 24 pt，水平间距 8 pt. 距顶 221 pt
    _optOneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optOneButton setImage:[UIImage imageNamed:@"theme_game_two_purchase_one"] forState:UIControlStateNormal];
    _optOneButton.alpha = 1.0f;
    [_optOneButton addTarget:self action:@selector(optClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_optOneButton];
    
    _optTenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optTenButton setImage:[UIImage imageNamed:@"theme_game_two_purchase_ten"] forState:UIControlStateNormal];
    _optTenButton.alpha = 0.55f;
    [_optTenButton addTarget:self action:@selector(optClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_optTenButton];
    
    _optHundredButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optHundredButton setImage:[UIImage imageNamed:@"theme_game_two_purchase_hundred"] forState:UIControlStateNormal];
    _optHundredButton.alpha = 0.55f;
    [_optHundredButton addTarget:self action:@selector(optClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_optHundredButton];
    
    _optOtherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optOtherButton setImage:[UIImage imageNamed:@"theme_game_two_purchase_other"] forState:UIControlStateNormal];
    _optOtherButton.alpha = 0.55f;
    [_optOtherButton addTarget:self action:@selector(optClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_optOtherButton];
    
    _optButtons = @[_optOneButton, _optTenButton, _optHundredButton, _optOtherButton];
    
    CGFloat btnW = KDialogAdaptedWidth(60.0f);
    CGFloat btnH = KDialogAdaptedWidth(24.0f);
    CGFloat gap = KDialogAdaptedWidth(8.0f);
    
    [_optTenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(221));
        make.trailing.mas_equalTo(_bgImageView.mas_centerX).offset(-gap/2.0);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    [_optOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(221));
        make.trailing.mas_equalTo(_optTenButton.mas_leading).offset(-gap);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    [_optHundredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(221));
        make.leading.mas_equalTo(_bgImageView.mas_centerX).offset(gap/2.0);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    [_optOtherButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(221));
        make.leading.mas_equalTo(_optHundredButton.mas_trailing).offset(gap);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    // 消耗钻石提示 Label
    _costLabel = [[UILabel alloc] init];
    _costLabel.textColor = mHexRGB(0xFFE400);
    _costLabel.font = [UIFont boldSystemFontOfSize:12];
    _costLabel.text = @"消耗 10 钻石";
    [_bgImageView addSubview:_costLabel];
    
    // 确认购买按钮 (theme_game_two_purchase_confirm.png, 宽 208, 高 40. 距底端 16 pt)
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setImage:[UIImage imageNamed:@"theme_game_two_purchase_confirm"] forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmPurchaseClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_confirmButton];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(16));
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(208), KDialogAdaptedWidth(40)));
    }];
    
    [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_confirmButton.mas_top).offset(-KDialogAdaptedWidth(6));
        make.centerX.mas_equalTo(_bgImageView);
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
    _diamondBalanceLabel.text = [NSString stringWithFormat:@"%ld", (long)self.localDiamonds];
    _keyBalanceLabel.text = [NSString stringWithFormat:@"%ld", (long)self.localKeys];
    [self updateCostUI];
}

- (void)updateCostUI {
    NSInteger costCount = self.selectedCount;
    _costLabel.text = [NSString stringWithFormat:@"消耗 %ld 钻石", (long)(costCount * 10)];
}

#pragma mark - 档位点击
- (void)optClick:(UIButton *)sender {
    for (UIButton *btn in _optButtons) {
        btn.selected = (btn == sender);
        btn.alpha = (btn == sender) ? 1.0f : 0.55f;
    }
    
    if (sender == _optOneButton) {
        self.selectedCount = 1;
        [self updateCostUI];
    } else if (sender == _optTenButton) {
        self.selectedCount = 10;
        [self updateCostUI];
    } else if (sender == _optHundredButton) {
        self.selectedCount = 100;
        [self updateCostUI];
    } else if (sender == _optOtherButton) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"自定义购买数量" message:@"请输入购买数量" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"输入要购买的钥匙数量";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        WeakSelf
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(wself) strongSelf = wself;
            if (!strongSelf) return;
            UITextField *textField = alert.textFields.firstObject;
            NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSInteger count = [text integerValue];
            if (count <= 0) {
                [SVProgressHUD showErrorWithStatus:@"购买数量必须大于0"];
                return;
            }
            if (count > 9999) {
                [SVProgressHUD showErrorWithStatus:@"单次购买不能超过 9999 个"];
                return;
            }
            strongSelf.selectedCount = count;
            [strongSelf updateCostUI];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:confirm];
        [alert addAction:cancel];
        
        [[UIViewController currentViewController] presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - 执行购买
- (void)confirmPurchaseClick {
    NSInteger buyCount = self.selectedCount;
    if (buyCount <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择购买数量"];
        return;
    }
    if (buyCount > 9999) {
        [SVProgressHUD showErrorWithStatus:@"单次购买不能超过 9999 个"];
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
- (void)diamondPlusClick {
    UIViewController *curVC = [UIViewController currentViewController];
    if (curVC) {
        CFMWalletDiamondRechargeVc *re = [[CFMWalletDiamondRechargeVc alloc] init];
        WeakSelf
        
        // 隐藏当前购买弹窗
        self.hidden = YES;
        
        // 查找并隐藏游戏大底面板 (MLChatRoomThemeGameTwoView)
        __block UIView *gameMainView = nil;
        for (UIView *view in self.superview.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"MLChatRoomThemeGameTwoView")]) {
                gameMainView = view;
                gameMainView.hidden = YES;
                break;
            }
        }
        
        re.dismissBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(wself) strongSelf = wself;
                if (strongSelf) {
                    // 恢复显示弹窗和主面板
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
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
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
