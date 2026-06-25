//
//  EMO_SendVoiceView.m
//  miliao
//
//  Created by ZhangShiHao on 2023/7/3.
//  Copyright © 2023 EMO. All rights reserved.
//

#import "EMO_SendVoiceView.h"
#define isValidString(string)               (string && [string isEqualToString:@""] == NO)
#define ETRECORD_RATE 11025.0
#define ENCODE_MP3    1
#import "PlayerManager.h"
#import "ConvertAudioFile.h"

@interface EMO_SendVoiceView()<AVAudioRecorderDelegate,ConvertAudioFileDelagate,ETPlayerDelagate>
@property (nonatomic,strong) UILabel *tipLabel;
//@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIButton *recodeBtn;
@property (nonatomic,strong) UILabel *recodeLabel;

@property (nonatomic,strong) UIButton *delBtn;
@property (nonatomic,strong) NSString *mp3Path;
@property (nonatomic,strong) NSString *cafPath;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;
Assign BOOL haveVoice;//是否有录音
Assign BOOL recordeStatus;//录音状态
Assign BOOL playStatus;//播放录音状态

@end

@implementation EMO_SendVoiceView{
    NSInteger time;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.haveVoice=NO;
        self.recordeStatus=NO;
        self.playStatus=NO;
        [self tipLabel];
        [self recodeBtn];
        [self recodeLabel];
        [self delBtn];
        
        [ConvertAudioFile sharedInstance].delegate=self;
        [PlayerManager sharedInstance].delegate=self;
        
    }
    return self;
}


- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = getLanguage(@"语音介绍");
        _tipLabel.textColor = RGBA(0, 0, 0, 1);
        _tipLabel.textAlignment=NSTextAlignmentLeft;
        _tipLabel.font=KFont(14);
        [self addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KAdaptedHeight(0));
            make.leading.mas_equalTo(KAdaptedWidth(15));
            make.trailing.mas_equalTo(KAdaptedWidth(-15));
            make.height.mas_equalTo(KAdaptedHeight(30));
        }];
    }
    return _tipLabel;
}

- (UIButton *)recodeBtn{
    if (!_recodeBtn) {
        _recodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recodeBtn setImage:[UIImage imageNamed:@"soundRecordingImg"] forState:UIControlStateNormal];
        [_recodeBtn setImage:[UIImage imageNamed:@"soundRecordingImg"] forState:UIControlStateSelected];
//        [_recodeBtn setImage:[UIImage imageNamed:@"playRecordingImg"] forState:UIControlStateSelected];
        _recodeBtn.selected=NO;
        [_recodeBtn addTarget:self action:@selector(recodeClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_recodeBtn];
        [_recodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(KAdaptedWidth(0));
            make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(80), KAdaptedWidth(80)));
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(KAdaptedHeight(50));
            
        }];
    }
    return _recodeBtn;
}

- (UILabel *)recodeLabel{
    if (!_recodeLabel) {
        _recodeLabel = [[UILabel alloc] init];
        _recodeLabel.text = getLanguage(@"点击录制");
        _recodeLabel.textColor = RGBA(34, 34, 34, 1);
        _recodeLabel.textAlignment=NSTextAlignmentCenter;
        _recodeLabel.font=KFont(14);
        [self addSubview:_recodeLabel];
        [_recodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.recodeBtn.mas_bottom).offset(KAdaptedHeight(5));
            make.width.mas_equalTo(KAdaptedWidth(200));
            make.height.mas_equalTo(KAdaptedWidth(20));
            make.centerX.mas_equalTo(KAdaptedHeight(0));
        }];
    }
    return _recodeLabel;
}


- (UIButton *)delBtn{
    if (!_delBtn) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delBtn setTitle:getLanguage(@"刷新") forState:UIControlStateNormal];
        [_delBtn setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        _delBtn.titleLabel.font=KFontA(14);
        _delBtn.layer.borderColor=RGBA(102, 102, 102, 1).CGColor;
        _delBtn.layer.borderWidth=1;
        _delBtn.layer.cornerRadius=KAdaptedHeight(30)/2;
        _delBtn.layer.masksToBounds=YES;
        [_delBtn addTarget:self action:@selector(delVoiceFile) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_delBtn];
        [_delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.recodeBtn.mas_width);
            make.height.mas_equalTo(KAdaptedHeight(30));
            make.centerX.mas_equalTo(self.recodeBtn.mas_centerX);
            make.top.mas_equalTo(self.recodeLabel.mas_bottom).offset(KAdaptedHeight(10));
            
        }];
    }
    return _delBtn;
}







#pragma mark 提交音频
-(void)sendVoiceDataBlick{
    [SVProgressHUD show];
    [NetworkRequest uploadOneVoice:@"" parameters:nil path:[NSURL fileURLWithPath:self.mp3Path] fileName:@"file" progress:^(NSProgress *uploadProgress) {

    } success:^(id responObject) {
        NSLog(@"%@",responObject);
        if ([responObject[@"code"] integerValue]==1) {
            if (self.VoiceBlock) {
                self.VoiceBlock(responObject[@"data"][@"url"],self->time);
            }
        }
        
        [SVProgressHUD dismiss];

    } error:^(NSError *errors) {
        [SVProgressHUD dismiss];
    }];
    
    
    
    
}




#pragma mark 录制停止点击事件
-(void)recodeClick{
    
    if(self.haveVoice){
//        self.recodeBtn.selected=!self.recodeBtn.selected;
        if (self.playStatus) {
            [self PausePlay];//暂停
            NSLog(@"CCC");
        }else{
            NSLog(@"DDD");
            [self PlayVoice];//播放
        }
    }else{
        self.recordeStatus=!self.recordeStatus;
        if (self.recordeStatus) {
            [self startRecording];//开始
            NSLog(@"aaa");
        }else{
            NSLog(@"bbb");
            [self StopRecordA];//停止
            self.haveVoice=YES;
            [self.recodeBtn setImage:[UIImage imageNamed:@"playRecordingImg"] forState:UIControlStateNormal];
            [self.recodeBtn setImage:[UIImage imageNamed:@"playRecordingImg"] forState:UIControlStateSelected];
            
        }
    }
   
}

#pragma mark 播放暂停点击事件
-(void)PlayClick:(UIButton *)sender{
    
    if(self.haveVoice){
        
    }
    

    
}


#pragma mark 删除音频点击事件
-(void)delVoiceFile{
    
    BOOL isDir = FALSE;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:self.cafPath isDirectory:&isDir];
    if (!isDirExist) {
        NSLog(@"--------  录音文件不存在...");
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"暂无录音!")];
        return;
    }
    
    if (self.recordeStatus) {
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"录音中无法删除!")];
        return;
    }
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否删除录音?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cleanMp3File];
        [self cleanCafFile];
        self.haveVoice=NO;
        self.recordeStatus=NO;
        self.playStatus=NO;
        [self.recodeBtn setImage:[UIImage imageNamed:@"soundRecordingImg"] forState:UIControlStateNormal];
        [self.recodeBtn setImage:[UIImage imageNamed:@"soundRecordingImg"] forState:UIControlStateSelected];
        if (self.VoiceBlock) {
            self.VoiceBlock(@"",0);
        }
        self->_recodeLabel.text = getLanguage(@"点击录音");
        
    }]];
    [[Common getCurrentVC] presentViewController:alert animated:YES completion:nil];
 

}
#pragma mark ConvertAudioFileDelagate
-(void)ConvertAudioFileTranscoding:(BOOL)Status{
    if (Status) {
        if (self.VoiceBlock) {
            self.VoiceBlock(self.mp3Path,time);
        }
        NSLog(@"录音成功");
    }else{
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"录音失败请重试")];
    }
    
}
#pragma mark ETPlayerDelagate
- (void)currentPlayerStatus:(ETPlayerStatus)playerStatus{
    if (playerStatus==ETPlayer_FinishedPlay) {
        
        [self PausePlay];//暂停
        
    }
}

#pragma mark 开始录制
-(void)startRecording{
    // 重置录音机
    if (_audioRecorder) {
        [self cleanMp3File];
        [self cleanCafFile];
        _audioRecorder = nil;
        time = 0;
        [self destoryTimer];
    }
    
    if (![self.audioRecorder isRecording]) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil){
            NSLog(@"Error creating session: %@", [sessionError description]);
        } else{   [session setActive:YES error:nil];
        
        }
        
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(record)
                                                    userInfo:nil
                                                     repeats:YES];
        [self.audioRecorder record];

         NSLog(@"录音开始");
        
#if ENCODE_MP3
         [[ConvertAudioFile sharedInstance] conventToMp3WithCafFilePath:self.cafPath
                                                           mp3FilePath:self.mp3Path
                                                            sampleRate:ETRECORD_RATE
                                                              callback:^(BOOL result)
         {
             if (result) {
                 NSLog(@"mp3 file compression sucesss");
             }
         }];
#endif
        
    } else {
        
        NSLog(@"is  recording now  ....");
    }
}
#pragma mark 停止录制
-(void)StopRecordA{
    if ([self.audioRecorder isRecording]) {
        NSLog(@"完成");
        [self destoryTimer];
        [self.audioRecorder stop];
    }

#if !ENCODE_MP3
    [ConvertAudioFile conventToMp3WithCafFilePath:self.cafPath
                                      mp3FilePath:self.mp3Path
                                       sampleRate:ETRECORD_RATE
                                         callback:^(BOOL result) {
                                             NSLog(@"转码结果 ------ %d", result);
    }];
    
#endif
}


#pragma mark 播放
-(void)PlayVoice{
    
    if ([self.audioRecorder isRecording]) {
        NSLog(@"--------  正在录制中...");
        [self StopRecordA];
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:self.cafPath isDirectory:&isDir];
    if (!isDirExist) {
        NSLog(@"--------  录音文件不存在...");
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"请先录制音频")];
//        self.playButton.selected=NO;
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:self.mp3Path];
    [[PlayerManager sharedInstance] playWithVoiceURL:url];
    
    if (self.timer) {
        [self destoryTimer];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                   target:self
                                                 selector:@selector(play)
                                                 userInfo:nil
                                                  repeats:YES];
}

#pragma mark 暂停播放
-(void)PausePlay{
//    [[PlayerManager sharedInstance] pause];//暂停
    [[PlayerManager sharedInstance] stop];//停止
    [self destoryTimer];
    self.playStatus=NO;
}



- (void)play {
    self.playStatus=YES;
     self.recodeLabel.text = [NSString stringWithFormat:@"%@ / %@",
                            [self timeFormatted:[PlayerManager sharedInstance].currentTime],
                            [self timeFormatted:[PlayerManager sharedInstance].finishTime]];
}



/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
- (AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        //7.0第一次运行会提示，是否允许使用麦克风
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil){
            NSLog(@"Error creating session: %@", [sessionError description]);
        }else{
            [session setActive:YES error:nil];
        }
          
        
        //创建录音文件保存路径
        NSURL *url= [self getSavePath];
        //创建录音格式设置
        NSDictionary *setting = [self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        [_audioRecorder prepareToRecord];
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
- (NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    [dicM setObject:@(ETRECORD_RATE) forKey:AVSampleRateKey];
    [dicM setObject:@(2) forKey:AVNumberOfChannelsKey];
    [dicM setObject:@(16) forKey:AVLinearPCMBitDepthKey];
    [dicM setObject:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    return dicM;
}

/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSURL *)getSavePath{
    //  在Documents目录下创建一个名为FileData的文件夹
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"AudioData"];
    NSLog(@"%@",path);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if(!(isDirExist && isDir))
        
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"创建文件夹失败！");
        }
        NSLog(@"创建文件夹成功，文件路径%@",path);
    }
    NSString *fileName = @"record";
    NSString *cafFileName = [NSString stringWithFormat:@"%@.caf", fileName];
    NSString *mp3FileName = [NSString stringWithFormat:@"%@.mp3", fileName];
    
    NSString *cafPath = [path stringByAppendingPathComponent:cafFileName];
    NSString *mp3Path = [path stringByAppendingPathComponent:mp3FileName];
    
    self.mp3Path = mp3Path;
    self.cafPath = cafPath;
    
    NSLog(@"file path:%@",cafPath);
    
    NSURL *url=[NSURL fileURLWithPath:cafPath];
    return url;
}

- (void)cleanCafFile {
    
    if (isValidString(self.cafPath)) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = FALSE;
        BOOL isDirExist = [fileManager fileExistsAtPath:self.cafPath isDirectory:&isDir];
        if (isDirExist) {
            [fileManager removeItemAtPath:self.cafPath error:nil];
            NSLog(@"  xxx.caf  file   already delete");
        }
    }
}

- (void)cleanMp3File {
    
    if (isValidString(self.mp3Path)) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = FALSE;
        BOOL isDirExist = [fileManager fileExistsAtPath:self.mp3Path isDirectory:&isDir];
        if (isDirExist) {
            [fileManager removeItemAtPath:self.mp3Path error:nil];
            NSLog(@"  xxx.mp3  file   already delete");
        }
    }
}


- (void)convertMp3 {
    
    
        [[ConvertAudioFile sharedInstance] conventToMp3WithCafFilePath:self.cafPath
                                                           mp3FilePath:self.mp3Path
                                                            sampleRate:ETRECORD_RATE callback:^(BOOL result)
        {
            NSLog(@"---- 转码完成  --- result %d  ---- ", result);
        }];;
 

}


- (void)record {
    time ++;
    self.recodeLabel.text = [self timeFormatted:(int)time];
    if (time==60) {
        [self StopRecordA];
        [SVProgressHUD showImage:KGetImage(@"") status:getLanguage(@"最长录制60秒")];
    }
}


- (void)destoryTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        NSLog(@"----- timer destory");
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
        NSLog(@"----- 录音  完毕");
        if (self.VoiceBlock) {
            self.VoiceBlock(self.mp3Path,time);
        }
        
#if ENCODE_MP3
        [[ConvertAudioFile sharedInstance] sendEndRecord];;
#endif
        
    }
}

- (NSString *)timeFormatted:(NSInteger)totalSeconds {
    
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    if (hours <= 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes, (long)seconds];
    }
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
}





@end
