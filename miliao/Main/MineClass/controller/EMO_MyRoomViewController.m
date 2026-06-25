//
//  EMO_MyRoomViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/3.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_MyRoomViewController.h"
#import "EMO_MyRoomTableViewCell.h"
#import "EMO_MLRoomNewVC.h"
#import "RoomPasswordView.h"
#import "EMO_StartPlayViewController.h"//直播开始
#import "EMO_EndPlayViewController.h"//直播结束
@interface EMO_MyRoomViewController ()<UITableViewDelegate,UITableViewDataSource>
Strong UITableView *listView;
Strong NSMutableArray *listArray;
Strong UIButton *myRoomBtn;
Strong UIButton *otherRoomBtn;
Assign BOOL type;
Assign NSInteger page;

Strong RoomPasswordView *passWordView;
@end

@implementation EMO_MyRoomViewController
-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.text=getLanguage(@"我的房间");
    self.titleLabel.font=KFont(18);
    self.type=YES;
    self.page=1;
    [self reuqestList:YES];
    [self setUpMainTableRefresh];
    [self myRoomBtn];
    [self otherRoomBtn];
    [self listView];
    [self.view insertSubview:self.myRoomBtn aboveSubview:self.otherRoomBtn];
    
}
#pragma mark - setUpMainTableRefresh
- (void)setUpMainTableRefresh
{
    WeakSelf;
    [ZJUIUtil refreshWithHeader:self.listView refresh:^{
        wself.page = 1;
        [wself reuqestList:YES];
    }];
    
    
    [ZJUIUtil refreshWithFooter:self.listView refresh:^(){
        wself.page ++;
        [wself reuqestList:NO];
    }];
}
- (RoomPasswordView *)passWordView{
    if (!_passWordView) {
        _passWordView = [[RoomPasswordView alloc] initWithFrame:CGRectMake(0, 0, ScreenViewWidth, ScreenViewHeight)];
    }
    return _passWordView;
}

- (UIButton *)myRoomBtn{
    if (!_myRoomBtn) {
        _myRoomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _myRoomBtn.backgroundColor=BaseMainColor;
        [_myRoomBtn setTitle:getLanguage(@"我创建的房间") forState:UIControlStateNormal];
        [_myRoomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _myRoomBtn.titleLabel.font=KFont(14);
        [_myRoomBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _myRoomBtn.layer.cornerRadius=KAdaptedHeight(20);
        _myRoomBtn.layer.masksToBounds=YES;
        _myRoomBtn.tag=100;
        [self.view addSubview:_myRoomBtn];
        [_myRoomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.top.mas_equalTo(KAdaptedHeight(15)+ZJTopNavH+ZJStatusBarH);
            make.height.mas_equalTo(KAdaptedHeight(40));
            make.trailing.mas_equalTo(self.view.mas_centerX).offset(KAdaptedWidth(15));
//            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(180), KAdaptedHeight(40)));
            
        }];
    }
    return _myRoomBtn;
}

- (UIButton *)otherRoomBtn{
    if (!_otherRoomBtn) {
        _otherRoomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _otherRoomBtn.backgroundColor=kWhiteColor;
        [_otherRoomBtn setTitle:getLanguage(@"我管理的房间") forState:UIControlStateNormal];
        [_otherRoomBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        _otherRoomBtn.titleLabel.font=KFont(14);
        [_otherRoomBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _otherRoomBtn.layer.cornerRadius=KAdaptedHeight(20);
        _otherRoomBtn.layer.masksToBounds=YES;
        _otherRoomBtn.tag=200;
        [self.view addSubview:_otherRoomBtn];
        [_otherRoomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.top.mas_equalTo(self.myRoomBtn.mas_top);
//            make.width.mas_equalTo(self.myRoomBtn.mas_width);
            make.leading.mas_equalTo(self.view.mas_centerX).offset(KAdaptedWidth(-15));
            make.height.mas_equalTo(self.myRoomBtn.mas_height);
            
        }];
    }
    return _otherRoomBtn;
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
            make.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(-KSAFEAREA_BOTTOM_HEIHGHT);
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH+KAdaptedHeight(60));
        }];
    }
    return _listView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
//    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMO_MyRoomTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell"]];
    if (!cell) {
        cell=[[EMO_MyRoomTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"Cell"]];
    }
    cell.dicData=self.listArray[indexPath.row];
    cell.type=self.type;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    WeakSelf;
    cell.BtnBlock = ^(NSDictionary * _Nonnull dic) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:getLanguage(@"辞职") message:getLanguage(@"是否退出此房间管理?") preferredStyle:UIAlertControllerStyleAlert];
        //增加取消按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleDefault handler:nil]];
        //增加确定按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:getLanguage(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          
            [self requestData:dic];
        }]];
        
        [wself presentViewController:alertController animated:true completion:nil];
        
        
    };
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic=self.listArray[indexPath.row];
    
    if([dic[@"status"] integerValue]==1){
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"房间已被禁播")];
    }else if([dic[@"status"] integerValue]==0){
        if(self.type){
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
    }
    else{
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
        
        
//        if(self.type){
//    //      status  房间状态0正常1禁播2开播
//
//            if([dic[@"status"] integerValue]==2){
//                [self getIntoTheRoom:dic passWord:@""];
//            }else{
//                EMO_StartPlayViewController*vc=[EMO_StartPlayViewController new];
//                vc.dicData = self.listArray[indexPath.row];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//        }else{
//            [self getIntoTheRoom:dic passWord:@""];
//        }
    }
   
   
    
    
//    if([dic[@"select"] integerValue]==0){
//        if([[UserManager userInfo].user_id integerValue]==[dic[@"uuid"] integerValue]){
//            EMO_StartPlayViewController*vc=[EMO_StartPlayViewController new];
//            vc.dicData = self.listArray[indexPath.row];
//            [self.navigationController pushViewController:vc animated:YES];
//        }else{
//            EMO_EndPlayViewController*vc=[EMO_EndPlayViewController new];
//            vc.dicData = self.listArray[indexPath.row];
//            [self.navigationController pushViewController:vc animated:YES];
//
//        }
//
//    }else if ([dic[@"status"] integerValue]==1){
//        NSLog(@"禁播");
//        [SVProgressHUD showImage:KGetImage(@"") status:@"该房间已被禁播"];
//    }else{
//        if([dic[@"type"] integerValue]==0){
//            [self getIntoTheRoom:dic passWord:@""];
//        }else{
//            if([[UserManager userInfo].user_id integerValue]==[dic[@"uid"] integerValue]){
//                [self getIntoTheRoom:dic passWord:@""];
//            }else{
//                [[UIApplication sharedApplication].delegate.window addSubview:self.passWordView];
//                [self.passWordView setDicModel:dic];
//                WeakSelf;
//                self.passWordView.sendDicSeBlock = ^(NSDictionary *model, NSString *text) {
//                    [wself getIntoTheRoom:model passWord:text];
//                };
//            }
//        }
//
//    }

    
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

#pragma mark 退出房间管理
-(void)requestData:(NSDictionary *)dic{
    [NetworkRequest POST:Request_Resignation parmeters:@{@"room_id":[Common isNull:dic[@"id"]]} success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
        NSMutableArray *arr=self.listArray.mutableCopy;
        int i=0;
        for (NSDictionary *dicD in arr) {
            if([dic[@"id"] integerValue]==[dicD[@"id"]integerValue]){
                [self.listArray removeObjectAtIndex:i];
                [self.listView deleteRow:i inSection:0 withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
            i++;
        }
        [self.listView reloadData];
    } failture:^(NSError *error) {
    }];
    
    
}


#pragma mark 获取数据
- (void)reuqestList:(BOOL )fresh{
    WeakSelf;
    NSDictionary *dic = @{@"type":self.type==YES?@"0":@"1",@"page":@(self.page),@"size":@(PageSize)};
    /** 创建的房间，只显示一个*/
    if (self.type) {
        dic = @{@"type":@"0",@"page":@(self.page),@"size":@"1"};
    }
    
    [NetworkRequest POST:Request_GetMyRoomList parmeters:dic success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        if(fresh){
            [wself.listArray removeAllObjects];
            wself.listArray=nil;
        }
        NSArray *array =baseModel.data;
        
        if (array.count>0) {
            for (NSDictionary *dic in array) {
//                NSMutableDictionary *dicData=[NSMutableDictionary dictionaryWithDictionary:dic];
//                [dicData setObject:@"0" forKey:@"select"];
//                [wself.listArray addObject:dicData];
                [wself.listArray addObject:dic];
            }
        }
        [wself.listView reloadData];
        [wself.listView.mj_header endRefreshing];
        [wself.listView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [wself.listView.mj_header endRefreshing];
        [wself.listView.mj_footer endRefreshing];
    }];
    
    
    
    
}

-(void)BtnClick:(UIButton *)sender{
    if(sender.tag==100){
        self.myRoomBtn.backgroundColor=BaseMainColor;
        [self.myRoomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        self.otherRoomBtn.backgroundColor=kWhiteColor;
        [self.otherRoomBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        [self.view insertSubview:self.myRoomBtn aboveSubview:self.otherRoomBtn];
        self.type=YES;
    }else{
        self.type=NO;
        self.otherRoomBtn.backgroundColor=BaseMainColor;
        [self.otherRoomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        self.myRoomBtn.backgroundColor=kWhiteColor;
        [self.myRoomBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        [self.view insertSubview:self.otherRoomBtn aboveSubview:self.myRoomBtn];
    }
    
    [self reuqestList:YES];
    
    
    
   
}





@end
