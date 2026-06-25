//
//  UIImageView+WebURLImage.h
//  FaceShow
//
//  Created by skyz on 2018/1/26.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WebURLImage)
- (void)setURLImageWith:(NSString *)urlString PlaceHolderImageStr:(NSString *)placeHolderStr;
//添加边框
-(void)addBorder;





/*
 含义：裁剪网络图片
 @param imageVSize 图片大小
 @param urlStr 图片网络地址
 @param placeHolderStr 占位图片

 */

- (void)setURLImagewithSize:(CGSize)imageVSize urlStr:(NSString *)urlStr PlaceHolderImageStr:(NSString *)placeHolderStr;


@end
