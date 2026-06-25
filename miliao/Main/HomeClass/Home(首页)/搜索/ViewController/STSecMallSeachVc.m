//
//  OMSeachVc.m
//
//  类介绍说明：
//
//

#import "STSecMallSeachVc.h"
// DTO
#import "SQLManager.h"
#import "BSPost.h"
// View
#import "OMSeachCollCell.h"
#import "WSLWaterFlowLayout.h"

#import "STSecMallSeachHotVie.h"
#import "CFMHomeSeachOpr.h"
/** 列表数据间距*/
#define list_data_padding  8.0
/** 列数*/
#define collum_num  2
// 下级控制器
#import "STSecMallSeachResVc.h"
@interface STSecMallSeachVc ()<UICollectionViewDelegate, UICollectionViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource,WSLWaterFlowLayoutDelegate>
/** collection */
@property (strong, nonatomic) UICollectionView *collection;
/** 分页上拉和下拉刷新*/
/** 数据源*/
@property (nonatomic,strong) NSMutableArray *dataArr;
//瀑布流
@property (nonatomic,strong) WSLWaterFlowLayout *flow;
/** seach*/
@property (nonatomic,strong) DYSeachBarView *seachView;
/** 搜索历史记录，本地数据库*/
@property (nonatomic,strong) NSMutableArray *seachArr;
/** his*/
@property (nonatomic,strong) CFMHomeSeachOpr *hisOpr;
/** 热门搜索*/
@property (nonatomic,strong) STSecMallSeachHotVie *hotVie;
/** 热门搜索词汇*/
@property (nonatomic,strong) NSMutableArray *hotArr,*hotStrArr;
@end

@implementation STSecMallSeachVc

#pragma mark -
#pragma mark --- 加载控制器
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SQLManager *manger = [SQLManager sharedSQLManager];
    NSArray *searchArr = [manger selectAllPostFromDatabaseForTable:@"searchHistory"];

    [self.seachArr removeAllObjects];
    for (BSPost *post in searchArr) {
        [self.seachArr insertObject:post.searchWord atIndex:0];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collection reloadData];
    });
    
    /** 设置热门词汇位置*/
    self.hotVie.top = self.hisOpr.bottom + [self getTableViewHeight] + 16;
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
    /** 最多显示10个*/
    if (self.seachArr.count > 10) {
        return 10;
    }
    return self.seachArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OMSeachCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OMSeachCollCell" forIndexPath:indexPath];
    @weakify(self);
    cell.fetchDel = ^{
        @strongify(self);
        if (indexPath.row < self.seachArr.count) {
            /** 删除记录文字*/
            SQLManager *manger = [SQLManager sharedSQLManager];
            [manger deleteItemWithSearchWord:self.seachArr[indexPath.row] forTable:@"searchHistory"];
            [self.seachArr removeObjectAtIndex:indexPath.row];
            /** 刷新*/
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collection reloadData];
            });
        }
    };
    if (self.seachArr.count != 0) {
        cell.lab.text = self.seachArr[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /** 搜索跳转*/
    [self searchTextInputSkip:self.seachArr[indexPath.row]];
}
#pragma mark --
#pragma mark -- WSLWaterFlowLayoutDelegate --
//返回每个item大小
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < self.seachArr.count) {
        NSString *text = self.seachArr[indexPath.row];

        /** item wid*/
        CGFloat itemH = 27;
        CGFloat itemW = [NSString widthForContent:text font:PingFangFONT(12)] +20 + 27;

        /** extra 93*/
        return CGSizeMake(itemW, itemH);
    }
    
    return CGSizeMake(1, 1);
}

/** 头视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 0.00001);
}
/** 脚视图Size */
-(CGSize )waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 0.00001);
}

///** 列数*/
//-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
//    return self.dataArr.count;
//}
///** 行数*/
//-(CGFloat)rowCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
//    return 1;
//}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return list_data_padding;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return list_data_padding;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}
#pragma mark -
#pragma mark DZNEmptyDataSetSource（数据源代理）
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"list_no_data"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无相关信息~";
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
    self.view.backgroundColor = LineColor ;
    /** opr*/
    [self.view addSubview:self.hisOpr];
    /** tab */
    [self.view addSubview:self.collection];
//    /** hot*/
//    [self.view addSubview:self.hotVie];
}

#pragma mark -
#pragma mark --- Rac方法
- (void)initRacChain {
    /** 搜索*/
    @weakify(self);
    self.seachView.seachViewDidEndEditing = ^(NSString *content) {
        @strongify(self);
        if (content.isNull || !content) {
        } else {
            if (![content isNull]) {
                /** 记录搜索历史*/
                [self searchHistoryToLocal:content];
                /** 搜索跳转*/
                [self searchTextInputSkip:content];
            }
        }
    };
    
    /** 清除记录*/
    [[self.hisOpr.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self clearHistory];
    }];
    
//    /** 热门搜索*/
//    self.hotVie.pin.itemClickIndex = ^(NSUInteger index) {
//        @strongify(self);
//        GoodListInfoModel *model = self.hotArr[index];
//        /** 搜索跳转*/
//        [self searchTextInputSkip:model.name];
//    };
}

#pragma mark -
#pragma mark --- 网络请求
- (void)initRequestData {
    /** 获取热门列表*/
    [self fetchHotCityList];
}

#pragma mark -
#pragma mark --- Getter
-(UICollectionView *)collection
{
    if (!_collection) {
        self.flow = [[WSLWaterFlowLayout alloc] init];
        self.flow.delegate = self;
        self.flow.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;

        //创建collectionView
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.hisOpr.bottom, SCREEN_WIDTH, SCREEN_HEIGHT_FULL - self.hisOpr.bottom) collectionViewLayout:self.flow];
        _collection.backgroundColor = UIColor.whiteColor;
        /** 注册cell*/
        [_collection registerNib:[UINib nibWithNibName:@"OMSeachCollCell" bundle:nil] forCellWithReuseIdentifier:@"OMSeachCollCell"];
        
//        /** 注册header和footer*/
//        [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
//        [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
        _collection.dataSource = self;
        _collection.delegate = self ;
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
-(NSMutableArray *)seachArr
{
    if (!_seachArr) {
        _seachArr = [NSMutableArray array];
    }
    return _seachArr ;
}
- (DYSeachBarView *)seachView {
    if (!_seachView) {
        _seachView = [[DYSeachBarView alloc]initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 60 - 20, 33)];
        _seachView.placeHoder = @"请输入搜索房间ID";
        _seachView.backgroundColor = HexColorDy(@"#E3E3E3");
//        _seachView.layer.masksToBounds = YES;
//        _seachView.layer.cornerRadius = _seachView.height / 2 ;
        [_seachView makeRoundCorner];
//        _seachView.delegate = self ;
    }
    return _seachView ;
}
-(CFMHomeSeachOpr *)hisOpr
{
    if (!_hisOpr) {
        _hisOpr = [[[NSBundle mainBundle] loadNibNamed:@"CFMHomeSeachOpr" owner:self options:nil]lastObject];
        _hisOpr.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_hisOpr setFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, _hisOpr.contentView.height)];
    }
    return _hisOpr;
}
-(STSecMallSeachHotVie *)hotVie
{
    if (!_hotVie) {
        _hotVie = [[[NSBundle mainBundle] loadNibNamed:@"STSecMallSeachHotVie" owner:self options:nil]lastObject];
        _hotVie.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_hotVie setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _hotVie.contentView.height)];
    }
    return _hotVie;
}

#pragma mark --
#pragma mark --- Method
/** 搜索跳转*/
- (void)searchTextInputSkip:(NSString *)content
{
    STSecMallSeachResVc *VC = [[STSecMallSeachResVc alloc] init];
    VC.keyword = content ;
    [self.navigationController pushViewController:VC animated:YES];
}

/** 搜索记录做成本地*/
- (void)searchHistoryToLocal:(NSString *)content
{
    //做本地搜索，根据输入的用户名字搜索
    //搜索历史写入本地
    if (content.length != 0) {
        SQLManager *manger = [SQLManager sharedSQLManager];
        
        BOOL isExit = NO ;
        NSArray *searchArr = [manger selectAllPostFromDatabaseForTable:@"searchHistory"];
        for (BSPost *post in searchArr) {
            if ([post.searchWord isEqualToString:content]) {
                isExit = YES ;
                break ;
            }
        }
        
        if (!isExit) {
            [manger insertItemWithSearchWord:content forTable:@"searchHistory"];
        }
    } else {
        [SVProgressHUD showTextHUDWithMessage:@"请输入搜索内容！"];
    }
}

#pragma mark - 清空历史记录
- (void)clearHistory
{
    SQLManager *manger = [SQLManager sharedSQLManager];
    
    NSArray *searchArr = [manger selectAllPostFromDatabaseForTable:@"searchHistory"];
    
    if (searchArr.count <= 0) {
        return ;
    }
    
    @weakify(self);
    DYAlertView *alert = [[DYAlertView alloc] initWithTitle:@"温馨提示" content:@"确定要清空搜索历史记录？" construct:@"确定" completion:^{
        
        @strongify(self);
        SQLManager *manger = [SQLManager sharedSQLManager];
        NSArray *searchArr = [manger selectAllPostFromDatabaseForTable:@"searchHistory"];
        for (BSPost *post in searchArr) {
            [manger deleteItemWithSearchWord:post.searchWord forTable:@"searchHistory"];
        }
        [self.seachArr removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collection reloadData];
        });
        
    }];
    [alert addButtonTitle:@"取消" completion:^{
        
    }];
    [alert show];
}

//UITableView获取高度：
-(CGFloat)getTableViewHeight {
    [self.collection reloadData];
     [self.collection layoutIfNeeded];
     return self.collection.contentSize.height;
}


/** 获取热门列表*/
- (void)fetchHotCityList
{
//    @weakify(self);
//    /** para*/
//    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
//    parameter[@"limit"] = @"1000";
//    parameter[@"page"] = @"1";
//    /** type    类别 1.商家保证金 2.二手商品成色 3.二手商品分类 4.投诉用户类型 5.热门搜索 6.热门城市 7.主页模板*/
//    parameter[@"type"] = @"5";
//    [FFHomeHandel requestSecTradeCateList:parameter success:^(NSMutableArray *dataArr, NSMutableArray *strArr) {
//        @strongify(self);
//        self.hotArr = dataArr ;
//        self.hotStrArr = strArr ;
//        /** 刷新*/
//        self.hotVie.strArr = self.hotStrArr;
//        [self.hotVie setFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.hotVie.contentView.height)];
//        /** 设置热门词汇位置*/
//        self.hotVie.top = self.hisOpr.bottom + [self getTableViewHeight] + 16;
//    } failure:^{
//        
//    }];
}
@end


