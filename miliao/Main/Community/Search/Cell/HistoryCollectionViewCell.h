//
//  HistoryCollectionViewCell.h
//  miliao
//
//  Created by aa on 2019/8/7.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EdgeInsetsLabel.h"
#import "SearchModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HistoryCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) EdgeInsetsLabel *tagLabel;
@property (strong, nonatomic) SearchModel *model;
@end

NS_ASSUME_NONNULL_END
