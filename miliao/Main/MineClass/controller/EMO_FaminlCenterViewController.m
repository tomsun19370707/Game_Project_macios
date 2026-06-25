//
//  EMO_FaminlCenterViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/3.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_FaminlCenterViewController.h"
#import "EMO_FaminlCenterTableCell.h"
#import "EMO_FamilyRefuseViewController.h"//拒绝
@interface EMO_FaminlCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
Strong UITableView *listView;
Strong NSMutableArray *listArray;
Assign NSInteger page;

@end

@implementation EMO_FaminlCenterViewController
-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}


-(void)viewWillAppear:(BOOL)animated{
    [self loadNewData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self listView];
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
            make.top.mas_equalTo(KAdaptedHeight(10));
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
    cell.type=1;
    WeakSelf;
    cell.BtnBlock = ^(NSDictionary * _Nonnull dic, NSInteger tag) {
        if(tag==100){
            [self agreen:tag andDic:dic];
        }
        else{
            EMO_FamilyRefuseViewController *vc=[EMO_FamilyRefuseViewController new];
            NSMutableDictionary *dicData=[NSMutableDictionary dictionaryWithDictionary:dic];
            [dicData setObject:@(self.index) forKey:@"index"];
            [dicData setObject:self.familyID forKey:@"familyID"];
            vc.dicData=dicData;
            [wself.navigationController pushViewController:vc animated:YES];
            
        }
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
   
    
}



- (void)reuqestList:(NSInteger)type{
    WeakSelf;
    [NetworkRequest POST:Request_getfamilyApplyList parmeters:@{                          @"family_id":self.familyID,
                     @"type":@(self.index),} success:^(id responObject) {

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
        [wself.listView.mj_footer endRefreshing];
        [wself.listView.mj_header endRefreshing];
    } failture:^(NSError *error) {
        wself.page--;
        [wself.listView.mj_footer endRefreshing];
        [wself.listView.mj_header endRefreshing];
    }];
}



-(void)agreen:(NSInteger )type andDic:(NSDictionary *)dic{
    
    [NetworkRequest POST:Request_OperateFamilyUserApply parmeters:@{@"family_id":self.familyID,@"status":@"1",@"id":dic[@"id"],@"type":@(self.index)} success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
        [self reuqestList:1];
        

    } failture:^(NSError *error) {

    }];
    
    
    
}






@end
