//
//  BaseUIStyle.h
//  君分时代
//
//  Created by 贠小飞 on 2018/4/10.
//  Copyright © 2018年 贠小飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BaseUIStyle : NSObject


@property (nonatomic, readonly) float       topBarHeight;
@property (nonatomic, readonly) UIColor     *topBarBgColor;
@property (nonatomic, readonly) UIFont      *topBarTitleFont;
@property (nonatomic, readonly) UIColor     *topBarTitleColor;
@property (nonatomic, readonly) UIFont      *topBarButtionFont;
@property (nonatomic, readonly) UIColor     *topBarButtonTitleColor;

@property (nonatomic, readonly) float       tabBarHeight;
@property (nonatomic, readonly) UIColor     *tabBarBgColor;

@property (nonatomic, readonly) UIColor     *tableHeaderBgColor;
@property (nonatomic, readonly) UIColor     *tableBgColor;
@property (nonatomic, readonly) UIColor     *tableCellBgColor;
@property (nonatomic, readonly) UIColor     *tableSeparatorColor;

@property (nonatomic, readonly) NSString    *bgImageName;
@property (nonatomic, readonly) NSString    *bgMImageName;
@property (nonatomic, readonly) UIColor     *bgColor;


@end
