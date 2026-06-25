//
//  EMO_RoomTypeView.h
//  miliao
//
//  Created by ZhangShiHao on 2023/7/10.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_RoomTypeView : BaseView
Copy void(^BtnClick)(NSInteger senderTag,NSInteger type);


@end

NS_ASSUME_NONNULL_END
