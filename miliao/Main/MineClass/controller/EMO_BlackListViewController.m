//
//  EMO_BlackListViewController.m
//  miliao
//
//  Created by 张世浩 on 2022/10/14.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_BlackListViewController.h"
#import "EMO_BlackListTableViewCell.h"
@interface EMO_BlackListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger mainPage;
@end

@implementation EMO_BlackListViewController

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.text=getLanguage(@"黑名单");
    self.titleLabel.font=KFont(18);
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    [self tableView];
    [self setUpMainTableRefresh];
    self.mainPage = 1;
    [self getUserFriendWithParameters:YES];
    
}


#pragma mark - setUpMainTableRefresh
- (void)setUpMainTableRefresh
{
    WeakSelf;
    [ZJUIUtil refreshWithHeader:self.tableView refresh:^{
        wself.mainPage = 1;
        [wself getUserFriendWithParameters:YES];
    }];
    
    
    [ZJUIUtil refreshWithFooter:self.tableView refresh:^(){
        wself.mainPage ++;
        [wself getUserFriendWithParameters:NO];
    }];
}

- (void)getUserFriendWithParameters:(BOOL)isRefresh{
    
    WeakSelf;
    [NetworkRequest POST:Request_GetBlockList parmeters:@{@"page":@(self.mainPage)} success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [wself.tableView.mj_footer endRefreshing];
        [wself.tableView.mj_header endRefreshing];

        if (isRefresh) {
            [wself.dataArr removeAllObjects];
            self.dataArr=nil;
        }
        
        NSArray *array =baseModel.data;
        if (array.count>0) {
            [wself.dataArr addObjectsFromArray:array];
        }
        
        [wself.tableView reloadData];
    
    } failture:^(NSError *error) {
        wself.mainPage--;
        [wself.tableView.mj_footer endRefreshing];
        [wself.tableView.mj_header endRefreshing];
    }];
    

 
}
//移除黑名单
- (void)getCancel_blackWithParameters:(NSDictionary *)model{
    
    WeakSelf;
    [NetworkRequest POST:Request_GetfollowOrBlack parmeters:@{@"to_uid":model[@"uid"],@"type":@"1"} success:^(id responObject) {
        BaseModel *model1=(BaseModel *)responObject;
        [[RCCoreClient sharedCoreClient] removeFromBlacklist:[model[@"uid"] stringValue] success:^{
            NSLog(@"aaa");
        } error:^(RCErrorCode status) {
            NSLog(@"BBB");
        }];
        [SVProgressHUD showImage:KGetImage(@"") status:model1.msg];
        [self getUserFriendWithParameters:YES];
    } failture:^(NSError *error) {
        
    }];
    
   
    
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
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH+1);
            make.leading.trailing.bottom.mas_equalTo(0);
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EMO_BlackListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[EMO_BlackListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.model = self.dataArr[indexPath.row];
    WEAK_SELF
    cell.quDingButtonClickBlock = ^(NSDictionary *model) {
        [weakSelf getCancel_blackWithParameters:model];
    };
    cell.selectionStyle=0;
    return cell;
}


#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    
}




@end
