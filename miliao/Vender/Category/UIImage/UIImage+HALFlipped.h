//
//  UIImage+HALFlipped.h
//  NormalProject
//
//  Created by 大靠山Mac mini on 2021/10/8.
//  Copyright © 2021 WYL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (HALFlipped)
- (UIImage *)hal_imageFlippedForRightToLeftLayoutDirection;
@end

NS_ASSUME_NONNULL_END
