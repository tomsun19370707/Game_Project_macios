//
//  EMO_RoomHostView.h
//  miliao
//
//  Created by aa on 2019/6/14.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "BaseView.h"
#import "SVGA.h"
@class MLRoomMessageModel;

@interface EMO_RoomHostView : BaseView

@property (nonatomic , copy) void(^roomHostViewClickBlock)(NSInteger idx);

//@property(nonatomic, copy) void (^paiHangBlock)(void);
@property (nonatomic, strong) SVGAImageView    *headSvgaImg;//房主头像框
@property (nonatomic, strong) UIImageView    *headIconImg;//房主头像框
@property (nonatomic, strong) NSArray *sequenceArray;
/** 房间信息*/
@property (nonatomic,strong) NSDictionary *currentRoomInfo;

//在线人数
@property (nonatomic, strong) NSMutableArray *onlineUserArray;
/////房间音乐
//@property(nonatomic, strong) UIButton *musicBtn;

//@property(nonatomic, copy) NSString *meiliStr;
//@property(nonatomic, copy) NSString *huoliStr;

@property(nonatomic, copy) void (^paiHangBangBlock)(void);
@property(nonatomic, copy) void (^noticeBlock)(void);
@property(nonatomic, copy) void (^muscianBlock)(void);
@property(nonatomic, copy) void (^peopleNumBlock)(void);
// 发送表情
- (void)shouEmojiToIcon:(MLRoomMessageModel *)model;
- (void)hostLeaveClick;
- (void)setWaveLayerToView;
- (void)setWaveLayerWithUid:(NSUInteger )uid volume:(NSUInteger )volume sequenceArray:(NSArray *)sequenceArray;
- (void)setWaveLayerWithUid:(NSUInteger )uid open:(BOOL)volume sequenceArray:(NSArray *)sequenceArray;
- (CGRect )hostFrameWithUserID:(NSString *)userID idx:(NSInteger )idx;

@end
