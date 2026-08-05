#import "MLChatRoomThemeGameOnePurchaseView.h"
#import "MLGameLotteryService.h"
#import "CFMWalletDiamondRechargeVc.h"
#import "UIViewController+CurViewController.h"
#import "Global.h"

#define KDialogAdaptedWidth(x) (isPadA ? ceilf((x) * (390.0 / 375.0)) : KAdaptedWidth(x))

@interface MLChatRoomThemeGameOnePurchaseView ()

@property (nonatomic, strong) MLGameLotteryInfoModel *infoModel;
@property (nonatomic, copy) void(^purchaseSuccessBlock)(NSInteger);

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *closeButton;

// 顶部余额指示栏 (钻石/钥匙)
@property (nonatomic, strong) UIButton *diamondBarView;
@property (nonatomic, strong) UIImageView *diamondIconView;
@property (nonatomic, strong) UILabel *diamondBalanceLabel;
@property (nonatomic, strong) UIButton *diamondPlusButton; // 新增充值加号按钮

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

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UILabel *costLabel;

@property (nonatomic, assign) NSInteger selectedCount; // 选择购买的钥匙数量
@property (nonatomic, assign) NSInteger localDiamonds; // 本地钻石余额
@property (nonatomic, assign) NSInteger localKeys; // 本地钥匙余额

@end

@implementation MLChatRoomThemeGameOnePurchaseView

+ (void)showInView:(UIView *)parentView 
            infoModel:(MLGameLotteryInfoModel *)info 
     purchaseSuccess:(void(^)(NSInteger))success {
    MLChatRoomThemeGameOnePurchaseView *view = [[MLChatRoomThemeGameOnePurchaseView alloc] initWithFrame:parentView.bounds infoModel:info purchaseSuccess:success];
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
    
    // 背景外框 (315 * 360 pt，应用 KDialogAdaptedWidth 进行自适应)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_one_purchase_popup_board"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(315), KDialogAdaptedWidth(360)));
    }];
    
    // 右上角关闭按钮 (theme_game_one_purchase_back.png, 36 * 36 pt, 距顶 16 pt, 距右 16 pt)
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"theme_game_one_purchase_back"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(12)); // 调整边距以居中 44x44 的热区
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(12));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(44), KDialogAdaptedWidth(44)));
    }];
    
    // 钻石余额指示栏 (整个底座为 UIButton，实现点击整条充值，高 22 pt, 距顶 62 pt, 距左 24 pt)
    _diamondBarView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_diamondBarView setBackgroundImage:[UIImage imageNamed:@"theme_game_one_purchase_diamond_bar"] forState:UIControlStateNormal];
    [_diamondBarView addTarget:self action:@selector(diamondPlusClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_diamondBarView];
    [_diamondBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(62));
        make.leading.mas_equalTo(KDialogAdaptedWidth(24));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(120), KDialogAdaptedWidth(22)));
    }];
    
    _diamondIconView = [[UIImageView alloc] init];
    _diamondIconView.image = [UIImage imageNamed:@"theme_game_one_purchase_diamond_icon"];
    _diamondIconView.contentMode = UIViewContentModeScaleAspectFit;
    [_diamondBarView addSubview:_diamondIconView];
    [_diamondIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(6)); // 缩小的图标在内嵌布局下偏置 6 pt
        make.centerY.mas_equalTo(_diamondBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(16), KDialogAdaptedWidth(16))); // 缩小至 16x16
    }];
    
    _diamondBalanceLabel = [[UILabel alloc] init];
    _diamondBalanceLabel.textColor = kWhiteColor;
    _diamondBalanceLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(11)];
    _diamondBalanceLabel.text = @"0";
    [_diamondBarView addSubview:_diamondBalanceLabel];
    [_diamondBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(26)); // 左移至 26 pt，紧凑美观且不重叠
        make.centerY.mas_equalTo(_diamondBarView);
    }];

    _diamondPlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_diamondPlusButton setImage:[UIImage imageNamed:@"theme_game_one_plus_icon"] forState:UIControlStateNormal];
    _diamondPlusButton.userInteractionEnabled = NO; // 禁止用户交互，由父视图 _diamondBarView 统一处理点击
    [_diamondBarView addSubview:_diamondPlusButton];
    [_diamondPlusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(6)); // 靠最右侧 6 pt 偏置
        make.centerY.mas_equalTo(_diamondBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(14), KDialogAdaptedWidth(14)));
    }];
    
    // 钥匙余额指示栏 (钥匙底座 theme_game_one_purchase_key_bar.png, 高 22 pt, 距顶 62 pt, 距右 24 pt)
    _keyBarView = [[UIImageView alloc] init];
    _keyBarView.image = [UIImage imageNamed:@"theme_game_one_purchase_key_bar"];
    _keyBarView.contentMode = UIViewContentModeScaleToFill;
    [_bgImageView addSubview:_keyBarView];
    [_keyBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(62));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(24));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(120), KDialogAdaptedWidth(22)));
    }];
    
    _keyIconView = [[UIImageView alloc] init];
    _keyIconView.image = [UIImage imageNamed:@"theme_game_one_purchase_key_icon"];
    _keyIconView.contentMode = UIViewContentModeScaleAspectFit;
    [_keyBarView addSubview:_keyIconView];
    [_keyIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(6)); // 缩小的图标在内嵌布局下偏置 6 pt
        make.centerY.mas_equalTo(_keyBarView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(16), KDialogAdaptedWidth(16))); // 缩小至 16x16
    }];
    
    _keyBalanceLabel = [[UILabel alloc] init];
    _keyBalanceLabel.textColor = kWhiteColor;
    _keyBalanceLabel.font = [UIFont systemFontOfSize:KDialogAdaptedWidth(11)];
    _keyBalanceLabel.text = @"0";
    [_keyBarView addSubview:_keyBalanceLabel];
    [_keyBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(26)); // 左移至 26 pt
        make.centerY.mas_equalTo(_keyBarView);
    }];
    
    // 中部商品展示框组 (下移至 114 pt, 水平居中)
    // 左侧钥匙展示背板: theme_game_one_purchase_board_left.png (宽 97, 高 100 pt)
    _boardLeftView = [[UIImageView alloc] init];
    _boardLeftView.image = [UIImage imageNamed:@"theme_game_one_purchase_board_left"];
    _boardLeftView.contentMode = UIViewContentModeScaleToFill;
    [_bgImageView addSubview:_boardLeftView];
    [_boardLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(114));
        make.trailing.mas_equalTo(_bgImageView.mas_centerX).offset(-KDialogAdaptedWidth(24));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(97), KDialogAdaptedWidth(100)));
    }];
    
    // 右侧礼物赠送背板: theme_game_one_purchase_board_gift.png (宽 97, 高 100 pt)
    _boardGiftView = [[UIImageView alloc] init];
    _boardGiftView.image = [UIImage imageNamed:@"theme_game_one_purchase_board_gift"];
    _boardGiftView.contentMode = UIViewContentModeScaleToFill;
    [_bgImageView addSubview:_boardGiftView];
    [_boardGiftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(114));
        make.leading.mas_equalTo(_bgImageView.mas_centerX).offset(KDialogAdaptedWidth(24));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(97), KDialogAdaptedWidth(100)));
    }];
    
    // 中间加号: theme_game_one_purchase_plus_origin.png (大小 20 * 20 pt)
    _plusIconView = [[UIImageView alloc] init];
    _plusIconView.image = [UIImage imageNamed:@"theme_game_one_purchase_plus_origin"];
    _plusIconView.contentMode = UIViewContentModeScaleAspectFit;
    [_bgImageView addSubview:_plusIconView];
    [_plusIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_boardLeftView);
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(20), KDialogAdaptedWidth(20)));
    }];
    
    // 4档快捷选择按钮组 (1 / 10 / 100 / 其它)
    _optOneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optOneButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_purchase_one_selected"] forState:UIControlStateSelected];
    [_optOneButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_purchase_one_normal"] forState:UIControlStateNormal];
    _optOneButton.selected = YES;
    [_optOneButton addTarget:self action:@selector(optClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_optOneButton];
    
    _optTenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optTenButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_purchase_ten_selected"] forState:UIControlStateSelected];
    [_optTenButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_purchase_ten_normal"] forState:UIControlStateNormal];
    [_optTenButton addTarget:self action:@selector(optClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_optTenButton];
    
    _optHundredButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optHundredButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_purchase_hundred_selected"] forState:UIControlStateSelected];
    [_optHundredButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_purchase_hundred_normal"] forState:UIControlStateNormal];
    [_optHundredButton addTarget:self action:@selector(optClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_optHundredButton];
    
    _optOtherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optOtherButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_purchase_other_selected"] forState:UIControlStateSelected];
    [_optOtherButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_purchase_other_normal"] forState:UIControlStateNormal];
    [_optOtherButton addTarget:self action:@selector(optClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_optOtherButton];
    
    _optButtons = @[_optOneButton, _optTenButton, _optHundredButton, _optOtherButton];
    
    CGFloat btnW = KDialogAdaptedWidth(61.0f); // 缩小 10% (从 68 缩小为 61)
    CGFloat btnH = KDialogAdaptedWidth(25.0f); // 缩小 10% (从 28 缩小为 25)
    CGFloat gap = KDialogAdaptedWidth(8.0f);
    
    [_optTenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(236)); // 从 224 下移为 236
        make.trailing.mas_equalTo(_bgImageView.mas_centerX).offset(-gap/2.0);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    [_optOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(236)); // 从 224 下移为 236
        make.trailing.mas_equalTo(_optTenButton.mas_leading).offset(-gap);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    [_optHundredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(236)); // 从 224 下移为 236
        make.leading.mas_equalTo(_bgImageView.mas_centerX).offset(gap/2.0);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    [_optOtherButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KDialogAdaptedWidth(236)); // 从 224 下移为 236
        make.leading.mas_equalTo(_optHundredButton.mas_trailing).offset(gap);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    // 消耗钻石提示 Label (置于确认按钮上方)
    _costLabel = [[UILabel alloc] init];
    _costLabel.textColor = mHexRGB(0xFFE400);
    _costLabel.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(12)];
    _costLabel.text = [NSString stringWithFormat:@"消耗 %ld 钻石", (long)[self getSingleKeyCost]];
    [_bgImageView addSubview:_costLabel];
    
    // 确认购买按钮 (theme_game_one_purchase_confirm.png, 宽由 208 放大至 230，高由 42 放大至 48. 距底端 24 pt)
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setBackgroundImage:[UIImage imageNamed:@"theme_game_one_purchase_confirm"] forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmPurchaseClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_confirmButton];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(24));
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(207), KDialogAdaptedWidth(43))); // 缩小 10% (从 230x48 缩小为 207x43)
    }];
    
    [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_confirmButton.mas_top).offset(KDialogAdaptedWidth(13)); // 再往下移动 5 pt (原 8)
        make.centerX.mas_equalTo(_bgImageView);
    }];
}

#pragma mark - 充值路由
- (void)diamondPlusClick {
    UIViewController *curVC = [UIViewController currentViewController];
    if (curVC) {
        CFMWalletDiamondRechargeVc *re = [[CFMWalletDiamondRechargeVc alloc] init];
        WeakSelf
        
        // 隐藏购买弹窗
        self.hidden = YES;
        
        // 查找并隐藏游戏大底面板 (MLChatRoomThemeGameOneView)
        __block UIView *gameMainView = nil;
        for (UIView *view in self.superview.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"MLChatRoomThemeGameOneView")]) {
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
            [curVC presentViewController:nav animated:YES completion:nil];
        }
    }
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
    [self updateCostUI];
}

- (void)updateCostUI {
    NSInteger costCount = self.selectedCount;
    _costLabel.text = [NSString stringWithFormat:@"消耗 %ld 钻石", (long)(costCount * [self getSingleKeyCost])];
}

#pragma mark - 档位点击
- (void)optClick:(UIButton *)sender {
    for (UIButton *btn in _optButtons) {
        btn.selected = (btn == sender);
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
        if (wself.selectedCount != 1 && wself.selectedCount != 10 && wself.selectedCount != 100 && wself.selectedCount <= 0) {
            [wself optClick:wself.optOneButton];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields.firstObject;
        NSString *inputStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSInteger count = [inputStr integerValue];
        if (inputStr.length == 0 || count <= 0) {
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
        [wself updateCostUI];
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"已选择购买 %ld 把钥匙", (long)count]];
    }]];
    
    UIViewController *topVC = [UIViewController currentViewController];
    if (topVC) {
        [topVC presentViewController:alert animated:YES completion:nil];
    }
}

- (NSInteger)getSingleKeyCost {
    return 10; // 标准基准：1把钥匙 = 10钻石
}

#pragma mark - 执行购买
- (void)confirmPurchaseClick {
    NSInteger buyCount = self.selectedCount;
    if (buyCount <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择购买数量"];
        return;
    }
    
    NSInteger costDiamonds = buyCount * [self getSingleKeyCost];
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
