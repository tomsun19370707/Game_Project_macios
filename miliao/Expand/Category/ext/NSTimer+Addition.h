//
//  NSTimer+Addition.h
//  PagedScrollView
//
//  Created by 李东阳 on 2019/1/18.
//  Copyright © 2019年 锤子科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)
/** 暂停*/
- (void)pauseTimer;
/** 继续*/
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
