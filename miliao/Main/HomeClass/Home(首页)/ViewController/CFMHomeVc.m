//
//  CFMHomeVc.m
//
//  类介绍说明：
//
//

#import "CFMHomeVc.h"
// DTO
#import "CFMChatRoomSkipManager.h"
// View
#import "CFMHomeNav.h"
#import "CFMHomeLunbo.h"
#import "CFMHomeRoom.h"
#import "CFMHomeTitle.h"
#import "CFMHomeFlow.h"
#import "CFMHomeSignAlert.h"
// 下级控制器
#import "EMO_AddRoomVC.h"
#import "EMO_RenZhengViewController.h"
/** 测试弹窗*/
#import "CFMRewardPriseAlert.h"
#import "CFMRewardHistoryAlert.h"
#import "CFMExRewardCoinAlert.h"
#import "CFMExRewardRuleAlert.h"
#import "CFMExDiamondAndBagAlert.h"
#import "CFMRateRewardVc.h"

@interface CFMHomeVc ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
/** table */
@property (strong, nonatomic) UITableView *listTableview;
/** 分页上拉和下拉刷新*/
/** 数据源*/
@property (nonatomic,strong) NSMutableArray *dataArr,*cateArr,*cateStrArr;
/** 房间列表*/
@property (nonatomic,strong) NSMutableArray *myRoomArr;
/** 页码*/
@property (nonatomic,strong) NSString *pageNo;
/** 是否有下一页*/
@property (nonatomic,assign) BOOL hasNextPage;
/** 数据筛选字典*/
@property (nonatomic,strong) NSMutableDictionary *parameter;
/** nav*/
@property (nonatomic,strong) CFMHomeNav *navVie;
/** bg*/
@property (nonatomic,strong) UIImageView *bg ;
/** lunbo*/
@property (nonatomic,strong) CFMHomeLunbo *lunbo;
/** 标题*/
@property (nonatomic,strong) CFMHomeTitle *titleVie;
/** 流*/
@property (nonatomic,strong) CFMHomeFlow *flowVie;
/** 选择的房间分类index*/
@property (nonatomic,assign) NSInteger cateIndex;
/** 创建房间*/
@property (nonatomic,strong) UIButton *addBtn;
@end

@implementation CFMHomeVc

#pragma mark -
#pragma mark --- 加载控制器
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /** 获取用户信息*/
    [self getUserInfoMessage];
    /** 获取我的房间列表*/
    [self fetchMyChatRoomList];
    /** 是否显示创建直播间的按钮*/
    [self whetherShowCreateRoomHandle];
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
    return 5.0 ;
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
    
    if (indexPath.section==1 && self.myRoomArr.count > 0) {
        /** 点击房间的判断逻辑*/
        CFMChatRoomSkipManager *man = [CFMChatRoomSkipManager shared];
        [man getRoomInfo:self.myRoomArr[0]];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        /** 标题和 房间流*/
        return 2;
    }
    return 1 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        /** 标题和 房间流*/
        if (indexPath.row==0) {
            return self.titleVie;
        }
        
        if (self.dataArr.count==0) {
            
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            [cell.contentView setHeight:0.00001];
            return cell;
        }
        self.flowVie.limitArr = self.dataArr;
        return self.flowVie;
    }
    
    if (indexPath.section==1) {
        /** 我的房间*/
        if (self.myRoomArr.count==0) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            [cell.contentView setHeight:0.00001];
            return cell;
        }
        CFMHomeRoom *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMHomeRoom"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMHomeRoom" owner:self options:nil]lastObject];
        }
        cell.model = self.myRoomArr[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell ;
    }
    
    return self.lunbo;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
    [self.navigationBar addSubview:self.navVie];
}

#pragma mark -
#pragma mark --- 创建控件
- (void)initContentView {
    self.cateIndex = 0 ;
    self.view.backgroundColor = HexColorDy(@"#F4FAFF");
    [self.view addSubview:self.bg];
    /** tab */
    [self.view addSubview:self.listTableview];
    /** add*/
    [self.view addSubview:self.addBtn];
}

#pragma mark -
#pragma mark --- Rac方法
- (void)initRacChain {
    /** 分类点击*/
    WeakSelf
    self.titleVie.fetchCateClick = ^(NSUInteger index) {
        DLog(@"------%ld",index);
        wself.cateIndex = index ;
        [wself refreshPagingDataWithType:HeaderRefreshType Scroll:wself.listTableview];
    };
    
    /** 创建房间*/
    [[self.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        //如果没有实名认证、不可以发送评论
        if([[UserManager userInfo].real_name_status intValue] != 2){
            /** 是否实名认证 0.待提交,1.审核中,2.审核通过,3.审核拒绝*/
            if ([UserManager userInfo].real_name_status.intValue==1) {
                [SVProgressHUD showTextHUDWithMessage:@"实名认证审核中！"];
                return;
            }
            //未实名
            DYAlertView *alert = [[DYAlertView alloc] initWithTitle:@"温馨提示" content:@"请先完成实名认证！" construct:@"确定" completion:^{
                
                EMO_RenZhengViewController *vc=[EMO_RenZhengViewController new];
                [wself.navigationController pushViewController:vc animated:YES];
            }];
            [alert addButtonTitle:@"取消" completion:^{
                
            }];
            [alert show];
            return;
        }
        
        EMO_AddRoomVC *vc = [[EMO_AddRoomVC alloc] init];
        [wself.navigationController pushViewController:vc animated:YES];
        
//        /** 抽奖盘*/
//        CFMRewardPriseAlert *al = [[NSBundle mainBundle] loadNibNamed:@"CFMRewardPriseAlert" owner:self options:nil][0];
//        [al show];
        
//        /** 中奖记录*/
//        CFMRewardHistoryAlert *al = [[NSBundle mainBundle] loadNibNamed:@"CFMRewardHistoryAlert" owner:self options:nil][0];
//        al.vcType = 1 ;
//        [al show];
        
//        /** 参与记录*/
//        CFMRewardHistoryAlert *al = [[NSBundle mainBundle] loadNibNamed:@"CFMRewardHistoryAlert" owner:self options:nil][0];
//        al.vcType = 2 ;
//        [al show];
        
//        /** 兑换紫金*/
//        CFMExRewardCoinAlert *al = [[NSBundle mainBundle] loadNibNamed:@"CFMExRewardCoinAlert" owner:self options:nil][0];
//        [al show];
        
//        /** 兑抽奖说明*/
//        CFMExRewardRuleAlert *al = [[NSBundle mainBundle] loadNibNamed:@"CFMExRewardRuleAlert" owner:self options:nil][0];
//        [al show];
        
//        /** 兑换*/
//        CFMExDiamondAndBagAlert *al = [[NSBundle mainBundle] loadNibNamed:@"CFMExDiamondAndBagAlert" owner:self options:nil][0];
//        [al show];
        
//        /** 倍率盘抽奖*/
//        CFMRateRewardVc *re = [[CFMRateRewardVc alloc]init];
//        re.vcType = 2 ;
//        [self.navigationController pushViewController:re  animated:YES];
    }];
} 

#pragma mark -
#pragma mark --- 网络请求
- (void)initRequestData {

    [self getRTMToken];
    
    /** 分页加载数据*/
    WeakSelf
    /** 头部视图刷新*/
    self.listTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wself refreshPagingDataWithType:HeaderRefreshType Scroll:self.listTableview];
        /** 获取轮播图和头条列表*/
        [self fetchLunboList];
        /** 获取房间分类列表*/
        [self fetchRoomCateList];
        /** 获取我的房间列表*/
        [self fetchMyChatRoomList];
    }];
    /** 上拉加载更多*/
    self.listTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [wself refreshPagingDataWithType:FooterRefreshType Scroll:self.listTableview];
    }];
    
    /** 开始刷新*/
    [self.listTableview.mj_header beginRefreshing];
    
    [ObjectTool performSelectorAfterDelay:0.5 completion:^{
        /** 判断今日是否签到*/
        [wself judgeTodaySignHandle];
    }];
}

#pragma mark -
#pragma mark --- Getter
- (UITableView *)listTableview
{
    if (!_listTableview) {
        _listTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT_dy - NavBarHeight - TabBarHeight) style:UITableViewStyleGrouped];
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
        _parameter[@"size"] = @"10";
    }
    /** //类型：0=推荐；大于0传分区一类id*/
    if (self.cateIndex > 0) {
        NSDictionary *dic = self.cateArr[self.cateIndex - 1];
        _parameter[@"type"] = FORMAT(dic[@"id"]);
    }else{
        _parameter[@"type"] = @"0";
    }
    return _parameter ;
}
-(CFMHomeNav *)navVie
{
    if (!_navVie) {
        _navVie = [[[NSBundle mainBundle] loadNibNamed:@"CFMHomeNav" owner:self options:nil]lastObject];
        _navVie.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_navVie setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _navVie.contentView.height)];
        _navVie.centerY = self.navigationBar.leftImage.centerY ;
    }
    return _navVie;
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
-(CFMHomeLunbo *)lunbo
{
    if (!_lunbo) {
        _lunbo = [[[NSBundle mainBundle] loadNibNamed:@"CFMHomeLunbo" owner:self options:nil]lastObject];
        _lunbo.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_lunbo setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _lunbo.contentView.height)];
    }
    return _lunbo;
}
-(CFMHomeTitle *)titleVie
{
    if (!_titleVie) {
        _titleVie = [[CFMHomeTitle alloc]init];
        _titleVie.selectionStyle = UITableViewCellSelectionStyleNone ;
    }
    return _titleVie;
}
-(CFMHomeFlow *)flowVie
{
    if (!_flowVie) {
        _flowVie = [[CFMHomeFlow alloc]init];
        _flowVie.selectionStyle = UITableViewCellSelectionStyleNone ;
    }
    return _flowVie;
}
-(UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [UIButton racButtonWithTitle:nil BGImage:IMAGE(@"chat_room_create") frame:CGRectMake(0, 0, 50, 50) fontSize:1 titleColor:nil];
        _addBtn.right = SCREENWIDTH - 16 ;
        _addBtn.bottom = SCREEN_HEIGHT_dy - TabBarHeight - 26 ;
    }
    return _addBtn;
}
#pragma mark --
#pragma mark --- Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/** 获取轮播图和头条列表*/
- (void)fetchLunboList
{
    WeakSelf
    /** 轮播图列表*/
    [NetworkRequest POST:Request_GetBanner parmeters:@{@"type":@"0"} success:^(id responObject) {
        [self.listTableview.mj_header endRefreshing];
        
        BaseModel *baseModel=(BaseModel *)responObject;
        NSMutableArray *titleArr=[NSMutableArray array];
        for (NSDictionary *dic in baseModel.data) {
            [titleArr addObject:dic[@"image"]];
        }
        wself.lunbo.cycleImageView.imageURLStringsGroup = titleArr;
        wself.lunbo.lunboData = baseModel.data;
        
    } failture:^(NSError *error) {
        
    }];
    
    /** 首页用户中奖通知列表*/
    [NetworkRequest POST:lottery_get_win_notice_log parmeters:nil success:^(id responObject) {
        BaseModel *baseModel=(BaseModel *)responObject;
        wself.lunbo.noticeData = baseModel.data;
    } failture:^(NSError *error) {
        
    }];
}

/** 获取房间分类列表*/
-(void)fetchRoomCateList
{
    /** 初始化*/
    self.cateArr = [NSMutableArray array];
    self.cateStrArr = [NSMutableArray array];
    
    [NetworkRequest POST:Request_GetRoomPartition parmeters:nil success:^(id responObject) {
        [self.listTableview.mj_header endRefreshing];
        
        BaseModel *basemodel=(BaseModel *)responObject;
        
        [self.cateArr addObjectsFromArray:basemodel.data];
        [self.cateStrArr addObject:getLanguage(@"今日推荐")];
        for (NSDictionary *dic in self.cateArr) {
            [self.cateStrArr addObject:dic[@"name"]];
        }
        
        self.titleVie.cateStrArr = self.cateStrArr ;
        
        /** 刷新*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listTableview reloadData];
        });
    } failture:^(NSError *error) {
        
    }];
}

/** 获取我的房间列表*/
- (void)fetchMyChatRoomList
{
    self.myRoomArr = [NSMutableArray array];
    
    WeakSelf;
    NSDictionary *dic = @{@"page":@"1",@"size":@"100"};
    [NetworkRequest POST:user_getMyOnlineRoom parmeters:dic success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
//        NSArray *array =baseModel.data;
        
//        if (array.count>0) {
//            for (NSDictionary *dic in array) {
////                NSMutableDictionary *dicData=[NSMutableDictionary dictionaryWithDictionary:dic];
////                [dicData setObject:@"0" forKey:@"select"];
////                [wself.listArray addObject:dicData];
//                [wself.myRoomArr addObject:dic];
//            }
//        }
        
        if ([NSString NotNull:baseModel.data]) {
            [wself.myRoomArr addObject:baseModel.data];
        }
        
        [wself.listTableview reloadData];
        [wself.listTableview.mj_header endRefreshing];
        [wself.listTableview.mj_footer endRefreshing];

    } failture:^(NSError *error) {
        [wself.listTableview.mj_header endRefreshing];
        [wself.listTableview.mj_footer endRefreshing];
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
    [FFHomeHandel  requestHomeChatRoomList:self.parameter success:^(NSMutableArray *dataArr, NSString *pageNo, BOOL hasNextPage) {
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

/** 判断今日是否签到*/
- (void)judgeTodaySignHandle
{
    if (![UserManager userInfo].user_id) {
        return;
    }
    [NetworkRequest POST:user_check_today parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        DLog(@"%@",responObject);
        
        /** 是否可签到*/
        NSString *is_signed_user = baseModel.data[@"is_signed_user"];
        if (is_signed_user.intValue==0) {
            /** 签到弹窗*/
            CFMHomeSignAlert *al = [[NSBundle mainBundle] loadNibNamed:@"CFMHomeSignAlert" owner:self options:nil][0];
            [al show];
        }

    } failture:^(NSError *error) {
        
    }];
}

-(void)getRTMToken
{
    
    [NetworkRequest POST:Request_Get_rtm_token parmeters:nil success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        UserDefaultsSave([Common isNull:basemodel.data],@"ShengWangRTMToken");
    } failture:^(NSError *error) {
        
    }];
}

#pragma mark 获取用户数据
- (void)getUserInfoMessage
{
   /** 是否 登录：*/
   if ([UserManager userInfo].user_id) {
       /** 已经登录*/
   }else{
       return;
   }
    
    [NetworkRequest POST:Request_UserInfo parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;

        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:baseModel.data];
        if([dic.allKeys containsObject:@"avatar_frame_image"]){
            [dic setObject:@(YES) forKey:@"is_zb"];
        }else{
            [dic setObject:@(NO) forKey:@"is_zb"];
        }
        [UserManager saveUserInfo:dic];

    } failture:^(NSError *error) {
        
    }];
}

/** 是否显示创建直播间的按钮*/
- (void)whetherShowCreateRoomHandle
{
    WeakSelf;
    NSDictionary *dic = @{@"type":@"0",@"page":@"1",@"size":@"10"};
    [NetworkRequest POST:Request_GetMyRoomList parmeters:dic success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;

        NSArray *array =baseModel.data;
        
        /** 我如果开过直播间的话，就不能再开了*/
//        if (array.count > 0) {
            wself.addBtn.hidden = YES ;
//        }else{
//            wself.addBtn.hidden = NO ;
//        }
    } failture:^(NSError *error) {
      
    }];
}
@end
