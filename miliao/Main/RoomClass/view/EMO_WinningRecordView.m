//
//  EMO_WinningRecordView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/26.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_WinningRecordView.h"

@interface EMO_WinningRecordView ()

@end

@implementation EMO_WinningRecordView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor=[UIColor clearColor];
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)singleTapGesture{
    self.hidden=YES;
//    [self removeFromSuperview];
}

-(void)initView{
   
    
    
}




@end
