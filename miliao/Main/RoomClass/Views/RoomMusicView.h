//
//  RoomMusicView.h
//  miliao
//
//  Created by aa on 2019/7/9.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "BaseView.h"

@class RoomMusicModel;

@interface RoomMusicView : BaseView


@property (nonatomic, strong) UISlider              *sliderView;
@property (nonatomic, strong) NSTimer               *timer;

@property (nonatomic, strong) UIButton              *playAndPauseBtn;
@property (nonatomic, assign) BOOL                  isPlay;

@property (nonatomic, strong) UISlider              *volumeSliderView;
@property (nonatomic, strong) UIImageView              *volumeImgageView;

@property (nonatomic, strong) RoomMusicModel        *model;
@property (nonatomic, strong) NSMutableArray        *soundArray;

@property (nonatomic , copy) void(^onAButtonClickBlock)(void);
@property (nonatomic , copy) void(^nextButtonClickBlock)(void);

@property (nonatomic , copy) void(^orderButtonClickBlock)(NSString *circular);
@property (nonatomic , copy) void(^playSoundClickBlock)(RoomMusicModel *model);

@property (nonatomic , copy) void(^musicFileClickBlock)(void);

@property (nonatomic , copy) void(^playAndPauseButonClickBlock)(RoomMusicModel *model, BOOL isPlay);

@property (nonatomic , copy) void(^sliderValueChangedBlock)(CGFloat sliderValue);

@property (nonatomic , copy) void(^volumeSliderValueChangedBlock)(CGFloat sliderValue);



- (void)setSliderPlay;

- (void)setSliderCurrentValue:(CGFloat )currentValue maximumValue:(CGFloat)maximumValue;

@end
