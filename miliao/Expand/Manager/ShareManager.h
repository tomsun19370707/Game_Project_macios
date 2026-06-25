//
//  ShareManager.h
//  miliao
//
//  Created by jkkj on 2021/6/29.
//  Copyright © 2021 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareManager : NSObject
+ (instancetype)manager;
///复制
- (void)shareCopyPaste:(NSString *)copyStr;
@end

NS_ASSUME_NONNULL_END
