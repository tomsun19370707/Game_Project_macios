//
//  XTCookieManager.m
//  xitu
//
//  Created by Gavin on 2019/5/30.
//  Copyright © 2019 xitu. All rights reserved.
//

#import "SRCookieManager.h"
#import <WebKit/WebKit.h>
@implementation SRCookieManager
+ (void)cleanWebCache {
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        // Done
    }];
}
@end

@implementation NSHTTPCookieStorage (SRFormatCookie)
- (NSString *)documentCookieFormat {
    NSString *cookieStr = @"";
    NSArray<NSHTTPCookie *> *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            if ([obj.domain isEqualToString:SRAppDomain] && ![obj.value containsString:@"'"]) {
                NSString *temStr = [NSString stringWithFormat:@"document.cookie='%@';",[obj formatToString]];
                [cookieStr stringByAppendingString:temStr];
            }
        }
    }];
    if([cookieStr length] > 0){
        return  [cookieStr substringToIndex:([cookieStr length] - 1)];//去掉最后一个字符";"
    }else{
        return cookieStr;
    }
}
@end

@implementation NSHTTPCookie (SRFormatCookie)

- (NSString *)formatToString {
    NSString *formatStr = [NSString stringWithFormat:@"%@=%@;Max-age=31536000;path=/;domain=%@;",
                           self.name,
                           self.value,
                           self.domain];
    return formatStr;
}

@end
