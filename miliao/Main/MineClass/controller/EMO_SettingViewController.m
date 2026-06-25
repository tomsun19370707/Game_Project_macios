//
//  EMO_SettingViewController.m
//  miliao
//
//  Created by 张世浩 on 2022/10/13.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_SettingViewController.h"
#import "EMO_EditUserMsgTableViewCell.h"
#import "EMO_BlackListViewController.h"//黑名单
#import "MLMaskView.h"
#import "EMO_EditSettingVC.h"//编辑-设置
#import "EMO_AboutUsViewController.h"//关于我们
#import "EMO_FeedbackViewController.h"//帮助与反馈
#import "SingleSwitchView.h"
#import "EMO_AdolescentVC.h"
#import "EMO_RenZhengViewController.h"
#import "STAccountSafeVc.h"
@interface EMO_SettingViewController ()<UITableViewDelegate, UITableViewDataSource,AgoraRtmDelegate,AgoraRtcEngineDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) MLMaskView  *maskView;
@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;
@property (nonatomic, strong) NSString *phoneStr;
Strong UIButton *delBtn;

Strong SingleSwitchView *SwitchView;
@property (nonatomic,strong)TKBottomView *bottomView ;
@end

@implementation EMO_SettingViewController

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserInfoMessage];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.font=KFont(18);
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:kAppAgoraKitId delegate:self];
    if(self.type==3){
        self.titleLabel.text=getLanguage(@"设置");
//        self.dataArr=[NSMutableArray arrayWithArray:@[@{@"data":@"",@"name":getLanguage(@"黑名单"),@"change":@"1"},@{@"data":@"",@"name":getLanguage(@"绑定邀请码"),@"change":@"1"},@{@"data":@"",@"name":getLanguage(@"关于我们"),@"change":@"1"},@{@"data":@"",@"name":getLanguage(@"帮助反馈"),@"change":@"1"},@{@"data":@"",@"name":getLanguage(@"青少年模式"),@"change":@"1"},@{@"data":@"",@"name":getLanguage(@"退出登录"),@"change":@"1"},@{@"data":@"",@"name":getLanguage(@"注销账号"),@"change":@"1"}]];
        
        NSString *device = [NSString stringWithFormat:@"当前设备：%@",[DeviceOpinion deviceName]];
        
//        self.dataArr=[NSMutableArray arrayWithArray:@[
//                      @{@"data":@"",@"name":getLanguage(@"黑名单"),@"change":@"1"},
//                      @{@"data":@"",@"name":getLanguage(@"实名认证"),@"change":@"1"},
//                      @{@"data":device,@"name":getLanguage(@"设备管理"),@"change":@"1"},
//                      @{@"data":@"",@"name":getLanguage(@"绑定邀请码"),@"change":@"1"},
//                      @{@"data":@"",@"name":getLanguage(@"账号安全"),@"change":@"1"},
//                      @{@"data":@"",@"name":getLanguage(@"关于我们"),@"change":@"1"},
//                      @{@"data":@"",@"name":getLanguage(@"退出登录"),@"change":@"1"}]];
        
        self.dataArr=[NSMutableArray arrayWithArray:@[
                      @{@"data":@"",@"name":getLanguage(@"黑名单"),@"change":@"1"},
                      @{@"data":@"",@"name":getLanguage(@"实名认证"),@"change":@"1"},
                      @{@"data":device,@"name":getLanguage(@"设备管理"),@"change":@"1"},
                      @{@"data":@"",@"name":getLanguage(@"账号安全"),@"change":@"1"},
                      @{@"data":@"",@"name":getLanguage(@"关于我们"),@"change":@"1"},
                      ]];
        
    }else if(self.type==1){
        self.titleLabel.text=getLanguage(@"提现设置");
        self.dataArr=[NSMutableArray arrayWithArray:@[@{@"data":@"",@"name":getLanguage(@"支付宝账户"),@"change":@"1"},@{@"data":@"",@"name":getLanguage(@"微信账户"),@"change":@"1"}]];
    }else{
        self.titleLabel.text=getLanguage(@"账号安全");
        NSString *numberString = [[Common isNull:[UserManager userInfo].mobile] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.dataArr=[NSMutableArray arrayWithArray:@[@{@"data":numberString,@"name":getLanguage(@"绑定手机号"),@"change":@"1"},@{@"data":@"",@"name":getLanguage(@"密码"),@"change":@"1"}]];
        
        [self delBtn];
    }
    
    [self tableView];
    

    [self.view insertSubview:self.barView aboveSubview:self.tableView];

    
    @weakify(self);
    [self.view addSubview:self.bottomView];
    [[self.bottomView.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self setLogOut];
    }];
}
-(void)btnCLick{
    
    
    
}

-(void)switchBtnClick:(BOOL )Open{
    [NetworkRequest POST:Request_ChangeUserInfo parmeters:@{@"is_disturb":Open?@"1":@"0"} success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
        if(Open){
            [[RCChannelClient sharedChannelManager] setNotificationQuietHoursLevel:@"00:00:00" spanMins:1439 level:RCPushNotificationQuietHoursLevelBlocked success:^() {} error:^(RCErrorCode status) {}];

        }else{
            [[RCChannelClient sharedChannelManager]setNotificationQuietHoursLevel:@"00:00:00" spanMins:1439 level:RCPushNotificationQuietHoursLevelDefault success:^{
            } error:^(RCErrorCode status) {
            }];
            
        }
        
    } failture:^(NSError *error) {
        
    }];
}

-(SingleSwitchView *)SwitchView{
    if (!_SwitchView) {
        _SwitchView=[[SingleSwitchView alloc]init];
        _SwitchView.backgroundColor=kWhiteColor;
        _SwitchView.frame=CGRectMake(0, 0, kWidth, KAdaptedHeight(55));
        _SwitchView.lineView.hidden=NO;
        _SwitchView.nameStr=getLanguage(@"消息免打扰");
        _SwitchView.nameLabel.font=KFontA(15);
        WeakSelf;
        _SwitchView.SwitchClick = ^(BOOL Open) {
            NSLog(@"%d",Open);
            [wself switchBtnClick:Open];
        };
        if([[UserManager userInfo].is_disturb integerValue]==1){
            _SwitchView.switchBtn.on=YES;
        }else{
            _SwitchView.switchBtn.on=NO;
        }

    }
    return _SwitchView;;
}

- (UIButton *)delBtn{
    if (!_delBtn) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delBtn.backgroundColor=RGBA(241, 241, 241, 1);
        [_delBtn setTitle:getLanguage(@"注销账户") forState:UIControlStateNormal];
        [_delBtn setTitleColor:RGBA(153, 153, 153, 1) forState:UIControlStateNormal];
        _delBtn.titleLabel.font=KFontA(15);
        [_delBtn addTarget:self action:@selector(btnCLick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_delBtn];
        [_delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-KSAFEAREA_BOTTOM_HEIHGHT-KAdaptedHeight(35));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedHeight(-15));
            make.height.mas_equalTo(KAdaptedHeight(50));
        }];
        setViewCorner(_delBtn, KAdaptedHeight(25));
    }
    return _delBtn;
}

- (MLMaskView *)maskView{
    if (!_maskView) {
        _maskView = [[NSBundle mainBundle] loadNibNamed:@"MLMaskView" owner:nil options:nil].lastObject;
        _maskView.frame = CGRectMake(0, 0, ScreenViewWidth, ScreenViewHeight);
        
    }
    return _maskView;
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
//        _tableView.tableHeaderView=self.SwitchView;
        _tableView.rowHeight=KAdaptedHeight(55);
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH);
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
    
    EMO_EditUserMsgTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[EMO_EditUserMsgTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.dicData = self.dataArr[indexPath.row];
    cell.selectionStyle=0;
    return cell;
}


#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    switch (indexPath.row) {
        case 0:{
            if(self.type==3){
                EMO_BlackListViewController *vc=[EMO_BlackListViewController new];
                [wself.navigationController pushViewController:vc animated:YES];
            }else if(self.type==2){
                EMO_EditSettingVC *vc=[EMO_EditSettingVC new];
                vc.index=5;//修改绑定的手机号
                [wself.navigationController pushViewController:vc animated:YES];
            }else{
                EMO_EditSettingVC *vc=[EMO_EditSettingVC new];
                vc.index=1;//支付宝
                [wself.navigationController pushViewController:vc animated:YES];
            }
          
        }break;
        case 1:{
            if(self.type==3){
//                if([[UserManager userInfo].pid integerValue]>0){
//                    [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"您已绑定过邀请码")];
//                    return;
//                }
//                
//                EMO_EditSettingVC *vc=[EMO_EditSettingVC new];
//                vc.index=3;//邀请码
//                [self.navigationController pushViewController:vc animated:YES];
                
                
                if([[UserManager userInfo].real_name_status integerValue]==1){
                    return [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"审核中...")];
                }
                if([[UserManager userInfo].real_name_status integerValue]==2){
                    return [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"您已实名认证")];
                }
                EMO_RenZhengViewController *vc=[EMO_RenZhengViewController new];
                [wself.navigationController pushViewController:vc animated:YES];
                
            }else if(self.type==2){
                EMO_EditSettingVC *vc=[EMO_EditSettingVC new];
                vc.index=4;//密码
                [wself.navigationController pushViewController:vc animated:YES];
            }else{
                EMO_EditSettingVC *vc=[EMO_EditSettingVC new];
                vc.index=2;//weixin
                [wself.navigationController pushViewController:vc animated:YES];
            }

        }break;
        case 2:{
//            [wself.navigationController pushViewController:[EMO_AboutUsViewController new] animated:YES];
            
//            [SVProgressHUD showTextHUDWithMessage:@"设备管理"];
            
        }break;
//        case 3:{
//            
////            [self.navigationController pushViewController:[EMO_FeedbackViewController new] animated:YES];
//            
//            /** 绑定邀请码*/
//            if([[UserManager userInfo].pid integerValue]>0){
//                [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"您已绑定过邀请码")];
//                return;
//            }
//            
//            EMO_EditSettingVC *vc=[EMO_EditSettingVC new];
//            vc.index=3;//邀请码
//            [self.navigationController pushViewController:vc animated:YES];
//
//        }break;
        case 3:{
//            //青少年模式
//            EMO_AdolescentVC *vc = [[EMO_AdolescentVC alloc] init];
//            if([Common isEmptyString:UserDefaultsGet(@"APPPassWord")]){
//                vc.isON = NO;
//            }else{
//                vc.isON = YES;
//            }
//            vc.senderType = YES;
//            [self.navigationController pushViewController:vc animated:YES];
            
            /** 账号安全*/
            STAccountSafeVc *sa = [[STAccountSafeVc alloc]init];
            [self.navigationController pushViewController:sa  animated:YES];
        }break;
            
        case 4:{
            /** 关于我们*/
            [wself.navigationController pushViewController:[EMO_AboutUsViewController new] animated:YES];
        }break;
  
        case 5:{
            [self setLogOut];
        }break;
        case 6:{
//            [self setLogOut];
            if(([[UserManager userInfo].real_name_status integerValue]==2)||([[UserManager userInfo].money integerValue]>0)){
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:getLanguage(@"温馨提示") message:getLanguage(@"注销后将无法享受平台权益") preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self delUserData];
                }]];
                
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                [self delUserData];
            }
        }break;
        case 8:{
            
        }break;
        default:
            break;
    }
    
    
}






- (void)setMaskViewModel{
    [self.maskView setLeftButtonString:getLanguage(@"取消") rightButton:getLanguage(@"确定") promptLB:getLanguage(@"确定清除全部缓存吗？") maskViewH:140.f];
    self.maskView.determineClickBlock = ^{
         [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"清除成功")];
    };
    [self.view addSubview:self.maskView];
}


-(void)delUserData{
    
    [NetworkRequest POST:Request_cancellation parmeters:nil success:^(id responObject) {
        BaseModel *baseModel=(BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
        if(baseModel.code==1){
            [self getout];
        }
    } failture:^(NSError *error) {
        
    }];
  
}



- (void)setLogOut{
    WeakSelf;
    [self.maskView setLeftButtonString:getLanguage(@"取消") rightButton:getLanguage(@"确定") promptLB:getLanguage(@"账号退出后，将清除本地数据，您确定要退出登录么?") maskViewH:140.f];
    self.maskView.determineClickBlock = ^{
//        [wself getQuit_roomWithParameters];//退出房间
        [wself getout];
    };
    [self.view addSubview:self.maskView];
}



-(void)getout{
    UserDefaultsSave(@"", kToken);
    [UserManager clearUserInfo];
    [MLRoomInformationManager clearUserInfo];
    
    EMO_LoginViewController *loginVC = [[EMO_LoginViewController alloc] init];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.agoraKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
    }];
    [[RCCoreClient sharedCoreClient] logout];
    delegate.roomViewController = nil;
    ZXNavigationController *navVC = [[ZXNavigationController alloc] initWithRootViewController:loginVC];
    navVC.navigationBarHidden = YES;
    delegate.window.rootViewController = navVC;
}

//退出房间
- (void)getQuit_roomWithParameters{
    if (![MLRoomInformationModel currentAccount].room_id){
        [UserManager clearUserInfo];
        [MLRoomInformationManager clearUserInfo];
        return;
    }
    
    [NetworkRequest POST:Request_Quit_hand parmeters:@{@"room_id":[MLRoomInformationModel currentAccount].room_id} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        [UserManager clearUserInfo];
        [MLRoomInformationManager clearUserInfo];
    } failture:^(NSError *error) {
        
    }];

      
}

-(TKBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[[NSBundle mainBundle] loadNibNamed:@"TKBottomView" owner:self options:nil]lastObject];
        [_bottomView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _bottomView.contentView.height)];
        [_bottomView.btn setTitle:@"退出登录" forState:UIControlStateNormal];
        _bottomView.selectionStyle = UITableViewCellSelectionStyleNone ;
        _bottomView.bottom = SCREEN_HEIGHT_dy ;
    }
    return _bottomView ;
}

#pragma mark 获取用户数据
- (void)getUserInfoMessage
{
    [NetworkRequest POST:Request_UserInfo parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;

        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:baseModel.data];
        if([dic.allKeys containsObject:@"avatar_frame_image"]){
            [dic setObject:@(YES) forKey:@"is_zb"];
        }else{
            [dic setObject:@(NO) forKey:@"is_zb"];
        }
        [UserManager saveUserInfo:dic];

    } failture:^(NSError *error) {
        
    }];
}

@end
