//
//  EMO_RoomGameAlertView.h
//  miliao
//
//  Created by xxf on 2026/2/9.
//  Copyright © 2026 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMO_RoomGameAlertView : UIView
- (void)showInView:(UIView *)view ;
- (void)hideView;

@property (nonatomic, strong) void (^EMO_RoomGameAlertViewBlock)(NSDictionary *dic);

@end

NS_ASSUME_NONNULL_END
