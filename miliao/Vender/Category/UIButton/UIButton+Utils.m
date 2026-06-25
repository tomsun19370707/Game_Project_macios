//
//  UIButton+Utils.m
//  ButtonTextImagePositionDemo
//
//  Created by yanjiuyuan on 2019/4/3.
//  Copyright © 2019 yanjiuyuan. All rights reserved.
//

#import "UIButton+Utils.h"

@implementation UIButton (Utils)

- (void)setupImageTopTitleBottom {
    CGSize imageSize = self.imageView.bounds.size;
    CGSize titleSize = self.titleLabel.bounds.size;
    
    UIEdgeInsets titleInsets = UIEdgeInsetsZero;
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    switch (self.contentHorizontalAlignment) {
        case UIControlContentHorizontalAlignmentCenter:
            titleInsets.left = -imageSize.width / 2;
            titleInsets.right = imageSize.width / 2;
            imageInsets.left = titleSize.width / 2;
            imageInsets.right = -titleSize.width / 2;
            break;
        case UIControlContentHorizontalAlignmentLeft:
        case UIControlContentHorizontalAlignmentLeading: {
            // target distance between {the center x of both title and image} and {the left edge of both title and image}
            CGFloat centerXToLeft = MAX(imageSize.width, titleSize.width) / 2;
            CGFloat titleLeftInset = centerXToLeft - titleSize.width / 2 - imageSize.width;
            titleInsets.left = titleLeftInset;
            titleInsets.right = 0;
            CGFloat imageLeftInset = centerXToLeft - imageSize.width / 2;
            imageInsets.left = imageLeftInset;
            imageInsets.right = -imageLeftInset;
        }
            break;
        case UIControlContentHorizontalAlignmentRight:
        case UIControlContentHorizontalAlignmentTrailing: {
            // target distance between {the center x of both title and image} and {the right edge of both title and image}
            CGFloat centerXToRight = MAX(imageSize.width, titleSize.width) / 2;
            CGFloat titleRightInset = centerXToRight - (titleSize.width / 2);
            titleInsets.right = titleRightInset;
            titleInsets.left = -titleRightInset;
            CGFloat imageRightInset = centerXToRight - imageSize.width / 2 - titleSize.width;
            imageInsets.right = imageRightInset;
            imageInsets.left = 0;
        }
            break;
        case UIControlContentHorizontalAlignmentFill:
            break;
    }
    
    switch (self.contentVerticalAlignment) {
        case UIControlContentVerticalAlignmentCenter:
            titleInsets.top = imageSize.height / 2;
            titleInsets.bottom = -imageSize.height / 2;
            imageInsets.top = -titleSize.height / 2;
            imageInsets.bottom = titleSize.height / 2;
            break;
        case UIControlContentVerticalAlignmentTop:
            titleInsets.top = imageSize.height;
            titleInsets.bottom = -imageSize.height;
            imageInsets.top = 0;
            imageInsets.bottom = 0;
            break;
        case UIControlContentVerticalAlignmentBottom:
            titleInsets.top = 0;
            titleInsets.bottom = 0;
            imageInsets.top = -titleSize.height;
            imageInsets.bottom = titleSize.height;
            break;
        case UIControlContentVerticalAlignmentFill:
            break;
    }
    
    self.titleEdgeInsets = titleInsets;
    self.imageEdgeInsets = imageInsets;
}

- (void)setupImageRightTitleLeft {
    CGSize imageSize = self.imageView.bounds.size;
    CGSize titleSize = self.titleLabel.bounds.size;
    
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width);
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(0, titleSize.width+15, 0, -titleSize.width);
    
    switch (self.contentVerticalAlignment) {
        case UIControlContentVerticalAlignmentCenter:
            break;
        case UIControlContentVerticalAlignmentTop: {
            CGFloat centerYToTop = MAX(titleSize.height, imageSize.height) / 2;
            titleInsets.top = centerYToTop - titleSize.height / 2;
            titleInsets.bottom = -titleInsets.top;
            imageInsets.top = centerYToTop - imageSize.height / 2;
            imageInsets.bottom = -imageInsets.top;
        }
            break;
        case UIControlContentVerticalAlignmentBottom: {
            CGFloat centerYToBottom = MAX(titleSize.height, imageSize.height) / 2;
            titleInsets.bottom = centerYToBottom - titleSize.height / 2;
            titleInsets.top = -titleInsets.bottom;
            imageInsets.bottom = centerYToBottom - imageSize.height / 2;
            imageInsets.top = -imageInsets.bottom;
        }
            break;
        case UIControlContentVerticalAlignmentFill:
            break;
    }
    
    self.titleEdgeInsets = titleInsets;
    self.imageEdgeInsets = imageInsets;
}

@end
