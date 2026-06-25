//
//  UIButton+WebURLImage.h
//  FaceShow
//
//  Created by skyz on 2018/1/26.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+AFNetworking.h"
@interface UIButton (WebURLImage)
- (void)setURLImageWith:(NSString *)urlString PlaceHolderImageStr:(NSString *)placeHolderStr;
- (void)setURLImageWiths:(NSURL *)urlString PlaceHolderImageStr:(NSString *)placeHolderStr;
@end
