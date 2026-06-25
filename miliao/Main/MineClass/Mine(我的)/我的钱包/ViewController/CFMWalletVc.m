//
//  CFMWalletVc.m
//
//  类介绍说明：
//
//

#import "CFMWalletVc.h"
// DTO

// View
#import "CFMWalletCell.h"
// 下级控制器
#import "CFMWalletRewardHisVc.h"
#import "CFMWalletDiamondRechargeVc.h"
#import "CFMWalletDiamondSumVc.h"
#import "CFMWalletDiamondMainVc.h"
#import "CFMWalletRewardHisVc.h"
#import "CFMWalletDiamondExReCoinVc.h"
#import "CFMWalletDiamondExGiftVc.h"
@interface CFMWalletVc ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
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
@property (nonatomic,strong) UIImageView *bg;
/** 余额信息*/
@property (nonatomic,strong) NSDictionary *balanceInfo;
@end

@implementation CFMWalletVc

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
    return 10 ;
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
    
    switch (indexPath.section) {
        case 0:
            {
                /** 抽奖必明细*/
                CFMWalletRewardHisVc *wa = [[CFMWalletRewardHisVc alloc]init];
                wa.vcType = 1 ;
                [self.navigationController pushViewController:wa  animated:YES];
            }
            break;
        case 1:
            {
                /** 黑曜石明细*/
                CFMWalletRewardHisVc *wa = [[CFMWalletRewardHisVc alloc]init];
                wa.vcType = 2 ;
                [self.navigationController pushViewController:wa  animated:YES];
            }
            break;  
        case 2:
            {
                /** 钻石*/
                CFMWalletDiamondMainVc *wa = [[CFMWalletDiamondMainVc alloc]init];
                [self.navigationController pushViewController:wa  animated:YES];
            }
            break; 
        case 3:
            {
                /** 元宝明细*/
                CFMWalletRewardHisVc *wa = [[CFMWalletRewardHisVc alloc]init];
                wa.vcType = 3 ;
                [self.navigationController pushViewController:wa  animated:YES];
            }
            break; 
        case 4:
            {
                /** 金币明细*/
                CFMWalletRewardHisVc *wa = [[CFMWalletRewardHisVc alloc]init];
                wa.vcType = 4 ;
                [self.navigationController pushViewController:wa  animated:YES];
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
    @weakify(self);
    CFMWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMWalletCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMWalletCell" owner:self options:nil]lastObject];
        [[cell.btn1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (indexPath.section==4) {
                /** 兑换金币*/
                CFMWalletDiamondExReCoinVc *re = [[CFMWalletDiamondExReCoinVc alloc]init];
                re.vcType = 3 ;
                [self.navigationController pushViewController:re  animated:YES];
                return;
            }
            if (indexPath.section==3) {
                /** 兑换礼物*/
                CFMWalletDiamondExGiftVc *re = [[CFMWalletDiamondExGiftVc alloc]init];
                [self.navigationController pushViewController:re  animated:YES];
                return;
            }
            
            CFMWalletDiamondRechargeVc *re = [[CFMWalletDiamondRechargeVc alloc]init];
            [self.navigationController pushViewController:re  animated:YES];
        }];
        [[cell.btn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            CFMWalletDiamondSumVc *re = [[CFMWalletDiamondSumVc alloc]init];
            [self.navigationController pushViewController:re  animated:YES];
        }];
    }
    if (indexPath.section==0) {
        cell.bg.image = IMAGE(@"mine_wallet_reward");
        cell.title.text = @"紫金";
        cell.title.textColor = HexColorDy(@"#ED177E");
        cell.num.textColor = HexColorDy(@"#ED177E");
        cell.btn1.hidden = YES ;
        cell.btn2.hidden = YES ;
        NSString *lottery_coin = self.balanceInfo[@"lottery_coin"];
        cell.num.text = FORMAT_TYPE(@"%.2f", lottery_coin.floatValue);
    }else if (indexPath.section==1) {
        cell.bg.image = IMAGE(@"mine_wallet_rate");
        cell.title.text = @"黑曜石";
        cell.title.textColor = HexColorDy(@"#974F00");
        cell.num.textColor = HexColorDy(@"#974F00");
        cell.btn1.hidden = YES ;
        cell.btn2.hidden = YES ;
        NSString *ratio_coin = self.balanceInfo[@"ratio_coin"];
        cell.num.text = FORMAT_TYPE(@"%.2f", ratio_coin.floatValue);
    }else if (indexPath.section==2) {
        cell.bg.image = IMAGE(@"mine_wallet_diamond");
        cell.title.text = @"钻石";
        cell.title.textColor = HexColorDy(@"#3D2385");
        cell.num.textColor = HexColorDy(@"#3D2385");
        cell.btn1.hidden = NO ;
        cell.btn2.hidden = NO ;
        [cell.btn1 setTitle:@"充值" forState:UIControlStateNormal];
        [cell.btn1 setTitleColor:HexColorDy(@"#3D2385") forState:UIControlStateNormal];
        [cell.btn2 setTitle:@"明细" forState:UIControlStateNormal];
        [cell.btn2 setTitleColor:HexColorDy(@"#3D2385") forState:UIControlStateNormal];
        NSString *diamond = self.balanceInfo[@"diamond"];
        cell.num.text = FORMAT_TYPE(@"%.2f", diamond.floatValue);
    }else if (indexPath.section==3) {
        cell.bg.image = IMAGE(@"mine_wallet_coin");
        cell.title.text = @"元宝";
        cell.title.textColor = HexColorDy(@"#F95C41");
        cell.num.textColor = HexColorDy(@"#F95C41");
        cell.btn1.hidden = NO ;
        cell.btn2.hidden = YES ;
        [cell.btn1 setTitle:@"兑换礼物" forState:UIControlStateNormal];
        [cell.btn1 setTitleColor:HexColorDy(@"#F95C41") forState:UIControlStateNormal];
        NSString *prize_coin = self.balanceInfo[@"prize_coin"];
        cell.num.text = FORMAT_TYPE(@"%.2f", prize_coin.floatValue);
    }else if (indexPath.section==4) {
        cell.bg.image = IMAGE(@"mine_wallet_gold");
        cell.title.text = @"金币";
        cell.title.textColor = HexColorDy(@"#E55F0A");
        cell.num.textColor = HexColorDy(@"#E55F0A");
        cell.btn1.hidden = NO ;
        cell.btn2.hidden = YES ;
        [cell.btn1 setTitle:@"兑换钻石" forState:UIControlStateNormal];
        [cell.btn1 setTitleColor:HexColorDy(@"#E55F0A") forState:UIControlStateNormal];
        NSString *money = self.balanceInfo[@"money"];
        cell.num.text = FORMAT_TYPE(@"%.2f", money.floatValue);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
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
    self.navigationBar.title = @"我的钱包";
    self.navigationBar.backgroundColor = UIColor.clearColor ;
}

#pragma mark -
#pragma mark --- 创建控件
- (void)initContentView {
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
        _listTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT_FULL - NavBarHeight ) style:UITableViewStyleGrouped];
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
-(UIImageView *)bg
{
    if (!_bg) {
        _bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
        _bg.image = IMAGE(@"mine_wallet_nav_bg");
        _bg.contentMode = UIViewContentModeScaleAspectFill;
        CGFloat temp = 84.0 / 375.0;
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
@end

