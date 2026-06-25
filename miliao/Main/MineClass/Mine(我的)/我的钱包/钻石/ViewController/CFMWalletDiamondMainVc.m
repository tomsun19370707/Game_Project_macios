//
//  STWithdrawVc.m
//
//  类介绍说明：
//
//

#import "CFMWalletDiamondMainVc.h"
// DTO
// View
#import "CFMWalletDiamondRechargeHeader.h"
#import "CFMWalletDiamondMainCell.h"
#import "CFMWalletDiamondMainSign.h"
// 下级控制器
#import "CFMWalletDiamondRechargeVc.h"
#import "CFMWalletDiamondExReCoinVc.h"
@interface CFMWalletDiamondMainVc ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
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
/** bg*/
@property (nonatomic,strong) UIImageView *bg ;
/** 余额信息*/
@property (nonatomic,strong) NSDictionary *balanceInfo;
/** 是否签到*/
@property (nonatomic,strong) NSDictionary *signInfo;
@end

@implementation CFMWalletDiamondMainVc

#pragma mark -
#pragma mark --- 加载控制器
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /** 获取余额等*/
    [self fetchBalance];
    /** 判断今日是否签到*/
    [self judgeTodaySignHandle];
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
    if (section>=1) {
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
    
    switch (indexPath.section) {
        case 2:
            {
                /** 充值*/
                CFMWalletDiamondRechargeVc *re = [[CFMWalletDiamondRechargeVc alloc]init];
                [self.navigationController pushViewController:re  animated:YES];
            }
            break;
        case 3:
            {
                /** 兑换紫金*/
                CFMWalletDiamondExReCoinVc *re = [[CFMWalletDiamondExReCoinVc alloc]init];
                re.vcType = 1 ;
                [self.navigationController pushViewController:re  animated:YES];
            }
            break; 
        case 4:
            {
                /** 兑换黑曜石*/
                CFMWalletDiamondExReCoinVc *re = [[CFMWalletDiamondExReCoinVc alloc]init];
                re.vcType = 2 ;
                [self.navigationController pushViewController:re  animated:YES];
            }
            break;
        default:
            break;
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
        CFMWalletDiamondMainSign *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMWalletDiamondMainSign"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMWalletDiamondMainSign" owner:self options:nil]lastObject];
        }
        /** 是否可签到*/
        NSString *is_signed_user = self.signInfo[@"is_signed_user"];
        cell.cansSign = !is_signed_user.boolValue ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell ;
    }
    
    
    CFMWalletDiamondMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMWalletDiamondMainCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMWalletDiamondMainCell" owner:self options:nil]lastObject];
    }
    if (indexPath.section==2) {
        cell.title.text = @"充值";
    }else  if (indexPath.section==3) {
        cell.title.text = @"兑换紫金";
    }else  if (indexPath.section==4) {
        cell.title.text = @"兑换黑曜石";
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
    if (indexPath.section>=1) {
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
    self.navigationBar.title = @"钻石";
    self.navigationBar.type = BaseNavBarTypeDarkMode ;
    self.navigationBar.backgroundColor = UIColor.clearColor ;
}

#pragma mark -
#pragma mark --- 创建控件
- (void)initContentView {
    self.view.backgroundColor = LineColor ;
    [self.view addSubview:self.bg];
    /** tab */
    [self.view addSubview:self.listTableview];
}

#pragma mark -
#pragma mark --- Rac方法
- (void)initRacChain {
  
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
        _listTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT_FULL - NavBarHeight) style:UITableViewStyleGrouped];
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
        /** 刷新*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.listTableview reloadData];
        });
    } failture:^(NSError *error) {
        
    }];
}

/** 判断今日是否签到*/
- (void)judgeTodaySignHandle
{
    if (![UserManager userInfo].user_id) {
        return;
    }
    WeakSelf
    [NetworkRequest POST:user_check_today parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        DLog(@"%@",responObject);
        
        wself.signInfo = baseModel.data ;
        /** 刷新*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.listTableview reloadData];
        });

    } failture:^(NSError *error) {
        
    }];
}
@end
