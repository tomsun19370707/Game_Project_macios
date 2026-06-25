//
//  UIImageView+WebURLImage.m
//  FaceShow
//
//  Created by skyz on 2018/1/26.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import "UIImageView+WebURLImage.h"
#import "UIImageView+AFNetworking.h"
#import "SDWebImage/UIImageView+WebCache.h"
@implementation UIImageView (WebURLImage)
- (void)setURLImageWith:(NSString *)urlString PlaceHolderImageStr:(NSString *)placeHolderStr{
   if ([urlString hasPrefix:@"http"]) {
      [self setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:placeHolderStr]];

   }else{
      NSString * urlStr = [NSString stringWithFormat:@"%@%@",VERSION_HTTPS_SERVER,urlString];
      
      [self setURLImageWith:urlStr PlaceHolderImageStr:placeHolderStr];
   }
}
-(void)addBorder{
    self.layer.borderWidth = 3.0f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
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
- (void)setURLImagewithSize:(CGSize)imageVSize urlStr:(NSString *)urlStr PlaceHolderImageStr:(NSString *)placeHolderStr{
   [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:placeHolderStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      //将图片裁剪
      if (image) {
         NSLog(@"%@",NSStringFromCGSize(image.size));
         //定义裁剪的区域相对于原图片的位置
         CGFloat x= 0;
         CGFloat height = (double)imageVSize.height/kHeight * image.size.height;
         CGFloat width = image.size.width;
         CGFloat y = (image.size.height - height )/2;
         CGRect subImageRect = CGRectMake(x, y,width,height);
         CGImageRef imageRef = image.CGImage;
         CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
         UIGraphicsBeginImageContext(imageVSize);
         CGContextRef context = UIGraphicsGetCurrentContext();
         CGContextDrawImage(context, subImageRect, subImageRef);
         UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
         UIGraphicsEndImageContext();
         self.image = subImage;
      }
   }];
}
@end
