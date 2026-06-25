//
//  TrendVoiceView.m
//  miliao
//
//  Created by aa on 2019/7/5.
//  Copyright © 2019 miliao. All rights reserved.
//

#import "TrendVoiceView.h"
#import <AVFoundation/AVFoundation.h>
@interface TrendVoiceView()<AVAudioPlayerDelegate>
{
    id timeObserve;
}
@property (nonatomic,strong)AVPlayer *player;
@property (nonatomic, strong) NSTimer *recordTimer; //录音定时器
@property (retain, nonatomic) AVAudioPlayer *audioPlayer;
@property (assign,nonatomic) int second;
@end
@implementation TrendVoiceView

+(instancetype)voiceView
{
    //XIB加载View
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}
//- (void)setup_UI {
//
//}

//- (void)stopPlayAVPlayer {
//    if (self.recordTimer) {
//            [self.recordTimer invalidate];
//            self.recordTimer = nil;
//            self.PlayBtn.selected = NO;
//        }
//    //    self.TimeLabel.text = NSStringFormat(@"%@s",self.playTime);
//       self.newTimeLabel.text = NSStringFormat(@"    %@s",self.playTime);
//    if ([self.audioPlayer isPlaying]) {
//        [self.audioPlayer stop];
//        self.audioPlayer.delegate = nil;
////        [self.audioPlayer re]
//    }
//}
- (void)awakeFromNib{
    [super awakeFromNib];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayAVPlayer) name:@"kStopAVPlayerNotification" object:nil];
    self.PlayBtn.selected = NO;
    self.TimeLabel.hidden = YES;
    [self addSubview:self.newTimeLabel];
    self.newTimeLabel.userInteractionEnabled = YES;
    self.newTimeLabel.clipsToBounds = YES;
    self.newTimeLabel.layer.cornerRadius = 20;
    self.newTimeLabel.frame = CGRectMake(0, 0, 200, 40);
    [self.newTimeLabel addSubview:self.shengboImageVIew];
    self.shengboImageVIew.frame = CGRectMake(200-120-20, 10, 120, 20);
    self.shengboImageVIew.userInteractionEnabled = YES;
    
    self.myPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     self.myPlayBtn.frame = CGRectMake(0, 0, 200, 40);
    [self addSubview:self.myPlayBtn];
    self.myPlayBtn.backgroundColor = UIColor.clearColor;
    self.myPlayBtn.hidden = NO;
    [self.myPlayBtn addTarget:self action:@selector(audioPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.myPlayBtn setTitle:@"播放" forState:UIControlStateNormal];
}
- (void)audioPlayBtnClick:(UIButton *)sender {
    UIButton *btn = sender;
    
    if (!self.isLocalPath) {
//        [self playWithUrl:btn];
        !self.playBtnActionBlock ?: self.playBtnActionBlock(self.myPlayBtn.selected);

    }
    else
    {
        [self playWithPath:self.myPlayBtn];
    }
//   self.myPlayBtn.selected = !self.myPlayBtn.selected;

}
- (UILabel *)newTimeLabel{
    if (!_newTimeLabel) {
        _newTimeLabel = [ControlCreator createLabel:self rect:CGRectMake(0, 0, 0, 0) text:@"10s" font:Font(18) color:UIColor.whiteColor backguoundColor:MHColorFromHexString(@"#5CACFF") align:NSTextAlignmentLeft lines:1];
    }
    return _newTimeLabel;
}
- (UIImageView *)shengboImageVIew{
    if (!_shengboImageVIew) {
        _shengboImageVIew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"声波"]];
    }
    return _shengboImageVIew;
}
//- (AVAudioPlayer *)audioPlayer{
//    if (!_audioPlayer) {
//        _audioPlayer = [[AVAudioPlayer alloc] init];
//    }
//    return _audioPlayer;
//}
- (void)playWithPath:(UIButton *)btn
{
    if (btn.selected) {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        if (_audioPlayer.isPlaying) {
            [_audioPlayer stop];
        }
        long long fileLength = [self fileSizeAtPath:self.audioUrl];
        MYLog(@"%lld",fileLength);
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:self.audioUrl] error:nil];
        
        _audioPlayer.delegate = self;
        [_audioPlayer play];
        
        [self startPlayTimer];
    }
    else
    {
        [_audioPlayer stop];
        [self stopPlayerTimer];
       
    }
    
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    self.myPlayBtn.selected = NO;
}
- (void)startPlayTimer
{
    [self stopPlayerTimer];
    self.second = 0;
    self.recordTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updatePlayTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.recordTimer forMode:NSRunLoopCommonModes];
    [self.recordTimer fire];
//    self.statusLabel.text = @"正在播放";
}
- (void)stopPlayerTimer
{
//
    if (self.recordTimer) {
        [self.recordTimer invalidate];
        self.recordTimer = nil;
        self.PlayBtn.selected = NO;
    }
//    self.TimeLabel.text = NSStringFormat(@"%@s",self.playTime);
   self.newTimeLabel.text = NSStringFormat(@"    %@s",self.playTime);
}
- (void)updatePlayTime
{
    if (self.second == [self.playTime intValue]) {
         [self stopPlayerTimer];
        return;
    }
    if (self.second <60) {
        _second ++;
    }
//    self.TimeLabel.text = [NSString stringWithFormat:@"%ds", [self.playTime intValue]- self.second];
    self.newTimeLabel.text = [NSString stringWithFormat:@"    %ds", [self.playTime intValue]- self.second];
}
//计算文件大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//- (void)playWithUrl:(UIButton *)btn
//{
//    AVPlayerItem *songitem;
//    if (btn.selected) {
//        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:self.audioUrl] options:nil];
//        songitem = [[AVPlayerItem alloc] initWithAsset:asset];
//       
//        self.player = [[AVPlayer alloc] initWithPlayerItem:songitem];
//        AVAudioSession * session  = [AVAudioSession sharedInstance];
//        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//        [session setActive:YES error:nil];
//        [songitem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//       
//        WEAK_SELF
//        timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//            float current = CMTimeGetSeconds(time);
//            float total = CMTimeGetSeconds(songitem.duration);
////            MYLog(@"current %f    total %f",current,total);
//            if (current) {
//                wselfTimeLabel.text = [NSString stringWithFormat:@"%.fs",total - current];
//            }
//            if(current == total)
//            {
//                [wselfplayer removeTimeObserver:timeObserve];
//                wselfplayer = nil;
//                wselfTimeLabel.text = wselfplayTime;
//                btn.selected = NO;
//            }
//        }];
//    }
//    else
//    {
//        [self.player pause];
//        if (timeObserve) {
//            [self.player removeTimeObserver:timeObserve];
//            timeObserve = nil;
//        }
//        self.player = nil;
//        self.TimeLabel.text = self.playTime;
//        [songitem removeObserver:self forKeyPath:@"status"];
//    }
//}
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"status"]) {
//        AVPlayerItem *item = (AVPlayerItem *)object;
//        //AVPlayerItemStatus *status = item.status;
//        if (item.status == AVPlayerItemStatusReadyToPlay) {
//            [self.player play];
//            //对播放界面的一些操作，时间、进度等
//        }
//    }
//}
@end
