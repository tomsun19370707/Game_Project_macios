//
//  CFMExDiamondAndBagAlert.m
//  miliao
//
//  Created by Dylan Lee on 2026/1/4.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "CFMExDiamondAndBagAlert.h"
#import "CFMExDiamondAndBagDiamond.h"
#import "CFMExDiamondAndBagPackage.h"
#import "Common.h"

@interface CFMExDiamondAndBagAlert ()<UITextFieldDelegate>
/** 数据源*/
@property (nonatomic,strong) NSMutableArray *dataArr;
/** maskview*/
@property (nonatomic,strong) UIView *maskView;
/** 异形屏，底部tab不可控区域*/
@property (nonatomic,strong) UIView *specia_screen_view;
/**  1钻石2背包礼物*/
@property (nonatomic,assign) int vcType;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UILabel *mark;
@property (weak, nonatomic) IBOutlet UIButton *btn;

/** 钻石*/
@property (nonatomic,strong) CFMExDiamondAndBagDiamond *diamondVie;
/** 背包*/
@property (nonatomic,strong) CFMExDiamondAndBagPackage *bagVie;
/** 记录键盘高度*/
@property (nonatomic,assign) CGFloat keyboardHeight;
/** 余额相关的*/
@property (nonatomic,strong) NSDictionary *balanceInfo;
/** 背包礼物，选择的礼物index*/
@property (nonatomic,assign) NSInteger packageGiftIndex;

@property (nonatomic, strong) RACDisposable *keyboardShowDisposable;
@property (nonatomic, strong) RACDisposable *keyboardHideDisposable;
@end

@implementation CFMExDiamondAndBagAlert

#pragma mark -
#pragma mark --- init
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initContentview];
        [self initRacChain];
    }
    return self ;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initContentview];
        [self initRacChain];
    }
    return self ;
}

- (void)dealloc {
    [self.keyboardShowDisposable dispose];
    [self.keyboardHideDisposable dispose];
}

#pragma mark -
#pragma mark --- 初始化view
- (void)initContentview
{
    self.packageGiftIndex = 0 ;
    self.vcType = 1;
    
    [self.btn makeRoundCorner];
    [self setFrame:CGRectMake(0, SCREEN_HEIGHT_FULL + 60, SCREEN_WIDTH, 420)];
    [self makeCornerAt:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:15];
    
    [self.contentView addSubview:self.diamondVie];
    [self.contentView addSubview:self.bagVie];
    
    self.diamondVie.frame = CGRectMake(0, 80, SCREEN_WIDTH, 230);
    self.bagVie.frame = CGRectMake(0, 80, SCREEN_WIDTH, 230);
    
    self.diamondVie.hidden = NO;
    self.bagVie.hidden = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initContentview];
    [self initRacChain];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // 阻断 super 选定消息
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    // 阻断 super 高亮消息
}

#pragma mark -
#pragma mark --- Rac
- (void)initRacChain {
    @weakify(self);
    /** 键盘的弹出*/
    self.keyboardShowDisposable = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        if (!self) return;
        NSDictionary *userInfo = [x userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        CGFloat height = keyboardRect.size.height;
        if (self.keyboardHeight != height) {
            [self setBottom:(SCREEN_HEIGHT_FULL - height)];
            self.keyboardHeight = height ;
            DLog(@"\n+++++++++%f",height);
        }
    }];
    
    /** 键盘消失*/
    self.keyboardHideDisposable = [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        if (!self) return;
        self.keyboardHeight = 0.0 ;
        [self setBottom:SCREEN_HEIGHT_FULL];
    }];
    
    /** 背包礼物切换的时候*/
    self.bagVie.fetchClick = ^(NSInteger selIndex) {
        @strongify(self);
        if (!self) return;
        self.packageGiftIndex = selIndex;
        if (selIndex < self.dataArr.count) {
            id item = self.dataArr[selIndex];
            if ([item isKindOfClass:[GoodListInfoModel class]]) {
                GoodListInfoModel *model = (GoodListInfoModel *)item;
                self.bagVie.tip.text = [NSString stringWithFormat:@"可兑换黑曜石：%d", model.exchange_num];
            } else if ([item isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)item;
                self.bagVie.tip.text = [NSString stringWithFormat:@"可兑换黑曜石：%@", FORMAT(dict[@"exchange_num"] ?: @"0")];
            }
        }
    };
}

#pragma mark -
#pragma mark --- Getter
-(UIView *)maskView
{
    if (!_maskView) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *backgroundView = [[UIView alloc] initWithFrame:window ? window.bounds : CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT_FULL)];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        _maskView = backgroundView;
    }
    return _maskView ;
}

-(UIView *)specia_screen_view
{
    if (!_specia_screen_view) {
        _specia_screen_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 60)];
        _specia_screen_view.backgroundColor = [UIColor whiteColor];
        _specia_screen_view.bottom = SCREEN_HEIGHT_FULL ;
    }
    return _specia_screen_view ;
}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr ;
}

-(CFMExDiamondAndBagDiamond *)diamondVie
{
    if (!_diamondVie) {
        _diamondVie = [[[NSBundle mainBundle] loadNibNamed:@"CFMExDiamondAndBagDiamond" owner:nil options:nil] lastObject];
        _diamondVie.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_diamondVie setFrame:CGRectMake(0, 80, SCREEN_WIDTH, 230)];
    }
    return _diamondVie;
}

-(CFMExDiamondAndBagPackage *)bagVie
{
    if (!_bagVie) {
        _bagVie = [[[NSBundle mainBundle] loadNibNamed:@"CFMExDiamondAndBagPackage" owner:nil options:nil] lastObject];
        _bagVie.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_bagVie setFrame:CGRectMake(0, 80, SCREEN_WIDTH, 230)];
        _bagVie.tf.delegate = self ;
    }
    return _bagVie;
}

#pragma mark -
#pragma mark --- ibaction
- (IBAction)closeAc:(id)sender {
    [self hideView];
}

- (IBAction)ac1:(id)sender {
    [self.btn1 setTitleColor:BaseMainColor forState:UIControlStateNormal];
    self.mark.centerX = SCREENWIDTH / 4.0 ;
    [self.btn2 setTitleColor:HexColorDy(@"333333") forState:UIControlStateNormal];
    
    self.vcType = 1;
    self.diamondVie.hidden = NO;
    self.bagVie.hidden = YES;
}

- (IBAction)ac2:(id)sender {
    [self.btn2 setTitleColor:BaseMainColor forState:UIControlStateNormal];
    self.mark.centerX = SCREENWIDTH / 4.0 * 3.0 ;
    [self.btn1 setTitleColor:HexColorDy(@"333333") forState:UIControlStateNormal];
    
    self.vcType = 2;
    self.diamondVie.hidden = YES;
    self.bagVie.hidden = NO;
}

- (IBAction)sureAc:(id)sender {
    if (self.vcType == 2) {
        [self giftExchangeToCoin:NO];
        return;
    }
    
    WeakSelf
    if (self.diamondVie.tf.text.floatValue <= 0) {
        [SVProgressHUD showTextHUDWithMessage:@"请输入兑换数量"];
        return;
    }
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"diamond"] = self.diamondVie.tf.text;
    [FFHomeHandel customeOprHandle:parameter apiStr:user_diamondChangeRatioCoin success:^(BaseModel *info) {
        [SVProgressHUD showTextHUDWithMessage:@"成功"];
        if (wself.fetchRefresh) {
            wself.fetchRefresh();
        }
        [wself hideView];
    } failure:^{
        
    }];
}

#pragma mark -
#pragma mark --- Method
- (void)show
{
    UIViewController *topVC = [Common getCurrentVC];
    UIView *window = topVC ? topVC.view : [UIApplication sharedApplication].keyWindow;
    [self showOnview:window];
}

- (void)showOnview:(UIView *)window
{
    if (!window) {
        window = [UIApplication sharedApplication].keyWindow;
    }
    [window addSubview:self.maskView];
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
    if (IS_iPhoneX) {
        [window addSubview:self.specia_screen_view];
        [window insertSubview:self.specia_screen_view belowSubview:self];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self setBottom:SCREEN_HEIGHT];
    } completion:^(BOOL finished) {

    }];
    
    [self fetchBalance];
    [self fetchRateConfig];
    [self fetchMyBagGiftList];
}

- (void)hideView {
    [self.keyboardShowDisposable dispose];
    [self.keyboardHideDisposable dispose];
    
    [UIView animateWithDuration:0.15 animations:^{
        [self setTop:SCREEN_HEIGHT + 60];
    } completion:^(BOOL finished) {
        [self->_maskView removeFromSuperview];
        self->_maskView.hidden = YES ;
        self->_specia_screen_view.hidden = YES ;
        [self->_specia_screen_view removeFromSuperview];
        [self removeFromSuperview];
    }];
}

/** 获取余额等*/
- (void)fetchBalance
{
    WeakSelf
    [NetworkRequest POST:user_getMoney parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        if ([baseModel.data isKindOfClass:[NSDictionary class]]) {
            wself.balanceInfo = (NSDictionary *)baseModel.data;
            NSString *diamond = FORMAT(wself.balanceInfo[@"diamond"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.diamondVie.balance.text = [NSString stringWithFormat:@"当前钻石余额：%.2f", diamond.floatValue];
            });
        }
    } failture:^(NSError *error) {
        
    }];
}

/** 获取配置比例等*/
- (void)fetchRateConfig
{
    WeakSelf
    [NetworkRequest POST:index_config parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        if ([baseModel.data isKindOfClass:[NSDictionary class]]) {
            NSString *diamond_change_ratio_coin = FORMAT(baseModel.data[@"diamond_change_ratio_coin"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.diamondVie.tip.text = [NSString stringWithFormat:@"钻石：黑曜石=1:%@", diamond_change_ratio_coin];
            });
        }
    } failture:^(NSError *error) {
        
    }];
}

/** 获取背包礼物列表*/
- (void)fetchMyBagGiftList
{
    WeakSelf
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"page"] = @"1";
    parameter[@"size"] = @"100";
    parameter[@"is_send"] = @"1";
    if ([NSString NotNull:UserDefaultsGet(kToken)]) {
        parameter[@"token"] = UserDefaultsGet(kToken);
    }
    [FFHomeHandel fetchPackageGiftList:parameter success:^(NSMutableArray *dataArr, NSString *pageNo, BOOL hasNextPage) {
        wself.dataArr = dataArr;
        dispatch_async(dispatch_get_main_queue(), ^{
            wself.bagVie.limitArr = wself.dataArr;
            if (wself.dataArr.count > 0) {
                wself.packageGiftIndex = 0;
                id item = wself.dataArr[0];
                if ([item isKindOfClass:[GoodListInfoModel class]]) {
                    GoodListInfoModel *model = (GoodListInfoModel *)item;
                    wself.bagVie.tip.text = [NSString stringWithFormat:@"可兑换黑曜石：%d", model.exchange_num];
                } else if ([item isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = (NSDictionary *)item;
                    wself.bagVie.tip.text = [NSString stringWithFormat:@"可兑换黑曜石：%@", FORMAT(dict[@"exchange_num"] ?: @"0")];
                }
            }
        });
    } failure:^{
        
    }];
}

/** 兑换背包礼物为黑曜石*/
- (void)giftExchangeToCoin:(BOOL)isGetCoin
{
    if (self.packageGiftIndex >= self.dataArr.count) {
        [SVProgressHUD showTextHUDWithMessage:@"请选择要兑换的礼物"];
        return;
    }
    if (self.bagVie.tf.text.floatValue <= 0) {
        [SVProgressHUD showTextHUDWithMessage:@"请输入兑换数量"];
        return;
    }
    
    id giftObj = self.dataArr[self.packageGiftIndex];
    NSString *giftID = @"";
    if ([giftObj isKindOfClass:[GoodListInfoModel class]]) {
        GoodListInfoModel *model = (GoodListInfoModel *)giftObj;
        if (model.gift_id > 0) {
            giftID = [NSString stringWithFormat:@"%d", model.gift_id];
        } else if (model.ID.length > 0) {
            giftID = FORMAT(model.ID);
        } else if (model.knapsack_id.length > 0) {
            giftID = FORMAT(model.knapsack_id);
        }
    } else if ([giftObj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)giftObj;
        giftID = FORMAT(dict[@"gift_id"] ?: dict[@"id"] ?: dict[@"knapsack_id"]);
    }
    
    if (giftID.length == 0 || [giftID isEqualToString:@"0"]) {
        [SVProgressHUD showTextHUDWithMessage:@"请选择要兑换的礼物"];
        return;
    }
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"knapsack_id"] = giftID;
    parameter[@"nums"] = self.bagVie.tf.text;
    if ([NSString NotNull:UserDefaultsGet(kToken)]) {
        parameter[@"token"] = UserDefaultsGet(kToken);
    }
    WeakSelf
    [FFHomeHandel customeOprHandle:parameter apiStr:gift_bagGiftExchangeRatioCoin success:^(BaseModel *info) {
        [SVProgressHUD showTextHUDWithMessage:@"成功"];
        if (wself.fetchRefresh) {
            wself.fetchRefresh();
        }
        [wself hideView];
    } failure:^{
        
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}
@end
