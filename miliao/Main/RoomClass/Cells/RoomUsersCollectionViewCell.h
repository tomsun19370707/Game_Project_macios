//
//  RoomUsersCollectionViewCell.h
//  miliao
//
//  Created by TonyStark on 2020/3/16.
//  Copyright © 2020 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLRoomMSequenceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RoomUsersCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) UIView *bkView;//边框view
@property(nonatomic, strong) UIImageView *iconView;//头像
@property(nonatomic, strong) UIButton *nameLabel;//名字/

@property(nonatomic, strong) MLRoomMSequenceModel *sequenModel;//麦位model
-(void)configWithModel:(MLRoomMSequenceModel *)sequenModel isSelect:(NSInteger)isSelected;
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
