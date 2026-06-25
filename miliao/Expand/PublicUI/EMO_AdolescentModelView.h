//
//  EMO_AdolescentModelView.h
//  miliao
//
//  Created by jkkj on 2023/10/30.
//  Copyright © 2023 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//青少年模式
@interface EMO_AdolescentModelView : UIView
- (void)viewHide;
- (void)viewShow;
Copy void(^adolescentBlock)();
@end

NS_ASSUME_NONNULL_END
