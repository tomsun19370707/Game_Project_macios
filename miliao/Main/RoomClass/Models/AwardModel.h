//
//  AwardModel.h
//  miliao
//
//  Created by aa on 2019/9/5.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AwardModel : NSObject
//奖品id
@property (nonatomic, strong) NSString *giftID;
//奖品名称
@property (nonatomic, strong) NSString *name;
//奖品数量
@property (nonatomic, strong) NSString *num;
//奖品价格
@property (nonatomic, strong) NSString *price;
//奖品图片
@property (nonatomic, strong) NSString *show_img;
//是否公屏显示
@property(nonatomic, copy) NSString *is_public_play;
//是否所有房间播报
@property(nonatomic, copy) NSString *is_play;

//1都播报  （公屏播 全服播）  2全部都不播    3 公屏播 全服不播   4公屏不播  全服播
@property(nonatomic, copy) NSString *radio_event;

@end

NS_ASSUME_NONNULL_END
