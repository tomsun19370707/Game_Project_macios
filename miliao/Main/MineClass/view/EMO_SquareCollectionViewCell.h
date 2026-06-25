//
//  EMO_SquareCollectionViewCell.h
//  miliao
//
//  Created by 张世浩 on 2022/12/27.
//  Copyright © 2022 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EMO_SquareCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong) PackModel *model;
@property (nonatomic ,strong) UIImageView *selectImageView;
@end

NS_ASSUME_NONNULL_END
