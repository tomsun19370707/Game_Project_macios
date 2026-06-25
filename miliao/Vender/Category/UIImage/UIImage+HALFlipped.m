//
//  UIImage+HALFlipped.m
//  NormalProject
//
//  Created by 大靠山Mac mini on 2021/10/8.
//  Copyright © 2021 WYL. All rights reserved.
//

#import "UIImage+HALFlipped.h"

@implementation UIImage (HALFlipped)
- (UIImage *)hal_imageFlippedForRightToLeftLayoutDirection
{
    if (isRTL()) {
        return [UIImage imageWithCGImage:self.CGImage
                                   scale:self.scale
                             orientation:UIImageOrientationUpMirrored];
    }else{
        return [UIImage imageWithCGImage:self.CGImage
                                   scale:self.scale
                             orientation:UIImageOrientationUp];
    }

    return self;
}
@end
