//
//  EMO_RoomClickUserView.h
//  miliao
//
//  Created by aa on 2019/6/24.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "BaseView.h"

@class MLRoomMSequenceModel;

@interface EMO_RoomClickUserView : BaseView

@property (nonatomic , copy) void(^listClickBlock)(NSInteger idxe,MLRoomMSequenceModel *model);
- (void)setUpViewWithModel:(MLRoomMSequenceModel *)model;

@end
