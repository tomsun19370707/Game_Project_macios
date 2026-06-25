#import <TargetConditionals.h>

#if TARGET_OS_SIMULATOR

#import <UIKit/UIKit.h>

// Mock CSPreMessageModel
typedef NS_ENUM(NSInteger, CSPreMessageType) {
    CSPreMessageTypeCustom = 1
};

@interface CSPreMessageModel : NSObject
@property (nonatomic, assign) CSPreMessageType msgType;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *imageUrl;
@end

@implementation CSPreMessageModel
@end

// Mock CSCustomInfoModel
@interface CSCustomInfoModel : NSObject
@property (nonatomic, copy) NSString *arg;
@property (nonatomic, copy) NSString *visitorId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, copy) NSString *wechat;
@property (nonatomic, copy) NSString *customInfo;
@end

@implementation CSCustomInfoModel
@end

// Mock CSVisitorChatViewController
@interface CSVisitorChatViewController : UIViewController
@property (nonatomic, copy) NSArray<CSPreMessageModel *> *preMessageModelArr;
- (instancetype)initWithArg:(NSString *)arg style:(NSString *)style;
- (instancetype)initWithArg:(NSString *)arg style:(NSString *)style chatViewFrame:(CGRect)chatViewFrame;
@end

@implementation CSVisitorChatViewController
- (instancetype)initWithArg:(NSString *)arg style:(NSString *)style {
    self = [super init];
    return self;
}
- (instancetype)initWithArg:(NSString *)arg style:(NSString *)style chatViewFrame:(CGRect)chatViewFrame {
    self = [super init];
    return self;
}
@end

// Mock CS53ServiceDelegate
@protocol CS53ServiceDelegate <NSObject>
@required
- (void)didFinishLoad;
@optional
- (void)didFailLoad;
- (void)didReadVisitorId:(NSString *)visitorId;
- (void)didReadUnreadTotalNum:(NSInteger)unreadTotalNum;
- (void)didReadData:(NSDictionary *)dic;
- (void)didReadOneConversation:(NSDictionary *)dic;
@end

// Mock CS53Manager
@interface CS53Manager : NSObject
@property (nonatomic, weak) id <CS53ServiceDelegate> delegate;
@property (nonatomic, copy) NSDictionary *chatConfig;
+ (instancetype)sharedManager;
- (void)startWithAppId:(NSString *)appId arg:(NSString *)arg;
- (void)login53ServiceWithVisitorId:(NSString *)visitorId;
- (void)quit53Service:(void(^)(BOOL))block;
- (void)registerDeviceToken:(id)deviceToken;
- (void)loadChatList;
- (void)registerCustomInfo:(CSCustomInfoModel *)customInfoModel;
@end

@implementation CS53Manager
+ (instancetype)sharedManager {
    static CS53Manager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CS53Manager alloc] init];
    });
    return manager;
}
- (void)startWithAppId:(NSString *)appId arg:(NSString *)arg {}
- (void)login53ServiceWithVisitorId:(NSString *)visitorId {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishLoad)]) {
            [self.delegate didFinishLoad];
        }
    });
}
- (void)quit53Service:(void(^)(BOOL))block {
    if (block) block(YES);
}
- (void)registerDeviceToken:(id)deviceToken {}
- (void)loadChatList {}
- (void)registerCustomInfo:(CSCustomInfoModel *)customInfoModel {}
@end

// Global string constants
NSString *const CSConfigKeyNavigationShow = @"CSConfigKeyNavigationShow";
NSString *const CSConfigKeyNavigationBackgroundColor = @"CSConfigKeyNavigationBackgroundColor";
NSString *const CSConfigKeyLeftChatBubbleBackgroundColor = @"CSConfigKeyLeftChatBubbleBackgroundColor";
NSString *const CSConfigKeyLeftChatTextColor = @"CSConfigKeyLeftChatTextColor";
NSString *const CSConfigKeyLeftChatBubbleRadius = @"CSConfigKeyLeftChatBubbleRadius";
NSString *const CSConfigKeyRightChatBubbleBackgroundColor = @"CSConfigKeyRightChatBubbleBackgroundColor";
NSString *const CSConfigKeyRightChatTextColor = @"CSConfigKeyRightChatTextColor";
NSString *const CSConfigKeyRightChatBubbleRadius = @"CSConfigKeyRightChatBubbleRadius";
NSString *const CSConfigKeySystemTipsBackgroundColor = @"CSConfigKeySystemTipsBackgroundColor";
NSString *const CSConfigKeySystemTipsTextColor = @"CSConfigKeySystemTipsTextColor";
NSString *const CSConfigKeyRefreshingHeaderText = @"CSConfigKeyRefreshingHeaderText";
NSString *const CSConfigKeyRefreshingHeaderColor = @"CSConfigKeyRefreshingHeaderColor";
NSString *const CSConfigKeyRefreshNoMoreDataHeaderText = @"CSConfigKeyRefreshNoMoreDataHeaderText";
NSString *const CSConfigKeyWelcomeText = @"CSConfigKeyWelcomeText";

#endif
