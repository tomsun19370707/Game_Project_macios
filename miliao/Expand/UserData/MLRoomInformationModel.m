//
//  MLRoomInformationModel.m
//  miliao
//
//  Created by aa on 2019/6/14.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "MLRoomInformationModel.h"

#import <MJExtension.h>
@implementation MLRoomInformationModel


+(instancetype)currentAccount{
    
    
    static MLRoomInformationModel *account;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!account) {
            account = [[MLRoomInformationModel alloc] init];
            account.isBanned = YES;
        }
    });
    return account;
}

//- (void)setRoom_cover:(NSString *)room_cover{
//    _room_cover = room_cover;
//    if ([room_cover rangeOfString:@"http"].location == NSNotFound) {
//        _room_cover = [NSString stringWithFormat:@"%@%@",VERSION_HTTPS_SERVER,room_cover];
//    }
//}

@end

@implementation MLRoomInformationManager


+ (BOOL)saveUserInfo:(MLRoomInformationModel *)dic
{
    return [NSKeyedArchiver archiveRootObject:[dic mj_keyValues] toFile:[self path]];
}

+ (MLRoomInformationModel *)userInfo
{
    id  data = [NSKeyedUnarchiver unarchiveObjectWithFile:[self path]];
    MLRoomInformationModel *model = [MLRoomInformationModel mj_objectWithKeyValues:data];
    model.isBanned = YES;
    return model;
}

+ (BOOL)clearUserInfo
{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:[self path]])
    {
        //删除归档文件
        return [defaultManager removeItemAtPath:[self path] error:nil];
    }
    else
    {
        return NO;
    }
}


/**
 Documents/ 保存应用程序的重要数据文件和用户数据文件等。用户数据基本上都放在这个位置(例如从网上下载的图片或音乐文件)，该文件夹在应用程序更新时会自动备份，在连接iTunes时也可以自动同步备份其中的数据。
 
 Library：这个目录下有两个子目录,可创建子文件夹。可以用来放置您希望被备份但不希望被用户看到的数据。该路径下的文件夹，除Caches以外，都会被iTunes备份.
 
 Library/Caches: 保存应用程序使用时产生的支持文件和缓存文件(保存应用程序再次启动过程中需要的信息)，还有日志文件最好也放在这个目录。iTunes 同步时不会备份该目录并且可能被其他工具清理掉其中的数据。
 Library/Preferences: 保存应用程序的偏好设置文件。NSUserDefaults类创建的数据和plist文件都放在这里。会被iTunes备份。
 
 @return <#return value description#>
 */
+(NSString *)path
{
    // 获取沙盒根目录路径
    //    NSString *homeDir   = NSHomeDirectory();
    //    // 获取Documents目录路径
    //    NSString *docDir    = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    //    //获取Library的目录路径
    //    NSString *libDir    = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) lastObject];
    //    // 获取cache目录路径
    //    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) firstObject];
    //    // 获取tmp目录路径
    NSString *tmpDir = NSTemporaryDirectory();
    //    // 获取应用程序程序包中资源文件路径的方法：
    //    NSString *bundle = [[NSBundle mainBundle] bundlePath];
    
    NSString *name = @"MLRoomInformationModel";
    NSString *type = @"sql";
    
    NSString *allName = [NSString stringWithFormat:@"%@.%@",name,type];
    
    return [tmpDir stringByAppendingPathComponent:allName];;
}
@end
