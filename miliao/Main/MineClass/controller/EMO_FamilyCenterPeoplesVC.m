//
//  EMO_FamilyCenterPeoplesVC.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/4.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_FamilyCenterPeoplesVC.h"
#import "EMO_FaminlCenterTableCell.h"
#import "EMO_FamilyCenterDetailsOfIncomeVC.h"//收益流水
@interface EMO_FamilyCenterPeoplesVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
Strong UITableView *listView;
Strong NSMutableArray *listArray;
Assign NSInteger page;

@end

@implementation EMO_FamilyCenterPeoplesVC
-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(255, 255, 255, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
//    self.barView.backgroundColor=kClearColor;
    self.titleLabel.text=getLanguage(@"家族成员");
    self.titleLabel.font=KFont(18);
    
    [self addPullRefreshView];
    
    [self addFootViewRefreshView];
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


- (UITableView *)listView{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.backgroundColor = [UIColor clearColor];
        _listView.showsVerticalScrollIndicator = NO;
        _listView.rowHeight = KAdaptedHeight(90);
        [self.view addSubview:_listView];
        [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH);
            make.leading.trailing.mas_offset(0);
            make.bottom.mas_offset(-5);

        }];
    }
    return _listView;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
//    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EMO_FaminlCenterTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"oneCell"];
    if (!cell) {
        cell=[[EMO_FaminlCenterTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"oneCell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.dicData=self.listArray[indexPath.row];
    cell.type=2;
    WeakSelf;
    cell.BtnBlock = ^(NSDictionary * _Nonnull dic, NSInteger tag) {
        if(tag==100){
            [wself getOutData:dic];
            
        }else{
            EMO_FamilyCenterDetailsOfIncomeVC *vc=[EMO_FamilyCenterDetailsOfIncomeVC new];
            vc.type=2;
            vc.FamilyID=self.familyID;
            vc.FamilyUserID=[Common isNull:dic[@"id"]];
            [wself.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
   
    
}


//订单列表
- (void)reuqestList:(NSInteger)type{
    WeakSelf;
    NSDictionary *dic = @{@"page":@(self.page),
                          @"limit":@"15",
                          @"family_id":self.familyID,
    };
    [NetworkRequest POST:Request_FamilyUserList parmeters:dic success:^(id responObject) {
        [wself.listView.mj_footer endRefreshing];
        [wself.listView.mj_header endRefreshing];
        BaseModel *baseModel = (BaseModel *)responObject;

        if (type==1) {
            [wself.listArray removeAllObjects];
            wself.listArray=nil;
        }
        
        NSArray *array =baseModel.data;
        if (array.count>0) {
            [wself.listArray addObjectsFromArray:array];
            
        }
        [wself.listView reloadData];
    } failture:^(NSError *error) {
        wself.page--;
        [wself.listView.mj_footer endRefreshing];
        [wself.listView.mj_header endRefreshing];
    }];
}


-(void)getOutData:(NSDictionary *)dic{
    
    
    [NetworkRequest POST:Request_KickedFamily parmeters:@{@"family_id":self.familyID,@"family_user_list_id":dic[@"uid"]} success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
        [self loadNewData];
    } failture:^(NSError *error) {
        
    }];
    
    
    
}






@end
