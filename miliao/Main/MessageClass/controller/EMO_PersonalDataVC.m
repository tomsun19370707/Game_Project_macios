//
//  EMO_PersonalDataVC.m
//  miliao
//
//  Created by 张世浩 on 2023/6/25.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_PersonalDataVC.h"
#import "EMO_HomeTableViewCell.h"
#import "EMO_PersonalGradeCell.h"
#import "EMO_PersonalGiftCell.h"
#import "RoomPasswordView.h"
#import "EMO_PersonalSkillCell.h"

#import "EMO_SkillXQViewController.h"

@interface EMO_PersonalDataVC ()<UITableViewDataSource,UITableViewDelegate,ETPlayerDelagate>
Strong UITableView *listView;
Strong NSMutableArray *listArray;
Strong NSMutableArray *listTitleArray;
Strong PlayerManager *playManager;
Strong NSIndexPath *currentIndex;

Strong RoomPasswordView *passWordView;

@end

@implementation EMO_PersonalDataVC
-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}
-(NSMutableArray *)listTitleArray{
    if (!_listTitleArray) {
        _listTitleArray = [[NSMutableArray alloc] initWithArray:@[@{@"name":getLanguage(@"聊天室"),@"img":@"chatRoomIconImg"},@{@"name":getLanguage(@"等级成就"),@"img":@"levelImg"},@{@"name":getLanguage(@"收到的礼物"),@"img":@"giftImg"},]];
    }
    return _listTitleArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if(self.index==1){
//        [self reuqestList:1];
//    }
    
    
}
- (void)viewWillDisappear:(BOOL)animated {
    if(self.index==2){
        if(self.playManager.status==ETPlayer_Playing){
            [self.playManager stop];
        }
    }
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(248, 248, 248, 0);
    [self listView];
    
    if(self.index==2){
        self.playManager=[PlayerManager sharedInstance];
        [RACObserve(self.playManager,status) subscribeNext:^(id  _Nullable x) {
            if(self.playManager.status==ETPlayer_FinishedPlay||self.playManager.status==ETPlayer_Stop){
                if(self.currentIndex){
                    EMO_PersonalSkillCell *cell=[self.listView cellForRowAtIndexPath:self.currentIndex];
                    cell.play=NO;
                }
            }
        }];
    }
}

-(void)setDicData:(NSDictionary *)dicData{
    _dicData=dicData;
    
    if(self.index==2&&(![Common isBlankArr:dicData[@"skill_info"]])){
        self.listArray=dicData[@"skill_info"];
    }
    [self.listView reloadData];
    
    /** 添加访客记录*/
    [self addVisitHistory];
}

- (RoomPasswordView *)passWordView{
    if (!_passWordView) {
        _passWordView = [[RoomPasswordView alloc] initWithFrame:CGRectMake(0, 0, ScreenViewWidth, ScreenViewHeight)];
    }
    return _passWordView;
}

- (UITableView *)listView{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.backgroundColor = RGBA(248, 248, 248, 1);
        _listView.showsVerticalScrollIndicator = NO;
        _listView.rowHeight = KAdaptedHeight(120);
        _listView.bounces=NO;
        [self.view addSubview:_listView];
        [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.leading.trailing.mas_offset(0);
            make.bottom.mas_offset(-5);

        }];
    }
    return _listView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.index==0){
        return 3;
    }else{
        return 1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.index==0){
        return KAdaptedHeight(40);
    }else{
        return 1;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=RGBA(255, 255, 255, 1);
    if(self.index==0){
        NSDictionary *dic=self.listTitleArray[section];
        UIView *lineView=[[UIView alloc] init];
        lineView.backgroundColor=RGBA(248, 248, 248, 1);
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(KAdaptedHeight(5));
        }];
        UIButton *btn=[[UIButton alloc] init];
        [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        btn.titleLabel.font=KFontA(14);
        [btn setImage:KGetImage(dic[@"img"]) forState:UIControlStateNormal];
        btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineView.mas_bottom);
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.width.mas_equalTo(KAdaptedWidth(100));
            make.bottom.mas_equalTo(0);
        }];
        [btn setImagePositionWithType:SSImagePositionTypeLeft spacing:6];
        
    }
    return view;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(self.index==0){
        if(section==0){
            if([Common isBlankDictionary:self.dicData[@"room_info"]]){
                return 0;
            }
        }else if(section==2){
            if([Common isBlankArr:self.dicData[@"my_receive_gift"]]){
                return 0;
            }
        }
        return 1;
    }else{
        return self.listArray.count;

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.index==0){
        if(indexPath.section==1){
//            return 160;
            EMO_PersonalGradeCell *cell = (EMO_PersonalGradeCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.cellHeight;
        }else if(indexPath.section==0){
            return 100;
        }else{
            return 130;
        }
    }else{
        return 100;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.index==0){
        if(indexPath.section==0){
            EMO_HomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell1"];
            if (!cell) {
                cell=[[EMO_HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell1"];
            }
            cell.dicData=self.dicData[@"room_info"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.section==1){
            EMO_PersonalGradeCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell2"];
            if (!cell) {
                cell=[[EMO_PersonalGradeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell2"];
            }
            cell.dicData=self.dicData;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }else{
            EMO_PersonalGiftCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell3"];
            if (!cell) {
                cell=[[EMO_PersonalGiftCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell3"];
            }
                cell.arrData=self.dicData[@"my_receive_gift"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else{
        
        EMO_PersonalSkillCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CellA"];
        if (!cell) {
            cell=[[EMO_PersonalSkillCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellA"];
        }
        [cell cellDicData:self.listArray[indexPath.row] andIndex:indexPath];
        WeakSelf;
        cell.PlayVoiceBlock = ^(NSDictionary * _Nonnull dic, BOOL playStatus, NSIndexPath *index) {
            if(playStatus){
                if(wself.playManager.status==ETPlayer_Playing){
                    [wself.playManager stop];
                }
                wself.currentIndex=index;
                [wself.playManager playWithVoiceURL:[NSURL URLWithString:[Common isNull:dic[@"video_url"]]]];
    //            [wself.playManager playWithVoiceURL:[NSURL URLWithString:@"https://heart-chat.oss-cn-beijing.aliyuncs.com/uploads/20230705/a312df7abb1d21f6caee92a0b8e53482.mp3"]];
            }else{
                [wself.playManager stop];
            }
        
        };
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if(self.index==2){
//        EMO_SkillXQViewController *vc=[EMO_SkillXQViewController new];
//        vc.skillID=self.listArray[indexPath.row][@"id"];
//        vc.type=2;
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }
    if(self.index==0&&indexPath.section==0){
        [self getIntoTheRoom:self.dicData[@"room_info"] passWord:@""];
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
//        code 1开播 2未开播  3加锁
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
        }else if(basemolde.code==3){
            [[UIApplication sharedApplication].delegate.window addSubview:self.passWordView];
            [self.passWordView setDicModel:model];
            WeakSelf;
            self.passWordView.sendDicSeBlock = ^(NSDictionary *model, NSString *text) {
                [wself getIntoTheRoom:model passWord:text];
            };
        }else {
            [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:basemolde.msg]];
        }

    } failture:^(NSError *error) {
        
    }];
}


- (void)reuqestList:(NSInteger)type{
    WeakSelf;
    [NetworkRequest POST:@"" parmeters:@{@"page":@""} success:^(id responObject) {
        NSLog(@"%@",responObject);
        if (type==1) {
            [wself.listArray removeAllObjects];
        }
        BaseModel *baseModel = (BaseModel *)responObject;
        [wself.listArray addObjectsFromArray:baseModel.data[@"data"]];
        [wself.listView reloadData];
    } failture:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
   
}

/** 添加访客记录*/
- (void)addVisitHistory
{
    NSString *b_user_id = _dicData[@"user_info"][@"id"];
    if (![NSString NotNull:b_user_id]) {
        return;
    }
    /** para*/
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    parameter[@"b_user_id"] = b_user_id;
    [NetworkRequest POST:user_createVisitor parmeters:parameter success:^(id responObject) {
        
    } failture:^(NSError *error) {
        
    }];
}
@end
