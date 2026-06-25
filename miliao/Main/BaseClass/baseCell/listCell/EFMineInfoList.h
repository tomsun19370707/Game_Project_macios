//
//  EFMineInfoList.h
//  enjoyfun
//
//  Created by 李东阳 on 2019/10/6.
//  Copyright © 2019 锤子科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFMineInfoList : UITableViewCell
/** text*/
@property (nonatomic,strong) NSString *lab1Str,*lab2Str;
/** lab2 text align*/
@property (nonatomic,assign) NSTextAlignment lab2TextAlign;
/** color*/
@property (nonatomic,strong) UIColor *lab2TextColor;
/** 是否显示右侧arrow*/
@property (nonatomic,assign) BOOL isArrowShow;

@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;
@end
