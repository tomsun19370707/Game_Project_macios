//
//  CFMMyBagVc.m
//
//  类介绍说明：
//
//

#import "CFMMyBagVc.h"
// DTO

// View
#import "CFMMyBagVcCollCell.h"
// 下级控制器

@interface CFMMyBagVc ()<UICollectionViewDelegate, UICollectionViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
/** collection */
@property (strong, nonatomic) UICollectionView *collection;
/** 分页上拉和下拉刷新*/
/** 数据源*/
@property (nonatomic,strong) NSMutableArray *dataArr;
/** 页码*/
@property (nonatomic,strong) NSString *pageNo;
/** 是否有下一页*/
@property (nonatomic,assign) BOOL hasNextPage;
/** 数据筛选字典*/
@property (nonatomic,strong) NSMutableDictionary *parameter;
@end

@implementation CFMMyBagVc

#pragma mark -
#pragma mark --- 加载控制器
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /** 开始刷新*/
    [self refreshPagingDataWithType:HeaderRefreshType Scroll:self.collection];
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
#pragma mark --- collectiondelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CFMMyBagVcCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CFMMyBagVcCollCell" forIndexPath:indexPath];
    if (self.dataArr.count != 0) {
        cell.model = self.dataArr[indexPath.row];
    }
    return cell ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count != 0) {
        
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
    [self.collection.mj_header beginRefreshing];
}

#pragma mark -
#pragma mark --- 导航初始化
- (void)initNavBar {
    self.navigationBar.title = @"我的背包";
}

#pragma mark -
#pragma mark --- 创建控件
- (void)initContentView {
    /** tab */
    [self.view addSubview:self.collection];
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
    self.collection.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshPagingDataWithType:HeaderRefreshType Scroll:self.collection];
    }];
    /** 上拉加载更多*/
    self.collection.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshPagingDataWithType:FooterRefreshType Scroll:self.collection];
    }];
}

#pragma mark -
#pragma mark --- Getter

-(UICollectionView *)collection
{
    if (!_collection) {
        CGFloat itemWidth = (SCREENWIDTH - 10 * 5 ) / 4.0 ;
        CGFloat itemheight = 135;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal ;
        layout.itemSize = CGSizeMake(itemWidth, itemheight);
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.minimumLineSpacing = 7 ;
        layout.minimumInteritemSpacing =7 ;
        /** 初始化*/
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT_FULL - NavBarHeight) collectionViewLayout:layout];
        _collection.delegate  =self;
        _collection.dataSource  =self;
        _collection.backgroundColor = LineColor;
        _collection.showsHorizontalScrollIndicator = NO ;
        _collection.showsVerticalScrollIndicator = NO ;
        if (@available(iOS 11.0, *)) {
            _collection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        /** 注册cell*/
        [_collection registerNib:[UINib nibWithNibName:@"CFMMyBagVcCollCell" bundle:nil] forCellWithReuseIdentifier:@"CFMMyBagVcCollCell"];
        /** 无数据默认图*/
        _collection.emptyDataSetDelegate = self ;
        _collection.emptyDataSetSource = self ;
    }
    return _collection ;
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
    /** type 礼物时查看,0=可赠送，1=不可赠送*/
    /** status 类型：0=礼物；1=头像框；2=进场特效；3=坐骑;4=靓号 9=抽奖盘礼物 不传默认全部*/
    return _parameter ;
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
    [FFHomeHandel fetchPackageGiftList:self.parameter success:^(NSMutableArray *dataArr, NSString *pageNo, BOOL hasNextPage) {
        
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
            [self.collection reloadData];
        });
        
    } failure:^{
        if (refreshType == HeaderRefreshType) {
            [scroll.mj_header endRefreshing];
        }else if (refreshType == FooterRefreshType) {
            [scroll.mj_footer endRefreshing];
        }
        /** UI*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collection reloadData];
        });
    }];
}
@end
