//
//  EMO_RoomSettingView.h
//  miliao
//
//  Created by 张世浩 on 2022/10/21.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_RoomSettingView : BaseView

Copy void(^BtnClick)(NSInteger senderTag);

Strong NSString *type;

Assign BOOL allCloseMicrophone;

Assign BOOL isPlay;

@end

NS_ASSUME_NONNULL_END
