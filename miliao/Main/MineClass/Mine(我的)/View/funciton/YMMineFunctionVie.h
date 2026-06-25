//
//  YMMineFunctionVie.h
//  YunMarket
//
//  Created by 李东阳 on 2021/3/17.
//

#import <UIKit/UIKit.h>

@interface YMMineFunctionVie : UITableViewCell

/** 图标和icon*/
@property (nonatomic,strong) NSArray *titles,*icons;

/** 设置一行显示的数量*/
@property (nonatomic,assign) NSUInteger columnNum;

/** 加载数据*/
- (void)loadData ;
@end
