//
//  STSecMallSeachResVc.m
//
//  类介绍说明：
//
//

#import "STSecMallSeachResVc.h"
// DTO
#import "CFMChatRoomSkipManager.h"
// View
#import "CFMHomeFlowCollCell.h"
// 下级控制器

@interface STSecMallSeachResVc ()<UICollectionViewDelegate, UICollectionViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
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
/** sea*/
@property (nonatomic,strong) DYSeachBarView *seachView ;
@end

@implementation STSecMallSeachResVc

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
#pragma mark --- collectiondelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CFMHomeFlowCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CFMHomeFlowCollCell" forIndexPath:indexPath];
    if (self.dataArr.count != 0) {
        cell.model = self.dataArr[indexPath.row];
    }
    return cell ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArr.count) {
        NSDictionary *model = self.dataArr[indexPath.row];
        /** 点击房间的判断逻辑*/
        CFMChatRoomSkipManager *man = [CFMChatRoomSkipManager shared];
        [man getRoomInfo:model];
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
    self.navigationBar.titleView = self.seachView ;
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
    @weakify(self);
    self.seachView.seachViewDidEndEditing = ^(NSString *content) {
        @strongify(self);
        [self refreshPagingDataWithType:HeaderRefreshType Scroll:self.collection];
    };
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
    /** 开始刷新*/
    [self refreshPagingDataWithType:HeaderRefreshType Scroll:self.collection];
}

#pragma mark -
#pragma mark --- Getter

-(UICollectionView *)collection
{
    if (!_collection) {
        CGFloat width = (SCREEN_WIDTH - 12 * 3) / 2.0 ;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        //        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal ;
        layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
        layout.itemSize = CGSizeMake(width, 199);
        layout.minimumLineSpacing = 10 ;
        layout.minimumInteritemSpacing =10 ;
        
        /** 初始化*/
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT_FULL - NavBarHeight) collectionViewLayout:layout];
        _collection.delegate  =self;
        _collection.dataSource  =self;
        _collection.backgroundColor = [UIColor clearColor];
        _collection.showsHorizontalScrollIndicator = NO ;
        _collection.showsVerticalScrollIndicator = NO ;
        if (@available(iOS 11.0, *)) {
            _collection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        /** 注册cell*/
        [_collection registerNib:[UINib nibWithNibName:@"CFMHomeFlowCollCell" bundle:nil] forCellWithReuseIdentifier:@"CFMHomeFlowCollCell"];
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
        _parameter[@"limit"] = @"10";
    }
    if ([NSString NotNull:self.seachView.text]) {
        _parameter[@"keyword"] = self.seachView.text;
    }else{
        [_parameter removeObjectForKey:@"keyword"];
    }
    return _parameter ;
}
- (DYSeachBarView *)seachView {
    if (!_seachView) {
        _seachView = [[DYSeachBarView alloc]initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 60 - 20, 33)];
        _seachView.placeHoder = @"请输入搜索房间ID";
        _seachView.backgroundColor = HexColorDy(@"#E3E3E3");
//        _seachView.layer.masksToBounds = YES;
//        _seachView.layer.cornerRadius = _seachView.height / 2 ;
        [_seachView makeRoundCorner];
        _seachView.text = self.keyword ;
//        _seachView.delegate = self ;
    }
    return _seachView ;
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
    [FFHomeHandel  requestChatRoomList:self.parameter success:^(NSMutableArray *dataArr, NSString *pageNo, BOOL hasNextPage) {
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
