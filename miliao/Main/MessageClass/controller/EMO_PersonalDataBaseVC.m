//
//  EMO_PersonalDataBaseVC.m
//  miliao
//
//  Created by 张世浩 on 2023/6/25.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_PersonalDataBaseVC.h"
#import "EMO_PersonalDataVC.h"
#import "EMO_PersonalHeadView.h"
#import "EMO_PersonalNavView.h"
#import "EMO_OhterUserDynamicVC.h"//他人动态
#import "MLSessionViewController.h"//发消息
@interface EMO_PersonalDataBaseVC ()<dgNavViewDelegate>
@property (nonatomic,strong) EMO_PersonalNavView *navView;
@property (nonatomic,strong)WMZPageController *VC;
@property (nonatomic,strong)EMO_PersonalHeadView *headView;
@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,assign) BOOL isCanSideBack;

Strong NSMutableDictionary *dicData;
Strong NSMutableArray *reportArr;

@end

@implementation EMO_PersonalDataBaseVC

-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)reportArr{
    if (!_reportArr) {
        _reportArr=[NSMutableArray array];
    }
    return _reportArr;
}
-(NSMutableDictionary *)dicData{
    if(!_dicData){
        _dicData=[NSMutableDictionary dictionary];
    }
    return _dicData;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:YES animated:YES];
     [self forbiddenSideBack];
     
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

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    
    return self.isCanSideBack;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
}

- (EMO_PersonalNavView*)navView {
    if (!_navView) {
        WeakSelf;
        _navView = [[EMO_PersonalNavView alloc]init];
        if([self.userID integerValue]==[[UserManager userInfo].user_id integerValue]){
            _navView.messageBtn.hidden=YES;
            _navView.moreBtn.hidden=YES;
        }
        _navView.BtnBlock = ^(NSInteger tag) {
            if(tag==100){
                [wself.navigationController popViewControllerAnimated:YES];
            }else if (tag==200){
                if([[UserManager userInfo].real_name_status intValue] == 2){
                    MLSessionViewController *VC = [[MLSessionViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:wself.userID];
                    if([wself.dicData.allKeys containsObject:@"user_info"]){
                        VC.title = wself.dicData[@"user_info"][@"nickname"];
                    }else{
                        VC.title = wself.userID;
                    }
                    [wself.navigationController pushViewController:VC animated:YES];
                }else{
                    [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:@"请先实名认证"]];
                }
            }else{
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
                [alert addAction:[UIAlertAction actionWithTitle:getLanguage(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                for (NSDictionary *dic in wself.reportArr) {
                    [alert addAction:[UIAlertAction actionWithTitle:[Common isNull:dic[@"reason"]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        for (NSDictionary *dic in wself.reportArr) {
                            if([dic[@"reason"] isEqualToString:action.title]){
                                [wself report:dic andReasonId:dic[@"id"]];
                                break;;
                            }
                        }
                    }]];
                }
                [wself presentViewController:alert animated:YES completion:nil];
                
            }
        
        };
        [self.view addSubview:_navView];
        [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(ZJTopNavH+ZJStatusBarH);
        }];
    }
    return _navView;

}
-(void)navBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setUI{
    
    WeakSelf;
        //标题数组
//    if(self.titleArr.count<1){
//        self.dataArr=[NSMutableArray arrayWithArray:@[@"资料",@"动态",@"技能"]];
    self.dataArr=[NSMutableArray arrayWithArray:@[@"资料",@"动态"]];
//    }
        //控制器数组
        NSMutableArray *vcArr = [NSMutableArray new];
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx==1){
            EMO_OhterUserDynamicVC *vc=[EMO_OhterUserDynamicVC new];
            vc.type=3;
            vc.userID = wself.userID;
            vc.HidenBack=YES;
            [vcArr addObject:vc];
        }else{
            EMO_PersonalDataVC *vc = [EMO_PersonalDataVC new];
            vc.index = idx;
            vc.dicData=wself.dicData;
            [vcArr addObject:vc];
        }
        }];
        
        WMZPageParam *param = PageParam()
        .wTitleArrSet(self.dataArr)
        .wControllersSet(vcArr)
        .wMenuAnimalSet(PageTitleMenuAiQY)
        .wMenuDefaultIndexSet(0)
        //悬浮开启
        .wTopSuspensionSet(YES)
        //头视图y坐标从0开始
        .wFromNaviSet(YES)
    .wMenuTitleColorSet(PageDarkColor(RGBA(153, 153, 153, 1),RGBA(153, 153, 153, 1)))
    //颜色
            .wMenuTitleSelectColorSet(PageDarkColor(kBlackColor, kBlackColor))
           .wMenuIndicatorColorSet(PageDarkColor(RGBA(255, 238, 1, 1),RGBA(255, 238, 1, 1)))
    
        //如果吸顶偏移量有问题 传入此属性即可 为当前的值+上传入的值
//        .wTopOffsetSet(-PageVCStatusBarHeight)
//          .wTopOffsetSet(-80)
    .wTopChangeHeightSet(-KAdaptedHeight(300))
    .wMenuIndicatorYSet(0)
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

            self.headView=[[EMO_PersonalHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KAdaptedHeight(300))];
            self.headView.dicData=self.dicData[@"user_info"];
            if([self.dicData[@"family_info"] isKindOfClass:[NSDictionary class]]){
                self.headView.level_image = self.dicData[@"family_info"][@"level_image"];
            }
            if([self.dicData[@"room_info"] isKindOfClass:[NSDictionary class]]){
                self.headView.roomDic = self.dicData[@"room_info"];
            }
            return self.headView;
        });
        
    self.VC =  [WMZPageController new];
    self.VC.view.frame=CGRectMake(0,0, SCREENWIDTH, SCREEN_HEIGHT);
    self.VC.param = param;
    self.VC.pageView.backgroundColor=kClearColor;
    self.VC.downSc.backgroundColor=kClearColor;
    self.VC.view.backgroundColor=kClearColor;

    [self.view addSubview:self.VC.view];
    [self addChildViewController:self.VC];
    
    [self navView];
}



-(void)loadData{

    WeakSelf;
    [SVProgressHUD show];
    [NetworkRequest POST:Request_getOtherUserInfo parmeters:@{@"to_uid":self.userID} success:^(id responObject) {
        [SVProgressHUD dismiss];
        BaseModel *baseModel = (BaseModel *)responObject;
        
        wself.dicData=[[NSMutableDictionary alloc] initWithDictionary:baseModel.data];
        [wself setUI];
    } failture:^(NSError *errors) {
        [SVProgressHUD dismiss];
        
    }];
    
    
    [NetworkRequest POST:Request_GetReportReason parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        self.reportArr=[NSMutableArray arrayWithArray:baseModel.data];
        
    } failture:^(NSError *error) {
        
    }];
    
 
}

-(void)report:(NSDictionary *)dic andReasonId:(NSString *)reportID{
//type类型:0=动态,1=房间,2=会员，3=评论
    [NetworkRequest POST:Request_AddReport parmeters:@{@"reason_id":reportID,@"comment_id":dic[@"id"],@"type":@"2",@"to_uid":self.userID} success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
        
    } failture:^(NSError *error) {
        
    }];
    
    
}






@end
