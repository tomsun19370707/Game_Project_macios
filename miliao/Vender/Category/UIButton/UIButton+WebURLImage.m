//
//  UIButton+WebURLImage.m
//  FaceShow
//
//  Created by skyz on 2018/1/26.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import "UIButton+WebURLImage.h"

@implementation UIButton (WebURLImage)
- (void)setURLImageWith:(NSString *)urlString PlaceHolderImageStr:(NSString *)placeHolderStr{
   NSString * urlStr;
   if ([urlString hasPrefix:@"http"]) {
      urlStr = urlString;

   }else{
      urlStr = [NSString stringWithFormat:@"%@%@",VERSION_HTTPS_SERVER,urlString];
   }
   [self setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:placeHolderStr]];
}
- (void)setURLImageWiths:(NSURL *)urlString PlaceHolderImageStr:(NSString *)placeHolderStr{
   [self setImageForState:UIControlStateNormal withURL:urlString placeholderImage:[UIImage imageNamed:placeHolderStr]];
}
@end
