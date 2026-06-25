//
//  NetworkRequest.m
//  XGHZPWorker
//
//  Created by xiangguohe on 17/3/10.
//  Copyright © 2017年 XGH. All rights reserved.
//

#import "NetworkRequest.h"
#import "AFmanager.h"
#import "NSString+Custom.h"
#import <AFNetworking/AFNetworking.h>


@interface NetworkRequest ()
/**是否显示*/
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end;
@implementation NetworkRequest

+ (instancetype)shareInstance {
    static NetworkRequest *request = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[NetworkRequest alloc] init];
        request.manager = [AFHTTPSessionManager manager];
        request.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        request.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/javascript",@"application/json",@"text/plain",@"text/json",@"charset=utf-8",nil];
        [request.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    });
    return request;
}
#pragma mark -- GET请求
+ (void)requestGET:(NSString *)URL
           parameters:(NSDictionary *)parDic
           success:(void(^)(id responObject))successBlock
             error:(void(^)(NSError * errors))errorBlock{
    
    
    NetworkRequest *net = [NetworkRequest shareInstance];
    NSLog(@"%@",parDic);

    NSString *str = [DAConfig userLanguage];
    NSString *LanguageStr = [NSString string];
    if ([str isEqualToString:@"zh-Hans"]) {
//        LanguageStr = @"Chinese";
        LanguageStr =@"zh-cn";
    }else if ([str isEqualToString:@"en"]) {
//        LanguageStr = @"English";
        LanguageStr =@"en-us";
    } else if ([str isEqualToString:@"ja"]) {
//        LanguageStr = @"Japanese";
        LanguageStr =@"ja";
    }else if ([str isEqualToString:@"zh-Hant"]) {
        LanguageStr =@"zh-hk";
}
//    else if ([str isEqualToString:@"my-MM"]) {
//        LanguageStr = @"Burmese";
//    }
    NSLog(@"LanguageStr---%@",LanguageStr);
    NSLog(@"token---%@",UserDefaultsGet(kToken));
    [net.manager.requestSerializer setValue:LanguageStr forHTTPHeaderField:@"Accept-Language"];
    [net.manager.requestSerializer setValue:UserDefaultsGet(kToken) forHTTPHeaderField:@"token"];
    //发送网络请求
    
    [net.manager GET:URL parameters:parDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseModel *baseModel = [BaseModel mj_objectWithKeyValues:responseObject];
        DLog(@"[Finished] Post, %@ %@ %@ %@", URL, parDic,responseObject, net.manager.requestSerializer.HTTPRequestHeaders);
        if (baseModel.code == 1) {
            successBlock(baseModel);
        }else{
            NSLog(@"error:%@",baseModel.msg);
            [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];

        }
//        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"网络连接失败")];
    
    errorBlock(error);
    }];
    
    
}

#pragma mark -- POST请求
+ (NSURLSessionDataTask *)POST:(NSString *)urlStr
   parmeters:(NSDictionary *)parmeters
     success:(void (^)(id))success
    failture:(void (^)(NSError *))failture {
    NetworkRequest *net = [NetworkRequest shareInstance];
    [net.manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    net.manager.requestSerializer.timeoutInterval = 50;
    [net.manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSMutableDictionary * parMutableDic = [[NSMutableDictionary alloc] initWithDictionary:parmeters];
    NSString *str = [DAConfig userLanguage];
    NSString *LanguageStr = [NSString string];
    if ([str isEqualToString:@"zh-Hans"]) {
        LanguageStr =@"zh-cn";
    }else if ([str isEqualToString:@"en"]) {
        LanguageStr =@"en-us";
    } else if ([str isEqualToString:@"ja"]) {
        LanguageStr =@"ja";
    }else if ([str isEqualToString:@"zh-Hant"]) {
                LanguageStr =@"zh-hk";
    }
//    [net.manager.requestSerializer setValue:LanguageStr forHTTPHeaderField:@"Accept-Language"];
    [net.manager.requestSerializer setValue:UserDefaultsGet(kToken) forHTTPHeaderField:@"token"];
//    NSLog(@"token----%@",UserDefaultsGet(kToken));
//    NSLog(@"url-----%@----\n参数:%@",urlStr,parMutableDic);
//    NSLog(@"LanguageStr---%@",LanguageStr);
    
    return [net.manager POST:urlStr parameters:parMutableDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"结果:%@",responseObject);
        BaseModel *baseModel = [BaseModel mj_objectWithKeyValues:responseObject];
        DLog(@"[Finished] Post, %@ %@ %@ %@", urlStr, parMutableDic,responseObject, net.manager.requestSerializer.HTTPRequestHeaders);
        if (baseModel.code == 1) {
            success(baseModel);

        }else if(baseModel.code==3&&([urlStr isEqualToString:Request_EnterRoom])){
            success(baseModel);
        }
        else{
            NSLog(@"error:%@",baseModel.msg);
            
            [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *errorData = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
        if(errorData != nil){
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
            DLog(@"[Finished] Post, %@ %@ %@ %@", urlStr, parMutableDic,dic, net.manager.requestSerializer.HTTPRequestHeaders);
            [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:dic[@"msg"]]];
            if([dic[@"code"] integerValue]==401){
                UserDefaultsSave(@"", kToken);
                [UserManager clearUserInfo];
                [MLRoomInformationManager clearUserInfo];
                EMO_LoginViewController *loginVC = [[EMO_LoginViewController alloc] init];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [[RCCoreClient sharedCoreClient] logout];
                delegate.roomViewController = nil;
                ZXNavigationController *navVC = [[ZXNavigationController alloc] initWithRootViewController:loginVC];
                navVC.navigationBarHidden = YES;
                delegate.window.rootViewController = navVC;
            }
            failture(error);
        }
    }];

}

+ (void)POSTNewNeW:(NSString *)urlStr
                     parmeters:(NSDictionary *)parmeters
                       success:(void (^)(id responObject))success
                      failture:(void (^)(NSError *))failture {

    NSString *str = [DAConfig userLanguage];
    NSString *LanguageStr = [NSString string];
    if ([str isEqualToString:@"zh-Hans"]) {
        LanguageStr =@"zh-cn";
    }else if ([str isEqualToString:@"en"]) {
        LanguageStr =@"en-us";
    } else if ([str isEqualToString:@"ja"]) {
        LanguageStr =@"ja";
    }else if ([str isEqualToString:@"zh-Hant"]) {
        LanguageStr =@"zh-hk";
    }
    NSMutableDictionary *headers=[NSMutableDictionary dictionary];
    [headers setObject:@"application/json;charset=UTF-8" forKey:@"Content-type"];
    [headers setObject:@"application/json" forKey:@"Accept"];
    [headers setObject:UserDefaultsGet(kToken) forKey:@"token"];
    [headers setObject:LanguageStr forKey:@"Language"];
    [headers setObject:LanguageStr forKey:@"Accept-Language"];
    NSLog(@"header===================%@",headers);
    NSData *data = [NSJSONSerialization dataWithJSONObject:parmeters options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:data];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@",urlStr] parameters:nil error:nil];
    request.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:tempJsonData];
    [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            BaseModel *baseModel = [BaseModel mj_objectWithKeyValues:responseObject];
            DLog(@"[Finished] Post, %@ %@ %@ %@", urlStr, parmeters,responseObject,headers);
            if (baseModel.code == 1) {
                success(baseModel);

            }else if(baseModel.code==3&&([urlStr isEqualToString:Request_EnterRoom])){
                success(baseModel);
            }
            else{
                NSLog(@"error:%@",baseModel.msg);
                
                [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];

            }
        } else {
            NSData *errorData = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
            if(errorData != nil){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
                [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:dic[@"msg"]]];
                if([dic[@"code"] integerValue]==401){
                    UserDefaultsSave(@"", kToken);
                    [UserManager clearUserInfo];
                    [MLRoomInformationManager clearUserInfo];
                    EMO_LoginViewController *loginVC = [[EMO_LoginViewController alloc] init];
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [[RCCoreClient sharedCoreClient] logout];
                    delegate.roomViewController = nil;
                    ZXNavigationController *navVC = [[ZXNavigationController alloc] initWithRootViewController:loginVC];
                    navVC.navigationBarHidden = YES;
                    delegate.window.rootViewController = navVC;
                }
                failture(error);
            }
        }
    }] resume];
    
}

+ (NSURLSessionDataTask *)POSTNew:(NSString *)urlStr
                     parmeters:(NSDictionary *)parmeters
                       success:(void (^)(id responObject))success
                      failture:(void (^)(NSError *))failture {
    NetworkRequest *net = [NetworkRequest shareInstance];
    [net.manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    net.manager.requestSerializer.timeoutInterval = 50;
    [net.manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSString *str = [DAConfig userLanguage];
    NSString *LanguageStr = [NSString string];
    if ([str isEqualToString:@"zh-Hans"]) {
//        LanguageStr = @"Chinese";
        LanguageStr =@"zh-cn";
    }else if ([str isEqualToString:@"en"]) {
//        LanguageStr = @"English";
        LanguageStr =@"en-us";
    } else if ([str isEqualToString:@"ja"]) {
//        LanguageStr = @"Japanese";
        LanguageStr =@"ja";
    }else if ([str isEqualToString:@"zh-Hant"]) {
                LanguageStr =@"zh-hk";
    }
//    else if ([str isEqualToString:@"my-MM"]) {
//        LanguageStr = @"Burmese";
//    }
    [net.manager.requestSerializer setValue:UserDefaultsGet(kToken) forHTTPHeaderField:@"token"];
    [net.manager.requestSerializer setValue:LanguageStr forHTTPHeaderField:@"Language"];
    [net.manager.requestSerializer setValue:LanguageStr forHTTPHeaderField:@"Accept-Language"];
    NSLog(@"url---%@--参数---%@---\nheader:token--%@\nLanguage:%@",urlStr,parmeters,UserDefaultsGet(kToken),LanguageStr);
    
    return [net.manager POST:urlStr parameters:parmeters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failture(error);
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"网络连接失败")];
    }];
    

}



#pragma mark -- 上传单张图片
+ (void)uploadOneImage:(NSString *)URL
            parameters:(NSDictionary *)parDic
                 image:(UIImage *)image
              fileName:(NSString *)imageFileName
              progress:(void(^)(NSProgress * uploadProgress))progress
               success:(void(^)(id responObject))successBlock
                 error:(void(^)(NSError *errors))errorBlock{
   
    NSMutableDictionary * parMutableDic = [[NSMutableDictionary alloc] initWithDictionary:parDic];
    NetworkRequest *net = [NetworkRequest shareInstance];
    [net.manager.requestSerializer setValue:UserDefaultsGet(kToken) forHTTPHeaderField:@"token"];
    
    [net.manager POST:URL parameters:parMutableDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (image) {
            //1.将图片转化为data
            NSData * data = UIImageJPEGRepresentation(image, 0.5);
            if (data) {
                //2.照片区分名称
                NSDateFormatter * formatter = [[NSDateFormatter alloc]init];

                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSString * str = [formatter stringFromDate:[NSDate date]];

                //转化为文件格式
                NSString * fileName = [NSString stringWithFormat:@"%@.png",str]
                ;
                [formData appendPartWithFileData:data name:imageFileName fileName:fileName mimeType:@"image/png"];
            }else{
                //1.将图片转化为data
                NSData * data = [[NSData alloc]init];
                //2.照片区分名称
                NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSString * str = [formatter stringFromDate:[NSDate date]];
                //转化为文件格式
                NSString * fileName = [NSString stringWithFormat:@"%@.png",str];
                [formData appendPartWithFileData:data name:imageFileName fileName:fileName mimeType:@"image/png"];
            }
        }
        else{
            //1.将图片转化为data
            NSData * data = [[NSData alloc]init];
            //2.照片区分名称
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString * str = [formatter stringFromDate:[NSDate date]];
            //转化为文件格式
            NSString * fileName = [NSString stringWithFormat:@"%@.png",str];
            [formData appendPartWithFileData:data name:imageFileName fileName:fileName mimeType:@"image/png"];

        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        BaseModel *baseModel = [BaseModel mj_objectWithKeyValues:responseObject];
        if (baseModel.code == 1) {
            successBlock(baseModel);
        }else{
            [SVProgressHUD showImage:KGetImage(@"") status:[Common isNull:baseModel.msg]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"网络连接失败")];
    }];


}
// 上传多张图片
+ (void)uploadImageArr:(NSString *)url
            parameters:(NSDictionary *)parameters
            consImages:(NSArray<UIImage *> *)consImages
              progress:(void(^)(NSProgress * uploadProgress))progress
               success:(void(^)(id responObject))successBlock
               failure:(void(^)(NSError *error))failureBlock{
    NSMutableDictionary * parMutableDic = [[NSMutableDictionary alloc] initWithDictionary:parameters];
   
    
    NetworkRequest *net = [NetworkRequest shareInstance];
    [net.manager.requestSerializer setValue:UserDefaultsGet(kToken) forHTTPHeaderField:@"token"];
    
    
    [net.manager POST:url parameters:parMutableDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (consImages) {
           for (int i = 0; i < consImages.count; i++) {
              NSLog(@"循环操作");
          //     UIImageJPEGRepresentation(consImages[i], 1)
              //1.转成NSData类型
              NSData * imageData = UIImageJPEGRepresentation(consImages[i], 0.5);
             //2.加时间
              NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             formatter.dateFormat = @"yyyyMMddHHmmss";
              NSString *str = [formatter stringFromDate:[NSDate date]];
              //转成文件格式
              NSString *fileName = [NSString stringWithFormat:@"files.jpeg"];
              [formData appendPartWithFileData:imageData name:@"files"  fileName:fileName mimeType:@"image/jpeg"];
           }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
           progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
    
    

}


+(void)uploadOneVideo:(NSString *)URL parameters:(NSDictionary *)parDic path:(NSURL *)videoPath fileName:(NSString *)videoFileName progress:(void (^)(NSProgress *))progress success:(void (^)(id))successBlock error:(void (^)(NSError *))errorBlock{
    
    NetworkRequest *net = [NetworkRequest shareInstance];
    [net.manager.requestSerializer setValue:UserDefaultsGet(kToken) forHTTPHeaderField:@"token"];
    
    [net.manager POST:URL parameters:parDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileURL:videoPath name:@"files" fileName:videoFileName mimeType:@"application/octet-stream" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
           progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
    }];
    
    
    
}




+(void)uploadOneVoice:(NSString *)URL parameters:(NSDictionary *)parDic path:(NSURL *)voicePath fileName:(NSString *)voiceFileName progress:(void (^)(NSProgress *))progress success:(void (^)(id))successBlock error:(void (^)(NSError *))errorBlock{
    
    NetworkRequest *net = [NetworkRequest shareInstance];
    [net.manager.requestSerializer setValue:UserDefaultsGet(kToken) forHTTPHeaderField:@"token"];
    [net.manager POST:[NSString stringWithFormat:@"%@",URL] parameters:parDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data=[NSData dataWithContentsOfURL:voicePath];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp3",voiceFileName];
        [formData appendPartWithFileData:data name:@"file"  fileName:fileName mimeType:@"audio/mp3"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
           progress(uploadProgress);
        }

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
    }];

    
    
    
}








@end
