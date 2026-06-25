//
//  EMO_RoomSQSMView.h
//  miliao
//
//  Created by jkkj on 2021/7/6.
//  Copyright © 2021 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMO_RoomSQSMView : UIView
@property (nonatomic , copy) void(^SQBlock)(NSDictionary *dic);
- (void)showView;
- (void)hideView;

@property (nonatomic,assign)BOOL freshDara;

@end

NS_ASSUME_NONNULL_END
