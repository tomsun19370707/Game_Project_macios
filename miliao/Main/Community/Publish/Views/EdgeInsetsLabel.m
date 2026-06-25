//
//  EdgeInsetsLabel.m
//  miliao
//
//  Created by aa on 2019/7/17.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "EdgeInsetsLabel.h"

@implementation EdgeInsetsLabel

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    NSString *tempString = self.text;
    self.text = @"";
    self.text = tempString;
}

-(void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.contentInset)];
}


@end
