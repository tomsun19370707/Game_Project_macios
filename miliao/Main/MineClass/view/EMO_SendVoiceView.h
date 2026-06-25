//
//  EMO_SendVoiceView.h
//  miliao
//
//  Created by ZhangShiHao on 2023/7/3.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_SendVoiceView : BaseView
@property (nonatomic,copy)void(^VoiceBlock)(NSString *voiceFilePath,NSInteger duration);


@end

NS_ASSUME_NONNULL_END
