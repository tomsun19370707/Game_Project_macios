//
//  BJGiftViewCell.h
//  miliao
//
//  Created by bianruifeng on 2019/12/11.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RoomGiftModel;
@class RoomFuDaiModel;
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, WZDLayoutButtonStyle) {
    WZDLayoutButtonStyleNone,
    WZDLayoutButtonStyleLeftImageRightTitle, /** 左图右文 */
    WZDLayoutButtonStyleLeftTitleRightImage, /** 左文右图 */
    WZDLayoutButtonStyleUpImageDownTitle, /** 上图下文 */
    WZDLayoutButtonStyleUpTitleDownImage /** 上文下图 */
};

@interface WZDLayoutButton : UIButton

/*
 * 图片和文字的间距，默认值0 (如需根据内容计算button的frame，不建议设置此方法)
 */
@property (nonatomic, assign) CGFloat midSpacing;

/**
 * 图片大小，默认值(30,30)
 */
@property (nonatomic,assign) CGSize imageSize;

/*
 * 布局方式
 */
@property (nonatomic, assign) WZDLayoutButtonStyle layoutStyle;


@end

@interface BJGiftViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView       *giftIcon;
@property (nonatomic, strong) WZDLayoutButton           *giftName;
@property (nonatomic, strong) UILabel           *giftPrice;
@property(nonatomic, strong) UILabel *packageGiftCount;//背包显示单个礼物数量

@property (nonatomic, strong) UIButton           *sendBtn;

@property (nonatomic, strong) UIButton           *selectBtn;

@property (nonatomic, strong) RoomGiftModel     *giftModel;
@property (nonatomic, strong) RoomFuDaiModel     *fuDaiModel;
@property (nonatomic, strong) NSIndexPath     *SelectIndexPath;




/// 填充数据
/// @param giftModel model
/// @param currentInex 当前是第几个，1，礼物，2，背包
-(void)configWithModel:(RoomGiftModel *)giftModel Index:(NSInteger)currentInex andIndexpath:(NSIndexPath *)SelectIndexPath;
//福袋
-(void)configWithFuDaiModel:(RoomFuDaiModel *)fuDaiModel Index:(NSInteger)currentInex andIndexpath:(NSIndexPath *)SelectIndexPath;

-(void)getIsSelected:(BOOL)isSelect andIndex:(NSInteger)currentInex andShow:(BOOL)clickView;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;


@property (nonatomic, strong) UIImageView       *lockIconImageView;
Copy void(^GiftBtnClick)(NSInteger type,NSIndexPath *indexPath);
Copy void(^sendGiftClick)(NSInteger num);
Copy void(^giftLongPressBlock)(RoomGiftModel *giftModel, NSIndexPath *indexPath);

@end





NS_ASSUME_NONNULL_END
