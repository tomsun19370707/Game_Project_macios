//
//  SQLManager.m
//  LessonFMDB
//
//  Created by 李东阳 on 14-9-12.
//  Copyright (c) 2014年 李东阳. All rights reserved.
//

#import "SQLManager.h"
#import "BSPost.h"
#define DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]
//数据库路径，在document文件夹中
#define DATABASE_PATH  [DOCUMENT_PATH stringByAppendingPathComponent:@"myDb.sqlite"]

@implementation SQLManager

static SQLManager *sqlManager = nil;
static dispatch_once_t  onceToken;

+ (SQLManager *)sharedSQLManager
{
    dispatch_once(&onceToken, ^{
        sqlManager = [[SQLManager alloc]init];
    });
    return sqlManager;
}

//创建数据库
- (void)creataDatabase;
{
    //根据路径创建数据库
    _fmDB = [FMDatabase databaseWithPath:DATABASE_PATH];
}

- (void)creatTableWithTableName:(NSString *)tableName
{
    //如果没有数据库，则先创建
    if (!_fmDB) {
        [self creataDatabase];
    }
    //如果数据库没有打开，提示错误
    if (![_fmDB open]) {
        NSLog(@"打开数据库失败！");
        return;
    }
    //为数据库设置缓存，提高效率
    [_fmDB setShouldCacheStatements:YES];
    //如果数据库中不存在表，则创建;存在的话，就不创建
    
    if (![_fmDB tableExists:tableName]) {//创建表
        [_fmDB executeUpdate:[NSString stringWithFormat:@"create table %@(postName varchar(255))",tableName]];
        NSLog(@"表创建成功！");
    }

}

//数据库的操作
- (void)insertItemWithSearchWord:(NSString *)seachWord forTable:(NSString *)tableName
{
    if (!_fmDB) {
        [self creataDatabase];
    }
    if (![_fmDB open]) {
        return;
    }
    //设置缓存
    [_fmDB setShouldCacheStatements:YES];
    if (![_fmDB tableExists:tableName]) {
        [self creatTableWithTableName:tableName];
    }
    //先判断是否创建了表
    
    //前边是判断条件
    //创建多线程，操作数据库
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:DATABASE_PATH];
    [queue inDatabase:^(FMDatabase *db) {
        
        BOOL isInsert= [_fmDB executeUpdate:@"insert into searchHistory(postName) values(?)",seachWord];
        if (isInsert) {
            NSLog(@"success!");
        }
        else
        {
            NSLog(@"fail!");
        }
    }];
    
    //执行完之后，关闭队列
    [queue close];
}
- (void)deleteItemWithSearchWord:(NSString *)searchWord forTable:(NSString *)tableName
{
    //执行操作
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:DATABASE_PATH];
    [queue inDatabase:^(FMDatabase *db) {
        BOOL isDelete = [_fmDB executeUpdate:[NSString stringWithFormat:@"drop table %@",tableName]];
        if (isDelete) {
            NSLog(@"success");
        }
        else
        {
            NSLog(@"fail!");
        }
    }];
    
    [queue close];


    
    
    
    
    
    
    
    
    
    
    
    
    
//    if (!_fmDB) {
//        [self creataDatabase];
//    }
//    if (![_fmDB open]) {
//        return;
//    }
//    [_fmDB setShouldCacheStatements:YES];
//    
//    if (![_fmDB tableExists:tableName]) {
//        [self creatTableWithTableName:tableName];
//    }
//    
//    //执行操作
//    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:DATABASE_PATH];
//    [queue inDatabase:^(FMDatabase *db) {
//        BOOL isDelete = [_fmDB executeUpdate:[NSString stringWithFormat:@"delete from %@ where postName = %@",tableName,searchWord]];
//        if (isDelete) {
//            NSLog(@"success");
//        }
//        else
//        {
//            NSLog(@"fail!");
//        }
//    }];
//    
//    [queue close];
}

- (NSArray *)selectAllPostFromDatabaseForTable:(NSString *)tableName
{
    if (!_fmDB) {
        [self creataDatabase];
    }
    if (![_fmDB open]) {
        return nil;
    }
    [_fmDB setShouldCacheStatements:YES];
    
    if (![_fmDB tableExists:tableName]) {
        return nil;
    }
    
    
    //用一个数组，存放对象
    NSMutableArray *postArr = [NSMutableArray array];
    //定义一个结果集，用于存放返回的数据
    FMResultSet * resultSet = [_fmDB executeQuery:[NSString stringWithFormat:@"select * from %@",tableName]];
    while ([resultSet next]) {
        BSPost *post = [[BSPost alloc]init];
        post.searchWord = [resultSet stringForColumn:@"postName"];
        [postArr addObject:post];
    }
    
    return postArr;
}

@end
