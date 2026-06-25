//
//  EMO_CollectViewController.m
//  miliao
//
//  Created by 张世浩 on 2023/6/25.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_CollectViewController.h"
#import "EMO_SySMsgTableViewCell.h"
@interface EMO_CollectViewController ()<UITableViewDataSource,UITableViewDelegate>
Strong UITableView *listView;
Strong NSMutableArray *listArray;
Assign NSInteger page;
@property (nonatomic, strong) YJT_NODataView *noDataView;


@end

@implementation EMO_CollectViewController
-(YJT_NODataView *)noDataView{
    if(!_noDataView){
        _noDataView=[[YJT_NODataView alloc] init];
        _noDataView.dicData=@{@"img":@"NODataBgImg",@"tip":@"暂无更多数据"};
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
    self.titleLabel.text=getLanguage(@"我的收藏");
    [self listView];
    
    [self addFootViewRefreshView];
    
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
        _listView.rowHeight = KAdaptedHeight(200);
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
//    return self.listArray.count;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EMO_SySMsgTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[EMO_SySMsgTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
//    cell.dicData=self.listArray[indexPath.row];
    cell.dicData=@{@"":@""};
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
    
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
    
    [NetworkRequest POST:@"" parmeters:@{@"page":@(wself.page)} success:^(id responObject) {
        NSLog(@"%@",responObject);
        if (type==1) {
            [wself.listArray removeAllObjects];
        }
        BaseModel *baseModel = (BaseModel *)responObject;
        [wself.listArray addObjectsFromArray:baseModel.data[@"data"]];
        wself.noDataView.hidden=wself.listArray.count<1?NO:YES;
        [wself.listView reloadData];
        [wself.listView.mj_header endRefreshing];
        [wself.listView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        NSLog(@"%@",error);
        [wself.listView.mj_header endRefreshing];
        [wself.listView.mj_footer endRefreshing];
    }];
    
    
    
    
//
//    for (int i=0; i<10; i++) {
//        [self.listArray addObject:@{@"headimg":@"https://img1.baidu.com/it/u=325979682,874179696&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=1158",@"name":@"芥末不辣",@"time":@"2022-10-28 20:00",@"dynamin":@"独白：我想找一个人聊天，感觉.独白：我想找一个人聊天，感觉.独白：我想找一个人聊天，感觉.独白：我想找一个人聊天，感觉...",@"type":@"1",@"msgtype":@"2",@"msg":@"来呀一起聊"}];
//        [self.listArray addObject:@{@"headimg":@"https://img1.baidu.com/it/u=325979682,874179696&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=1158",@"name":@"芥末不辣芥末不辣",@"time":@"2022-10-28 20:00",@"dynamin":@"独白：我想找一个人聊天，感觉.独白：我想找一个人聊天，感觉.独白：我想找一个人聊天，感觉.独白：我想找一个人聊天，感觉...",@"type":@"2",@"msgtype":@"1",@"msg":@"我对你的动态进行了点赞"}];
//
//    }
//                [wselflistView reloadData];
//
//
//    NSDictionary *dic = @{@"page":@(self.page),
//                          @"limit":@"15",
//                          @"state_type":@(0),
//
//    };
//    [NetworkRequest POST:Request_OrderList parmeters:dic success:^(id responObject) {
//        [wselflistView.mj_footer endRefreshing];
//        [wselflistView.mj_header endRefreshing];
//        BaseModel *baseModel = (BaseModel *)responObject;
//        if (type==1) {
//            [self.listArray removeAllObjects];
//            self.listArray=nil;
//        }
//
////        NSArray *array =baseModel.data[@"list"];
////        if (array.count>0) {
////            [wselflistArray addObjectsFromArray:array];
////            [wselflistView reloadData];
////        }
//
//    } failture:^(NSError *error) {
//        wselfpage--;
//    }];
}


@end
