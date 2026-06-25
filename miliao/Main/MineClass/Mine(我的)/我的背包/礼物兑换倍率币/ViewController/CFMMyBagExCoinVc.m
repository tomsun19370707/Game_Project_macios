//
//  CFMWalletDiamondExReCoinVc.m
//
//  类介绍说明：
//
//

#import "CFMMyBagExCoinVc.h"
// DTO

// View
#import "CFMMyBagExCoinInput.h"
// 下级控制器

@interface CFMMyBagExCoinVc ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource,UITextFieldDelegate>
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
@property (nonatomic,strong) CFMMyBagExCoinInput *inputVie;
@end

@implementation CFMMyBagExCoinVc

#pragma mark -
#pragma mark --- 加载控制器
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    self.inputVie.model = self.giftInfo ;
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
    self.navigationBar.title = @"兑换黑曜石";
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
    [[self.bottomView.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        /** 获取礼物可兑换的 黑曜石数量  或者是  兑换黑曜石*/
        [wself giftExchangeToCoin:NO];
    }];
}

#pragma mark -
#pragma mark --- 网络请求
- (void)initRequestData {
    
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
-(CFMMyBagExCoinInput *)inputVie
{
    if (!_inputVie) {
        _inputVie = [[[NSBundle mainBundle] loadNibNamed:@"CFMMyBagExCoinInput" owner:self options:nil]lastObject];
        _inputVie.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_inputVie setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _inputVie.contentView.height)];
        _inputVie.tf.delegate = self ;
    }
    return _inputVie;
}
#pragma mark --
#pragma mark --- Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/** 获取礼物可兑换的 黑曜石数量  或者是  兑换黑曜石*/
- (void)giftExchangeToCoin:(BOOL)isGetCoin
{
    if (self.inputVie.tf.text.floatValue <=0) {
        [SVProgressHUD showTextHUDWithMessage:@"请输入兑换数量"];
        return;
    }
    /** 当前选择的礼物*/
    GoodListInfoModel *gift = self.giftInfo ;
    /** para*/
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    parameter[@"knapsack_id"] = FORMAT(gift.ID);
    parameter[@"nums"] = self.inputVie.tf.text;
    if (isGetCoin) {
        parameter[@"get_ratio_coin"] = @"1";
    }
    WeakSelf
    [FFHomeHandel customeOprHandle:parameter apiStr:gift_bagGiftExchangeRatioCoin success:^(BaseModel *info) {
        if (isGetCoin) {
            wself.inputVie.avaNum.text =[ NSString stringWithFormat:@"可兑换黑曜石 %.2f",0.0];
        }else{
            /** 这是兑换*/
            [SVProgressHUD showTextHUDWithMessage:@"成功"];
            [ObjectTool performSelectorAfterDelay:ALERT_MESSAGE_DISPLAY_INTERVAL completion:^{
                [wself back];
            }];
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
