//
//  UICollectionView+Custom.m
//  FaceShow
//
//  Created by skyz on 2018/1/9.
//  Copyright © 2018年 GChao. All rights reserved.
//

#import "UICollectionView+Custom.h"

@implementation UICollectionView (Custom)
- (void)collectionViewDisplayWithMsg:(NSString *)message ifNecessaryForRowCount:(CollectionViewType)tableType{
   UIView * backgroundView = [[UIView alloc]init];
   backgroundView.backgroundColor = self.backgroundColor;
   //显示样式
   UILabel * messageLab = [UILabel new];
   messageLab.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
   messageLab.textColor = [UIColor lightGrayColor];
   messageLab.textAlignment = NSTextAlignmentCenter;
   [messageLab sizeToFit];
   messageLab.text = message;
   [backgroundView addSubview:messageLab];
   self.backgroundView = backgroundView;
}
@end
