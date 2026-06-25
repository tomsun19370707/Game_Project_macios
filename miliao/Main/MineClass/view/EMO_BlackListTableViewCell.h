//
//  EMO_BlackListTableViewCell.h
//  miliao
//
//  Created by 张世浩 on 2022/10/14.
//  Copyright © 2022 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface EMO_BlackListTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *model;

@property (nonatomic , copy) void(^quDingButtonClickBlock)(NSDictionary *model);


@end

NS_ASSUME_NONNULL_END
