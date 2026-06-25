//
//  ZXNavigationController.m
//  ZXTabBarController
//
//  Created by Jackey on 2016/12/14.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "ZXNavigationController.h"
#import "UIImage+Image.h"

//黄色导航栏
#define NavBarColor [UIColor colorWithRed:250/255.0 green:227/255.0 blue:111/255.0 alpha:1.0]

@interface ZXNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation ZXNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:NavBarColor]
                             forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor blackColor], NSForegroundColorAttributeName,
                                        [UIFont systemFontOfSize:15], NSFontAttributeName, nil]];

}


- (instancetype)init{
    self = [super init];
    if (self) {
        self.minControllerCount = 1;
        self.interactivePopGestureRecognizer.delegate = self;
        
    }
    return self;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.viewControllers.count <= self.minControllerCount) {
        return NO;
    }
    return YES;
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if (self.viewControllers.firstObject) {
//        if (self.viewControllers.firstObject != viewController) {
//            viewController.hidesBottomBarWhenPushed = YES;
//        }
//    }
//    [super pushViewController:viewController animated:animated];
//}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    return  [super popViewControllerAnimated:animated];
}


@end
