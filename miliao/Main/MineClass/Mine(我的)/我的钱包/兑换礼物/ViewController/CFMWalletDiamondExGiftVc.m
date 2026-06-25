//
//  CFMWalletDiamondExReCoinVc.m
//
//  类介绍说明：
//
//

#import "CFMWalletDiamondExGiftVc.h"
// DTO

// View
#import "CFMWalletRewardHisSection.h"
#import "CFMWalletDiamondExGiftVie.h"
#import "CFMWalletDiamondExGiftNum.h"
// 下级控制器

@interface CFMWalletDiamondExGiftVc ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
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
@property (nonatomic,strong) CFMWalletDiamondExGiftVie *flowVie;
/** 数量*/
@property (nonatomic,strong) CFMWalletDiamondExGiftNum *numVie;
/** 余额*/
@property (nonatomic,strong) NSDictionary *balanceInfo;
/** 0钻石 1倍率盘*/
@property (nonatomic,assign) int oprIndex;
/** 兑换的数量*/
@property (nonatomic,strong) NSString *giftNum;
/** 选择的礼物index*/
@property (nonatomic,assign) NSInteger giftIndex;
@end

@implementation CFMWalletDiamondExGiftVc
- (void)back {
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        // push 进入
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.presentingViewController) {
        // present 进入
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        // 兜底（极少情况，比如被嵌套）
        [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
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
    if (section==1) {
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
    if (indexPath.section==0) {
        CFMWalletRewardHisSection *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMWalletRewardHisSection"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMWalletRewardHisSection" owner:self options:nil]lastObject];
        }
        NSString *prize_coin = self.balanceInfo[@"prize_coin"];
        cell.title.text = [NSString stringWithFormat:@"当前元宝余额：%.2f",prize_coin.floatValue];
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell ;
    }
    
    if (indexPath.section==2) {
        return self.numVie;
    }
    
    self.flowVie.limitArr = self.dataArr;
    return self.flowVie;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
    self.navigationBar.title = @"兑换";
}

#pragma mark -
#pragma mark --- 创建控件
- (void)initContentView {
    self.giftNum = @"1";
    self.oprIndex = 0 ;
    self.giftIndex = -1;
    [self.view addSubview:self.bottomView];
    /** tab */
    [self.view addSubview:self.listTableview];
}

#pragma mark -
#pragma mark --- Rac方法
- (void)initRacChain {
    @weakify(self);
    self.flowVie.fetchClick = ^(int index) {
        @strongify(self);
        self.oprIndex = index ;
        [self refreshPagingDataWithType:HeaderRefreshType Scroll:self.listTableview];
    };
    
    /** 选择了礼物*/
    self.flowVie.fetchGiftClick = ^(int giftIndex) {
        @strongify(self);
        self.giftIndex = giftIndex ;
    };
    
    /** 数量改变*/
    self.numVie.numberVie.resultNumber = ^(NSString *number) {
        @strongify(self);
        self.giftNum = number ;
    };
    
    /** 确认兑换*/
    [[self.bottomView.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.dataArr.count ==0) {
            return;
        }
        if (self.giftIndex==-1) {
            [SVProgressHUD showTextHUDWithMessage:@"请选择礼物"];
            return;
        }
        GoodListInfoModel *model = self.dataArr[self.giftIndex];
        /** para*/
        NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
        parameter[@"gift_id"] = FORMAT(model.ID);
        parameter[@"nums"] = self.giftNum ;
        [FFHomeHandel customeOprHandle:parameter apiStr:gift_prizeCoinChangeGift success:^(BaseModel *info) {
            @strongify(self);
            [SVProgressHUD showTextHUDWithMessage:@"兑换成功"];
            /** 获取余额等*/
            [self fetchBalance];
        } failure:^{
            
        }];
    }];
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
        _parameter[@"page_size"] = @"10";
    }
    /** 8=钻石礼物,9=抽奖盘专属礼物。默认 8*/
    _parameter[@"type"] = FORMAT_TYPE(@"%d", self.oprIndex + 8);
    /** 可选 是否可兑换元宝 1 是 0 否 不需要不用传*/
    _parameter[@"is_exchange"] = @"1";
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
-(CFMWalletDiamondExGiftVie *)flowVie
{
    if (!_flowVie) {
        _flowVie = [[[NSBundle mainBundle] loadNibNamed:@"CFMWalletDiamondExGiftVie" owner:self options:nil]lastObject];
        _flowVie.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_flowVie setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _flowVie.contentView.height)];
    }
    return _flowVie;
}
-(CFMWalletDiamondExGiftNum *)numVie
{
    if (!_numVie) {
        _numVie = [[[NSBundle mainBundle] loadNibNamed:@"CFMWalletDiamondExGiftNum" owner:self options:nil]lastObject];
        _numVie.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_numVie setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _numVie.contentView.height)];
    }
    return _numVie;
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
    [FFHomeHandel  customeListRequestHandle:self.parameter apiStr:gift_giftList success:^(NSMutableArray *dataArr, NSString *pageNo, BOOL hasNextPage) {
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
