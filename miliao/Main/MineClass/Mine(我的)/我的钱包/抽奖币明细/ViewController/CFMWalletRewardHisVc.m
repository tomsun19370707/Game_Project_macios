//
//  CFMWalletRewardHisVc.m
//
//  类介绍说明：
//
//

#import "CFMWalletRewardHisVc.h"
// DTO

// View
#import "CFMWalletRewardHisSection.h"
#import "CFMWalletRewardHisCell.h"
// 下级控制器
#import "CFMWalletDiamondExGiftVc.h"
#import "CFMWalletDiamondExReCoinVc.h"
@interface CFMWalletRewardHisVc ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
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
/** 账户信息*/
@property (nonatomic,strong) NSDictionary *balanceInfo;
/** place*/
@property (nonatomic,strong) DPlaceholder *place ;
@end

@implementation CFMWalletRewardHisVc

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
    return 0.000001 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section>=1) {
        return 10;
    }
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
    @weakify(self);
    if (indexPath.section>=1) {
        /** 明细*/
        CFMWalletRewardHisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMWalletRewardHisCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMWalletRewardHisCell" owner:self options:nil]lastObject];
        }
        if (self.dataArr.count != 0) {
            cell.model = self.dataArr[indexPath.section - 1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell ;
    }
    
    
    /** 顶部的标题*/
    CFMWalletRewardHisSection *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMWalletRewardHisSection"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMWalletRewardHisSection" owner:self options:nil]lastObject];
        [[cell.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.vcType==4) {
                /** 兑换金币*/
                CFMWalletDiamondExReCoinVc *re = [[CFMWalletDiamondExReCoinVc alloc]init];
                re.vcType = 3 ;
                [self.navigationController pushViewController:re  animated:YES];
                return;
            }
            
            /** 兑换礼物*/
            CFMWalletDiamondExGiftVc *re = [[CFMWalletDiamondExGiftVc alloc]init];
            [self.navigationController pushViewController:re  animated:YES];
        }];
    }
    NSString *lottery_coin = self.balanceInfo[@"lottery_coin"];
    cell.title.text = [NSString stringWithFormat:@"紫金账户：%.2f",lottery_coin.floatValue];
    if (self.vcType==2) {
        NSString *ratio_coin = self.balanceInfo[@"ratio_coin"];
        cell.title.text = [NSString stringWithFormat:@"黑曜石账户：%.2f",ratio_coin.floatValue];
    }else if (self.vcType==3) {
        NSString *prize_coin = self.balanceInfo[@"prize_coin"];
        cell.title.text = [NSString stringWithFormat:@"元宝账户：%.2f",prize_coin.floatValue];
        cell.btn.hidden = NO ;
    }else if (self.vcType==4) {
        NSString *money = self.balanceInfo[@"money"];
        cell.title.text = [NSString stringWithFormat:@"金币账户：%.2f",money.floatValue];
        cell.btn.hidden = NO ;
        [cell.btn setTitle:@"兑换钻石" forState:UIControlStateNormal];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + self.dataArr.count;
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
    self.navigationBar.title = @"紫金明细";
    if (self.vcType==2) {
        self.navigationBar.title = @"黑曜石明细";
    }else if (self.vcType==3) {
        self.navigationBar.title = @"元宝明细";
    }else if (self.vcType==4) {
        self.navigationBar.title = @"金币明细";
    }
}

#pragma mark -
#pragma mark --- 创建控件
- (void)initContentView {
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

    /** 分页加载数据*/
    @weakify(self);
    /** 头部视图刷新*/
    self.listTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshPagingDataWithType:HeaderRefreshType Scroll:self.listTableview];
    }];
    /** 上拉加载更多*/
    self.listTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshPagingDataWithType:FooterRefreshType Scroll:self.listTableview];
    }];
    /** 开始刷新*/
    [self refreshPagingDataWithType:HeaderRefreshType Scroll:self.listTableview];
    
    /** 获取余额等*/
    [self fetchBalance];
}

#pragma mark -
#pragma mark --- Getter
- (UITableView *)listTableview
{
    if (!_listTableview) {
        _listTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT_FULL - NavBarHeight ) style:UITableViewStyleGrouped];
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
//        /** 无数据默认图*/
//        _listTableview.emptyDataSetSource = self ;
//        _listTableview.emptyDataSetDelegate = self ;
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
        _parameter[@"page_size"] = @"10";
    }
    return _parameter ;
}
-(DPlaceholder *)place
{
    if (!_place) {
        _place = [DPlaceholder loadPlaceholder];
        _place.delegate = self.listTableview;
    }
    return _place;
}
#pragma mark --
#pragma mark --- Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/** 分页数据加载*/
- (void)refreshPagingDataWithType:(RefreshType)refreshType  Scroll:(UIScrollView *)scroll
{
    if (refreshType == HeaderRefreshType) {
        self.pageNo = @"1";
        /** 数据字典*/
        self.parameter[@"page"] = self.pageNo ;
        [self.dataArr removeAllObjects];
        /** 更新footer状态*/
        scroll.mj_footer.state = MJRefreshStateIdle;
    }else if (refreshType == FooterRefreshType) {
        if (!self.hasNextPage) {
            [scroll.mj_footer endRefreshing];
            scroll.mj_footer.state = MJRefreshStateNoMoreData;
            return;
        }
        /** 数据字典*/
        self.parameter[@"page"] = self.pageNo ;
    }

    NSString *apiStr = user_lotteryCoinLogList ;
    if (self.vcType==2) {
        apiStr = user_ratioCoinLogList ;
    }else if (self.vcType==3) {
        apiStr = user_userPrizeCoinList ;
    }else if (self.vcType==4) {
        apiStr = user_userMoneyLogList ;
    }
    
    /** 调用列表刷新*/
    [FFHomeHandel  customeListRequestHandle:self.parameter apiStr:apiStr success:^(NSMutableArray *dataArr, NSString *pageNo, BOOL hasNextPage) {
        if (refreshType == HeaderRefreshType) {
            [scroll.mj_header endRefreshing];
            self.dataArr = dataArr ;
        }else if (refreshType == FooterRefreshType) {
            [scroll.mj_footer endRefreshing];
            [self.dataArr addObjectsFromArray:dataArr] ;
        }
        self.pageNo = pageNo ;
        self.hasNextPage = hasNextPage ;
        /** 判断是否有下一页数据，更新底部刷新状态*/
        if (self.hasNextPage) {
            scroll.mj_footer.state = MJRefreshStateIdle;
        }else{
            scroll.mj_footer.state = MJRefreshStateNoMoreData;
        }
        /** UI*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listTableview reloadData];
        });
        
        if (self.dataArr.count > 0) {
            self.place.hidden = YES ;
        }else{
            self.place.hidden = NO ;
        }
        
    } failure:^{
        if (refreshType == HeaderRefreshType) {
            [scroll.mj_header endRefreshing];
        }else if (refreshType == FooterRefreshType) {
            [scroll.mj_footer endRefreshing];
        }
        /** UI*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listTableview reloadData];
        });
        
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
@end

