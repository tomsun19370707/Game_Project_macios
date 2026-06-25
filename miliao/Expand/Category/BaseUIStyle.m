//
//  BaseUIStyle.m
//  君分时代
//
//  Created by 贠小飞 on 2018/4/10.
//  Copyright © 2018年 贠小飞. All rights reserved.
//

#import "BaseUIStyle.h"
#import "Global.h"

@implementation BaseUIStyle

- (float)topBarHeight{
    
    return ZJTopNavH;
}

-(UIColor *)topBarBgColor{
    return mainColor;
}

- (UIFont *)topBarTitleFont{
    return [UIFont systemFontOfSize:17];
}

- (UIColor *)topBarTitleColor{
    return MHColorFromHexString(@"#333333");
}

- (UIFont *)topBarButtionFont{
    return [UIFont systemFontOfSize:14];
}

- (UIColor *)topBarButtonTitleColor{
    return [UIColor whiteColor];
}

- (float)tabBarHeight {
    return 49.0f;
}

- (UIColor *)tabBarBgColor {
    return [UIColor whiteColor];
}


- (UIColor *)tableHeaderBgColor {
    return mainColor;
}

- (UIColor *)tableBgColor {
    return Color(247.0, 249.0, 250.0,1.0);
}

- (UIColor *)tableCellBgColor {
    return [UIColor clearColor];
}

- (UIColor *)tableSeparatorColor {
    return Color(204.0, 204.0, 204.0,1.0);
    
}


- (NSString *)bgImgName {
    return nil;
}

- (NSString *)bgMImgName {
    return nil;
}

- (UIColor *)bgColor {
    return mainColor;
    
}


@end
