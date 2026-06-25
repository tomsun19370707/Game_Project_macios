//
//  EMO_MyGuildXQViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/6/29.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_MyGuildXQViewController.h"
#import "EMO_MyGuildXQHeadView.h"
#import "EMO_HomeTableViewCell.h"
#import "EMO_FamilyAnchorListCell.h"
#import "EMO_MyGuildXQFootView.h"
#import <WXApi.h>
#import "EMO_APPCustomMessage.h"
#import "EMO_ShareFirendListViewController.h"
#import "MLSessionViewController.h"
@interface EMO_MyGuildXQViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) EMO_MyGuildXQHeadView *headView;
@property (nonatomic, strong) EMO_MyGuildXQFootView *footView;
@property (nonatomic, assign) NSInteger mainPage;
@property (nonatomic, strong) NSMutableDictionary *dicData;
@end

@implementation EMO_MyGuildXQViewController

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableDictionary *)dicData{
    if(!_dicData){
        _dicData=[NSMutableDictionary dictionary];
    }
    return _dicData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(255, 255, 255, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.barView.backgroundColor=kClearColor;
    self.titleLabel.text=getLanguage(@"家族详情");
    self.titleLabel.font=KFont(18);
    [self.rightButton setImage:KGetImage(@"familyShareImg") forState:UIControlStateNormal];
    self.rightButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    
//    [self setUpMainTableRefresh];
    [self headView];
    [self footView];
    [self tableView];
    
    [self backBtn];
    [self getData:YES];
    [self.view insertSubview:self.barView aboveSubview:self.headView];
    
    
    
    
    
}
-(void)rightButtonClick:(UIButton *)sender{
    [self showShareViewWithTitle];

}

- (EMO_MyGuildXQHeadView *)headView{
    if (!_headView) {
        _headView = [[EMO_MyGuildXQHeadView alloc] init];
        _headView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(KAdaptedHeight(200));
        }];
    }
    return _headView;
}


- (EMO_MyGuildXQFootView *)footView{
    if (!_footView) {
        _footView = [[EMO_MyGuildXQFootView alloc] init];
        _footView.layer.shadowColor = RGBA(167, 167, 167, 0.09).CGColor;
        _footView.layer.shadowOffset = CGSizeMake(0,-3);
        _footView.layer.shadowOpacity = 1;
        _footView.layer.shadowRadius = 4;
        WeakSelf;
        _footView.BtnBlock = ^(NSInteger tag) {
            if(tag==100){
                [wself qianYueData:1];
            }else if (tag==200){
                MLSessionViewController *VC = [[MLSessionViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:[Common isNull:wself.dicData[@"uid"]]];
                    VC.title = wself.dicData[@"name"];
                [wself.navigationController pushViewController:VC animated:YES];
                
            }else{
                [wself qianYueData:0];
            }
        };
        [self.view addSubview:_footView];
        [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(KAdaptedHeight(50)+KSAFEAREA_BOTTOM_HEIHGHT);
        }];
    }
    return _footView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor =  kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor=[UIColor clearColor];
        _tableView.rowHeight=KAdaptedHeight(90);
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headView.mas_bottom);
            make.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(self.footView.mas_top);
        }];
    }
    return _tableView;
}



#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return 1;
    }else{
        return self.dataArr.count;
    }
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(KAdaptedWidth(15), 0, kWidth-KAdaptedWidth(30), KAdaptedHeight(30))];
    if(section==0){
        label.text=getLanguage(@"主播列表");
    }else{
        label.text=getLanguage(@"开播房间");
    }
    label.textColor=RGBA(0, 0, 0, 1);
    label.font=KFontA(16);
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section==0){
        EMO_FamilyAnchorListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        if (!cell) {
            cell=[[EMO_FamilyAnchorListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell1"];
        }
        cell.selectionStyle=0;
        cell.ListArr=[NSMutableArray arrayWithArray:self.dicData[@"family_user_arr"]];
        return cell;
    }else{
        EMO_HomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell=[[EMO_HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        }
        cell.selectionStyle=0;
        cell.dicData = self.dataArr[indexPath.row];
        return cell;
    }
    
}


#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    EMO_MyGuildXQViewController *vc=[EMO_MyGuildXQViewController new];
    vc.guildID=self.dataArr[indexPath.row][@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


#pragma mark - setUpMainTableRefresh
- (void)setUpMainTableRefresh
{
    WeakSelf;
    [ZJUIUtil refreshWithHeader:self.tableView refresh:^{
        wself.mainPage = 1;
        [wself getData:YES];
    }];
    
    
    [ZJUIUtil refreshWithFooter:self.tableView refresh:^(){
        wself.mainPage ++;
        [wself getData:NO];
    }];
}


-(void)getData:(BOOL)isRefresh{

    
    /**
     is_in_family;//表示当前查询的这个家族中状态 //-1代表什么家族都没0=审核中,1=审核通过,2=申请驳回
     is_patriarch是否族长
     is_in_other_family;//在其他家族中的状态//0=审核中,1=审核通过,2=申请驳回
     is_exit_family;//退出申请 -1为未申请,0=审核中,1=审核通过,2=申请驳回
     */
   
    [NetworkRequest POST:Request_MyFamily parmeters:@{@"family_id":self.guildID} success:^(id responObject) {
        BaseModel *model=(BaseModel *)responObject;
        [self.dicData addEntriesFromDictionary:model.data];
        if (isRefresh) {
            [self.dataArr removeAllObjects];
        }
        [self.dataArr addObjectsFromArray:model.data[@"chat_room_list"]];
        self.headView.dicData=self.dicData;
        
        if([self.dicData[@"is_patriarch"] integerValue]==1){
            self.footView.status=4;
            [self.footView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(KSAFEAREA_BOTTOM_HEIHGHT);
            }];
        }else{
            if([self.dicData[@"is_in_family"] integerValue]==-1){
                self.footView.status=1;
            }else{
                if([self.dicData.allKeys containsObject:@"is_in_other_family"]){
                    if([self.dicData[@"is_in_other_family"] integerValue]==1){
                        self.footView.status=4;
                        [self.footView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.mas_equalTo(KSAFEAREA_BOTTOM_HEIHGHT);
                        }];
                    }else {
                        self.footView.status=1;
                    }
                }else if ([self.dicData[@"is_in_family"] integerValue]==0){
                    self.footView.status=2;
                }else if ([self.dicData[@"is_in_family"] integerValue]==1){
                    self.footView.status=3;
                }else if ([self.dicData[@"is_in_family"] integerValue]==2){
                    self.footView.status=1;
                }
            }
        }
        
       
        
        [self.tableView reloadData];
        
    } failture:^(NSError *error) {
        
    }];
    
    
}


-(void)qianYueData:(NSInteger)type{

    
    [NetworkRequest POST:Request_ApplyFamily parmeters:@{@"family_id":self.guildID,@"type":@(type)} success:^(id responObject) {
        BaseModel *model=(BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:model.msg]];
        [self getData:YES];
        
    } failture:^(NSError *error) {
        
    }];
    
    
    
    
    
}









#pragma mark 带标题的分享弹窗
- (void)showShareViewWithTitle{
    WeakSelf;
//
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
            vc.type=1;
            vc.dicData=self.dicData;
            [self.navigationController pushViewController:vc animated:YES];
        
        }
        
    };
}



- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
        if (![[UMSocialManager defaultManager] isInstall:platformType]) {
            [SVProgressHUD showErrorWithStatus:@"未安装此应用"];
            return;
        }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.dicData[@"name"] descr:[NSString stringWithFormat:@"ID:%@",self.dicData[@"id"]] thumImage:self.dicData[@"image"]];
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
    urlMessage.title = @"EMO";//分享标题
//    urlMessage.description = @"EMO情绪管理处";//分享描述
    urlMessage.description = @"您的情绪管理大师";//分享描述
    [urlMessage setThumbImage:[UIImage imageNamed:@"logo1024"]];
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






@end
