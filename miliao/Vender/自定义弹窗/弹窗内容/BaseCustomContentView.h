//
//  BaseCustomContentView.h
//  CustomAlertView
//
//  Created by mac on 2021/1/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseCustomContentView : UIView

//@property (nonatomic ,strong) void(^cancleBtnClick)(NSInteger tag);

@property (nonatomic ,strong) void(^cancleBtnClick)(NSDictionary *dicData);

- (void) addChildrenViews;
@end

NS_ASSUME_NONNULL_END
