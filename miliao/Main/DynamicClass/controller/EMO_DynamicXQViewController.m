//
//  EMO_DynamicXQViewController.m
//  MeetHer
//
//  Created by 张世浩 on 2023/2/16.
//

#import "EMO_DynamicXQViewController.h"
#import "EMO_WMTimeLineHeaderView.h"
#import "WMPhotoBrowser.h"
#import "WTBottomInputView.h"
#import "EMO_CommentXQTableCell.h"

#import "UIImageView+ZFCache.h"
#import "ZFUtilities.h"
#import "EMO_CommentMoreVC.h"//更多评论
#import "EMO_CommentBottomView.h"

#import "EMO_CommentHeadView.h"//评论
#import "EMO_CommentTableViewCell.h"
#import "EMO_PersonalDataBaseVC.h"
#import "BWShareView.h"
@interface EMO_DynamicXQViewController ()<UITableViewDelegate,UITableViewDataSource,WTBottomInputViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableDictionary *dicData;
@property(strong,nonatomic) WTBottomInputView *bottomView;//inputView
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, assign) NSInteger selecttype;
@property (nonatomic, strong) NSMutableDictionary *selectDic;

@property(nonatomic,strong)EMO_CommentBottomView *commentView;

Strong EMO_WMTimeLineHeaderView *headView;
Strong NSMutableArray *reportArr;

Strong UIButton *followBtn;
Strong UIButton *moreBtn;

Assign NSInteger page;

@end

@implementation EMO_DynamicXQViewController
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
-(NSMutableDictionary *)dicData{
    if (!_dicData) {
        _dicData=[NSMutableDictionary dictionary];
    }
    return _dicData;
}
-(NSMutableArray *)reportArr{
    if (!_reportArr) {
        _reportArr = [[NSMutableArray alloc] init];
    }
    return _reportArr;
}
-(NSMutableDictionary *)selectDic{
    if (!_selectDic) {
        _selectDic=[NSMutableDictionary dictionary];
    }
    return _selectDic;
}

-(void)getTestData{
    
    WeakSelf;
    [NetworkRequest POST:Request_GetDynamicXQ parmeters:@{@"dynamic_id":self.model.message_id} success:^(id responObject) {
        NSLog(@"%@",responObject);
        BaseModel *baseModel = (BaseModel *)responObject;
        self.dicData=baseModel.data;
        [wself.tableView reloadData];
        [wself.tableView.mj_header endRefreshing];

    } failture:^(NSError *error) {
        NSLog(@"%@",error);
        [wself.tableView.mj_header endRefreshing];

    }];
    
    [NetworkRequest POST:Request_GetReportReason parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        self.reportArr=[NSMutableArray arrayWithArray:baseModel.data];
        
    } failture:^(NSError *error) {
        
    }];
    
    
  
}

-(void)commentData:(BOOL)type{
    
    WeakSelf;
    [SVProgressHUD show];
    [NetworkRequest POST:Request_DynamicCommnetList parmeters:@{@"dynamic_id":self.model.message_id,@"page":@(self.page),@"size":@(PageSize)} success:^(id responObject) {
        NSLog(@"%@",responObject);
        [SVProgressHUD dismiss];
        BaseModel *baseModel = (BaseModel *)responObject;
        if(type){
            [self.dataSource removeAllObjects];
            self.dataSource=nil;
        }
        [self.dataSource addObjectsFromArray:baseModel.data[@"list"]];
        
        [wself.tableView reloadData];
        [wself.tableView.mj_header endRefreshing];
        [wself.tableView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        [wself.tableView.mj_header endRefreshing];
        [wself.tableView.mj_footer endRefreshing];

    }];
    
    
    
}

-(void)report:(NSInteger)type{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    for (NSDictionary *dic in self.reportArr) {
        [alert addAction:[UIAlertAction actionWithTitle:[Common isNull:dic[@"reason"]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            for (NSDictionary *dic in self.reportArr) {
                if([dic[@"reason"] isEqualToString:action.title]){
                    if(type==2){
                        [self report:dic andReasonId:dic[@"id"]];
                    }else{
                        [self dynamic:dic[@"id"]];
                    }
                    
                    break;;
                }
            }
        }]];
    }
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)dynamic:(NSString *)reportID{
    //type类型:0=动态,1=房间,2=会员，3=评论
    [NetworkRequest POST:Request_AddReport parmeters:@{@"reason_id":reportID,@"type":@"0",@"dynamic_id":self.model.message_id} success:^(id responObject) {
            BaseModel *baseModel = (BaseModel *)responObject;
            [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
            
        } failture:^(NSError *error) {
            
        }];
}


-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.bottomView resignFirstResponder];
    [self commentData:YES];
}


-(void)rightButtonClick:(UIButton *)sender{
    WeakSelf;
    
    if(sender.tag==1000){
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self report:1];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }else{
        [NetworkRequest POST:Request_GetfollowOrBlack parmeters:@{@"type":@"0",@"to_uid":self.model.uid} success:^(id responObject) {
            BaseModel *basemodel=(BaseModel *)responObject;
            [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:basemodel.msg]];
            wself.model.is_attention=!wself.model.is_attention;
            /** 关注按钮的 样式*/
            [wself focusBtnState];

        } failture:^(NSError *error) {

        }];
    }
    
    
    
    
}


- (UIButton *)followBtn{
    if (!_followBtn) {
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        /** 关注按钮的 样式*/
        [self focusBtnState];
        [self.barView addSubview:_followBtn];
        [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-45));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(70), KAdaptedHeight(25)));
            make.bottom.mas_equalTo(self.barView.mas_bottom).offset(KAdaptedHeight(-9));
        }];
        setViewCorner(_followBtn, KAdaptedHeight(25)/2);
        [_followBtn addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followBtn;
}

/** 关注按钮的 样式*/
- (void)focusBtnState
{
    self.followBtn.frame = CGRectMake(0, 0, 66, 21);
    self.followBtn.titleLabel.font = PingFangFONT(11);
    [self.followBtn makeRoundCornerAndLayerColor:BaseMainColor];
    if (self.model.is_attention) {
        self.followBtn.backgroundColor = UIColor.whiteColor ;
        self.followBtn.layer.borderColor = LineColor.CGColor ;
        [self.followBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.followBtn setTitleColor:HexColorDy(@"666666") forState:UIControlStateNormal];
    }else{
        self.followBtn.backgroundColor = BaseMainColor ;
        self.followBtn.layer.borderColor = BaseMainColor.CGColor ;
        [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.followBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:KGetImage(@"dynamicMoreImg") forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.tag=1000;
        [self.barView addSubview:_moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(25), KAdaptedHeight(25)));
            make.bottom.mas_equalTo(self.barView.mas_bottom).offset(KAdaptedHeight(-9));
        }];
    }
    return _followBtn;
}







- (void)setUpMainTableRefresh
{
//    WeakSelf;
//    [ZJUIUtil refreshWithHeader:self.tableView refresh:^{
//        wself.page = 1;
//        [wself commentData:YES];
//    }];
//    
//    
//    [ZJUIUtil refreshWithFooter:self.tableView refresh:^(){
//        wself.page ++;
//        [wself commentData:NO];
//    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(248, 248, 248, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.leftButtonView.image = ImageNamed(@"xiaoxi_back");
    self.titleLabel.text = @"动态详情";
    [self followBtn];
    [self moreBtn];
    
    if([self.model.uid integerValue]==[[UserManager userInfo].user_id integerValue]){
        self.followBtn.hidden=YES;
        self.moreBtn.hidden=YES;
    }
    
    [self setUpMainTableRefresh];
    self.page=0;
    self.selecttype=0;
    [self getTestData];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//           make.edges.mas_equalTo(0);
        make.top.mas_equalTo(ZJTopNavH+ZJStatusBarH);
        make.leading.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(-TabBar_H);
       }];
    
    self.bottomView = [[WTBottomInputView alloc]init];
     self.bottomView.delegate = self;
    [self.view addSubview:self.bottomView];
    
    
    /// playerManager
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
//    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
    
    /// player,tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:8888];
    self.player.controlView = self.controlView;
    /// 1.0是消失100%时候
    self.player.playerDisapperaPercent = 0.8;
    /// 播放器view露出一半时候开始播放
    self.player.playerApperaPercent = .5;
    
    self.player.shouldAutoPlay=NO;
    //@zf_weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        //@zf_strongify(self)
        [self.player stopCurrentPlayingCell];
    };
    
    /// 停止的时候找出最合适的播放(只能找到设置了tag值cell)
    self.player.zf_scrollViewDidEndScrollingCallback = ^(NSIndexPath * _Nonnull indexPath) {
        //@zf_strongify(self)
        if (!self.player.playingIndexPath) {
            [self playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
        }
    };

     
    /// 滑动中找到适合的就自动播放
    /// 如果是停止后再寻找播放可以忽略这个回调
    /// 如果在滑动中就要寻找到播放的indexPath，并且开始播放，那就要这样写
    self.player.zf_playerShouldPlayInScrollView = ^(NSIndexPath * _Nonnull indexPath) {
//        //@zf_strongify(self)
        if ([indexPath compare:self.player.playingIndexPath] != NSOrderedSame) {
            [self playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
        }
    };
      
    
    /** 底部的评论区域*/
    [self bottomCommentArea];
}

#pragma mark - private method

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollAnimated:(BOOL)animated {
//    NSInteger index = (indexPath.row-1)/2;
//    ZFTableViewCellLayout *layout = self.dataSource[index];
    if (animated) {
        [self.player playTheIndexPath:indexPath assetURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",VERSION_HTTPS_SERVER,self.dicData[@"imgs"][0]]] scrollPosition:ZFPlayerScrollViewScrollPositionTop animated:YES];
    } else {
        [self.player playTheIndexPath:indexPath assetURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",VERSION_HTTPS_SERVER,self.dicData[@"imgs"][0]]]];
    }
//https://media.w3.org/2010/05/sintel/trailer.mp4
    [self.controlView showTitle:@"视频"
                 coverURLString:[NSString stringWithFormat:@"%@%@",VERSION_HTTPS_SERVER,self.dicData[@"imgs"][0]]
                 fullScreenMode:ZFFullScreenModePortrait];
}
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
    }
    return _controlView;
}


- (EMO_WMTimeLineHeaderView *)headView{
    if (!_headView) {
        _headView = [[EMO_WMTimeLineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWidth, self.model.headerHeight+KAdaptedHeight(100))];
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.model=self.model;
        WeakSelf;
        _headView.headImgClickBlock = ^{
            EMO_PersonalDataBaseVC *vc=[EMO_PersonalDataBaseVC new];
            vc.userID=[NSString stringWithFormat:@"%@",wself.model.uid];
            [wself.navigationController pushViewController:vc animated:YES];
        };
        _headView.tapImageBlock = ^(NSInteger index, NSArray *dataSource) {
            WMPhotoBrowser *browser = [WMPhotoBrowser new];
            browser.dataSource = dataSource.mutableCopy;
            browser.currentPhotoIndex = index;
            [wself.navigationController pushViewController:browser animated:YES];
            
        };
    
    }
    return _headView;
}


-(UITableView *)tableView{
    if (_tableView==nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ZJTopNavH, kWidth, kScreenHeight-ZJTopNavH) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView=self.headView;

    }
    return _tableView;
}
-(void)textViewDidSendText:(NSString *)text{
    NSLog(@"%@",text);
}
/**
 键盘的frame改变
 */
- (void)keyboardChangeFrameMinY:(CGFloat)minY{
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
//    return self.dataSource.count;
}
//显示评论的数据
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

//    return self.dataSource.count;
//    NSArray *arr=self.dataSource[section][@"children"];
//    if(arr.count>0){
//        if(arr.count>2){
//            return 2;
//        }
//        return arr.count;
//    }else{
//        return 0;
//    }
    
    
    /** 评论不再显示*/
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    NSDictionary *dic=self.dataSource[section];
    CGSize cellSizeH = [NSStringFormat(@"%@",dic[@"comment"]) sizeWithFont:KFontA(14) With:ScreenViewWidth - KAdaptedWidth(40)];
    return cellSizeH.height+KAdaptedHeight(90);
 
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    __weak __typeof(self) weakSelf= self;
    NSDictionary *dic=self.dataSource[section];
    CGSize cellSizeH = [NSStringFormat(@"%@",dic[@"comment"]) sizeWithFont:KFontA(14) With:kWidth - KAdaptedWidth(40)];
    EMO_CommentHeadView *headerView=[[EMO_CommentHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, cellSizeH.height+KAdaptedHeight(90))];
    headerView.dicData=[NSMutableDictionary dictionaryWithDictionary:dic];
    headerView.BtnClick = ^(NSMutableDictionary * _Nonnull dic, NSInteger tag) {
        if(tag==100){
            [weakSelf report:2];
        }else if(tag==200){
            [weakSelf likeData:dic andIndex:section];
            
        }else if(tag==300){
            weakSelf.selecttype=2;
            weakSelf.selectDic=dic;
            [weakSelf.bottomView.textView becomeFirstResponder];
            
//            EMO_CommentMoreVC *vc=[EMO_CommentMoreVC new];
//            vc.model=weakSelf.model;
//            vc.reportArr=weakSelf.reportArr;
//            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
    };
    return headerView;
    

}
///footer高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSArray *arr=self.dataSource[section][@"children"];
        if(arr.count>2){
            return KAdaptedHeight(30);
        }
    return CGFLOAT_MIN;
}
///footerView
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSArray *arr=self.dataSource[section][@"children"];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30.f)];
    if(arr.count>2){
        UIView *bgVIew=[[UIView alloc] init];
        bgVIew.backgroundColor=RGBA(248, 248, 248, 1);
        [footerView addSubview:bgVIew];
        [bgVIew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(KAdaptedHeight(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.leading.mas_equalTo(KAdaptedWidth(63));
        }];
        setViewCorner(bgVIew, KAdaptedHeight(5));
        UIButton *moreBtn=[[UIButton alloc] init];
        [moreBtn setTitle:getLanguage(@"查看更多回复消息") forState:UIControlStateNormal];
        [moreBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        [moreBtn setImage:KGetImage(@"DownImg") forState:UIControlStateNormal];
        moreBtn.titleLabel.font=KFontA(12);
        [moreBtn addTarget:self action:@selector(MoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        moreBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [bgVIew addSubview:moreBtn];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(KAdaptedHeight(0));
            make.trailing.mas_equalTo(KAdaptedWidth(-0));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            
        }];
        [moreBtn setImagePositionWithType:SSImagePositionTypeRight spacing:5];
        
    }
    
    
    return footerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr=self.dataSource[indexPath.section][@"children"];
    if(arr.count>0){
        NSDictionary *dic=arr[indexPath.row];
        NSString *contentStr=[NSString string];
        if([dic.allKeys containsObject:@"to_comment_user_id"]){
            contentStr=[NSString stringWithFormat:@"%@回复%@:%@",dic[@"nickname"],dic[@"to_comment_user_nickname"],dic[@"comment"]];
        }else{
            contentStr=[NSString stringWithFormat:@"%@:%@",dic[@"nickname"],dic[@"comment"]];
        }
        return [contentStr boundingRectWithSize:CGSizeMake(kWidth-KAdaptedWidth(80+30), CGFLOAT_MAX) font:KFontA(14) lineSpacing:2.0].height+KAdaptedHeight(20);
    }else{
        return 0;
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EMO_CommentTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[EMO_CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    NSArray *arr=self.dataSource[indexPath.section][@"children"];
    if(arr.count>0){
        cell.dicData=arr[indexPath.row];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
////    如果是动态是自己的,才能进行二级评论
//    if([self.dicData[@"user_id"] integerValue]==[UserDefaultsGet(kUserID) integerValue]){
    self.selecttype=3;
    NSArray *arr=self.dataSource[indexPath.section][@"children"];
    self.selectDic=[NSMutableDictionary dictionaryWithDictionary:arr[indexPath.row]];
    [self.selectDic setObject:[Common isNull:self.dataSource[indexPath.section][@"id"]] forKey:@"commentOneId"];
    
        [self.bottomView.textView becomeFirstResponder];
//    }

    
    
//    EMO_CommentMoreVC *vc=[EMO_CommentMoreVC new];
//    vc.model=self.model;
//    vc.reportArr=self.reportArr;
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}


-(void)MoreBtnClick{
    
    EMO_CommentMoreVC *vc=[EMO_CommentMoreVC new];
    vc.model=self.model;
    vc.reportArr=self.reportArr;
    [self.navigationController pushViewController:vc animated:YES];
    
}



- (void)WTBottomInputViewSendTextMessage:(NSString *)message{
    if ([message isEqualToString:@"轻轻敲醒沉睡的心灵，让我看看你的点评~"]||[message isEqualToString:@""]) {
        return;
    }
    [self sendMessage:message];
}

#pragma mark 评论
-(void)sendMessage:(NSString *)text{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    
    [dic setObject:text forKey:@"comment"];
    [dic setObject:self.model.message_id forKey:@"dynamic_id"];
    
    if (self.selecttype==2) {
        [dic setObject:self.selectDic[@"id"] forKey:@"comment_id"];
        [dic setObject:self.selectDic[@"id"] forKey:@"first_comment_id"];
    }else  if(self.selecttype==3){
        [dic setObject:self.selectDic[@"id"] forKey:@"comment_id"];
        [dic setObject:self.selectDic[@"commentOneId"] forKey:@"first_comment_id"];
    }
    
    self.selecttype=0;
    
    [NetworkRequest POST:Request_CheckMessage parmeters:@{@"message":text} success:^(id responObject) {
        [self sendCommentData:dic];
    } failture:^(NSError *error) {

    }];

    
}


-(void)sendCommentData:(NSDictionary *)dic{
    
    [NetworkRequest POST:Request_AddComment parmeters:dic success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        NSLog(@"%@",baseModel.data);
        self.page=1;
        [self commentData:YES];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpDataDynamic" object:nil userInfo:nil]];
    } failture:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}




-(void)likeData:(NSMutableDictionary *)dic andIndex:(NSInteger)index{
    
    [NetworkRequest POST:Request_LikeOrFollow parmeters:@{@"dynamic_id":self.model.message_id,@"comment_id":dic[@"id"],@"type":@"0"} success:^(id responObject) {
        [self commentData:YES];
        
    } failture:^(NSError *error) {
        
    }];
    
    
    
    
}


-(void)report:(NSDictionary *)dic andReasonId:(NSString *)reportID{
//type类型:0=动态,1=房间,2=会员，3=评论
    [NetworkRequest POST:Request_AddReport parmeters:@{@"reason_id":reportID,@"comment_id":dic[@"id"],@"type":@"3"} success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
        
    } failture:^(NSError *error) {
        
    }];
    
    
}





- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


-(void)dealComment{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%s",__FUNCTION__);
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__FUNCTION__);
}


    
    
/** 底部的评论区域*/
- (void)bottomCommentArea
{
    self.commentView=[[EMO_CommentBottomView alloc] init];
    [self.commentView.likeBtn addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.commentView.commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.commentView.collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.commentView.reportBtn.hidden = YES ;
    self.commentView.model = self.model ;
    self.commentView.frame = CGRectMake(0, 0, SCREENWIDTH, 50);
    self.commentView.bottom = SCREEN_HEIGHT_dy ;
    self.commentView.backgroundColor = UIColor.whiteColor ;
    self.commentView.showReport = NO ;
    
    [self.view addSubview:self.commentView];
}

/** 喜欢*/
- (void)likeBtnClick
{
    WeakSelf
    [NetworkRequest POST:Request_LikeOrFollow parmeters:@{@"dynamic_id":self.model.message_id,@"type":@"0"} success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        NSLog(@"%@",baseModel.data);
        
        wself.model.is_like = !wself.model.is_like;

        if (wself.model.is_like) {
            wself.model.like_num ++;
        }else{
            wself.model.like_num=wself.model.like_num-1<0?0:wself.model.like_num-1;
        }
        /** 重新赋值*/
        wself.commentView.model = wself.model ;
        
    } failture:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

/** 分享*/
-(void)commentBtnClick
{
    WeakSelf;
// [[BWItemModel alloc] initWithImg:@"shareFriendImg" text:getLanguage(@"emo好友")]
    BWShareView *shareView = [[BWShareView alloc] initWithFrame:[ObjectTool SharedSettings].currentVC.view.bounds shareTitle:getLanguage(@"分享至") shareArray:[NSMutableArray arrayWithObjects:[[BWItemModel alloc] initWithImg:@"wechatImg" text:getLanguage(@"微信好友")],[[BWItemModel alloc] initWithImg:@"pengyouquanImg" text:getLanguage(@"朋友圈")], nil]];
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
            
//            EMO_ShareFirendListViewController *vc=[EMO_ShareFirendListViewController new];
//            vc.type=1;
//            vc.dicData=self.dicData;
//            [self.navigationController pushViewController:vc animated:YES];
        
        }
        
    };
}

/** 收藏*/
- (void)collectBtnClick
{
    WeakSelf
    [NetworkRequest POST:Request_LikeOrFollow parmeters:@{@"dynamic_id":self.model.message_id,@"type":@"1"} success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        NSLog(@"%@",baseModel.data);
        
        wself.model.is_collect = !wself.model.is_collect;
        if (wself.model.is_collect) {
            wself.model.collect_num ++;
        }else{
            wself.model.collect_num=wself.model.collect_num-1<0?0:wself.model.collect_num-1;
        }
        /** 重新赋值*/
        wself.commentView.model = wself.model ;
        
    } failture:^(NSError *error) {
        NSLog(@"%@",error);
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
@end
