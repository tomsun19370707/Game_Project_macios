//
//  ZXTabBarController.m
//  ZXTabBarController
//
//  Created by Jackey on 2016/12/14.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "ZXTabBarController.h"
#import "EMO_HomeBaseViewController.h"
#import "EMO_ChatViewController.h"
#import "EMO_MessageTwoViewController.h"
#import "EMO_DynamicBaseViewController.h"
#import "CFMMineVc.h"
#import "CFMHomeVc.h"

#import "EMO_MineViewController.h"
#import "ZXNavigationController.h"
#import "ZXTabBar.h"
@interface ZXTabBarController () <ZXTabBarDelegate>

@end

@implementation ZXTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    //设置子视图控制器
    [self setupChildViewControllers];
    
    //替换TabBar
    ZXTabBar *zxTabBar = [[ZXTabBar alloc] init];
    [self setValue:zxTabBar forKeyPath:@"tabBar"];
    [self getUserInfoMessage];
    
    [ObjectTool SharedSettings].isAllowAlertShow = YES ;
}

#pragma mark - 设置子视图控制器方法
- (void)setupChildViewControllers {
    
    //添加子视图控制器
//    [self addChildVc:[[EMO_HomeBaseViewController alloc] init]
//               title:getLanguage(@"首页")
//               Image:@"homeTabDefaultImg"
//       selectedImage:@"homeTabSelectImg"];
    [self addChildVc:[[CFMHomeVc alloc] init]
               title:getLanguage(@"首页")
               Image:@"homeTabDefaultImg"
       selectedImage:@"homeTabSelectImg"];
    
//    [self addChildVc:[[EMO_ChatViewController alloc] init]
//               title:getLanguage(@"聊天室")
//               Image:@"chatTabDefaultImg"
//       selectedImage:@"chatTabSelectImg"]; 
    
    [self addChildVc:[[EMO_DynamicBaseViewController alloc] init]
               title:getLanguage(@"社区")
               Image:@"dynamicDefaultImg"
       selectedImage:@"dynamicSelectImg"];
    
    [self addChildVc:[[EMO_MessageTwoViewController alloc] init]
               title:getLanguage(@"消息")
               Image:@"msgDefaultImg"
       selectedImage:@"msgSelectImg"];
    
    [self addChildVc:[[CFMMineVc alloc] init]
               title:getLanguage(@"我的")
               Image:@"mineDefaultImg"
       selectedImage:@"mineSelectImg"];
    
//    [self addChildVc:[[EMO_MineViewController alloc] init]
//               title:getLanguage(@"我的")
//               Image:@"mineDefaultImg"
//       selectedImage:@"mineSelectImg"];
    
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title Image:(NSString *)image
     selectedImage:(NSString *)selectedImage {
    
    //设置子控制器
    childVc.title = title;
    childVc.tabBarItem.title = title;
    
    [childVc.tabBarItem setImage:[[UIImage imageNamed:image]
          imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [childVc.tabBarItem setSelectedImage:[[UIImage imageNamed:selectedImage]
                  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [childVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:HexColorDy(@"#888888") forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:HexColorDy(@"#333333") forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    
    
    //初始化ZXNavigationController
    ZXNavigationController *navController = [[ZXNavigationController alloc] initWithRootViewController:childVc];
    
    [self addChildViewController:navController];
}

#pragma mark - ZXTabBarDelegate method
- (void)tabBarDidClickPlusButton:(ZXTabBar *)tabBar {
    
    NSLog(@"点击了加号按钮");
    
    
    
}

#pragma mark 获取用户数据
- (void)getUserInfoMessage{
    [NetworkRequest POST:Request_UserInfo parmeters:nil success:^(id responObject) {
        BaseModel *baseModel = (BaseModel *)responObject;
        NSLog(@"%@",baseModel.data);
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:baseModel.data];
        if([dic.allKeys containsObject:@"avatar_frame_image"]){
            [dic setObject:@(YES) forKey:@"is_zb"];
        }else{
            [dic setObject:@(NO) forKey:@"is_zb"];
        }
        [UserManager saveUserInfo:dic];
    } failture:^(NSError *error) {
        
    }];
}
@end
