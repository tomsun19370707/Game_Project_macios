//
//  SearchCollectionView.h
//  miliao
//
//  Created by aa on 2019/8/7.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchCollectionView : UICollectionView
@property (nonatomic,strong)NSMutableArray *hotArray;
@property (nonatomic,strong)NSMutableArray *historyArray;
@end

NS_ASSUME_NONNULL_END
