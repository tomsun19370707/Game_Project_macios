//
//  MLChatRoomUnifiedExchangeConfirmDialog.m
//  miliao
//
//  Created by PairProgramming on 2026/9/8.
//

#import "MLChatRoomUnifiedExchangeConfirmDialog.h"
#import "Global.h"
#import "FFHomeHandel.h"
#import "DZCX_NetAPIPaths.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface MLChatRoomUnifiedExchangeConfirmDialog () <UITextFieldDelegate>

@property (nonatomic, strong) MLUnifiedExchangeItem *item;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *dialogContainer;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *refreshBtn;

@property (nonatomic, strong) UIView *giftCardContainer;
@property (nonatomic, strong) UIImageView *giftCardBg;
@property (nonatomic, strong) UIImageView *giftImageView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *ratioLabel;

@property (nonatomic, strong) UIView *counterContainer;
@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UITextField *countTextField;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UIView *totalRowContainer;
@property (nonatomic, strong) UILabel *totalTitleLabel;
@property (nonatomic, strong) UIImageView *totalCoinIcon;
@property (nonatomic, strong) UILabel *totalCostLabel;

@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL isExchanging;

@end

@implementation MLChatRoomUnifiedExchangeConfirmDialog

+ (instancetype)showWithItem:(MLUnifiedExchangeItem *)item
                      inView:(nullable UIView *)parentView
                     success:(nullable MLUnifiedExchangeConfirmSuccessBlock)successBlock {
    if (!item) return nil;
    
    UIView *targetView = parentView;
    if (!targetView) {
        targetView = [UIApplication sharedApplication].keyWindow;
    }
    if (!targetView) return nil;
    
    MLChatRoomUnifiedExchangeConfirmDialog *dialog = [[MLChatRoomUnifiedExchangeConfirmDialog alloc] initWithFrame:targetView.bounds item:item];
    dialog.successBlock = successBlock;
    [targetView addSubview:dialog];
    [dialog animateShow];
    return dialog;
}

- (instancetype)initWithFrame:(CGRect)frame item:(MLUnifiedExchangeItem *)item {
    self = [super initWithFrame:frame];
    if (self) {
        _item = item;
        _count = 1;
        _isExchanging = NO;
        [self setupUI];
        [self registerKeyboardNotifications];
        [self reloadData];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    _maskView = [[UIView alloc] init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapMask = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMaskTapped)];
    [_maskView addGestureRecognizer:tapMask];
    [self addSubview:_maskView];
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _dialogContainer = [[UIView alloc] init];
    _dialogContainer.backgroundColor = [UIColor clearColor];
    [self addSubview:_dialogContainer];
    [_dialogContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(320);
        make.height.mas_equalTo(330);
    }];
    
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.image = [UIImage imageNamed:@"unified_exchange_bg_confirm_dialog"];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    [_dialogContainer addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_dialogContainer);
    }];
    
    // 右上角刷新重置按钮
    _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_refreshBtn setImage:[UIImage imageNamed:@"unified_exchange_btn_refresh"] forState:UIControlStateNormal];
    [_refreshBtn addTarget:self action:@selector(onRefreshClick) forControlEvents:UIControlEventTouchUpInside];
    [_dialogContainer addSubview:_refreshBtn];
    [_refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dialogContainer).offset(16);
        make.right.equalTo(_dialogContainer).offset(-18);
        make.width.height.mas_equalTo(38);
    }];
    
    // 左侧礼物大卡片
    _giftCardContainer = [[UIView alloc] init];
    [_dialogContainer addSubview:_giftCardContainer];
    [_giftCardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dialogContainer).offset(36);
        make.left.equalTo(_dialogContainer).offset(32);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(124);
    }];
    
    _giftCardBg = [[UIImageView alloc] init];
    _giftCardBg.image = [UIImage imageNamed:@"unified_exchange_bg_confirm_gift"];
    _giftCardBg.contentMode = UIViewContentModeScaleToFill;
    [_giftCardContainer addSubview:_giftCardBg];
    [_giftCardBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_giftCardContainer);
    }];
    
    _giftImageView = [[UIImageView alloc] init];
    _giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_giftCardContainer addSubview:_giftImageView];
    [_giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_giftCardContainer);
        make.width.height.mas_equalTo(56);
    }];
    
    // 右侧礼物名称
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:17.0] ?: [UIFont boldSystemFontOfSize:17.0];
    _nameLabel.textColor = [UIColor colorWithRed:0x22/255.0 green:0x22/255.0 blue:0x22/255.0 alpha:1.0];
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_dialogContainer addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_giftCardContainer).offset(16);
        make.left.equalTo(_giftCardContainer.mas_right).offset(16);
        make.right.equalTo(_dialogContainer).offset(-56);
    }];
    
    // 右侧兑换比例/单价
    _ratioLabel = [[UILabel alloc] init];
    _ratioLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0] ?: [UIFont systemFontOfSize:14.0];
    _ratioLabel.textColor = [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1.0];
    _ratioLabel.numberOfLines = 2;
    _ratioLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_dialogContainer addSubview:_ratioLabel];
    [_ratioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(12);
        make.left.equalTo(_giftCardContainer.mas_right).offset(16);
        make.right.equalTo(_dialogContainer).offset(-20);
    }];
    
    // 计数器区域 (减号 + 输入框 + 加号)
    _counterContainer = [[UIView alloc] init];
    [_dialogContainer addSubview:_counterContainer];
    [_counterContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_giftCardContainer.mas_bottom).offset(16);
        make.centerX.equalTo(_dialogContainer);
        make.height.mas_equalTo(38);
    }];
    
    _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_subBtn setImage:[UIImage imageNamed:@"unified_exchange_btn_sub"] forState:UIControlStateNormal];
    [_subBtn addTarget:self action:@selector(onSubClick) forControlEvents:UIControlEventTouchUpInside];
    [_counterContainer addSubview:_subBtn];
    [_subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_counterContainer);
        make.centerY.equalTo(_counterContainer);
        make.width.height.mas_equalTo(38);
    }];
    
    UIImageView *inputBg = [[UIImageView alloc] init];
    inputBg.image = [UIImage imageNamed:@"unified_exchange_bg_num_input"];
    inputBg.contentMode = UIViewContentModeScaleToFill;
    [_counterContainer addSubview:inputBg];
    [inputBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_subBtn.mas_right).offset(10);
        make.centerY.equalTo(_counterContainer);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(38);
    }];
    
    _countTextField = [[UITextField alloc] init];
    _countTextField.keyboardType = UIKeyboardTypeNumberPad;
    _countTextField.textAlignment = NSTextAlignmentCenter;
    _countTextField.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16.0] ?: [UIFont boldSystemFontOfSize:16.0];
    _countTextField.textColor = [UIColor whiteColor];
    _countTextField.delegate = self;
    [_countTextField addTarget:self action:@selector(onCountTextChanged:) forControlEvents:UIControlEventEditingChanged];
    [_counterContainer addSubview:_countTextField];
    [_countTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(inputBg);
    }];
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setImage:[UIImage imageNamed:@"unified_exchange_btn_add"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(onAddClick) forControlEvents:UIControlEventTouchUpInside];
    [_counterContainer addSubview:_addBtn];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputBg.mas_right).offset(10);
        make.right.equalTo(_counterContainer);
        make.centerY.equalTo(_counterContainer);
        make.width.height.mas_equalTo(38);
    }];
    
    // 总计区域 (总计 + 图标 + 数量)
    _totalRowContainer = [[UIView alloc] init];
    [_dialogContainer addSubview:_totalRowContainer];
    [_totalRowContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_counterContainer.mas_bottom).offset(14);
        make.centerX.equalTo(_dialogContainer);
        make.height.mas_equalTo(26);
    }];
    
    _totalTitleLabel = [[UILabel alloc] init];
    _totalTitleLabel.text = @"总计";
    _totalTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:17.0] ?: [UIFont boldSystemFontOfSize:17.0];
    _totalTitleLabel.textColor = [UIColor colorWithRed:0x22/255.0 green:0x22/255.0 blue:0x22/255.0 alpha:1.0];
    [_totalRowContainer addSubview:_totalTitleLabel];
    [_totalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_totalRowContainer);
        make.centerY.equalTo(_totalRowContainer);
    }];
    
    _totalCoinIcon = [[UIImageView alloc] init];
    _totalCoinIcon.contentMode = UIViewContentModeScaleAspectFit;
    [_totalRowContainer addSubview:_totalCoinIcon];
    [_totalCoinIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_totalTitleLabel.mas_right).offset(8);
        make.centerY.equalTo(_totalRowContainer);
        make.width.height.mas_equalTo(24);
    }];
    
    _totalCostLabel = [[UILabel alloc] init];
    _totalCostLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18.0] ?: [UIFont boldSystemFontOfSize:18.0];
    _totalCostLabel.textColor = [UIColor colorWithRed:0x22/255.0 green:0x22/255.0 blue:0x22/255.0 alpha:1.0];
    [_totalRowContainer addSubview:_totalCostLabel];
    [_totalCostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_totalCoinIcon.mas_right).offset(8);
        make.right.equalTo(_totalRowContainer);
        make.centerY.equalTo(_totalRowContainer);
    }];
    
    // 确定兑换按钮
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_submitBtn setImage:[UIImage imageNamed:@"unified_exchange_btn_confirm"] forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(onSubmitExchangeClick) forControlEvents:UIControlEventTouchUpInside];
    [_dialogContainer addSubview:_submitBtn];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_totalRowContainer.mas_bottom).offset(12);
        make.centerX.equalTo(_dialogContainer);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(_dialogContainer).offset(-16);
    }];
}

- (void)reloadData {
    [_giftImageView sd_setImageWithURL:[NSURL URLWithString:_item.image] placeholderImage:nil];
    _nameLabel.text = _item.name ?: @"";
    
    if (_item.isBackpackGift) {
        _ratioLabel.text = [NSString stringWithFormat:@"兑换比例为 1:%@", [MLUnifiedExchangeItem formatLargeNumber:_item.unitRatio]];
        _totalCoinIcon.image = [UIImage imageNamed:@"unified_exchange_ic_obsidian"];
    } else {
        if (_item.prizeCoin > 0) {
            _ratioLabel.text = [NSString stringWithFormat:@"单价: %ld 元宝", (long)_item.prizeCoin];
            _totalCoinIcon.image = [UIImage imageNamed:@"unified_exchange_ic_ingot"];
        } else if (_item.ratioCoin > 0) {
            _ratioLabel.text = [NSString stringWithFormat:@"单价: %ld 黑曜石", (long)_item.ratioCoin];
            _totalCoinIcon.image = [UIImage imageNamed:@"unified_exchange_ic_obsidian"];
        } else {
            _ratioLabel.text = @"免费兑换";
            _totalCoinIcon.image = [UIImage imageNamed:@"unified_exchange_ic_ingot"];
        }
    }
    
    _count = 1;
    _countTextField.text = [NSString stringWithFormat:@"%ld", (long)_count];
    [self updateTotalCost];
}

- (void)updateTotalCost {
    int64_t safeCount = (int64_t)_count;
    if (_item.isBackpackGift) {
        double total = (double)safeCount * _item.unitRatio;
        _totalCostLabel.text = [MLUnifiedExchangeItem formatLargeNumber:total];
    } else {
        int64_t unit = _item.prizeCoin > 0 ? (int64_t)_item.prizeCoin : (int64_t)_item.ratioCoin;
        int64_t total = safeCount * unit;
        _totalCostLabel.text = [MLUnifiedExchangeItem formatLargeNumber:(double)total];
    }
}

#pragma mark - Actions

- (void)onRefreshClick {
    [self.countTextField resignFirstResponder];
    _count = 1;
    _countTextField.text = [NSString stringWithFormat:@"%ld", (long)_count];
    [self updateTotalCost];
}

- (void)onSubClick {
    [self.countTextField resignFirstResponder];
    if (_count > 1) {
        _count--;
        _countTextField.text = [NSString stringWithFormat:@"%ld", (long)_count];
        [self updateTotalCost];
    }
}

- (void)onAddClick {
    [self.countTextField resignFirstResponder];
    if (_item.isBackpackGift && _count >= _item.ownedNum) {
        [SVProgressHUD showImage:nil status:@"已达到拥有数量上限"];
        return;
    }
    _count++;
    _countTextField.text = [NSString stringWithFormat:@"%ld", (long)_count];
    [self updateTotalCost];
}

- (void)onCountTextChanged:(UITextField *)tf {
    NSString *text = [tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length == 0) {
        _count = 0;
    } else {
        _count = [text integerValue];
    }
    [self updateTotalCost];
}

- (void)onMaskTapped {
    if (_countTextField.isFirstResponder) {
        [_countTextField resignFirstResponder];
        return;
    }
    [self dismiss];
}

#pragma mark - Submit Network Request

- (void)onSubmitExchangeClick {
    [self.countTextField resignFirstResponder];
    if (_isExchanging) return;
    
    if (_count <= 0) {
        [SVProgressHUD showImage:nil status:@"兑换数量需大于 0"];
        return;
    }
    
    if (_item.isBackpackGift && _count > _item.ownedNum) {
        [SVProgressHUD showImage:nil status:@"拥有数量不足"];
        return;
    }
    
    _isExchanging = YES;
    _submitBtn.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"兑换中..."];
    
    __weak typeof(self) wself = self;
    if (_item.isBackpackGift) {
        // 背包礼物兑换黑曜石 (后端接口 knapsack_id 必须实传真实 gift_id)
        NSInteger targetGiftId = _item.giftId > 0 ? _item.giftId : _item.itemId;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"knapsack_id"] = [NSString stringWithFormat:@"%ld", (long)targetGiftId];
        param[@"nums"] = [NSString stringWithFormat:@"%ld", (long)_count];
        if ([NSString NotNull:UserDefaultsGet(kToken)]) param[@"token"] = UserDefaultsGet(kToken);
        
        [FFHomeHandel customeOprHandle:param apiStr:gift_bagGiftExchangeRatioCoin success:^(BaseModel *info) {
            wself.isExchanging = NO;
            wself.submitBtn.userInteractionEnabled = YES;
            if (info.code == 1) {
                [SVProgressHUD showSuccessWithStatus:@"兑换成功！"];
                if (wself.successBlock) {
                    wself.successBlock();
                }
                [wself dismiss];
            } else {
                NSString *msg = (info.msg && info.msg.length > 0) ? info.msg : @"兑换失败，请稍后重试";
                [SVProgressHUD showImage:nil status:msg];
            }
        } failure:^{
            wself.isExchanging = NO;
            wself.submitBtn.userInteractionEnabled = YES;
            [SVProgressHUD showImage:nil status:@"网络异常，请稍后重试"];
        }];
    } else {
        // 元宝商城兑换礼物
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"gift_id"] = [NSString stringWithFormat:@"%ld", (long)_item.giftId];
        param[@"nums"] = [NSString stringWithFormat:@"%ld", (long)_count];
        if ([NSString NotNull:UserDefaultsGet(kToken)]) param[@"token"] = UserDefaultsGet(kToken);
        
        [FFHomeHandel customeOprHandle:param apiStr:gift_prizeCoinChangeGift success:^(BaseModel *info) {
            wself.isExchanging = NO;
            wself.submitBtn.userInteractionEnabled = YES;
            if (info.code == 1) {
                [SVProgressHUD showSuccessWithStatus:@"兑换成功！"];
                if (wself.successBlock) {
                    wself.successBlock();
                }
                [wself dismiss];
            } else {
                NSString *msg = (info.msg && info.msg.length > 0) ? info.msg : @"兑换失败，请稍后重试";
                [SVProgressHUD showImage:nil status:msg];
            }
        } failure:^{
            wself.isExchanging = NO;
            wself.submitBtn.userInteractionEnabled = YES;
            [SVProgressHUD showImage:nil status:@"网络异常，请稍后重试"];
        }];
    }
}

#pragma mark - Keyboard Notifications

- (void)registerKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)note {
    CGRect kbFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.dialogContainer.transform = CGAffineTransformMakeTranslation(0, -kbFrame.size.height / 2.0);
    }];
}

- (void)keyboardWillHide:(NSNotification *)note {
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.dialogContainer.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - Show / Dismiss Animations

- (void)animateShow {
    _maskView.alpha = 0.0;
    _dialogContainer.alpha = 0.0;
    _dialogContainer.transform = CGAffineTransformMakeScale(0.85, 0.85);
    [UIView animateWithDuration:0.25 animations:^{
        self.maskView.alpha = 1.0;
        self.dialogContainer.alpha = 1.0;
        self.dialogContainer.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    [self.countTextField resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = 0.0;
        self.dialogContainer.alpha = 0.0;
        self.dialogContainer.transform = CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
