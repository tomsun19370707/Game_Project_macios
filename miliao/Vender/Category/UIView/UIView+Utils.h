//
//  UIView+Utils.h
//  MobileMap
//
//  Created by damingdan on 14/11/17.
//  Copyright (c) 2014年 Kingoit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Utils)
- (void) roundCornerWithBorderWidth:(CGFloat) width cornerRadius:(CGFloat) radius borderColor:(UIColor*) color;


/** Loads an instance from the Nib named like the class. Returns the first root object of the Nib. */
+ (id) loadFromNib;

- (void) renderInnerShadow;
@end


@interface UIView(FindViewThatIsFirstResponder)
- (UIView *)findViewThatIsFirstResponder;
@end