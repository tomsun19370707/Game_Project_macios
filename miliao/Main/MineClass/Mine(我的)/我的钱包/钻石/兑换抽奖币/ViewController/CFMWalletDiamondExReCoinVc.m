//
//  CFMWalletDiamondExReCoinVc.m
//
//  类介绍说明：
//
//

#import "CFMWalletDiamondExReCoinVc.h"
// DTO

// View
#import "CFMWalletDiamondExReCoinInput.h"
// 下级控制器

@interface CFMWalletDiamondExReCoinVc ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
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
@property (nonatomic,strong) CFMWalletDiamondExReCoinInput *inputVie;
/** 余额等相关信息*/
@property (nonatomic,strong) NSDictionary *balanceInfo;
@end

@implementation CFMWalletDiamondExReCoinVc

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
    return 10 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001 ;
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
    return self.inputVie;
    
    //    <#TableViewCell#> *cell = [tableView dequeueReusableCellWithIdentifier:@"<#TableViewCell#>"];
    //    if (cell == nil) {
    //        cell = [[[NSBundle mainBundle] loadNibNamed:@"<#TableViewCell#>" owner:self options:nil]lastObject];
    //    }
    //    if (self.dataArr.count != 0) {
    ////        cell.model = self.dataArr[indexPath.row];
    //    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    //    return cell ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setRoundCorner:tableView indexPath:indexPath];
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
    self.navigationBar.title = @"兑换紫金";
    if (self.vcType==2) {
        self.navigationBar.title = @"兑换黑曜石";
    }else if (self.vcType==3) {
        self.navigationBar.title = @"兑换钻石金币";
    }
}

#pragma mark -
#pragma mark --- 创建控件
- (void)initContentView {
    [self.view addSubview:self.bottomView];
    /** tab */
    [self.view addSubview:self.listTableview];
}

#pragma mark -
#pragma mark --- Rac方法
- (void)initRacChain {
    WeakSelf
    /** 兑换*/
    [[self.bottomView.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {

        if (self.inputVie.tf.text.floatValue <= 0) {
            [SVProgressHUD showTextHUDWithMessage:@"请输入兑换数量"];
            return;
        }
        /** para*/
        NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
        NSString *apiStr;
        switch (self.vcType) {
            case 1:
                {
                    apiStr = user_diamondChangeLotteryCoin;
                    parameter[@"diamond"] = self.inputVie.tf.text;
                }
                break;
            case 2:
                {
                    apiStr = user_diamondChangeRatioCoin;
                    parameter[@"diamond"] = self.inputVie.tf.text;
                }
                break;   
            case 3:
                {
                    apiStr = user_moneyChangeDiamond;
                    parameter[@"money"] = self.inputVie.tf.text;
                }
                break; 
            default:
                break;
        }
        [FFHomeHandel customeOprHandle:parameter apiStr:apiStr success:^(BaseModel *info) {
            [SVProgressHUD showTextHUDWithMessage:@"成功"];
            /** 获取余额等*/
            [self fetchBalance];
        } failure:^{
            
        }];
    }];
}

#pragma mark -
#pragma mark --- 网络请求
- (void)initRequestData {
    /** 获取配置比例等*/
    [self fetchRateConfig];
}

#pragma mark -
#pragma mark --- Getter
- (UITableView *)listTableview
{
    if (!_listTableview) {
        _listTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT_dy - NavBarHeight - self.bottomView.height) style:UITableViewStyleGrouped];
        _listTableview.delegate =self;
        _listTableview.dataSource =self;
        _listTableview.showsVerticalScrollIndicator = NO;
        _listTableview.backgroundColor = LineColor ;
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
        [_bottomView.btn setTitle:@"确认兑换" forState:UIControlStateNormal];
        _bottomView.selectionStyle = UITableViewCellSelectionStyleNone ;
        _bottomView.bottom = SCREEN_HEIGHT_dy ;
    }
    return _bottomView ;
}
-(CFMWalletDiamondExReCoinInput *)inputVie
{
    if (!_inputVie) {
        _inputVie = [[[NSBundle mainBundle] loadNibNamed:@"CFMWalletDiamondExReCoinInput" owner:self options:nil]lastObject];
        _inputVie.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_inputVie setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _inputVie.contentView.height)];
        
        // 对标 Android 提交 29：模式显隐隔离 (仅在 vcType == 3 金币兑换钻石时显示，其它模式隐藏保持原貌)
        if (self.vcType == 3) {
            _inputVie.exchangeAllBtn.hidden = NO;
            @weakify(self);
            [[_inputVie.exchangeAllBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                NSString *money = self.balanceInfo[@"money"];
                if (money.length > 0) {
                    self.inputVie.tf.text = [NSString stringWithFormat:@"%.2f", money.floatValue];
                    
                    // 平滑光标移动至末尾
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UITextPosition *endPos = [self.inputVie.tf endOfDocument];
                        self.inputVie.tf.selectedTextRange = [self.inputVie.tf textRangeFromPosition:endPos toPosition:endPos];
                    });
                }
            }];
        } else {
            _inputVie.exchangeAllBtn.hidden = YES;
        }
    }
    return _inputVie;
}
#pragma mark --
#pragma mark --- Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/** 获取余额等*/
- (void)fetchBalance
{
    WeakSelf
    [NetworkRequest POST:user_getMoney parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        wself.balanceInfo = baseModel.data ;

        if (self.vcType==1) {
            NSString *diamond = wself.balanceInfo[@"diamond"];
            wself.inputVie.balance.text = [NSString stringWithFormat:@"当前钻石余额：%.2f",diamond.floatValue];
        }else if (self.vcType==2) {
            NSString *diamond = wself.balanceInfo[@"diamond"];
            wself.inputVie.balance.text = [NSString stringWithFormat:@"当前钻石余额：%.2f",diamond.floatValue];
        }else if (self.vcType==3) {
            NSString *money = wself.balanceInfo[@"money"];
            wself.inputVie.balance.text = [NSString stringWithFormat:@"当前金币余额：%.2f",money.floatValue];
        }
        
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
        
        if (self.vcType==1) {
            wself.inputVie.tip.text = [NSString stringWithFormat:@"钻石：紫金=1:%@",diamond_change_lottery_coin];
        }else if (self.vcType==2) {
            wself.inputVie.tip.text = [NSString stringWithFormat:@"钻石：黑曜石=1:%@",diamond_change_ratio_coin];
        }else if (self.vcType==3) {
            wself.inputVie.tip.text = [NSString stringWithFormat:@"金币：钻石=1:%@",money_change_diamond];
        }
        
    } failture:^(NSError *error) {
        
    }];
}
@end


