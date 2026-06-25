//
//  SVGAParser.h
//  SVGAPlayer
//
//  Created by 崔明辉 on 16/6/17.
//  Copyright © 2016年 UED Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SVGAVideoEntity;

@interface SVGAParser : NSObject

@property (nonatomic, assign) BOOL enabledMemoryCache;

- (void)parseWithURL:(nonnull NSURL *)URL
     completionBlock:(void ( ^ _Nonnull )(SVGAVideoEntity * _Nullable videoItem))completionBlock
        failureBlock:(void ( ^ _Nullable)(NSError * _Nullable error))failureBlock;

- (void)parseWithURLRequest:(nonnull NSURLRequest *)URLRequest
            completionBlock:(void ( ^ _Nonnull )(SVGAVideoEntity * _Nullable videoItem))completionBlock
               failureBlock:(void ( ^ _Nullable)(NSError * _Nullable error))failureBlock;

- (void)parseWithData:(nonnull NSData *)data
             cacheKey:(nonnull NSString *)cacheKey
      completionBlock:(void ( ^ _Nullable)(SVGAVideoEntity * _Nonnull videoItem))completionBlock
         failureBlock:(void ( ^ _Nullable)(NSError * _Nonnull error))failureBlock;

- (void)parseWithNamed:(nonnull NSString *)named
              inBundle:(nullable NSBundle *)inBundle
       completionBlock:(void ( ^ _Nullable)(SVGAVideoEntity * _Nonnull videoItem))completionBlock
          failureBlock:(void ( ^ _Nullable)(NSError * _Nonnull error))failureBlock;
/**
 通过url加载svga动画,设置svga文件存储

 @param URL url
 @param completionBlock 成功回调
 @param failureBlock 失败回调
 */
- (void)parseMemoryWithURL:(nonnull NSURL *)URL
                   Version:(NSString *_Nullable)version
           completionBlock:(void ( ^ _Nonnull )(SVGAVideoEntity * _Nullable videoItem))completionBlock
              failureBlock:(void ( ^ _Nullable)(NSError * _Nullable error))failureBlock;

@end
