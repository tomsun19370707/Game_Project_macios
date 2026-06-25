//
//  EMO_TaskTableViewCell.h
//  miliao
//
//  Created by ZhangShiHao on 2023/6/30.
//  Copyright © 2023 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMO_TaskTableViewCell : UITableViewCell

Strong NSDictionary *dicData;

Copy void (^BtnBlock)(NSDictionary *dic);

@end

NS_ASSUME_NONNULL_END
