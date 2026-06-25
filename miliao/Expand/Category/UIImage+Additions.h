//
//  UIImage+Additions.h
//  GoldCow
//
//  Created by haiwei on 15/6/1.
//  Copyright (c) 2015年 ddsfsdfsd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (Additions)

+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIImage *)imageByCropToRect:(CGRect)rect;



///**
// 返回一个gif图片
//
// @param data 二进制数据
// */
//+ (UIImage *)sd_animatedGIFWithData:(NSData *)data;


/**
 返回一个gif图片

 @param name 本地的gif名称(不需要后缀)
 */
+ (UIImage *)sd_animatedGIFNamed:(NSString *)name;
+ (UIImage *)xy_getVideoThumbnail:(NSString *)filePath;
@end
