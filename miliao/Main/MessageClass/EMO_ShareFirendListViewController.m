//
//  EMO_ShareFirendListViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/31.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_ShareFirendListViewController.h"
#import "MLSessionViewController.h"

#import "YYF_ChatListTableViewCell.h"

#import "EMO_APPCustomMessage.h"

#import "EMO_APPCustomRoomMessage.h"

@interface EMO_ShareFirendListViewController ()<UITableViewDelegate,UITableViewDataSource,RCIMUserInfoDataSource,dgNavViewDelegate>
@property (nonatomic,strong) NSMutableArray *userMessageArr;
@property (nonatomic,strong) NSArray *optionTitles;
@property (nonatomic,strong) NSMutableArray *optionIcons;
@property (nonatomic,strong) dgNavView *navView;

@end

@implementation EMO_ShareFirendListViewController

-(void)viewWillAppear:(BOOL)animated{
//    [self viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];


    [self.conversationListTableView reloadData];
    [self refreshConversationTableViewIfNeeded];
    
}


-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=kWhiteColor;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"UpDataMessage" object:nil];

    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),]];
    
    self.conversationListTableView.frame=CGRectMake(0,ZJTopNavH+ZJStatusBarH, kWidth, kHeight-ZJTopNavH+ZJStatusBarH);
    self.conversationListTableView.dataSource=self;
    self.conversationListTableView.dataSource=self;
    self.conversationListTableView.separatorStyle=0;
    self.conversationListTableView.backgroundColor=kWhiteColor;
    self.conversationListTableView.showsVerticalScrollIndicator=NO;
    self.conversationListTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.conversationListTableView reloadData];
     [self refreshConversationTableViewIfNeeded];
    
    
    [self navView];
}

- (dgNavView*)navView {

    if (!_navView) {
        _navView = [[dgNavView alloc]initWithFrame:CGRectMake(0, ZJStatusBarH, kWidth, ZJTopNavH)];
        [_navView.backBtn setImage:KGetImage(@"fanhui") forState:UIControlStateNormal];
        _navView.titleStr=@"分享至";
        _navView.navLabel.textColor=RGBA(51,51,51,1);
        _navView.navLabel.alpha=1;
        _navView.backgroundColor=kWhiteColor;
        _navView.delegate = self;
        _navView.camareBtn.hidden=YES;
        [self.view addSubview:_navView];

    }
    return _navView;

}
-(void)navBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark 收到新消息
- (void)didReceiveMessageNotification:(NSNotification *)notification{
    
    [self.conversationListTableView reloadData];
    [self refreshConversationTableViewIfNeeded];
    [self notifyUpdateUnreadMessageCount];
//    [self messageBadgeValue];
}
#pragma mark 点击头像
- (void)didTapCellPortrait:(RCConversationModel *)model{
    NSLog(@"头像==%@",model);
    
}


#pragma mark  即将显示Cell的回调
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{

    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    NSLog(@"%@",model);
    
    if (model.conversationModelType!=3) {
        [[RCIM sharedRCIM] refreshUserInfoCache:[[RCIM sharedRCIM] getUserInfoCache:model.targetId] withUserId:model.targetId];
        RCConversationCell  *cellA= (RCConversationCell *)cell;
        cellA.selectionStyle=UITableViewCellSelectionStyleNone;
        [cellA setHeaderImagePortraitStyle:RC_USER_AVATAR_CYCLE];
        cellA.bubbleTipView.hidden=YES;
        cellA.statusView.hidden=YES;
        cellA.conversationTitle.text=[NSString stringWithFormat:@"%@",model.conversationTitle];
        cellA.conversationTitle.font=KFont(14);
        cellA.messageContentLabel.font=KFont(12);
        cellA.messageContentLabel.textColor=RGBA(102, 102, 102, 1);
        cellA.messageCreatedTimeLabel.font=KFont(10);
        cellA.messageCreatedTimeLabel.textColor=RGBA(153, 153, 153, 1);
        if ([model.objectName isEqualToString:@"app:BusinessCard"]) {
            cellA.messageContentLabel.text=getLanguage(@"[个人名片]");
        }
        if (model.unreadMessageCount>0) {
            UILabel *label=[[UILabel alloc]init];
            label.textColor=kWhiteColor;
            label.font=KFontBold(10);
            label.backgroundColor=kRedColor;
            label.layer.cornerRadius=KAdaptedWidth(15/2);
            label.layer.masksToBounds=YES;
            label.tag=100;
            label.text=[NSString stringWithFormat:@"%ld",(long)model.unreadMessageCount];
            label.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(cellA.messageCreatedTimeLabel.mas_trailing);
                make.bottom.mas_equalTo(cellA.messageContentLabel.mas_bottom);
                make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(15), KAdaptedWidth(15)));
                
            }];
            label.hidden=NO;
        }else{
            for (UILabel *label in cellA.contentView.subviews) {
                if (label.tag==100) {
                    [label removeFromSuperview];
                }
            }
        }
        
    }
  
    if (model.conversationType==6) {
        RCConversationCell  *cellA= (RCConversationCell *)cell;
        cellA.conversationTitle.text=getLanguage(@"官方消息");
        
    }
    
}
- (void)didDeleteConversationCell:(RCConversationModel *)model{
    
    
}


- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    YYF_ChatListTableViewCell *cell =[[YYF_ChatListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YJRChatListTableViewCell"];
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [cell setDataModel:model];
    return cell;

}


#pragma mark 会话列表数据源
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource{

    return dataSource;
   
}

/**
 *重写RCConversationListViewController的onSelectedTableRow事件
 *
 *  @param conversationModelType 数据模型类型
 *  @param model                 数据模型
 *  @param indexPath             索引
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    
    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE ||
        conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        [self pushChatVC:model];
//        return;
    }

 
}




- (void)pushChatVC:(RCConversationModel *)model {
    
    if(self.type==1){
        EMO_APPCustomMessage *txtMsg=[EMO_APPCustomMessage messageWithContentFamilyName:self.dicData[@"name"] andFamilyUrl:self.dicData[@"image"] andUser_id:[UserManager userInfo].user_id andFamilyId:self.dicData[@"id"] andFamilyLevel:self.dicData[@"family_level_image"]];
             RCMessage *message = [[RCMessage alloc]
               initWithType:ConversationType_PRIVATE
               targetId:model.targetId
               direction:MessageDirection_SEND
               content:txtMsg];
             [[RCIM sharedRCIM] sendMessage:message pushContent:nil pushData:nil successBlock:^(RCMessage *successMessage) {
                     //成功
                 NSLog(@"%@",successMessage);
                 }
                 errorBlock:^(RCErrorCode nErrorCode, RCMessage *errorMessage) {
                     //失败
                 NSLog(@"%ld==%@",(long)nErrorCode,errorMessage);
                 }];
        
        
    }else{
        
        EMO_APPCustomRoomMessage *txtMsg=[EMO_APPCustomRoomMessage messageWithContentRoomName:self.dicData[@"roomName"] andRoomUrl:self.dicData[@"roomImage"] andRoomId:self.dicData[@"roomId"] andRoomUuid:self.dicData[@"roomUuid"] andRoomStatus:self.dicData[@"roomStatus"] andRoomType:self.dicData[@"roomType"] andRoomNotice:self.dicData[@"roomNotice"]];
        
             RCMessage *message = [[RCMessage alloc]
               initWithType:ConversationType_PRIVATE
               targetId:model.targetId
               direction:MessageDirection_SEND
               content:txtMsg];
             [[RCIM sharedRCIM] sendMessage:message pushContent:nil pushData:nil successBlock:^(RCMessage *successMessage) {
                     //成功
                 NSLog(@"%@",successMessage);
                 }
                 errorBlock:^(RCErrorCode nErrorCode, RCMessage *errorMessage) {
                     //失败
                 NSLog(@"%ld==%@",(long)nErrorCode,errorMessage);
                 }];
        
    }
    
    [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"分享成功")];
    [self.navigationController popViewControllerAnimated:YES];

    
}




-(NSMutableArray *)userMessageArr{
    if (!_userMessageArr) {
        _userMessageArr=[NSMutableArray array];
    }
    return _userMessageArr;
}







@end
