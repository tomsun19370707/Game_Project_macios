//
//  NetworkRequest.h
//  XGHZPWorker
//
//  Created by xiangguohe on 17/3/10.
//  Copyright © 2017年 XGH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NetworkRequest : NSObject
#pragma mark -- GET请求
+ (void)requestGET:(NSString *)URL
        parameters:(NSDictionary *)parDic
           success:(void(^)(id responObject))successBlock
             error:(void(^)(NSError * errors))errorBlock;
#pragma mark -- POST请求
+ (NSURLSessionDataTask *)POST:(NSString *)urlStr
   parmeters:(NSDictionary *)parmeters
     success:(void(^)(id responObject))success
    failture:(void(^)(NSError *error))failture;
+ (void)POSTNewNeW:(NSString *)urlStr
                     parmeters:(NSDictionary *)parmeters
                       success:(void (^)(id responObject))success
          failture:(void (^)(NSError *))failture;
+ (NSURLSessionDataTask *)POSTNew:(NSString *)urlStr
                     parmeters:(NSDictionary *)parmeters
                       success:(void (^)(id responObject))success
                         failture:(void (^)(NSError *))failture;

#pragma mark -- 上传单张图片
+ (void)uploadOneImage:(NSString *)URL
            parameters:(NSDictionary *)parDic
                 image:(UIImage *)image
              fileName:(NSString *)imageFileName
              progress:(void(^)(NSProgress * uploadProgress))progress
               success:(void(^)(id responObject))successBlock
                 error:(void(^)(NSError *errors))errorBlock;
/** 上传多张图片 */
+ (void)uploadImageArr:(NSString *)url
        parameters:(NSDictionary *)parameters
        consImages:(NSArray<UIImage *> *)consImages
          progress:(void(^)(NSProgress * uploadProgress))progress
           success:(void(^)(id responObject))successBlock
           failure:(void(^)(NSError *error))failureBlock;

#pragma mark -- 上传视频
+ (void)uploadOneVideo:(NSString *)URL
            parameters:(NSDictionary *)parDic
                 path:(NSURL *)videoPath
              fileName:(NSString *)videoFileName
              progress:(void(^)(NSProgress * uploadProgress))progress
               success:(void(^)(id responObject))successBlock
                 error:(void(^)(NSError *errors))errorBlock;

#pragma mark -- 上传音频
+ (void)uploadOneVoice:(NSString *)URL
            parameters:(NSDictionary *)parDic
                  path:(NSURL *)voicePath
              fileName:(NSString *)voiceFileName
              progress:(void(^)(NSProgress * uploadProgress))progress
               success:(void(^)(id responObject))successBlock
                 error:(void(^)(NSError *errors))errorBlock;



@end
