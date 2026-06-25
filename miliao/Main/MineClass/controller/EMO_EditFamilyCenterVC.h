//
//  EMO_EditFamilyCenterVC.h
//  miliao
//
//  Created by ZhangShiHao on 2023/7/4.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_EditFamilyCenterVC : BaseController

Strong NSDictionary *dicData;

Copy void (^changeBlock)(NSMutableDictionary *dic);

@end

NS_ASSUME_NONNULL_END
