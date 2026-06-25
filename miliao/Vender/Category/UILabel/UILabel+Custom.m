//
//  UILabel+Custom.m
//  FaceShow
//
//  Created by skyz on 2018/3/14.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import "UILabel+Custom.h"

@implementation UILabel (Custom)
#pragma mark -- 点击昵称进入个人中心
-(void)pushToPersonVCWith:(NSString *)accountStr{
//   self.userInteractionEnabled = YES;
//   UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
////      UIViewController * vc = [self currentViewController];
////      PersonShowViewController * personShowVC  = [[PersonShowViewController alloc]init];
////      //自己的个人中心
////      if (accountStr == nil) {
////         personShowVC.userId = [[UserHelp shareHelp] getLocalModel].userId;
////      }else{
////         //别人的个人中心
////         personShowVC.account = [[UserHelp shareHelp] getLocalModel].userId;
////         personShowVC.userId = accountStr;
////      }
////      [vc.navigationController pushViewController:personShowVC animated:YES];
//       [PushToViewController pushToPersonShowVCWith:accountStr persionType:0];
//   }];
//   //跳转个人主页
//   [self addGestureRecognizer:tap];
}
- (UIViewController*)currentViewController{
   //获得当前活动窗口的根视图
   UIViewController* vc = [UIApplication sharedApplication].windows.firstObject.rootViewController;
   while (1)
   {
      //根据不同的页面切换方式，逐步取得最上层的viewController
      if ([vc isKindOfClass:[UITabBarController class]]) {
         vc = ((UITabBarController*)vc).selectedViewController;
      }
      if ([vc isKindOfClass:[UINavigationController class]]) {
         vc = ((UINavigationController*)vc).visibleViewController;
      }
      if (vc.presentedViewController) {
         vc = vc.presentedViewController;
      }else{
         break;
      }
   }
   return vc;
}
#pragma mark -- label设置半角
- (void)setBorderWithCornerRadius:(CGFloat)cornerRadius
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(UIColor *)borderColor
                             type:(UIRectCorner)corners {

   //    UIRectCorner type = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;

   //1. 加一个layer 显示形状
   CGRect rect = CGRectMake(borderWidth/2.0, borderWidth/2.0,
                            CGRectGetWidth(self.frame)-borderWidth, CGRectGetHeight(self.frame)-borderWidth);
   CGSize radii = CGSizeMake(cornerRadius, borderWidth);

   //create path
   UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];

   //create shape layer
   CAShapeLayer *shapeLayer = [CAShapeLayer layer];
   shapeLayer.strokeColor = borderColor.CGColor;
   shapeLayer.fillColor = [UIColor clearColor].CGColor;

   shapeLayer.lineWidth = borderWidth;
   shapeLayer.lineJoin = kCALineJoinRound;
   shapeLayer.lineCap = kCALineCapRound;
   shapeLayer.path = path.CGPath;

   [self.layer addSublayer:shapeLayer];




   //2. 加一个layer 按形状 把外面的减去
   CGRect clipRect = CGRectMake(0, 0,
                                CGRectGetWidth(self.frame)-1, CGRectGetHeight(self.frame)-1);
   CGSize clipRadii = CGSizeMake(cornerRadius, borderWidth);
   UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:clipRect byRoundingCorners:corners cornerRadii:clipRadii];

   CAShapeLayer *clipLayer = [CAShapeLayer layer];
   clipLayer.strokeColor = borderColor.CGColor;
   shapeLayer.fillColor = [UIColor clearColor].CGColor;

   clipLayer.lineWidth = 1;
   clipLayer.lineJoin = kCALineJoinRound;
   clipLayer.lineCap = kCALineCapRound;
   clipLayer.path = clipPath.CGPath;

   self.layer.mask = clipLayer;
}
@end
