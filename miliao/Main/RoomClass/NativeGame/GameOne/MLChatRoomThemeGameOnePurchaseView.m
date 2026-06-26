#import "MLChatRoomThemeGameOnePurchaseView.h"
#import "MLGameLotteryService.h"
#import "Global.h"

@interface MLChatRoomThemeGameOnePurchaseView () <UITextFieldDelegate>

@property (nonatomic, strong) MLGameLotteryInfoModel *infoModel;
@property (nonatomic, copy) void(^purchaseSuccessBlock)(NSInteger);

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *diamondBalanceLabel; // 钻石余额
@property (nonatomic, strong) UILabel *keyBalanceLabel; // 钥匙余额

@property (nonatomic, strong) UIButton *optOneButton;
@property (nonatomic, strong) UIButton *optTenButton;
@property (nonatomic, strong) UIButton *optHundredButton;
@property (nonatomic, strong) UIButton *optOtherButton;
@property (nonatomic, strong) NSArray<UIButton *> *optButtons;

@property (nonatomic, strong) UIView *otherInputContainer;
@property (nonatomic, strong) UITextField *inputTextField;

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
    
    // 背景外框 (315 * 360)
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"theme_game_one_purchase_popup_board"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.userInteractionEnabled = YES;
    setViewCorner(_bgImageView, 12);
    [self addSubview:_bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(315, 360));
    }];
    
    // 关闭按钮 (36 * 36)
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = CGRectMake(315 - 36 - 16, 16, 36, 36);
    [_closeButton setImage:[UIImage imageNamed:@"theme_game_one_result_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_closeButton];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"购买钥匙";
    _titleLabel.textColor = mHexRGB(0xFFE400);
    _titleLabel.font = KFontBoldA(18);
    [_bgImageView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24);
        make.centerX.mas_equalTo(_bgImageView);
    }];
    
    // 钻石与钥匙余额展示条
    UIView *balanceBar = [[UIView alloc] init];
    [_bgImageView addSubview:balanceBar];
    [balanceBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(18);
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(280, 40));
    }];
    
    _diamondBalanceLabel = [[UILabel alloc] init];
    _diamondBalanceLabel.textColor = kWhiteColor;
    _diamondBalanceLabel.font = KFontA(13);
    _diamondBalanceLabel.text = @"钻石: --";
    [balanceBar addSubview:_diamondBalanceLabel];
    [_diamondBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.centerY.mas_equalTo(balanceBar);
    }];
    
    _keyBalanceLabel = [[UILabel alloc] init];
    _keyBalanceLabel.textColor = kWhiteColor;
    _keyBalanceLabel.font = KFontA(13);
    _keyBalanceLabel.text = @"钥匙: --";
    [balanceBar addSubview:_keyBalanceLabel];
    [_keyBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-12);
        make.centerY.mas_equalTo(balanceBar);
    }];
    
    // 其它数量输入框 (默认隐藏)
    _otherInputContainer = [[UIView alloc] init];
    _otherInputContainer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.05];
    setViewCorner(_otherInputContainer, 6);
    _otherInputContainer.hidden = YES;
    [_bgImageView addSubview:_otherInputContainer];
    [_otherInputContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(balanceBar.mas_bottom).offset(20);
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(260, 45));
    }];
    
    _inputTextField = [[UITextField alloc] init];
    _inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    _inputTextField.placeholder = @"请输入购买数量";
    _inputTextField.textColor = kWhiteColor;
    _inputTextField.font = KFontA(14);
    _inputTextField.textAlignment = NSTextAlignmentCenter;
    // 设置 placeholder 颜色
    _inputTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入购买数量" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.3]}];
    _inputTextField.delegate = self;
    [_inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_otherInputContainer addSubview:_inputTextField];
    [_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_otherInputContainer);
    }];
    
    // 档位按钮组 (1 / 10 / 100 / 其它)
    _optOneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optOneButton setImage:[UIImage imageNamed:@"theme_game_one_purchase_one_selected"] forState:UIControlStateSelected];
    [_optOneButton setImage:[UIImage imageNamed:@"theme_game_one_purchase_one_normal"] forState:UIControlStateNormal];
    _optOneButton.selected = YES;
    [_optOneButton addTarget:self action:@selector(optClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_optOneButton];
    
    _optTenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optTenButton setImage:[UIImage imageNamed:@"theme_game_one_purchase_ten_selected"] forState:UIControlStateSelected];
    [_optTenButton setImage:[UIImage imageNamed:@"theme_game_one_purchase_ten_normal"] forState:UIControlStateNormal];
    [_optTenButton addTarget:self action:@selector(optClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_optTenButton];
    
    _optHundredButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optHundredButton setImage:[UIImage imageNamed:@"theme_game_one_purchase_hundred_selected"] forState:UIControlStateSelected];
    [_optHundredButton setImage:[UIImage imageNamed:@"theme_game_one_purchase_hundred_normal"] forState:UIControlStateNormal];
    [_optHundredButton addTarget:self action:@selector(optClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_optHundredButton];
    
    _optOtherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optOtherButton setImage:[UIImage imageNamed:@"theme_game_one_purchase_other_selected"] forState:UIControlStateSelected];
    [_optOtherButton setImage:[UIImage imageNamed:@"theme_game_one_purchase_other_normal"] forState:UIControlStateNormal];
    [_optOtherButton addTarget:self action:@selector(optClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_optOtherButton];
    
    _optButtons = @[_optOneButton, _optTenButton, _optHundredButton, _optOtherButton];
    
    CGFloat btnW = 68.0f;
    CGFloat btnH = 34.0f;
    CGFloat gap = 8.0f;
    
    [_optOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-120);
        make.leading.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    [_optTenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_optOneButton);
        make.leading.mas_equalTo(_optOneButton.mas_trailing).offset(gap);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    [_optHundredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_optOneButton);
        make.leading.mas_equalTo(_optTenButton.mas_trailing).offset(gap);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    [_optOtherButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_optOneButton);
        make.leading.mas_equalTo(_optHundredButton.mas_trailing).offset(gap);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    // 确认按钮及消耗提示文字
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setImage:[UIImage imageNamed:@"theme_game_one_purchase_confirm"] forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmPurchaseClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgImageView addSubview:_confirmButton];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgImageView);
        make.bottom.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(260, 86)); // 高还原底边下移配合素材质感
    }];
    
    _costLabel = [[UILabel alloc] init];
    _costLabel.textColor = kWhiteColor;
    _costLabel.font = KFontBoldA(14);
    _costLabel.text = @"消耗 200 钻石";
    [_bgImageView addSubview:_costLabel];
    [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_confirmButton.mas_top).offset(-10);
        make.centerX.mas_equalTo(_bgImageView);
    }];
}

#pragma mark - 数据拉取
- (void)loadUserMoney {
    [MLGameLotteryService getUserMoneyWithSuccess:^(MLGameUserMoneyModel *model) {
        self.localDiamonds = [model.diamond doubleValue];
        self.localKeys = model.lottery_coin;
        [self updateBalanceUI];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)updateBalanceUI {
    _diamondBalanceLabel.text = [NSString stringWithFormat:@"钻石: %ld", (long)self.localDiamonds];
    _keyBalanceLabel.text = [NSString stringWithFormat:@"钥匙: %ld", (long)self.localKeys];
    [self updateCostUI];
}

- (void)updateCostUI {
    if (_optOtherButton.selected) {
        NSInteger count = [_inputTextField.text integerValue];
        _costLabel.text = [NSString stringWithFormat:@"消耗 %ld 钻石", (long)(count * 200)];
    } else {
        _costLabel.text = [NSString stringWithFormat:@"消耗 %ld 钻石", (long)(self.selectedCount * 200)];
    }
}

#pragma mark - 档位点击
- (void)optClick:(UIButton *)sender {
    for (UIButton *btn in _optButtons) {
        btn.selected = (btn == sender);
    }
    
    if (sender == _optOneButton) {
        self.selectedCount = 1;
        _otherInputContainer.hidden = YES;
        [self.inputTextField resignFirstResponder];
    } else if (sender == _optTenButton) {
        self.selectedCount = 10;
        _otherInputContainer.hidden = YES;
        [self.inputTextField resignFirstResponder];
    } else if (sender == _optHundredButton) {
        self.selectedCount = 100;
        _otherInputContainer.hidden = YES;
        [self.inputTextField resignFirstResponder];
    } else if (sender == _optOtherButton) {
        _otherInputContainer.hidden = NO;
        [self.inputTextField becomeFirstResponder];
    }
    
    [self updateCostUI];
}

#pragma mark - 输入变化
- (void)textFieldDidChange:(UITextField *)textField {
    [self updateCostUI];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 过滤非数字
    NSCharacterSet *numbers = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:numbers] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}

#pragma mark - 执行购买 (安全红线 & 防刷拦截 & 连续购买)
- (void)confirmPurchaseClick {
    NSInteger buyCount = 0;
    
    if (_optOtherButton.selected) {
        NSString *inputStr = [_inputTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (inputStr.length == 0 || [inputStr integerValue] == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入购买数量"];
            return;
        }
        buyCount = [inputStr integerValue];
        if (buyCount > 9999) {
            [SVProgressHUD showErrorWithStatus:@"单次购买不能超过 9999 个"];
            return;
        }
    } else {
        buyCount = self.selectedCount;
    }
    
    NSInteger costDiamonds = buyCount * 200;
    if (self.localDiamonds < costDiamonds) {
        [SVProgressHUD showErrorWithStatus:@"钻石余额不足，请前往充值"];
        return;
    }
    
    _confirmButton.enabled = NO;
    [MLGameLotteryService diamondChangeLotteryCoinWithDiamondCount:costDiamonds success:^(id responseObject) {
        self.confirmButton.enabled = YES;
        
        // 成功扣减与回显 (不 Dismiss 弹窗, 连续购买)
        self.localDiamonds -= costDiamonds;
        self.localKeys += buyCount;
        [self updateBalanceUI];
        
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"成功兑换 %ld 把钥匙", (long)buyCount]];
        
        // 触发钥匙余额变更回调
        if (self.purchaseSuccessBlock) {
            self.purchaseSuccessBlock(self.localKeys);
        }
    } failure:^(NSError *error) {
        self.confirmButton.enabled = YES;
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
