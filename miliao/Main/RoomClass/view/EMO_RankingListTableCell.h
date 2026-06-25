//
//  EMO_RankingListTableCell.h
//  miliao
//
//  Created by 张世浩 on 2022/10/26.
//  Copyright © 2022 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMO_RankingListTableCell : UITableViewCell
/** 0财富榜 1魅力榜*/
@property (nonatomic,assign) NSInteger titleSelectTag;

Strong NSDictionary *dicData;

Assign NSInteger rowindex;

@end

NS_ASSUME_NONNULL_END
