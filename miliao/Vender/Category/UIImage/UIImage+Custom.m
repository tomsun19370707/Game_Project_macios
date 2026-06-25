//
//  UIImage+Custom.m
//  FaceShow
//
//  Created by skyz on 2018/6/15.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import "UIImage+Custom.h"

@implementation UIImage (Custom)
- (UIImage *)redraw{
   CGFloat width = CGImageGetWidth(self.CGImage);
   CGFloat height = CGImageGetHeight(self.CGImage);

   // 创建一个bitmap的context
   // 并把它设置成为当前正在使用的context
   UIGraphicsBeginImageContext(CGSizeMake(width, height));

   // 绘制图片大小设置
   [self drawInRect:CGRectMake(0, 0, width, height)];

   // 从当前context中创建一个图片
   UIImage* image = UIGraphicsGetImageFromCurrentImageContext();

   // 使当前的context出堆栈
   UIGraphicsEndImageContext();

   // 返回新的改变大小后的图片
   return image;
}
@end
