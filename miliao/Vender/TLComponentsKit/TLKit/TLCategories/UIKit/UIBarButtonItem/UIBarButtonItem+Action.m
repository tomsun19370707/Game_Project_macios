//
//  UIBarButtonItem+Action.m
//  TLKit
//
//  Created by 李伯坤 on 2017/8/28.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "UIBarButtonItem+Action.h"
#import <objc/runtime.h>

char * const UIBarButtonItemActionBlock = "UIBarButtonItemActionBlock";

@implementation UIBarButtonItem (Action)

+ (id)fixItemSpace:(CGFloat)space
{
    UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fix.width = space;
    return fix;
}

- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style actionBlick:(TLBarButtonActionBlock)actionNewBlock
{
    if (self = [self initWithTitle:title style:style target:nil action:nil]) {
        [self setActionBlock:actionNewBlock];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style actionBlick:(TLBarButtonActionBlock)actionNewBlock
{
    if (self = [self initWithImage:image style:style target:nil action:nil]) {
        [self setActionBlock:actionNewBlock];
    }
    return self;
}

- (void)performActionBlock {
    dispatch_block_t block = self.actionNewBlock;
    if (block)
        block();
}

- (TLBarButtonActionBlock)actionNewBlock {
    return objc_getAssociatedObject(self, UIBarButtonItemActionBlock);
}

- (void)setActionBlock:(TLBarButtonActionBlock)actionNewBlock{
    if (actionNewBlock != self.actionNewBlock) {
        [self willChangeValueForKey:@"actionNewBlock"];
        
        objc_setAssociatedObject(self, UIBarButtonItemActionBlock, actionNewBlock, OBJC_ASSOCIATION_COPY);
        
        [self setTarget:self];
        [self setAction:@selector(performActionBlock)];
        
        [self didChangeValueForKey:@"actionNewBlock"];
    }
}
@end
