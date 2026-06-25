//
//  UITableViewCell+RoundCorner.h
//  HomeMaster
//
//  Created by Dylan on 2022/2/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (RoundCorner)

/** tableview 添加圆角,默认白色 whiteColor*/
- (void)setRoundCorner:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

/** tableview 添加圆角*/
- (void)setRoundCorner:(UITableView *)tableView  cellBgColor:(UIColor *)cellBgColor indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END

