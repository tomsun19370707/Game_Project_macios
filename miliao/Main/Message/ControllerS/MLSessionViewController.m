//
//  MLSessionViewController.m
//  miliao
//
//  Created by aa on 2019/7/27.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "MLSessionViewController.h"

#import "MLSessionSetViewController.h"

#import "MDSessionPreviewVC.h"
#import "SelectPhotoManager.h"
#import "EMO_PersonalDataBaseVC.h"

#import "EMO_APPCustomMessage.h"
#import "EMO_APPCustomMessageCell.h"
#import "EMO_APPCustomRoomMessage.h"
#import "EMO_APPCustomRoomMessageCell.h"

#import "EMO_MyGuildXQViewController.h"//公会详情
#import "RoomPasswordView.h"
#import "EMO_MLRoomNewVC.h"
#import "EMO_StartPlayViewController.h"//直播开始
#import "EMO_EndPlayViewController.h"//直播结束
#import "MLSessionViewController+EMO_Photo.h"

@interface MLSessionViewController ()<RCIMReceiveMessageDelegate,dgNavViewDelegate>
//@property (nonatomic,strong) dgNavView *navView;
@property (nonatomic, strong)SelectPhotoManager *photoManager;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightTwoButton;
@property (nonatomic, assign) BOOL followIndex;

Strong RoomPasswordView *passWordView;

@end

@implementation MLSessionViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //    [self.leftButton removeFromSuperview];
    if(self.popBlock){
        self.popBlock();
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerClass:[EMO_APPCustomMessageCell class] forMessageClass:[EMO_APPCustomMessage class]];
    [self registerClass:[EMO_APPCustomRoomMessageCell class] forMessageClass:[EMO_APPCustomRoomMessage class]];
    
    // Do any additional setup after loading the view.
    //    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationConfession:) name:@"SendMessageNotification" object:nil];
    
    
    if (self.conversationType ==ConversationType_PRIVATE) {
        self.followIndex=NO;
        [self getMini_officialWithParameters];
        
    }else{
        
        [[RCCoreClient sharedCoreClient] setConversationToTop:ConversationType_SYSTEM targetId:self.targetId isTop:YES];//设置系统消息置顶
        [self.navigationController.navigationBar setBackgroundImage:KGetImage(@"") forBarMetrics:UIBarMetricsDefault];
    }
    
    [self setDisplayConversationTypeArray:@[@(ConversationType_PRIVATE)]];
    [self notifyUpdateUnreadMessageCount];
    ///删除扩展项
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:1];
    self.view.backgroundColor = [UIColor whiteColor];
    self.conversationMessageCollectionView.backgroundColor = RGBA(248, 248, 248, 1);
    self.displayUserNameInCell = NO;
}

- (RoomPasswordView *)passWordView{
    if (!_passWordView) {
        _passWordView = [[RoomPasswordView alloc] initWithFrame:CGRectMake(0, 0, ScreenViewWidth, ScreenViewHeight)];
    }
    return _passWordView;
}


- (void)didTapMessageCell:(RCMessageModel *)model{
    
    if ([model.content isKindOfClass:[EMO_APPCustomMessage class]]) {
        EMO_APPCustomMessage *messageModel=(EMO_APPCustomMessage *)model.content;
        EMO_MyGuildXQViewController *vc=[EMO_MyGuildXQViewController new];
        vc.guildID=messageModel.familyId;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    if ([model.content isKindOfClass:[EMO_APPCustomRoomMessage class]]) {
        EMO_APPCustomRoomMessage *messageModel=(EMO_APPCustomRoomMessage *)model.content;
        [self getIntoTheRoom:@{@"id":messageModel.roomId} passWord:@""];
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





#pragma mark 发送消息前先进行后台内容审核
-(void)InfoNotificationConfession:(NSNotification *)messageData{
    NSDictionary *dic=messageData.userInfo;
    [NetworkRequest POST:Request_CheckTask parmeters:nil success:^(id responObject) {
        NSLog(@"用于检测发消息的任务");
    } failture:^(NSError *error) {
        
    }];
    if ([dic[@"messageContent"] isKindOfClass:[RCImageMessage class]]) {
        RCImageMessage *msg=(RCImageMessage *)dic[@"messageContent"];
        [self GetToken:[UIImage imageWithData:msg.originalImageData] andDic:dic];
        
    } else {
        RCTextMessage *msg=(RCTextMessage *)dic[@"messageContent"];
        [NetworkRequest POST:Request_replaceText parmeters:@{@"message":msg.content} success:^(id responObject) {
            BaseModel *baseModel = (BaseModel *)responObject;
            [NetworkRequest POST:Request_CheckMessage parmeters:@{@"message":[Common isNull:baseModel.data]} success:^(id responObject) {
                msg.content = [Common isNull:baseModel.data];
                [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE
                    targetId:dic[@"targetId"]
                    content:msg//dic[@"messageContent"]
                    pushContent:dic[@"pushContent"]
                    pushData:nil
                    success:^(long messageId) {
                    }error:^(RCErrorCode nErrorCode, long messageId) {
                        DebugLog(@"error");
                    }];
            } failture:^(NSError *error) {
                
                
            }];
        } failture:^(NSError *error) {
            
        }];
    }
    
}

-(void)GetToken:(UIImage *)image andDic:(NSDictionary *)dic{
    [SVProgressHUD show];
    [NetworkRequest POST:Request_getQiNiuToken parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
            [self addavtarImg:image andToken:baseModel.data[@"qiniutoken"] andDataDic:dic];
    } failture:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

-(void)addavtarImg:(UIImage *)image andToken:(NSString *)token andDataDic:(NSDictionary *)dic{
        
//    WeakSelf;
    [NetworkRequest uploadOneImage:Request_AppUpload parameters:@{@"qiniutoken":token} image:image fileName:@"file" progress:^(NSProgress *uploadProgress) {
        
    } success:^(id responObject) {
//        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD dismiss];
        [[RCIM sharedRCIM] sendMediaMessage:ConversationType_PRIVATE targetId:dic[@"targetId"]
            content:dic[@"messageContent"]
        pushContent:dic[@"pushContent"]
           pushData:nil progress:nil success:nil error:nil cancel:nil];
        
    } error:^(NSError *errors) {
        [SVProgressHUD dismiss];
        
    }];
    

}


//- (dgNavView*)navView {
//
//    if (!_navView) {
//        _navView = [[dgNavView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZJTopNavH)];
//        [_navView.backBtn setImage:KGetImage(@"left_top_fanhui") forState:UIControlStateNormal];
//        _navView.titleStr=self.title;
//        _navView.navLabel.textColor=RGBA(51,51,51,1);
//        _navView.navLabel.alpha=1;
//        _navView.backgroundColor=kWhiteColor;
//        _navView.delegate = self;
//        _navView.camareBtn.hidden=YES;
//
//    }
//    return _navView;
//
//}
//-(void)navBackClick{
//    [self.navigationController popViewControllerAnimated:YES];
//}


#pragma mark 网络请求
- (void)getMini_officialWithParameters{
    
    [NetworkRequest POST:Request_getOtherUserInfo parmeters:@{@"to_uid":self.targetId} success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        NSDictionary *dicData=baseModel.data[@"user_info"];
        if([dicData[@"is_attention"] integerValue]==1){
            self.followIndex=YES;
        
            self.rightTwoButton.layer.contents=(id)KGetImage(@"followCancalImg").CGImage;
            [self.rightTwoButton setTitle:getLanguage(@"已关注") forState:UIControlStateNormal];
        }else{
            self.followIndex=NO;
            self.rightTwoButton.layer.contents=(id)KGetImage(@"followSelectImg").CGImage;
            [self.rightTwoButton setTitle:getLanguage(@"关注") forState:UIControlStateNormal];
        }
        
    } failture:^(NSError *errors) {

        
    }];
    

  
  
}
// 关注 取关
- (void)getCancel_followWithParameters{
    
    WeakSelf;
    [NetworkRequest POST:Request_GetfollowOrBlack parmeters:@{@"type":@"0",@"to_uid":self.targetId} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:basemodel.msg]];
        wself.followIndex=!wself.followIndex;
        if (wself.followIndex) {
            self.rightTwoButton.layer.contents=(id)KGetImage(@"followCancalImg").CGImage;
            [self.rightTwoButton setTitle:getLanguage(@"已关注") forState:UIControlStateNormal];
        }else{
            self.rightTwoButton.layer.contents=(id)KGetImage(@"followSelectImg").CGImage;
            [self.rightTwoButton setTitle:getLanguage(@"关注") forState:UIControlStateNormal];
        }

    } failture:^(NSError *error) {

    }];

}



#pragma mark NAV
///聊天设置
- (void)searchprogram:(UIButton *)sender{
    MLSessionSetViewController *VC = [[MLSessionSetViewController alloc] init];
    VC.ryUserID = self.targetId;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)guanzhuClick{
    [self getCancel_followWithParameters];
    
}

- (void)leftButtonBlackClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//获取选择图片的时间，重写，适配iOS13
///点击扩展项
- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    if (tag == 1001) {
        ///照片
//        [self.photoManager startSelectPhotoWithImageName:@"photoImage"];
//        __weak __typeof(self)weakSelf = self;
//        [self.photoManager setSuccessHandle:^(SelectPhotoManager *manager, UIImage *image) {
//            RCImageMessage *content = [RCImageMessage messageWithImageData:UIImageJPEGRepresentation(image, 0.4)] ;
//            [weakSelf sendMessage:content pushContent:@"【图片】"];
//        }];
        [self choosePicture];
        
    }
}

/*!
 查看图片消息中的图片

 @param model   消息Cell的数据模型

 @discussion SDK在此方法中会默认调用RCImageSlideController下载并展示图片。
 */
- (void)presentImagePreviewController:(RCMessageModel *)model{
    MDSessionPreviewVC *vc = [MDSessionPreviewVC new];
    vc.model = model;
    vc.modalPresentationStyle = 0;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark 融云回调
- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    //改变头像样式
    
    //改变字体颜色
//    if ([cell isMemberOfClass:RCTextMessageCell.class]) {
//        RCTextMessageCell *textCell = (RCTextMessageCell *)cell;
//        if (cell.messageDirection == MessageDirection_SEND) {
//            textCell.textLabel.textColor = [UIColor whiteColor];
//        }else{
//            textCell.textLabel.textColor = mainViceColor;
//        }
//    }
//    if ([cell isMemberOfClass:RCVoiceMessageCell.class]) {
//        RCVoiceMessageCell *textCell = (RCVoiceMessageCell *)cell;
//        if (cell.messageDirection == MessageDirection_SEND) {
//            textCell.voiceDurationLabel.textColor = [UIColor whiteColor];
//        }else{
//            textCell.voiceDurationLabel.textColor = MLControlsColor;
//        }
//    }
}
/*!
 接收消息的回调方法
 
 @param message     当前接收到的消息
 @param left        还剩余的未接收的消息数，left>=0
 
 @discussion 如果您设置了IMKit消息监听之后，SDK在接收到消息时候会执行此方法（无论App处于前台或者后台）。
 其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
 您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
 */
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    
}
/*!
 点击Cell中头像的回调
 
 @param userId  点击头像对应的用户ID
 */
- (void)didTapCellPortrait:(NSString *)userId{
    if (self.conversationType ==ConversationType_PRIVATE) {
        EMO_PersonalDataBaseVC *vc=[EMO_PersonalDataBaseVC new];
        vc.userID=userId;
        [self.navigationController pushViewController:vc animated:YES];
    }

}
- (void)notifyUpdateUnreadMessageCount{
    //    [super notifyUpdateUnreadMessageCount];
    //    int totalUnreadCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    
    if (self.conversationType ==ConversationType_PRIVATE) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,60,30)];
            [rightButton setImage:[UIImage imageNamed:@"dynamicMoreImg"]forState:UIControlStateNormal];
            [rightButton addTarget:self action:@selector(searchprogram:) forControlEvents:UIControlEventTouchUpInside];
    //        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    //        //设置
    //        UIBarButtonItem *btn0 = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(searchprogram:)];
    //        btn0.image = [UIImage imageNamed:@"xiaoxi_sz"];
            
            
            self.rightTwoButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,65,30)];
            self.rightTwoButton.layer.contents=(id)KGetImage(@"followSelectImg").CGImage;
            [self.rightTwoButton setTitle:getLanguage(@"关注") forState:UIControlStateNormal];
            [self.rightTwoButton setTitleColor:RGBA(34, 34, 34, 1) forState:UIControlStateNormal];
            self.rightTwoButton.titleLabel.font=KFont(13);
            self.rightTwoButton.layer.contents=(id)KGetImage(@"followSelectImg").CGImage;
            [self.rightTwoButton addTarget:self action:@selector(guanzhuClick) forControlEvents:UIControlEventTouchUpInside];
            
            //关注
            UIBarButtonItem *btn2 = [[UIBarButtonItem alloc] initWithCustomView:self.rightTwoButton];
            //设置
            UIBarButtonItem *btn1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:btn1, btn2, nil];

            self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(40,8,150,30)];
            [self.leftButton setImage:[UIImage imageNamed:@"fanhui"]forState:UIControlStateNormal];
            [self.leftButton addTarget:self action:@selector(leftButtonBlackClick) forControlEvents:UIControlEventTouchUpInside];
            [self.leftButton setTitle:[NSString stringWithFormat:@"  %@",self.title] forState:UIControlStateNormal];
            [self.leftButton setTitleColor:RGBA(34, 34, 34, 1) forState:UIControlStateNormal];
            self.leftButton.titleLabel.font=KFont(18);
            self.leftButton.backgroundColor = UIColor.clearColor;
//            self.leftButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
            self.title=@"";
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(20,8,150,30)];
            [self.leftButton setImage:[UIImage imageNamed:@"fanhui"]forState:UIControlStateNormal];
            [self.leftButton addTarget:self action:@selector(leftButtonBlackClick) forControlEvents:UIControlEventTouchUpInside];
            [self.leftButton setTitle:[NSString stringWithFormat:@"  %@",self.title] forState:UIControlStateNormal];
            [self.leftButton setTitleColor:RGBA(34, 34, 34, 1) forState:UIControlStateNormal];
            self.leftButton.titleLabel.font=KFont(18);
            self.leftButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            [self.navigationController.navigationBar addSubview:self.leftButton ];
            UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,5,5)];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
            self.title=@"";
            
        });
    }
    
   
}
-(SelectPhotoManager *)photoManager
{
    if (!_photoManager) {
        _photoManager = [[SelectPhotoManager alloc]init];
        _photoManager.canEditPhoto = NO;
    }
    return _photoManager;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
