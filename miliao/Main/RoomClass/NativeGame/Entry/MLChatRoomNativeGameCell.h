#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLChatRoomNativeGameCell : UICollectionViewCell

+ (NSString *)cellIdentifier;

- (void)configureWithTitle:(NSString *)title 
                 logoName:(NSString *)logoName 
                textColor:(UIColor *)textColor;

@end

NS_ASSUME_NONNULL_END
