//
//  LocaleFileManager.m
//  DTLibrary
//
//  Created by Leks Zhang on 11-3-18.
//  Copyright 2011 Leks Zhang. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

//几大文件目录

+ (NSString *)getHomeDirectory {
    NSString *homePath = NSHomeDirectory();
    //    NSLog(@"Home目录：%@",homePath);
    return homePath;
}

+ (NSString *)getDocumentsDirectory {
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = docPath[0];
    NSLog(@"Documents目录：%@",documentsPath);
    return documentsPath;
}

+ (NSString *)getLibraryDirectory {
    NSArray *libsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = libsPath[0];
    NSLog(@"Library目录：%@",libPath);
    return libPath;
}

+ (NSString *)getCacheDirectory {
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = cacPath[0];
    NSLog(@"Cache目录：%@",cachePath);
    return cachePath;
}

+ (NSString *)getTemporaryDirectory {
    NSString *tempPath = NSTemporaryDirectory();
    NSLog(@"temp目录：%@",tempPath);
    return tempPath;
}
+ (NSString *)libPrefPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preferences"];
}
#pragma -mark File Operation
+ (BOOL)creatDirectory:(NSString *)dirPath {
    if ([Common isEmptyString:dirPath]) {
        return NO;
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = [fm fileExistsAtPath:dirPath];
    if (isExist) {
        return NO;
    }
    NSError *error = nil;
    BOOL resBool = [fm createDirectoryAtPath:dirPath
                 withIntermediateDirectories:YES
                                  attributes:nil
                                       error:&error];
    if (error) {
        NSLog(@"error:%@",[error description]);
        return NO;
    }
    return resBool;
}

+ (BOOL)creatFile:(NSString *)filePath Data:(id)data Name:(NSString *)name {
    if ([Common isEmptyString:filePath] ||
        !data ||
        [Common isEmptyString:name]) {
        return NO;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    //不存在则创建目录
    if (![fm fileExistsAtPath:filePath]) {
        [FileManager creatDirectory:filePath];
    }
    NSError *error = nil;
    BOOL resBool = [fm createFileAtPath:[NSString stringWithFormat:@"%@/%@",filePath,name]
                               contents:data
                             attributes:nil];
    if (error) {
        NSLog(@"error:%@",[error description]);
        return NO;
    }
    return resBool;
}

+ (BOOL)removeFileOrDirectory:(NSString *)path {
    if ([Common isEmptyString:path]) {
        return NO;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL resBool = [fm removeItemAtPath:path
                                  error:&error];
    if (error) {
        NSLog(@"error:%@",[error description]);
        return NO;
    }
    return resBool;
}

//递归查找
+ (NSArray *)findFileContentsPath:(NSString *)path {
    if ([Common isEmptyString:path]) {
        return nil;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *resArr = [fm subpathsOfDirectoryAtPath:path
                                              error:&error];
    if (error) {
        NSLog(@"error:%@",[error description]);
        return nil;
    }
    return resArr;
}

//单个文件的大小
+ (long long)fileSizeAtPath:(NSString*) filePath {
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        NSError *error = nil;
        long long sumSize = [[fm attributesOfItemAtPath:filePath
                                                  error:&error] fileSize];
        if (error) {
            NSLog(@"error:%@",[error description]);
            return 0;
        }
        return sumSize;
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
+ (long long)folderSizeAtPath:(NSString *)folderPath {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:folderPath]) {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[fm subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName = nil;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [FileManager fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

//文件修改时间
+ (NSDate *)fileModificationDateAtPath:(NSString *) filePath {
    NSFileManager *fm  = [NSFileManager defaultManager];
    //取文件修改时间
    NSError *error = nil;
    NSDictionary *dictFile = [fm attributesOfItemAtPath:filePath error:&error];
    if (error) {
        NSLog(@"get fileModificationDate error: %@", error);
        return nil;
    }
    NSDate *modificationDate = [dictFile fileModificationDate];
    return modificationDate;
}

//文件类型
+ (NSString *)fileTypeAtPath:(NSString *) filePath {
    NSFileManager *fm  = [NSFileManager defaultManager];
    //取文件类型
    NSError *error = nil;
    NSDictionary *dictFile = [fm attributesOfItemAtPath:filePath error:&error];
    if (error) {
        NSLog(@"get fileType error: %@", error);
        return @"";
    }
    NSString *fileType = [dictFile fileType];
    return fileType;
}


@end
