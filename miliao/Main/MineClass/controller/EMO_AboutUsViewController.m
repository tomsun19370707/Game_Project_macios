//
//  EMO_AboutUsViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/5.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_AboutUsViewController.h"
#import "EMO_EditUserMsgTableViewCell.h"
#import "EMO_WebViewController.h"

#import <CSVisitorSDK/CSVisitorChatViewController.h>
#import <CSVisitorSDK/CSVisitorSDK.h>
#import <CSVisitorSDK/CSCustomInfoModel.h>
#import "EMO_OnLineChatViewController.h"

#import "MLSessionViewController.h"

@interface EMO_AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource,CS53ServiceDelegate>
Strong UITableView *listView;
Strong NSArray *listArray;
@end

@implementation EMO_AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBar:YES needBack:YES needBackground:YES];
    self.titleLabel.text=getLanguage(@"关于我们");
    self.titleLabel.font=KFont(18);
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    [self getOfficialWithParameters];
    self.listArray=@[@{@"data":@"",@"name":getLanguage(@"用户协议"),@"change":@"1"},@{@"data":@"",@"name":getLanguage(@"隐私协议"),@"change":@"1"},@{@"data":@"",@"name":getLanguage(@"联系客服"),@"change":@"1"}];
    
    [self createUI];
    
    
    // 0.在程序拿到访客ID信息的时候(比如app登录成功)方可登录，假设在此处拿到
    NSString *visitorId = [[NSUserDefaults standardUserDefaults] objectForKey:@"CSUserDefaults_SingleCompany_SaveVisitorId"];
    [[CS53Manager sharedManager] login53ServiceWithVisitorId:visitorId];
    
    // 1.设置代理
    [CS53Manager sharedManager].delegate = self;
    
}
- (void)createUI{
    UIImageView *logImg = [[UIImageView alloc] init];
    logImg.image = [UIImage imageNamed:@"logo1024"];
    [self.view addSubview:logImg];
    [logImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_offset(80);
        make.top.mas_offset(120);
        make.centerX.equalTo(self.view);
    }];
    setViewCorner(logImg, 10);
    
    UILabel *label=[[UILabel alloc] init];
    label.text=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    label.textColor=RGBA(0, 0, 0, 1);
    label.textAlignment=NSTextAlignmentCenter;
    label.font=KFont(16);
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(KAdaptedHeight(30));
        make.top.mas_equalTo(logImg.mas_bottom).offset(KAdaptedHeight(10));
        
    }];
    
    UILabel *VersionLabel=[[UILabel alloc] init];
    VersionLabel.text=[NSString stringWithFormat:@"%@%@",getLanguage(@"版本"),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    VersionLabel.textColor=RGBA(153, 153, 153, 1);
    VersionLabel.textAlignment=NSTextAlignmentCenter;
    VersionLabel.font=KFont(14);
    VersionLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(concernAction)];
    [VersionLabel addGestureRecognizer:tap];
    [self.view addSubview:VersionLabel];
    [VersionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(KAdaptedHeight(50));
        make.bottom.mas_equalTo(-KAdaptedHeight(30));
        
    }];
    

    
    _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.rowHeight = 60;
    _listView.bounces=NO;
    _listView.backgroundColor = [UIColor clearColor];
    _listView.showsVerticalScrollIndicator = NO;
    _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listView.tableFooterView = [UIView new];
    [self.view addSubview:_listView];
    [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(VersionLabel.mas_top).offset(KAdaptedHeight(-10));
        make.top.mas_equalTo(label.mas_bottom).offset(KAdaptedHeight(30));
        make.leading.mas_offset(14);
        make.trailing.mas_offset(-14);
    }];
    setViewCorner(_listView, 10);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMO_EditUserMsgTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[EMO_EditUserMsgTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.dicData = self.listArray[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==2){
//        [self showAleatView:@"" andMessage:[Common isNull:[UserManager userInfo].service]];
        
        //            CSPreMessageModel *textModel = [[CSPreMessageModel alloc] init];
        //            textModel.msgType = CSPreMessageTypeCustom;
        //            textModel.text = @"这是预发纯文本";
        //        chatVC.preMessageModelArr = @[textModel];
//    https://tb.53kf.com/code/client/075045a6f5595845d7b98a57215406eb4/1
//        EMO_OnLineChatViewController *chatVC = [[EMO_OnLineChatViewController alloc] initWithArg:@"10719921" style:@"1"];
//        [self.navigationController pushViewController:chatVC animated:YES];
        
        
//        EMO_WebViewController *vc=[EMO_WebViewController new];
//        vc.titleType=getLanguage(@"在线客服");
//        vc.strUrl= @"https://tb.53kf.com/code/client/075045a6f5595845d7b98a57215406eb4/1";
//        [self.navigationController pushViewController:vc animated:YES];
    
        
        /**  在线客服*/
        [self fetchRateConfig];
        
    }else{
        [self xieyiData:indexPath.row];

    }
    
}


-(void)showAleatView:(NSString *)tittle andMessage:(NSString*)message{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:tittle message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sendaction = [UIAlertAction actionWithTitle:getLanguage(@"呼叫") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",message];
        // NSLog(@"str======%@",str);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }];
    [alertVC addAction:cancelaction];
    [alertVC addAction:sendaction];
    [self presentViewController:alertVC animated:YES completion:nil];
}



- (void)getOfficialWithParameters{
    
    
    
//    客服电话
//    [NetworkRequest POST:@"" parmeters:nil success:^(id responObject) {
//        BaseModel *baseModel = (BaseModel *)responObject;
//        self.phoneStr = [Common isNull:baseModel.data];
//
//    } failture:^(NSError *error) {
//    }];
    
}

-(void)xieyiData:(NSInteger)type{
    
    [NetworkRequest POST:Request_AppText parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        EMO_WebViewController *vc=[EMO_WebViewController new];
        
//        NSArray *arr=baseModel.data;
//        NSDictionary *dic =arr[type];
//        if (type==0) {
//            dic=arr[0];
//            vc.titleType=getLanguage(@"用户协议");
//            vc.strUrl= @"https://www.baidu.com";
//        }else{
//            dic=arr[1];
//            vc.titleType=getLanguage(@"隐私协议");
//            vc.strUrl= @"https://www.baidu.com";
//        }
        NSDictionary *dic =baseModel.data[type];
        vc.titleType=dic[@"title"];
        vc.strUrl=dic[@"content"];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failture:^(NSError *error) {
        
        
    }];
     
}

-(void)concernAction{
    AppDelegate *delegate = APPDELEGATE;
    [delegate UpdataVersion];
}

#pragma mark - CS53ServiceDelegate

- (void)didFinishLoad{
    [[CS53Manager sharedManager] loadChatList];
    /**
       第三方会员信息对接功能，有需求的可参照下面调用
      
       1.必要条件: 在您拥有了visitorId, arg两个值之后才可调用，否则无效
       2.必要条件: 在didFinishLoad回调之后，不限于didFinishLoad这个方法体中。即didFinishLoad回调后的方法中，或之后的任意时刻调用
     
       3.下面只是一个简单的调用示例，在该demo中，第一次接入app，即第一次生成visitorId之前，下面的visitorId是大概率为空的
         您的对接不应该这样，应该严格遵守条件1。下面只是提供简单的调用方式而已。
     */
    NSString *visitorId = [[NSUserDefaults standardUserDefaults] objectForKey:@"CSUserDefaults_SingleCompany_SaveVisitorId"];
    if ([Common isEmptyString:visitorId]) return;
    CSCustomInfoModel *model = [[CSCustomInfoModel alloc] init];
    model.visitorId = visitorId;
    model.arg = @"10719921";
    model.userId = [UserManager userInfo].user_id;
    model.username =[UserManager userInfo].nickname;
    
//    model.phone = @"13513383659";
    // 您可以按需根据CSCustomInfoModel.h中属性的备注信息，按需传入您所需参数
    [[CS53Manager sharedManager] registerCustomInfo:model];
}

- (void)didReadVisitorId:(NSString *)visitorId{
    NSLog(@"需要保存访客ID:%@",visitorId);
    if ([Common isEmptyString:visitorId]) {
        return;
    }
    // 有账号登录的app，应该以账号唯一标识为键对应存储，并且可以同步至服务器
    NSString *localVisitorId = [[NSUserDefaults standardUserDefaults] objectForKey:@"CSUserDefaults_SingleCompany_SaveVisitorId"];
    
    if (![Common isEmptyString:localVisitorId] && [localVisitorId isEqualToString:visitorId]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:visitorId forKey:@"CSUserDefaults_SingleCompany_SaveVisitorId"];
}



- (void)dealloc{
    [CS53Manager sharedManager].delegate = nil;
    
    
}


/**  在线客服*/
- (void)fetchRateConfig
{
    WeakSelf
    [NetworkRequest POST:index_config parmeters:nil success:^(id responObject) {
        
        BaseModel *baseModel = (BaseModel *)responObject;
        
        /** 客服*/
        NSString *kefu_user_id = baseModel.data[@"kefu_user_id"];
        
        if ([NSString NotNull:kefu_user_id]) {
            MLSessionViewController *VC = [[MLSessionViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:kefu_user_id];
            VC.title = @"在线客服";
            [Dn_NAVPUSH pushViewController:VC animated:YES];
        }

    } failture:^(NSError *error) {
        
    }];
}

@end
