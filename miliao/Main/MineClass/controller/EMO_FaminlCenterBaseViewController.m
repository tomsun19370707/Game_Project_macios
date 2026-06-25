//
//  EMO_FaminlCenterBaseViewController.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/4.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_FaminlCenterBaseViewController.h"
#import "EMO_FaminlCenterViewController.h"
#import "EMO_FamilyCenterHeadView.h"
#import "EMO_EditFamilyCenterVC.h"//编辑公会资料
#import "EMO_FamilyCenterPeoplesVC.h"//公会成员
#import "EMO_FamilyCenterDetailsOfIncomeVC.h"//收益明细
@interface EMO_FaminlCenterBaseViewController ()
@property (nonatomic,strong)WMZPageController *VC;
@property (nonatomic,strong)EMO_FamilyCenterHeadView *headView;
@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,strong)NSMutableArray *titleArr;
@end

@implementation EMO_FaminlCenterBaseViewController
-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr=[NSMutableArray array];
    }
    return _titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBA(255, 255, 255, 1);
    [self loadBar:YES needBack:YES needBackground:YES];
    self.barView.backgroundColor=kClearColor;
    self.titleLabel.text=getLanguage(@"家族中心");
    self.titleLabel.font=KFont(18);
    [self loadData];
    
}


-(void)setUI:(NSDictionary *)dic{
    
    WeakSelf;
        //标题数组
    if(self.titleArr.count<1){
        self.dataArr=[NSMutableArray arrayWithArray:@[@"申请入驻",@"退会申请"]];
    }
        //控制器数组
        NSMutableArray *vcArr = [NSMutableArray new];
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EMO_FaminlCenterViewController *vc = [EMO_FaminlCenterViewController new];
            vc.index = idx;
        vc.familyID=[Common isNull:dic[@"id"]];
            [vcArr addObject:vc];
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
    .wTopChangeHeightSet(-KAdaptedHeight(600))
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

            self.headView=[[EMO_FamilyCenterHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth, KAdaptedHeight(350))];
            self.headView.dicData=dic;
            self.headView.SenderBlock = ^(NSInteger tag) {
                if(tag==100){
                    EMO_EditFamilyCenterVC *vc=[EMO_EditFamilyCenterVC new];
                    vc.dicData=dic;
                    vc.changeBlock = ^(NSMutableDictionary * _Nonnull dic) {
                        wself.headView.dicData=dic;
                    };
                    [wself.navigationController pushViewController:vc animated:YES];
                    
                }else if(tag ==200){
                    EMO_FamilyCenterDetailsOfIncomeVC *vc=[EMO_FamilyCenterDetailsOfIncomeVC new];
                    vc.type=1;
                    vc.FamilyID=[Common isNull:dic[@"id"]];
                    [wself.navigationController pushViewController:vc animated:YES];
                }
                else{
                    EMO_FamilyCenterPeoplesVC *vc=[EMO_FamilyCenterPeoplesVC new];
                    vc.familyID=[Common isNull:dic[@"id"]];
                    [wself.navigationController pushViewController:vc animated:YES];
                }
                
            };

            return self.headView;
        });
        
    self.VC =  [WMZPageController new];
    self.VC.view.frame=CGRectMake(0,0, kWidth, kHeight);
    self.VC.param = param;
    self.VC.pageView.backgroundColor=kClearColor;
    self.VC.downSc.backgroundColor=kClearColor;
    self.VC.view.backgroundColor=kClearColor;
    [self.view addSubview:self.VC.view];
    [self addChildViewController:self.VC];
    
    
    [self.view insertSubview:self.barView aboveSubview:self.VC.view];
    
}



-(void)loadData{
    WeakSelf;
    [NetworkRequest POST:Request_MyFamily parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        [wself setUI:baseModel.data];
    } failture:^(NSError *error) {
    
    }];
    
    
    
}






@end
