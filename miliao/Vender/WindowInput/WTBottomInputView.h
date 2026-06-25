#import <UIKit/UIKit.h>
@protocol WTBottomInputViewDelegate <NSObject>
-(void)WTBottomInputViewSendTextMessage:(NSString *)message;
@end
@interface WTBottomInputView : UIView
@property (nonatomic, strong) UIButton * senderBtn;
@property (nonatomic, strong) UITextView * textView;
@property(nonatomic,weak)id<WTBottomInputViewDelegate>delegate;
- (void)showView;
- (void)hideView;


@end
