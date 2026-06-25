//
//  UITextView+Placeholder.h
//  miliao
//
//  Created by aa on 2019/7/12.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT double UITextView_PlaceholderVersionNumber;
FOUNDATION_EXPORT const unsigned char UITextView_PlaceholderVersionString[];
@interface UITextView (Placeholder)
@property (nonatomic, readonly) UILabel *placeholderLabel;
@property (nonatomic, strong) IBInspectable NSString *placeholderT;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;
+(UIColor *)defaultPlaceholderColor;
@end

NS_ASSUME_NONNULL_END
