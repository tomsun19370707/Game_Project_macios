//
//  CFMultiplierGamesVC.m
//  miliao
//
//  Created by xxf on 2026/2/9.
//  Copyright © 2026 EMO. All rights reserved.
//

#import "CFMultiplierGamesVC.h"
// DTO

// View
#import "CFMutiplierGamesResultView.h"
#import "CFMRateRewardHis.h"
#import "CFMRateRewardInput.h"
// 下级控制器

@interface CFMultiplierGamesVC ()<CAAnimationDelegate>
/** DTO */
//@property (nonatomic,strong) <#DTOHandle#> *handle;
/** 底部背景*/
@property (nonatomic,strong) UIImageView *bg;
@property (nonatomic,strong) UIImageView *bg1;
/** 记录*/
@property (nonatomic,strong) CFMRateRewardHis *ruleVie;
/** 底部兑换*/
@property (nonatomic,strong) CFMRateRewardInput *inputVie;
/** 记录键盘高度*/
@property (nonatomic,assign) CGFloat keyboardHeight;
/** 盘详情*/
@property (nonatomic,strong) NSDictionary *panLook;

@end

@implementation CFMultiplierGamesVC

#pragma mark -
#pragma mark 加载控制器
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /** 获取余额等*/
    [self fetchBalance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 布局视图
    [self initContentView];
    // Rac
    [self initRacChain];
    // 网络请求
    [self initRequestData];
}
- (void)showInView:(UIView *)superView {
    [superView addSubview:self.view];
    self.view.mj_y = ScreenHeight;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.mj_y = 0;
    }];
}


#pragma mark -
#pragma mark --- 创建控件
- (void)initContentView {
    self.view.backgroundColor = UIColor.clearColor;
    [self.view addSubview:self.bg];

    [self.bg addSubview:self.ruleVie];
    [self.view addSubview:self.inputVie];
}

#pragma mark -
#pragma mark --- Rac方法
- (void)initRacChain {
    @weakify(self);
    /** 键盘的弹出*/
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        //获取键盘的高度
        NSDictionary *userInfo = [x userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        CGFloat height = keyboardRect.size.height;
        if (self.keyboardHeight != height) {
            [self.inputVie setBottom:(SCREEN_HEIGHT_dy - height)];
            self.keyboardHeight = height ;
            DLog(@"\n+++++++++%f",height);
        }
    }];

    /** 键盘消失*/
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        self.keyboardHeight = 0.0 ;
        [self.inputVie setBottom:SCREEN_HEIGHT_dy];
    }];

    /** 下注*/
    [[self.inputVie.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (!self.panLook) {
            return;
        }
        if (self.inputVie.tf.text.floatValue <= 0) {
            [SVProgressHUD showTextHUDWithMessage:@"请输入下注金额"];
            return;
        }

        [self shakeViewWithTranslation:self.bg1];
    }];

    /** 刷新余额*/
    self.inputVie.fetchRefresh = ^{
        @strongify(self);
        /** 获取余额等*/
        [self fetchBalance];
    };

}


- (void)shakeViewWithTranslation:(UIView *)view  {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];

    // 晃动距离（像素）
    CGFloat distance = 10.0;

    animation.values = @[@0,
                        @(distance),
                        @(-distance),
                        @(distance),
                        @(-distance),
                        @(distance),
                         @(-distance),
                         @(distance),
                         @(-distance),
                         @(distance),
                         @(-distance),
                         @(distance),
                         @(-distance),
                         @(distance),
                         @(-distance),
                         @(distance),
                        @0];

    animation.duration = 1.4;
    animation.removedOnCompletion = YES;

    // 设置代理来处理动画结束回调
    animation.delegate = self;

    [view.layer addAnimation:animation forKey:@"shakeTranslation"];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self bet];
}


- (void)bet {
    /** para*/
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    parameter[@"id"] = self.rewardId;
    parameter[@"amount"] = self.inputVie.tf.text ;

    @weakify(self);
    [NetworkRequest POST:ratio_bet_new parmeters:parameter success:^(BaseModel *responObject) {
        @strongify(self);
        self.inputVie.tf.text = @"";
//            [SVProgressHUD showTextHUDWithMessage:@"下注成功"];
        /** 获取余额等*/
        [self fetchBalance];
        CFMutiplierGamesResultView *view = [[CFMutiplierGamesResultView alloc] initWithFrame:CGRectZero];
        view.numLabel.text = [NSString stringWithFormat:@"%@个", responObject.data[@"win_prize_coin"]];
        view.ratioLabel.text = [NSString stringWithFormat:@"%@倍", responObject.data[@"mult"]];
        [self.view addSubview:view];
    } failture:^(NSError *error) {

    }];
}
#pragma mark -
#pragma mark --- 网络请求
- (void)initRequestData {
    /** 获取固定或者随机倍率盘详情*/
    [self fetchPanInfo];
}

#pragma mark -
#pragma mark --- Getter
-(UIImageView *)bg
{
    if (!_bg) {
        CGFloat height = hh(1046);
        CGFloat top = ScreenHeight - height;
        _bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, top, SCREENWIDTH, height)];
        _bg.image = IMAGE(@"mgame_bg0");
        _bg.userInteractionEnabled = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(hh(64), 0, hh(622), hh(844))];
        self.bg1 = imageView;
        imageView.image = IMAGE(@"mgame_bg1");
        [_bg addSubview:imageView];

        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, hh(120), ScreenWidth, top)];
        [self.view addSubview:tapView];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewtap:)];
        [tapView addGestureRecognizer:tapGestureRecognizer];

    }
    return _bg;
}

- (void)viewtap :(UITapGestureRecognizer *)tap {
    [self hideView];
}
- (void)hideView {
    self.view.hidden = YES;
    [self.view removeFromSuperview];
}
-(CFMRateRewardHis *)ruleVie
{
    if (!_ruleVie) {
        _ruleVie = [[[NSBundle mainBundle] loadNibNamed:@"CFMRateRewardHis" owner:self options:nil]lastObject];
        _ruleVie.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_ruleVie setFrame:CGRectMake(0, 120, _ruleVie.contentView.width, _ruleVie.contentView.height)];
        _ruleVie.right = SCREENWIDTH - 10 ;
    }
    return _ruleVie;
}
-(CFMRateRewardInput *)inputVie
{
    if (!_inputVie) {
        _inputVie = [[[NSBundle mainBundle] loadNibNamed:@"CFMRateRewardInput" owner:self options:nil]lastObject];
        _inputVie.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_inputVie setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _inputVie.contentView.height)];
        _inputVie.bottom = SCREEN_HEIGHT_dy;
        if (self.vcType==2) {
            [_inputVie.sureBtn setBackgroundColor:HexColorDy(@"#FFE68B") forState:UIControlStateNormal];
            [_inputVie.sureBtn setTitleColor:HexColorDy(@"#684084") forState:UIControlStateNormal];
            _inputVie.title.textColor = HexColorDy(@"#E5C8FF");
        }
    }
    return _inputVie;
}

#pragma mark --
#pragma mark --- Method
/** 获取余额等*/
- (void)fetchBalance
{
    WeakSelf
    [NetworkRequest POST:user_getMoney parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        NSDictionary *balanceInfo = baseModel.data ;

        /** 黑曜石*/
        NSString *ratio_coin = balanceInfo[@"ratio_coin"];
        wself.inputVie.balance.text = [NSString stringWithFormat:@"当前黑曜石：%.2f",ratio_coin.floatValue];
        wself.inputVie.balanceWid.constant = [NSString widthForContent:wself.inputVie.balance.text font:wself.inputVie.balance.font] + 3 ;

    } failture:^(NSError *error) {

    }];
}

/** 获取固定或者随机倍率盘详情*/
- (void)fetchPanInfo
{
    /** para*/
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    parameter[@"id"] = self.rewardId;
    WeakSelf
    [NetworkRequest POST:ratio_room_detailNew parmeters:parameter success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        wself.panLook = baseModel.data ;
        /** 规则*/
//        wself.ruleVie.model = wself.panLook ;

    } failture:^(NSError *error) {

    }];



    [NetworkRequest POST:ratio_room_detail parmeters:parameter success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        /** 规则*/
        wself.ruleVie.content = baseModel.data[@"room_info"][@"content"] ;
        wself.ruleVie.ID = self.rewardId;

    } failture:^(NSError *error) {

    }];
}

@end
