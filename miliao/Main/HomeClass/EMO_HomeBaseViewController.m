//
//  EMO_HomeBaseViewController.m
//  miliao
//
//  Created by 张世浩 on 2023/6/16.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_HomeBaseViewController.h"
#import "EMO_HomeViewController.h"
#import "EMO_HomeHeadView.h"
#import "MLSearchViewController.h"
#import "RoomGiftModel.h"
#import <CommonCrypto/CommonDigest.h>
#import "EMO_StartPlayViewController.h"
#import "EMO_EndPlayViewController.h"
#import "RoomPasswordView.h"
#import "EMO_PublicManager.h"
#import "EMO_AddRoomVC.h"
@interface EMO_HomeBaseViewController ()
@property (nonatomic,strong)WMZPageController *VC;
@property (nonatomic,strong)EMO_HomeHeadView *headView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *titleArr;
@property (nonatomic,assign) BOOL isCanSideBack;
Strong RoomPasswordView *passWordView;

Assign NSInteger selectIndex;

@property (nonatomic, strong) NSMutableArray    *svgaArray;

@end

@implementation EMO_HomeBaseViewController
static SVGAParser *parserCache;

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr=[NSMutableArray array];
    }
    return _titleArr;
}
- (RoomPasswordView *)passWordView{
    if (!_passWordView) {
        _passWordView = [[RoomPasswordView alloc] initWithFrame:CGRectMake(0, 0, ScreenViewWidth, ScreenViewHeight)];
    }
    return _passWordView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:YES animated:YES];
     [self forbiddenSideBack];
    AppDelegate *delegate = APPDELEGATE;
    [delegate UpdataVersion];
     
}
-(void)viewWillDisappear:(BOOL)animated{
      [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self resetSideBack];
    
}
/**
 
 * 禁用边缘返回

 */
-(void)forbiddenSideBack{
    
    self.isCanSideBack = NO;
    //关闭ios右滑返回
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
        
    }
    
}

/*
 恢复边缘返回
 */

- (void)resetSideBack {
    
    self.isCanSideBack=YES;
    //开启ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        
    }
    
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    
    return self.isCanSideBack;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self getRTMToken];
    [self giftCacheData];
    self.selectIndex=0;
    //显示青少年模式
    if([Common isEmptyString:UserDefaultsGet(@"APPPassWord")]){
        //无密码,弹出青少年模式
        [[EMO_PublicManager manager].adolescentView viewShow];
    }
}

-(void)setUI{
    
    WeakSelf;
        //标题数组
    if(self.titleArr.count<1){
        self.titleArr=[NSMutableArray arrayWithArray:@[@"今日推荐",@"交友",@"情感",@"电台"]];
    }
        //控制器数组
        NSMutableArray *vcArr = [NSMutableArray new];
    [self.titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EMO_HomeViewController *vc = [EMO_HomeViewController new];
            vc.index = idx;
//            vc.dicData= obj;
            [vcArr addObject:vc];
        }];
        
        WMZPageParam *param = PageParam()
        .wTitleArrSet(self.titleArr)
        .wControllersSet(vcArr)
        .wMenuAnimalSet(PageTitleMenuPDD)
        .wMenuDefaultIndexSet(0)
        //指示器位置
        .wMenuIndicatorYSet(17)
        .wMenuIndicatorHeightSet(5)
        .wMenuIndicatorRadioSet(2.5)
        //悬浮开启
        .wTopSuspensionSet(YES)
        //头视图y坐标从0开始
        .wFromNaviSet(YES)
        .wMenuTitleColorSet(PageDarkColor(RGBA(153, 153, 153, 1),RGBA(153, 153, 153, 1)))
    //颜色
        .wMenuTitleSelectColorSet(PageDarkColor(kBlackColor, kBlackColor))
        .wMenuIndicatorColorSet(PageDarkColor(RGBA(255, 198, 0, 1),RGBA(255, 198, 0, 1)))
    
        //如果吸顶偏移量有问题 传入此属性即可 为当前的值+上传入的值
//        .wTopOffsetSet(-PageVCStatusBarHeight)
//          .wTopOffsetSet(-80)
    .wTopChangeHeightSet(-KAdaptedHeight(600))
    //背景层
    .wInsertHeadAndMenuBgSet(^(UIView *bgView) {
        bgView.backgroundColor=RGBA(255, 255, 255, 0);
    })
    // 字体大小
    .wMenuTitleUIFontSet(KFont(15))
//    选中的字体大小
    .wMenuTitleSelectUIFontSet(KFontBold(17))
        //头部
        .wMenuHeadViewSet(^UIView *{
            self.headView=[[EMO_HomeHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KAdaptedHeight(450))];
            self.headView.SenderBlock = ^(NSInteger tag) {
                if(tag==100){
                    MLSearchViewController *vc=[[MLSearchViewController alloc] init];
                    [wself.navigationController pushViewController:vc animated:NO];
                }else {
                
                     if (tag==4000){
                        wself.selectIndex=0;
                        ZXTabBarController *tabbar = (ZXTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                        tabbar.selectedIndex = 1;
                        [wself performSelector:@selector(delayMethods) withObject:nil afterDelay:0.5];
                     }else{

                         [wself getRoomInfo:tag/1000-1];
                     }
                    
                  
                }
                
                
            };

            return self.headView;
        });
        
    self.VC =  [WMZPageController new];
    self.VC.view.frame=CGRectMake(0,0, SCREENWIDTH, SCREEN_HEIGHT-TabBar_H);
    self.VC.param = param;
    self.VC.pageView.backgroundColor=kClearColor;
    self.VC.downSc.backgroundColor=kClearColor;
    self.VC.view.backgroundColor=kClearColor;

    [self.view addSubview:self.VC.view];
    [self addChildViewController:self.VC];
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:KGetImage(@"UY_HomeAdd") forState:0];
    [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.height.width.mas_offset(50);
        make.bottom.mas_offset(-20);
    }];
}

-(void)addClick{
    EMO_AddRoomVC *vc = [[EMO_AddRoomVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)delayMethods{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpDataChatSelect" object:nil userInfo:@{@"index":@(self.selectIndex)}]];
}


-(void)loadData{
    
    [NetworkRequest POST:Request_GetRoomPartition parmeters:nil success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        
        [self.dataArr addObjectsFromArray:basemodel.data];
        [self.titleArr addObject:getLanguage(@"今日推荐")];
        for (NSDictionary *dic in self.dataArr) {
            [self.titleArr addObject:dic[@"name"]];
        }
        [self setUI];
    } failture:^(NSError *error) {
        [self setUI];
    }];
    
    
    
}


-(void)getRTMToken{
    
    [NetworkRequest POST:Request_Get_rtm_token parmeters:nil success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        UserDefaultsSave([Common isNull:basemodel.data],@"ShengWangRTMToken");
    } failture:^(NSError *error) {
        
    }];
    
}

-(void)getRoomInfo:(NSInteger)tag{
    
    [NetworkRequest POST:Request_GetRandRoom parmeters:@{@"type":@(tag)} success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        NSLog(@"%@",basemodel.data);
        NSArray *arr=basemodel.data;
        if(arr.count>0){
            NSDictionary *dic=arr[0];
            if([dic[@"status"] integerValue]==0){
                if([[UserManager userInfo].user_id integerValue]==[dic[@"uid"] integerValue]){
//                    EMO_StartPlayViewController*vc=[EMO_StartPlayViewController new];
//                    vc.dicData = [NSMutableDictionary dictionaryWithDictionary:dic];
//                    [self.navigationController pushViewController:vc animated:YES];
                    
                    /** 2026-01-24 不在进入准备开播页面*/
                    if([dic[@"type"] integerValue]==0){
                        [self getIntoTheRoom:dic passWord:@""];
                    }else{
                        if([[UserManager userInfo].user_id integerValue]==[dic[@"uid"] integerValue]){
                            [self getIntoTheRoom:dic passWord:@""];
                        }else{
                            [[UIApplication sharedApplication].delegate.window addSubview:self.passWordView];
                            [self.passWordView setDicModel:dic];
                            WeakSelf;
                            self.passWordView.sendDicSeBlock = ^(NSDictionary *model, NSString *text) {
                                [wself getIntoTheRoom:model passWord:text];
                            };
                        }
                    }
                    
                    
                }else{
                    EMO_EndPlayViewController*vc=[EMO_EndPlayViewController new];
                    vc.dicData = [NSMutableDictionary dictionaryWithDictionary:dic];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                
            }else if ([dic[@"status"] integerValue]==1){
                NSLog(@"禁播");
                [SVProgressHUD showImage:KGetImage(@"") status:@"该房间已被禁播"];
            }else{
                if([dic[@"type"] integerValue]==0){
                    [self getIntoTheRoom:dic passWord:@""];
                }else{
                    if([[UserManager userInfo].user_id integerValue]==[dic[@"uid"] integerValue]){
                        [self getIntoTheRoom:dic passWord:@""];
                    }else{
                        [[UIApplication sharedApplication].delegate.window addSubview:self.passWordView];
                        [self.passWordView setDicModel:dic];
                        WeakSelf;
                        self.passWordView.sendDicSeBlock = ^(NSDictionary *model, NSString *text) {
                            [wself getIntoTheRoom:model passWord:text];
                        };
                    }
                }
              
            }

        }
        
        
    } failture:^(NSError *error) {
        
        
    }];
    
    
    
    
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






#pragma mark 礼物缓存
-(void)giftCacheData{
    parserCache = [[SVGAParser alloc] init];
    parserCache.enabledMemoryCache = YES;
    WeakSelf;
    
    [NetworkRequest POST:Request_GetGiftList parmeters:nil success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        NSMutableArray *arry = [RoomGiftModel mj_objectArrayWithKeyValuesArray:basemodel.data];
          for (RoomGiftModel *mode in arry) {
              if ([mode.svga_file hasSuffix:@".svga"]||[mode.svga_file hasSuffix:@".SVGA"]) {
                  [wself.svgaArray addObject:mode];
              }
          }
          [wself svgaCachePlay:wself.svgaArray[0]];
              
    } failture:^(NSError *error) {
        
    }];


}
-(void)svgaCachePlay:(RoomGiftModel *)mode{
    
    if (mode.svga_file.length<1) {
        return;
    }
    NSFileManager * fileMgr = [NSFileManager defaultManager];
    NSString *dir = [self memorySVGADir:[NSURL URLWithString:mode.svga_file]];
    NSString * svgaFilePath = [dir stringByAppendingString:[NSString stringWithFormat:@"/%@.svga",[self MD5StringExt:[NSURL URLWithString:mode.svga_file].absoluteString]]];
    if ([fileMgr fileExistsAtPath:svgaFilePath]) { //存在
        [self.svgaArray removeObject:mode];
        if (self.svgaArray.count>0) {
            [self svgaCachePlay:self.svgaArray[0]];
        }
        return;
    }
    [parserCache parseMemoryWithURL:[NSURL URLWithString:mode.svga_file] Version:@"1.0" completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        if (videoItem != nil) {
            [self.svgaArray removeObject:mode];
            if (self.svgaArray.count>0) {
                [self svgaCachePlay:self.svgaArray[0]];
            }
        }
    } failureBlock:^(NSError * _Nullable error) {
        if (error) {
        }
    }];
    
}


#pragma mark - Private
//文件夹SVGA 不存在创建
-(nullable NSString *)memorySVGADir:(NSURL *)url{
    
    NSFileManager * fileMgr = [NSFileManager defaultManager];
    NSString *memoryDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/SVGA/%@",[self MD5StringExt:url.absoluteString]]];
    BOOL dir = NO;
    [fileMgr fileExistsAtPath:memoryDir isDirectory:&dir];
    
    if (dir == NO) { //创建文件夹
        
        [fileMgr createDirectoryAtPath:memoryDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return memoryDir;
}

- (NSString *)MD5StringExt:(NSString *)str {
    
    const char *cstr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}



@end
