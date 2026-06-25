//
//  TSMusicPlayerVc.m
//
//  类介绍说明：
//
//
#import "BaseVC.h"

#import <UIKit/UIKit.h>

@interface TSMusicPlayerVc : BaseVC
/** 必传，播放的index*/
@property (nonatomic,assign) NSUInteger playIndex;
/** 列表数据*/
@property (nonatomic,strong) NSMutableArray <GoodListInfoModel *> *playArr;
@end
