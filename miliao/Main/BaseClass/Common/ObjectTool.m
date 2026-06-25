//
//  ObjectTool.m
//  GroupPurchaseProject
//
//  Created by 锤子科技 on 2017/6/22.
//  Copyright © 2017年 锤子科技. All rights reserved.
//

#import "ObjectTool.h"
/** 缓存*/
#import "SDImageCache.h"
@implementation ObjectTool
static  dispatch_once_t  oneToken;
static  ObjectTool *set = nil;

+ (ObjectTool *)SharedSettings
{
    dispatch_once(&oneToken, ^{
        set = [[ObjectTool alloc]init];
    });
    return set;
}
/** 倒计时*/
/**
 time 正在进行的时间
 arrive  倒计时结束
 */
+ (void)countDownInterval:(int)interval time:(void(^)(NSString *time))time arrive:(void(^)(void))arrive
{
    __block int timeout = interval; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                arrive();
            });
        }else{
            int seconds = timeout % 60 == 0 ? 60 : timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                time(strTime);
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
/**
 *   间隔多长时间后执行方法
 *
 *  @param  delay      间隔时间
 *  @param  completion      结束回调
 */
+ (void)performSelectorAfterDelay:(double)delay completion:(void(^)(void))completion
{
    double delayInSeconds = delay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //执行事件
        completion();
    });
}
/** 计算缓存大小*/
+ (void)calculateCacheSizeWithCompletion:(void(^)(NSString *sizeContent))completion
{
//    [SVProgressHUD showLoadingHUDWithMessage:@""];
    /** 计算缓存*/
    [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        
        NSString *content = @"" ;
        if (totalSize/1024.0/1024.0 < 1) {
            content = [NSString stringWithFormat:@"清除缓存(已使用%.0fKB)",totalSize/1024.0];
        } else {
            content = [NSString stringWithFormat:@"清除缓存(已使用%.1fMB)",totalSize/1024.0/1024.0];
        }
        completion(content);
//        [SVProgressHUD hideLoadingHUD];
    }];
}
/** 清理缓存*/
+ (void)clearDiskCache:(void(^)(void))completion
{
    [SVProgressHUD showLoadingHUDWithMessage:@"清理中..."];
    /** 计算缓存*/
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        completion();
        [ObjectTool performSelectorAfterDelay:1.0 completion:^{
            [SVProgressHUD hideLoadingHUD];
        }];
    }];
}
/** 按钮添加右上角角标数字(例如：购物车按钮右上角角标)*/
+ (void)cusView:(UIView *)view addTopBage:(int)bage bageLab:(void(^)(UILabel *num))bageLab
{
    UILabel *lab = [UILabel LabelWithFrame:CGRectMake(0, 0, 22, 15) fontSize:0 textColor:[UIColor whiteColor] textAlient:NSTextAlignmentCenter numberLines:1];
    lab.font = PingFangFONT(11);
    lab.backgroundColor = BaseMainColor;
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = lab.height / 2 ;
    lab.text = [NSString stringWithFormat:@"%d",bage];
    lab.hidden = NO;
    if (bage <= 0) {
        lab.hidden = YES ;
    }
    
    /** 添加到view上*/
    [lab setBottom:6];
    [lab setLeft:view.width / 2.0];
    [view addSubview:lab];
    
    if (bageLab) {
        bageLab(lab);
    }
}

/** 设置消息未读角标数字*/
+ (void)messageBageVie:(UILabel *)bage bageNum:(int)bageNum
{
    if (bageNum > 0) {
        bage.text = FORMAT_TYPE(@"%d", bageNum);
        bage.font = PingFangFONT(11);
        if (bageNum > 99) {
            bage.font = PingFangFONT(9);
            bage.text = @"99+";
        }
        bage.hidden = NO ;
    }else{
        bage.hidden = YES ;
    }
}

/** 获取按照x升序排列后的tabBarButtons*/
+ (void)tabBarButtonsAscSort:(UITabBarController *)tabVC finish:(void(^)(NSMutableArray *tabBarButtons))finish
{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];
    for (UIView *tabBarButton in tabVC.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    
    /** 重新排列tabBarButtons 中的顺序，按照x升序排列*/
    NSMutableArray *targetArr = [NSMutableArray array];
    /** 先获取所有x坐标值*/
    for (int i = 0; i < tabBarButtons.count; i ++) {
        UIControl *bar = tabBarButtons[i];
        [targetArr addObject:[NSString stringWithFormat:@"%.0f",bar.origin.x]];
    }
    /** 排序前*/
    for (int i = 0; i < targetArr.count - 1; i++) {
        //比较的躺数
        for (int j = 0; j < targetArr.count - 1 - i; j++) {
            //比较的次数
            if ([targetArr[j] intValue] > [targetArr[j + 1] intValue]) {
                //这里为升序排序
                int temp = [targetArr[j] intValue];
                targetArr[j] = targetArr[j + 1];
                //OC中的数组只能存储对象，所以这里转换成string对象
                targetArr[j + 1] = [NSString stringWithFormat:@"%d",temp];
                /** 调换tab顺序*/
                UIControl *con_j = tabBarButtons[j];
                UIControl *con_jj = tabBarButtons[j + 1];
                [tabBarButtons replaceObjectAtIndex:j withObject:con_jj];
                [tabBarButtons replaceObjectAtIndex:j + 1 withObject:con_j];
            }
        }
    }
    /** 排序后*/
    
    if (finish) {
        finish(tabBarButtons);
    }
}

/** 获取APP当前名称和版本号*/
+ (NSString *)App_Name
{
    /** app name*/
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary[@"CFBundleName"] ;
}
+ (NSString *)App_Version
{
    /** app name*/
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary[@"CFBundleShortVersionString"] ;
}

/** model转化为字典*/
+ (NSDictionary *)dicFromObject:(NSObject *)object
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [object valueForKey:name];//valueForKey返回的数字和字符串都是对象
        
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            //string , bool, int ,NSinteger
            [dic setObject:value forKey:name];
            
        } else if ([value isKindOfClass:[NSArray class]]) {
            //数组或字典
            [dic setObject:[self arrayWithObject:value] forKey:name];
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            //数组或字典
            [dic setObject:[self dicWithObject:value] forKey:name];
        } else if (value == nil) {
            //null
            //[dic setObject:[NSNull null] forKey:name];//这行可以注释掉?????
        } else {
            //model
            [dic setObject:[self dicFromObject:value] forKey:name];
        }
    }
    
    return [dic copy];
}
+ (NSArray *)arrayWithObject:(id)object {
    //数组
    NSMutableArray *array = [NSMutableArray array];
    NSArray *originArr = (NSArray *)object;
    if ([originArr isKindOfClass:[NSArray class]]) {
        for (NSObject *object in originArr) {
            if ([object isKindOfClass:[NSString class]]||[object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [array addObject:object];
            } else if ([object isKindOfClass:[NSArray class]]) {
                //数组或字典
                [array addObject:[self arrayWithObject:object]];
            } else if ([object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [array addObject:[self dicWithObject:object]];
            } else {
                //model
                [array addObject:[self dicFromObject:object]];
            }
        }
        return [array copy];
    }
    return array.copy;
}

+ (NSDictionary *)dicWithObject:(id)object {
    //字典
    NSDictionary *originDic = (NSDictionary *)object;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([object isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in originDic.allKeys) {
            id object = [originDic objectForKey:key];
            if ([object isKindOfClass:[NSString class]]||[object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [dic setObject:object forKey:key];
            } else if ([object isKindOfClass:[NSArray class]]) {
                //数组或字典
                [dic setObject:[self arrayWithObject:object] forKey:key];
            } else if ([object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [dic setObject:[self dicWithObject:object] forKey:key];
            } else {
                //model
                [dic setObject:[self dicFromObject:object] forKey:key];
            }
        }
        return [dic copy];
    }
    return dic.copy;
}

/** 获取文件地址*/
+ (NSDictionary *)dictionaryFromConfig:(NSString *)configFileName {
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:configFileName];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

/** 系统提示弹框*/
+ (void)systemAlertTip:(NSString *)content
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:content preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
    }]];
    [Dn_NAVPUSH presentViewController:alert animated:YES completion:nil];
}

/** 基础分享*/
+ (void)baseShareHandle
{
    
}

/** 获取麦克风权限*/
- (void)fetchMicroPhoneStatus
{
    AVAuthorizationStatus microPhoneStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
      switch (microPhoneStatus) {
          case AVAuthorizationStatusDenied:
          case AVAuthorizationStatusRestricted:
          {
              // 被拒绝
              [self goMicroPhoneSet];
          }
              break;
          case AVAuthorizationStatusNotDetermined:
          {
              // 没弹窗
              [self requestMicroPhoneAuth];
          }
              break;
          case AVAuthorizationStatusAuthorized:
          {
              // 有授权
          }
              break;

          default:
              break;
      }
}

-(void)requestMicroPhoneAuth
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {

    }];
}

-(void)goMicroPhoneSet
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"您还没有允许麦克风权限" message:@"去设置一下吧" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertAction * setAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success) {

            }];
        });
    }];

    [alert addAction:cancelAction];
    [alert addAction:setAction];

    [Dn_NAVPUSH presentViewController:alert animated:YES completion:nil];
}

/** 群聊，判断消息是否超时未读*/
+ (BOOL)isGroupChatReadTimeout:(double)timestamp
{
    return NO;
}

/** 视频格式转换*/
+ (NSURL *)_videoConvert2Mp4:(NSURL *)movUrl
{
    [SVProgressHUD showLoadingHUDWithMessage:@""];
    
    
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];

    if ([compatiblePresets containsObject:AVAssetExportPreset640x480]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPreset640x480];
        NSString *mp4Path = [NSString stringWithFormat:@"%@/%d%d.mp4", [ObjectTool getAudioOrVideoPath], (int)[[NSDate date] timeIntervalSince1970], arc4random() % 100000];
        mp4Url = [NSURL fileURLWithPath:mp4Path];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }

        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }

    
    [SVProgressHUD hideLoadingHUD];
    
    return mp4Url;
}

/** 获取音视频录制地址路径*/
+ (NSString *)getAudioOrVideoPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"EMDemoRecord"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}
@end
