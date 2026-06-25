//
//  EMO_SkillTableViewCell.h
//  miliao
//
//  Created by ZhangShiHao on 2023/7/3.
//  Copyright © 2023 EMO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMO_SkillTableViewCell : UITableViewCell

Strong NSDictionary *dicData;
Copy void (^BtnBlock)(NSDictionary *dic);

@end

NS_ASSUME_NONNULL_END
