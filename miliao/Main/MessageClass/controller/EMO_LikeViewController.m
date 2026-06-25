//
//  EMO_LikeViewController.m
//  miliao
//
//  Created by 张世浩 on 2023/6/25.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_LikeViewController.h"
#import "EMO_LikeTableViewCell.h"
#import "EMO_DynamicXQViewController.h"
#import "MessageInfoModel.h"
@interface EMO_LikeViewController ()<UITableViewDataSource,UITableViewDelegate>
Strong UITableView *listView;
Strong NSMutableArray *listArray;
Assign NSInteger page;
@property (nonatomic, strong) YJT_NODataView *noDataView;

@end

@implementation EMO_LikeViewController
-(YJT_NODataView *)noDataView{
    if(!_noDataView){
        _noDataView=[[YJT_NODataView alloc] init];
        _noDataView.dicData=@{@"img":@"noDataImg",@"tip":@"暂无更多数据"};
        [self.view addSubview:_noDataView];
        [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kWidth, KAdaptedHeight(150)));
        }];
    }
    return _noDataView;
}
-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addPullRefreshView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(248, 248, 248, 0);
    
    [self loadBar:YES needBack:YES needBackground:YES];
    self.leftButtonView.image = ImageNamed(@"xiaoxi_back");
    self.titleLabel.text=getLanguage(@"收到的喜欢");
    [self listView];
//    [self addFootViewRefreshView];
    [self noDataView];
    self.noDataView.hidden=YES;
}

- (UITableView *)listView{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.backgroundColor = [UIColor whiteColor];
        _listView.showsVerticalScrollIndicator = NO;
        _listView.rowHeight = KAdaptedHeight(100);
        [self.view addSubview:_listView];
        [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH);
            make.leading.trailing.mas_offset(0);
            make.bottom.mas_offset(-5);

        }];
    }
    return _listView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
//    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EMO_LikeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[EMO_LikeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.dicData=self.listArray[indexPath.row];
//    cell.dicData=@{@"":@""};
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < self.listArray.count) {
        NSDictionary * dicData=self.listArray[indexPath.row];
        
        [NetworkRequest POST:Request_GetDynamicXQ parmeters:@{@"dynamic_id":FORMAT(dicData[@"dynamic_id"])} success:^(id responObject) {
            NSLog(@"%@",responObject);
            BaseModel *baseModel = (BaseModel *)responObject;
            
            /** 进去详情*/
            EMO_DynamicXQViewController *detailVC=[EMO_DynamicXQViewController new];
            MessageInfoModel *eachModel = [[MessageInfoModel alloc]initWithDic:baseModel.data];
            /** 用户信息*/
            /** para*/
            NSMutableDictionary *parameter =[NSMutableDictionary dictionaryWithDictionary:baseModel.data];
            eachModel.user = parameter ;
            detailVC.model=eachModel;
            [self.navigationController pushViewController:detailVC animated:YES];

        } failture:^(NSError *error) {
            
        }];
    }
}

//增加下拉刷新控件
- (void)addPullRefreshView {
    self.page = 1;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [header beginRefreshing];
    self.listView.mj_header = header;
}

- (void)loadNewData{
    self.page = 1;
    [self reuqestList:1];
}

- (void)addFootViewRefreshView
{
    WeakSelf;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        wself.page++;
        [wself reuqestList:2];
    }];
    
    [footer setTitle:getLanguage(@"暂无更多数据") forState:MJRefreshStateNoMoreData];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    footer.stateLabel.font = [UIFont systemFontOfSize:10];
    footer.triggerAutomaticallyRefreshPercent = 0.5;
    footer.stateLabel.textColor = [UIColor colorWithHexString:@"0xa2a9a9"];
    self.listView.mj_footer.automaticallyChangeAlpha = YES;
    self.listView.mj_footer = footer;
}

//
- (void)reuqestList:(NSInteger)type{
    WeakSelf;
    
    [NetworkRequest POST:Request_GetReceivelike parmeters:nil success:^(id responObject) {
        NSLog(@"%@",responObject);
        if (type==1) {
            [wself.listArray removeAllObjects];
        }
        BaseModel *baseModel = (BaseModel *)responObject;
        [wself.listArray addObjectsFromArray:baseModel.data];
//        wself.noDataView.hidden=wself.listArray.count<1?NO:YES;
        [wself.listView reloadData];
        [wself.listView.mj_header endRefreshing];
        [wself.listView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        NSLog(@"%@",error);
        [wself.listView.mj_header endRefreshing];
        [wself.listView.mj_footer endRefreshing];
    }];
    
    
    
    
}


@end
