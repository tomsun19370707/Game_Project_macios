//
//  BaseView.h
//  君分时代
//
//  Created by 贠小飞 on 2018/4/10.
//  Copyright © 2018年 贠小飞. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Global.h"
#import "BaseController.h"


@interface BaseView : UIView{
    
    BaseUIStyle *_uiStyle;
}
@property (nonatomic, assign) BaseController *parentVC;

- (void)loadData:(id)obj;
+ (NSInteger)HeightForView;
+ (NSInteger)WidthForView;


@end
