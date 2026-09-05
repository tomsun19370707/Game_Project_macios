//
//  MLChatRoomThemeGameSixFusionDialog.h
//  miliao
//
//  Created for Game 6 (玲珑珍宝塔) 门票融合说明与合成弹窗.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MLTowerGameSixTicketTypeModel;

@interface MLChatRoomThemeGameSixFusionDialog : UIView

/// 融合成功或已有门票的回调通知
@property (nonatomic, copy, nullable) void (^onFusionSuccessBlock)(void);

/// 预置服务端状态版本号
@property (nonatomic, assign) NSInteger stateVersion;

/// 预置服务端门票配置列表
@property (nonatomic, strong, nullable) NSArray<MLTowerGameSixTicketTypeModel *> *ticketTypes;

/// 预置是否有进行中挑战状态
@property (nonatomic, assign) BOOL hasActiveTicket;

- (void)setTicketTypes:(NSArray<MLTowerGameSixTicketTypeModel *> *)ticketTypes;
- (void)setHasActiveTicket:(BOOL)hasActiveTicket;

/// 弹出门票融合说明与合成对话框
/// @param parentView 父视图（传 nil 默认使用 keyWindow）
+ (instancetype)showInView:(nullable UIView *)parentView;

@end

NS_ASSUME_NONNULL_END
