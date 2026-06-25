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
@interface CFMExDiamondAndBagAlert ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource,UITextFieldDelegate>
/** table */
@property (strong, nonatomic) UITableView *listTableview;
/** 分页上拉和下拉刷新*/
/** 数据源*/
@property (nonatomic,strong) NSMutableArray *dataArr;
/** View */
/** maskview*/
@property (nonatomic,strong) UIView *maskView;
/** 异形屏，底部tab不可控区域*/
@property (nonatomic,strong)UIView *specia_screen_view;
/** View */
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
@end

@implementation CFMExDiamondAndBagAlert

#pragma mark -
#pragma mark --- init
-(instancetype)init
{
    self = [super init];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- init frame
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- 初始化view
- (void)initContentview
{
    self.packageGiftIndex = 0 ;
    
    [self.btn makeRoundCorner];
    [self setFrame:CGRectMake(0, SCREEN_HEIGHT_FULL + 60, SCREEN_WIDTH, self.contentView.height + 200)];
    [self makeCornerAt:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:15];
    
    [self.contentView addSubview:self.listTableview];
}
#pragma mark -
#pragma mark --- tableviewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataArr.count != 0) {
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_vcType==2) {
        /** 背包*/
        self.bagVie.limitArr = self.dataArr;
        return self.bagVie ;
    }
    
    
    /** 钻石*/
    NSString *diamond = self.balanceInfo[@"diamond"];
    self.diamondVie.balance.text = [NSString stringWithFormat:@"当前钻石余额：%.2f",diamond.floatValue];
    return self.diamondVie ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    /** 初始化*/
    [self initContentview];
    /** RAC*/
    [self initRacChain];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark --- Rac
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
            [self setBottom:(SCREEN_HEIGHT_FULL - height)];
            self.keyboardHeight = height ;
            DLog(@"\n+++++++++%f",height);
        }
    }];
    
    /** 键盘消失*/
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        self.keyboardHeight = 0.0 ;
        [self setBottom:SCREEN_HEIGHT_FULL];
    }];
    
    /** 背包礼物切换的时候*/
    WeakSelf
    self.bagVie.fetchClick = ^(NSInteger selIndex) {
        wself.packageGiftIndex = selIndex ;
        /** 获取礼物可兑换的 黑曜石数量  或者是  兑换黑曜石*/
        [wself giftExchangeToCoin:YES];
    };
}

#pragma mark -
#pragma mark --- Getter
-(UIView *)maskView
{
    if (!_maskView) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        /** 遮罩视图*/
        UIView *backgroundView = [[UIView alloc] initWithFrame:window.bounds];
        //        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
//        backgroundView.userInteractionEnabled = YES;
//        backgroundView.multipleTouchEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
//        [backgroundView addGestureRecognizer:tap];
//        @weakify(self);
//        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
//            @strongify(self);
//            [self hideView];
//        }];
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
- (UITableView *)listTableview
{
    if (!_listTableview) {
        _listTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, self.height - 160) style:UITableViewStyleGrouped];
        _listTableview.delegate =self;
        _listTableview.dataSource =self;
        _listTableview.showsVerticalScrollIndicator = NO;
        _listTableview.backgroundColor = UIColor.clearColor;
        _listTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableview.estimatedRowHeight = 0;
        _listTableview.estimatedSectionFooterHeight = 0;
        _listTableview.estimatedSectionHeaderHeight = 0;
        if (@available(iOS 11.0, *)) {
            _listTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        /** 无数据默认图*/
        _listTableview.emptyDataSetSource = self ;
        _listTableview.emptyDataSetDelegate = self ;
    }
    return _listTableview ;
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
        _diamondVie = [[[NSBundle mainBundle] loadNibNamed:@"CFMExDiamondAndBagDiamond" owner:self options:nil]lastObject];
        _diamondVie.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_diamondVie setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _diamondVie.contentView.height)];
    }
    return _diamondVie;
}
-(CFMExDiamondAndBagPackage *)bagVie
{
    if (!_bagVie) {
        _bagVie = [[[NSBundle mainBundle] loadNibNamed:@"CFMExDiamondAndBagPackage" owner:self options:nil]lastObject];
        _bagVie.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_bagVie setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _bagVie.contentView.height)];
        _bagVie.tf.delegate = self ;
    }
    return _bagVie;
}
#pragma mark --
#pragma mark --- Setter

#pragma mark --
#pragma mark --- ibaction
- (IBAction)closeAc:(id)sender {
    [self hideView];
}
- (IBAction)ac1:(id)sender {
    [self.btn1 setTitleColor:BaseMainColor forState:UIControlStateNormal];
    self.mark.centerX = SCREENWIDTH / 4.0 ;
    [self.btn2 setTitleColor:HexColorDy(@"333333") forState:UIControlStateNormal];
    
    self.vcType=1 ;
    /** 刷新*/
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.listTableview reloadData];
    });
}
- (IBAction)ac2:(id)sender {
    [self.btn2 setTitleColor:BaseMainColor forState:UIControlStateNormal];
    self.mark.centerX = SCREENWIDTH / 4.0 * 3.0 ;
    [self.btn1 setTitleColor:HexColorDy(@"333333") forState:UIControlStateNormal];
    
    self.vcType=2 ;
    /** 刷新*/
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.listTableview reloadData];
    });
}
- (IBAction)sureAc:(id)sender {
    
    if (self.vcType==2) {
        /** 获取礼物可兑换的 黑曜石数量  或者是  兑换黑曜石*/
        [self giftExchangeToCoin:NO];
        return;
    }
    
    WeakSelf
    if (self.diamondVie.tf.text.floatValue <= 0) {
        [SVProgressHUD showTextHUDWithMessage:@"请输入兑换数量"];
        return;
    }
    /** 钻石兑换黑曜石*/
    /** para*/
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
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

#pragma mark --
#pragma mark --- Method
- (void)show
{
    UIView *window = [ObjectTool SharedSettings].currentVC.view;
    /** 全部加载到window上*/
    [window addSubview:self];
    [window addSubview:self.maskView];
    [window bringSubviewToFront:self];
    
    if (IS_iPhoneX) {
        [window addSubview:self.specia_screen_view];
        [window insertSubview:self.specia_screen_view belowSubview:self];
    }
    
    /** 弹框动画*/
    [UIView animateWithDuration:0.3 animations:^{
        [self setBottom:SCREEN_HEIGHT];
    }completion:^(BOOL finished) {

    }];
    
    /** 获取余额等*/
    [self fetchBalance];
    /** 获取配置比例等*/
    [self fetchRateConfig];
    /** 获取背包礼物列表*/
    [self fetchMyBagGiftList];
}
- (void)showOnview:(UIView *)window
{
//    UIView *window = [ObjectTool SharedSettings].currentVC.view;
    /** 全部加载到window上*/
    [window addSubview:self];
    [window addSubview:self.maskView];
    [window bringSubviewToFront:self];
    
    if (IS_iPhoneX) {
        [window addSubview:self.specia_screen_view];
        [window insertSubview:self.specia_screen_view belowSubview:self];
    }
    
    /** 弹框动画*/
    [UIView animateWithDuration:0.3 animations:^{
        [self setBottom:SCREEN_HEIGHT];
    }completion:^(BOOL finished) {

    }];
    
    /** 获取余额等*/
    [self fetchBalance];
    /** 获取配置比例等*/
    [self fetchRateConfig];
    /** 获取背包礼物列表*/
    [self fetchMyBagGiftList];
}
- (void)hideView{
    [UIView animateWithDuration:0.15 animations:^{
        [self setTop:SCREEN_HEIGHT + 60];
    }completion:^(BOOL finished) {
        [self->_maskView removeFromSuperview];
        self->_maskView.hidden = YES ;
        self->_specia_screen_view.hidden = YES ;
        [self->_specia_screen_view removeFromSuperview];
        [self removeAllSubviews];
        [self removeFromSuperview];
    }];
}

/** 获取余额等*/
- (void)fetchBalance
{
    WeakSelf
    [NetworkRequest POST:user_getMoney parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        wself.balanceInfo = baseModel.data ;
        /** 刷新*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.listTableview reloadData];
        });
    } failture:^(NSError *error) {
        
    }];
}

/** 获取配置比例等*/
- (void)fetchRateConfig
{
    WeakSelf
    [NetworkRequest POST:index_config parmeters:nil success:^(id responObject) {
        
        BaseModel *baseModel = (BaseModel *)responObject;
        
        /** 1个钻石可以兑换多少个紫金*/
        NSString *diamond_change_lottery_coin = baseModel.data[@"diamond_change_lottery_coin"];
        /** 1个钻石可以兑换多少个黑曜石*/
        NSString *diamond_change_ratio_coin = baseModel.data[@"diamond_change_ratio_coin"];
        /** 1金币可以兑换多少钻石*/
        NSString *money_change_diamond = baseModel.data[@"money_change_diamond"];
        
        wself.diamondVie.tip.text = [NSString stringWithFormat:@"钻石：黑曜石=1:%@",diamond_change_ratio_coin];
        
    } failture:^(NSError *error) {
        
    }];
}

/** 获取背包礼物列表*/
- (void)fetchMyBagGiftList
{
    WeakSelf
    /** para*/
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    parameter[@"page"] = @"1";
    parameter[@"size"] = @"100";
    /** 可选 1 可以兑换 2 不可兑换*/
    parameter[@"is_send"] = @"1";
    [FFHomeHandel fetchPackageGiftList:parameter success:^(NSMutableArray *dataArr, NSString *pageNo, BOOL hasNextPage) {
        wself.dataArr = dataArr ;
        /** 刷新*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listTableview reloadData];
        });
    } failure:^{
        
    }];
}

/** 获取礼物可兑换的 黑曜石数量  或者是  兑换黑曜石*/
- (void)giftExchangeToCoin:(BOOL)isGetCoin
{
    if (self.packageGiftIndex < self.dataArr.count) {
    }else{
        return;
    }
    if (!isGetCoin) {
        if (self.bagVie.tf.text.floatValue <=0) {
            [SVProgressHUD showTextHUDWithMessage:@"请输入兑换数量"];
            return;
        }
    }else{
        /** 获取可兑换的数量*/
        if (self.bagVie.tf.text.floatValue <=0) {
            return;
        }
    }
    /** 当前选择的礼物*/
    GoodListInfoModel *gift = self.dataArr[self.packageGiftIndex];
    /** para*/
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    parameter[@"knapsack_id"] = FORMAT(gift.ID);
    parameter[@"nums"] = self.bagVie.tf.text;
    if (isGetCoin) {
        parameter[@"get_ratio_coin"] = @"1";
    }
    WeakSelf
    [FFHomeHandel customeOprHandle:parameter apiStr:gift_bagGiftExchangeRatioCoin success:^(BaseModel *info) {
        if (isGetCoin) {
            wself.bagVie.tip.text =[ NSString stringWithFormat:@"可兑换黑曜石 %.2f",0.0];
        }else{
            /** 这是兑换*/
            [SVProgressHUD showTextHUDWithMessage:@"成功"];
            if (wself.fetchRefresh) {
                wself.fetchRefresh();
            }
            [wself hideView];
        }
    } failure:^{
        
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.floatValue > 0) {
        /** 获取礼物可兑换的 黑曜石数量  或者是  兑换黑曜石*/
        [self giftExchangeToCoin:YES];
    }
}
@end

