//
//  EMO_CommentHeadView.h
//  miliao
//
//  Created by ZhangShiHao on 2023/7/17.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseView.h"
#import "MessageInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EMO_CommentHeadView : BaseView

Copy void(^BtnClick)(NSMutableDictionary *dic,NSInteger tag);

Strong NSMutableDictionary *dicData;

@end

NS_ASSUME_NONNULL_END
