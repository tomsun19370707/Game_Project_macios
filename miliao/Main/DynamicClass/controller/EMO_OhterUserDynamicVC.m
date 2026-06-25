//
//  EMO_OhterUserDynamicVC.m
//  MeetHer
//
//  Created by 张世浩 on 2023/3/25.
//

#import "EMO_OhterUserDynamicVC.h"
#import "EMO_DynamicXQViewController.h"
#import "ZFTableViewCell.h"
#import "ZFTableData.h"
#import "ZFOtherCell.h"
#import "WMPhotoBrowser.h"
#import "YJT_NODataView.h"
#import "EMO_PersonalDataBaseVC.h"
#import "EMO_EditDynamicVC.h"
static NSString *kIdentifier = @"kIdentifier";
static NSString *kDouYinIdentifier = @"douYinIdentifier";

@interface EMO_OhterUserDynamicVC ()<UITableViewDelegate,UITableViewDataSource,ZFTableViewCellDelegate,WTBottomInputViewDelegate,UITextViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) NSMutableArray *dataSource;
//@property(strong,nonatomic) WTBottomInputView *bottomView;//inputView
Assign NSInteger page;
Strong ZFTableViewCellLayout *layoutModel;
Strong MessageInfoModel *otherModel;
Assign NSInteger selectCellType;
@property (nonatomic, strong) YJT_NODataView *noDataView;


@end

@implementation EMO_OhterUserDynamicVC

-(YJT_NODataView *)noDataView{
    if(!_noDataView){
        _noDataView=[[YJT_NODataView alloc] init];
        _noDataView.dicData=@{@"img":@"NODataBgImg",@"tip":@"暂无更多数据"};
        [self.view addSubview:_noDataView];
        [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.centerX.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kWidth, KAdaptedHeight(150)));
            
        }];
    }
    return _noDataView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource=[NSMutableArray array];
    }
    return _dataSource;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBar:YES needBack:YES needBackground:YES];
    if(self.HidenBack==NO){
        self.leftButtonView.image = KGetImage(@"xiaoxi_back");
        if(self.type==1){
            self.titleLabel.text = @"我的收藏";
        }else if(self.type==2){
            self.titleLabel.text = @"我的动态";
        }else if(self.type==3){
            self.titleLabel.text = @"他的动态";
        }
    }else{
        self.leftButtonView.hidden=YES;
    }
  
    
    self.view.backgroundColor =kWhiteColor;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationConfession) name:@"UpDataDynamic" object:nil];
    self.page=0;
    [self addPullRefreshView];

    [self.view addSubview:self.tableView];

    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];

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
        //@zf_strongify(self)
        if ([indexPath compare:self.player.playingIndexPath] != NSOrderedSame) {
            [self playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
        }
    };
    
//    self.bottomView = [[WTBottomInputView alloc]init];
//     self.bottomView.delegate = self;
//    [self.view addSubview:self.bottomView];
     
    [self noDataView];
    self.noDataView.hidden=YES;
    
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if(self.HidenBack){
        self.tableView.frame = CGRectMake(KAdaptedWidth(14), 0, kWidth-KAdaptedWidth(14)*2, kHeight-ZJTopNavH-ZJStatusBarH);
    }else{
        self.tableView.frame = CGRectMake(KAdaptedWidth(14), ZJTopNavH+ZJStatusBarH, kWidth-KAdaptedWidth(14)*2, kHeight-ZJTopNavH-ZJStatusBarH);
    }
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //@zf_weakify(self)
    [self.player zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        //@zf_strongify(self)
        [self playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
    }];
}


-(void)InfoNotificationConfession{
    [self loadNewData];
}
//增加下拉刷新控件
- (void)addPullRefreshView {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [header beginRefreshing];
    self.page=1;
    self.tableView.mj_header = header;
}
- (void)loadNewData{
    self.page=1;
    [self reuqestList:1];
}
- (void)addFootViewRefreshView
{
    WeakSelf;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        wself.page++;
        [wself reuqestList:2];
    }];
    
    [footer setTitle:getLanguage(@"暂无更多数据") forState:MJRefreshStateNoMoreData];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    footer.stateLabel.font = [UIFont systemFontOfSize:10];
    footer.triggerAutomaticallyRefreshPercent = 0.5;
    footer.stateLabel.textColor = [UIColor colorWithHexString:@"0xa2a9a9"];
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer = footer;
}
-(void)reuqestList:(NSInteger)type{
    WeakSelf;
    NSDictionary *dic=[NSDictionary dictionary];
    if(self.type==3){
        dic=@{@"page":@(wself.page),@"type":@"3",@"to_uid":self.userID};
    }else {
        dic=@{@"page":@(wself.page),@"type":@(self.type)};
    }
    
    [NetworkRequest POST:Request_GetDynamicList parmeters:dic success:^(id responObject) {
        NSLog(@"%@",responObject);
        BaseModel *baseModel = (BaseModel *)responObject;
        if (type==1) {
            [wself.dataSource removeAllObjects];
            wself.dataSource=nil;
//            [wself.dataSourceAAA removeAllObjects];
//            wself.dataSourceAAA=nil;
        }
        NSArray *arr=baseModel.data;
        if(arr.count<1){
            [SVProgressHUD showInfoWithStatus:getLanguage(@"暂无更多数据")];
        }
        for (NSDictionary *eachDic in arr) {
//            if ([eachDic[@"type"] integerValue]==2) {
//                ZFTableData *data = [[ZFTableData alloc] init];
//                [data setValuesForKeysWithDictionary:eachDic];
//                ZFTableViewCellLayout *layout = [[ZFTableViewCellLayout alloc] initWithData:data];
//                [self.dataSource addObject:layout];
//            }else{
                MessageInfoModel *messageModel = [[MessageInfoModel alloc] initWithDic:eachDic];
                [wself.dataSource addObject:messageModel];
//            }
//            [self.dataSourceAAA addObject:eachDic[@"type"]];
        }

        wself.noDataView.hidden=wself.dataSource.count<1?NO:YES;
        [wself.tableView reloadData];
        [wself.tableView.mj_header endRefreshing];
        [wself.tableView.mj_footer endRefreshing];
    } failture:^(NSError *error) {
        NSLog(@"%@",error);
        [wself.tableView.mj_header endRefreshing];
        [wself.tableView.mj_footer endRefreshing];
    }];
    
    
    

    
}





- (void)requestData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    self.dataSource = @[].mutableCopy;
    NSArray *videoList = [rootDict objectForKey:@"list"];
    for (NSDictionary *dataDic in videoList) {
        ZFTableData *data = [[ZFTableData alloc] init];
        [data setValuesForKeysWithDictionary:dataDic];
        ZFTableViewCellLayout *layout = [[ZFTableViewCellLayout alloc] initWithData:data];
        [self.dataSource addObject:layout];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - UIScrollViewDelegate   列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2*self.dataSource.count+1;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
//    if ([self.dataSourceAAA[indexPath.row]integerValue]==2) {
//        ZFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
//        [cell setDelegate:self withIndexPath:indexPath];
//        if (self.index==2) {
//            cell.delBtn.hidden=NO;
//        }else{
//            cell.delBtn.hidden=YES;
//        }
//        cell.layout = self.dataSource[indexPath.row];
//        [cell setNormalMode];
//
//        cell.headImgClickBlock = ^{
//            NSLog(@"点击动态的用户头像");
//        };
//
//        cell.likeBtnClickBlock = ^(UIButton *moreBtn, BOOL isExpand, ZFTableViewCellLayout *layot) {
//            [SVProgressHUD showImage:KGetImage(@"") status:@"点赞"];
////            [NetworkRequest POST:@"" parmeters:@{@"life_id":layot.data.message_id} success:^(id responObject) {
////                BaseModel *baseModel = (BaseModel *)responObject;
////                NSLog(@"%@",baseModel.data);
//                moreBtn.selected=!moreBtn.selected;
//                if (!isExpand) {
//                    layot.data.is_star=@"1";
//                    layot.data.star_num=[NSString stringWithFormat:@"%ld",[layot.data.star_num integerValue]+1];
//                }else{
//                    layot.data.is_star=@"0";
//                    layot.data.star_num=[NSString stringWithFormat:@"%ld",[layot.data.star_num integerValue]-1<0?0:[layot.data.star_num integerValue]-1];
//                }
//                [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if ([obj isKindOfClass:[ZFTableViewCellLayout class]]) {
//                        ZFTableViewCellLayout *objItem=obj;
//                        if([objItem.data.message_id integerValue]==[layot.data.message_id integerValue]){
//                            [self.dataSource replaceObjectAtIndex:idx withObject:layot];
//                            [self.tableView reloadRow:idx inSection:0 withRowAnimation:UITableViewRowAnimationNone];
//
//                        }
//                    }
//
//                }];
//
////            } failture:^(NSError *error) {
////                NSLog(@"%@",error);
////            }];
//        };
//
//        cell.CommentBtnClickBlock = ^(UIButton *commentBtn, ZFTableViewCellLayout *layot) {
//            [SVProgressHUD showImage:KGetImage(@"") status:@"评论"];
//            wself.selectCellType=2;
//            wself.layoutModel=layot;
//            [wself.bottomView.textView becomeFirstResponder];
//        };
//        cell.MoreBtnClickBlock = ^{
//            [SVProgressHUD showImage:KGetImage(@"") status:@"收藏"];
//        };
//        cell.SendMsgBtnClickBlock = ^{
////            [SVProgressHUD showImage:KGetImage(@"") status:@"发消息"];
//        };
//        cell.delBtnClickBlock = ^(NSString *life_id) {
//            [wself delDynamic:life_id];
//        };
//        return cell;
//    }
    
    ZFOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:kDouYinIdentifier];
//    if([[UserManager userInfo].user_id integerValue]==[self.userID integerValue]){
//        cell.delBtn.hidden=NO;
//    }else{
//        cell.delBtn.hidden=YES;
//    }
    cell.model=self.dataSource[indexPath.row];
    cell.selectionStyle=0;
    cell.headImgClickBlock = ^{
        MessageInfoModel *model=self.dataSource[indexPath.row];
        EMO_PersonalDataBaseVC *vc=[EMO_PersonalDataBaseVC new];
        vc.userID=[NSString stringWithFormat:@"%@",model.uid];
        [wself.navigationController pushViewController:vc animated:YES];
    };
    cell.FollowBtnClickBlock = ^(UIButton *commentBtn, MessageInfoModel *model) {
        [NetworkRequest POST:Request_GetfollowOrBlack parmeters:@{@"to_uid":model.uid,@"type":@"0"} success:^(id responObject) {
            BaseModel *baseModel = (BaseModel *)responObject;
            NSLog(@"%@",baseModel.data);
            model.is_attention=!model.is_attention;
            [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[MessageInfoModel class]]) {
                    MessageInfoModel *objItem=obj;
                    if([model.uid integerValue]==[objItem.uid integerValue]){
                        objItem.is_attention=model.is_attention;
                        [self.dataSource replaceObjectAtIndex:idx withObject:objItem];
                    }
                }
               
            }];
        } failture:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    };
    cell.CollectBtnClickBlock = ^(UIButton *moreBtn, BOOL isExpand, MessageInfoModel *model) {
        [NetworkRequest POST:Request_LikeOrFollow parmeters:@{@"dynamic_id":model.message_id,@"type":@"1"} success:^(id responObject) {
            BaseModel *baseModel = (BaseModel *)responObject;
            NSLog(@"%@",baseModel.data);
            moreBtn.selected=!moreBtn.selected;
            if (!isExpand) {
                model.is_collect=YES;
                model.collect_num=model.collect_num+1;

            }else{
                model.is_collect=NO;
                model.collect_num=model.collect_num-1<0?0:model.collect_num-1;
            }
            [moreBtn setTitle:[NSString stringWithFormat:@"%ld",model.collect_num] forState:UIControlStateNormal];
            [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[MessageInfoModel class]]) {
                    MessageInfoModel *objItem=obj;
                    if([objItem.message_id integerValue]==[model.message_id integerValue]){
                        [self.dataSource replaceObjectAtIndex:idx withObject:model];
                    }
                }
               
            }];
        } failture:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
        
    };
    
    
    cell.likeBtnClickBlock = ^(UIButton *moreBtn, BOOL isExpand, MessageInfoModel *model) {
        [NetworkRequest POST:Request_LikeOrFollow parmeters:@{@"dynamic_id":model.message_id,@"type":@"0"} success:^(id responObject) {
            BaseModel *baseModel = (BaseModel *)responObject;
            NSLog(@"%@",baseModel.data);
            moreBtn.selected=!moreBtn.selected;
            if (!isExpand) {
                model.is_like=YES;
                model.like_num=model.like_num+1;

            }else{
                model.is_like=NO;
                model.like_num=model.like_num-1<0?0:model.like_num-1;

            }
            [moreBtn setTitle:[NSString stringWithFormat:@"%ld",model.like_num] forState:UIControlStateNormal];
            [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[MessageInfoModel class]]) {
                    MessageInfoModel *objItem=obj;
                    if([objItem.message_id integerValue]==[model.message_id integerValue]){
                        [self.dataSource replaceObjectAtIndex:idx withObject:model];
                        [self.tableView reloadRow:idx inSection:0 withRowAnimation:UITableViewRowAnimationNone];

                    }
                }
               
            }];
        } failture:^(NSError *error) {
            NSLog(@"%@",error);
        }];

    };
    cell.delBtnClickBlock = ^(MessageInfoModel *model) {
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            EMO_EditDynamicVC *vc=[EMO_EditDynamicVC new];
            vc.model=model;
            vc.successBlock = ^{
                [wself loadNewData];
            };
            [wself.navigationController pushViewController:vc animated:YES];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [wself delDynamic:[Common isNull:model.message_id]];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    };
    cell.CommentBtnClickBlock = ^(UIButton *commentBtn, MessageInfoModel *model) {
        [SVProgressHUD showImage:KGetImage(@"") status:@"跳转详情"];
//        self.selectCellType=1;
//        self.otherModel=model;
//        [self.bottomView.textView becomeFirstResponder];
 
    };
//    cell.MoreBtnClickBlock = ^{
//        [SVProgressHUD showImage:KGetImage(@"") status:@"查看更多评论"];
//    };
//    cell.SendMsgBtnClickBlock = ^{
//        [SVProgressHUD showImage:KGetImage(@"") status:@"发消息"];
//    };
    cell.tapImageBlock = ^(NSInteger index, NSArray *dataSource) {
        WMPhotoBrowser *browser = [WMPhotoBrowser new];
        browser.dataSource = dataSource.mutableCopy;
        browser.currentPhotoIndex = index;
        [wself.navigationController pushViewController:browser animated:YES];
//        [weakSelf presentViewController:browser animated:YES completion:^{

//        }];
        
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row % 2 != 1)  return;
    /// 如果正在播放的index和当前点击的index不同，则停止当前播放的index
    if (self.player.playingIndexPath != indexPath) {
        [self.player stopCurrentPlayingCell];
    }
    //// 如果没有播放，则点击进详情页会自动播放 暂时关闭
//    if (!self.player.currentPlayerManager.isPlaying) {
//        [self playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
//    }
    
    
    
    EMO_DynamicXQViewController *detailVC=[EMO_DynamicXQViewController new];
//    if ([self.dataSourceAAA[indexPath.row] integerValue]==2) {
//        ZFTableViewCellLayout *layout = self.dataSource[indexPath.row];
//        detailVC.messageId=[NSString stringWithFormat:@"%@",layout.data.message_id];
//    }else{
        MessageInfoModel *eachModel = self.dataSource[indexPath.row];
        detailVC.model=eachModel;
//    }
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageInfoModel *eachModel = self.dataSource[indexPath.row];
    return eachModel.headerHeight+KAdaptedHeight(65);
    
//    if ([self.dataSourceAAA[indexPath.row]integerValue]==2) {
//        ZFTableViewCellLayout *layout = self.dataSource[indexPath.row];
//        if ([layout.data.comment_num integerValue]<1) {
//            return layout.height+KAdaptedHeight(85);
//        }
//        return layout.height+KAdaptedHeight(165);
//    }else{
//
//        MessageInfoModel *eachModel = self.dataSource[indexPath.row];
//        if (eachModel.comment_res.count<1) {
//            return eachModel.headerHeight+KAdaptedHeight(85)+KAdaptedHeight(10);
//        }
//        return eachModel.headerHeight+KAdaptedHeight(165)+KAdaptedHeight(10);
//    }

}

#pragma mark 删除动态
-(void)delDynamic:(NSString *)mesage_id{
    WeakSelf;
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"" message:getLanguage(@"确定删除这条动态吗") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [NetworkRequest POST:Request_DelDynamic parmeters:@{@"dynamic_id":mesage_id} success:^(id responObject) {
            BaseModel *baseModel = (BaseModel *)responObject;
            NSLog(@"%@",baseModel.data);
            NSMutableArray *dataArr=[NSMutableArray arrayWithArray:self.dataSource];

            [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[MessageInfoModel class]]) {
                    MessageInfoModel *objItem=obj;
                    if([objItem.message_id integerValue]==[mesage_id integerValue]){
                        [wself.dataSource removeObjectAtIndex:idx];
//                        [wself.dataSourceAAA removeObjectAtIndex:idx];
                        [wself.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                }else{
                    ZFTableViewCellLayout  *objItem=obj;
                    if([objItem.data.message_id integerValue]==[mesage_id integerValue]){
                        [wself.dataSource removeObjectAtIndex:idx];
//                        [wself.dataSourceAAA removeObjectAtIndex:idx];
                        [wself.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                }
            }];
            
            
            
//
        } failture:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    

}





#pragma mark - ZFTableViewCellDelegate

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
//    [self playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
//点击cell暂时禁用播放,跟Android同步,跳转详情播放
    
    
    EMO_DynamicXQViewController *detailVC=[EMO_DynamicXQViewController new];
//    if ([self.dataSourceAAA[indexPath.row] integerValue]==2) {
//        ZFTableViewCellLayout *layout = self.dataSource[indexPath.row];
//        detailVC.messageId=[NSString stringWithFormat:@"%@",layout.data.message_id];
//    }else{
        MessageInfoModel *eachModel = self.dataSource[indexPath.row];
        detailVC.model=eachModel;
//    }
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark - private method

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollAnimated:(BOOL)animated {

    ZFTableViewCellLayout *layout = self.dataSource[indexPath.row];
    if (animated) {
        [self.player playTheIndexPath:indexPath assetURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",layout.data.imgs[0]]] scrollPosition:ZFPlayerScrollViewScrollPositionTop animated:YES];
    } else {
        [self.player playTheIndexPath:indexPath assetURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",layout.data.imgs[0]]]];
    }
    
    [self.controlView showTitle:@"" coverImage:[Common getThumbnailImage:[NSString stringWithFormat:@"%@",layout.data.imgs[0]]] fullScreenMode:ZFFullScreenModeLandscape];

}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor=kClearColor;
        [_tableView registerClass:[ZFTableViewCell class] forCellReuseIdentifier:kIdentifier];
        [_tableView registerClass:[ZFOtherCell class] forCellReuseIdentifier:kDouYinIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
    }
    return _controlView;
}



-(void)likeData{
    
    
    
    
    
}





- (void)WTBottomInputViewSendTextMessage:(NSString *)message{
    if ([message isEqualToString:@"发布一条甜美的评论~"]||[message isEqualToString:@""]) {
        return;
    }
    [self sendMessage:message];
}

#pragma mark 评论
-(void)sendMessage:(NSString *)text{
    NSDictionary *dic=[NSDictionary dictionary];
    if (self.selectCellType==2) {
        dic= @{@"life_id":self.layoutModel.data.message_id,@"comment_text":text};
    }else{
        dic= @{@"life_id":self.otherModel.message_id,@"comment_text":text};
    }
    [NetworkRequest POST:@"" parmeters:dic success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        NSLog(@"%@",baseModel.data);
        [self reuqestList:1];
//        [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (self.selectCellType==2) {
//                if ([obj isKindOfClass:[ZFTableViewCellLayout class]]) {
//                    ZFTableViewCellLayout *objItem=obj;
//                    if ([objItem.data.message_id isEqualToString:self.layoutModel.data.message_id]) {
//                        self.layoutModel.data.comment_num=[NSString stringWithFormat:@"%ld",[self.layoutModel.data.comment_num integerValue]+1];
//                        NSMutableArray *arr=[NSMutableArray array];
//                        for (NSDictionary *dic in self.layoutModel.data.comment_res[@"data"]) {
//                            [arr addObject:dic];
//
//                        }
//                        [arr addObject:@{@"":@""}];
//                        self.layoutModel.data.comment_res=@{@"data":arr};
//                        [self.dataSource replaceObjectAtIndex:idx withObject:self.layoutModel];
//                        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:idx] withRowAnimation:UITableViewRowAnimationNone];
//                    }
//                }
//
//            }else{
//                if ([obj isKindOfClass:[MessageInfoModel class]]) {
//                    MessageInfoModel *objItem=obj;
//                    if ([objItem.message_id isEqualToString:self.otherModel.message_id]) {
//                        [self.dataSource replaceObjectAtIndex:idx withObject:self.otherModel];
//                        [self.tableView reloadRow:idx inSection:0 withRowAnimation:UITableViewRowAnimationNone];
//
//                    }
//
//                }
//            }
//
//        }];
    } failture:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    
    
}



@end
