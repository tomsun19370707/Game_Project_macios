//
//  EMO_RoomManagerView.h
//  miliao
//
//  Created by ZhangShiHao on 2023/7/10.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_RoomManagerView : BaseView


Copy void (^SuccessClick)(NSDictionary *dic, NSInteger typeStatus);


/** 刷新*/
-(void)GetData:(BOOL)fresh andkeyword:(NSString *)keyword;

@end

NS_ASSUME_NONNULL_END

