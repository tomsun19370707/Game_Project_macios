//
//  EMO_FaminlCenterTableCell.h
//  miliao
//
//  Created by ZhangShiHao on 2023/7/4.
//  Copyright © 2023 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMO_FaminlCenterTableCell : UITableViewCell

Assign NSInteger type;
Strong NSDictionary *dicData;
Copy void (^BtnBlock)(NSDictionary *dic, NSInteger tag);


@end

NS_ASSUME_NONNULL_END
