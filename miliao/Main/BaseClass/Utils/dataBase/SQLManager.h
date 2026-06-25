//
//  SQLManager.h
//  LessonFMDB
//
//  Created by 李东阳 on 14-9-12.
//  Copyright (c) 2014年 李东阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface SQLManager : NSObject
{
    FMDatabase *_fmDB;
}
//这是一个数据库管理类
+ (SQLManager *)sharedSQLManager;

//数据库 的增删改查操作
- (void)insertItemWithSearchWord:(NSString *)seachWord forTable:(NSString *)tableName;
- (void)deleteItemWithSearchWord:(NSString *)searchWord forTable:(NSString *)tableName;
- (NSArray *)selectAllPostFromDatabaseForTable:(NSString *)tableName;

@end
