//
//  EMO_MyGuildTableViewCell.h
//  miliao
//
//  Created by 张世浩 on 2022/10/18.
//  Copyright © 2022 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMO_MyGuildTableViewCell : UITableViewCell
Strong NSDictionary *dicData;
@property(nonatomic,copy) void (^BtnBlock)(NSDictionary *dic);


@end

NS_ASSUME_NONNULL_END
