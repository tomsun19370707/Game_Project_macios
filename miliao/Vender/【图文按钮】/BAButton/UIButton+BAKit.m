//
//  UIButton+BAKit.m
//  BAButtonDemo
//
//  Created by boai on 2017/5/17.
//  Copyright © 2017年 博爱之家. All rights reserved.
//

#import "UIButton+BAKit.h"
#import <objc/runtime.h>
#import "BAKit_ConfigurationDefine.h"


@implementation UIButton (BAKit)

- (void)setupBAButtonLayout {
    if (self.ba_buttonLayoutType == BAKit_ButtonLayoutTypeDefault) {
        return;
    }
    CGFloat image_w = self.imageView.bounds.size.width;
    CGFloat image_h = self.imageView.bounds.size.height;
    
    CGFloat title_w = self.titleLabel.bounds.size.width;
    CGFloat title_h = self.titleLabel.bounds.size.height;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        title_w = self.titleLabel.intrinsicContentSize.width;
        title_h = self.titleLabel.intrinsicContentSize.height;
    }
    
    UIEdgeInsets imageEdge = UIEdgeInsetsZero;
    UIEdgeInsets titleEdge = UIEdgeInsetsZero;
    
    if (self.ba_padding_inset == 0) {
        self.ba_padding_inset = 5;
    }
    
    switch (self.ba_buttonLayoutType) {
        case BAKit_ButtonLayoutTypeNormal: {
            titleEdge = UIEdgeInsetsMake(0, self.ba_padding, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, 0, 0, self.ba_padding);
        }
            break;
        case BAKit_ButtonLayoutTypeCenterImageRight: {
            titleEdge = UIEdgeInsetsMake(0, -image_w - self.ba_padding, 0, image_w);
            imageEdge = UIEdgeInsetsMake(0, title_w + self.ba_padding, 0, -title_w);
        }
            break;
        case BAKit_ButtonLayoutTypeCenterImageTop: {
            titleEdge = UIEdgeInsetsMake(0, -image_w, -image_h - self.ba_padding, 0);
            imageEdge = UIEdgeInsetsMake(-title_h - self.ba_padding, 0, 0, -title_w);
        }
            break;
        case BAKit_ButtonLayoutTypeCenterImageBottom: {
            titleEdge = UIEdgeInsetsMake(-image_h - self.ba_padding, -image_w, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, 0, -title_h - self.ba_padding, -title_w);
        }
            break;
        case BAKit_ButtonLayoutTypeLeftImageLeft: {
            titleEdge = UIEdgeInsetsMake(0, self.ba_padding + self.ba_padding_inset, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, self.ba_padding_inset, 0, 0);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
            break;
        case BAKit_ButtonLayoutTypeLeftImageRight: {
            titleEdge = UIEdgeInsetsMake(0, -image_w + self.ba_padding_inset, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, title_w + self.ba_padding + self.ba_padding_inset, 0, 0);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
            break;
        case BAKit_ButtonLayoutTypeRightImageLeft: {
            imageEdge = UIEdgeInsetsMake(0, 0, 0, self.ba_padding + self.ba_padding_inset);
            titleEdge = UIEdgeInsetsMake(0, 0, 0, self.ba_padding_inset);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
            break;
        case BAKit_ButtonLayoutTypeRightImageRight: {
            titleEdge = UIEdgeInsetsMake(0, 0, 0, image_w + self.ba_padding + self.ba_padding_inset);
            imageEdge = UIEdgeInsetsMake(0, 0, 0, -title_w + self.ba_padding_inset);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
            break;
            
        default:
            break;
    }
    self.imageEdgeInsets = imageEdge;
    self.titleEdgeInsets = titleEdge;
}

#pragma mark - 快速创建 button

/**
 UIButton：快速设置 button 的布局样式 和 间距
 
 @param type button 的布局样式
 @param padding 文字与图片之间的间距
 */
- (void)ba_button_setButtonLayoutType:(BAKit_ButtonLayoutType)type padding:(CGFloat)padding {
    self.ba_buttonLayoutType = type;
    self.ba_padding = padding;
}




#pragma mark - setter / getter
- (void)setBa_buttonLayoutType:(BAKit_ButtonLayoutType)ba_buttonLayoutType {
    BAKit_Objc_setObj(@selector(ba_buttonLayoutType), @(ba_buttonLayoutType));
    [self setupBAButtonLayout];
}

- (BAKit_ButtonLayoutType)ba_buttonLayoutType {
    return [BAKit_Objc_getObj integerValue];
}

- (void)setBa_padding:(CGFloat)ba_padding {
    BAKit_Objc_setObj(@selector(ba_padding), @(ba_padding));
    [self setupBAButtonLayout];
}

- (CGFloat)ba_padding {
    return [BAKit_Objc_getObj floatValue];
}

- (void)setBa_padding_inset:(CGFloat)ba_padding_inset {
    BAKit_Objc_setObj(@selector(ba_padding_inset), @(ba_padding_inset));
    [self setupBAButtonLayout];
}

- (CGFloat)ba_padding_inset {
    return [BAKit_Objc_getObj floatValue];
}

- (void)setBa_buttonActionBlock:(BAKit_UIButtonActionBlock)ba_buttonActionBlock {
    [self addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    BAKit_Objc_setObj(@selector(ba_buttonActionBlock), ba_buttonActionBlock);
}

- (BAKit_UIButtonActionBlock)ba_buttonActionBlock {
    return BAKit_Objc_getObj;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];

    if (self.ba_buttonLayoutType == BAKit_ButtonLayoutTypeDefault) {
        return;
    }
    [self setupBAButtonLayout];
}

@end

