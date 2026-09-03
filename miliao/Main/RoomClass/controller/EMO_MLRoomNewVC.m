//
//  EMO_MLRoomNewVC.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/7.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_MLRoomNewVC.h"
#import <WXApi.h>
#import "CustomAlertViewA.h"
#import "EMO_EndPlayViewController.h"//直播结束
#import "EMO_RoomTopView.h"//头视图
#import "EMO_RoomMoreView.h"//更多
#import "EMO_RoomSettingView.h"//房间设置
#import "EMO_ShareFirendListViewController.h"//分享好友
#import "EMO_OnlineUserView.h"//在线用户视图
#import "EMO_UserInfoView.h"//用户信息展示界面
#import "EMO_UserReportViewController.h"//举报界面
#import "EMO_PersonalDataBaseVC.h"//个人主页
#import "EMO_RechargeViewController.h"//充值界面
#import "EMO_RoomHostView.h"//主播和麦位视图
#import "EMO_RoomBarrageView.h"//最下边视图
#import "EMO_RoomClickUserView.h"//抱人上麦,锁麦
#import "EMO_RoomManagerView.h"//房间管理
#import "EMO_RewardListViewController.h"//打赏清单
#import "EMO_OperationlogViewController.h"//操作日志
#import "EMO_PrizeView.h"//抽奖视图
#import "MLInputBoxView.h"
#import "RoomFloatingWindow.h"//
#import "YYF_RoomGiftView.h"//礼物视图
#import "EMO_RoomFluctuationOfWheatView.h"
#import "CFMWalletDiamondRechargeVc.h"

#import "MLUserReportModel.h"//举报模型
#import "CC_VioceTopHengFuView.h"//进场横幅
#import "EMO_RoomSetViewController.h"//
#import "RoomMusicViewController.h"//音乐VC

#import "RoomBarrageMessageCell.h"//聊天消息
#import "RoomGiftMessageCell.h"//礼物消息

#import "MLRoomMessageModel.h"
#import "MLRoomMSequenceModel.h"
#import "MLRoomUserModel.h"
#import "MLRoomAdminModel.h"
//#import "RoomMusicModel.h"
#import "RoomGiftModel.h"
#import <HWPopController/HWPop.h>

#import "AwardModel.h"
#import "WebsocketManager.h"

#import "EMO_RoomSQSMView.h"

#import "RoomFuDaiModel.h"

#import "EMO_RoomAnnouncementView.h"//房间公告
#import "EMO_RankingListView.h"//排行榜

/** 抽奖弹窗*/
#import "CFMRewardPriseAlert.h"
/** 开启背景音乐*/
#import "CFMPlayerMusicListVc.h"

//弹幕所需
#import "LLBarrageRenderView.h"
#import "CustomBarrageCell.h"
#import "TextBarrageCell.h"
#import "CustomBarrageModel.h"
#import "NSString+LLAdd.h"

#import "EMO_RoomChatVC.h"
#import "MLSessionViewController.h"
#import "EMO_RoomGameAlertView.h"
#import "RunGamaViewController.h"
#import "MLChatRoomNativeGameView.h"
#import "MLChatRoomGameCenterDialog.h"
@interface EMO_MLRoomNewVC ()<UITableViewDelegate, UITableViewDataSource, AgoraRtcEngineDelegate, AgoraRtmDelegate, AgoraRtmChannelDelegate, UITextViewDelegate, SVGAPlayerDelegate,SRWebSocketDelegate,BarrageDataSource>


@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;
@property (nonatomic, strong) AgoraRtmKit     *agoraRtmKit;
@property (nonatomic, strong) AgoraRtmChannel   *channel;
@property (nonatomic, strong) AgoraRtmChannelAttributeOptions *channelAttributeOption;
@property (nonatomic, strong) AgoraRtcEngineKit   *agoraKitPublic;
@property (nonatomic, strong) AgoraRtmKit  *agoraRtmKitPublic;
@property (nonatomic, strong) AgoraRtmChannel *channelPublic;//用来全局发送消息
@property (nonatomic, strong) UITableView     *tableView;
@property (nonatomic, strong) NSMutableArray  *listArry;
@property (nonatomic, strong) NSMutableArray *sequenceArray;
@property (nonatomic, strong) NSMutableArray *reportArray;
@property (nonatomic, strong) NSMutableArray  *soundArray;
@property (nonatomic, strong) NSMutableArray *userSelectedArray;
@property (nonatomic, strong) NSMutableArray *playSvgaArray;
@property (nonatomic, strong) NSMutableArray *roomUserArray;
@property (nonatomic, strong) UIImageView   *bgImageView;

@property (nonatomic, strong) EMO_RoomSQSMView     *roomWheatView;
@property (nonatomic, strong) EMO_RoomTopView  *roomTopView;
@property (nonatomic, strong) EMO_RoomHostView   *roomHostView;
@property (nonatomic, strong) EMO_RoomBarrageView   *roomBarrageView;
@property (nonatomic, strong) EMO_RoomMoreView   *roomMoreView;
@property (nonatomic, strong) EMO_RoomSettingView   *roomSettingView;
@property (nonatomic, strong) EMO_RankingListView * rankingListView;
@property(nonatomic,strong) EMO_RoomAnnouncementView * roomAnnouncementView;
@property (nonatomic, strong) EMO_RoomClickUserView    *roomClickUserView;
@property (nonatomic, strong) MLInputBoxView   *inputBoxView;

@property (nonatomic, strong) YYF_RoomGiftView   *newRoomGiftView;
@property (nonatomic, strong) EMO_RoomFluctuationOfWheatView            *fluctuationOfWheatView;
@property (nonatomic, strong) EMO_OnlineUserView            *onlineUserView;
@property (nonatomic, strong) EMO_RoomManagerView *roomManagerView;
@property (nonatomic, strong) EMO_PrizeView *prizeView;

@property (nonatomic, strong) NSDictionary   *attributes;
@property (nonatomic, assign) BOOL             isClose;
@property (nonatomic, strong) NSString        *reportID;
@property (nonatomic, strong) NSString        *reportType;
@property (nonatomic, strong) NSMutableArray *giftImageArrar;
@property (nonatomic, strong) SVGAPlayer   *giftSelectedImage;
//@property (nonatomic, strong) NSMutableDictionary  *dictInfo;
//@property(nonatomic, assign) NSInteger first;//是否刚进入直播间
@property(nonatomic, strong) WebsocketManager *socketManager;
@property(nonatomic, strong) SRWebSocket *socket;//socket
@property (nonatomic, strong) EMO_UserInfoView *roomUserInfoView;//点击头像弹出的用户信息页面
///app大频道
@property(nonatomic, strong)  AgoraRtmChannel * allChannel;
@property (nonatomic, assign) BOOL    shangMai;
@property (nonatomic, assign) NSInteger firstKaiMai;
@property (nonatomic, strong) LLBarrageRenderView *renderView;//弹幕view
@property (nonatomic, strong) NSMutableArray *renderDataList;
Assign BOOL AllCloseMicrophone;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger countTime;
@property (nonatomic,assign) BOOL startOrCloseTime;
@property (nonatomic,strong) UILabel *timeLabel;

/** 音乐开启按钮*/
@property (nonatomic,strong) UIButton *musicBtn;
/** 可选，当前直播间 正在播放的音乐，用于回显*/
@property (nonatomic,strong) NSString *currentLiveRoomPlayMusic;
/** 记录房间信息*/
@property (nonatomic,strong) NSMutableDictionary *currentRoomInfo;
@end


@implementation EMO_MLRoomNewVC

static SVGAParser *parser;
-(NSMutableArray *)renderDataList{
    if (!_renderDataList) {
        _renderDataList=[NSMutableArray array];
    }
    return _renderDataList;
}
-(NSMutableArray *)playSvgaArray{
    if (!_playSvgaArray) {
        _playSvgaArray=[NSMutableArray array];
    }
    return _playSvgaArray;
}
-(NSMutableArray *)roomUserArray{
    if (!_roomUserArray) {
        _roomUserArray=[NSMutableArray array];
    }
    return _roomUserArray;
}
-(void)freshMXList{
    PostNoticeObserver(@"uploadSQSMListData", nil);
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    AppDelegate *delegate = APPDELEGATE;
    if (delegate.roomViewController) {
        [self.roomHostView setWaveLayerToView];
    }
    [self performSelector:@selector(freshMXList) withObject:nil afterDelay:1.0f];
    [self uploadMessageNum];
}
#pragma mark ======================  断开socket链接   ======================
- (void)duankaiSocketMethod {
    //    [self.socket close];
}

- (void)viewWillDisappear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    AppDelegate *delegate = APPDELEGATE;
    if (_isClose) {
        delegate.roomViewController = self;
    }else{
        delegate.roomViewController = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.first = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"UpDataMessage" object:nil];
    self.firstKaiMai=1;
    self.shangMai=YES;
    self.countTime=300;
    self.startOrCloseTime=NO;
    [self loadBar:NO needBack:NO needBackground:YES];
    self.view.backgroundColor = ML_DarkColor;
    self.bgView.backgroundColor = ML_DarkColor;
    _isClose = YES;
    self.AllCloseMicrophone=NO;
    [self setAgoraRtcEngineKitOrAgoraRtmKit];
    
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PopReChangeViewController) name:@"PopReChangeViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outOfTheClick:) name:@"RoomOutOfTheClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openBoxWithPublicMethod:) name:@"socketNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CloseRoomNotification) name:@"CloseRoomNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CloseRoomUserNotification) name:@"CloseRoomUserNotification" object:nil];
    
    [self setUIViewUp];
    
    //    [self room_introClick];
    
    
    WeakSelf
    /** 添加音乐入口*/
    [self.view addSubview:self.musicBtn];
    [self.view bringSubviewToFront:self.musicBtn];
    [[self.musicBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        if (wself.musicBtn.tag==1) {
            DYActionSheet *sheet = [[DYActionSheet alloc]initWithTitleArr:@[@"关闭当前音乐",@"重新选择音乐"]];
            [sheet setDActionSheetClick:^(int index, NSString *title) {
                if (index==0) {
                    /** 关闭推流的 混合音乐背景*/
                    [wself stopMixAudioBgm];
                }else if (index==1) {
                    /** 选择音乐*/
                    [wself chooseMusic];
                }
            }];
            [sheet show];
            return;
        }
        
        /** 选择音乐*/
        [wself chooseMusic];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.socket || self.socket.readyState == SR_CLOSED || self.socket.readyState == SR_CLOSING) {
        self.socket = [[SRWebSocket alloc] initWithURLRequest:
                       [NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://www.wx00fx.cn:9090/ws"]]];
        self.socket.delegate = self;
    }
    
    // 🎯 推荐：使用 Utility QoS，适合后台网络任务
    // Utility QoS 适用于：
    // - 用户不需要立即看到结果的任务
    // - 网络请求、后台下载
    // - 长时间运行的计算
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(
                                                                         DISPATCH_QUEUE_SERIAL,
                                                                         QOS_CLASS_UTILITY,  // 使用 Utility 级别
                                                                         0
                                                                         );
    dispatch_queue_t queue = dispatch_queue_create("com.emo.websocket.connect", attr);
    
    if (self.socket.readyState == SR_CONNECTING) {
        dispatch_async(queue, ^{
            [self.socket open];
        });
    }
}




/** 选择音乐*/
- (void)chooseMusic
{
    /** 关闭推流的 混合音乐背景*/
    [self stopMixAudioBgm];
    
    WeakSelf
    CFMPlayerMusicListVc *pl = [[CFMPlayerMusicListVc alloc]init];
    pl.fetchSaveMusicFile = ^(NSString *musicUrl) {
        wself.currentLiveRoomPlayMusic = musicUrl ;
        /** 开启混音播放音乐*/
        [wself openMixMusicPlayHandle:musicUrl];
    };
    pl.currentLiveRoomPlayMusic = self.currentLiveRoomPlayMusic ;
    [wself.navigationController pushViewController:pl  animated:YES];
}

//接收到新消息
- (void)InfoNotificationAction:(NSNotification *)notification{
    [self uploadMessageNum];
}

-(void)uploadMessageNum{
    WeakSelf;
    [[RCCoreClient sharedCoreClient] getTotalUnreadCountWith:^(int unreadCount) {
        if(unreadCount>0){
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.roomBarrageView.messageNum.hidden = NO;
                wself.roomBarrageView.messageNum.text = [NSString stringWithFormat:@"%d",unreadCount];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.roomBarrageView.messageNum.hidden = YES;
            });
        }
    }];
}

#pragma matk
-(void)CloseRoomNotification{
    [self getQuit_roomWithParameters:1];
}

-(void)CloseRoomUserNotification{
    
    NSDictionary *dict = @{
        @"messageType":@"9"};
    [self appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict]];
    AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict]];
    [self.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
        
    }];
    [self getQuit_roomWithParameters:2];
}

#pragma mark - SRWebSocketDelegate
-(void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"✅✅打开socket");
    //    [self endReConnectTimer];
    //    [self destoryNetWorkCheckingTimer];
    //    [self.socket sendString:@"action=sendallmessage&content=1" error:nil];
    
    //    [self.socket sendString:@"ssssssssss" error:nil];
    //    [SVProgressHUD showSuccessWithStatus:@"连接成功"];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:@"reg" forKey:@"action"];
    [dictionary setValue:[NSString stringWithFormat:@"%@",[MLRoomInformationModel currentAccount].room_id] forKey:@"homeid"];
    [dictionary setValue:@"1" forKey:@"content"];
    [self.socket sendString:[dictionary modelToJSONString] error:nil];
    NSLog(@"链接成功！");
}

-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSDictionary *dic = [self dictionaryWithJsonString:message];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"socketNotification" object:nil];
    if ([dic[@"code"] isEqualToString:@"202"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"socketNotification" object:nil userInfo:[self dictionaryWithJsonString:dic[@"data"]]];
    }
    NSLog(@"✅✅✅✅✅✅----%@", message);
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"❌❌socket连接失败 = %@", error);
    //    [SVProgressHUD dismiss];
    //    if (self.isActivelyClose) {
    //        return;
    //    }
    //    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
    //        [self startNetWorkStartChekingTimer];//开启网络检测
    //    } else {
    //        [self reConnectWebSocket];
    //    }
}

-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"❌❌socket失去连接 = %@", reason);
}
#pragma mark ======================  宝箱全服通告   ======================

- (void)openBoxWithPublicMethod:(NSNotification *)notition {
    //    __weak __typeof(self)weakSelf = self;
    NSDictionary *dic = notition.userInfo;
    NSLog(@"*************dic = %@",dic);
    NSString *message = @"";
    if ([dic[@"message"] length]>0) {
        for (NSDictionary *ddd in dic[@"awardList"]) {
            message = [NSString stringWithFormat:@"%@ %@%@钻x%@",message,[ddd objectForKey:@"name"],[ddd objectForKey:@"price"],[ddd objectForKey:@"num"]];
        }
        //        message = dic[@"message"];
    }else{
        message = dic[@"award_tips"];
    }
    
    NSDictionary *dict = @{@"nickName":dic[@"nickName"],
                           @"user_id":dic[@"user_id"],
                           @"message":message,
                           @"box_class":dic[@"box_class"],
                           @"messageType":@"6666",
                           @"roomId222":dic[@"roomId222"]
    };
    if ([[MLRoomInformationModel currentAccount].room_id integerValue]==[dic[@"roomId222"] integerValue]) {
        //本房间不播报
    }else{
        [self appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict]];
    }
}
// 发送一条消息
- (void)sendMsg:(NSDictionary *)msg{
    NSDictionary *dic = @{@"action":@"sendallmessage",@"homeid":[NSString stringWithFormat:@"%@",[MLRoomInformationModel currentAccount].room_id],@"content":[msg modelToJSONString]};
    [self.socket sendString:[dic modelToJSONString] error:nil];
}

- (void)outOfTheClick:(NSNotification *)notification
{
    ///全服公屏显示
    NSDictionary *notificationDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo[@"data"]];
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:notificationDic];
    [mutDic setValue:@"6666" forKey:@"messageType"];
    [mutDic setValue:[MLRoomInformationModel currentAccount].room_id forKey:@"roomId222"];
    NSMutableArray *awardArray = [[NSMutableArray alloc] init];
    NSArray *dataArray = [[NSArray alloc] initWithArray:mutDic[@"awardList"]];
    NSArray *titleArr=[NSArray array];
    if (dataArray.count>1) {
        titleArr=[mutDic[@"award_tips"] componentsSeparatedByString:@" "];
    }
    NSInteger titleIndex=0;
    for (AwardModel *model in dataArray) {
        NSMutableDictionary *awardDic = [[NSMutableDictionary alloc] init];
        awardDic[@"giftID"] = model.giftID;
        awardDic[@"name"] = model.name;
        awardDic[@"num"] = model.num;
        awardDic[@"price"] = model.price;
        awardDic[@"show_img"] = model.show_img;
        awardDic[@"is_public_play"] = model.is_public_play;
        awardDic[@"is_play"] = model.is_play;
        awardDic[@"radio_event"] = model.radio_event;
        [awardArray addObject:awardDic];
        if (dataArray.count>1) {
            if ([Common isEmptyString:titleArr[titleIndex]]) {
                titleIndex++;
            }
            [mutDic setValue:titleArr[titleIndex] forKey:@"award_tips"];
            titleIndex++;
        }
        
        if (![self isEmptyString:mutDic[@"award_tips"]] ) {
            if ([model.radio_event integerValue]!=2) {
                if ([model.radio_event integerValue]==1||([model.radio_event integerValue]==4)) {
                    //有礼物名称
                    mutDic[@"message"] = mutDic[@"award_tips"];
                    mutDic[@"awardList"] = awardArray;
                    //    [self sendMsg:mutDic.mutableCopy];
                    
                    NSString *jsonStr = [NSString dictionaryToJson:mutDic];
                    AgoraRtmMessage *allMessage = [[AgoraRtmMessage alloc] initWithText:jsonStr];
                    [self appendInfoToTableViewWithInfo:[NSString dictionaryToJson:mutDic.mutableCopy]];
                    [self.allChannel sendMessage:allMessage completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
                        
                    }];
                }
                
                if ([model.radio_event integerValue]==1||([model.radio_event integerValue]==3)) {
                    //本房间的公屏显示
                    NSDictionary *dict1 = @{@"nickName":notification.userInfo[@"data"][@"nickName"],
                                            @"user_id":notification.userInfo[@"data"][@"user_id"],
                                            @"vip_img":notification.userInfo[@"data"][@"vip_img"],
                                            //                                            @"message":notification.userInfo[@"data"][@"award_tips"],
                                            @"message":mutDic[@"award_tips"],
                                            @"box_class":notification.userInfo[@"data"][@"box_class"],
                                            @"messageType":@"13"};
                    AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict1]];
                    [self appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict1]];
                    [self.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
                        
                    }];
                }
                
            }
        }
    }
    //    if (![self isEmptyString:mutDic[@"award_tips"]] ) {
    //
    //
    //        //有礼物名称
    //        mutDic[@"message"] = mutDic[@"award_tips"];
    //        mutDic[@"awardList"] = awardArray;
    //        //    [self sendMsg:mutDic.mutableCopy];
    //
    //        NSString *jsonStr = [NSString dictionaryToJson:mutDic];
    //        AgoraRtmMessage *allMessage = [[AgoraRtmMessage alloc] initWithText:jsonStr];
    //        [self appendInfoToTableViewWithInfo:[NSString dictionaryToJson:mutDic.mutableCopy]];
    //        [self.allChannel sendMessage:allMessage completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
    //
    //        }];
    //
    //        //本房间的公屏显示
    //        NSDictionary *dict1 = @{@"nickName":notification.userInfo[@"data"][@"nickName"],
    //                                @"user_id":notification.userInfo[@"data"][@"user_id"],
    //                                @"vip_img":notification.userInfo[@"data"][@"vip_img"],
    //                                @"message":notification.userInfo[@"data"][@"award_tips"],
    //                                @"box_class":notification.userInfo[@"data"][@"box_class"],
    //                                @"messageType":@"13"};
    //        AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict1]];
    //        [self appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict1]];
    //        [self.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
    //
    //        }];
    //    }
    //
    
}

//字符串为空检查
- (BOOL)isEmptyString:(NSString *)sourceStr {
    if ((NSNull *)sourceStr == [NSNull null]) {
        return YES;
    }
    if (sourceStr == NULL) {
        return YES;
    }
    if (sourceStr == nil) {
        return YES;
    }
    if ([sourceStr isEqualToString:@""]) {
        return YES;
    }
    if (sourceStr.length == 0) {
        return YES;
    }
    if ([sourceStr isEqualToString:@"null"]) {
        return YES;
    }
    if ([sourceStr isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([sourceStr isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}

- (void)PopReChangeViewController
{
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.3];
}
-(void) delay
{
    EMO_RechargeViewController *vc = [[EMO_RechargeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark- 延时
- (void)delayCode:(UIImageView *)giftImage{
    [giftImage removeFromSuperview];
}


#pragma mark- SVGAPlayerDelegate
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player{
    [self.playSvgaArray removeFirstObject];
    [self.giftSelectedImage removeFromSuperview];
    self.giftSelectedImage = nil;
    if (self.playSvgaArray.count>0) {
        [self PlaySVGA:self.playSvgaArray[0]];
    }
}
- (void)svgaPlayerDidAnimatedToFrame:(NSInteger)frame{
    
}
- (void)svgaPlayerDidAnimatedToPercentage:(CGFloat)percentage{
    
}

#pragma mark- 拼接接收到的消息到聊天框
- (void)appendInfoToTableViewWithInfo:(NSString *)infoStr {
    //TODO  1：正常的 聊天消息  2：进入房间  3： 刷新麦序列表
    // 4 ：礼物消息  5 ：表型消息 6：清空消息  9 主播下播 10开启倒计时 11关闭倒计时 12退出房间 7房间设置,6666全服播报，13，本房间开箱子 16(开关麦刷新光圈)
    //    333 刷新上下麦用户列表  7770 礼物飘屏 7771宝箱飘屏   7772塔罗牌飘屏  7773大胃王飘屏
    
    
    __weak __typeof(self)weakSelf = self;
    MLRoomMessageModel *model = [MLRoomMessageModel mj_objectWithKeyValues:[NSString dictionaryWithJsonString:infoStr]];
    NSLog(@"SSSSSS=%@=====消息内容：%@",model.messageType,infoStr);
    if ([model.messageType isEqualToString:@"13"]) {
        if (model.awardList.count > 0) {
            NSArray * arr = model.awardList;
            NSString * nameStr = [[NSString alloc] init];
            for (NSDictionary * dd in arr) {
                nameStr = [NSString stringWithFormat:@"%@ %@%@钻x%@",nameStr,[dd objectForKey:@"name"],[dd objectForKey:@"price"],[dd objectForKey:@"num"]];
            }
            //刷新列表
            CGSize cellSizeH = [NSStringFormat(@"哇哦，%@ 在普通蛋中开出来了%@", model.nickName, nameStr) sizeWithFont:Font(14) With:ScreenViewWidth - 40-100-50];
            model.cellHeight = cellSizeH.height + 15;
            CGSize cellSizeW = [NSStringFormat(@"哇哦，%@ 在普通蛋中开出来了%@！", model.nickName, nameStr) sizeWithFont:Font(15) hiegth:20];
            CGFloat cellW = cellSizeW.width;
            CGFloat cellSW = ScreenViewWidth - 40;
            
            if (cellW > cellSW) {
                model.cellWeight = cellSW;
            }else{
                model.cellWeight = cellW;
            }
        }else{
            //刷新列表
            CGSize cellSizeH = [NSStringFormat(@"哇哦，%@ 在普通蛋中开出来了%@", model.nickName, model.message) sizeWithFont:Font(14) With:ScreenViewWidth - 40-100-50];
            model.cellHeight = cellSizeH.height + 15;
            CGSize cellSizeW = [NSStringFormat(@"哇哦，%@ 在普通蛋中开出来了%@！", model.nickName, model.message) sizeWithFont:Font(15) hiegth:20];
            CGFloat cellW = cellSizeW.width;
            CGFloat cellSW = ScreenViewWidth - 40;
            
            if (cellW > cellSW) {
                model.cellWeight = cellSW;
            }else{
                model.cellWeight = cellW;
            }
        }
        [self.listArry addObject:model];
        [self.tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.listArry.count - 1 inSection:0];
            [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
        
    }
    else if ([model.messageType isEqualToString:@"3"]) {
        
        [self getMicrophone_statusWithParameters:3];
    }
    else if ([model.messageType isEqualToString:@"10"]) {
        self.startOrCloseTime=!self.startOrCloseTime;
        [self startOrCloseTimeData:2];
    }
    else if ([model.messageType isEqualToString:@"11"]) {
        self.startOrCloseTime=!self.startOrCloseTime;
        [self startOrCloseTimeData:2];
    }
    else if ([model.messageType isEqualToString:@"12"]) {
        [self getRoomUsersWithParameters:2];//有用户退出房间
    }
    else if ([model.messageType isEqualToString:@"16"]) {
        //        (开关麦刷新光圈)安卓用
    }
    else if ([model.messageType isEqualToString:@"333"]) {
        if([[MLRoomInformationModel currentAccount].uuid integerValue]==[[UserManager userInfo].user_id integerValue]){
            self.roomWheatView.freshDara=YES;//刷新上麦用户列表
        }
        
    }
    else if ([model.messageType isEqualToString:@"7770"]||[model.messageType isEqualToString:@"7771"]) {
        
        /** 2026-01-22送礼物的动画去掉*/
        
        //        [model.userInfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //            NSDictionary *dict = obj;
        //            if ([dict[@"is_first"] integerValue] == 1) {
        //                return ;
        //            }
        //            MLRoomMessageModel *messageModelmodel = [[MLRoomMessageModel alloc] init];
        //            messageModelmodel.user_id = model.user_id;
        //            messageModelmodel.nickName = model.nickName;
        //            messageModelmodel.nick_color = [Common isNull:model.nick_color];
        //            messageModelmodel.messageType = model.messageType;
        //            messageModelmodel.giftNum = model.giftNum;
        //            messageModelmodel.show_img = model.show_img;
        //            messageModelmodel.toNickName = dict[@"nickname"];
        //            messageModelmodel.peerage_image = model.peerage_image;
        //            messageModelmodel.vip_num = model.vip_num;
        //            messageModelmodel.gift_name = model.gift_name;
        //            if (model.nickName.length>6) {
        //                messageModelmodel.nickName = [NSString stringWithFormat:@"%@...",[model.nickName substringToIndex:5]];
        //            }
        //            NSString *str = dict[@"nickname"];
        //            if ([dict[@"nickname"] length]>6) {
        //                messageModelmodel.toNickName = [NSString stringWithFormat:@"%@...",[str substringToIndex:6]];
        //            }
        //            messageModelmodel.toUser_id = dict[@"userId"];
        //            messageModelmodel.toNick_color = dict[@"nick_color"];
        //            [self addNewData:@[messageModelmodel]];
        //
        //
        //        }];
        
        
        
        return;
    }
    else if ([model.messageType isEqualToString:@"7772"]||[model.messageType isEqualToString:@"7773"]) {
        //        [self addNewData];
        //        MLRoomMessageModel *messageModelmodel = [[MLRoomMessageModel alloc] init];
        //        messageModelmodel.coin = model.coin;
        //        messageModelmodel.nickName = model.nickName;
        //        messageModelmodel.nick_color = model.nick_color;
        //        messageModelmodel.messageType = model.messageType;
        //        messageModelmodel.message = model.message;
        [self addNewData:@[model]];
        return;
    }
    else if ([model.messageType isEqualToString:@"6666"]) {
        //刷新列表
        CGSize cellSizeH = [NSStringFormat(@"大吉大利【全服】，恭喜 %@ 在普通蛋中开出来了%@", model.nickName, model.message) sizeWithFont:Font(14) With:ScreenViewWidth - 40-100-50];
        model.cellHeight = cellSizeH.height + 15;
        CGSize cellSizeW = [NSStringFormat(@"大吉大利【全服】，恭喜 %@ 在普通蛋中开出来了%@", model.nickName, model.message) sizeWithFont:Font(15) hiegth:20];
        CGFloat cellW = cellSizeW.width;
        CGFloat cellSW = ScreenViewWidth - 40;
        if (cellW > cellSW) {
            model.cellWeight = cellSW;
        }else{
            model.cellWeight = cellW;
        }
        
        [self.listArry addObject:model];
        [self.tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.listArry.count - 1 inSection:0];
            [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
        
    }
    else if ([model.messageType isEqualToString:@"401"]) {
        //清空魅力值之后，刷新页面魅力值
        [self getMicrophone_statusWithParameters:3];
        //        self.first = 2;
    }
    else if([model.messageType isEqualToString:@"4"]){
        //礼物 收到礼物之后刷新麦位魅力值和房主魅力值
        //        self.first = 2;
        [self getMicrophone_statusWithParameters:3];
        [self getRoomInfoWithParameters:2 commplete:^{
            
        }];
        
        
        NSString *imgStr=[Common isNull:model.show_gif_img];
        if ([imgStr hasSuffix:@".svga"]||[imgStr hasSuffix:@".SVGA"]) {
            [self.playSvgaArray addObject:model.show_gif_img];
            if (self.playSvgaArray.count==1) {
                [weakSelf PlaySVGA:model.show_gif_img];
            }
            if (model.userInfo.count>1) {
                for (int i=0; i<model.userInfo.count-1; i++) {
                    [self.playSvgaArray addObject:model.show_gif_img];
                }
            }
            
        }else{
            [model.userInfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dict = obj;
                NSMutableArray *sequArr=[NSMutableArray arrayWithArray:weakSelf.sequenceArray];
                if (sequArr.count > 0) {
                    [sequArr removeObjectAtIndex:0];
                }
                //                    for (int i = 0; i < weakSelf.sequenceArray.count; i++) {
                for (int i = 0; i < sequArr.count; i++) {
                    UIImageView *gift = [ControlCreator createImageView:weakSelf.bgView rect:CGRectMake(weakSelf.bgView.width - 30, weakSelf.bgView.height - 30, 0, 0) imageName:@"" backguoundColor:[UIColor clearColor]];
                    [gift sd_setImageWithURL:[NSURL URLWithString:model.show_img]];
                    
                    MLRoomMSequenceModel *model = sequArr[i];
                    if ([dict[@"userId"] integerValue] == [[Common isNull:model.uid] integerValue]) {
                        CGRect giftFrame = [weakSelf.roomHostView hostFrameWithUserID:dict[@"userId"] idx:i];
                        [UIView transitionWithView:gift duration:2 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionTransitionFlipFromRight animations:^{
                            gift.frame = CGRectMake(giftFrame.origin.x+10 , giftFrame.origin.y + 32+(i>3?150+130:150), 90, 90);
                        } completion:^(BOOL finished) {
                            [weakSelf performSelector:@selector(delayCode:) withObject:gift afterDelay:1.0f];
                        }];
                    }else if ([dict[@"userId"] integerValue] == [[MLRoomInformationModel currentAccount].uuid integerValue]){
                        CGRect giftFrame = [weakSelf.roomHostView hostFrameWithUserID:dict[@"userId"] idx:i];
                        [UIView transitionWithView:gift duration:2 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionTransitionFlipFromRight animations:^{
                            gift.frame = CGRectMake(giftFrame.origin.x+150, giftFrame.origin.y + 32+50, 90, 90);
                        } completion:^(BOOL finished) {
                            [weakSelf performSelector:@selector(delayCode:) withObject:gift afterDelay:1.0f];
                        }];
                    }else{
                        [gift removeFromSuperview];
                    }
                }
            }];
        }
        
        
        
        
        
        [model.userInfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;
            if ([dict[@"is_first"] integerValue] == 1) {
                return ;
            }
            MLRoomMessageModel *messageModelmodel = [[MLRoomMessageModel alloc] init];
            messageModelmodel.user_id = model.user_id;
            messageModelmodel.nickName = model.nickName;
            messageModelmodel.nick_color = [Common isNull:model.nick_color];
            messageModelmodel.messageType = model.messageType;
            messageModelmodel.giftNum = model.giftNum;
            messageModelmodel.show_img = model.show_img;
            messageModelmodel.toNickName = dict[@"nickname"];
            messageModelmodel.peerage_image = model.peerage_image;
            messageModelmodel.contribute_level=model.contribute_level;
            messageModelmodel.charm_level=model.charm_level;
            messageModelmodel.vip_num = model.vip_num;
            if (model.nickName.length>6) {
                messageModelmodel.nickName = [NSString stringWithFormat:@"%@...",[model.nickName substringToIndex:5]];
            }
            NSString *str = dict[@"nickname"];
            //            if ([dict[@"nickname"] length]>6) {
            //                messageModelmodel.toNickName = [NSString stringWithFormat:@"%@...",[str substringToIndex:6]];
            //            }
            CGSize cellW = [NSStringFormat(@"%@ 送给 %@",messageModelmodel.nickName, messageModelmodel.toNickName) sizeWithFont:Font(13) hiegth:16];
            CGSize giftNumW = [NSStringFormat(@"x%@", model.giftNum) sizeWithFont:Font(14) hiegth:26];
            messageModelmodel.cellWeight = cellW.width+giftNumW.width+45;
            messageModelmodel.messageWidth = cellW.width+5;
            if (cellW.width+giftNumW.width+45>ScreenWidth-80) {
                messageModelmodel.cellHeight = cellW.height;
                messageModelmodel.cellWeight = ScreenWidth-80;
            }
            messageModelmodel.toUser_id = dict[@"userId"];
            messageModelmodel.toNick_color = dict[@"nick_color"];
            [self.listArry addObject:messageModelmodel];
            [self.tableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.listArry.count - 1 inSection:0];
                [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            });
        }];
        
    }
    else if([model.messageType isEqualToString:@"5"]){
        //表情
        [self.roomHostView shouEmojiToIcon:model];
        
        if ([model.is_answer integerValue] > 0) {
            
            if (![model.peerage_image isEqualToString:@""]) {
                model.nickName = NSStringFormat(@"%@",model.nickName);
            }
            if (![model.contribute_level isEqualToString:@""]) {
                model.nickName = NSStringFormat(@"%@",model.nickName);
            }
            CGSize cellSizeH = [NSStringFormat(@"%@:%@",model.nickName, model.message) sizeWithFont:Font(14) With:ScreenViewWidth - 40-100];
            model.cellHeight = cellSizeH.height + 25;
            CGSize cellSizeW = [NSStringFormat(@"%@:%@",model.nickName, model.message) sizeWithFont:Font(15) hiegth:20];
            CGFloat cellW = cellSizeW.width;
            CGFloat cellSW = ScreenViewWidth - 40-100;
            if (cellW > cellSW) {
                model.cellWeight = cellSW;
            }else{
                model.cellWeight = cellW;
            }
            
            [self.listArry addObject:model];
            [self.tableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.listArry.count - 1 inSection:0];
                [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            });
        }
        
    }
    else if ([model.messageType isEqualToString:@"6"]){
        
        [self.listArry removeAllObjects];
        [self.tableView reloadData];
        
    }
    else if ([model.messageType isEqualToString:@"9"]){
        [self getQuit_roomWithParameters:3];
    }
    else if ([model.messageType isEqualToString:@"7"]){//暂时不用
        if (![[MLRoomInformationModel currentAccount].notice isEqualToString:model.room_intro]) {
            [MLRoomInformationModel currentAccount].notice = model.room_intro;
            [self room_introClick];
        }
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.room_background]];
        [MLRoomInformationModel currentAccount].name = model.room_name;
        [MLRoomInformationModel currentAccount].name = model.room_type;
        [self.roomTopView loadData];
    }
    else if ([model.messageType isEqualToString:@"15"]){
#pragma mark 接收观众上麦申请 刷新按钮小红点
        
        PostNoticeObserver(@"uploadSQSMListData", nil);
        [self getRoomInfoWithParameters:2 commplete:^{
            
        }];
    }else if ([model.messageType isEqualToString:@"100"]){
#pragma mark 主播进出房间的提示
        /** 主播退出和进入房间,房间频道中,发送消息,messageType为100,msgType,1为进入,2是离开.主播进入和离开调用上面这个接口.getRoomInfo接口返回的room_info中字段is_in_room,代表房主是否在房间的意思,1在,0否*/
        /** para*/
        NSMutableDictionary *paraRoomINfo =[NSMutableDictionary dictionaryWithDictionary:self.currentRoomInfo[@"room_info"]];
        paraRoomINfo[@"is_in_room"] = FORMAT(model.msgType);
        /** 重新设置*/
        self.currentRoomInfo[@"room_info"] = paraRoomINfo ;
        /** 重新设置*/
        self.roomHostView.currentRoomInfo = self.currentRoomInfo ;
    }
    else{
        //2，系统通知
        if ([model.messageType isEqualToString:@"2"]) {
            
            ///显示进场横幅
            if (![Common isEmptyString:model.enter_effects_image]) {
                ///如果为空，不显示入场横幅
                //                if (!model.is_cloaking) {
                ///无隐身状态
                dispatch_async(dispatch_get_main_queue(), ^{
                    CC_VioceTopHengFuView *topView = LoadFromNib(@"CC_VioceTopHengFuView");
                    topView.left = 10;
                    topView.top = self.roomHostView.bottom;
                    [topView.icon sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:defaultionPhotoIcon];
                    if (![Common isEmptyString:model.enter_effects_image]) {
                        [topView.txkIcon sd_setImageWithURL:[NSURL URLWithString:model.enter_effects_image] placeholderImage:defaultionPhotoIcon];
                    }
                    [topView.backIMg sd_setImageWithURL:[NSURL URLWithString:model.enter_effects_image] placeholderImage:defaultionPhotoIcon];
                    [weakSelf.view addSubview:topView];
                });
                //                }
            }
            
            
            
            
            if([model.message isEqualToString:@"2"]){
                model.message=getLanguage(@"进入房间");
            }
            //            [self vipSpecialEffectsViewClick:model];
            [self getRoomUsersWithParameters:2];//更新人数
            if([model.message isEqualToString:@"进入房间"]){
                //            if([model.message isEqualToString:@"2"]){
                if (![Common isEmptyString:model.rode_image]) {
                    if ([model.rode_image hasSuffix:@".svga"]||[model.rode_image hasSuffix:@".SVGA"]) {
                        [self.playSvgaArray addObject:model.rode_image];
                        if (self.playSvgaArray.count==1) {
                            [weakSelf PlaySVGA:model.rode_image];//进场特效
                        }
                    }
                    
                }
            }
            
        }
        if (![model.peerage_image isEqualToString:@""]) {
            model.nickName = NSStringFormat(@"%@",model.nickName);
        }
        if (![model.contribute_level isEqualToString:@""]) {
            model.nickName = NSStringFormat(@"%@",model.nickName);
        }
        if (![model.charm_level isEqualToString:@""]) {
            model.nickName = NSStringFormat(@"%@",model.nickName);
        }
        
        CGSize cellSizeH = [NSStringFormat(@"%@:%@",model.nickName, model.message) sizeWithFont:Font(14) With:ScreenViewWidth - KAdaptedWidth(130)];
        model.cellHeight = cellSizeH.height + 20;
        
        
        /** 消息为空的不显示*/
        if ([NSString NotNull:model.message]) {
            model.cellWeight = ScreenViewWidth - KAdaptedWidth(135);
            [self.listArry addObject:model];
            [self.tableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.listArry.count - 1 inSection:0];
                [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            });
        }
        
        
#pragma mark- 抽奖飘窗动画生成*************************
        if ([NSString NotNull:model.gift_name]) {
            /** 添加弹窗*/
            MLRoomMessageModel *messageModelmodel = [[MLRoomMessageModel alloc] init];
            messageModelmodel.user_id = @"1";
            messageModelmodel.nickName = model.nickName;
            messageModelmodel.nick_color = [Common isNull:model.nick_color];
            messageModelmodel.messageType = @"7770";
            messageModelmodel.giftNum = model.giftNum;
            messageModelmodel.show_img = model.show_img;
            messageModelmodel.toNickName = model.nickName;
            messageModelmodel.peerage_image = model.show_img;
            messageModelmodel.vip_num = model.vip_num;
            messageModelmodel.gift_name = model.gift_name;
            if (model.nickName.length>6) {
                messageModelmodel.nickName = [NSString stringWithFormat:@"%@...",[model.nickName substringToIndex:5]];
            }
            messageModelmodel.toUser_id = @"2";
            messageModelmodel.toNick_color = @"ffffff";
            [self addNewData:@[messageModelmodel]];
        }
        
    }
}

#pragma mark SVGA 播放

-(void)PlaySVGA:(NSString *)SVGAURLStr{
    __weak __typeof(self)weakSelf = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:kIsOpenRoomGiftAnimation] integerValue]==1) {
        [self.view addSubview:self.giftSelectedImage];
        [self.view bringSubviewToFront:self.giftSelectedImage];
        //
        [parser parseMemoryWithURL:[NSURL URLWithString:SVGAURLStr] Version:@"1.0" completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
            if (videoItem != nil) {
                weakSelf.giftSelectedImage.videoItem = videoItem;
                [weakSelf.giftSelectedImage startAnimation];
            }
        } failureBlock:^(NSError * _Nullable error) {
            if (error) {
                [weakSelf.giftSelectedImage removeFromSuperview];
            }
        }];
    }else{
        [self.playSvgaArray removeAllObjects];
        
    }
}


#pragma mark ---- 接受频道消息，全频道消息 <AgoraRtmChannelDelegate>
//接受频道消息，全频道消息
- (void)channel:(AgoraRtmChannel *_Nonnull)channel messageReceived:(AgoraRtmMessage *_Nonnull)message fromMember:(AgoraRtmMember *_Nonnull)member{
    [self appendInfoToTableViewWithInfo:message.text];
}

#pragma mark ---- 接受单点消息
//接受单点消息
- (void)rtmKit:(AgoraRtmKit *_Nonnull)kit messageReceived:(AgoraRtmMessage *_Nonnull)message fromPeer:(NSString *_Nonnull)peerId{
    if ([message.text isEqualToString:PeerMsg_MaiDown]) {
        [self.agoraKit setClientRole:AgoraClientRoleAudience];
        [self.agoraKit stopAudioMixing];
        [self.roomBarrageView xiamaiSetUI];
        self.firstKaiMai=1;
    }else if ([message.text isEqualToString:PeerMsg_MaiOff]){
        //点消息_被远端关闭麦
        [self.agoraKit enableLocalAudio:NO];
        [self.roomHostView setWaveLayerWithUid:[[UserManager userInfo].user_id integerValue] open:YES sequenceArray:self.sequenceArray];
    }else if ([message.text isEqualToString:PeerMsg_MaiOn]){
        //        暂时取消开麦操作
        //        [self.agoraKit enableLocalAudio:YES];
        //        [self.roomHostView setWaveLayerWithUid:[[UserManager userInfo].user_id integerValue] open:YES sequenceArray:self.sequenceArray];
    }else if ([message.text isEqualToString:PeerMsg_MaiUp]){
        [self.agoraKit setClientRole:AgoraClientRoleBroadcaster];
        [self.roomBarrageView shangxiamaiSetUI];
    }else if ([message.text isEqualToString:PeerMsg_ChatOff]){
        [MLRoomInformationModel currentAccount].isBanned = YES;
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"被禁言")];
        [self.roomBarrageView.keyboardButton setTitle:@"被禁言" forState:0];
        self.roomBarrageView.keyboardButton.userInteractionEnabled = NO;
    }else if ([message.text isEqualToString:PeerMsg_ChatOn]){
        [MLRoomInformationModel currentAccount].isBanned = NO;
        self.roomBarrageView.keyboardButton.userInteractionEnabled = YES;
        [self.roomBarrageView.keyboardButton setTitle:getLanguage(@"说点什么.....") forState:UIControlStateNormal];
    }else if ([message.text isEqualToString:PeerMsg_RoomKick]||[message.text isEqualToString:PeerMsg_BlackRoomKick]){
        //踢出房间
        [self.channel leaveWithCompletion:^(AgoraRtmLeaveChannelErrorCode errorCode) {
        }];
        [self.agoraKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        }];
        if([message.text isEqualToString:PeerMsg_RoomKick]){
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"被踢出房间")];
        }else{
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"你已被拉黑")];
        }
        self.isClose = NO;
        [self.floatingWindow removeFromSuperview];
        [MLRoomInformationManager clearUserInfo];
        [self backClick];
    }else if ([message.text isEqualToString:PeerMsg_AdminOn]){
        [MLRoomInformationModel currentAccount].user_type = @"2";
        [self.roomBarrageView setAdminBarrage];
        [self.roomTopView loadData];
        //        self.roomHostView.musicBtn.hidden=NO;
    }else if ([message.text isEqualToString:PeerMsg_AdminOff]){
        [MLRoomInformationModel currentAccount].user_type = @"0";
        [self.roomBarrageView setNoAdminBarrage];
        [self.roomTopView loadData];
        //        self.roomHostView.musicBtn.hidden=YES;
    }else if ([message.text isEqualToString:PeerMsg_TimeOn]){
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"主播开启倒计时")];
    }else if ([message.text isEqualToString:PeerMsg_TimeOff]){
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"主播开启倒计时")];
    }else if ([message.text isEqualToString:PeerMsg_TimeOver]){
        [self.agoraKit setClientRole:AgoraClientRoleAudience];
        [self.agoraKit stopAudioMixing];
        [self.roomBarrageView xiamaiSetUI];
        self.firstKaiMai=1;
    }
    
    
    
    
    
    
}
#pragma mark //离开频道
- (void)channel:(AgoraRtmChannel *_Nonnull)channel memberLeft:(AgoraRtmMember *_Nonnull)member{
    MYLog(@"Uid:%@ didOffline reason:%@", member.channelId, member.userId);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getMicrophone_statusWithParameters:2];
        [self getRoomUsersWithParameters:2];
        if ([member.channelId integerValue] == [member.userId integerValue]) {
            //厅主离开
            [MLRoomInformationModel currentAccount].is_afk = @"1";
            [self.roomHostView hostLeaveClick];
        }
    });
    
    
}
#pragma mark //加入频道
- (void)channel:(AgoraRtmChannel *_Nonnull)channel memberJoined:(AgoraRtmMember *_Nonnull)member{
    [self getRoomUsersWithParameters:2];
    if ([member.channelId integerValue] == [member.userId integerValue]) {
        //厅主回来了
        [MLRoomInformationModel currentAccount].is_afk = @"2";
        [self.roomHostView hostLeaveClick];
    }
}

#pragma mark- <AgoraRtcEngineDelegate>
//切换角色 回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString*)channel withUid:(NSUInteger)uid elapsed:(NSInteger) elapsed {
    NSLog(@"%ld",(long)elapsed);
}
- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine didClientRoleChanged:(AgoraClientRole)oldRole newRole:(AgoraClientRole)newRole{
    MYLog(@">>>>>>>>>>>>>>>>>>>>%ld,>>>>>>>>>>>>>>>>>>>>>%ld",oldRole, newRole);
}
// 有人加入频道  回调
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    [self getRoomUsersWithParameters:2];
}
//有用户离开频道
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    //    [self getMicrophone_statusWithParameters:2];
    //        if (([[MLRoomInformationModel currentAccount].uuid integerValue] == uid)&&(reason==AgoraUserOfflineReasonQuit)) {
    //            //厅主离开
    //            [self getQuit_roomWithParameters:3];
    //        }else{
    [self getRoomUsersWithParameters:2];
    //        }
    
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didAudioRouteChanged:(AgoraAudioOutputRouting)routing {
    switch (routing) {
        case AgoraAudioOutputRoutingDefault:
            MYLog(@"AgoraRtc_AudioOutputRouting_Default");
            break;
        case AgoraAudioOutputRoutingHeadset:
            MYLog(@"AgoraRtc_AudioOutputRouting_Headset");
            break;
        case AgoraAudioOutputRoutingEarpiece:
            MYLog(@"AgoraRtc_AudioOutputRouting_Earpiece");
            break;
        case AgoraAudioOutputRoutingHeadsetNoMic:
            MYLog(@"AgoraRtc_AudioOutputRouting_HeadsetNoMic");
            break;
        case AgoraAudioOutputRoutingSpeakerphone:
            MYLog(@"AgoraRtc_AudioOutputRouting_Speakerphone");
            break;
        case AgoraAudioOutputRoutingLoudspeaker:
            MYLog(@"AgoraRtc_AudioOutputRouting_Loudspeaker");
            break;
        case AgoraAudioOutputRoutingHeadsetBluetooth:
            MYLog(@"AgoraRtc_AudioOutputRouting_HeadsetBluetooth");
            break;
        default:
            break;
    }
}
//声音回调
- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine reportAudioVolumeIndicationOfSpeakers:(NSArray<AgoraRtcAudioVolumeInfo*> *_Nonnull)speakers totalVolume:(NSInteger)totalVolume{
    if (self.sequenceArray.count == 0) {
        return;
    }
    __weak __typeof(self)weakSelf = self;
    [speakers enumerateObjectsUsingBlock:^(AgoraRtcAudioVolumeInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.uid == 0) {
            [weakSelf.roomHostView setWaveLayerWithUid:[[UserManager userInfo].user_id integerValue] volume:obj.volume sequenceArray:weakSelf.sequenceArray];
        }else{
            [weakSelf.roomHostView setWaveLayerWithUid:obj.uid volume:obj.volume sequenceArray:weakSelf.sequenceArray];
        }
    }];
}
//音乐播放结束回调
- (void)rtcEngineLocalAudioMixingDidFinish:(AgoraRtcEngineKit *_Nonnull)engine{
    [self cancelTime];
    //    [self getNext_musicWithParameters:@"next"];
}


#pragma mark 修改频道属性
-(void)channel:(AgoraRtmChannel *)channel attributeUpdate:(NSArray<AgoraRtmChannelAttribute *> *)attributes{
    
    NSLog(@"%@",attributes);
    //    [SVProgressHUD showImage:KGetImage(@"") status:[NSString stringWithFormat:@"已修改频道属性:%@",attributes]];
    
    NSString *changeType=[NSString stringWithFormat:@"%@",attributes[0].value];
    for (AgoraRtmChannelAttribute *attribute in attributes) {
        
        if ([attribute.key isEqualToString:Attribute_Update]&&[changeType isEqualToString:Attribute_Update]) {
            //更新房间数据
            [self getRoomInfoData];
            break;
        }
        
        if ([attribute.key isEqualToString:Attribute_Lock]&&[changeType isEqualToString:Attribute_Lock]) {
            [self getMicrophone_statusWithParameters:2];//刷新麦位
            break;
        }
        if ([attribute.key isEqualToString:Attribute_Own]&&[changeType isEqualToString:Attribute_Own]) {
            
        }
        if ([attribute.key isEqualToString:Attribute_BgImg]&&[changeType isEqualToString:Attribute_BgImg]) {
            NSDictionary *dic=[Common dictionaryWithJsonString:attribute.value];
            [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
            break;
        }
        if ([attribute.key isEqualToString:Attribute_Publish]&&[changeType isEqualToString:Attribute_Publish]) {
            [MLRoomInformationModel currentAccount].notice = attribute.value;
            [self.roomAnnouncementView upData];
            break;
        }
        if ([attribute.key isEqualToString:Attribute_CoverImg]&&[changeType isEqualToString:Attribute_CoverImg]) {
            [MLRoomInformationModel currentAccount].room_bg_image = attribute.value;
            [self.roomTopView loadData];
            break;
        }
        if ([attribute.key isEqualToString:Attribute_Name]&&[changeType isEqualToString:Attribute_Name]) {
            [MLRoomInformationModel currentAccount].name = attribute.value;
            [self.roomTopView loadData];
            break;
        }
    }
    
}


-(void)defaultAttbutesKey:(NSString *)key andValue:(NSString *)value{
    AgoraRtmChannelAttribute *defaultAttribute=[AgoraRtmChannelAttribute new];
    defaultAttribute.key=key;
    defaultAttribute.value=value;
    [self.agoraRtmKit addOrUpdateChannel:[MLRoomInformationModel currentAccount].room_id Attributes:@[defaultAttribute] Options:self.channelAttributeOption completion:^(AgoraRtmProcessAttributeErrorCode errorCode) {
        NSLog(@"BBBB===%ld",(long)errorCode);
        
    }];
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArry.count;
}

//TODO  1：正常的 聊天消息  2：进入房间  3： 刷新麦序列表
// 4 ：礼物消息  5 ：表情消息 6：清空消息 7房间设置,666全服播报，13，本房间开箱子 6666：砸金蛋全服解析
//401:清空魅力值 15:接收观众上麦申请 其他：系统通知
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    MLRoomMessageModel *model  = self.listArry[indexPath.row];
    
    if ([model.messageType integerValue] == 4) {
        RoomGiftMessageCell *cell = [RoomGiftMessageCell cellWithTableView:tableView];
        cell.model = model;
        cell.nickNameClickBlock = ^(UIView *containerView, NSString *text, NSRange range, CGRect rect, MLRoomMessageModel *model) {
            if ([text isEqualToString:@"1"]) {
                [weakSelf get_other_userWithParameters:model.user_id isZaimaishang:@"2"];
            }else{
                [weakSelf get_other_userWithParameters:model.toUser_id isZaimaishang:@"2"];
            }
        };
        return cell;
    }
    RoomBarrageMessageCell *cell = [RoomBarrageMessageCell cellWithTableView:tableView];
    if (indexPath.row == 0) {
        if ([model.user_id isEqualToString:@"0"]) {
            [cell setSystemInforms:self.listArry[0]];
        }else{
            [cell setModel:self.listArry[indexPath.row]];
        }
    }
    else{
        if ([model.user_id isEqualToString:@"1"]){
            [cell setSystemInforms:self.listArry[indexPath.row]];
        }else{
            [cell setModel:self.listArry[indexPath.row]];
        }
        
    }
    cell.nickNameClickBlock = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect, MLRoomMessageModel *model) {
        [weakSelf get_other_userWithParameters:model.user_id isZaimaishang:@"2"];
    };
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLRoomMessageModel *model = self.listArry[indexPath.row];
    if ([model.messageType integerValue] == 4) {
        return 55;
    }
    return model.cellHeight +10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (void)room_introClick{
    NSDictionary *dict1 = @{@"nickName":@"房间公告",
                            @"user_id":@"1",
                            @"vip_img":@"",
                            @"hz_img":@"",
                            @"message":NSStringFormat(@"%@",[Common isNull:[MLRoomInformationModel currentAccount].notice]),
                            @"messageType":@"2"};
    //更新于2020-03-18，暂时隐藏欢迎进入房间的提示
    [self appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict1]];
}


#pragma mark  BarrageDataSource代理方法  飘屏

- (CGSize)renderView:(LLBarrageRenderView *)renderView sizeAtIndex:(NSInteger)index{
    
    MLRoomMessageModel *model=self.renderDataList[index];
    
    CGFloat contentWidth=0;
    if ([model.messageType integerValue]==7770||[model.messageType integerValue]==7771) {
        
        NSString *text=[NSString stringWithFormat:@" %@ 抽中 %@*%@",model.nickName,model.gift_name,model.giftNum];
        contentWidth = [text widthForFont:KFont(12)];
    }else{
        
        NSString *text1=[NSString stringWithFormat:@"%@%@%@%@",model.nickName,[model.messageType integerValue]==7772?getLanguage(@"在塔罗牌中抽中"):getLanguage(@"在大胃王中获得"),model.coin,getLanguage(@"金币")];
        contentWidth = [text1 widthForFont:KFont(12)];
    }
    
    return CGSizeMake( contentWidth+130.0 , 60.0);
}
- (LLBarrageCell *)renderView:(LLBarrageRenderView *)renderView cellAtIndex:(NSInteger)index{
    
    CustomBarrageCell *barrage = [renderView dequeueReusableCellWithIdentifier:@"cell"];
    MLRoomMessageModel *model=self.renderDataList[index];
    if ([model.messageType integerValue]==7770||[model.messageType integerValue]==7771) {
        barrage.Model = model;
    }else{
        barrage.dicData = @{@"coin":model.coin,@"nickName":model.nickName,@"messageType":model.messageType};
    }
    
    return barrage;
    
    
}





#pragma mark getDataHttp

#pragma mark 拒绝or接受
- (void)getHandle_cpWithParameters:(NSInteger)type roomMessageModel:(MLRoomMessageModel *)model{
    NSDictionary *dict = @{@"user_id":model.user_id,
                           @"type":@(type)
    };
    __weak __typeof(self)weakSelf = self;
    [HttpTool getHandle_cpWithParameters:dict success:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            if (type == 1) {//同意
                NSDictionary *dict1 = @{@"nickName":[UserManager userInfo].nickname,
                                        @"user_id":[UserManager userInfo].user_id,
                                        @"headimgurl":[UserManager userInfo].avatar,
                                        //                                        @"nick_color":weakSelf.dictInfo[@"nick_color"],
                                        @"toUser_id":model.user_id,
                                        @"toNickName":model.nickName,
                                        @"toheadimgurl":model.headimgurl,
                                        @"toNick_color":model.nick_color,
                                        @"messageType":@"11"};
                AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict1]];
                [weakSelf appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict1]];
                [weakSelf.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
                    
                }];
            }
            NSDictionary *dict2 = @{@"nickName":[UserManager userInfo].nickname,
                                    @"cpType":NSStringFormat(@"%ld",type),
                                    @"messageType":@"1"};
            AgoraRtmMessage *message2 = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict2]];
            [weakSelf.agoraRtmKit sendMessage:message2 toPeer:model.user_id completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 获取房间成员列表
- (void)get_room_usersWithParameters:(NSString *)maiXu userID:(NSString *)userID{
    
    WeakSelf;
    NSDictionary *dict = @{@"room_id":[MLRoomInformationModel currentAccount].room_id,@"status":@"0"};
    [NetworkRequest POST:Request_GetRoomUser parmeters:dict success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        [wself.bgView addSubview:wself.fluctuationOfWheatView];
        wself.fluctuationOfWheatView.room_user = [MLRoomAdminModel mj_objectArrayWithKeyValuesArray:basemodel.data];
        
        wself.fluctuationOfWheatView.quDingButtonClickBlock = ^(MLRoomAdminModel *model) {
            if ([model.is_mic isEqualToString:@"1"]) {
                
                [wself getGo_microphoneWithUserID:[Common isNull:model.microphoneID] andType:YES andMsgData:@""];
            }else{
                [wself getUp_microphoneWithParameters:maiXu user_id:model.microphoneID andData:model.mj_keyValues];
            }
        };
        //        wself.fluctuationOfWheatView.searchButtonClickBlock = ^(NSString *userid) {
        //            [wself get_room_usersWithParameters:maiXu userID:userid];
        //        };
    } failture:^(NSError *error) {
        
    }];
    
    
    
}
//#pragma mark 获取用户vip,徽章微张 图片
//- (void)get_user_vipWithParameters:(NSString *)isZaiFang{
////    [SVProgressHUD showImage:KGetImage(@"") status:@"获取用户vip,徽章微张 图片,谁谁谁进入直播间"];
//
//    NSDictionary *dict = @{@"user_id":[UserManager userInfo].user_id,
//                           @"uid":[MLRoomInformationModel currentAccount].room_id
//    };
//    __weak __typeof(self)weakSelf = self;
////    [HttpTool get_user_vipWithParameters:dict success:^(id response) {
////        if ([response[@"code"] integerValue] == 1) {
////            weakSelf.dictInfo = response[@"data"];
////            [self.roomHostView.headIconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",weakSelf.dictInfo[@"zb_img"]]]];
//////            weakSelf.roomHostView.headIconImg.imageName = [Common isNull:weakSelf.dictInfo[@"zb_img"]];
////            if ([isZaiFang isEqualToString:@"0"]) {
////                NSDictionary *dict1 = @{@"nickName":@"系统通知",
////                                        @"user_id":@"0",
////                                        @"vip_img":@"",
////                                        @"hz_img":@"",
////                                        @"message":NSStringFormat(@"%@",[MLRoomInformationModel currentAccount].notice),
////                                        @"messageType":@"2"};
////                [weakSelf appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict1]];
////                [weakSelf room_introClick];
////                NSArray *arry = weakSelf.dictInfo[@"cp_users"];
////                if (arry.count > 0) {
////                    [arry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////                        NSDictionary *userInfo = obj;
////
////                        NSDictionary *dict2 = @{@"nickName":[UserManager userInfo].nickname,
////                                                @"user_id":[UserManager userInfo].user_id,
////                                                @"headimgurl":[UserManager userInfo].avatar,
////                                                @"nick_color":[Common isNull:weakSelf.dictInfo[@"nick_color"]],
////                                                @"toNickName":userInfo[@"nickname"],
////                                                @"toUser_id":userInfo[@"id"],
////                                                @"toNick_color":userInfo[@"nick_color"],
////                                                @"toheadimgurl":userInfo[@"headimgurl"],
////                                                @"vip_tx":[Common isNull:weakSelf.dictInfo[@"vip_tx"]],
////                                                @"vip_img":[Common isNull:weakSelf.dictInfo[@"vip_img"]],
////                                                @"vip_num":[Common isNull:weakSelf.dictInfo[@"vip_level"]],
////                                                @"hz_img":[Common isNull:weakSelf.dictInfo[@"hz_img"]],
////                                                @"cp_tx":userInfo[@"cp_tx"],
////                                                @"messageType":@"8"};
////                        AgoraRtmMessage *message1 = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict2]];
////                        [weakSelf.channel sendMessage:message1 completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
////                            NSDictionary *dict3 = @{@"nickName":[UserManager userInfo].nickname,
////                                                    @"user_id":[UserManager userInfo].user_id,
////                                                    @"headimgurl":[UserManager userInfo].avatar,
////                                                    @"nick_color":[Common isNull:weakSelf.dictInfo[@"nick_color"]],
////                                                    @"toNick_color":userInfo[@"nick_color"],
////                                                    @"toNickName":userInfo[@"nickname"],
////                                                    @"toheadimgurl":userInfo[@"headimgurl"],
////                                                    @"toUser_id":userInfo[@"id"],
////                                                    @"cp_tx":userInfo[@"cp_tx"],
////                                                    @"vip_tx":[Common isNull:weakSelf.dictInfo[@"vip_tx"]],
////                                                    @"messageType":@"9"};
////                            [weakSelf appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict3]];
////                        }];
////                        [weakSelf.agoraRtmKit sendMessage:message1 toPeer:userInfo[@"id"] completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
////                        }];
////
////                    }];
////
////                    return ;
////                }
////
////                NSDictionary *dict4 = @{@"nickName":[UserManager userInfo].nickname,
////                                        @"user_id":[UserManager userInfo].user_id,
////                                        @"nick_color":[Common isNull:weakSelf.dictInfo[@"nick_color"]],
//////                                        @"message":@"进入直播间",
////                                        @"message":@"2",
////                                        @"vip_tx":[Common isNull:weakSelf.dictInfo[@"vip_tx"]],
////                                        @"vip_img":[Common isNull:weakSelf.dictInfo[@"vip_img"]],
////                                        @"vip_num":[Common isNull:weakSelf.dictInfo[@"vip_level"]],
////                                        @"hz_img":[Common isNull:weakSelf.dictInfo[@"hz_img"]],
////                                        @"messageType":@"2"};
////                AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict4]];
////                [weakSelf.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
////
////                    [weakSelf appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict4]];
////                }];
////            }
////        }
////    } failure:^(NSError *error) {
////
////    }];
//
//
//
//
//
//
//}

#pragma mark 发送礼物
//发送礼物
- (void)getGift_queueWithParameters:(NSArray *)userSelectedArray giftModel:(RoomGiftModel *)giftModel giftNum:(NSString *)giftNum currentType:(NSString *)currentType{
    __weak __typeof(self)weakSelf = self;
    if ([currentType isEqualToString:@"2"]) {
        ///背包
        currentType = @"1";
    }else{
        currentType = @"0";
    }
    
    NSString *gid = [giftModel realGiftId];
    if (gid.length == 0) {
        gid = giftModel.giftID ? [NSString stringWithFormat:@"%@", giftModel.giftID] : @"";
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"room_id":[MLRoomInformationModel currentAccount].room_id,
                                                                                @"gift_id":gid,
                                                                                @"num":giftNum,
                                                                                @"to_uids":@"",
                                                                                @"type":currentType}];
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *userInfo = [NSMutableArray array];
    [userSelectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MLRoomMSequenceModel *msModel = (MLRoomMSequenceModel *)obj;
        if ([NSString NotNull:msModel.uid]) {
            [arr addObject:msModel.uid];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:msModel.uid forKey:@"userId"];
            [dic setValue:msModel.nickname forKey:@"nickname"];
            [userInfo addObject:dic];
        }
    }];
    [dict setValue:[arr componentsJoinedByString:@","] forKey:@"to_uids"];
    
    [NetworkRequest POST:gift_sendGift parmeters:dict success:^(id responObject) {
        [weakSelf getMicrophone_statusWithParameters:3];
        [weakSelf getRoomInfoWithParameters:2 commplete:^{
            
        }];
        if ([currentType isEqualToString:@"1"]) {
            [weakSelf fetchKnapsackList];
        }
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithDictionary:@{@"nickName":[UserManager userInfo].nickname,
                                                                                     @"user_id":[UserManager userInfo].user_id,
                                                                                     @"message":@"",
                                                                                     @"show_img":giftModel.image,
                                                                                     @"show_gif_img":[Common isNull:giftModel.svga_file],
                                                                                     @"type":[Common isNull:giftModel.type],
                                                                                     @"giftNum":giftNum,
                                                                                     @"gift_name":giftModel.name,
                                                                                     @"e_name":[Common isNull:giftModel.e_name],
                                                                                     @"userInfo":userInfo,
                                                                                     @"messageType":@"4",
                                                                                     @"giftOrFuDai":@"1",
                                                                                     @"peerage_image":[Common isNull:[UserManager userInfo].peerage_icon],
                                                                                     @"contribute_level":[Common isNull:[UserManager userInfo].contribute_level],
                                                                                     @"charm_level":[Common isNull:[UserManager userInfo].charm_level],
                                                                                   }];
        AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict1]];
        [weakSelf appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict1]];
        [weakSelf.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
            //                weakSelf.first = 2;
        }];
        if ([giftModel.is_broadcast integerValue]==1) {
            [dict1 setObject:@"7770" forKey:@"messageType"];
            AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict1]];
            [weakSelf appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict1]];
            [weakSelf.allChannel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
                
            }];
        }
    } failture:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

//#pragma mark 发送福袋
//发送福袋
//- (void)getGiftFuDai_queueWithParameters:(NSArray *)userSelectedArray giftModel:(RoomFuDaiModel *)giftModel giftNum:(NSString *)giftNum currentType:(NSString *)currentType{
//    __weak __typeof(self)weakSelf = self;
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"id":giftModel.fuDaiID,
//                        @"user_id":[UserManager userInfo].user_id,
//                        @"uid":[MLRoomInformationModel currentAccount].room_id,
//                        @"num":giftNum,
//                        @"fromUid":@"",
//                        @"type":@""     }];
//    NSMutableArray *arrA = [NSMutableArray array];
//    NSMutableArray *userArr = [NSMutableArray array];
//    NSMutableArray *userInfo = [NSMutableArray array];
//    [userSelectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        MLRoomMSequenceModel *msModel = (MLRoomMSequenceModel *)obj;
//        [arrA addObject:msModel.uid];
//        [userArr addObject:msModel.uid];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setValue:msModel.uid forKey:@"userId"];
//        [dic setValue:msModel.nickname forKey:@"nickname"];
//        [dic setValue:msModel.avatar forKey:@"headimgurl"];
//        [userInfo addObject:dic];
//    }];
//    [dict setValue:[arrA componentsJoinedByString:@","] forKey:@"fromUid"];
//
//
//    [HttpTool getRequstBuyFuDaiWithParameters:dict success:^(id response) {
//        MYLog(@"%@",response);
//        if ([response[@"code"] integerValue] == 1) {
//            [weakSelf getMicrophone_statusWithParameters:3];
//            [weakSelf getRoomInfoWithParameters:2];
//            NSArray *arr=response[@"data"];
//            for (NSDictionary *dic in arr) {
//
//                NSMutableArray *userInfoArr = [NSMutableArray array];
//                for (NSDictionary *dicData in userSelectedArray) {
//                    MLRoomMSequenceModel *msModel = (MLRoomMSequenceModel *)dicData;
//                    if ([dic[@"user_id"] integerValue]==[msModel.uid integerValue]) {
//                        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
//                        [dic1 setValue:msModel.uid forKey:@"userId"];
//                        [dic1 setValue:msModel.nickname forKey:@"nickname"];
//                        [dic1 setValue:msModel.avatar forKey:@"headimgurl"];
//                        [userInfoArr addObject:dic1];
//                        break;
//                    }
//                }
//                NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithDictionary:@{@"nickName":[UserManager userInfo].nickname,
//                     @"user_id":[UserManager userInfo].user_id,
////                     @"nick_color":[Common isNull:weakSelf.dictInfo[@"nick_color"]],
////                     @"vip_img":[Common isNull:weakSelf.dictInfo[@"vip_img"]],
////                     @"vip_num":[Common isNull:weakSelf.dictInfo[@"vip_level"]],
//                     @"message":@"",
//                     @"show_img":dic[@"oneimage"],
//                     @"show_gif_img":dic[@"twoimage"],
//                     @"type":dic[@"type"],
//                     @"e_name":dic[@"name"],
//                     @"giftNum":giftNum,
//                     @"gift_name":dic[@"name"],
//                     @"userInfo":userInfoArr,
//                     @"messageType":@"4",
//                     @"giftOrFuDai":@"2",
//                     @"FuDaiuserList":userArr,
//                    }];
//
//                AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict1]];
//                [weakSelf appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict1]];
//                [weakSelf.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
////                    weakSelf.first = 2;
//                }];
//
//                if ([dic[@"is_play"]integerValue]==1) {
//                    [dict1 setObject:@"7771" forKey:@"messageType"];
//                    AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict1]];
//                    [weakSelf appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict1]];
//                    [weakSelf.allChannel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
//
//                    }];
//                }
//
//            }
//
//
//        }else{
//            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:response[@"message"]];
//        }
//
//    } failure:^(NSError *error) {
//        MYLog(@"%@",error);
//
//    }];
//
//}




#pragma mark 重新获取房间信息
- (void)getRoomInfoWithParameters:(NSInteger)type  commplete:(void (^)(void))commplete{
    WeakSelf;
    [NetworkRequest POST:Request_GetRoomInfo parmeters:@{@"room_id":[MLRoomInformationModel currentAccount].room_id} success:^(id responObject) {
        BaseModel *basemolde=(BaseModel *)responObject;
        MLRoomInformationModel *mode=[MLRoomInformationModel mj_objectWithKeyValues:basemolde.data[@"room_info"]];
        mode.userinfo=basemolde.data[@"userinfo"];
        mode.is_muted=[basemolde.data[@"userinfo"][@"is_muted"] boolValue];
        mode.user_type=[Common isNull:basemolde.data[@"userinfo"][@"type"]];
        MLRoomInformationModel *model1 = [MLRoomInformationModel currentAccount];
        [model1 mj_setKeyValues:mode];
        [MLRoomInformationManager saveUserInfo:[MLRoomInformationModel currentAccount]];
        
        if([[MLRoomInformationModel currentAccount].is_me integerValue]==1){
            [wself.roomBarrageView.shangmaiNumBtn setTitle:[NSString stringWithFormat:@"排队%@人",mode.apply_nums] forState:UIControlStateNormal];
        }
        if(type==2){
            [wself.roomTopView.hotBtn setTitle:[NSString stringWithFormat:@"%@",[MLRoomInformationModel currentAccount].heat] forState:UIControlStateNormal];
        }
        
        /** id设置*/
        wself.roomTopView.uidSet = FORMAT(basemolde.data[@"room_info"][@"uid"]);
        
        /** 记录房间信息*/
        wself.currentRoomInfo = [NSMutableDictionary dictionaryWithDictionary:basemolde.data] ;
        
        /** 判断，只有房主才显示添加音乐按钮*/
        NSString *is_me = basemolde.data[@"room_info"][@"is_me"];
        wself.musicBtn.hidden = !is_me.boolValue;
        
        if(is_me.intValue==1){
            wself.roomMoreView.isMe = YES ;
            
            [ObjectTool performSelectorAfterDelay:0.5 completion:^{
                /** 主播进去 或者 离开房间
                 1 进入房间 2 退出房间
                 */
                [wself anchorLeaveOrJoinRoom:1 success:^{
                }];
            }];
        }else{
            wself.roomMoreView.isMe = NO ;
        }
        
        if (commplete) {
            commplete();
        }
        
    } failture:^(NSError *error) {
        [wself.navigationController popViewControllerAnimated:YES];
        
        if (commplete) {
            commplete();
        }
    }];
    //重新获取用户信息
    [self getUserInfoMessage];
}

#pragma mark 获取礼物列表
- (void)getGift_listWithParameters:(MLRoomUserModel *)mdoel{
    
    /** 原来的接口   2026-01-17替换 为 gift_giftList
     Request_GetGiftList
     */
    
    WeakSelf;
    [NetworkRequest POST:gift_giftList parmeters:nil success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        NSMutableArray *arry = [RoomGiftModel mj_objectArrayWithKeyValuesArray:basemodel.data[@"data"]];
        [wself.view addSubview:wself.newRoomGiftView];
        wself.newRoomGiftView.giftArray =arry;
        NSMutableArray *userArr=[NSMutableArray array];
        NSInteger i=0;
        for (MLRoomMSequenceModel *mode in wself.sequenceArray) {
            if([mode.uid integerValue]!=[[MLRoomInformationModel currentAccount].uuid integerValue]){
                if ([mode.status integerValue]==2) {
                    mode.num=i;
                    [userArr addObject:mode];
                }
                i++;
            }
            
        }
        //送礼物
        [wself.newRoomGiftView setGiftCarouse:arry userCarousel:userArr userMiZuan:[UserManager userInfo].diamond allUsers:userArr andUserNum:userArr.count];
        
    } failture:^(NSError *error) {
        
    }];
    
    //获取背包礼物
    [self fetchKnapsackList];
    
    
    [NetworkRequest POST:Request_GetBoxList parmeters:nil success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        wself.newRoomGiftView.fudaiArray=[RoomFuDaiModel mj_objectArrayWithKeyValuesArray:basemodel.data];
        
    } failture:^(NSError *error) {
        
    }];
    
    //    NSDictionary *dict = @{@"user_id":[UserManager userInfo].user_id};
    //    [HttpTool getGift_listWithParameters:dict success:^(id response) {
    //        if ([response[@"code"] integerValue] == 1) {
    //            NSMutableArray *arry = [RoomGiftModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"gifts"]];
    //            [wself.view addSubview:wself.newRoomGiftView];
    //            wself.newRoomGiftView.giftArray = [RoomGiftModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"gifts"]];
    //            wself.newRoomGiftView.gemArray = [RoomGiftModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"baoshi"]];
    //            wself.newRoomGiftView.myArray = [RoomGiftModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"my_wares"]];
    //
    //            NSMutableArray *userArr=[NSMutableArray array];
    //            NSInteger i=0;
    //            for (MLRoomMSequenceModel *mode in wself.sequenceArray) {
    //                if ([mode.status integerValue]==2) {
    //                    mode.weizhi=i+1;
    //                    [userArr addObject:mode];
    //                }
    //                i++;
    //            }
    ////            if (mdoel) {
    ////                //送给指定人的礼物，点击麦位送礼
    ////                [weakSelf.newRoomGiftView setGiftCarouse:arry userCarousel:[NSMutableArray arrayWithArray:@[mdoel]] userMiZuan:response[@"data"][@"mizuan"] allUsers:userArr andUserNum:userArr.count+1];
    ////            }else{
    //                //送礼物
    //                [wself.newRoomGiftView setGiftCarouse:arry userCarousel:userArr userMiZuan:response[@"data"][@"mizuan"] allUsers:userArr andUserNum:userArr.count+1];
    //
    ////            }
    //
    //
    //        }
    //    } failure:^(NSError *error) {
    //
    //    }];
    
    
    //    [HttpTool getRequstFuDaiListWithParameters:nil success:^(id response) {
    //        if ([response[@"code"] integerValue] == 1) {
    ////            self.roomGiftView.fudaiArray=[RoomFuDaiModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
    //            self.newRoomGiftView.fudaiArray=[RoomFuDaiModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
    //
    //        }
    //    } failure:^(NSError *error) {
    //
    //    }];
    
    
    
    
}

- (void)fetchKnapsackList {
    WeakSelf;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@(0),@"page":@(1),@"size":@(100),@"status":@"0"}];
    [NetworkRequest POST:Request_GetMyKnapsack parmeters:dic success:^(id responObject) {
        BaseModel *basemodel = (BaseModel *)responObject;
        NSMutableArray *arry = [RoomGiftModel mj_objectArrayWithKeyValuesArray:basemodel.data];
        NSString *currentUid = [UserManager userInfo].user_id;
        NSMutableArray<RoomGiftModel *> *mergedArray = [RoomGiftModel mergeBackpackGiftList:arry userId:currentUid];
        wself.newRoomGiftView.myArray = mergedArray;
        if (wself.newRoomGiftView.currentType == 2) {
            [wself.newRoomGiftView uploadType:1001];
        }
    } failture:^(NSError *error) {
    }];
}

#pragma mark -- 新加的房间人数
- (void)getRoomUsersWithParameters:(NSInteger)type{
    
    WeakSelf;
    [NetworkRequest POST:Request_GetRoomUser parmeters:@{@"room_id":[MLRoomInformationModel currentAccount].room_id,@"page":@"1",@"size":@(150),@"status":@"0"} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        NSLog(@"%@",basemodel.data);
        self.roomHostView.onlineUserArray=basemodel.data;
        self.roomUserArray=[MLRoomAdminModel mj_objectArrayWithKeyValuesArray:basemodel.data];
        if(type==1){
            NSDictionary *dict1 = @{@"nickName":@"系统通知",
                                    @"user_id":@"0",
                                    @"vip_img":@"",
                                    @"hz_img":@"",
                                    @"message":NSStringFormat(@"%@",[MLRoomInformationModel currentAccount].notice),
                                    @"messageType":@"2"};
            [wself appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict1]];
            //                [wself room_introClick];
            
            NSDictionary *dict4 = @{@"nickName":[UserManager userInfo].nickname,
                                    @"user_id":[UserManager userInfo].user_id,
                                    @"avatar":[UserManager userInfo].avatar,
                                    @"message":@"进入房间",
                                    //                                        @"message":@"2",
                                    @"enter_effects_image":[Common isNull:[UserManager userInfo].enter_effects_image],
                                    @"vip_img":[Common isNull:[UserManager userInfo].avatar_frame_image],
                                    @"vip_num":@"",
                                    @"hz_img":@"",
                                    @"peerage_image":[Common isNull:[UserManager userInfo].peerage_icon],
                                    @"contribute_level":[Common isNull:[UserManager userInfo].contribute_level],
                                    @"charm_level":[Common isNull:[UserManager userInfo].charm_level],
                                    @"rode_image":[Common isNull:[UserManager userInfo].rode_svga_file],
                                    @"messageType":@"2"};
            AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict4]];
            [wself.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
                [wself appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict4]];
            }];
            
        }
        
    } failture:^(NSError *error) {
        
    }];
}

#pragma mark 添加飘屏数据
- (void)addNewData:(NSArray *)dataArr{
    
    [self.renderDataList addObjectsFromArray:dataArr];
    [self.renderView addBarragesNum:dataArr.count];
    
}

#pragma mark ======================  清空魅力值   ======================
- (void)cleanMeiliMethodWithUserId:(NSString *)user_id {
    WeakSelf;
    
    NSDictionary *dic=[NSDictionary dictionary];
    if (user_id.length>0) {
        dic=@{@"room_id":[MLRoomInformationModel currentAccount].room_id,@"room_user_id":user_id};
    }else{
        dic=@{@"room_id":[MLRoomInformationModel currentAccount].room_id};
    }
    
    [NetworkRequest POST:Request_EmptyCharm parmeters:dic success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:basemodel.msg]];
        NSLog(@"%@",basemodel.data);
        NSDictionary *dict = @{@"nickName":@"",
                               @"user_id":@"",
                               @"message":@"",
                               @"messageType":@"3"};
        //             @"messageType":@"401"
        [wself appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict]];
        AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict]];
        [wself.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
            
        }];
        
    } failture:^(NSError *error) {
        
    }];
    
    
}
#pragma mark 取消排麦
- (void)getDelWaitWithParameters{
    //    NSDictionary *dict = @{@"user_id":[UserManager userInfo].user_id
    //    };
    
    //    [NetworkRequest POST:Request_delMicrophoneApply parmeters:@{@"room_id":[MLRoomInformationModel currentAccount].room_id,@"room_microphone_apply_id":@""} success:^(id responObject) {
    //        BaseModel *basemodel=(BaseModel *)responObject;
    //        NSLog(@"%@",basemodel.data);
    //
    //
    //    } failture:^(NSError *error) {
    //
    //    }];
    
}



#pragma mark 上一首、下一首
//- (void)getNext_musicWithParameters:(NSString *)next{
//    if ([self.musicModel.is_music integerValue] != 1) {
//        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:getLanguage(@"暂无可播放歌曲请去添加")];
//        return;
//    }
//
//    __weak __typeof(self)weakSelf = self;
//    NSDictionary *dict = @{@"id":self.musicModel.musicID,
//                           @"type":next,
//                           @"class":self.musicCycle,
//                           @"user_id":[UserManager userInfo].user_id };
//    [HttpTool getNext_musicWithParameters:dict success:^(id response) {
//        if ([response[@"code"] integerValue] == 1) {
//            if ([response[@"data"][@"is_music"] integerValue] == 1) {
//                weakSelf.musicModel = [RoomMusicModel mj_objectWithKeyValues:response[@"data"]];
//                weakSelf.roomMusicView.model = weakSelf.musicModel;
//                [weakSelf.agoraKit startAudioMixing:self.musicModel.music_url loopback:NO replace:NO cycle:1 startPos:0];
//                [weakSelf startTime];
//                weakSelf.isPlay = YES;
//                weakSelf.musicModel.isPlay = @"1";
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"Next_music" object:weakSelf.musicModel];
//            }else{
//                [weakSelf cancelTime];
//                [weakSelf.roomMusicView setSliderPlay];
//            }
//        }
//    } failure:^(NSError *error) {
//
//    }];
//}

#pragma mark 获取音乐及音效
//- (void)getNow_musicWithParameters{
//    NSDictionary *dict = @{@"user_id":[UserManager userInfo].user_id,
//                           @"id":@""};
//    __weak __typeof(self)weakSelf = self;
//    [HttpTool getNow_musicWithParameters:dict success:^(id response) {
//        if ([response[@"code"] integerValue] == 1) {
//            weakSelf.musicModel = [RoomMusicModel mj_objectWithKeyValues:response[@"data"]];
//            weakSelf.musicModel.isPlay = @"0";
//            weakSelf.soundArray = [RoomMusicModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"yinxiao"]];
//        }
//    } failure:^(NSError *error) {
//
//    }];
//}

-(void)StopPlayData{
    
    WeakSelf
    /** 主播进去 或者 离开房间
     1 进入房间 2 退出房间
     */
    [self anchorLeaveOrJoinRoom:2 success:^{
        /** 2026-01-24 修改为不再关闭直播，直接退出页面即可*/
        [wself backClick];
    }];
    
    //    DSAlert * _alertView2                  = [[DSAlert alloc] ds_showTitle:getLanguage(@"提示") message:@"确定进行下播?"
    //                                                                     image:nil buttonTitles:@[@"取消", @"确定"] buttonTitlesColor:@[RGBA(102, 102, 102, 1), RGBA(255, 198, 0, 1)]];
    //    /*! 自定义按钮文字颜色 */
    //    //    _alertView2.buttonTitleColor = [UIColor orangeColor];
    //    _alertView2.bgColor = [UIColor colorWithRed:1.0 green:1.0 blue:1 alpha:0.1];
    //    /*! 是否开启进出场动画 默认：NO，如果 YES ，并且同步设置进出场动画枚举为默认值：1 */
    //    _alertView2.showAnimate = YES;
    //    /*! 显示alert */
    //    [_alertView2 ds_showAlertView];
    //    _alertView2.buttonActionBlock = ^(NSInteger index){
    //        if (index == 0)
    //        {
    //            NSLog(@"点击了取消按钮！");
    //            /*! 隐藏alert */
    //            [_alertView2 ds_dismissAlertView];
    //        }
    //        else if (index == 1)
    //        {
    //            NSLog(@"点击了确定按钮！");
    //            //退出房间
    //            [self getQuit_roomWithParameters:1];
    //            /*! 隐藏alert */
    //            [_alertView2 ds_dismissAlertView];
    //        }
    //    };
    
}

#pragma mark 退出房间
- (void)getQuit_roomWithParameters:(NSInteger)type{
    WeakSelf;
    [NetworkRequest POST:Request_Quit_hand parmeters:@{@"room_id":[MLRoomInformationModel currentAccount].room_id} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        if (basemodel.code == 1) {
            if(type==1){
                NSDictionary *dict = @{
                    @"messageType":@"9"};
                //             @"messageType":@"401"
                [wself appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict]];
                AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict]];
                [wself.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
                    
                }];
            }else if(type==2){
                
                NSDictionary *dict = @{
                    @"messageType":@"12"};
                [wself appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict]];
                AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict]];
                [wself.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
                    
                }];
                [wself backClick];
            }else{
                
                EMO_EndPlayViewController *vc=[EMO_EndPlayViewController new];
                vc.type=1;
                vc.dicData=[NSMutableDictionary dictionaryWithDictionary:@{@"image":[MLRoomInformationModel currentAccount].image,@"name":[MLRoomInformationModel currentAccount].name}];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            [wself.channel leaveWithCompletion:^(AgoraRtmLeaveChannelErrorCode errorCode) {
            }];
            [wself.agoraKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
            }];
            wself.isClose = NO;
            [wself.floatingWindow removeFromSuperview];
            //            [self getRoomUsersWithParameters:2];
            [MLRoomInformationManager clearUserInfo];
        }else{
            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[Common isNull:basemodel.msg]];
        }
        
        
    } failture:^(NSError *error) {
        
    }];
    
    
    
    
}
#pragma mark 取消关注
- (void)getCancel_followWithParameters:(NSString *)userID{
    [NetworkRequest POST:Request_GetfollowOrBlack parmeters:@{@"to_uid":userID,@"type":@"0"} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[Common isNull:basemodel.msg]];
    } failture:^(NSError *error) {
        
    }];
    
}

#pragma mark 关注
- (void)getFollowWithParameters:(NSString *)userID{
    
    [NetworkRequest POST:Request_GetfollowOrBlack parmeters:@{@"to_uid":userID,@"type":@"0"} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[Common isNull:basemodel.msg]];
    } failture:^(NSError *error) {
        
    }];
}
#pragma mark 举报
- (void)getSend_reportWithParameters:(NSString *)report{
    NSDictionary *dict = @{@"type":self.reportType,
                           @"user_id":[UserManager userInfo].user_id,
                           @"target":self.reportID,
                           @"img":@"",
                           @"report_type": report};
    
    [HttpTool getSend_reportWithParameters:dict success:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            
        }
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:response[@"message"]];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark 获取举报类型
- (void)getReport_typeWithParameters{
    
    WeakSelf;
    [NetworkRequest POST:Request_GetReportReason parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        EMO_UserReportViewController *VC = [[EMO_UserReportViewController alloc] init];
        VC.type=wself.reportType;
        VC.ryUserID =wself.reportID;
        VC.reportTypeArr = [MLUserReportModel mj_objectArrayWithKeyValuesArray:baseModel.data];
        [wself.navigationController pushViewController:VC animated:YES];
    } failture:^(NSError *error) {
        
    }];
    
    
    
}

#pragma mark 踢出房间
- (void)getOut_roomWithParameters:(NSString *)userID{
    WeakSelf;
    
    
    NSString *roomUserID=[NSString string];
    for (MLRoomAdminModel *mode in self.roomUserArray) {
        if([mode.uid integerValue]==[userID integerValue]){
            roomUserID=[Common isNull:mode.microphoneID];
            break;
        }
    }
    
    [NetworkRequest POST:Request_KickOutRoom parmeters:@{@"room_id":[MLRoomInformationModel currentAccount].room_id,@"room_user_id":roomUserID} success:^(id responObject) {
        //        BaseModel *basemodel=(BaseModel *)responObject;
        [wself getMicrophone_statusWithParameters:2];
        NSDictionary *dict1 = @{@"nickName":[UserManager userInfo].nickname,
                                @"user_id":[UserManager userInfo].user_id,
                                @"message":NSStringFormat(@"%@",wself.inputBoxView.inputTextView.text),
                                @"messageType":@"3"};
        AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict1]];
        [wself.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
        }];
        AgoraRtmMessage *message2 = [[AgoraRtmMessage alloc] initWithText:PeerMsg_RoomKick];
        [wself.agoraRtmKit sendMessage:message2 toPeer:userID completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
        }];
        
    } failture:^(NSError *error) {
        
    }];
    
    
    
}


#pragma mark 禁言 or 解除禁言
- (void)getIs_blackWithParameters:(NSString *)userID andType:(BOOL)status{
    WeakSelf;
    NSString *roomUserID=[NSString string];
    for (MLRoomAdminModel *mode in self.roomUserArray) {
        if([mode.uid integerValue]==[userID integerValue]){
            roomUserID=[Common isNull:mode.microphoneID];
            break;
        }
    }
    [NetworkRequest POST:Request_SetRoomUser parmeters:@{@"room_id":[MLRoomInformationModel currentAccount].room_id,@"type":@"0",@"room_user_id":roomUserID} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        if(status){
            AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:PeerMsg_ChatOff];
            [wself.agoraRtmKit sendMessage:message toPeer:userID completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
            }];
        }else{
            AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:PeerMsg_ChatOn];
            [wself.agoraRtmKit sendMessage:message toPeer:userID completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
            }];
        }
        
        [SVProgressHUD showImage:[UIImage imageNamed:@""] status:[Common isNull:basemodel.msg]];
        
    } failture:^(NSError *error) {
        
    }];
    
}



#pragma mark 打开麦克风  or 关闭麦克风
- (void)getRemove_soundWithParameters:(NSString *)microphoneID andStatus:(BOOL)Status{
    WeakSelf;//    microphone_position_id  麦序id
    NSDictionary *dic=[NSDictionary dictionary];
    if(microphoneID.length>0){
        dic=@{@"room_id":[MLRoomInformationModel currentAccount].room_id,@"type":@"1",@"microphone_position_id":microphoneID};//单人操作
    }else{
        dic=@{@"room_id":[MLRoomInformationModel currentAccount].room_id,@"type":@"0"};//全员操作
    }
    [NetworkRequest POST:Status==YES?Request_OpenMicrophone:Request_CloseMicrophone parmeters:dic success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:basemodel.msg]];
        if(microphoneID.length<1){
            self.AllCloseMicrophone=!self.AllCloseMicrophone;
            self.roomSettingView.allCloseMicrophone=self.AllCloseMicrophone;
            for (MLRoomMSequenceModel *model in wself.sequenceArray) {
                AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:wself.AllCloseMicrophone==YES?PeerMsg_MaiOff:PeerMsg_MaiOn];
                [wself.agoraRtmKit sendMessage:message toPeer:model.uid completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
                    
                }];
            }
            //            [self.roomBarrageView kaiMai];
        }
        
        [wself getMicrophone_statusWithParameters:2];
        //        NSDictionary *dict = @{@"nickName":[UserManager userInfo].nickname,
        //                               @"user_id":[UserManager userInfo].user_id,
        //                               @"message":@"",
        //                               @"messageType":@"3"};
        //        AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict]];
        //        [wself.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
        //        }];
        NSDictionary *dict = @{@"user_id":[UserManager userInfo].user_id,
                               @"msgType":Status==NO?@"1":@"2",//1关2开
                               @"microphone_position_id":microphoneID,
                               @"messageType":@"16"};
        AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict]];
        [wself.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
        }];
        
        
        
    } failture:^(NSError *error) {
        
    }];
    
}

#pragma mark 获取个人基本信息
- (void)get_other_userWithParameters:(NSString *)uId isZaimaishang:(NSString *)maishang{
    WeakSelf;
    
    [NetworkRequest POST:Request_getOtherUserInfo parmeters:@{@"to_uid":uId} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        NSDictionary *roomDic=basemodel.data[@"room_info"];
        NSDictionary *familyDic=basemodel.data[@"family_info"];
        NSLog(@"llla");
        MLRoomUserModel *model = [MLRoomUserModel mj_objectWithKeyValues:basemodel.data[@"user_info"]];
        
        if (![Common isBlankDictionary:roomDic]) {
            model.microphone_position_id=roomDic[@"microphone_position_id"];
            model.microphone_position_num=roomDic[@"microphone_position_num"];
            model.microphone_position_type=roomDic[@"microphone_position_type"];
            model.is_muted=roomDic[@"is_muted"];
            model.prevent_exit_microphone_position=[roomDic[@"prevent_exit_microphone_position"] integerValue];
        }
        
        if (![Common isBlankDictionary:familyDic]) {
            model.level_image=familyDic[@"level_image"];
        }
        model.skill_info=basemodel.data[@"skill_info"];
        model.zaiMaiShang = maishang;
        [wself.sequenceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MLRoomMSequenceModel *sequenceModel = (MLRoomMSequenceModel *)obj;
            if ([sequenceModel.uid integerValue] == [model.userID integerValue]) {
                model.zaiMaiShang = @"1";
            }
        }];
        wself.roomUserInfoView.model = model;
        [wself.view addSubview:wself.roomUserInfoView];
        [wself.roomUserInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.leading.trailing.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        
        //            [wself.bgView addSubview:wself.iconForUserInfoView];
        //            wself.iconForUserInfoView.model = model;
        
    } failture:^(NSError *error) {
        
    }];
    
    
    //    NSDictionary *dict = @{@"uid":[MLRoomInformationModel currentAccount].room_id, @"user_id":uId, @"my_id":[UserManager userInfo].user_id};
    //    __weak __typeof(self)weakSelf = self;
    //    [HttpTool get_other_userWithParameters:dict success:^(id response) {
    //        if ([response[@"code"] integerValue] == 1) {
    
    //        }
    //    } failure:^(NSError *error) {
    //
    //    }];
}

#pragma mark 设为闭麦YES or 开麦NO
- (void)getShut_microphoneWith:(NSString *)weizhi andMicrophoneID:(NSString *)ID andStatus:(BOOL)status{
    
    WeakSelf;
    [NetworkRequest POST:Request_LockMicrophone parmeters:@{@"room_id":[MLRoomInformationModel currentAccount].room_id,@"microphone_position_id":ID,@"type":@(!status?0:1)} success:^(id responObject) {
        //        BaseModel *basemodel=(BaseModel *)responObject;
        [wself getMicrophone_statusWithParameters:2];
        NSDictionary *dict = @{@"nickName":[UserManager userInfo].nickname,
                               @"user_id":[UserManager userInfo].user_id,
                               @"message":@"",
                               @"messageType":@"3"};
        
        AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict]];
        [wself.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
        }];
        //            “0,1,1,1,1,1,1,1” 0是开麦 1是闭麦
        NSString *str=[NSString string];
        NSInteger i=0;
        for (MLRoomMSequenceModel *mode in self.sequenceArray) {
            if (i==[weizhi integerValue]) {
                if(status){
                    str=[str stringByAppendingString:@"0,"];
                }else{
                    str=[str stringByAppendingString:@"1,"];
                }
                
                
            }else{
                if ([mode.status integerValue]==3) {
                    str=[str stringByAppendingString:@"1,"];
                }else{
                    str=[str stringByAppendingString:@"0,"];
                }
            }
            i++;
        }
        str = [str substringToIndex:15];
        NSLog(@"%@",str);
        [wself defaultAttbutesKey:@"Attribute_A" andValue:Attribute_Lock];
        [wself defaultAttbutesKey:Attribute_Lock andValue:str];//设为闭麦位
        
        
    } failture:^(NSError *error) {
        
    }];
    
    
    
}


#pragma mark 下麦
- (void)getGo_microphoneWithUserID:(NSString *)userId andType:(BOOL)type andMsgData:(NSString *) msg{
    
    NSDictionary *dic=[NSDictionary dictionary];
    dic=@{@"room_id":[MLRoomInformationModel currentAccount].room_id,@"type":type==YES?@"1":@"0",@"room_microphone_id":userId};
    
    WeakSelf;
    [NetworkRequest POST:Request_UnderMicrophone parmeters:dic success:^(id responObject) {
        //        BaseModel *model=(BaseModel *)responObject;
        [wself getMicrophone_statusWithParameters:2];
        
        if(msg.length>0){
            AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:PeerMsg_MaiDown];
            [wself.agoraRtmKit sendMessage:message toPeer:msg completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
                
            }];
        }
        
        //        [wself.agoraKit setClientRole:AgoraClientRoleBroadcaster];
        [wself.agoraKit setClientRole:AgoraClientRoleAudience];
        NSDictionary *dict = @{@"nickName":[UserManager userInfo].nickname,
                               @"user_id":[UserManager userInfo].user_id,
                               @"message":@"",
                               @"messageType":@"3"};
        AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict]];
        [wself.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
            if ([userId integerValue] == [[UserManager userInfo].user_id integerValue]) {
                [wself.roomBarrageView xiamaiSetUI];
                [wself.agoraKit enableLocalAudio:NO];
                [wself.agoraKit stopAudioMixing];
            }
        }];
        
        
    } failture:^(NSError *error) {
        
        
    }];
    
    
    
}

#pragma mark 申请上麦
- (void)requestSQSM:(NSString *)micID{
    WeakSelf;
    [NetworkRequest POST:Request_ApplyMicrophonePosition parmeters:@{@"room_id":[Common isNull:[MLRoomInformationModel currentAccount].room_id],@"microphone_position_id":micID} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:basemodel.msg]];
        NSDictionary *dict =[NSDictionary dictionary];
        
        if([[MLRoomInformationModel currentAccount].uuid integerValue]==[[UserManager userInfo].user_id integerValue]){
            dict = @{@"messageType":@"3"};
        }else{
            dict = @{@"messageType":@"15"};//暂时隐藏房主同意步骤,用户点击直接上麦
        }
        dict = @{@"messageType":@"3"};
        AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict]];
        [wself.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {}];
        [self getMicrophone_statusWithParameters:2];
    } failture:^(NSError *error) {
        
    }];
    
    
}

#pragma mark  抱人上麦和同意上麦
- (void)getUp_microphoneWithParameters:(NSString *)maiXu user_id:(NSString *)userID andData:(NSDictionary *)model{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[MLRoomInformationModel currentAccount].room_id forKey:@"room_id"];
    //    if ([userID isEqualToString:@""]) {
    //        [dict setValue:[UserManager userInfo].user_id forKey:@"room_user_id"];
    //    }else{
    [dict setValue:userID forKey:@"room_user_id"];
    [dict setValue:@"1" forKey:@"type"];
    //    }
    [dict setValue:@"1" forKey:@"microphone_position_id"];
    if (!maiXu) {
        [self.sequenceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MLRoomMSequenceModel *model = (MLRoomMSequenceModel *)obj;
            if ([model.status integerValue] == 1) {
                [dict setValue:@(idx) forKey:@"position"];
                *stop = YES;
            }
        }];
    }else{
        [dict setValue:maiXu forKey:@"microphone_position_id"];
    }
    
    WeakSelf;
    [NetworkRequest POST:Request_AgreeMicrophoneApply parmeters:dict success:^(id responObject) {
        [wself getMicrophone_statusWithParameters:2];
        NSDictionary *dict = @{@"nickName":[UserManager userInfo].nickname,
                               @"user_id":@"",
                               @"message":@"",
                               @"messageType":@"3"};
        AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict]];
        [wself.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
            if ([userID integerValue] == [[UserManager userInfo].user_id integerValue]) {
                [wself.roomBarrageView shangxiamaiSetUI];
                [wself.agoraKit setClientRole:AgoraClientRoleBroadcaster];
            }
        }];
        self.roomWheatView.freshDara=YES;//刷新上麦用户列表
        [self getRoomInfoWithParameters:2 commplete:^{
            
        }];
    } failture:^(NSError *error) {
        
    }];
}
#pragma mark 获取房间状态 麦序列表
// 获取房间状态 麦序列表
- (void)getMicrophone_statusWithParameters:(NSInteger)A{
    WeakSelf;
    
    [NetworkRequest POST:Request_GetRoomMicrophonePosition parmeters:@{@"room_id":[MLRoomInformationModel currentAccount].room_id} success:^(id responObject) {
        BaseModel *baemodel=(BaseModel *)responObject;
        NSLog(@"%@",baemodel.data);
        //        is_arr 1是全员禁麦 0不是
        self.AllCloseMicrophone=[baemodel.data[@"is_arr"] boolValue];
        wself.sequenceArray = [MLRoomMSequenceModel mj_objectArrayWithKeyValuesArray:baemodel.data[@"microphone_position"]];
        [wself.roomHostView setSequenceArray:wself.sequenceArray];
        
        /** 刷新 主播 是否在主播间*/
        wself.roomHostView.currentRoomInfo = wself.currentRoomInfo ;
        
        [wself.roomBarrageView setPaimaiWithArry:wself.sequenceArray];
        [wself.sequenceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MLRoomMSequenceModel *model = (MLRoomMSequenceModel *)obj;
            if(idx==0){
                self.countTime=[model.countdown_times integerValue]*60;
                self.startOrCloseTime=[model.is_countdown boolValue];
            }
            if ([model.uid integerValue] == [[UserManager userInfo].user_id integerValue]) {
                [wself.agoraKit setClientRole:AgoraClientRoleBroadcaster];
                [wself.roomBarrageView shangxiamaiSetUI];
                if (wself.shangMai==YES) {
                    [wself.agoraKit enableLocalAudio:YES];
                    //                    if([model.type integerValue]==1){
                    [wself.roomBarrageView kaiMai:YES andType:1];
                    //                    }else{
                    //                        [wself.roomBarrageView kaiMai:NO andType:1];
                    //                    }
                    
                }
            }
        }];
        
        
    } failture:^(NSError *error) {
        
    }];
    
}

#pragma mark 更新房间设置数据
- (void)getRoomInfoData{
    
    [NetworkRequest POST:Request_GetRoomInfo parmeters:@{@"room_id":[MLRoomInformationModel currentAccount].room_id} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        NSDictionary *dicData=basemodel.data[@"room_info"];
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:dicData[@"room_bg_image"]]];
        [MLRoomInformationModel currentAccount].notice = [Common isNull:dicData[@"notice"]];
        [MLRoomInformationModel currentAccount].name =[Common isNull:dicData[@"name"]];
        [MLRoomInformationModel currentAccount].room_bg_image =[Common isNull:dicData[@"room_bg_image"]];
        [MLRoomInformationModel currentAccount].room_image_id =[Common isNull:dicData[@"room_image_id"]];
        [MLRoomInformationModel currentAccount].partition_name =[Common isNull:dicData[@"partition_name"]];
        [MLRoomInformationModel currentAccount].partition_id =[Common isNull:dicData[@"partition_id"]];
        [self.roomTopView loadData];
        [self.roomAnnouncementView upData];
        
        
    } failture:^(NSError *error) {
        
    }];
    
    
    
}
#pragma mark 开启or关闭倒计时
-(void)startOrCloseTimeData:(NSInteger )type{
    WeakSelf;
    if(self.startOrCloseTime){
        self.timeLabel.hidden=NO;
        self.count = self.countTime;
        self.timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
        self.timeLabel.text=[NSString stringWithFormat:@"麦位倒计时\n%ld",self.count];
    }else{
        self.timeLabel.hidden=YES;
        [self.timer invalidate];
        self.timer = nil;
        _count = self.countTime;
    }
    
    
    if(type==1){
        [NetworkRequest POST:Request_SetMicrophoneCountdown parmeters:@{@"room_id":[MLRoomInformationModel currentAccount].room_id,@"type":@(self.startOrCloseTime?0:1)} success:^(id responObject) {
            //        BaseModel *basemodel=(BaseModel *)responObject;
            
            NSDictionary *dict =[NSDictionary dictionary];
            if(self.startOrCloseTime){
                dict = @{@"messageType":@"10"};
                [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"开启倒计时")];
            }else{
                dict = @{@"messageType":@"11"};
                [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"关闭倒计时")];
            }
            AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict]];
            [wself.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
                
            }];
            
            
            
            //        [wself.sequenceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //            MLRoomMSequenceModel *sequenceModel = (MLRoomMSequenceModel *)obj;
            //            if([sequenceModel.status integerValue]==2){
            //                AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:self.startOrCloseTime?PeerMsg_TimeOn:PeerMsg_TimeOff];
            //                    [wself.agoraRtmKit sendMessage:message toPeer:sequenceModel.uid completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
            //                    }];
            //            }
            //            NSLog(@"AAA=%@",sequenceModel);
            //        }];
            
            
        } failture:^(NSError *error) {
            
        }];
    }
    
    
}
-(void)timerEvent{
    self.count--;
    self.timeLabel.text=[NSString stringWithFormat:@"麦位倒计时\n%ld",self.count];
    if (self.count == 0) {
        self.titleLabel.hidden=YES;
        self.startOrCloseTime=NO;
        [self.timer invalidate];
        self.timer = nil;
        self.count = self.countTime;
        
        if([[MLRoomInformationModel currentAccount].is_me integerValue]==1){//判断是否是房主,
            WeakSelf;
            
            [NetworkRequest POST:Request_ExitAllMicrophone parmeters:@{@"room_id":[MLRoomInformationModel currentAccount].room_id} success:^(id responObject) {
                [wself.sequenceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    MLRoomMSequenceModel *sequenceModel = (MLRoomMSequenceModel *)obj;
                    NSLog(@"AAA=%@",sequenceModel);
                    if([sequenceModel.status integerValue]==2){
                        AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:self.startOrCloseTime?PeerMsg_TimeOn:PeerMsg_TimeOff];
                        [wself.agoraRtmKit sendMessage:message toPeer:sequenceModel.uid completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
                        }];
                    }
                    
                }];
                //                AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:PeerMsg_TimeOver];
                //                [wself.agoraRtmKit sendMessage:message toPeer:@"" completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
                //                }];
                //
            } failture:^(NSError *error) {
                
            }];
        }
    }
}

// 文本将要改变
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"/n"]) {
        return NO;
    }
    NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (temp.length > 50)
    {
        textView.text = [temp substringToIndex:50];
        //            [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"最多输入50字")];
        return NO;
    }
    // 设置输入汉字拼音未确定状态的文字样式
    textView.typingAttributes = self.attributes;
    return YES;
}
- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.text.length > 0) {
        self.inputBoxView.beiJingLB.hidden = YES;
    }else{
        self.inputBoxView.beiJingLB.hidden = NO;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.typingAttributes = self.attributes;
}

- (void)textViewDidChange:(UITextView *)textView {
    textView.typingAttributes = self.attributes;
    if (!textView.markedTextRange) {
        NSRange selectedRange = textView.selectedRange;
        NSAttributedString *attributedString = [YBEmojiDataManager.manager replaceEmojiWithAttributedString:textView.attributedText attributes:self.attributes];
        NSUInteger offset = textView.attributedText.length - attributedString.length;
        textView.attributedText = attributedString;
        textView.selectedRange = NSMakeRange(selectedRange.location - offset, 0);
    }else{
        // 输入汉字拼音未确定状态, 不做处理
    }
    [self refreshUIWith:textView];
}


- (void)refreshUIWith:(UITextView *)textView {
    CGFloat heigh = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)].height + 20;
    heigh = heigh < 55 ? 55 : heigh;
    heigh = heigh > 100 ? 100 : heigh;
    textView.scrollEnabled = heigh >= 100;
    CGFloat max_y = CGRectGetMaxY(self.inputBoxView.frame);
    CGFloat min_y = max_y - heigh;
    
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.inputBoxView.frame = CGRectMake(0, min_y, self.view.bounds.size.width, heigh);
    }];
}
#pragma mark - 定时器更该进度

- (void)updateWaitTime{
    //
    //    [self.roomMusicView setSliderCurrentValue:[self.agoraKit getAudioMixingCurrentPosition] maximumValue:[self.agoraKit getAudioMixingDuration]];
    //
    ////    [self.roomMusicView setSliderCurrentValue:[self.agoraKit getAudioMixingCurrentPosition] maximumValue:[self.agoraKit getAudioFileInfo:[Common isNull:self.musicModel.music_url]]];
    
    
}
- (void)startTime {
    //    [self.roomMusicView.timer invalidate];
    //    self.roomMusicView.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateWaitTime) userInfo:nil repeats:YES];
}

- (void)cancelTime{
    //    [self.roomMusicView.timer invalidate];
    //    self.roomMusicView.timer = nil;
}
#pragma mark - UIKeyboardNotification
- (void)keyboardWillShow:(NSNotification *)aNotification {
    double duration = [aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat keyboard_h = [aNotification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.inputBoxView.frame = CGRectMake(0, weakSelf.bgView.height - keyboard_h - weakSelf.inputBoxView.height, ScreenViewWidth, CGRectGetHeight(weakSelf.inputBoxView.frame));
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    __weak __typeof(self)weakSelf = self;
    double duration = [aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        weakSelf.inputBoxView.frame = CGRectMake(0, weakSelf.bgView.height, weakSelf.bgView.width, 50);
    }];
}

- (void)dealloc {
    //    if (self.socket) {
    [self.socket close];
    //    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PopReChangeViewController" object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RoomOutOfTheClick" object:nil];
    MYLog(@"%s", __func__);
}


#pragma mark ======================  声网配置，进入房间   ======================

- (void)setAgoraRtcEngineKitOrAgoraRtmKit{
    WEAK_SELF
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:kAppAgoraKitId delegate:self];
    
    self.agoraRtmKit = [[AgoraRtmKit alloc] initWithAppId:kAppAgoraKitId delegate:self];
    [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    [self.agoraKit leaveChannel:nil];
    
    [self.agoraKit setDefaultAudioRouteToSpeakerphone:YES];
    
    NSString *RTCToken = UserDefaultsGet(@"ShengWangRTCToken");
    if ([self.agoraKit joinChannelByToken:RTCToken channelId:[MLRoomInformationModel currentAccount].room_id info:nil uid:[[UserManager userInfo].user_id integerValue] joinSuccess:nil] == 0)
    {
        NSLog(@"ssss");
    }else{
        NSLog(@"bbbbb");
    }
    if ([[MLRoomInformationModel currentAccount].user_type isEqualToString:@"1"]) {
        //        [self.agoraKit setClientRole:AgoraClientRoleBroadcaster];
        //AgoraClientRoleBroadcaster
        [self.agoraKit setClientRole:AgoraClientRoleAudience];
    }else{
        [self.agoraKit setClientRole:AgoraClientRoleAudience];
    }
    [self.agoraKit enableAudioVolumeIndication:100 smooth:3 report_vad:YES];
    NSInteger curUid = [[UserManager userInfo].user_id integerValue];
    NSInteger userUid = [[MLRoomInformationModel currentAccount].uuid integerValue];
    
    if (curUid == userUid) {
        NSString *userID = [UserManager userInfo].user_id;
        NSString *RTMToken = UserDefaultsGet(@"ShengWangRTMToken");
        [self.agoraRtmKit loginByToken:RTMToken user:[Common isNull:userID] completion:^(AgoraRtmLoginErrorCode errorCode) {
            weakSelf.channel = [weakSelf.agoraRtmKit createChannelWithId:[MLRoomInformationModel currentAccount].room_id delegate:self];
            [weakSelf.channel joinWithCompletion:^(AgoraRtmJoinChannelErrorCode state) {
                [weakSelf.agoraKit adjustAudioMixingVolume:10];
                //                [weakSelf get_user_vipWithParameters:@"1"];
                [weakSelf settingChannalAttributeData];
                [weakSelf.agoraKit enableLocalAudio:YES];
            }];
            ///加入/创建全频道
            weakSelf.allChannel = [weakSelf.agoraRtmKit createChannelWithId:@"897432975" delegate:weakSelf];
            [weakSelf.allChannel joinWithCompletion:^(AgoraRtmJoinChannelErrorCode state) {
            }];
        }];
    }else{
        NSString *RTMToken = UserDefaultsGet(@"ShengWangRTMToken");
        
        if (![NSString NotNull:RTMToken]) {
            [SVProgressHUD showTextHUDWithMessage:@"token为空"];
            return;
        }
        
        [self.agoraRtmKit loginByToken:RTMToken user:NSStringFormat(@"%@",[UserManager userInfo].user_id) completion:^(AgoraRtmLoginErrorCode errorCode) {
            weakSelf.channel = [weakSelf.agoraRtmKit createChannelWithId:NSStringFormat(@"%@",[MLRoomInformationModel currentAccount].room_id) delegate:weakSelf];
            [weakSelf.channel joinWithCompletion:^(AgoraRtmJoinChannelErrorCode state) {
                [weakSelf.agoraKit adjustAudioMixingVolume:10];
                if(state == AgoraRtmJoinChannelErrorOk) {
                    //                    [weakSelf get_user_vipWithParameters:@"0"];
                    [weakSelf settingChannalAttributeData];
                } else {
                    [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"进入房间失败，请稍后再试"];
                    weakSelf.isClose = NO;
                    [weakSelf.floatingWindow removeFromSuperview];
                    [weakSelf backClick];
                    [MLRoomInformationManager clearUserInfo];
                }
            }];
            
            ///加入/创建全频道
            weakSelf.allChannel = [weakSelf.agoraRtmKit createChannelWithId:@"897432975" delegate:weakSelf];
            [weakSelf.allChannel joinWithCompletion:^(AgoraRtmJoinChannelErrorCode state) {
            }];
        }];
    }
    //    [MLRoomInformationManager saveUserInfo:[MLRoomInformationModel currentAccount]];
}

-(void)settingChannalAttributeData{
    self.channelAttributeOption=[AgoraRtmChannelAttributeOptions new];
    self.channelAttributeOption.enableNotificationToChannelMembers=YES;
    [self.agoraRtmKit getChannelAllAttributes:[MLRoomInformationModel currentAccount].room_id completion:^(NSArray<AgoraRtmChannelAttribute *> * _Nullable attributes, AgoraRtmProcessAttributeErrorCode errorCode) {
        if (attributes.count<1) {
            [self defaultAttbutesKey:@"Attribute_A" andValue:@"defAction"];
            NSLog(@"没有属性,添加默认属性");
        }else{
            NSLog(@"已有属性:%@",attributes);
        }
    }];
    
}



#pragma mark- setView添加视图
- (void)setUIViewUp{
    [self.bgView addSubview:self.bgImageView];
    [self.bgView addSubview:self.roomTopView];
    [self.bgView addSubview:self.roomHostView];
    
    [self.bgView addSubview:self.roomBarrageView];
    [self.roomBarrageView addSubview:self.tableView];
    [self.roomBarrageView sendSubviewToBack:self.tableView];
    [self.bgView addSubview:self.inputBoxView];
    self.view.backgroundColor = ML_DarkColor;
    self.bgView.backgroundColor = ML_DarkColor;
    //    self.musicCycle = @"list";;
    //    self.isPlay = NO;
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:[MLRoomInformationModel currentAccount].room_bg_image]];
    
    [self.bgView addSubview:self.renderView];
    
    [self.renderView start];
    [self getUserInfoMessage];
    //    如果增加飘屏开关需要使用以下方法
    //    [self.renderView stop];//停止飘屏
    
    
    WEAK_SELF
    
    
    
#pragma mark  排行榜
    self.roomHostView.paiHangBangBlock = ^{
        [weakSelf.view addSubview:weakSelf.rankingListView];
        [weakSelf.rankingListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.leading.trailing.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
    };
#pragma mark 在线人数
    self.roomHostView.peopleNumBlock = ^{
        [weakSelf.bgView addSubview:weakSelf.onlineUserView];
    };
    
    
#pragma mark  公告
    self.roomHostView.noticeBlock = ^{
        //房间公告
        [weakSelf.bgView addSubview:weakSelf.roomAnnouncementView];
        [weakSelf.roomAnnouncementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.leading.trailing.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
    };
#pragma mark  麦位点击事件
    self.roomHostView.roomHostViewClickBlock = ^(NSInteger idx) {
        MLRoomMSequenceModel *model = weakSelf.sequenceArray[idx];
        if (idx == 0) {
            if([model.status integerValue]==2){
                [weakSelf get_other_userWithParameters:[MLRoomInformationModel currentAccount].uuid isZaimaishang:@"1"];
            }else{
                [weakSelf requestSQSM:[Common isNull:model.ID]];
            }
            return ;
        }
        
        if ([model.status integerValue] == 2) {
            
            if([model.uid integerValue]==[[UserManager userInfo].user_id integerValue]){
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:getLanguage(@"温馨提示") message:getLanguage(@"确定要下麦吗?") preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf getGo_microphoneWithUserID:model.ID andType:NO andMsgData:@""];
                    [weakSelf.agoraKit setClientRole:AgoraClientRoleAudience];
                    [weakSelf.agoraKit stopAudioMixing];
                    [weakSelf.roomBarrageView xiamaiSetUI];
                    weakSelf.firstKaiMai=1;
                }]];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }else{
                [weakSelf get_other_userWithParameters:model.uid isZaimaishang:@"1"];
            }
            
            
        }else if ([model.status integerValue] == 0){
            if(idx==1){
                [SVProgressHUD showImage:KGetImage(@"") status:@"老板麦无法申请"];
                return;
            }
            if ([[MLRoomInformationModel currentAccount].user_type integerValue] == 0) {
                // 直接上麦
                //                [weakSelf getUp_microphoneWithParameters:NSStringFormat(@"%d",idx - 1) user_id:@""];
                [weakSelf requestSQSM:model.ID];
                
            }else{
                [weakSelf.bgView addSubview:weakSelf.roomClickUserView];
                [weakSelf.roomClickUserView setUpViewWithModel:model];
                weakSelf.roomClickUserView.listClickBlock = ^(NSInteger idxe,MLRoomMSequenceModel *model) {
                    if (idxe == 1) {
                        //                        [weakSelf getUp_microphoneWithParameters:NSStringFormat(@"%ld",idx - 1) user_id:@""];
                        [weakSelf requestSQSM:model.ID];
                    }else if (idxe == 2) {
#pragma mark 抱人上麦
                        [weakSelf get_room_usersWithParameters:model.ID userID:@""];
                        //                        [weakSelf get_room_usersWithParameters:NSStringFormat(@"%ld",idx - 1) userID:@""];
                    }else{
                        [weakSelf getShut_microphoneWith:NSStringFormat(@"%ld",idx) andMicrophoneID:model.ID andStatus:YES];
                    }
                };
            }
            
        }else if ([model.status integerValue] == 1){
            if ([[MLRoomInformationModel currentAccount].user_type integerValue] == 0) {
                [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"该麦位已锁"];
            }else{
                [weakSelf.bgView addSubview:weakSelf.roomClickUserView];
                [weakSelf.roomClickUserView setUpViewWithModel:model];
                weakSelf.roomClickUserView.listClickBlock = ^(NSInteger idxe,MLRoomMSequenceModel *model) {
                    if (idxe == 2) {
                        //                        [weakSelf.bgView addSubview:weakSelf.holdingMView];
                        //                        weakSelf.holdingMView.holdingMClickBlock = ^(NSString *textTF) {
                        //                            [weakSelf getUp_microphoneWithParameters:NSStringFormat(@"%ld",idx - 1) user_id:textTF];
                        //                        };
                    }else{
                        [weakSelf getShut_microphoneWith:NSStringFormat(@"%ld",idx) andMicrophoneID:model.ID andStatus:NO];
                        //                        [weakSelf getOpen_microphoneWith:NSStringFormat(@"%ld",idx - 1)];
                    }
                };
            }
        }
    };
    
#pragma mark 房间游戏中心点击
    self.roomBarrageView.scycleClickBlock = ^(NSInteger tag, NSInteger index, NSDictionary *dic) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [MLChatRoomGameCenterDialog showInView:window];
    };
    
    self.roomBarrageView.sureClickBlock = ^(NSInteger index) {
        
        if(index==1||index==666){
            NSLog(@"开麦or闭麦");
            //                if((([[MLRoomInformationModel currentAccount].is_me integerValue]==1)&&(index==666))){
            //                    for (MLRoomMSequenceModel *mode in weakSelf.sequenceArray) {
            //                        if([mode.uid integerValue]==[[MLRoomInformationModel currentAccount].uuid integerValue]){
            //                            [weakSelf getRemove_soundWithParameters:[NSString stringWithFormat:@"%@",mode.ID] andStatus: weakSelf.roomBarrageView.isMai];
            //                            break;
            //                        }
            //                    }
            //                }
            //麦克风
            [weakSelf.agoraKit enableLocalAudio:weakSelf.roomBarrageView.isMai];
            weakSelf.shangMai=weakSelf.roomBarrageView.isMai;
            MYLog(@">>>>>>>>>>>>>%d",weakSelf.roomBarrageView.isMai);
            [weakSelf.roomHostView setWaveLayerWithUid:[[UserManager userInfo].user_id integerValue] open:!weakSelf.roomBarrageView.isMai sequenceArray:weakSelf.sequenceArray];
            
        }else if (index==2){
            NSLog(@"房间设置");
            //房间设置
            [weakSelf.view addSubview:weakSelf.roomSettingView];
            [weakSelf.roomSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.leading.trailing.mas_equalTo(0);
                make.bottom.mas_equalTo(KAdaptedHeight(0));
                //            make.height.mas_equalTo(KAdaptedHeight(186));
            }];
            
            //            [weakSelf.bgView addSubview:weakSelf.bottomMoreView];
            
        }else if (index==3){
            [weakSelf StopPlayData];
        }else if (index==4){
            NSLog(@"表情");
            //键盘
            [weakSelf.inputBoxView.inputTextView becomeFirstResponder];
        }else if (index==5){
            NSLog(@"排队上麦列表");
            ///展开申请上麦列表
            [weakSelf.roomWheatView showView];
        }else if (index==6){
            NSLog(@"礼物");
            [weakSelf getGift_listWithParameters:nil];
        }else if (index==7){
            NSLog(@"发消息");
            //键盘
            [weakSelf.inputBoxView.inputTextView becomeFirstResponder];
        }else{
            //消息列表
            EMO_RoomChatVC *vc = [[EMO_RoomChatVC alloc] init];
            ZXNavigationController *nav = [[ZXNavigationController alloc] initWithRootViewController:vc];
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [weakSelf presentViewController:nav animated:YES completion:nil];
            vc.dismisBlock = ^(NSString *tag,NSString *title){
                MLSessionViewController *VC = [[MLSessionViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:tag];
                VC.title = title;
                [weakSelf.navigationController pushViewController:VC animated:YES];
            };
        }
    };
    
#pragma mark 发消息
    self.inputBoxView.sendSeBlock = ^{
        
        NSString *str = weakSelf.inputBoxView.inputTextView.text;
        str = [str stringByReplacingOccurrencesOfString:@"\n"withString:@""];
        if ([str isEqualToString:@""]) {
            return ;
        }
        [NetworkRequest POST:Request_replaceText parmeters:@{@"message":str} success:^(id responObject) {
            BaseModel *baseModel = (BaseModel *)responObject;
            [NetworkRequest POST:Request_CheckMessage parmeters:@{@"message":[Common isNull:baseModel.data]} success:^(id responObject) {
                if ([MLRoomInformationModel currentAccount].isBanned) {
                }else{
                    NSDictionary *dict = @{@"nickName":[UserManager userInfo].nickname,
                                           @"user_id":[UserManager userInfo].user_id,
                                           //                   @"nick_color":[Common isNull:weakSelf.dictInfo[@"nick_color"]],
                                           @"message":NSStringFormat(@"%@",baseModel.data),
                                           @"peerage_image":[Common isNull:[UserManager userInfo].peerage_icon],
                                           @"contribute_level":[Common isNull:[UserManager userInfo].contribute_level],
                                           @"charm_level":[Common isNull:[UserManager userInfo].charm_level],
                                           @"messageType":@"1"};
                    AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict]];
                    [weakSelf.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
                        
                    }];
                    [weakSelf appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict]];
                    weakSelf.inputBoxView.inputTextView.text = @"";
                    [weakSelf.inputBoxView.inputTextView resignFirstResponder];
                }
            } failture:^(NSError *error) {}];
        } failture:^(NSError *error) {
            
        }];
    };
    
    [[UIApplication sharedApplication].delegate.window addSubview:self.floatingWindow];
    self.floatingWindow.hidden = YES;
    self.floatingWindow.muteSwitchButtonBlock = ^{
        if (weakSelf.roomBarrageView.isVoice) {
            weakSelf.roomBarrageView.isVoice = NO;
            [weakSelf.floatingWindow.muteSwitchButton setImage:[UIImage imageNamed:@"home_fuchuang_mute"] forState:UIControlStateNormal];
        }else{
            weakSelf.roomBarrageView.isVoice = YES;
            [weakSelf.floatingWindow.muteSwitchButton setImage:[UIImage imageNamed:@"home_fuchuang_voice"] forState:UIControlStateNormal];
        }
        [weakSelf.agoraKit muteAllRemoteAudioStreams:!weakSelf.roomBarrageView.isVoice];
    };
    self.floatingWindow.shutDownButtonBlock = ^{
        //退出房间
        if([[MLRoomInformationModel currentAccount].uuid integerValue]==[[UserManager userInfo].user_id integerValue]){
            [weakSelf getQuit_roomWithParameters:1];
        }else{
            
            /** 主播进去 或者 离开房间
             1 进入房间 2 退出房间
             */
            /** 2026-01-24 修改为不再关闭直播，直接退出页面即可*/
            [weakSelf anchorLeaveOrJoinRoom:2 success:^{
                [weakSelf.floatingWindow removeFromSuperview];
            }];
            //            [weakSelf getQuit_roomWithParameters:2];
            
        }
        [weakSelf.socket close];
    };
    
    self.roomManagerView.SuccessClick = ^(NSDictionary * _Nonnull dic, NSInteger typeStatus) {
        if(typeStatus==1){//设置管理员
            [weakSelf.agoraRtmKit sendMessage:[[AgoraRtmMessage alloc] initWithText:[dic[@"type"] integerValue] == 0?PeerMsg_AdminOn:PeerMsg_AdminOff] toPeer:[Common isNull:dic[@"uid"]] completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
            }];
            
        }else if (typeStatus==2){//解除禁言
            [weakSelf.agoraRtmKit sendMessage:[[AgoraRtmMessage alloc] initWithText:[dic[@"is_muted"] integerValue] == 0?PeerMsg_ChatOff:PeerMsg_ChatOn] toPeer:[Common isNull:dic[@"uid"]] completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
            }];
            
        }else{//拉黑设置
            NSLog(@"拉黑设置");
            if([dic[@"is_black"] integerValue]==0){
                AgoraRtmMessage *message2 = [[AgoraRtmMessage alloc] initWithText:PeerMsg_BlackRoomKick];
                [weakSelf.agoraRtmKit sendMessage:message2 toPeer:[Common isNull:dic[@"uid"]] completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
                }];
                
            }
        }
        
    };
    
    WeakSelf
    [self getRoomInfoWithParameters:1 commplete:^{
        [wself getMicrophone_statusWithParameters:2];
    }];
    [self getRoomUsersWithParameters:1];
    [self timeLabel];
    self.timeLabel.hidden=YES;
    
}
#pragma mark 带标题的分享弹窗
- (void)showShareViewWithTitle{
    WeakSelf;
    // [[BWItemModel alloc] initWithImg:@"shareFriendImg" text:getLanguage(@"emo好友")]
    BWShareView *shareView = [[BWShareView alloc] initWithFrame:self.view.bounds shareTitle:getLanguage(@"分享至") shareArray:[NSMutableArray arrayWithObjects:[[BWItemModel alloc] initWithImg:@"wechatImg" text:getLanguage(@"微信好友")],[[BWItemModel alloc] initWithImg:@"pengyouquanImg" text:getLanguage(@"朋友圈")], nil]];
    [shareView show];
    shareView.shareItemClick = ^(BWItemModel * _Nonnull model) {
        NSLog(@"name1 = %@", model.text);
        if ([model.text isEqualToString:getLanguage(@"微信好友")]) {
            //            [wself shareWeChat:WXSceneSession];
            [wself shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
        }else if ([model.text isEqualToString:getLanguage(@"朋友圈")]){
            //            [wself shareWeChat:WXSceneTimeline];
            [wself shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
        }else if ([model.text isEqualToString:getLanguage(@"复制链接")]){
            UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
            pastboard.string = [NSString stringWithFormat:@"https://www.baidu.com"];
            [SVProgressHUD showSuccessWithStatus:getLanguage(@"已复制")];
        }else{
            
            EMO_ShareFirendListViewController *vc=[EMO_ShareFirendListViewController new];
            vc.type=2;
            vc.dicData=@{@"roomId":[MLRoomInformationModel currentAccount].room_id,@"roomName":[MLRoomInformationModel currentAccount].name,@"roomImage":[MLRoomInformationModel currentAccount].image,@"roomNotice":[MLRoomInformationModel currentAccount].notice,@"roomUuid":[MLRoomInformationModel currentAccount].uuid,@"roomStatus":[MLRoomInformationModel currentAccount].status,@"roomType":[MLRoomInformationModel currentAccount].type};
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    };
}


-(void)shareWeChat:(int )type{
    
    SendMessageToWXReq *req1 = [[SendMessageToWXReq alloc]init];
    // 是否是文档
    req1.bText =  NO;
    
    //    WXSceneSession  = 0,        /**< 聊天界面    */
    //    WXSceneTimeline = 1,        /**< 朋友圈      */
    //    WXSceneFavorite = 2,     //收藏
    req1.scene = type;
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = @"U遇";//分享标题
    //    urlMessage.description = @"EMO情绪管理处";//分享描述
    urlMessage.description = @"您的情绪管理大师";//分享描述
    [urlMessage setThumbImage:[UIImage imageNamed:@"shareIcon"]];
    // *****************  微信分享时，图片大小必须小于32k   ************************
    //    [urlMessage setThumbImage:[self compressImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dict[@"imgUrl"]]]]] toByte:32768]];
    //创建多媒体对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = @"https://www.baidu.com";//分享链接
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    req1.message = urlMessage;
    //发送分享信息
    //    [WXApi sendReq:req1];
    [WXApi sendReq:req1 completion:^(BOOL success) {
        NSLog(@"%d",success);
        
    }];
    
    
    
}







- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType{
    if (![[UMSocialManager defaultManager] isInstall:platformType]) {
        [SVProgressHUD showErrorWithStatus:@"未安装此应用"];
        return;
    }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[Common isNull:[MLRoomInformationModel currentAccount].name] descr:[Common isNull:[MLRoomInformationModel currentAccount].notice] thumImage:[MLRoomInformationModel currentAccount].image];
    shareObject.webpageUrl = [Common isNull:[UserManager userInfo].invite_url];
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if(error)
        {
            MYLog(@"分享 error %@",error);
            [SVProgressHUD showErrorWithStatus:error.userInfo[@"message"]];
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}
- (void)backClick{
    [super backClick];
    [self duankaiSocketMethod];
}


- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [ControlCreator createImageView:self.bgView rect:CGRectMake(0, 0, self.bgView.width, self.bgView.height) imageName:@"WechatIMG29" backguoundColor:nil];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

///申请上麦列表
- (EMO_RoomSQSMView *)roomWheatView{
    if (!_roomWheatView) {
        _roomWheatView = [[EMO_RoomSQSMView alloc] initWithFrame:self.bgView.frame];
        [self.bgView addSubview:_roomWheatView];
        WeakSelf;
        _roomWheatView.SQBlock = ^(NSDictionary * _Nonnull dic) {
            //        dic[@"type"]    1同意 2拒绝
            if ([dic[@"type"] integerValue]==1) {
                [wself getRoomInfoWithParameters:2 commplete:^{
                    
                }];
                [wself getMicrophone_statusWithParameters:3];
                NSDictionary *dict = @{@"nickName":[UserManager userInfo].nickname,
                                       @"user_id":@"",
                                       @"message":@"",
                                       @"messageType":@"3"};
                AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict]];
                [wself.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
                    if ([dict[@"userid"] integerValue] == [[UserManager userInfo].user_id integerValue]) {
                        [wself.roomBarrageView shangxiamaiSetUI];
                        [wself.agoraKit setClientRole:AgoraClientRoleBroadcaster];
                    }
                }];
                AgoraRtmMessage *message1 = [[AgoraRtmMessage alloc] initWithText:PeerMsg_MaiUp];
                [wself.agoraRtmKit sendMessage:message1 toPeer:[NSString stringWithFormat:@"%@",dic[@"userid"]] completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
                    
                }];
            }
        };
    }
    return _roomWheatView;
}

/////房间顶部信息：房间名字 ID

- (EMO_RoomTopView *)roomTopView{
    if (!_roomTopView) {
        _roomTopView = [[EMO_RoomTopView alloc] init];
        WeakSelf;
        _roomTopView.BtnClickBlock = ^(NSInteger index) {
            if (index==100) {
                
            }else if(index==200){
                //                //房间设置
                //                [wself.view addSubview:wself.roomSettingView];
                //                [wself.roomSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
                //                    make.top.mas_equalTo(0);
                //                    make.leading.trailing.mas_equalTo(0);
                //                    make.bottom.mas_equalTo(KAdaptedHeight(0));
                //        //            make.height.mas_equalTo(KAdaptedHeight(186));
                //                }];
                //
            }else if(index==300){
                //               //房间更多
                [wself.view addSubview:wself.roomMoreView];
                [wself.roomMoreView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(0);
                    make.leading.trailing.mas_equalTo(0);
                    make.bottom.mas_equalTo(KAdaptedHeight(0));
                    //             make.height.mas_equalTo(KAdaptedHeight(130));
                }];
                
            }
            
        };
        [self.view addSubview:_roomTopView];
        [_roomTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kSafeArea_Top);
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(KAdaptedHeight(50));
        }];
    }
    return _roomTopView;
}

- (EMO_RoomMoreView *)roomMoreView{
    if (!_roomMoreView) {
        WeakSelf;
        _roomMoreView = [[EMO_RoomMoreView alloc] init];
        _roomMoreView.BtnClick = ^(NSInteger senderTag) {
            if (senderTag==100) {//分享房间
                //                [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
                [wself showShareViewWithTitle];
            }else if (senderTag==200){
                //退出房间
                if([[MLRoomInformationModel currentAccount].uuid integerValue]==[[UserManager userInfo].user_id integerValue]){
                    [wself getQuit_roomWithParameters:1];
                }else{
                    [wself getQuit_roomWithParameters:2];
                }
                
            }else if (senderTag==300){
                //举报
                wself.reportID = [MLRoomInformationModel currentAccount].room_id;
                wself.reportType = @"1";
                [wself getReport_typeWithParameters];
            }else{
            }
        };
    }
    return _roomMoreView;
}

- (EMO_RoomSettingView *)roomSettingView{
    if (!_roomSettingView) {
        _roomSettingView = [[EMO_RoomSettingView alloc] init];
        WeakSelf;
        _roomSettingView.BtnClick = ^(NSInteger senderTag) {
            
            //            @{@"name":getLanguage(@"房间设置"),@"img":@"RSSetImg"},
            //            @{@"name":getLanguage(@"房间管理"),@"img":@"RSGuanLiImg"},
            //            @{@"name":getLanguage(@"静音"),@"img":@"UY_RoomPlay"},
            //            @{@"name":getLanguage(@"清空消息"),@"img":@"RSDelMsgImg"},
            //            @{@"name":getLanguage(@"清空魅力值"),@"img":@"RSDelMeiLiImg"},
            //            @{@"name":getLanguage(@"打赏清单"),@"img":@"RSDaShangImg"},
            //            @{@"name":getLanguage(@"操作日志"),@"img":@"RSLogImg"},
            //            @{@"name":getLanguage(@"全员禁麦"),@"img":@"RSCloseMaiImg"},
            //            @{@"name":getLanguage(@"倒计时"),@"img":@"RSCountdownImg"},]];
            
            if(senderTag==100){
                EMO_RoomSetViewController *vc=[EMO_RoomSetViewController new];
                vc.roomSetClickBlock = ^(NSMutableDictionary *setInfo) {
                    
                    [wself defaultAttbutesKey:@"Attribute_A" andValue:Attribute_Update];
                    [wself defaultAttbutesKey:Attribute_Update andValue:@"1"];//频道更新
                    
                };
                
                [wself.navigationController pushViewController:vc animated:YES];
            }else if (senderTag==101){
                
                [wself.view addSubview:wself.roomManagerView];
                
                /** 刷新*/
                [wself.roomManagerView GetData:YES andkeyword:@""];
                
                [wself.roomManagerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                    make.leading.trailing.mas_equalTo(0);
                    make.top.mas_equalTo(0);
                }];
            }else if (senderTag==102){
                /** 静音*/
                if (wself.roomSettingView.isPlay) {
                    [wself.agoraKit muteLocalAudioStream:NO];
                }else{
                    [wself.agoraKit muteLocalAudioStream:YES];
                }
            }
            else if (senderTag==103){
                [SVProgressHUD showImage:KGetImage(@"") status:@"消息已清空!"];
                ///清空消息
                NSDictionary *dict = @{@"nickName":@"",
                                       @"user_id":@"",
                                       @"message":@"",
                                       @"messageType":@"6"};
                [wself appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict]];
                AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict]];
                [wself.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
                    
                }];
                
            }else if (senderTag==104){
                ///清空魅力值
                [wself cleanMeiliMethodWithUserId:@""];
            }else if (senderTag==105){
                EMO_RewardListViewController *vc=[EMO_RewardListViewController new];
                [wself.navigationController pushViewController:vc animated:YES];
            }else if (senderTag==106){
                EMO_OperationlogViewController *vc=[EMO_OperationlogViewController new];
                [wself.navigationController pushViewController:vc animated:YES];
            }else if (senderTag==107){
                //                    "全员禁麦"
                [wself getRemove_soundWithParameters:@"" andStatus:wself.AllCloseMicrophone];
            }else if (senderTag==108){
                wself.startOrCloseTime=!wself.startOrCloseTime;
                [wself startOrCloseTimeData:1];
            }
            
            
            //            if (senderTag==100) {
            
            //
            //            }else if (senderTag==200){
            //                ///管理员
            //                RoomAdminiViewController *VC = [[RoomAdminiViewController alloc] init];
            //                VC.adminiStrClickBlock = ^(MLRoomAdminModel *adminiModel) {
            //                    AgoraRtmMessage *message;
            //                    if ([adminiModel.is_admin integerValue] == 0) {
            //                        message = [[AgoraRtmMessage alloc] initWithText:PeerMsg_AdminOff];
            //                    }else{
            //                        message = [[AgoraRtmMessage alloc] initWithText:PeerMsg_AdminOn];
            //                    }
            //                    [wself.agoraRtmKit sendMessage:message toPeer:adminiModel.uid completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
            //                    }];
            //                };
            //                [wself.navigationController pushViewController:VC animated:YES];
            //            }else if (senderTag==300){
            
            //            }else{
            //                ///清空魅力值
            //                [wself cleanMeiliMethodWithUserId:@""];
            //            }
            //
        };
    }
    return _roomSettingView;
}




///房间人员view
- (EMO_RoomHostView *)roomHostView{
    if (!_roomHostView) {
        _roomHostView = [[NSBundle mainBundle] loadNibNamed:@"EMO_RoomHostView" owner:nil options:nil].lastObject;
        _roomHostView.frame = CGRectMake(0, kSafeArea_Top+KAdaptedHeight(50)+5, self.bgView.width, 290+40+16);
    }
    return _roomHostView;
}

///底部选择
- (EMO_RoomBarrageView *)roomBarrageView{
    if (!_roomBarrageView) {
        _roomBarrageView = [[EMO_RoomBarrageView alloc] init];
        
        _roomBarrageView.frame = CGRectMake(0, self.roomHostView.bottom, self.bgView.width, self.bgView.height - self.roomHostView.bottom - [UIDevice vg_safeDistanceBottom]-5);
    }
    return _roomBarrageView;
}
//房间管理
- (EMO_RoomManagerView *)roomManagerView{
    if (!_roomManagerView) {
        _roomManagerView = [[EMO_RoomManagerView alloc] init];
        
    }
    return _roomManagerView;
}


//排行榜
- (EMO_RankingListView *)rankingListView{
    if (!_rankingListView) {
        _rankingListView = [[EMO_RankingListView alloc] init];
        
    }
    return _rankingListView;
}
///房间公告
- (EMO_RoomAnnouncementView *)roomAnnouncementView{
    if (!_roomAnnouncementView) {
        _roomAnnouncementView = [[EMO_RoomAnnouncementView alloc] init];
        
    }
    return _roomAnnouncementView;
}

- (EMO_RoomClickUserView *)roomClickUserView{
    if (!_roomClickUserView) {
        _roomClickUserView = [[NSBundle mainBundle] loadNibNamed:@"EMO_RoomClickUserView" owner:nil options:nil].lastObject;
        _roomClickUserView.frame = self.bgView.frame;
    }
    return _roomClickUserView;
}

- (MLInputBoxView *)inputBoxView{
    if (!_inputBoxView) {
        _inputBoxView = [[NSBundle mainBundle] loadNibNamed:@"MLInputBoxView" owner:nil options:nil].lastObject;
        _inputBoxView.frame = CGRectMake(0, self.bgView.height, self.bgView.width, 50);
        _inputBoxView.inputTextView.delegate = self;
    }
    return _inputBoxView;
}
- (RoomFloatingWindow *)floatingWindow{
    if (!_floatingWindow) {
        _floatingWindow = [[NSBundle mainBundle] loadNibNamed:@"RoomFloatingWindow" owner:nil options:nil].lastObject;
        _floatingWindow.frame = CGRectMake(ScreenViewWidth - 90, 400, 90, 50);
    }
    return _floatingWindow;
}


-(EMO_OnlineUserView *)onlineUserView{
    if (!_onlineUserView) {
        _onlineUserView = [[EMO_OnlineUserView alloc] initWithFrame:self.bgView.frame];
    }
    return _onlineUserView;
}

///礼物界面
- (YYF_RoomGiftView *)newRoomGiftView{
    if (!_newRoomGiftView) {
        WeakSelf;
        _newRoomGiftView = [[YYF_RoomGiftView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _newRoomGiftView.handselBUttonClickBlock = ^(NSArray *userSelectedArray, RoomGiftModel *giftModel, NSString *giftNum,NSString *currentType) {
            //            if ([giftModel.wares_type isEqualToString:@"1"]) {
            //                //1表示钻石，2表示礼物
            //                [wself getSend_baoshiWithParameters:userSelectedArray giftModel:giftModel giftNum:giftNum];
            //            }else if ([giftModel.wares_type isEqualToString:@"3"]){
            //                [wself getSend_bykiWithParameters:userSelectedArray giftModel:giftModel giftNum:giftNum];
            //            }else
            //                if ([giftModel.wares_type isEqualToString:@"2"]||[giftModel.wares_type isEqualToString:@"9"]){
            //送出礼物
            [wself getGift_queueWithParameters:userSelectedArray giftModel:giftModel giftNum:giftNum currentType:currentType];
            //            }
            //            [wself getMicrophone_statusWithParameters:2];
        };
        
        _newRoomGiftView.handselFuDaiBUttonClickBlock = ^(NSArray *userSelectedArray, RoomFuDaiModel *fuDaiModel, NSString *giftNum, NSString *currentType) {
            //送出福袋
            //            [wself getGiftFuDai_queueWithParameters:userSelectedArray giftModel:fuDaiModel giftNum:giftNum currentType:currentType];
            //            [wself getMicrophone_statusWithParameters:2];
            
        };
        
        ///赠送背包礼物
        _newRoomGiftView.senderBackPackBlock = ^(MLRoomMSequenceModel *userModel, NSArray *giftArray) {
            NSArray *allBackpack = [wself.newRoomGiftView.myArray copy];
            // 场景 2: 部分锁定分流
            if (allBackpack && giftArray.count < allBackpack.count) {
                for (NSInteger i = 0; i < giftArray.count; i++) {
                    RoomGiftModel *giftModel = giftArray[i];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [wself getGift_queueWithParameters:@[userModel] giftModel:giftModel giftNum:giftModel.num currentType:@"2"];
                    });
                }
                [SVProgressHUD showSuccessWithStatus:getLanguage(@"已送出全部未锁定礼物")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.06 * giftArray.count + 0.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [wself fetchKnapsackList];
                });
                return;
            }
            
            // 场景 3: 无锁定全量送出
            NSDictionary *dic = @{@"to_user_id":[Common isNull:userModel.uid],@"room_id":[Common isNull:[MLRoomInformationModel currentAccount].room_id]};
            [NetworkRequest POST:Request_SendBackPackGift parmeters:dic success:^(id responObject) {
                BaseModel *baseModel = (BaseModel *)responObject;
                wself.newRoomGiftView.backPackPriceLabel.text  = [NSString stringWithFormat:@"   背包总价值:0  "];
                [SVProgressHUD showSuccessWithStatus:baseModel.msg];
                wself.newRoomGiftView.myArray = [[NSMutableArray alloc] init];
                [wself.newRoomGiftView uploadType:1000];
                //发送礼物消息
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:userModel.uid forKey:@"userId"];
                [dic setValue:userModel.nickname forKey:@"nickname"];
                NSArray *userInfoArray = @[dic];
                for(RoomGiftModel *giftModel in giftArray){
                    NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithDictionary:@{@"nickName":[UserManager userInfo].nickname,
                                                                                                 @"user_id":[UserManager userInfo].user_id,
                                                                                                 @"message":@"",
                                                                                                 @"show_img":giftModel.image,
                                                                                                 @"show_gif_img":[Common isNull:giftModel.svga_file],
                                                                                                 @"type":[Common isNull:giftModel.type],
                                                                                                 @"giftNum":giftModel.num,
                                                                                                 @"gift_name":giftModel.name,
                                                                                                 @"e_name":[Common isNull:giftModel.e_name],
                                                                                                 @"userInfo":userInfoArray,
                                                                                                 @"messageType":@"4",
                                                                                                 @"giftOrFuDai":@"1",
                                                                                                 @"peerage_image":[Common isNull:[UserManager userInfo].peerage_icon],
                                                                                                 @"contribute_level":[Common isNull:[UserManager userInfo].contribute_level],
                                                                                                 @"charm_level":[Common isNull:[UserManager userInfo].charm_level],
                                                                                               }];
                    AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict1]];
                    [wself appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict1]];
                    [wself.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
                    }];
                }
            } failture:^(NSError *error) {
                
            }];
        };
        
        ///充值
        _newRoomGiftView.topUpButtonClickBlock = ^{
            //            [wself.roomCZView showView];
            CFMWalletDiamondRechargeVc *vc=[CFMWalletDiamondRechargeVc new];
            [wself.navigationController pushViewController:vc animated:YES];
        };
        
        
    }
    return _newRoomGiftView;
}
- (EMO_RoomFluctuationOfWheatView *)fluctuationOfWheatView{
    if (!_fluctuationOfWheatView) {
        _fluctuationOfWheatView = [[EMO_RoomFluctuationOfWheatView alloc] initWithFrame:self.bgView.frame];
    }
    return _fluctuationOfWheatView;
}

- (EMO_PrizeView *)prizeView{
    if (!_prizeView) {
        _prizeView = [[EMO_PrizeView alloc] initWithFrame:self.bgView.frame];
    }
    return _prizeView;
}



- (SVGAPlayer *)giftSelectedImage{
    if (!_giftSelectedImage) {
        _giftSelectedImage = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _giftSelectedImage.contentMode = UIViewContentModeScaleAspectFill;
        _giftSelectedImage.delegate = self;
        _giftSelectedImage.loops = 1;
        _giftSelectedImage.clearsAfterStop = YES;
        parser = [[SVGAParser alloc] init];
        parser.enabledMemoryCache = YES;
    }
    return _giftSelectedImage;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, self.roomBarrageView.width-KAdaptedWidth(85), self.roomBarrageView.height - 85) style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundView = nil;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor=[UIColor clearColor];
    }
    return _tableView;
}
- (NSMutableArray *)listArry{
    if (!_listArry) {
        _listArry = [NSMutableArray array];
    }
    return _listArry;
}
- (NSMutableArray *)sequenceArray{
    if (!_sequenceArray) {
        _sequenceArray = [NSMutableArray array];
    }
    return _sequenceArray;
}
- (NSMutableArray *)reportArray{
    if (!_reportArray) {
        _reportArray = [NSMutableArray array];
    }
    return _reportArray;
}
- (NSMutableArray *)soundArray{
    if (!_soundArray) {
        _soundArray = [NSMutableArray array];
    }
    return _soundArray;
}
//- (NSMutableDictionary *)dictInfo{
//    if (!_dictInfo) {
//        _dictInfo = [NSMutableDictionary dictionary];
//    }
//    return _dictInfo;
//}

//用户信息界面
- (EMO_UserInfoView *)roomUserInfoView{
    if (!_roomUserInfoView) {
        WeakSelf;
        _roomUserInfoView = [[EMO_UserInfoView alloc] init];
#pragma mark 用户信息界面点击事件
        _roomUserInfoView.personalBtnClickBlock = ^(MLRoomUserModel * _Nonnull model, NSInteger tag) {
            switch (tag) {
                case 666:{
                    //        跳转用户主页
                    EMO_PersonalDataBaseVC *VC=[EMO_PersonalDataBaseVC new];
                    VC.userID = model.userID;
                    [wself.navigationController pushViewController:VC animated:YES];
                }break;
                case 1000:{
                    //举报用户
                    wself.reportID = model.userID;
                    wself.reportType = @"2";
                    [wself getReport_typeWithParameters];
                }break;
                case 2000:{
                    //                    拷贝ID
                    [[ShareManager manager] shareCopyPaste:[Common isNull:model.userID]];
                }break;
                case 3000:{
                    //                    闭麦 开麦
                    [wself getRemove_soundWithParameters:[Common isNull:model.microphone_position_id] andStatus: [model.microphone_position_type integerValue]==1?YES:NO];
                    
                    AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[model.microphone_position_type integerValue]==0?PeerMsg_MaiOff:PeerMsg_MaiOn];
                    [wself.agoraRtmKit sendMessage:message toPeer:model.userID completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
                        
                    }];
                    
                }break;
                case 4000:{
                    //                    清空用户魅力值
                    [wself cleanMeiliMethodWithUserId:[Common isNull:model.microphone_position_id]];
                    
                }break;
                case 5000:{
                    if([model.userID integerValue]==[[MLRoomInformationModel currentAccount].uuid integerValue]){
                        [wself StopPlayData];
                    }else{
                        //                    踢出房间
                        [wself getOut_roomWithParameters:[Common isNull:model.userID]];
                    }
                    
                }break;
                case 6000:{
                    //                    上下麦
                    if ([model.zaiMaiShang isEqualToString:@"1"]) {
                        [wself getGo_microphoneWithUserID:model.microphone_position_id andType:YES andMsgData:model.userID];
                        
                    }else{
                        [wself getUp_microphoneWithParameters:nil user_id:model.microphone_position_id andData:@{@"":@""}];
                        AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:PeerMsg_MaiUp];
                        [wself.agoraRtmKit sendMessage:message toPeer:model.userID completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
                            
                        }];
                    }
                }break;
                case 7000:{
                    //                    关注和取关
                    if ([model.is_attention isEqualToString:@"1"]) {
                        [wself getCancel_followWithParameters:model.userID];
                    }else{
                        [wself getFollowWithParameters:model.userID];
                    }
                }break;
                case 8000:{
                    //                    送礼物
                    [wself getGift_listWithParameters:model];
                    
                }break;
                case 9000:{
                    //                    禁言
                    //                    UIAlertController *alert=[UIAlertController alertControllerWithTitle:getLanguage(@"") message:getLanguage(@"禁言时间") preferredStyle:UIAlertControllerStyleActionSheet];
                    //                    [alert addAction:[UIAlertAction actionWithTitle:NSStringFormat(@"5%@",getLanguage(@"分钟")) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    //                    }]];
                    [wself getIs_blackWithParameters:model.userID andType:[model.is_muted integerValue]==1?NO:YES];
                }break;
                case 10000:{
                    //                    @他人
                    NSString *str = [NSString stringWithFormat:@"%@%@",@"@",model.nickname];
                    [NetworkRequest POST:Request_CheckMessage parmeters:@{@"message":str} success:^(id responObject) {
                        if ([MLRoomInformationModel currentAccount].isBanned) {
                        }else{
                            NSDictionary *dict = @{@"nickName":[UserManager userInfo].nickname,
                                                   @"user_id":[UserManager userInfo].user_id,
                                                   @"message":str,
                                                   @"peerage_image":[Common isNull:[UserManager userInfo].peerage_icon],
                                                   @"contribute_level":[Common isNull:[UserManager userInfo].contribute_level],
                                                   @"charm_level":[Common isNull:[UserManager userInfo].charm_level],
                                                   @"messageType":@"1"};
                            AgoraRtmMessage *message = [[AgoraRtmMessage alloc] initWithText:[NSString dictionaryToJson:dict]];
                            [wself.channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
                                [SVProgressHUD showImage:KGetImage(@"") status:@"已@他"];
                            }];
                            [wself appendInfoToTableViewWithInfo:[NSString dictionaryToJson:dict]];
                        }
                    } failture:^(NSError *error) {
                        
                    }];
                }break;
                default:
                    break;
            }
            
        };
    }
    return _roomUserInfoView;
}


- (LLBarrageRenderView *)renderView{
    if (!_renderView) {
        _renderView = [[LLBarrageRenderView alloc] initWithFrame:CGRectMake(0, kSafeArea_Top+KAdaptedHeight(50)+5, kWidth, 300)];
        _renderView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
        _renderView.dataSource = self;
        [_renderView registerClass:[CustomBarrageCell class] forCellReuseIdentifier:@"cell"];
        [_renderView registerClass:[TextBarrageCell class] forCellReuseIdentifier:@"cell1"];
        _renderView.animationDuration = 5.0;
        _renderView.nextSpaceTime = 0.25;
        [self.view addSubview:_renderView];
        //        [_renderView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.mas_equalTo(self.roomTopView.mas_bottom);
        //        }];
    }
    return _renderView;
}


- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"麦位倒计时\n0";
        _timeLabel.textColor = kWhiteColor;
        _timeLabel.numberOfLines=0;
        _timeLabel.font=KFontA(11);
        _timeLabel.textAlignment=NSTextAlignmentCenter;
        _timeLabel.backgroundColor=RGBA(0, 0, 0, 0.2);
        [self.bgView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.roomTopView.mas_bottom).offset(KAdaptedHeight(60));
            make.leading.mas_equalTo(KAdaptedWidth(30));
            make.height.mas_equalTo(KAdaptedHeight(40));
            make.width.mas_equalTo(KAdaptedWidth(60));
            
        }];
        setViewCorner(_timeLabel, KAdaptedHeight(10));
    }
    return _timeLabel;
}

-(UIButton *)musicBtn
{
    if (!_musicBtn) {
        _musicBtn = [UIButton racButtonWithTitle:nil BGImage:IMAGE(@"reward_music_open") frame:CGRectMake(0, 0, 50, 50) fontSize:1 titleColor:nil];
        _musicBtn.right = SCREENWIDTH - 20 ;
        _musicBtn.bottom = SCREEN_HEIGHT_dy - 90;
        /** 0 表示没有正在播放的音乐  1正在播放音乐*/
        _musicBtn.tag = 0 ;
    }
    return _musicBtn;
}

#pragma mark 获取用户数据
- (void)getUserInfoMessage{
    WeakSelf;
    [NetworkRequest POST:Request_UserInfo parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:baseModel.data];
        if([dic.allKeys containsObject:@"avatar_frame_image"]){
            [dic setObject:@(YES) forKey:@"is_zb"];
        }else{
            [dic setObject:@(NO) forKey:@"is_zb"];
        }
        [UserManager saveUserInfo:dic];
        [wself.roomBarrageView scycleData];
        wself.newRoomGiftView.backPackPriceLabel.text = [NSString stringWithFormat:@"   背包总价值:%@   ",[Common isNullNumber:dic[@"total_gift_money"]]];
    } failture:^(NSError *error) {
        
    }];
}


/** 开启混音播放音乐*/
- (void)openMixMusicPlayHandle:(NSString *)musicUrl
{
    if (![NSString NotNull:musicUrl]) {
        return;
    }
    // 暂停或恢复播放音乐文件,先关闭上一个
    //    [self.agoraKit pauseAudioMixing];
    //    [self.agoraKit resumeAudioMixing];
    [self.agoraKit stopAudioMixing];
    
    
    // 指定本地或在线音乐文件的路径
    NSString *filePath = musicUrl;
    // 设置是否只在本地播放音乐文件。No 表示本地用户和远端用户都能听到音乐
    BOOL loopback = NO;
    // 音乐文件循环播放的次数 1 表示仅播放一次
    NSInteger cycle = 1;
    // 设置音乐文件的起始播放位置
    NSInteger startPos = 0;
    // 调用 startAudioMixing 方法播放音乐文件
    [self.agoraKit startAudioMixing:filePath loopback:loopback replace:YES cycle:cycle startPos:startPos];
    
    // 获取当前音乐文件的总时长
    //    [self.agoraKit getAudioMixingDuration];
    // 设置当前音乐文件的播放位置。500 表示从音乐文件的第 500 ms 开始播放
    [self.agoraKit setAudioMixingPosition:500];
    
    // 调节当前音乐文件在远端的播放音量
    [self.agoraKit adjustAudioMixingPublishVolume:100];
    // 调节当前音乐文件在本地的播放音量
    [self.agoraKit adjustAudioMixingPlayoutVolume: 100];
    
    /** 记录*/
    self.musicBtn.tag = 1 ;
}

// 当音乐文件播放状态发生改变时触发该回调
// 在收到 localAudioMixingStateDidChanged 回调后，声网建议调用其他音乐混音 API，如 pauseAudioMixing 或 getAudioMixingDuration
- (void)rtcEngine:(AgoraRtcEngineKit* _Nonnull)engine localAudioMixingStateDidChanged:(AgoraAudioMixingStateCode)state reason:(AgoraAudioMixingReasonCode)reason
{
    DLog(@"背景音乐状态改变了，原因：%ld",reason);
}

/** 关闭推流的 混合音乐背景*/
- (void)stopMixAudioBgm
{
    /** 关闭音乐*/
    [self.agoraKit stopAudioMixing];
    /** 记录*/
    self.musicBtn.tag = 0 ;
}

/** 主播进去 或者 离开房间
 1 进入房间 2 退出房间
 */
- (void)anchorLeaveOrJoinRoom:(int)type success:(void (^)(void))success
{
    /** para*/
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    parameter[@"room_id"] = [MLRoomInformationModel currentAccount].room_id;
    /** type
     string
     可选
     类型 1 进入房间 2 退出房间*/
    parameter[@"type"] = FORMAT_TYPE(@"%d", type);
    [NetworkRequest POST:room_inRoom parmeters:parameter success:^(id responObject) {
        if (success) {
            success();
        }
    } failture:^(NSError *error) {
        
    }];
    
    
    /** 发送全局通知消息*/
    /** para*/
    NSMutableDictionary *paraChannel =[NSMutableDictionary dictionary];
    paraChannel[@"messageType"] = @"100";
    paraChannel[@"msgType"] = FORMAT_TYPE(@"%d", type);
    NSString *jsonStr = [NSString dictionaryToJson:paraChannel];
    AgoraRtmMessage *allMessage = [[AgoraRtmMessage alloc] initWithText:jsonStr];
    [self appendInfoToTableViewWithInfo:[NSString dictionaryToJson:parameter.mutableCopy]];
    [self.allChannel sendMessage:allMessage completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
        
    }];
}
@end
