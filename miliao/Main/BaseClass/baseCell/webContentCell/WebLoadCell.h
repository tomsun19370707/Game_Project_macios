//
//  WebLoadCell.h
//  PodFullDemo
//
//  Created by 李东阳 on 2019/12/27.
//  Copyright © 2019 锤子科技. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    /** 有header*/
    WebLoadCellTypeHeader,
    /** 无header*/
    WebLoadCellTypeHeaderNoExit,
}WebLoadCellType;

@interface WebLoadCell : UITableViewCell
/** 显示的文字*/
@property (weak, nonatomic) IBOutlet UILabel *lab;
/** 标识*/
@property (weak, nonatomic) IBOutlet UILabel *mark;

/** html*/
@property (nonatomic,strong) NSString *webHtml;
@property (nonatomic,assign) WebLoadCellType type;
/** 高度刷新*/
@property (nonatomic,copy) void (^webHeight)(CGFloat webHeight);
@end
