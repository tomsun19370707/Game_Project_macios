//
//  TSMusicPlayerVc.m
//
//  类介绍说明：
//
//

#import "CFMPlayerMusicListVc.h"
// DTO
#import "XXMediaUtil.h"
// View
#import "CFMPlayerMusicListCell.h"
#import "TSMusicPlayerOpr.h"
// 下级控制器
#import "TSMusicPlayerVc.h"
@interface CFMPlayerMusicListVc ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource,MusicPlayToolsDelegate>
/** table */
@property (strong, nonatomic) UITableView *listTableview;
/** 分页上拉和下拉刷新*/
/** 数据源*/
@property (nonatomic,strong) NSMutableArray *dataArr;
/** 页码*/
@property (nonatomic,strong) NSString *pageNo;
/** 是否有下一页*/
@property (nonatomic,assign) BOOL hasNextPage;
/** 数据筛选字典*/
@property (nonatomic,strong) NSMutableDictionary *parameter;
/** opr*/
@property (nonatomic,strong) TSMusicPlayerOpr *oprVie;
/** 详情*/
@property (nonatomic,strong) GoodListInfoModel *lookInfo;
/** 音乐播放器*/
@property (nonatomic,strong) XXMediaUtil *musicTool;
/** 记录音乐播放的进度，如果暂停后，则继续从暂停处播放*/
@property (nonatomic,assign) CGFloat musicProgress;
/** 关闭播放器*/
@property (nonatomic,strong) UIButton *shutDown;
/** 播放的index*/
@property (nonatomic,assign) NSInteger playIndex;
@end

@implementation CFMPlayerMusicListVc

#pragma mark -
#pragma mark --- 加载控制器
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    /** 暂停音乐*/
    [self pauseMusic];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // NavBar
    [self initNavBar];
    // 布局视图
    [self initContentView];
    // Rac
    [self initRacChain];
    // 网络请求
    [self initRequestData];
}

#pragma mark -
#pragma mark --- tableviewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.playIndex == indexPath.row) {
        /** 操作当前的音频*/
        if (self.oprVie.oprBtn.tag == 1) {
            /** 需要暂停*/
            /** 暂停音乐*/
            [self pauseMusic];
        }else{
            /** 播放音乐*/
            [self playMusic];
        }
    }else{
        self.playIndex = indexPath.row ;
        /** 清空进度*/
        self.musicProgress = 0 ;
        /** 播放音乐*/
        [self playMusic];
    }

    /** 刷新*/
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.listTableview reloadData];
    });
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CFMPlayerMusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMPlayerMusicListCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CFMPlayerMusicListCell" owner:self options:nil]lastObject];
    }
    if (indexPath.row < self.dataArr.count) {
        cell.model = self.dataArr[indexPath.row];
    }
    if (self.playIndex==indexPath.row) {
        cell.mark.hidden = NO ;
        /** 操作当前的音频*/
        if (self.oprVie.oprBtn.tag == 1) {
            cell.mark.image = IMAGE(@"mp_pause");
        }else{
            cell.mark.image = IMAGE(@"mp_play");
        }
    }else{
        cell.mark.hidden = YES ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setRoundCorner:tableView indexPath:indexPath];
}
#pragma mark -
#pragma mark DZNEmptyDataSetSource（数据源代理）
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"list_no_data"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无数据~~~";
    NSDictionary *attributes = @{NSFontAttributeName:PingFangFONT(14), NSForegroundColorAttributeName:UIColorFromRGB(0x999999)};
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

#pragma mark -
#pragma mark DZNEmptyDataSetDelegate（操作代理）
/** 响应按钮点击事件 */
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self.listTableview.mj_header beginRefreshing];
}

#pragma mark -
#pragma mark --- 导航初始化
- (void)initNavBar {
    self.navigationBar.title = @"音乐播放";
    self.navigationBar.rightBarItem = self.shutDown ;
}

#pragma mark -
#pragma mark --- 创建控件
- (void)initContentView {
    self.playIndex = 0 ;
    self.musicProgress = 0 ;
    self.view.backgroundColor = LineColor;
    /** tab */
    [self.view addSubview:self.listTableview];
    /** opr*/
    [self.view addSubview:self.oprVie];
    
    AVAudioSession  *session  =  [AVAudioSession  sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}

#pragma mark -
#pragma mark --- Rac方法
- (void)initRacChain {
    @weakify(self);
    /** 音乐播放操作*/
    self.oprVie.fetchClick = ^(int opr) {
        @strongify(self);
        /** 0上一首 1下一首 2开始/暂停*/
        switch (opr) {
            case 0:
                {
                    if (self.playIndex == 0) {
                        [SVProgressHUD showTextHUDWithMessage:@"当前是第一首"];
                        return;
                    }
                    self.playIndex -- ;
                    /** 清空进度*/
                    self.musicProgress = 0 ;
                    /** 播放音乐*/
                    [self playMusic];
                }
                break;
            case 1:
                {
                    /** 下一首逻辑*/
                    [self nextPlayHandle];
                }
                break;
            case 2:
                {
                    if (self.oprVie.oprBtn.tag == 1) {
                        /** 需要暂停*/
                        /** 暂停音乐*/
                        [self pauseMusic];
                    }else{
                        /** 播放音乐*/
                        [self playMusic];
                    }
                }
                break;
            default:
                break;
        }
        
        /** 刷新*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listTableview reloadData];
        });
    };
    
    /** 点击进去播放详情里去*/
    self.oprVie.fetchClickMusicLook = ^{
        @strongify(self);
        /** 如果没有选择音频播放，则不进入到详情里去*/
        if (self.playIndex==-1) {
            return;
        }
        TSMusicPlayerVc *pl = [[TSMusicPlayerVc alloc]init];
        pl.playIndex = self.playIndex ;
        pl.playArr = [NSMutableArray arrayWithArray:self.dataArr];
        [self.navigationController pushViewController:pl  animated:YES];
    };
    
    /** 关闭播放,选择该音乐并进行混音播放*/
    [[self.shutDown rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.dataArr.count==0) {
            [SVProgressHUD showTextHUDWithMessage:@"暂无音乐"];
            return;
        }
        if (self.playIndex==-1) {
            [SVProgressHUD showTextHUDWithMessage:@"请选择一首音乐"];
            return;
        }
        
        GoodListInfoModel *model = self.dataArr[self.playIndex];
        if (self.fetchSaveMusicFile) {
            self.fetchSaveMusicFile(model.music_file);
        }
        [self back];
    }];
    
    /** 进度拖动*/
    [[self.oprVie.slider rac_signalForControlEvents:UIControlEventValueChanged]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            XXMediaUtil *uti = [XXMediaUtil shared];
            [uti seekToTimeWithValue:self.oprVie.slider.value];
        }];
}

#pragma mark -
#pragma mark --- 网络请求
- (void)initRequestData {
    /** 获取音乐列表*/
    [self fetchMusicListHandle];
    
    /** 播放音乐*/
    [self playMusic];
}

#pragma mark -
#pragma mark --- Getter
- (UITableView *)listTableview
{
    if (!_listTableview) {
        _listTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT_dy - self.oprVie.height - NavBarHeight - 16*2) style:UITableViewStyleGrouped];
        _listTableview.delegate =self;
        _listTableview.dataSource =self;
        _listTableview.showsVerticalScrollIndicator = NO;
        _listTableview.backgroundColor = UIColor.clearColor ;
        _listTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableview.estimatedRowHeight = 0;
        _listTableview.estimatedSectionFooterHeight = 0;
        _listTableview.estimatedSectionHeaderHeight = 0;
        if (@available(iOS 11.0, *)) {
            _listTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        /** 无数据默认图*/
        _listTableview.emptyDataSetSource = self ;
        _listTableview.emptyDataSetDelegate = self ;
        _listTableview.bounces = NO ;
    }
    return _listTableview ;
}
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr ;
}
-(NSMutableDictionary *)parameter
{
    if (!_parameter) {
        _parameter = [NSMutableDictionary dictionary];
        _parameter[@"pageSize"] = @"10";
    }
    return _parameter ;
}
-(TSMusicPlayerOpr *)oprVie
{
    if (!_oprVie) {
        _oprVie = [[[NSBundle mainBundle] loadNibNamed:@"TSMusicPlayerOpr" owner:self options:nil]lastObject];
        _oprVie.selectionStyle = UITableViewCellSelectionStyleNone ;
        [_oprVie setFrame:CGRectMake(12, 0, SCREEN_WIDTH - 12 * 2, _oprVie.contentView.height)];
        _oprVie.backgroundColor = UIColor.whiteColor ;
        _oprVie.layer.masksToBounds = YES;
        _oprVie.layer.cornerRadius = 10 ;
        _oprVie.bottom = SCREEN_HEIGHT_dy - 16 ;
    }
    return _oprVie;
}
-(XXMediaUtil *)musicTool
{
    if (!_musicTool) {
        XXMediaUtil *uti = [XXMediaUtil shared];
        uti.delegate = self ;
        _musicTool = uti ;
    }
    return _musicTool;
}
-(UIButton *)shutDown
{
    if (!_shutDown) {
        _shutDown = [UIButton racButtonWithTitle:nil BGImage:IMAGE(@"mp_shut_down") frame:CGRectMake(0, 0, 20, 20) fontSize:1 titleColor:nil];
    }
    return _shutDown;
}
#pragma mark --
#pragma mark --- Method
/** 获取音乐列表*/
- (void)fetchMusicListHandle
{
    @weakify(self);
    /** para*/
    NSMutableDictionary *parameter =[NSMutableDictionary dictionary];
    parameter[@"page"] = @"1";
    parameter[@"size"] = @"100";
    [FFHomeHandel fetchMusicList:parameter success:^(NSMutableArray *dataArr, NSString *pageNo, BOOL hasNextPage) {
        @strongify(self);
        self.dataArr = dataArr ;
        
        /** 遍历音乐*/
        if ([NSString NotNull:self.currentLiveRoomPlayMusic]) {
            [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GoodListInfoModel *temp = obj;
                if ([temp.music_file isEqualToString:self.currentLiveRoomPlayMusic]) {
                    self.playIndex = idx ;
                    *stop = YES ;
                }
            }];
        }
        
        /** 展示音乐*/
        if (self.playIndex < self.dataArr.count) {
            /** 设置底部显示的信息*/
            self.oprVie.model = dataArr[self.playIndex] ;
            if ([NSString NotNull:self.currentLiveRoomPlayMusic]) {
                /** 需要进行播放*/
                [ObjectTool performSelectorAfterDelay:0.5 completion:^{
                    [self playMusic];
                }];
            }
        }
        
        /** 刷新*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listTableview reloadData];
        });
    } failure:^{
        
    }] ;
}

/** 外界实现这个方法的同时, 也将参数的值拿走了, 这样我们起到了"通过代理方法向外界传递值"的功能.*/
-(void)getCurTiem:(NSString *)curTime Totle:(NSString *)totleTime Progress:(CGFloat)progress
{
    self.oprVie.time1.text = curTime ;
    self.oprVie.time2.text = totleTime ;
    self.oprVie.slider.value = progress ;
    
    /** 记录进度*/
    self.musicProgress = progress ;
}

- (void)endOfPlayAction { 
    DLog(@"======当前音乐播放结束了");
    
    XXMediaUtil *uti = [XXMediaUtil shared];
    [uti seekToTimeWithValue:0];
    self.oprVie.slider.value = 0.0 ;
    /** 记录进度*/
    self.musicProgress = 0.0 ;
    
    /** 判断播放模式*/
    /** 模式切换 1列表循环 2随机 3单曲 */
    switch (self.oprVie.playMode) {
        case 1:
            {
                /** 循环播放*/
                self.playIndex++;
                if (self.playIndex >= self.dataArr.count) {
                    self.playIndex = 0;
                }
                
                [self playMusic];
            }
            break;
        case 2:
            {
                /** 随机*/
                self.playIndex = arc4random() % self.dataArr.count;
                
                [self playMusic];
            }
            break;   
        case 3:
            {
                /** 单曲*/
                [self playMusic];
            }
            break;
        default:
            break;
    }
}

/** 音频播放完成的通知*/
-(void)musicEndPlayHandle
{
    /** 音乐播放结束，代理，继续播放下一首*/
    /** 下一首逻辑*/
    [self nextPlayHandle];
}


/** 播放音乐*/
- (void)playMusic
{
    if (self.dataArr.count==0) {
        return;
    }
    if (self.playIndex==-1) {
        return;
    }
    
    /** 暂停音乐*/
    [self pauseMusic];
    self.lookInfo = nil ;
    
    if (self.playIndex < self.dataArr.count) {
        self.lookInfo = self.dataArr[self.playIndex] ;
    }
    
    /** 刷新*/
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.listTableview reloadData];
    });
    
    if (![NSString NotNull:self.lookInfo.music_file]) {
        [SVProgressHUD showTextHUDWithMessage:@"暂无播放源"];
        return;
    }
    
    
    if (self.musicProgress > 0) {
        /** 这个是暂停后的继续播放*/
        [self.musicTool seekToTimeWithValue:self.musicProgress];
    }else{
        /** 开始播放*/
        self.musicTool.mp3Url = self.lookInfo.music_file ;
        [self.musicTool musicPrePlay];
        [self.musicTool musicPlay];
        
        /** 设置底部显示的信息*/
        self.oprVie.model = self.lookInfo ;
    }
    
    
    self.oprVie.oprBtn.tag = 1 ;
    [self.oprVie.oprBtn setBackgroundImage:IMAGE(@"mp_pause") forState:UIControlStateNormal];
}

/** 暂停音乐*/
- (void)pauseMusic
{
    [self.musicTool musicPause];
    self.oprVie.oprBtn.tag = 0 ;
    [self.oprVie.oprBtn setBackgroundImage:IMAGE(@"mp_play") forState:UIControlStateNormal];
    
    /** 刷新*/
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.listTableview reloadData];
    });
}

/** 下一首逻辑*/
- (void)nextPlayHandle
{
    if (self.playIndex == self.dataArr.count - 1) {
        [SVProgressHUD showTextHUDWithMessage:@"当前是最后一首"];
        return;
    }
    self.playIndex ++ ;
    /** 清空进度*/
    self.musicProgress = 0 ;
    /** 播放音乐*/
    [self playMusic];
}
@end


