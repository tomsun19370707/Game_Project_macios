//
//  EMO_DressingCenterBaseVC.m
//  miliao
//
//  Created by 张世浩 on 2022/12/1.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "EMO_DressingCenterBaseVC.h"
#import "EMO_DressingCenterViewController.h"
#import "EMO_DressingCenterHeadView.h"

@interface EMO_DressingCenterBaseVC ()
@property (nonatomic,strong)WMZPageController *VC;
@property (nonatomic,strong)NSMutableArray *titleArr;
@property (nonatomic,strong)EMO_DressingCenterHeadView *headViewA;
@end

@implementation EMO_DressingCenterBaseVC
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
//    [self loadBar:YES needBack:YES needBackground:YES];
//    self.barView.backgroundColor=kClearColor;
//    self.titleLabel.text=getLanguage(@"装扮中心");
//    self.titleLabel.font=KFont(18);
    if(self.type==2){
        self.titleArr=[NSMutableArray arrayWithArray:@[getLanguage(@"头像框"),getLanguage(@"进场特效"),getLanguage(@"坐骑"),getLanguage(@"靓号")]];
    }else{
        self.titleArr=[NSMutableArray arrayWithArray:@[getLanguage(@"头像框"),getLanguage(@"靓号"),getLanguage(@"进场特效"),getLanguage(@"坐骑")]];
    }
    
    [self addView];
    
    
}
//-(void)rightButtonClick:(UIButton *)sender{
//    if(self.type==1){
//        EMO_DressingCenterBaseVC *vc=[EMO_DressingCenterBaseVC new];
//        vc.type=2;
//        [self.navigationController pushViewController:vc animated:YES];
//    }

//}


-(void)addView{
    WeakSelf;
    WMZPageParam *param = PageParam();
    param.wTitleArrSet(self.titleArr)
    .wViewControllerSet(^UIViewController *(NSInteger index) {
        EMO_DressingCenterViewController *vc = [EMO_DressingCenterViewController new];
        if(self.type==2){
            vc.index = index+1;
        }else{
            vc.index = index;
        }
             vc.type=wself.type;
             return vc;
     })
    .wMenuTitleColorSet(PageDarkColor(RGBA(102, 102, 102, 1), RGBA(102, 102, 102, 1)))
    .wMenuTitleSelectColorSet(PageDarkColor(RGBA(51, 51, 51, 1), RGBA(51, 51, 51, 1)))
    .wMenuIndicatorColorSet(PageDarkColor(RGBA(255, 198, 0, 1),RGBA(255, 198, 0, 1)))
    .wMenuBgColorSet([UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00])
    .wBgColorSet([UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00])
    .wMenuPositionSet(PageMenuPositionNavi)
//    是否开启渐变色
//    .wMenuAnimalTitleGradientSet(NO)
//     菜单标题的位置
    .wMenuPositionSet(PageMenuPositionLeft)
    // 字体大小
    .wMenuTitleUIFontSet(KFont(14))
//    选中的字体大小
    .wMenuTitleSelectUIFontSet(KFontBold(15))
//    指示器位置
    .wMenuIndicatorYSet(17)
    
    //头部
    .wMenuHeadViewSet(^UIView *{
        self.headViewA=[[EMO_DressingCenterHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, KAdaptedHeight(220))];
        self.headViewA.backgroundColor=[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
        self.headViewA.type=self.type;
        return self.headViewA;
    })
    .wMenuAnimalSet(PageTitleMenuLine);
    self.VC =  [WMZPageController new];
  
    self.VC.view.frame=CGRectMake(0,0, kWidth, kHeight-TabBar_H+KAdaptedHeight(25));
    self.VC.param = param;
    [self.view addSubview:self.VC.view];
    [self addChildViewController:self.VC];
}


-(void)addTitleData{
    
    
//    网络请求获取头数据
    ///获取推荐房间类型
//    [self.dataArr removeAllObjects];
//    [self.titleArr removeAllObjects];
    
//        WeakSelf;
//    [HttpTool getRoom_recommend_categoriesWithParameters:nil success:^(id response) {
//        if ([response[@"code"] intValue] == 1) {
//            [wself.dataArr addObject:@{@"id":@"0",@"name":getLanguage(@"热门")}];
//            [wself.dataArr addObjectsFromArray:response[@"data"]];
//            for (NSDictionary *dic in self.dataArr) {
//                [wself.titleArr addObject:dic[@"name"]];
//            }
//            [wself addView];
//        }
//    } failure:^(NSError *error) {
//        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"网络请求失败,请稍后再试")];
//    }];
    
//    self.titleArr=[NSMutableArray arrayWithArray:@[@"热门",@"男生",@"女生",@"交友"]];
//
//    [self addView];
}


@end
