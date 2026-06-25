//
//  BaseView.m
//  君分时代
//
//  Created by 贠小飞 on 2018/4/10.
//  Copyright © 2018年 贠小飞. All rights reserved.
//


#import "BaseView.h"
@implementation BaseView

- (void)dealloc {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _uiStyle = [[BaseUIStyle alloc] init];
    }
    return self;
}

- (void)loadData:(id)obj {
}

+ (NSInteger)HeightForView {
    return 0.0f;
}

+ (NSInteger)WidthForView {
    return 0.0f;
}


@end
