#import <UIKit/UIKit.h>
#import "DB_CustomContentView.h"
#import "BlessingBagCustomCententView.h"
#import "WinningRecordCustomView.h"
#import "GiftDescriptionCustomView.h"
#import "AddTalkCustomView.h"
#import "EMO_DBCustomRoomTypeView.h"


NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    AlertType_Top = 0,
    AlertType_Meddle,
    AlertType_Bottom,
} AlertType;
typedef enum : NSUInteger {
    DB_CustomContentViewTag =0,        //金币充值
    BlessingBagCustomCententViewTag,   //福袋
    WinningRecordCustomViewTag,        //福袋中奖记录
    GiftDescriptionCustomViewTag,        //福袋礼物说明
    AddTalkCustomViewTag,              //添加话题
    EMO_DBCustomRoomTypeViewTag,       //房间分区
   
} ContentType;
@interface CustomAlertViewA : UIView
@property (nonatomic ,strong) DB_CustomContentView *mytestContentView;
@property (nonatomic ,strong) BlessingBagCustomCententView *CustomFuDaiView;
@property (nonatomic ,strong) WinningRecordCustomView *CustomRecordView;
@property (nonatomic ,strong) GiftDescriptionCustomView *CustomGiftView;
@property (nonatomic ,strong) AddTalkCustomView *CustomAddTalkView;

@property (nonatomic ,strong) EMO_DBCustomRoomTypeView *customRoomTypeView;

+(instancetype) showAlertView_Type:(AlertType)showType ContentType:(ContentType)contentType andData:(NSDictionary *)dic;
@property (nonatomic ,strong) void (^cancleCallback)(void);
@property (nonatomic ,assign) UIEdgeInsets alertInset;
@end
NS_ASSUME_NONNULL_END
