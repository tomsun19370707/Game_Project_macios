
//
//  EMO_HomeViewController.m
//  miliao
//
//  Created by 张世浩 on 2023/6/16.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_HomeViewController.h"
#import "EMO_HomeTableViewCell.h"
#import "RoomPasswordView.h"
#import "EMO_MLRoomNewVC.h"
#import "RoomFloatingWindow.h"
#import "EMO_StartPlayViewController.h"//直播开始
#import "EMO_EndPlayViewController.h"//直播结束


@interface EMO_HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
Strong UITableView *listView;
Strong NSMutableArray *listArray;
Assign NSInteger page;

Strong RoomPasswordView *passWordView;


@end

@implementation EMO_HomeViewController
-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}

- (RoomPasswordView *)passWordView{
    if (!_passWordView) {
        _passWordView = [[RoomPasswordView alloc] initWithFrame:CGRectMake(0, 0, ScreenViewWidth, ScreenViewHeight)];
    }
    return _passWordView;
}
- (void)viewDidAppear:(BOOL)animated{
    AppDelegate *delegate = APPDELEGATE;
    if (delegate.roomViewController) {
        delegate.roomViewController.floatingWindow.hidden = NO;
        WEAK_SELF
        delegate.roomViewController.floatingWindow.enterTheRoomBlock = ^{
            [weakSelf.navigationController pushViewController:delegate.roomViewController animated:YES];
        };
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    AppDelegate *delegate = APPDELEGATE;
    if (delegate.roomViewController) {
        delegate.roomViewController.floatingWindow.hidden = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadNewData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPullRefreshView];
    [self addFootViewRefreshView];
    [self listView];
    
    
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
    
    EMO_HomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"oneCell"];
    if (!cell) {
        cell=[[EMO_HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"oneCell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.dicData=self.listArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic=self.listArray[indexPath.row];

    if([dic[@"status"] integerValue]==0){
        if([[UserManager userInfo].user_id integerValue]==[dic[@"uid"] integerValue]){
//            EMO_StartPlayViewController*vc=[EMO_StartPlayViewController new];
//            vc.dicData = self.listArray[indexPath.row];
//            [self.navigationController pushViewController:vc animated:YES];
            
            /** 2026-01-24 不在进入准备开播页面*/
            if([dic[@"type"] integerValue]==0){
                [self getIntoTheRoom:dic passWord:@""];
            }else{
                if([[UserManager userInfo].user_id integerValue]==[dic[@"uid"] integerValue]){
                    [self getIntoTheRoom:dic passWord:@""];
                }else{
                    [[UIApplication sharedApplication].delegate.window addSubview:self.passWordView];
                    [self.passWordView setDicModel:dic];
                    WeakSelf;
                    self.passWordView.sendDicSeBlock = ^(NSDictionary *model, NSString *text) {
                        [wself getIntoTheRoom:model passWord:text];
                    };
                }
            }
            
        }else{
            EMO_EndPlayViewController*vc=[EMO_EndPlayViewController new];
            vc.dicData = self.listArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }else if ([dic[@"status"] integerValue]==1){
        NSLog(@"禁播");
        [SVProgressHUD showImage:KGetImage(@"") status:@"该房间已被禁播"];
    }else{
        if([dic[@"type"] integerValue]==0){
            [self getIntoTheRoom:dic passWord:@""];
        }else{
            if([[UserManager userInfo].user_id integerValue]==[dic[@"uid"] integerValue]){
                [self getIntoTheRoom:dic passWord:@""];
            }else{
                [[UIApplication sharedApplication].delegate.window addSubview:self.passWordView];
                [self.passWordView setDicModel:dic];
                WeakSelf;
                self.passWordView.sendDicSeBlock = ^(NSDictionary *model, NSString *text) {
                    [wself getIntoTheRoom:model passWord:text];
                };
            }
        }
      
    }

    
}


#pragma  mark 进入房间前获取RTCtoken

-(void)getIntoTheRoom:(NSDictionary *)dic passWord:(NSString *)passWord{
    WeakSelf;
    
    [NetworkRequest POST:Request_Get_rtc_token parmeters:@{@"room_id":dic[@"id"]} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        UserDefaultsSave(basemodel.data,@"ShengWangRTCToken");
        [wself getRoomInformationWithModel:dic passWord:passWord];
        
    } failture:^(NSError *error) {
        
    }];
    
    
}


#pragma mark 进入房间
- (void)getRoomInformationWithModel:(NSDictionary *)model passWord:(NSString *)passWord{
    WeakSelf;
    [NetworkRequest POST:Request_EnterRoom parmeters:passWord.length<1?@{@"room_id":model[@"id"]}:@{@"room_id":model[@"id"],@"password":passWord} success:^(id responObject) {
        BaseModel *basemolde=(BaseModel *)responObject;
        if(basemolde.code==1){
            EMO_MLRoomNewVC *vc=[EMO_MLRoomNewVC new];
            MLRoomInformationModel *mode=[MLRoomInformationModel mj_objectWithKeyValues:basemolde.data[@"room_info"]];
            mode.microphone_position=basemolde.data[@"microphone_position"];
            NSDictionary *userDic=[NSDictionary dictionary];
            userDic=basemolde.data[@"userinfo"];
            mode.userinfo=userDic;
            mode.is_muted=[userDic[@"is_muted"] boolValue];
            mode.user_type=[Common isNullNumber:userDic[@"type"]];
                MLRoomInformationModel *model1 = [MLRoomInformationModel currentAccount];
            [model1 mj_setKeyValues:mode];
            
            [wself.navigationController pushViewController:vc animated:YES];
        }else{
            [[UIApplication sharedApplication].delegate.window addSubview:self.passWordView];
            [self.passWordView setDicModel:model];
            WeakSelf;
            self.passWordView.sendDicSeBlock = ^(NSDictionary *model, NSString *text) {
                [wself getIntoTheRoom:model passWord:text];
            };
        }

    } failture:^(NSError *error) {
        
    }];
}

- (void)reuqestList:(NSInteger)type{
    WeakSelf;
    if(type==1){
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpHomeData" object:nil userInfo:nil]];
    }
    
    NSDictionary *dic = @{@"page":@(self.page),
                          @"limit":@"15",
                          @"type":@(self.index==3?5:self.index),
              
    };
    [NetworkRequest POST:Request_GetRoomList parmeters:dic success:^(id responObject) {
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
    }];
}







@end
