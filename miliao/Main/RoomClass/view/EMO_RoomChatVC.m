//
//  EMO_MessageTwoViewController.m
//  miliao
//
//  Created by 张世浩 on 2022/11/12.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_RoomChatVC.h"
#import "EMO_RoomChatMessageVC.h"
#import "EMO_RoomChatHeaderView.h"
#import "YYF_ChatListTableViewCell.h"
#import "UITabBar+Badge.h"

#import "EMO_SysMsgViewController.h"//系统消息
#import "EMO_LikeViewController.h"//收到喜欢
#import "EMO_CollectViewController.h"//我的收藏
#import "EMO_PersonalDataBaseVC.h"//个人主页
#import "EMO_OhterUserDynamicVC.h"//我的收藏动态
#import "RoomFloatingWindow.h"
#import "MLSessionViewController.h"
#import "EMO_SysMsgViewController.h"
@interface EMO_RoomChatVC ()<UITableViewDelegate,UITableViewDataSource,RCIMUserInfoDataSource>
@property (nonatomic,strong) NSMutableArray *userArr;
@property (nonatomic,strong) NSMutableArray *userOnlineArr;
@property (nonatomic,strong) NSArray *optionTitles;
@property (nonatomic,strong) NSMutableArray *optionIcons;
@property (nonatomic,assign) NSInteger chatType;
@property (nonatomic,strong) EMO_RoomChatHeaderView *HeadView;

@end

@implementation EMO_RoomChatVC

-(void)viewWillAppear:(BOOL)animated{
//    [self viewWillAppear:animated];
//     [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.tabBarController.tabBar.hidden = NO;
    [self addOnlineData];
//    [self.conversationListTableView reloadData];
//    [self refreshConversationTableViewIfNeeded];
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


-(void)addData:(NSString *)strIDs{
    
    [NetworkRequest POST:Request_GetOnline parmeters:@{@"uids":strIDs} success:^(id responObject) {
        BaseModel *mode=(BaseModel *)responObject;
        [self.userOnlineArr removeAllObjects];
        NSArray *arr=mode.data;
        self.userOnlineArr=[NSMutableArray arrayWithArray:arr];
        [self.conversationListTableView reloadData];
        [self refreshConversationTableViewIfNeeded];
    } failture:^(NSError *error) {
        
        
    }];
}

-(void)addOnlineData{
    NSMutableArray *arr=[NSMutableArray array];
    for (RCConversation *mode in [[RCCoreClient sharedCoreClient] getConversationList:@[@(ConversationType_PRIVATE)] count:200 startTime:0]) {
        [arr addObject:mode.targetId];
    }
    [self addData:[arr componentsJoinedByString:@","]];
}

-(void)viewDidLoad{
    [super viewDidLoad];
//    self.view.backgroundColor=kWhiteColor;
    self.view.backgroundColor = UIColor.clearColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"UpDataMessage" object:nil];
    self.chatType=[NSUserTake(@"ChatSorting") integerValue];
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight - 450 - 44, kScreenWidth, 44)];
    topView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = UIColor.clearColor;
    backBtn.frame = CGRectMake(0,0, kScreenWidth, topView.top);
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.textColor = UIColor.blackColor;
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = KCFont(14);
    topLabel.text = @"消息";
    [topView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(14);
        make.right.mas_offset(-14);
        make.top.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    self.conversationListTableView.frame=CGRectMake(0,kScreenHeight - 450, kWidth, 450);
    self.conversationListTableView.dataSource=self;
    self.conversationListTableView.dataSource=self;
    self.conversationListTableView.separatorStyle=0;
    self.conversationListTableView.backgroundColor=kWhiteColor;
    self.conversationListTableView.tableHeaderView=self.HeadView;
    self.conversationListTableView.showsVerticalScrollIndicator=NO;
    self.conversationListTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}

//背景点击事件
-(void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 收到新消息
- (void)didReceiveMessageNotification:(NSNotification *)notification{
    [self addOnlineData];
    [self notifyUpdateUnreadMessageCount];
}

#pragma mark 点击头像
- (void)didTapCellPortrait:(RCConversationModel *)model{
    EMO_PersonalDataBaseVC *vc=[EMO_PersonalDataBaseVC new];
    vc.userID=model.targetId;
    [self.navigationController pushViewController:vc animated:YES];
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
        cellA.onlineView.backgroundColor=RGBA(23, 232, 0, 0);
        if(self.userOnlineArr.count>0){
            for (NSDictionary *dic in self.userOnlineArr) {
                if([dic[@"id"] integerValue]==[model.targetId integerValue]){
                    if([dic[@"online"] integerValue]==0){
                        cellA.onlineView.backgroundColor=RGBA(23, 232, 0, 1);
                    }
                    break;
                }
            }
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
//    if(self.userOnlineArr.count<1){
//        for (RCConversationModel *mode in dataSource) {
//            [self.userOnlineArr addObject:@((arc4random()%40)%3==0)];
//        }
//    }
    
    //    NSMutableArray *arr=[NSMutableArray array];
//    for (RCConversationModel *mode in dataSource) {
//        [arr addObject:mode.targetId];
//        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
//        [dict setObject:@"0" forKey:@"online"];
//        [dict setObject:mode forKey:@"mode"];
//        [arr addObject:dict];
//                [self.userArr addObject:dict];
//    }
//    self.userArr=[NSMutableArray arrayWithArray:dataSource];
//    [self addData:[arr componentsJoinedByString:@","]];
//        return self.userArr;

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
    }
}

-(void)MylettersTap:(UITapGestureRecognizer *)tap{
//    YJRMyMailViewController *vc=[YJRMyMailViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)pushChatVC:(RCConversationModel *)model {
    if([[UserManager userInfo].real_name_status intValue] == 2){
        //半屏
//        EMO_RoomChatMessageVC *VC = [[EMO_RoomChatMessageVC alloc] initWithConversationType:model.conversationType targetId:model.targetId];
//        VC.title = model.conversationTitle;
//            [self presentViewController:VC animated:YES completion:nil];
        
        if(self.dismisBlock){
            self.dismisBlock(model.targetId,model.conversationTitle);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:@"请先实名认证"]];
    }
}

#pragma mark 通知
- (void)InfoNotificationAction:(NSNotification *)notification{
    [self.conversationListTableView reloadData];
    [self refreshConversationTableViewIfNeeded];
}



-(NSMutableArray *)userArr{
    if (!_userArr) {
        _userArr=[NSMutableArray array];
    }
    return _userArr;
}
-(NSMutableArray *)userOnlineArr{
    if (!_userOnlineArr) {
        _userOnlineArr=[NSMutableArray array];
    }
    return _userOnlineArr;
}


- (BOOL)isHaveUnReadMessage
{
    static BOOL isHave;
    isHave = NO;
    WeakSelf;
    [[RCCoreClient sharedCoreClient] getTotalUnreadCountWith:^(int unreadCount) {
        if (unreadCount>0) {
            isHave = YES;
        }
    }];
    
    return isHave;
}

- (EMO_RoomChatHeaderView *)HeadView{
    if (!_HeadView) {
        _HeadView = [[EMO_RoomChatHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth,KAdaptedHeight(50))];
        _HeadView.backgroundColor = [UIColor whiteColor];
        _HeadView.userInteractionEnabled = YES ;
        
        WeakSelf
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            [wself dismissViewControllerAnimated:NO completion:^{
                            
            }];
            
            EMO_SysMsgViewController *se = [[EMO_SysMsgViewController alloc]init];
            [Dn_NAVPUSH pushViewController:se animated:YES];
        }];
        [_HeadView addGestureRecognizer:tap];
    }
    return _HeadView;
}



@end
