//
//  TopicSegmentView.h
//  miliao
//
//  Created by aa on 2019/8/3.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicSegmentHeaderView.h"
NS_ASSUME_NONNULL_BEGIN

@interface TopicSegmentView : UIView
@property (nonatomic, assign) NSUInteger selectedIndex;

- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray *)controllers titleArray:(NSArray *)titleArray parentController:(UIViewController *)parentController;
@end

NS_ASSUME_NONNULL_END
