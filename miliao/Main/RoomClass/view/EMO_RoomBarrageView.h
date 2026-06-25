//
//  EMO_RoomBarrageView.h
//  miliao
//
//  Created by ZhangShiHao on 2023/7/7.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMO_RoomBarrageView : BaseView
@property (nonatomic , copy) void(^sureClickBlock)(NSInteger index);//1-下麦 2-上麦
@property (nonatomic, strong) NSString *shangMai;
@property (nonatomic, assign) BOOL isVoice;
@property (nonatomic, assign) BOOL isMai;
@property(nonatomic,assign)   BOOL isPlay;//是否静音
@property (strong, nonatomic) UIButton *giftBtn;
@property (strong, nonatomic) UIButton *messageBtn;
@property (strong, nonatomic) UILabel *messageNum;
@property (strong, nonatomic) UIButton *shangmaiNumBtn;
@property (strong, nonatomic)UIButton       *keyboardButton;
- (void)setAdminBarrage;
- (void)setNoAdminBarrage;

- (void)xiamaiSetUI;
- (void)shangxiamaiSetUI;

- (void)setPaimaiWithArry:(NSArray *)arry;

//-(void)kaiMai:(BOOL)Status;

-(void)kaiMai:(BOOL)Status andType:(NSInteger )type;


@property (nonatomic , copy) void(^scycleClickBlock)(NSInteger tag,NSInteger index,NSDictionary *dic);
//刷新游戏开关
-(void)scycleData;
@end

NS_ASSUME_NONNULL_END
