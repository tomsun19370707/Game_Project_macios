//
//  EMO_RoomManagerCell.h
//  miliao
//
//  Created by ZhangShiHao on 2023/7/10.
//  Copyright © 2023 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMO_RoomManagerCell : UITableViewCell

Strong NSDictionary *dicData;

@property (nonatomic , copy) void(^quDingButtonClickBlock)(NSDictionary *dic);

@end

NS_ASSUME_NONNULL_END
