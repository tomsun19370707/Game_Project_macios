//
//  EMO_FriendsContentVC.m
//  miliao
//
//  Created by 张世浩 on 2022/10/15.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_FriendsContentVC.h"
#import "EMO_FriendsTableViewCell.h"
#import "EMO_PersonalDataBaseVC.h"
@interface EMO_FriendsContentVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
Assign NSInteger mainPage;
@property (nonatomic, strong) NODataView *dataView;

@end

@implementation EMO_FriendsContentVC

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [self getUserFriendWithParameters:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    self.titleLabel.font=KFont(18);
    if(self.index==200){
        self.titleLabel.text=getLanguage(@"我的关注");
    }else if(self.index==15){
        self.titleLabel.text=getLanguage(@"我的访客");
    }else{
        self.titleLabel.text=getLanguage(@"我的粉丝");
    }
    [self setUpMainTableRefresh];
    self.mainPage = 1;
    [self tableView];
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
    if (isRefresh) {
        [self.dataArr removeAllObjects];
    }

    NSString *apiStr = Request_GetMyFriendList;
    if (self.index==15) {
        /** 访客*/
        apiStr = user_getVisitorList ;
    }
    
    [NetworkRequest POST:apiStr parmeters:@{@"page":@(self.mainPage),@"type":@(self.index/100-2)} success:^(id responObject) {
        BaseModel *model=(BaseModel *)responObject;
        NSArray *array =model.data;
        if (self.index==15) {
            array =model.data[@"data"];
        }
        
        if (array.count > 0) {
            [self.dataArr addObjectsFromArray:array];
        }else{
            self.mainPage --;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        [self dataViewAddUpView];
    } failture:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)dataViewAddUpView{
//    if (self.dataArr.count == 0 ) {
//        [self.view addSubview:self.dataView];
//       
//        [self.dataView loadDataWithDic:@{@"imageName":@"nofansOrFollower",
//                                         @"title":getLanguage(@"空空如也")
//                                         }];
//    }else{
//        [self.dataView removeFromSuperview];
//    }
}

- (NODataView *)dataView{
    if (!_dataView) {
        _dataView = [[NODataView alloc] initWithFrame:CGRectMake(0, ZJTopNavH + 70, ScreenWidth, 300)];
        _dataView.backgroundColor = kClearColor;
    }
    return _dataView;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, SCREENHEIGHT - NavBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor=[UIColor clearColor];
        _tableView.rowHeight=KAdaptedHeight(80);
        [self.view addSubview:_tableView];
//        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.top.mas_equalTo(KAdaptedHeight(-0));
//            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH+2);
//            make.leading.trailing.bottom.mas_equalTo(0);
//        }];
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
    
    EMO_FriendsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[EMO_FriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.indexType=self.index;
    NSDictionary *info = self.dataArr[indexPath.row];
    cell.dicData = info;
    /** 时间  和  */
    cell.IDLabel.text = info[@"time_str"];
    cell.relieveBtn.hidden = YES ;
    
    cell.selectionStyle=0;
    WeakSelf;
    cell.BtnBlock = ^(NSDictionary * _Nonnull dic) {
        NSLog(@"%@",dic);
//        if ([dic[@"is_follow"] integerValue]==0) {
////        if (self.index==3) {
            [wself getFollowWithParameters:dic[@"uid"]];
////        }else if(self.index==2){
//        }else{
//            [wself getCancel_followWithParameters:dic[@"id"]];
//        }
        
    };
    return cell;
}


#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.dataArr.count) {
        NSDictionary *info = self.dataArr[indexPath.row];
        EMO_PersonalDataBaseVC *vc=[EMO_PersonalDataBaseVC new];
        vc.userID=FORMAT(info[@"uid"]);
        if (self.index==15) {
            /** 访客*/
            vc.userID = FORMAT(info[@"user_id"]);
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//关注
- (void)getFollowWithParameters:(NSString *)userID{
    
    [NetworkRequest POST:Request_GetfollowOrBlack parmeters:@{@"to_uid":userID,@"type":@"0"} success:^(id responObject) {
        BaseModel *model=(BaseModel *)responObject;
        [self getUserFriendWithParameters:YES];
        [SVProgressHUD showImage:KGetImage(@"") status:model.msg];
    } failture:^(NSError *error) {
        
    }];
    
}

//取消关注
- (void)getCancel_followWithParameters:(NSString *)userID{
//    NSDictionary *dict = @{@"user_id":[UserManager userInfo].user_id,
//                           @"followed_user_id":userID};
//    [HttpTool getCancel_followWithParameters:dict success:^(id response) {
//        if ([response[@"code"] integerValue] == 1) {
//            [self getUserFriendWithParameters:YES];
//        }
//        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:response[@"message"]];
//    } failure:^(NSError *error) {
//    }];
}





@end
