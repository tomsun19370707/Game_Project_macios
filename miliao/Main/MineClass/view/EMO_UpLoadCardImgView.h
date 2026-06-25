//
//  EMO_UpLoadCardImgView.h
//  ARINASI
//
//  Created by 张世浩 on 2022/8/11.
//  Copyright © 2022 ZSH. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_UpLoadCardImgView : BaseView

@property(nonatomic,strong) NSDictionary * tipDic;
@property(nonatomic,strong) NSString * ZMStr;
@property(nonatomic,strong) NSString * FMStr;

@property(nonatomic,assign) NSInteger status;

@property(nonatomic,assign) NSInteger settleStatus;

@property(nonatomic,copy) void(^SelectPhotoBlock)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END
