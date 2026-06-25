//
//  EMO_ChatViewController.m
//  miliao
//
//  Created by 张世浩 on 2022/10/10.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_ChatViewController.h"

#import "EMO_ChatContentViewController.h"
#import "RoomFloatingWindow.h"

@interface EMO_ChatViewController ()
Strong UIImageView *topBgImgView;
@property (nonatomic,strong)WMZPageController *VC;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *titleArr;


@end

@implementation EMO_ChatViewController
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self topBgImgView];
    [self addTitleData];
    
    
}
-(void)InfoNotificationConfession:(NSNotification *)notification{
    NSDictionary *dicData=notification.userInfo;
    
    [self.VC.upSc.mainView scrollToIndex:[dicData[@"index"] integerValue] animal:YES];
    
    
}

- (UIImageView*)topBgImgView{
    if (!_topBgImgView) {
        _topBgImgView = [[UIImageView alloc] init];
        _topBgImgView.image=KGetImage(@"mineHeadBgImg");
        [self.view addSubview:_topBgImgView];
        [_topBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(130));
        }];
    }
    return _topBgImgView;
}


-(void)addView{
    
    
    if(self.titleArr.count<1){
        self.titleArr=[NSMutableArray arrayWithArray:@[@"推荐",@"交友",@"情感",@"电台"]];
    }
    
    WMZPageParam *param = PageParam();
    param.wTitleArrSet(self.titleArr)
    .wViewControllerSet(^UIViewController *(NSInteger index) {
        EMO_ChatContentViewController *vc = [EMO_ChatContentViewController new];
             vc.index = index;
        if(self.dataArr.count>0){
            if(self.dataArr.count>=index){
                vc.dicD=self.dataArr[index];
            }
        }
             return vc;
     })
    //控制器开始切换
    .wEventBeganTransferControllerSet(^(UIViewController *oldVC, UIViewController *newVC, NSInteger oldIndex, NSInteger newIndex) {
        NSLog(@"开始切换 %ld %ld",oldIndex,newIndex);
     })
    //控制器结束切换
    .wEventEndTransferControllerSet(^(UIViewController *oldVC, UIViewController *newVC, NSInteger oldIndex, NSInteger newIndex) {
       NSLog(@"结束切换 %ld %ld",oldIndex,newIndex);
     })
    //标题点击
    .wEventClickSet(^(id anyID, NSInteger index) {
        NSLog(@"标题点击%ld",index);
    })
    .wEventChildVCDidSrollSet(^(UIViewController *pageVC, CGPoint oldPoint, CGPoint newPonit, UIScrollView *currentScrollView) {
        NSLog(@"滚动");
    })
    .wMenuTitleSelectColorSet(PageDarkColor(RGBA(34, 34, 34, 1), RGBA(34, 34, 34, 1)))
    .wMenuIndicatorColorSet(BaseMainColor)
    //默认选中第几个
    .wMenuDefaultIndexSet(0)
    //导航栏透明度变化
    .wNaviAlphaSet(YES)
    //背景层
    .wInsertHeadAndMenuBgSet(^(UIView *bgView) {
        bgView.backgroundColor=RGBA(255, 255, 255, 0);
//        bgView.backgroundColor=kRedColor;
    })
    .wMenuPositionSet(PageMenuPositionNavi)
//    是否开启渐变色
    .wMenuAnimalTitleGradientSet(NO)
    //导航栏透明度变化
    .wNaviAlphaSet(YES)
//     菜单标题的位置
    .wMenuPositionSet(PageMenuPositionLeft)
    // 字体大小
    .wMenuTitleUIFontSet(KFont(14))
//    选中的字体大小
    .wMenuTitleSelectUIFontSet(KFontBold(19))
//    指示器位置
    .wMenuIndicatorYSet(17)
    .wMenuIndicatorHeightSet(5)
    .wMenuIndicatorRadioSet(2.5)
    .wMenuAnimalSet(PageTitleMenuPDD);
    
    self.VC =  [WMZPageController new];
    self.VC.view.frame=CGRectMake(0,kSafeArea_Top+KAdaptedHeight(0), kWidth, kHeight-TabBar_H+KAdaptedHeight(25));
    self.VC.param = param;
    self.VC.pageView.backgroundColor=kClearColor;
    self.VC.downSc.backgroundColor=kClearColor;
    self.VC.view.backgroundColor=kClearColor;
    [self.view addSubview:self.VC.view];
    [self addChildViewController:self.VC];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationConfession:) name:@"UpDataChatSelect" object:nil];
    
}


-(void)addTitleData{

    WeakSelf;
    [NetworkRequest POST:Request_GetRoomPartition parmeters:nil success:^(id responObject) {
        BaseModel *basemodel=(BaseModel *)responObject;
        [wself.dataArr addObject:@{@"id":@"0",@"pid":@"0",@"name":@"推荐",@"image":@"",@"children":@[@{@"id":@"0",@"name":@"推荐"},@{@"id":@"666",@"name":@"我的收藏"}]}];
        [wself.dataArr addObjectsFromArray:basemodel.data];
        for (NSDictionary *dic in self.dataArr) {
            [wself.titleArr addObject:dic[@"name"]];
        }
        [wself addView];

    } failture:^(NSError *error) {
        [wself addView];

    }];

}


@end
