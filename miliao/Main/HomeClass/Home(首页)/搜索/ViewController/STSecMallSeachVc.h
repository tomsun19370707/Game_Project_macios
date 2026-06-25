//
//  STSecMallSeachVc.m
//
//  类介绍说明：
//
//
#import "BaseVC.h"

#import <UIKit/UIKit.h>

@interface STSecMallSeachVc : BaseVC 
/** 必传 1二手商品 2普通商品 3商家*/
@property (nonatomic,assign) int vcType;
/** 可选，用于筛选店铺下的商品*/
@property (nonatomic,strong) NSString *shopId;
@end
