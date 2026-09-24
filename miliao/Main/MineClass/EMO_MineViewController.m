//
//  EMO_MineViewController.m
//  miliao
//
//  Created by 张世浩 on 2022/10/10.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_MineViewController.h"
#import "EMO_MineTableHeadView.h"
#import "EMO_MineTableViewCell.h"
#import "EMO_EditUserMsgViewController.h"//编辑资料
#import "EMO_MyWalletViewController.h"//我的钱包
#import "EMO_NobilityViewController.h"//爵位

#import "EMO_SettingViewController.h"//设置
#import "EMO_InviteFriendsVC.h"//邀请好友
#import "EMO_CollectVC.h"//我的收藏
#import "EMO_GradeCenterViewController.h"//我的等级
#import "EMO_DressingCenterBaseVC.h"//新装扮中心
#import "EMO_MyGuildViewController.h"//我的公会
#import "EMO_GiftWallViewController.h"//我的礼物
#import "EMO_TaskCenterViewController.h"//任务中心
#import "EMO_MySkillsViewController.h"//我的技能
#import "EMO_MyRoomViewController.h"//我的房间
#import "EMO_FaminlCenterBaseViewController.h"//家族中心
#import "RoomFloatingWindow.h"
#import "EMO_RenZhengViewController.h"//实名认证
#import "EMO_AddRoomVC.h"
#import "DYAlertView.h"
@interface EMO_MineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) EMO_MineTableHeadView *headView;
@property (nonatomic ,strong) UserInfo    *userInfoModel;

@end

@implementation EMO_MineViewController

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic=[NSMutableDictionary dictionary];
    }
    return _dataDic;
}

#pragma mark 更新未读消息
-(void)messageBadgeValue{
    
    WeakSelf;
    [[RCCoreClient sharedCoreClient] getTotalUnreadCountWith:^(int unreadCount) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[wself.tabBarController tabBar] items] objectAtIndex:3].badgeValue =unreadCount>0?[NSString stringWithFormat:@"%ld",(long)unreadCount]:nil;
        });
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];

    [self messageBadgeValue];
    [self getUserInfoMessage];
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate *delegate = APPDELEGATE;
    if (delegate.roomViewController) {
        delegate.roomViewController.floatingWindow.hidden = NO;
        WeakSelf;
        delegate.roomViewController.floatingWindow.enterTheRoomBlock = ^{
            [wself.navigationController pushViewController:delegate.roomViewController animated:YES];
        };
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    AppDelegate *delegate = APPDELEGATE;
    if (delegate.roomViewController) {
        delegate.roomViewController.floatingWindow.hidden = YES;
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    
    self.dataArr=[NSMutableArray arrayWithArray:@[@{@"img":@"authenticationImg",@"name":getLanguage(@"实名认证")},@{@"img":@"WithdrawalImg",@"name":getLanguage(@"提现设置")},@{@"img":@"secureImg",@"name":getLanguage(@"账号安全")},@{@"img":@"settingImg",@"name":getLanguage(@"设置")}]];
    [self tableView];
    
    
}

#pragma mark 获取用户数据
- (void)getUserInfoMessage{
    [NetworkRequest POST:Request_UserInfo parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        NSLog(@"%@",baseModel.data);
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:baseModel.data];
        if([dic.allKeys containsObject:@"avatar_frame_image"]){
            [dic setObject:@(YES) forKey:@"is_zb"];
        }else{
            [dic setObject:@(NO) forKey:@"is_zb"];
        }
        [UserManager saveUserInfo:dic];
        UserInfo *model = [UserInfo mj_objectWithKeyValues:dic];
        self.userInfoModel = model;
        self.headView.userInfoModel=model;
            
        [self.tableView reloadData];
    } failture:^(NSError *error) {
        
    }];
}

- (UIButton *)settingBtn{
    if (!_settingBtn) {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingBtn setImage:[UIImage imageNamed:@"settingImg"] forState:UIControlStateNormal];
        [_settingBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _settingBtn.tag=200;
        [self.view addSubview:_settingBtn];
        [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(KAdaptedHeight(25));
            make.top.mas_equalTo(KAdaptedHeight(15)+kSafeArea_Top);
            make.trailing.mas_equalTo(KAdaptedWidth(-13.5));
            
        }];
    }
    return _settingBtn;
}


- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setImage:[UIImage imageNamed:@"editImg"] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _editBtn.tag=100;
        [self.view addSubview:_editBtn];
        [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.settingBtn.mas_top);
            make.width.mas_equalTo(self.settingBtn.mas_width);
            make.height.mas_equalTo(self.settingBtn.mas_height);
            make.trailing.mas_equalTo(self.settingBtn.mas_leading).offset(KAdaptedWidth(-16.5));
            
        }];
    }
    return _editBtn;
}


- (EMO_MineTableHeadView *)headView{
    if (!_headView) {
        _headView = [[EMO_MineTableHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, KAdaptedHeight(515)+ZJTopNavH)];
        WeakSelf;
        _headView.BtnClick = ^(NSInteger senderTag) {
            switch (senderTag) {
                case 1000:{
                    [wself.navigationController pushViewController:[EMO_MyWalletViewController new] animated:YES];
                }break;
                case 1001:{
                    [wself.navigationController pushViewController:[EMO_NobilityViewController new] animated:YES];
                
                }break;
                case 1002:{
                    EMO_DressingCenterBaseVC *vc=[EMO_DressingCenterBaseVC new];
                    vc.type=2;
                    [wself.navigationController pushViewController:vc animated:YES];
                    
                    
                }break;
                case 1003:{
//                    [wself getMyGuildData];
                    EMO_MyGuildViewController *VC=[EMO_MyGuildViewController new];
                    [wself.navigationController pushViewController:VC animated:YES];
                   
                }break;
                case 2000:{
                    [wself.navigationController pushViewController:[EMO_InviteFriendsVC new] animated:YES];
                   
                }break;
                case 2001:{
                    [wself.navigationController pushViewController:[EMO_TaskCenterViewController new] animated:YES];
                   
                }break;
                case 2002:{
                    EMO_GiftWallViewController *vc=[EMO_GiftWallViewController new];
                    vc.titleStr=getLanguage(@"我的礼物");
                    [wself.navigationController pushViewController:vc animated:YES];
                   
                }break;
                case 2003:{
                    [wself.navigationController pushViewController:[EMO_CollectVC new] animated:YES];

                }break;
                case 2004:{
                    [wself.navigationController pushViewController:[EMO_GradeCenterViewController new] animated:YES];
                
                }break;
                case 2005:{
                    [NetworkRequest POST:Request_MyFamily parmeters:nil success:^(id responObject) {
                        BaseModel *model=(BaseModel *)responObject;
                        if([model.data[@"is_patriarch"] integerValue]==1){
                            [wself.navigationController pushViewController:[EMO_FaminlCenterBaseViewController new] animated:YES];
                        }else{
                            [SVProgressHUD showImage:KGetImage(@"") status:@"您还未创建家族,无法查看"];
                        }
                    } failture:^(NSError *error) {
                        
                    }];
                    
                }break;
                case 2006:{
                    // 【回滚恢复点】原业务逻辑（展示“我创建的”和“我管理的”双Tab房间列表页）：
                    // 如需恢复原业务，取消下面一行的注释，并注释掉 [wself handleCreateRoomEntry] 即可：
                    // [wself.navigationController pushViewController:[EMO_MyRoomViewController new] animated:YES];

                    // [需求变更] 点击“我的房间”承接原首页“+”创建房间业务流程
                    [wself handleCreateRoomEntry];
                }break;
                case 2007:{
                    [wself.navigationController pushViewController:[EMO_MySkillsViewController new] animated:YES];
                   
                }break;
                default:
                    break;
            }
        };
    }
    return _headView;
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
        _tableView.rowHeight=KAdaptedHeight(40);
        _tableView.tableHeaderView=self.headView;
//        if (@available(iOS 15.0, *)) {
//            _tableView.sectionHeaderTopPadding = 0;
//        }
//        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        } else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
//            make.top.mas_equalTo(self.settingBtn.mas_bottom).offset(KAdaptedHeight(10));
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
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EMO_MineTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[EMO_MineTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.dicData = self.dataArr[indexPath.row];
        if (self.dataArr.count>1) {
            if (indexPath.row==0) {
                cell.topAndBottom=1;
            }else if (indexPath.row==self.dataArr.count-1){
                cell.topAndBottom=2;
            }
        }
    
    return cell;
}


#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    
    if(indexPath.row==0){
        if([[UserManager userInfo].real_name_status integerValue]==1){

            return [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"审核中...")];
        }
        if([[UserManager userInfo].real_name_status integerValue]==2){

            return [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"您已实名认证")];
        }
        EMO_RenZhengViewController *vc=[EMO_RenZhengViewController new];
        [wself.navigationController pushViewController:vc animated:YES];
    }else{
        EMO_SettingViewController *vc=[EMO_SettingViewController new];
        vc.type=indexPath.row;
        [wself.navigationController pushViewController:vc animated:YES];
    }
    
   
    
}




-(void)BtnClick:(UIButton *)sender{
    if (sender.tag==100) {
        EMO_EditUserMsgViewController *VC=[EMO_EditUserMsgViewController new];
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        EMO_SettingViewController *VC=[EMO_SettingViewController new];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    
}

#pragma mark 是否加入公会
-(void)getMyGuildData{
    
    [HttpTool postRequstJoinGuildWithParameters:nil success:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            EMO_MyGuildViewController *VC=[EMO_MyGuildViewController new];
//            VC.guildUserYES=YES;
            VC.guildDicData=response[@"data"][@"organiza"];
            NSUserValueNameA(response[@"data"][@"organiza"], @"GuildDic");
            [self.navigationController pushViewController:VC animated:YES];
        }
        else if ([response[@"code"] integerValue] == 10){
            [self haveInviteData];
        }
        else{
            [SVProgressHUD showImage:KGetImage(@"") status:[NSString stringWithFormat:@"%@",response[@"message"]]];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"网络连接失败，请稍后再试")];
    }];
     
}

-(void)haveInviteData{
    [HttpTool postRequstInvitationrecordWithParameters:nil success:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            NSArray *arr=[NSArray arrayWithArray:response[@"data"]];
            if (arr.count>0) {
                NSDictionary *dict=arr[0];
                EMO_MyGuildViewController *VC=[EMO_MyGuildViewController new];
//                VC.guildUserYES=NO;
                VC.guildDicData=dict;
                [self.navigationController pushViewController:VC animated:YES];
            }else{
                [SVProgressHUD showImage:KGetImage(@"") status:[NSString stringWithFormat:@"%@",getLanguage(@"您还未加入公会")]];
            }
            
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"网络连接失败，请稍后再试")];
    }];
    
    
    
    

    
    
}

//#pragma mark 加入公会
//-(void)JoinMyGuildData:(NSInteger )type andInviteId:(NSString *)ID{
//
//    [HttpTool postRequstGuildInvitationWithParameters:@{@"type":@(type),@"invite_id":ID} success:^(id response) {
//        if ([response[@"code"] integerValue] == 1) {
//
//        }
//
//        [SVProgressHUD showImage:KGetImage(@"") status:[NSString stringWithFormat:@"%@",response[@"message"]]];
//
//
//    } failure:^(NSError *error) {
//        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"网络连接失败，请稍后再试")];
//    }];
//
//}
//

#pragma mark - 创建房间流转与实名认证校验
- (void)handleCreateRoomEntry {
    UserInfo *userInfo = [UserManager userInfo];
    if (!userInfo) {
        return;
    }
    
    NSString *realNameStatus = [NSString stringWithFormat:@"%@", userInfo.real_name_status];
    
    // 实名认证状态判定：0=未认证, 1=申请中, 2=审核通过, 3=申请驳回
    if ([realNameStatus isEqualToString:@"2"]) {
        // 1. 已实名认证：直接打开创建房间页
        EMO_AddRoomVC *createVC = [[EMO_AddRoomVC alloc] init];
        [self.navigationController pushViewController:createVC animated:YES];
    } else if ([realNameStatus isEqualToString:@"1"]) {
        // 2. 实名认证审核中：轻提示
        [SVProgressHUD showInfoWithStatus:@"实名认证中，请耐心等待审核"];
    } else {
        // 3. 未实名认证 / 被驳回：弹出引导弹窗
        [self showRealNameAuthDialog];
    }
}

#pragma mark - 实名引导弹窗
- (void)showRealNameAuthDialog {
    WeakSelf;
    DYAlertView *alert = [[DYAlertView alloc] initWithTitle:@"提示"
                                                   content:@"暂未实名认证，无法创建房间，是否去实名认证？"
                                                 construct:@"确认"
                                                completion:^{
        EMO_RenZhengViewController *authVC = [[EMO_RenZhengViewController alloc] init];
        [wself.navigationController pushViewController:authVC animated:YES];
    }];
    [alert addButtonTitle:@"取消" completion:^{
        
    }];
    [alert show];
}

@end
