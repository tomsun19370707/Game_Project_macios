//
//  PublishControlView.h
//  miliao
//
//  Created by aa on 2019/7/12.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLChatBarDelegate.h"
NS_ASSUME_NONNULL_BEGIN
@class PublishControlView;
@protocol ControlViewDelegate <NSObject>

- (void)picBtnClick;
- (void)voiceBtnClick;

@end

@interface PublishControlView : UIView
@property (nonatomic, assign) id<TLChatBarDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *picBtn;
@property (weak, nonatomic) IBOutlet UIButton *expressionBtn;
@property (nonatomic, assign) KeyBoardStatus status;
@property (nonatomic,weak)id<ControlViewDelegate>Viewdelegate;
+(instancetype)controlView;


@end

NS_ASSUME_NONNULL_END
