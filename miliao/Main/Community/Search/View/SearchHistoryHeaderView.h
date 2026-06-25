//
//  SearchHistoryHeaderView.h
//  miliao
//
//  Created by aa on 2019/8/7.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchHistoryHeaderView : UICollectionReusableView
@property (nonatomic,strong) NSString *title;
@property (nonatomic , copy) void(^deleteHistoryBlock)(void);
@end

NS_ASSUME_NONNULL_END
