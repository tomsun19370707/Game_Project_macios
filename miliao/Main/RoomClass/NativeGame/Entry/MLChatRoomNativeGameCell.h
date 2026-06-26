#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLChatRoomNativeGameCell : UITableViewCell

+ (NSString *)cellIdentifier;

- (void)configureWithTitle:(NSString *)title 
                  subtitle:(NSString *)subtitle 
                 bgImgName:(NSString *)bgImgName 
                 logoImgName:(NSString *)logoImgName;

@end

NS_ASSUME_NONNULL_END
