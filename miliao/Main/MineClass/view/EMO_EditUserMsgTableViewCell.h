//
//  EMO_EditUserMsgTableViewCell.h
//  miliao
//
//  Created by 张世浩 on 2022/10/13.
//  Copyright © 2022 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMO_EditUserMsgTableViewCell : UITableViewCell
Strong NSDictionary *dicData;
@property(nonatomic,copy) NSString * changeStr;
@property(nonatomic,strong) UIImageView * headImgView;
@end

NS_ASSUME_NONNULL_END
