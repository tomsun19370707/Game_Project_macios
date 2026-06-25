//
//  UICollectionView+Custom.h
//  FaceShow
//
//  Created by skyz on 2018/1/9.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,CollectionViewType) {
   CollectionViewTypeNoData,//没有数据
   CollectionViewTypeError//出现错误
};
@interface UICollectionView (Custom)
/**数据请求*/
- (void)collectionViewDisplayWithMsg:(NSString *)message ifNecessaryForRowCount:(CollectionViewType)tableType;
@end
