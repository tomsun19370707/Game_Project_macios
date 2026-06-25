//
//  DYSeachBarView.h
//  GroupPurchaseProject
//
//  Created by 李东阳 on 2018/7/9.
//  Copyright © 2018年 锤子科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DYSeachBarView ;
@protocol DYSeachBarViewDelegate <NSObject>
@optional
/**是否允许输入*/
- (BOOL)seachBarViewShouldBeginEditing:(DYSeachBarView *)seachBarView;
@end

@interface DYSeachBarView : UIView<UITextFieldDelegate>
/**代理*/
 @property(nonatomic,weak)id<DYSeachBarViewDelegate>delegate;
/**点击搜索，或者键盘收回时候，均会调用此方法*/
@property (nonatomic,copy)void(^seachViewDidEndEditing)(NSString *content);
/**文字内容*/
@property (nonatomic,strong)NSString *text;
/**文字placehoder*/
@property (nonatomic,strong)NSString *placeHoder;
/** 第一响应者*/
- (void)resignFirstResponderHandle;
- (void)becomeFirstResponderHandle;
@end


