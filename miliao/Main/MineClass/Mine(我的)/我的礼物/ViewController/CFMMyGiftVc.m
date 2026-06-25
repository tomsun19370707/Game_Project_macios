//
//  CFMMyGiftVc.m
//
//  类介绍说明：
//
//

#import "CFMMyGiftVc.h"
// DTO

// View
#import "CFMMyGiftCell.h"
#import "CFMMyGiftOpr.h"
// 下级控制器

@interface CFMMyGiftVc ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
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
/** opr*/
@property (nonatomic,strong) CFMMyGiftOpr *oprVie;
@property (nonatomic,assign) int oprIndex;
@end

@implementation CFMMyGiftVc

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
    return 5 ;
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
    CFMMyGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMMyGiftCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMMyGiftCell" owner:self options:nil]lastObject];
    }
    if (self.dataArr.count != 0) {
        cell.oprIndex = self.oprIndex ;
        cell.model = self.dataArr[indexPath.section];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
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
    self.navigationBar.title = @"我的礼物";
}

#pragma mark -
#pragma mark --- 创建控件
- (void)initContentView {
    self.oprIndex = 0 ;
    [self.view addSubview:self.oprVie];
    /** tab */
    [self.view addSubview:self.listTableview];
}

#pragma mark -
#pragma mark --- Rac方法
- (void)initRacChain {
    @weakify(self);
    self.oprVie.fetchClick = ^(int index) {
        @strongify(self);
        self.oprIndex = index ;
        /** 开始刷新*/
        [self refreshPagingDataWithType:HeaderRefreshType Scroll:self.listTableview];
    };
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
}

#pragma mark -
#pragma mark --- Getter
- (UITableView *)listTableview
{
    if (!_listTableview) {
        _listTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, self.oprVie.bottom, SCREEN_WIDTH, SCREEN_HEIGHT_FULL - self.oprVie.bottom ) style:UITableViewStyleGrouped];
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
    /** 1 我收到的 2 我赠送的*/
    _parameter[@"type"] = FORMAT_TYPE(@"%d", self.oprIndex + 1);
    return _parameter ;
}
-(CFMMyGiftOpr *)oprVie
{
    if (!_oprVie) {
        _oprVie = [[[NSBundle mainBundle] loadNibNamed:@"CFMMyGiftOpr" owner:self options:nil]lastObject];
        _oprVie.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_oprVie setFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, _oprVie.contentView.height)];
        _oprVie.backgroundColor = LineColor ;
    }
    return _oprVie;
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
    
    /** 调用列表刷新*/
    [FFHomeHandel  fetchMySendAndReceiveGiftList:self.parameter success:^(NSMutableArray *dataArr, NSString *pageNo, BOOL hasNextPage) {
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
@end
