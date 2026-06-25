//
//  ResultHeaderView.h
//  miliao
//
//  Created by aa on 2019/8/8.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResultHeaderView : UIView
@property (nonatomic ,strong) NSString *title;
@property (nonatomic , copy) void(^moreBtnBlock)(void);
@end

NS_ASSUME_NONNULL_END
