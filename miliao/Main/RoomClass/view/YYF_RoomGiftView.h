//
//  YYF_RoomGiftView.h
//  miliao
//
//  Created by 张世浩 on 2022/12/6.
//  Copyright © 2022 miliao. All rights reserved.
//

#import "BaseView.h"
#import "MLRoomMSequenceModel.h"
@class RoomGiftModel;
@class RoomFuDaiModel;
@interface YYF_RoomGiftView : BaseView

@property (nonatomic , copy) void(^handselBUttonClickBlock)(NSArray *userSelectedArray, RoomGiftModel *giftModel, NSString *giftNum, NSString *currentType);
@property (nonatomic , copy) void(^senderBackPackBlock)(MLRoomMSequenceModel *userModel,NSArray *giftArray);
@property (nonatomic , copy) void(^handselFuDaiBUttonClickBlock)(NSArray *userSelectedArray, RoomFuDaiModel *fuDaiModel, NSString *giftNum, NSString *currentType);

@property (nonatomic, strong) NSMutableArray *giftArray;        ///< 一般的礼物
@property (nonatomic, strong) NSMutableArray *gemArray;         ///< 宝石
@property (nonatomic, strong) NSMutableArray *myArray;
@property (nonatomic, strong) NSMutableArray *fudaiArray;   //福袋
@property (nonatomic, assign) NSInteger currentType;
@property(nonatomic, strong) UILabel *backPackPriceLabel;//背包总价值
//@property(nonatomic, copy) NSString *meiliStr;//主播魅力值

@property (nonatomic , copy) void(^topUpButtonClickBlock)(void);

- (void)setGiftCarouse:(NSMutableArray *)giftCarouseArray userCarousel:(NSMutableArray *)userCarouselArray userMiZuan:(NSString *)miZuan allUsers:(NSArray *)allUsers andUserNum:(NSInteger )allNum;
-(void)uploadType:(NSInteger)tag;

@end

