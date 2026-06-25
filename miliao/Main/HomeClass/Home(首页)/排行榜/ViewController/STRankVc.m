//
//  STRankVc.m
//
//  类介绍说明：
//
//

#import "STRankVc.h"
// DTO

// View
#import "SGPagingView.h"
#import "STRankCell.h"
#import "STRankSort.h"
// 下级控制器

@interface STRankVc ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource,SGPageTitleViewDelegate>
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
@property (nonatomic,strong) SGPageTitleView *pageTitleView ;
/** sort*/
@property (nonatomic,strong) STRankSort *sortVie;
/** 0 财富榜 1魅力棒*/
@property (nonatomic,assign) int bangType;
/** 排序 0日榜 1周榜 2月榜*/
@property (nonatomic,assign) int timeType;
@end

@implementation STRankVc

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
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STRankCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"STRankCell" owner:self options:nil]lastObject];
    }
    if (self.dataArr.count != 0) {
        cell.bangType = self.bangType ;
        cell.model = self.dataArr[indexPath.row];
    }
    cell.row = indexPath.row ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    self.navigationBar.titleView = self.pageTitleView ;
}

#pragma mark -
#pragma mark --- 创建控件
- (void)initContentView {
    self.bangType = 0 ;
    self.timeType = 0 ;
    [self.view addSubview:self.sortVie];
    /** tab */
    [self.view addSubview:self.listTableview];
}

#pragma mark -
#pragma mark --- Rac方法
- (void)initRacChain {
    @weakify(self);
    self.sortVie.fetchClick = ^(int index) {
        @strongify(self);
        self.timeType = index ;
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
        _listTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, self.sortVie.bottom, SCREEN_WIDTH, SCREEN_HEIGHT_FULL - self.sortVie.bottom ) style:UITableViewStyleGrouped];
        _listTableview.delegate =self;
        _listTableview.dataSource =self;
        _listTableview.showsVerticalScrollIndicator = NO;
        _listTableview.backgroundColor = UIColor.whiteColor ;
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
        _parameter[@"size"] = @"10";
    }
    /** 0贡献，1魅力*/
    _parameter[@"type"] = FORMAT_TYPE(@"%d", self.bangType);
    /** 0日榜，1周榜，2月榜*/
    _parameter[@"status"] = FORMAT_TYPE(@"%d", self.timeType);
    return _parameter ;
}
-(SGPageTitleView *)pageTitleView
{
    if (!_pageTitleView) {
        /** 设置属性 */
        SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
        configure.titleColor = HexColorDy(@"#999999"); /** 普通状态颜色*/
        configure.titleFont = PingFangFONT(14) ;
        configure.titleSelectedFont = PingFangBoldFONT(15);
        configure.titleSelectedColor = HexColorDy(@"333333") ;
        configure.showBottomSeparator = NO ; /** 是否显示底部分割线，默认为 YES */
        configure.indicatorStyle = SGIndicatorStyleDefault ;
        configure.indicatorColor = BaseMainColor ;
        configure.indicatorCornerRadius = 8.0 ;
        configure.indicatorHeight = 3.0 ;
        configure.indicatorFixedWidth = 39;
        configure.indicatorToBottomDistance = 9 ;
//        configure.indicatorAdditionalWidth = 25; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
        configure.titleAdditionalWidth = 20 ; //标题额外增加的宽度
        configure.equivalence = YES ;
        
        NSArray *titles = @[@"财富榜",@"魅力榜"];
        if (titles.count != 0) {
            _pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(76, 0, SCREEN_WIDTH - 76 * 2, 45) delegate:self titleNames:titles configure:configure];
            _pageTitleView.selectedIndex = 0;//默认选中
            _pageTitleView.backgroundColor = UIColor.clearColor ;
        }
    }
    return _pageTitleView ;
}
-(STRankSort *)sortVie
{
    if (!_sortVie) {
        _sortVie = [[[NSBundle mainBundle] loadNibNamed:@"STRankSort" owner:self options:nil]lastObject];
        _sortVie.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_sortVie setFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, _sortVie.contentView.height)];
    }
    return _sortVie;
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
    [FFHomeHandel  customeNoPageListRequestHandleChangeModel:self.parameter apiStr:gift_getRanking  success:^(NSMutableArray <GoodListInfoModel *> *dataArr) {
        if (refreshType == HeaderRefreshType) {
            [scroll.mj_header endRefreshing];
            self.dataArr = dataArr ;
        }else if (refreshType == FooterRefreshType) {
            [scroll.mj_footer endRefreshing];
            [self.dataArr addObjectsFromArray:dataArr] ;
        }
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

/**
 *  联动 pageContent 的方法
 *
 *  @param pageTitleView      SGPageTitleView
 *  @param selectedIndex      选中按钮的下标
 */
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex
{
    self.bangType = selectedIndex ;
    [self refreshPagingDataWithType:HeaderRefreshType Scroll:self.listTableview];
}
@end

