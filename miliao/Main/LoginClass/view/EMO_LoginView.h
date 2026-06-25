//
//  EMO_LoginView.h
//  miliao
//
//  Created by 张世浩 on 2022/10/10.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_LoginView : BaseView

@property(nonatomic,copy) void(^BtnBlick)(NSInteger tag,NSInteger type,NSDictionary *dic);

-(void)freshView:(NSInteger)type;

/** 是否勾选同意*/
@property (nonatomic,assign) BOOL isAgree;

@end

NS_ASSUME_NONNULL_END
