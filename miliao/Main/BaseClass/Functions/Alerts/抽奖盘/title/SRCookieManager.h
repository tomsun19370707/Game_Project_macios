//
//  XTCookieManager.h
//  xitu
//
//  Created by Gavin on 2019/5/30.
//  Copyright © 2019 xitu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRCookieManager : NSObject
+ (void)cleanWebCache;
@end

@interface NSHTTPCookieStorage (SRFormatCookie)
- (NSString *)documentCookieFormat;
@end

@interface NSHTTPCookie (SRFormatCookie)
- (NSString *)formatToString;
@end

NS_ASSUME_NONNULL_END


