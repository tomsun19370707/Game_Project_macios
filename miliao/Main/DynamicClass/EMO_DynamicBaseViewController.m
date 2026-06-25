//
//  EMO_DynamicBaseViewController.m
//  miliao
//
//  Created by 张世浩 on 2023/6/17.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_DynamicBaseViewController.h"
#import "EMO_DynamicViewController.h"
#import "EMO_SendDynamicViewController.h"//发布动态

#import "RoomFloatingWindow.h"

@interface EMO_DynamicBaseViewController ()
Strong UIImageView *topBgImgView;
@property (nonatomic,strong)WMZPageController *VC;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *titleArr;
Strong UIButton *sendBtn;

@end

@implementation EMO_DynamicBaseViewController
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
    [self sendBtn];
    
}

- (UIImageView*)topBgImgView{
    if (!_topBgImgView) {
        _topBgImgView = [[UIImageView alloc] init];
        _topBgImgView.image=KGetImage(@"mineHeadBgImg");
        [self.view addSubview:_topBgImgView];
        [_topBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(KAdaptedWidth(0));
            make.height.mas_equalTo(KAdaptedHeight(100));
        }];
    }
    return _topBgImgView;
}


- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_sendBtn setImage:[UIImage imageNamed:@"sendImg"] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_sendBtn];
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          
            make.trailing.mas_equalTo(KAdaptedWidth(-10));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(40), KAdaptedWidth(40)));
            make.top.mas_equalTo(ZJTopNavH-KAdaptedHeight(15));
        }];
    }
    return _sendBtn;
}

-(void)BtnClick{
    [self.navigationController pushViewController:[EMO_SendDynamicViewController new] animated:YES];
}


-(void)addView{
    
    WMZPageParam *param = PageParam();
    param.wTitleArrSet(self.titleArr)
    .wViewControllerSet(^UIViewController *(NSInteger index) {
        EMO_DynamicViewController *vc = [EMO_DynamicViewController new];
         vc.index = index;
         return vc;
     })
    .wMenuTitleSelectColorSet(PageDarkColor(RGBA(34, 34, 34, 1), RGBA(34, 34, 34, 1)))
//    .wMenuIndicatorColorSet(PageDarkColor(RGBA(255, 198, 0, 1),RGBA(255, 198, 0, 1)))
    .wMenuIndicatorColorSet(BaseMainColor)
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
}


-(void)addTitleData{
//    网络请求获取头数据
    ///获取推荐房间类型

    
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
    
    self.titleArr=[NSMutableArray arrayWithArray:@[getLanguage(@"关注"),getLanguage(@"推荐")]];
    [self addView];
}


@end
