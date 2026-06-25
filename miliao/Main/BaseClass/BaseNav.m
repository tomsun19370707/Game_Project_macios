//
//  BaseNav.m
//  templateDemo
//
//  Created by 李东阳 on 2019/1/18.
//  Copyright © 2019年 锤子科技. All rights reserved.
//

#import "BaseNav.h"
@interface BaseNav ()<UIGestureRecognizerDelegate>
@end

@implementation BaseNav

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 隐藏系统导航*/
    self.navigationBar.hidden = YES ;
    /** 打开滑动返回手势*/
//    self.fd_fullscreenPopGestureRecognizer.enabled = YES ;
    /** iOS13的坑*/
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    
    // Do any additional setup after loading the view.
}

// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}
- (void)panGesture:(UIPanGestureRecognizer *)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStateEnded:{
            break;
        }
            
        default:
            break;
    }
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    DLog(@"%d",self.viewControllers.count);
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [super popViewControllerAnimated:YES];
    if (self.viewControllers.count) {
        
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
