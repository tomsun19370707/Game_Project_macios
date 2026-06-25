//
//  STWithdrawVc.m
//
//  类介绍说明：
//
//

#import "CFMWalletDiamondRechargeVc.h"
// DTO
#import "JYYSPayManger.h"
// View
#import "STRechargeINput.h"
#import "STRechargeLab.h"
#import "CFMWalletDiamondRechargeHeader.h"
#import "CFMWalletRewardHisSection.h"
// 下级控制器
#import "CFMWalletDiamondSumVc.h"
@interface CFMWalletDiamondRechargeVc ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
/** table */
@property (strong, nonatomic) UITableView *listTableview;
/** 分页上拉和下拉刷新*/
/** 数据源*/
@property (nonatomic,strong) NSMutableArray *dataArr;
/** 页码*/
@property (nonatomic,strong) NSString *pageNo;
/** 是否有下一页*/
@property (nonatomic,assign) BOOL hasNextPage;
/** 数据筛选字典*/
@property (nonatomic,strong) NSMutableDictionary *parameter;
/** bo*/
@property (nonatomic,strong) TKBottomView *bottomView ;
/** input*/
@property (nonatomic,strong) STRechargeINput *inputVie;
/** 选中的方式 0微信 1支付宝*/
@property (nonatomic,assign) NSUInteger typeIndex;
/** his*/
@property (nonatomic,strong) UIButton *hisBtn;
/** bg*/
@property (nonatomic,strong) UIImageView *bg ;
/** 余额信息*/
@property (nonatomic,strong) NSDictionary *balanceInfo;
/** 选择的充值档位*/
@property (nonatomic,strong) NSDictionary *chargeInfo;
@end

@implementation CFMWalletDiamondRechargeVc

#pragma mark -
#pragma mark --- 加载控制器
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /** 获取余额等*/
    [self fetchBalance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // NavBar
    [self initNavBar];
    // 布局视图
    [self initContentView];
    // Rac
    [self initRacChain];
    // 网络请求
    [self initRequestData];
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
    return 0.000001 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==3) {
        return 10;
    }
    return  0.000001;
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
    
    if (indexPath.section>=3) {
        self.typeIndex = indexPath.section -3 ;
        /** 刷新*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listTableview reloadData];
        });
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        CFMWalletDiamondRechargeHeader *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMWalletDiamondRechargeHeader"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMWalletDiamondRechargeHeader" owner:self options:nil]lastObject];
        }
        NSString *diamond = self.balanceInfo[@"diamond"];
        cell.diamond.text = FORMAT_TYPE(@"%.2f", diamond.floatValue);
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell ;
    }
    
    if (indexPath.section== 1) {
        if (self.dataArr.count==0) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            [cell.contentView setHeight:0.00001];
            return cell;
        }
        self.inputVie.limitArr = self.dataArr;
        return self.inputVie ;
    }
    
    if (indexPath.section==2) {
        /** 支付方式*/
        CFMWalletRewardHisSection *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMWalletRewardHisSection"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMWalletRewardHisSection" owner:self options:nil]lastObject];
        }
        cell.title.text = @"支付方式";
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell ;
    }
    
    
    STRechargeLab *cell = [tableView dequeueReusableCellWithIdentifier:@"STRechargeLab"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"STRechargeLab" owner:self options:nil]lastObject];
    }
    if (indexPath.section==3) {
        cell.icon.image = IMAGE(@"wechatPayImg");
        cell.lab.text = @"微信支付";
    }else  if (indexPath.section==4) {
        cell.icon.image = IMAGE(@"aliPayImg");
        cell.lab.text = @"支付宝支付";
    }
    if (self.typeIndex==indexPath.section-3) {
        cell.selIcon.image = IMAGE(@"pay_select_ed");
    }else{
        cell.selIcon.image = IMAGE(@"pay_select_un");
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1 || indexPath.section==3 || indexPath.section==4) {
        [cell setRoundCorner:tableView indexPath:indexPath];
    }
}
#pragma mark -
#pragma mark DZNEmptyDataSetSource（数据源代理）
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"list_no_data"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无数据~~~";
    NSDictionary *attributes = @{NSFontAttributeName:PingFangFONT(14), NSForegroundColorAttributeName:UIColorFromRGB(0x999999)};
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

#pragma mark -
#pragma mark DZNEmptyDataSetDelegate（操作代理）
/** 响应按钮点击事件 */
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self.listTableview.mj_header beginRefreshing];
}

#pragma mark -
#pragma mark --- 导航初始化
- (void)initNavBar {
    self.navigationBar.title = @"钻石充值";
    self.navigationBar.type = BaseNavBarTypeDarkMode ;
    self.navigationBar.backgroundColor = UIColor.clearColor ;
    self.navigationBar.rightBarItem = self.hisBtn ;
}

#pragma mark -
#pragma mark --- 创建控件
- (void)initContentView {
    self.view.backgroundColor = LineColor ;
    self.typeIndex = 0 ;
    [self.view addSubview:self.bg];
    [self.view addSubview:self.bottomView];
    /** tab */
    [self.view addSubview:self.listTableview];
}

#pragma mark -
#pragma mark --- Rac方法
- (void)initRacChain {
    @weakify(self);
    [[self.hisBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        CFMWalletDiamondSumVc *sun = [[CFMWalletDiamondSumVc alloc]init];
        [self.navigationController pushViewController:sun animated:YES];
    }];
    
    /** 充值*/
    [[self.bottomView.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (!self.chargeInfo) {
            [SVProgressHUD showTextHUDWithMessage:@"请选择充值档位"];
            return;
        }
        /** 充值下单*/
        /** para*/
        NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
        parameter[@"config_id"] = FORMAT(self.chargeInfo[@"id"]);
        /** 支付类型 wechat 微信 alipay支付宝*/
        if (self.typeIndex==0) {
            parameter[@"pay_type"] = @"wechat";
        }else  if (self.typeIndex==1) {
            parameter[@"pay_type"] = @"alipay";
        }
        [FFHomeHandel customeOprHandle:parameter apiStr:user_rechargeDiamond success:^(BaseModel *info) {
            
            if (self.typeIndex==0) {
                /** wechat*/
                /** 赋值 调起微信支付*/
                JYYSPayManger *manger = [JYYSPayManger sharedPayManger];
                [manger WechatPayment:info.data];
            }else  if (self.typeIndex==1) {
                /** alipay*/
                JYYSPayManger *manger = [JYYSPayManger sharedPayManger];
                /** 发起支付*/
                [manger ALiPayPayment:info.data];
            }
            
        } failure:^{
            
        }];
    }];
    
    WeakSelf
    self.inputVie.fetchMoneyDone = ^(NSDictionary *model) {
        wself.chargeInfo = model;
        /** 设置底部支付价格*/
        [wself setBoPrice];
    };
}

#pragma mark -
#pragma mark --- 网络请求
- (void)initRequestData {
    /** 获取充值金额列表*/
    [self fetchRechargeRank];
}

#pragma mark -
#pragma mark --- Getter
- (UITableView *)listTableview
{
    if (!_listTableview) {
        _listTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavBarHeight - self.bottomView.height) style:UITableViewStyleGrouped];
        _listTableview.delegate =self;
        _listTableview.dataSource =self;
        _listTableview.showsVerticalScrollIndicator = NO;
        _listTableview.backgroundColor = UIColor.clearColor ;
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
        _listTableview.bounces = NO ;
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
-(NSMutableDictionary *)parameter
{
    if (!_parameter) {
        _parameter = [NSMutableDictionary dictionary];
        _parameter[@"pageSize"] = @"10";
    }
    return _parameter ;
}
-(TKBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[[NSBundle mainBundle] loadNibNamed:@"TKBottomView" owner:self options:nil]lastObject];
        [_bottomView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _bottomView.contentView.height)];
        [_bottomView.btn setTitle:@"确认支付0元" forState:UIControlStateNormal];
        _bottomView.bottom = SCREEN_HEIGHT_dy ;
    }
    return _bottomView ;
}
-(STRechargeINput *)inputVie
{
    if (!_inputVie) {
        _inputVie = [[[NSBundle mainBundle] loadNibNamed:@"STRechargeINput" owner:self options:nil]lastObject];
        _inputVie.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_inputVie setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _inputVie.contentView.height)];
    }
    return _inputVie;
}
-(UIImageView *)bg
{
    if (!_bg) {
        _bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
        _bg.image = IMAGE(@"waller_diamond_bg");
        _bg.contentMode = UIViewContentModeScaleAspectFill;
        CGFloat temp = 230.0 / 375.0;
        _bg.height = SCREEN_WIDTH * temp ;
    }
    return _bg;
}
-(UIButton *)hisBtn
{
    if (!_hisBtn) {
        _hisBtn = [UIButton racButtonWithTitle:@"明细" BGImage:nil frame:CGRectMake(0, 0, 55, 35) fontSize:13 titleColor:UIColor.whiteColor];
    }
    return _hisBtn;
}
#pragma mark --
#pragma mark --- Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/** 获取充值金额列表*/
- (void)fetchRechargeRank
{
    WeakSelf
    /** para*/
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    parameter[@"page_size"] = @"1000";
    parameter[@"page"] = @"1";
    [FFHomeHandel customeNoPageListRequestHandle:parameter apiStr:user_rechargeDiamondConfigList success:^(NSMutableArray <NSDictionary *> *dataArr) {
        wself.dataArr = dataArr ;
        /** 默认选择*/
        if (dataArr.count > 0) {
            wself.chargeInfo = dataArr[0];
            /** 设置底部支付价格*/
            [wself setBoPrice];
        }
        /** 刷新*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.listTableview reloadData];
        });
    } failure:^{
        
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

/** 设置底部支付价格*/
- (void)setBoPrice
{
    NSString *price = self.chargeInfo[@"price"];
    [self.bottomView.btn setTitle:[NSString stringWithFormat:@"确认支付%.2f元",price.floatValue] forState:UIControlStateNormal];
}
@end
