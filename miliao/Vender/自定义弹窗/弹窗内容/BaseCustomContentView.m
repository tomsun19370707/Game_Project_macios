//
//  BaseCustomContentView.m
//  CustomAlertView
//
//  Created by mac on 2021/1/23.
//

#import "BaseCustomContentView.h"

@implementation BaseCustomContentView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addChildrenViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addChildrenViews];
    }
    return self;
}



- (void) addChildrenViews{
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}





@end
