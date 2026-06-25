//
//  LocaleFileManager.h
//  DTLibrary
//
//  Created by Leks Zhang on 11-3-18.
//  Copyright 2011 Leks Zhang. All rights reserved.
//
/*
<Application_Home>/AppName.app：存放应用程序自身
<Application_Home>/Documents/：存放用户文档和应用数据文件
<Application_Home>/Library/：应用程序规范的顶级目录，下面有一些规范定义的的子目录，当然也可以自定义子目录，用于存放应用的文件，但是不宜存放用户数据文件，和document一样会被itunes同步，但不包括caches子目录
<Application_Home>/Library/Preferences，这里存放程序规范要求的首选项文件
<Application_Home>/Library/Caches，保存应用的持久化数据，用于应用升级或者应用关闭后的数据保存，不会被itunes同步，所以为了减少同步的时间，可以考虑将一些比较大的文件而又不需要备份的文件放到这个目录下
<Application_Home>/tmp/，保存应用数据，但不需要持久化的，在应用关闭后，该目录下的数据将删除，也可能系统在程序不运行的时候做清楚。
*/

@interface FileManager : NSObject 

//几大文件目录

+ (NSString *)getHomeDirectory;

+ (NSString *)getDocumentsDirectory;

+ (NSString *)getLibraryDirectory;

+ (NSString *)getCacheDirectory;

+ (NSString *)getTemporaryDirectory;
+ (NSString *)libPrefPath;//配置目录，配置文件存这里
//文件操作
+ (BOOL)creatDirectory:(NSString *)dirPath;

+ (BOOL)creatFile:(NSString *)filePath Data:(id)data Name:(NSString *)name;

+ (BOOL)removeFileOrDirectory:(NSString *)path;

//递归查找
+ (NSArray *)findFileContentsPath:(NSString *)path;

//单个文件
+ (long long)fileSizeAtPath:(NSString*) filePath;

//文件夹大小
+ (long long)folderSizeAtPath:(NSString *) folderPath;

//文件修改时间
+ (NSDate *)fileModificationDateAtPath:(NSString *) filePath;

//文件类型
+ (NSString *)fileTypeAtPath:(NSString *) filePath;

@end


