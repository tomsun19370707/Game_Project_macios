//
//  EMO_FriendsTableViewCell.h
//  miliao
//
//  Created by 张世浩 on 2022/10/15.
//  Copyright © 2022 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMO_FriendsTableViewCell : UITableViewCell
Strong NSDictionary *dicData;
Assign NSInteger indexType;
//Assign BOOL hidden;
@property(nonatomic,copy) void (^BtnBlock)(NSDictionary *dic);

Strong UILabel *IDLabel;
Strong UIButton *relieveBtn;

@end

NS_ASSUME_NONNULL_END
