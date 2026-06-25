//
//  EMO_SubgiftRecordViewController.m
//  miliao
//
//  Created by 张世浩 on 2022/10/17.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_SubgiftRecordViewController.h"
#import "EMO_SubgiftRecordTableCell.h"

@interface EMO_SubgiftRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;

@end

@implementation EMO_SubgiftRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page=1;
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.text=getLanguage(@"转赠记录");
    self.titleLabel.font=KFont(18);
    self.view.backgroundColor=kWhiteColor;
    [self gethttpRequest:1];
    [self tableView];
    [self addPullRefreshView];
    [self addFootViewRefreshView];
}


//增加下拉刷新控件
- (void)addPullRefreshView {

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [header beginRefreshing];
    self.page=1;
    self.tableView.mj_header = header;
}


- (void)loadNewData{
    self.page=1;
    [self gethttpRequest:1];
}

- (void)addFootViewRefreshView
{
    WeakSelf;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        wself.page++;
        [wself gethttpRequest:2];
    }];
    [footer setTitle:getLanguage(@"暂无更多数据") forState:MJRefreshStateNoMoreData];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    footer.stateLabel.font = [UIFont systemFontOfSize:10];
    footer.triggerAutomaticallyRefreshPercent = 0.5;
    footer.stateLabel.textColor = [UIColor colorWithHexString:@"0xa2a9a9"];
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer = footer;
}




-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor =  RGBA(248, 248, 248, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor=[UIColor clearColor];
        _tableView.rowHeight=KAdaptedHeight(75);
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH);
            make.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(-KSAFEAREA_BOTTOM_HEIHGHT);
        }];
    }
    return _tableView;
}



#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
//    return 10;
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EMO_SubgiftRecordTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[EMO_SubgiftRecordTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.dicData = self.dataArr[indexPath.row];
    cell.selectionStyle=0;
    return cell;
}


#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    
}




- (void)gethttpRequest:(NSInteger)A{

    WeakSelf;
    
    [NetworkRequest POST:Request_getMyTransferLog parmeters:@{@"page":@(self.page),@"size":@(PageSize)} success:^(id responObject) {
        BaseModel *mode=(BaseModel *)responObject;
        if(A==1){
            [self.dataArr removeAllObjects];
            self.dataArr=nil;
        }
        
        [self.dataArr addObjectsFromArray:mode.data];
        [self.tableView reloadData];
        [wself.tableView.mj_header endRefreshing];
        [wself.tableView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [wself.tableView.mj_header endRefreshing];
        [wself.tableView.mj_footer endRefreshing];
    }];
    
    

}



@end
