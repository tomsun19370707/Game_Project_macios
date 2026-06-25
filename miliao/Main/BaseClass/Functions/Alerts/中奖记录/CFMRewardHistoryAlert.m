//
//  CFMRewardHistoryAlert.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/31.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMRewardHistoryAlert.h"
#import "CFMRewardHistoryCell.h"
#import "CFMRewardHistoryJoin.h"
#import "CFMRewardHistoryRate.h"
#import "CFMCFMRewardHistoryJoinRate.h"
@interface CFMRewardHistoryAlert ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
/** table */
@property (strong, nonatomic) UITableView *listTableview;
/** 分页上拉和下拉刷新*/
/** 数据源*/
@property (nonatomic,strong) NSMutableArray *dataArr;
/** View */
/** maskview*/
@property (nonatomic,strong) UIView *maskView;
/** 异形屏，底部tab不可控区域*/
@property (nonatomic,strong)UIView *specia_screen_view;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *mark;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

/** 0 我的 1全部*/
@property (nonatomic,assign) int selIndex;
@end

@implementation CFMRewardHistoryAlert

#pragma mark -
#pragma mark --- init
-(instancetype)init
{
    self = [super init];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- init frame
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /** 初始化*/
        [self initContentview];
        /** RAC*/
        [self initRacChain];
    }
    return self ;
}

#pragma mark -
#pragma mark --- 初始化view
- (void)initContentview
{
    self.selIndex = 0 ;
    
    [self setFrame:CGRectMake(0, SCREEN_HEIGHT_FULL + 60, SCREEN_WIDTH, SCREEN_HEIGHT_dy * 0.6)];
    [self makeCornerAt:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:15];
    
    [self.contentView addSubview:self.listTableview];
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
    return 0.000001;
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
    return self.dataArr.count ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_vcType==2) {
        /** 参与记录*/
        if (self.panType==2) {
            /** 倍率盘*/
            CFMCFMRewardHistoryJoinRate *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMCFMRewardHistoryJoinRate"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMCFMRewardHistoryJoinRate" owner:self options:nil]lastObject];
            }
            if (indexPath.row < self.dataArr.count) {
                cell.model = self.dataArr[indexPath.row];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            return cell ;
        }
        
        CFMRewardHistoryJoin *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMRewardHistoryJoin"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMRewardHistoryJoin" owner:self options:nil]lastObject];
        }
        if (indexPath.row < self.dataArr.count) {
            cell.model = self.dataArr[indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell ;
    }
    
    
    
    
    /** 中奖记录*/
    if (self.panType==2) {
        /** 倍率盘*/
        CFMRewardHistoryRate *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMRewardHistoryRate"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMRewardHistoryRate" owner:self options:nil]lastObject];
        }
        if (indexPath.row < self.dataArr.count) {
            cell.model = self.dataArr[indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell ;
    }
    
    CFMRewardHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMRewardHistoryCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMRewardHistoryCell" owner:self options:nil]lastObject];
    }
    if (indexPath.row < self.dataArr.count) {
        cell.model = self.dataArr[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    /** 初始化*/
    [self initContentview];
    /** RAC*/
    [self initRacChain];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark --- Rac
- (void)initRacChain {
    
}

#pragma mark -
#pragma mark --- Getter
-(UIView *)maskView
{
    if (!_maskView) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        /** 遮罩视图*/
        UIView *backgroundView = [[UIView alloc] initWithFrame:window.bounds];
        //        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
//        backgroundView.userInteractionEnabled = YES;
//        backgroundView.multipleTouchEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
//        [backgroundView addGestureRecognizer:tap];
//        @weakify(self);
//        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
//            @strongify(self);
//            [self hideView];
//        }];
        _maskView = backgroundView;
    }
    return _maskView ;
}
-(UIView *)specia_screen_view
{
    if (!_specia_screen_view) {
        _specia_screen_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 60)];
        _specia_screen_view.backgroundColor = [UIColor whiteColor];
        _specia_screen_view.bottom = SCREEN_HEIGHT_FULL ;
    }
    return _specia_screen_view ;
}
- (UITableView *)listTableview
{
    if (!_listTableview) {
        _listTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, self.height - 80) style:UITableViewStyleGrouped];
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
#pragma mark --
#pragma mark --- Setter
-(void)setVcType:(int)vcType
{
    _vcType = vcType ;
    if (vcType==2) {
        self.title.text = @"参与记录";
        [self.btn1 setTitle:@"我的参与记录" forState:UIControlStateNormal];
        [self.btn2 setTitle:@"全部参与记录" forState:UIControlStateNormal];
    }
    
    /** 刷新*/
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.listTableview reloadData];
    });
}
#pragma mark --
#pragma mark --- ibaction
- (IBAction)closeAc:(id)sender {
    [self hideView];
}
- (IBAction)ac1:(id)sender {
    self.selIndex = 0 ;
    
    [self.btn1 setTitleColor:BaseMainColor forState:UIControlStateNormal];
    self.mark.centerX = SCREENWIDTH / 4.0 ;
    [self.btn2 setTitleColor:HexColorDy(@"333333") forState:UIControlStateNormal];
    
    /** 获取记录列表*/
    [self fetchHistoryList];
}
- (IBAction)ac2:(id)sender {
    self.selIndex = 1 ;
    
    [self.btn2 setTitleColor:BaseMainColor forState:UIControlStateNormal];
    self.mark.centerX = SCREENWIDTH / 4.0 * 3.0 ;
    [self.btn1 setTitleColor:HexColorDy(@"333333") forState:UIControlStateNormal];
    
    /** 获取记录列表*/
    [self fetchHistoryList];
}

#pragma mark --
#pragma mark --- Method
- (void)show
{
    UIView *window = [ObjectTool SharedSettings].currentVC.view;
    /** 全部加载到window上*/
    [window addSubview:self];
    [window addSubview:self.maskView];
    [window bringSubviewToFront:self];
    
    if (IS_iPhoneX) {
        [window addSubview:self.specia_screen_view];
        [window insertSubview:self.specia_screen_view belowSubview:self];
    }
    
    /** 弹框动画*/
    [UIView animateWithDuration:0.3 animations:^{
        [self setBottom:SCREEN_HEIGHT];
    }completion:^(BOOL finished) {

    }];
    
    /** 获取记录列表*/
    [self fetchHistoryList];
}
- (void)hideView{
    [UIView animateWithDuration:0.15 animations:^{
        [self setTop:SCREEN_HEIGHT + 60];
    }completion:^(BOOL finished) {
        [self->_maskView removeFromSuperview];
        self->_maskView.hidden = YES ;
        self->_specia_screen_view.hidden = YES ;
        [self->_specia_screen_view removeFromSuperview];
        [self removeAllSubviews];
        [self removeFromSuperview];
    }];
}

/** 获取记录列表*/
- (void)fetchHistoryList
{
    WeakSelf
    /** para*/
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    /** 用户类型 ：my:只查看自己 ,all ：查看全部*/
    if (self.selIndex==0) {
        parameter[@"user_type"] = @"my";
    }else if (self.selIndex==1) {
        parameter[@"user_type"] = @"all";
    }
    parameter[@"page"] = @"1";
    parameter[@"page_size"] = @"100";
    parameter[@"id"] = self.rewardId;
    
    /** 接口*/
    NSString *apiStr = ratio_my_win_log_new;
    if (_vcType==2) {
        apiStr = ratio_my_records_new;
    }
    
    [FFHomeHandel customeListRequestHandle:parameter apiStr:apiStr success:^(NSMutableArray *dataArr, NSString *pageNo, BOOL hasNextPage) {
        wself.dataArr = dataArr ;
        /** 刷新*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listTableview reloadData];
        });
    } failure:^{
        
    }];
}
@end
