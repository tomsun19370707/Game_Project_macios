//
//  CFMRewardPriseAlert.m
//  miliao
//
//  Created by Dylan Lee on 2025/12/31.
//  Copyright © 2025 EMO. All rights reserved.
//

#import "CFMRewardPriseAlert.h"
#import "CFMRewardPriseTitle.h"
@interface CFMRewardPriseAlert ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
/** table */
@property (strong, nonatomic) UITableView *listTableview;
/** 分页上拉和下拉刷新*/
/** 数据源*/
@property (nonatomic,strong) NSMutableArray *dataArr,*rateArr;
/** maskview*/
@property (nonatomic,strong) UIView *maskView;
@end

@implementation CFMRewardPriseAlert

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
    [self setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREEN_HEIGHT_dy * 0.6)];
    [self setCenter:CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT_dy / 2.0)];
    
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
    return 10;
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
    WeakSelf
    CFMRewardPriseTitle *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMRewardPriseTitle"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMRewardPriseTitle" owner:self options:nil]lastObject];
        cell.fetchClick = ^{
            [wself hideView];
        };
    }
    if (indexPath.section==0) {
        if (self.dataArr.count==0) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            [cell.contentView setHeight:0.00001];
            return cell;
        }
        cell.cellType = 1 ;
        cell.title.text = @"抽奖盘抽奖";
        cell.limitArr = self.dataArr;
    }else if (indexPath.section==1) {
        if (self.rateArr.count==0) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            [cell.contentView setHeight:0.00001];
            return cell;
        }
        cell.cellType = 2 ;
        cell.title.text = @"倍率盘抽奖";
        cell.limitArr = self.rateArr;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setRoundCorner:tableView indexPath:indexPath];
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
- (UITableView *)listTableview
{
    if (!_listTableview) {
        _listTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, self.height - 35) style:UITableViewStyleGrouped];
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
        _listTableview.bounces = NO ;
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
-(UIView *)maskView
{
    if (!_maskView) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        /** 遮罩视图*/
        UIView *backgroundView = [[UIView alloc] initWithFrame:window.bounds];
        //        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
        backgroundView.userInteractionEnabled = YES;
        backgroundView.multipleTouchEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [backgroundView addGestureRecognizer:tap];
        WeakSelf
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            [wself hideView];
        }];
        _maskView = backgroundView;
    }
    return _maskView ;
}
#pragma mark --
#pragma mark --- Setter

#pragma mark --
#pragma mark --- ibaction
- (IBAction)closeAc:(id)sender {
    [self hideView];
}
#pragma mark --
#pragma mark --- Method
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    /** 全部加载到window上，不会出现点击异常事件*/
    [window addSubview:self];
    [window addSubview:self.maskView];
    [window bringSubviewToFront:self];
    
    /** 弹框动画*/
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.1;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:1.0];
    pulse.toValue= [NSNumber numberWithFloat:1.1];
    [self.layer addAnimation:pulse forKey:nil];
    
    /** 获取抽奖盘列表*/
    [self fetchRewardPanList];
    /** 获取倍率盘列表*/
    [self fetchRateRewardList];
}
- (void)hideView{
    [UIView animateWithDuration:0.15 animations:^{
        self.transform = CGAffineTransformMakeScale(.3f, .3f);
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self deallocSubview];
    }];
}
/** 销毁view*/
- (void)deallocSubview
{
    [_maskView removeFromSuperview];
    [self removeFromSuperview];
    _maskView.hidden = YES ;
}

/** 获取抽奖盘列表*/
- (void)fetchRewardPanList
{
    WeakSelf
    /** para*/
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    parameter[@"page_size"] = @"1000";
    parameter[@"page"] = @"1";
    [FFHomeHandel customeNoPageListRequestHandle:parameter apiStr:lottery_get_rooms success:^(NSMutableArray <NSDictionary *> *dataArr) {
        wself.dataArr = dataArr ;
        /** 刷新*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.listTableview reloadData];
        });
    } failure:^{
        
    }];
}

/** 获取倍率盘列表*/
- (void)fetchRateRewardList
{
    WeakSelf
    [FFHomeHandel customeNoPageListRequestHandle:nil apiStr:ratio_get_rooms success:^(NSMutableArray<NSDictionary *> *dataArr) {
        wself.rateArr = dataArr ;
        /** 刷新*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listTableview reloadData];
        });
    } failure:^{
        
    }];
}
@end

