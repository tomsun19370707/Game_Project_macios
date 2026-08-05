//
//  MLChatRoomThemeGameFivePurchaseView.m
//  miliao
//

#import "MLChatRoomThemeGameFivePurchaseView.h"
#import "MLGameLotteryService.h"
#import "CFMWalletDiamondRechargeVc.h"
#import "UIViewController+CurViewController.h"
#import "Global.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD.h>

@interface MLChatRoomThemeGameFivePurchaseView ()

@property (nonatomic, strong) MLGameLotteryInfoModel *info;
@property (nonatomic, copy) void(^successBlock)(NSInteger newKeyBalance);

@property (nonatomic, assign) NSInteger currentDiamondCount;
@property (nonatomic, assign) NSInteger currentKeyCount;
@property (nonatomic, assign) NSInteger selectedCount;
@property (nonatomic, assign) NSInteger customCount;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *backgroundContainer;
@property (nonatomic, strong) UIView *contentClippingContainer;
@property (nonatomic, strong) UIImageView *purchaseBgView;
@property (nonatomic, strong) UIButton *closeBtn;

// Top Bar Balances
@property (nonatomic, strong) UIView *diamondBar;
@property (nonatomic, strong) UIImageView *ivDiamond;
@property (nonatomic, strong) UILabel *tvDiamondCount;
@property (nonatomic, strong) UIImageView *btnPlus;

@property (nonatomic, strong) UIView *keyBar;
@property (nonatomic, strong) UIImageView *ivKey;
@property (nonatomic, strong) UILabel *tvKeyCount;

// Gifts Frame
@property (nonatomic, strong) UIImageView *frameLeft;
@property (nonatomic, strong) UILabel *labelPlus;
@property (nonatomic, strong) UIImageView *frameRight;

// Selection Options
@property (nonatomic, strong) UIButton *btnCountOne;
@property (nonatomic, strong) UIButton *btnCountTen;
@property (nonatomic, strong) UIButton *btnCountHundred;
@property (nonatomic, strong) UIButton *btnCountOther;

// Selected Box & Confirm Button
@property (nonatomic, strong) UILabel *tvSelectedCount;
@property (nonatomic, strong) UIButton *btnConfirmPurchase;

@end

@implementation MLChatRoomThemeGameFivePurchaseView

static const NSInteger KEY_PRICE_DIAMOND = 10; // 1 key = 10 diamonds

+ (void)showInView:(UIView *)parentView 
         infoModel:(MLGameLotteryInfoModel *)info 
   purchaseSuccess:(void(^)(NSInteger newKeyBalance))success {
    MLChatRoomThemeGameFivePurchaseView *purchaseView = [[MLChatRoomThemeGameFivePurchaseView alloc] initWithFrame:parentView.bounds infoModel:info purchaseSuccess:success];
    [parentView addSubview:purchaseView];
    [purchaseView animateShow];
}

- (instancetype)initWithFrame:(CGRect)frame 
                    infoModel:(MLGameLotteryInfoModel *)info 
              purchaseSuccess:(void(^)(NSInteger newKeyBalance))success {
    if (self = [super initWithFrame:frame]) {
        self.info = info;
        self.successBlock = success;
        self.currentKeyCount = info.lottery_coin;
        self.selectedCount = 1; // Default select 1
        self.customCount = -1;
        
        [self setupUI];
        [self loadUserMoney];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];

    // 1. Semi-transparent mask view
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [_maskView addGestureRecognizer:tap];

    // 2. Aspect Ratio Locked Panel Container (Ratio 659:789)
    _backgroundContainer = [[UIView alloc] init];
    _backgroundContainer.backgroundColor = [UIColor clearColor];
    [self addSubview:_backgroundContainer];
    [_backgroundContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(KDialogAdaptedWidth(280));
        make.height.mas_equalTo(_backgroundContainer.mas_width).multipliedBy(789.0 / 659.0);
    }];

    // 3. Clipped Content container
    _contentClippingContainer = [[UIView alloc] init];
    _contentClippingContainer.clipsToBounds = YES;
    [_backgroundContainer addSubview:_contentClippingContainer];
    [_contentClippingContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_backgroundContainer);
    }];

    // 3.1 Background image
    _purchaseBgView = [[UIImageView alloc] init];
    _purchaseBgView.contentMode = UIViewContentModeScaleToFill;
    _purchaseBgView.image = [UIImage imageNamed:@"theme_game_five_purchase_bg"];
    [_contentClippingContainer addSubview:_purchaseBgView];
    [_purchaseBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_contentClippingContainer);
    }];

    // 3.2 Top-Right Close Button (Overlapping)
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"theme_game_five_rule_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundContainer addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentClippingContainer).offset(KDialogAdaptedWidth(10));
        make.trailing.mas_equalTo(_contentClippingContainer).offset(-KDialogAdaptedWidth(10));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(24), KDialogAdaptedWidth(24)));
    }];

    // 4. Balances bar (Option A: top = 72 pt)
    _diamondBar = [[UIView alloc] init];
    _diamondBar.backgroundColor = [UIColor clearColor];
    _diamondBar.layer.contents = (__bridge id)[UIImage imageNamed:@"theme_game_five_purchase_bar_bg"].CGImage;
    [_contentClippingContainer addSubview:_diamondBar];
    [_diamondBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backgroundContainer.mas_top).offset(KDialogAdaptedWidth(72));
        make.trailing.mas_equalTo(_backgroundContainer.mas_centerX).offset(-KDialogAdaptedWidth(10));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(105), KDialogAdaptedWidth(24)));
    }];

    UITapGestureRecognizer *rechargeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rechargeClick)];
    [_diamondBar addGestureRecognizer:rechargeTap];
    _diamondBar.userInteractionEnabled = YES;

    _ivDiamond = [[UIImageView alloc] init];
    _ivDiamond.contentMode = UIViewContentModeScaleAspectFit;
    _ivDiamond.image = [UIImage imageNamed:@"theme_game_five_purchase_diamond"];
    [_diamondBar addSubview:_ivDiamond];
    [_ivDiamond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(5));
        make.centerY.mas_equalTo(_diamondBar);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(18), KDialogAdaptedWidth(15)));
    }];

    _btnPlus = [[UIImageView alloc] init];
    _btnPlus.contentMode = UIViewContentModeScaleAspectFit;
    _btnPlus.image = [UIImage imageNamed:@"theme_game_five_purchase_plus"];
    [_diamondBar addSubview:_btnPlus];
    [_btnPlus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(5));
        make.centerY.mas_equalTo(_diamondBar);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(12), KDialogAdaptedWidth(12)));
    }];

    _tvDiamondCount = [[UILabel alloc] init];
    _tvDiamondCount.textColor = kWhiteColor;
    _tvDiamondCount.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(10)];
    _tvDiamondCount.textAlignment = NSTextAlignmentCenter;
    _tvDiamondCount.lineBreakMode = NSLineBreakByTruncatingTail;
    _tvDiamondCount.text = @"0";
    [_diamondBar addSubview:_tvDiamondCount];
    [_tvDiamondCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_ivDiamond.mas_trailing).offset(KDialogAdaptedWidth(2));
        make.trailing.mas_equalTo(_btnPlus.mas_leading).offset(-KDialogAdaptedWidth(2));
        make.centerY.mas_equalTo(_diamondBar);
    }];

    // Key balance bar (Option A: top = 72 pt)
    _keyBar = [[UIView alloc] init];
    _keyBar.backgroundColor = [UIColor clearColor];
    _keyBar.layer.contents = (__bridge id)[UIImage imageNamed:@"theme_game_five_purchase_bar_bg"].CGImage;
    [_contentClippingContainer addSubview:_keyBar];
    [_keyBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_diamondBar.mas_top);
        make.leading.mas_equalTo(_backgroundContainer.mas_centerX).offset(KDialogAdaptedWidth(10));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(105), KDialogAdaptedWidth(24)));
    }];

    _ivKey = [[UIImageView alloc] init];
    _ivKey.contentMode = UIViewContentModeScaleAspectFit;
    _ivKey.image = [UIImage imageNamed:@"theme_game_five_purchase_key"];
    [_keyBar addSubview:_ivKey];
    [_ivKey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(KDialogAdaptedWidth(6));
        make.centerY.mas_equalTo(_keyBar);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(14), KDialogAdaptedWidth(18)));
    }];

    _tvKeyCount = [[UILabel alloc] init];
    _tvKeyCount.textColor = kWhiteColor;
    _tvKeyCount.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(10)];
    _tvKeyCount.textAlignment = NSTextAlignmentCenter;
    _tvKeyCount.lineBreakMode = NSLineBreakByTruncatingTail;
    _tvKeyCount.text = MLFormatLargeNumber((double)_currentKeyCount);
    [_keyBar addSubview:_tvKeyCount];
    [_tvKeyCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_ivKey.mas_trailing).offset(KDialogAdaptedWidth(2));
        make.trailing.mas_equalTo(-KDialogAdaptedWidth(6));
        make.centerY.mas_equalTo(_keyBar);
    }];

    // 5. Gifts Preview Display Frame (+50% enlarged total: 111x111 pt, top = 145 pt)
    _labelPlus = [[UILabel alloc] init];
    _labelPlus.text = @"+";
    _labelPlus.textColor = mHexRGB(0xB2834E);
    _labelPlus.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(28)];
    _labelPlus.textAlignment = NSTextAlignmentCenter;
    [_contentClippingContainer addSubview:_labelPlus];
    [_labelPlus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backgroundContainer.mas_top).offset(KDialogAdaptedWidth(145));
        make.centerX.mas_equalTo(_backgroundContainer);
    }];

    _frameLeft = [[UIImageView alloc] init];
    _frameLeft.contentMode = UIViewContentModeScaleAspectFit;
    _frameLeft.image = [UIImage imageNamed:@"theme_game_five_purchase_frame_left"];
    [_contentClippingContainer addSubview:_frameLeft];
    [_frameLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_labelPlus);
        make.trailing.mas_equalTo(_labelPlus.mas_leading).offset(-KDialogAdaptedWidth(6));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(111), KDialogAdaptedWidth(111)));
    }];

    _frameRight = [[UIImageView alloc] init];
    _frameRight.contentMode = UIViewContentModeScaleAspectFit;
    _frameRight.image = [UIImage imageNamed:@"theme_game_five_purchase_frame_right"];
    [_contentClippingContainer addSubview:_frameRight];
    [_frameRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_labelPlus);
        make.leading.mas_equalTo(_labelPlus.mas_trailing).offset(KDialogAdaptedWidth(6));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(111), KDialogAdaptedWidth(111)));
    }];

    // 6. Shortcut Options Selectors (top = 222 pt to accommodate 111pt gift frames)
    _btnCountTen = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCountTen setBackgroundImage:[UIImage imageNamed:@"theme_game_five_purchase_ten"] forState:UIControlStateNormal];
    [_btnCountTen addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnCountTen.tag = 10;
    [_contentClippingContainer addSubview:_btnCountTen];
    [_btnCountTen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backgroundContainer.mas_top).offset(KDialogAdaptedWidth(222));
        make.trailing.mas_equalTo(_backgroundContainer.mas_centerX).offset(-KDialogAdaptedWidth(3));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(54), KDialogAdaptedWidth(33)));
    }];

    _btnCountHundred = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCountHundred setBackgroundImage:[UIImage imageNamed:@"theme_game_five_purchase_hundred"] forState:UIControlStateNormal];
    [_btnCountHundred addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnCountHundred.tag = 100;
    [_contentClippingContainer addSubview:_btnCountHundred];
    [_btnCountHundred mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_btnCountTen.mas_top);
        make.leading.mas_equalTo(_backgroundContainer.mas_centerX).offset(KDialogAdaptedWidth(3));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(54), KDialogAdaptedWidth(33)));
    }];

    _btnCountOne = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCountOne setBackgroundImage:[UIImage imageNamed:@"theme_game_five_purchase_one"] forState:UIControlStateNormal];
    [_btnCountOne addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnCountOne.tag = 1;
    [_contentClippingContainer addSubview:_btnCountOne];
    [_btnCountOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_btnCountTen.mas_top);
        make.trailing.mas_equalTo(_btnCountTen.mas_leading).offset(-KDialogAdaptedWidth(5));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(54), KDialogAdaptedWidth(33)));
    }];

    _btnCountOther = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCountOther setBackgroundImage:[UIImage imageNamed:@"theme_game_five_purchase_other"] forState:UIControlStateNormal];
    [_btnCountOther addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnCountOther.tag = -1;
    [_contentClippingContainer addSubview:_btnCountOther];
    [_btnCountOther mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_btnCountTen.mas_top);
        make.leading.mas_equalTo(_btnCountHundred.mas_trailing).offset(KDialogAdaptedWidth(5));
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(54), KDialogAdaptedWidth(33)));
    }];

    // 7. Selected Count & Diamond Cost Text Label (No background capsule bar, shifted upwards)
    _tvSelectedCount = [[UILabel alloc] init];
    _tvSelectedCount.textColor = mHexRGB(0xFFDB83);
    _tvSelectedCount.font = [UIFont boldSystemFontOfSize:KDialogAdaptedWidth(11)];
    _tvSelectedCount.textAlignment = NSTextAlignmentCenter;
    [_contentClippingContainer addSubview:_tvSelectedCount];
    [_tvSelectedCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_btnCountTen.mas_bottom).offset(KDialogAdaptedWidth(4));
        make.centerX.mas_equalTo(_contentClippingContainer);
    }];

    // 8. Confirm Purchase Button (Enlarged by another 10%: 194x71 pt, bottom = -6 pt)
    _btnConfirmPurchase = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnConfirmPurchase setBackgroundImage:[UIImage imageNamed:@"theme_game_five_purchase_confirm"] forState:UIControlStateNormal];
    [_btnConfirmPurchase addTarget:self action:@selector(confirmPurchaseClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentClippingContainer addSubview:_btnConfirmPurchase];
    [_btnConfirmPurchase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-KDialogAdaptedWidth(6));
        make.centerX.mas_equalTo(_contentClippingContainer);
        make.size.mas_equalTo(CGSizeMake(KDialogAdaptedWidth(194), KDialogAdaptedWidth(71)));
    }];

    [self updateSelectionStates];
}

- (void)loadUserMoney {
    __weak typeof(self) weakSelf = self;
    [MLGameLotteryService getUserMoneyWithSuccess:^(MLGameUserMoneyModel *model) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (model && model.diamond) {
            strongSelf.currentDiamondCount = [model.diamond integerValue];
            strongSelf.tvDiamondCount.text = MLFormatLargeNumber([model.diamond doubleValue]);
        }
    } failure:nil];
}

- (void)optionClick:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if (tag == -1) {
        __weak typeof(self) weakSelf = self;
        UIViewController *topVC = [UIViewController currentViewController];
        if (!topVC) return;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"自定义购买数量" message:@"请输入购买数量" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.placeholder = @"输入要购买的钥匙数量";
            if (weakSelf.customCount > 0) {
                textField.text = [NSString stringWithFormat:@"%ld", (long)weakSelf.customCount];
            }
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            UITextField *tf = alert.textFields.firstObject;
            NSString *text = [tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (text.length == 0) {
                [SVProgressHUD showInfoWithStatus:@"数量不能为空"];
                return;
            }
            NSInteger count = [text integerValue];
            if (count <= 0) {
                [SVProgressHUD showInfoWithStatus:@"购买数量必须大于0"];
                return;
            }
            if (count > 9999) {
                [SVProgressHUD showInfoWithStatus:@"单次购买上限为 9999"];
                return;
            }
            strongSelf.customCount = count;
            strongSelf.selectedCount = -1;
            [strongSelf updateSelectionStates];
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:confirmAction];
        [topVC presentViewController:alert animated:YES completion:nil];
    } else {
        self.selectedCount = tag;
        [self updateSelectionStates];
    }
}

- (void)updateSelectionStates {
    _btnCountOne.alpha = (self.selectedCount == 1) ? 1.0f : 0.55f;
    _btnCountTen.alpha = (self.selectedCount == 10) ? 1.0f : 0.55f;
    _btnCountHundred.alpha = (self.selectedCount == 100) ? 1.0f : 0.55f;
    _btnCountOther.alpha = (self.selectedCount == -1) ? 1.0f : 0.55f;

    NSInteger actualCount = (self.selectedCount == -1) ? (self.customCount > 0 ? self.customCount : 0) : self.selectedCount;
    NSInteger totalCost = actualCount * KEY_PRICE_DIAMOND;
    _tvSelectedCount.text = [NSString stringWithFormat:@"已选择: %ld 个 (%ld钻石)", (long)actualCount, (long)totalCost];
}

- (void)rechargeClick {
    UIViewController *curVC = [UIViewController currentViewController];
    if (curVC) {
        CFMWalletDiamondRechargeVc *re = [[CFMWalletDiamondRechargeVc alloc] init];
        __weak typeof(self) weakSelf = self;
        
        self.hidden = YES;
        __block UIView *gameMainView = nil;
        for (UIView *view in self.superview.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"MLChatRoomThemeGameFiveView")]) {
                gameMainView = view;
                gameMainView.hidden = YES;
                break;
            }
        }
        
        re.dismissBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (gameMainView) {
                    gameMainView.hidden = NO;
                }
                if (weakSelf) {
                    weakSelf.hidden = NO;
                    [weakSelf loadUserMoney];
                }
            });
        };
        [curVC.navigationController pushViewController:re animated:YES];
    }
}

- (void)confirmPurchaseClick {
    NSInteger actualCount = (self.selectedCount == -1) ? self.customCount : self.selectedCount;
    if (actualCount <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请先选择或输入购买数量"];
        return;
    }
    
    NSInteger diamondCost = actualCount * KEY_PRICE_DIAMOND;
    if (self.currentDiamondCount < diamondCost) {
        [SVProgressHUD showInfoWithStatus:@"钻石余额不足"];
        [self rechargeClick];
        return;
    }

    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"购买中..."];
    [MLGameLotteryService diamondChangeLotteryCoinWithDiamondCount:diamondCost success:^(id responseObject) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        [SVProgressHUD showSuccessWithStatus:@"购买成功"];
        
        NSInteger newBalance = strongSelf.currentKeyCount + actualCount;
        strongSelf.currentKeyCount = newBalance;
        strongSelf.tvKeyCount.text = MLFormatLargeNumber((double)newBalance);
        
        [strongSelf loadUserMoney];
        
        if (strongSelf.successBlock) {
            strongSelf.successBlock(newBalance);
        }
        // Do not auto-close popup on purchase success; keep open for user manual close
    } failure:^(NSError *error) {
        NSString *errMsg = error.userInfo[NSLocalizedDescriptionKey] ?: @"购买失败";
        [SVProgressHUD showErrorWithStatus:errMsg];
    }];
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
