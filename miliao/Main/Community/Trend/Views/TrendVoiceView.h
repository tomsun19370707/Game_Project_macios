//
//  TrendVoiceView.h
//  miliao
//
//  Created by aa on 2019/7/5.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrendVoiceView : UIView
@property (weak, nonatomic) IBOutlet UIButton *PlayBtn;
@property(nonatomic, strong) UIButton *myPlayBtn;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property(nonatomic, strong) UILabel *newTimeLabel;
@property (strong ,nonatomic) NSString *audioUrl;
@property (strong ,nonatomic) NSString *playTime;
@property (assign ,nonatomic) BOOL isLocalPath;
@property(nonatomic, strong) UIImageView *shengboImageVIew;
+(instancetype)voiceView;
@property (nonatomic , copy) void(^playBtnActionBlock)(BOOL btnSelected);
@end

NS_ASSUME_NONNULL_END
