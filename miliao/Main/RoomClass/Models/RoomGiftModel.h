//
//  RoomGiftModel.h
//  miliao
//
//  Created by aa on 2019/7/20.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RoomGiftModel : NSObject

@property (nonatomic, strong) NSString *giftID;
@property (nonatomic, strong) NSString *is_broadcast;//是否全服播报 1播报 0不播报
@property (nonatomic, strong) NSString *svga_file;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *price;



//@property (nonatomic, strong) NSString *price_004;
//@property (nonatomic, strong) NSString *img;
//@property (nonatomic, strong) NSString *show_img;
@property (nonatomic, strong) NSString *is_check;
@property (nonatomic, strong) NSString *type;
//@property (nonatomic, strong) NSString *show_img2;
@property (nonatomic, strong) NSString *e_name;
@property (nonatomic, strong) NSString *wares_type;/*1、宝石 2、礼物 3、卡片 */
@property (nonatomic, copy) NSString *num;
@property (nonatomic, strong) NSString *gift_id;
@property (nonatomic, assign) BOOL is_locked;
@property (nonatomic, assign) BOOL isLocked;

- (NSString *)realGiftId;

/**
 接收服务端原始背包列表，按三级主键策略 (gift_id > name > id) 进行聚合去重与数量累加
 */
+ (NSMutableArray<RoomGiftModel *> *)mergeBackpackGiftList:(NSArray<RoomGiftModel *> *)rawList userId:(nullable NSString *)userId;

@end

