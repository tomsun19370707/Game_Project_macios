//
//  BaseModelDy.h
//  doctorUser
//
//  Created by 李东阳 on 2019/4/17.
//  Copyright © 2019 锤子科技. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PageModel;

@interface BaseModelDy : NSObject
/** 状态，
 success
 error
 warning
 login(跳转登录)
 register(跳转注册)
*/
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *code;
/** code，
 200:成功
 403:失败*/
@property (nonatomic,assign) int statusCode;
@property (nonatomic,strong) NSString *message;
/** 查询参数*/
@property (nonatomic,strong) NSDictionary *queryBean;
/** 页码信息*/
@property (nonatomic,strong) PageModel *page;
/** ID*/
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *createTime,*createtime,*create_time;
@property (nonatomic,assign) int del;
@end

@interface PageModel : NSObject
/** */
@property (nonatomic,assign) int empty;
/** */
@property (nonatomic,assign) int firstPage;
/** */
@property (nonatomic,assign) int firstResult;
/** 是否有下一页*/
@property (nonatomic,assign) int hasNext;
/** 是否有前一页*/
@property (nonatomic,assign) int hasPrev;
/** 下一页页码*/
@property (nonatomic,assign) int lastPage;
/** 总共可以分多少页*/
@property (nonatomic,assign) int pageCount;
/** 当前页码,从1开始*/
@property (nonatomic,assign) int pageIndex;
/** 每页记录数*/
@property (nonatomic,assign) int pageSize;
/** 数据总行数*/
@property (nonatomic,assign) int totalCount;
@end


/** 查询参数*/
@interface queryBeanModel : NSObject

///////////////////////卡券列表////////////////////
/** 未使用个数 */
@property (nonatomic,assign) int unUseCount;
/** 已使用个数 */
@property (nonatomic,assign) int useCount;
/** 已过期个数 */
@property (nonatomic,assign) int orterCount;

/** 进行中个数 */
@property (nonatomic,assign) int processingCount;
/** 已结束个数 */
@property (nonatomic,assign) int endCount;

@end
