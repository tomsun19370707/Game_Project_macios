//
//  UISearchBar+custom.h
//  miliao
//
//  Created by aa on 2019/7/27.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISearchBar (custom)
- (void)fm_setCancelButtonTitle:(NSString *)title;
- (void)fm_setTextColor:(UIColor *)textColor;
- (void)fm_setTextFont:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
