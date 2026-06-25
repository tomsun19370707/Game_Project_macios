//
//  CFMMineVc.m
//
//  类介绍说明：
//
//

#import "CFMMineVc.h"
// DTO

// View
#import "YMMineFunctionVie.h"
#import "CFMMineHeader.h"
#import "CFMMineWallet.h"
// 下级控制器
#import "CFMPlayerMusicListVc.h"
#import "EMO_SettingViewController.h"
@interface CFMMineVc ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
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
/** set*/
@property (nonatomic,strong) UIButton *setBtn;
/** bg*/
@property (nonatomic,strong) UIImageView *bg;
/** user*/
@property (nonatomic,strong) UserInfo *userInfoModel;
/** 访客数量*/
@property (nonatomic,assign) int visitToatleCount;
@end

@implementation CFMMineVc

#pragma mark -
#pragma mark --- 加载控制器
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /** 获取用户数据*/
    [self getUserInfoMessage];
    self.navigationController.navigationBar.hidden = YES ;
    /** 获取访客数量*/
    [self fetchVisitNum];
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
    if (!self.userInfoModel) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        [cell.contentView setHeight:0.00001];
        return cell;
    }
    
    if (indexPath.section == 2) {
        /** 其它功能*/
        YMMineFunctionVie *cell = [tableView dequeueReusableCellWithIdentifier:@"YMMineFunctionVie"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YMMineFunctionVie" owner:self options:nil]lastObject];
        }
        cell.icons = @[@"mine_func_gift",@"mine_func_collect",@"mine_func_room",@"mine_func_rank",@"mine_func_help"];
        cell.titles = @[@"我的礼物",@"我的收藏",@"我的房间",@"我的等级",@"帮助反馈"];
        cell.columnNum = 4 ;
        [cell loadData];
        cell.backgroundColor = UIColor.clearColor ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell ;
    }
    
    if (indexPath.section==1) {
        /** 钱包*/
        CFMMineWallet *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMMineWallet"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMMineWallet" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell ;
    }
    
    /** header*/
    CFMMineHeader *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMMineHeader"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMMineHeader" owner:self options:nil]lastObject];
    }
    cell.model = self.userInfoModel ;
    cell.visitToatleCount = self.visitToatleCount ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section>0) {
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
    self.navigationBar.backgroundColor = UIColor.clearColor ;
    self.navigationBar.rightBarItem = self.setBtn;
}

#pragma mark -
#pragma mark --- 创建控件
- (void)initContentView {
    self.visitToatleCount = 0 ;
    [self.view addSubview:self.bg];
    self.view.backgroundColor = HexColorDy(@"#F4FAFF");
    /** tab */
    [self.view addSubview:self.listTableview];
}

#pragma mark -
#pragma mark --- Rac方法
- (void)initRacChain {
    @weakify(self);
    [[self.setBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        EMO_SettingViewController *vc=[EMO_SettingViewController new];
        vc.type=3;
        [self.navigationController pushViewController:vc animated:YES];
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
        _listTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT_dy - TabBarHeight - NavBarHeight) style:UITableViewStyleGrouped];
        _listTableview.delegate =self;
        _listTableview.dataSource =self;
        _listTableview.showsVerticalScrollIndicator = NO;
        _listTableview.backgroundColor = UIColor.clearColor;
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
-(UIButton *)setBtn
{
    if (!_setBtn) {
        _setBtn = [UIButton racButtonWithTitle:nil BGImage:IMAGE(@"mine_set") frame:CGRectMake(0, 0, 26, 26) fontSize:1 titleColor:nil];
    }
    return _setBtn;
}
-(UIImageView *)bg
{
    if (!_bg) {
        _bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
        _bg.image = IMAGE(@"mineHeadBgImg");
        _bg.contentMode = UIViewContentModeScaleAspectFill;
        CGFloat temp = 261.0 / 375.0;
        _bg.height = SCREEN_WIDTH * temp ;
    }
    return _bg;
}
#pragma mark --
#pragma mark --- Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 获取用户数据
- (void)getUserInfoMessage
{
    [NetworkRequest POST:Request_UserInfo parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;

        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:baseModel.data];
        if([dic.allKeys containsObject:@"avatar_frame_image"]){
            [dic setObject:@(YES) forKey:@"is_zb"];
        }else{
            [dic setObject:@(NO) forKey:@"is_zb"];
        }
        [UserManager saveUserInfo:dic];
        UserInfo *model = [UserInfo mj_objectWithKeyValues:dic];
        self.userInfoModel = model;
        
        /** 刷新*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listTableview reloadData];
        });
    } failture:^(NSError *error) {
        
    }];
}

/** 获取访客数量*/
- (void)fetchVisitNum
{
    WeakSelf
    [NetworkRequest POST:user_getVisitorList parmeters:@{@"page":@"1"} success:^(id responObject) {
        BaseModel *model=(BaseModel *)responObject;
        NSString *total = FORMAT(model.data[@"total"]);
        wself.visitToatleCount = total.intValue ;
        /** 刷新*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listTableview reloadData];
        });
    } failture:^(NSError *error) {

    }];
}
@end

