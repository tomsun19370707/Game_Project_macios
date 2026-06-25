//
//  EMO_WebViewController.h
//  NormalProject
//
//  Created by 大靠山Mac mini on 2021/11/19.
//  Copyright © 2021 WYL. All rights reserved.
//

#import "BaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_WebViewController : BaseController
@property (nonatomic,assign)NSInteger pushType;
@property (nonatomic,strong)NSString *titleType;
@property (nonatomic,strong)NSString *strUrl;
@end

NS_ASSUME_NONNULL_END
