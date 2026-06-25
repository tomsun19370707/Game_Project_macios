//
//  EMO_RenZhengViewController.h
//  miliao
//
//  Created by apple on 2020/3/24.
//  Copyright © 2020 miliao. All rights reserved.
//

#import "BaseController.h"
#import "EMO_UpLoadCardImgView.h"
NS_ASSUME_NONNULL_BEGIN

@interface EMO_RenZhengViewController : BaseController

Assign NSInteger showStatus;

@property(nonatomic,strong) EMO_UpLoadCardImgView * carView;

//100-正面照 200-背面照
Assign NSInteger Picturetype;

Strong NSString *carViewZMStr;
Strong NSString *carViewFMStr;
@end

NS_ASSUME_NONNULL_END
