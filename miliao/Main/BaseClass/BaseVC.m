//
//  BaseVC.m
//  templateDemo
//
//  Created by 李东阳 on 2019/1/18.
//  Copyright © 2019年 锤子科技. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DLog(@"\nWillAppear-----%lu------rrrrrr\n",(unsigned long)self.navigationController.viewControllers.count);
    if (self.navigationController.viewControllers.count == 1) {
        /** 自动隐藏tabBar栏*/
        [self.navigationBar hideLeftBackButton:YES];
    }else{
        
    }
    
    /** 设置statusBar颜色*/
    [DeviceOpinion setBarStyle:Dark];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.navigationController) {
        /** 记录当前正在显示的控制器*/
        ObjectTool *set = [ObjectTool SharedSettings];
        set.currentVC = self ;
    }
    /** 前置*/
    [self.view bringSubviewToFront:self.navigationBar];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    /** 初始化*/
    [self initBaseContentView];
    /** iOS13的坑*/
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    //强行设置App模式为白天模式
    if (@available(iOS 13.0, *)) {
        // 设置为Dark Mode即可
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
    }
    /** 隐藏系统导航*/
    self.navigationController.navigationBar.hidden = YES ;
    
    // Do any additional setup after loading the view.
}
#pragma mark --- 初始化页面传
- (void)initBaseContentView
{
    /** 初始化导航条*/
    [self initCusNav];
    self.view.backgroundColor = LineColor;
}

#pragma mark --- pop
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 自定义导航条
- (void)initCusNav
{
    self.navigationBar = [[BaseNavBar alloc]init];
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.subNaviTitle];
    [self.view addSubview:self.secondTitle];
    /** 默认不显示导航栏底部分割线*/
    self.navigationBar.isShowCuttingLine = NO ;
    
    @weakify(self);
    [[self.navigationBar.leftTouchBack rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self back];
    }];
    
    //取消键盘
    [self clickTableViewHideKyeboard];
}
#pragma mark --
#pragma mark --- Getter
- (UILabel *)subNaviTitle
{
    if (!_subNaviTitle) {
        _subNaviTitle = [UILabel LabelWithFrame:CGRectMake(28, self.navigationBar.bottom + 25, SCREEN_WIDTH - 28, 40.0) fontSize:25 textColor:[UIColor blackColor] textAlient:NSTextAlignmentLeft numberLines:1];
        _subNaviTitle.font = [UIFont boldSystemFontOfSize:28.0];
        _subNaviTitle.backgroundColor = [UIColor clearColor];
    }
    return _subNaviTitle ;
}
- (UILabel *)secondTitle
{
    if (!_secondTitle) {
        _secondTitle = [UILabel LabelWithFrame:CGRectMake(28, self.subNaviTitle.bottom + 5, SCREEN_WIDTH - 28, 40.0) fontSize:14 textColor:HexColorDy(@"0x999999") textAlient:NSTextAlignmentLeft numberLines:1];
        _secondTitle.font = [UIFont systemFontOfSize:14];
        _secondTitle.backgroundColor = [UIColor clearColor];
    }
    return  _secondTitle ;
}
#pragma mark --
#pragma mark --- Method
/** 分页数据加载*/
- (void)refreshPagingDataWithType:(RefreshType)refreshType  Scroll:(UIScrollView *)scroll
{
    
}
/** 状态栏颜色*/
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

#pragma mark - View rotation
- (BOOL)shouldAutorotate {
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

/** 从栈中移出当前控控制器*/
- (void)dismissDetailVC:(void(^)(void))completion
{
    NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];
    /** 移出当前的，最后一个*/
    [newArray removeLastObject];
    if (newArray.count) {
        [self.navigationController setViewControllers:newArray animated:NO];
    }
    
    if (completion) {
        [ObjectTool performSelectorAfterDelay:0.3 completion:^{
            completion();
        }];
    }
}

//取消键盘
-(void)clickTableViewHideKyeboard
{
  
        UITapGestureRecognizer *gestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeboard)];
        gestureR.delegate = self;
        [self.view addGestureRecognizer:gestureR];
        
        gestureR.cancelsTouchesInView = NO;
    
    
    
}
- (void)hideKeboard{
  
  [self.view endEditing:YES];
  
}
@end
