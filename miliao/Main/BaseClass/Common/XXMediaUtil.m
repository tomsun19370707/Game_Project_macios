//
//  XXMediaUtil.m
//  XiXi
//
//  Created by 李东阳 on 2021/3/31.
//

#import "XXMediaUtil.h"
#import <AVKit/AVKit.h>
/** 选择相册视频*/
#import <MobileCoreServices/MobileCoreServices.h>
/** 相册图片浏览器*/
#import "TZImagePickerController.h"

static XXMediaUtil * mp = nil;

@interface XXMediaUtil ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/** 音频播放计时器*/
@property(nonatomic,strong)NSTimer * timer;
/** 回调*/
@property (nonatomic,copy) void (^imagePicker)(UIImage *image);
@property (nonatomic,copy) void (^videoPicker)(NSURL *videoUrl,UIImage *firstVideoImage);
@end

@implementation XXMediaUtil
/** 单例方法*/
+(instancetype)shared
{
    if (mp == nil) {
        static dispatch_once_t once_token;
        dispatch_once(&once_token, ^{
            mp = [[XXMediaUtil alloc] init];
        });
    }
    return mp;
}

#pragma mark --- 音频播放相关
- (instancetype)init
{
    self = [super init];
    if (self) {
        _player = [[AVPlayer alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endOfPlay:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

-(void)timerAction:(NSTimer * )sender
{
    // !! 计时器的处理方法中,不断的调用代理方法,将播放进度返回出去.
    // 一定要掌握这种形式.
    [self.delegate getCurTiem:[self valueToString:[self getCurTime]] Totle:[self valueToString:[self getTotleTime]] Progress:[self getProgress]];
}

/** 播放结束后的方法,由代理具体实现行为.*/
-(void) endOfPlay:(NSNotification *)sender
{
    // 为什么要先暂停一下呢?
    // 看看 musicPlay方法, 第一个if判断,你能明白为什么吗?
    [self musicPause];
    
    [self.delegate endOfPlayAction];
}

/** 观察者的处理方法, 观察的是Item的status状态.*/
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        switch ([[change valueForKey:@"new"] integerValue]) {
            case AVPlayerItemStatusUnknown:
                DLog(@"不知道什么错误");
                break;
            case AVPlayerItemStatusReadyToPlay:
                // 只有观察到status变为这种状态,才会真正的播放.
                [self musicPlay];
                break;
            case AVPlayerItemStatusFailed:
                // mini设备不插耳机或者某些耳机会导致准备失败.
                DLog(@"准备失败");
                break;
            default:
                break;
        }
    }
}

/** 准备播放,我们在外部调用播放器播放时,不会调用"直接播放",而是调用这个"准备播放",当它准备好时,会直接播放.*/
-(void)musicPrePlay
{
    // 通过下面的逻辑,只要AVPlayer有currentItem,那么一定被添加了观察者.
    // 所以上来直接移除之.
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    
    // 根据传入的URL(MP3歌曲地址),创建一个item对象
    // initWithURL的初始化方法建立异步链接. 什么时候连接建立完成我们不知道.但是它完成连接之后,会修改自身内部的属性status. 所以,我们要观察这个属性,当它的状态变为AVPlayerItemStatusReadyToPlay时,我们便能得知,播放器已经准备好,可以播放了.
    AVPlayerItem * item = [[ AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.mp3Url]];
    
    // 为item的status添加观察者.
    [item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    
    // 用新创建的item,替换AVPlayer之前的item.新的item是带着观察者的哦.
    [self.player replaceCurrentItemWithPlayerItem:item];
}


/** 播放*/
-(void)musicPlay
{
    // 如果计时器已经存在了,说明已经在播放中,直接返回.
    // 对于已经存在的计时器,只有musicPause方法才会使之停止和注销.
    if (self.timer != nil) {
        return;
    }
    
    // 播放后,我们开启一个计时器.
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    [self.player play];
}

/** 暂停方法*/
-(void)musicPause
{
    [self.timer invalidate];
    self.timer = nil;
    [self.player pause];
}

/** 跳转方法*/
-(void)seekToTimeWithValue:(CGFloat)value
{
    // 先暂停
    [self musicPause];
    
    // 跳转
    [self.player seekToTime:CMTimeMake(value * [self getTotleTime], 1) completionHandler:^(BOOL finished) {
        if (finished == YES) {
            [self musicPlay];
        }
    }];
}

/** 获取当前的播放时间*/
-(NSInteger)getCurTime
{
    if (self.player.currentItem) {
        // 用value/scale,就是AVPlayer计算时间的算法. 它就是这么规定的.
        // 下同.
        return self.player.currentTime.value / self.player.currentTime.timescale;
    }
    return 0;
}

/** 获取总时长*/
-(NSInteger)getTotleTime
{
    CMTime totleTime = [self.player.currentItem duration];
    if (totleTime.timescale == 0) {
        return 1;
    }else
    {
        return totleTime.value /totleTime.timescale;
    }
}

/** 获取当前播放进度*/
-(CGFloat)getProgress
{
    return (CGFloat)[self getCurTime]/ (CGFloat)[self getTotleTime];
}

/** 将整数秒转换为 00:00 格式的字符串*/
-(NSString *)valueToString:(NSInteger)value
{
    return [NSString stringWithFormat:@"%.2ld:%.2ld",value/60,value%60];
}


#pragma mark --- 视频播放相关
/** 播放全屏视频*/
+ (void)playVideoRestUrl:(NSString *)videoUrl
{
    /** 系统播放器*/
    //初始化AVPlayerViewController
    AVPlayerViewController *playerVc = [[AVPlayerViewController alloc]init];
    playerVc.showsPlaybackControls = YES ;
    // 设置显示的Frame
    playerVc.view.frame = AppDelegateInstance.window.bounds;

    /** 经过转义，防止有中文*/
    videoUrl = [videoUrl stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSURL *url=[NSURL URLWithString:(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)videoUrl,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8))];

    //设置流媒体视频路径
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVPlayerItem *item =[AVPlayerItem playerItemWithAsset:asset];

    //设置AVPlayer中的AVPlayerItem
    AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
    /** 赋值播放器*/
    playerVc.player = player;

    [Dn_NAVPUSH presentViewController:playerVc animated:YES completion:^{
        [playerVc.player play];
    }];
}

/** 播放本地路径视频*/
+ (void)playLocalVideoPath:(NSURL *)filePath
{
    /** 系统播放器*/
    //初始化AVPlayerViewController
    AVPlayerViewController *playerVc = [[AVPlayerViewController alloc]init];
    playerVc.showsPlaybackControls = YES ;
    // 设置显示的Frame
    playerVc.view.frame = AppDelegateInstance.window.bounds;

    NSURL *url= filePath ;

    //设置流媒体视频路径
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVPlayerItem *item =[AVPlayerItem playerItemWithAsset:asset];

    //设置AVPlayer中的AVPlayerItem
    AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
    /** 赋值播放器*/
    playerVc.player = player;

    [Dn_NAVPUSH presentViewController:playerVc animated:YES completion:^{
        [playerVc.player play];
    }];
}

#pragma mark --- 查看大图 看大图预览
/** 查看大图*/
+ (void)imagesPreviewDataUrlArr:(NSMutableArray *)arr index:(NSUInteger)index fatherVie:(UIView *)vie
{
//    /** 图片看大图*/
//    NSMutableArray *YBAry = [NSMutableArray array];
//    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSString *str = obj ;
//        // 网络图片
//        YBIBImageData *data0 = [YBIBImageData new];
//        data0.imageURL = [NSURL URLWithString:str];
//        [YBAry addObject:data0];
//    }];
//    // 设置数据源数组并展示
//    YBImageBrowser *browser = [YBImageBrowser new];
//    browser.dataSourceArray = YBAry;
//    browser.currentPage = index;
//    [browser show];
}


#pragma mark --- 调用系统方法获取单个图片或者视频
/** 图片选取回调  sourceType 1相册2相机*/
- (void)fetchImagePickerSourceType:(int)sourceType complete:(void(^)(UIImage *image))complete
{
    self.imagePicker = complete ;
    
    UIImagePickerControllerSourceType source = UIImagePickerControllerSourceTypeSavedPhotosAlbum ;
    if (sourceType == 2) {
        source = UIImagePickerControllerSourceTypeCamera ;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:source]) { // 如果当前机器支持sourceType(比如拍照，模拟器是不支持的)
        // 实例化UIImagePickerController控制器
        UIImagePickerController * imagePickerVC = [[UIImagePickerController alloc] init];
        // 设置资源来源
        imagePickerVC.sourceType = source;
        // 设置可用的媒体类型、默认只包含kUTTypeImage，如果想选择视频，请添加kUTTypeMovie
        imagePickerVC.mediaTypes = @[(NSString *)kUTTypeImage];
        // 设置代理，遵守UINavigationControllerDelegate, UIImagePickerControllerDelegate 协议
        imagePickerVC.delegate = self;
        // 是否允许编辑
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen ;
        // model出控制器
        [[ObjectTool SharedSettings].currentVC presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

/** 视频选择回调  sourceType 1相册2相机*/
- (void)fetchVideoPickerSourceType:(int)sourceType complete:(void(^)(NSURL *videoPath,UIImage *firstVideoImage))complete
{
    self.videoPicker = complete ;
    
    UIImagePickerControllerSourceType source = UIImagePickerControllerSourceTypeSavedPhotosAlbum ;
    if (sourceType == 2) {
        source = UIImagePickerControllerSourceTypeCamera ;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:source]) { // 如果当前机器支持sourceType(比如拍照，模拟器是不支持的)
        // 实例化UIImagePickerController控制器
        UIImagePickerController * imagePickerVC = [[UIImagePickerController alloc] init];
        // 设置资源来源
        imagePickerVC.sourceType = source;
        // 设置可用的媒体类型、默认只包含kUTTypeImage，如果想选择视频，请添加kUTTypeMovie
        imagePickerVC.mediaTypes = @[(NSString *)kUTTypeMovie];
        // 设置代理，遵守UINavigationControllerDelegate, UIImagePickerControllerDelegate 协议
        imagePickerVC.delegate = self;
        // 是否允许编辑
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen ;
        // model出控制器
        [[ObjectTool SharedSettings].currentVC presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

/** UIImagePickerControllerDelegate*/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info
{
    @weakify(self);
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        /** 图片*/
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage]; // 从info中取出图片资源 UIImagePickerControllerEditedImage 编辑后的图片    UIImagePickerControllerOriginalImage 原始图片
        if (self.imagePicker) {
            self.imagePicker(image);
        }
    }
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        /** 视频*/
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        /** 转化成mp4格式路径*/
        NSURL *mp4Url = [ObjectTool _videoConvert2Mp4:videoURL];
        /** 第一帧*/
        UIImage *image = [self getFirstImageWithViedoUrl:mp4Url] ;
        if (self.videoPicker) {
            self.videoPicker(mp4Url,image);
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


/** 获取多图，最多选择的数量，是否裁剪,可以从相册或者相机进行获取*/
- (void)fetchMutipleImagesMaxCount:(NSUInteger)maxCount isClip:(BOOL)isClip complete:(void(^)(NSArray<UIImage *> *photos))complete
{
    @weakify(self);
    DYActionSheet *sheet = [[DYActionSheet alloc]initWithTitleArr:@[@"相册",@"相机"]];
    [sheet setDActionSheetClick:^(int index, NSString *title) {
        switch (index) {
            case 0:
                {
                    /** 相册*/
                    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount delegate:nil];
                    /** 不允许拍摄和选取视频*/
                    imagePickerVc.allowPickingVideo = NO ;
                    imagePickerVc.allowTakeVideo = NO ;
                    /** 是否允许剪切*/
                    imagePickerVc.allowCrop = isClip ;
                    if (isClip) {
                        imagePickerVc.cropRect = CGRectMake(0, SCREEN_HEIGHT / 2 - SCREEN_WIDTH / 2, SCREEN_WIDTH, SCREEN_WIDTH);
                    }
                    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                        complete(photos);
                    }];
                    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
                    [[ObjectTool SharedSettings].currentVC presentViewController:imagePickerVc animated:YES completion:nil];
                }
                break;
            case 1:
                {
                    /** 相机*/
                    XXMediaUtil *tool = [XXMediaUtil shared];
                    /** 图片选取回调  sourceType 1相册2相机*/
                    [tool fetchImagePickerSourceType:2 complete:^(UIImage *image) {
                        complete(@[image]);
                    }];
                }
                break;
            default:
                break;
        }
    }];
    [sheet show];
}

/** 单张图片指定裁剪的大小*/
- (void)fetchClipedImageSize:(CGRect)clipRect complete:(void(^)(NSArray<UIImage *> *photos))complete
{
    /** 相册*/
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    /** 不允许拍摄和选取视频*/
    imagePickerVc.allowPickingVideo = NO ;
    imagePickerVc.allowTakeVideo = NO ;
    /** 是否允许剪切*/
    imagePickerVc.allowCrop = YES ;
    imagePickerVc.cropRect = clipRect;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        complete(photos);
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [[ObjectTool SharedSettings].currentVC presentViewController:imagePickerVc animated:YES completion:nil];
}


/** 获取视频的第一帧*/
- (UIImage *)getFirstImageWithViedoUrl:(NSURL *)url
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(SCREEN_WIDTH - 20, 480);
    NSError *error ;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(10, 10) actualTime:NULL error:&error];
    UIImage *image = [UIImage imageWithCGImage:img];
    DLog(@"error: %@",error);
    return image;
}

/** 获取本地视频 时长*/
- (int)getLocalVideoDuration:(NSURL *)path
{
    // 本地视频
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"开屏视频.mp4" ofType:nil];
//    NSURL *url = [NSURL fileURLWithPath:path];
    NSURL *url = path ;

    // 网络视频
//    NSString *path = @"http://aliyun.app.video.3dov.cn/Act-ss-mp4-hd/67975D3EC0663C70042D9A725167C244.mp4";
//    NSURL *url = [NSURL URLWithString:path];

    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    CMTime time = [asset duration];
    int seconds = ceil(time.value / time.timescale);

    DLog(@"视频时长: %d", seconds);

    return seconds;
}

/**  加载在线GIF并解析所有帧*/
- (void)loadGIFWithURL:(NSString *)url imageV:(UIImageView*)imageV
{
//    /** 普通的加载gif或者静图的方法*/
//    [imageV sd_setImageWithURL:[NSURL URLWithString:url]
//                  placeholderImage:nil
//                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (error) {
//            DLog(@"GIF加载失败: %@", error.localizedDescription);
//        } else {
//            DLog(@"GIF加载成功");
//        }
//    }];
    
    
    /** 可以暂停开始的方法*/
    // 使用SDWebImage下载GIF数据
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url]
                                                options:0
                                               progress:nil
                                              completed:^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (error) {
            DLog(@"GIF加载失败: %@", error.localizedDescription);
            return;
        }

        // 解析GIF数据，获取所有帧
        NSArray * gifFrames = [self framesFromGIFData:data];
        if (gifFrames.count == 0) {
            DLog(@"无法解析GIF帧");
            return;
        }

        // 初始化动画（默认播放）
        imageV.animationImages = gifFrames;
        imageV.animationDuration = image.duration; // 保持原GIF的播放时长
        imageV.animationRepeatCount = 0; // 无限循环
        [imageV startAnimating];
    }];
}

// 解析GIF数据，提取所有帧（核心方法）
- (NSArray<UIImage *> *)framesFromGIFData:(NSData *)data {
    NSMutableArray<UIImage *> *frames = [NSMutableArray array];
    
    // 使用ImageIO框架读取GIF数据
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if (!source) return frames;
    
    // 获取GIF的帧数
    size_t count = CGImageSourceGetCount(source);
    for (size_t i = 0; i < count; i++) {
        // 逐帧提取图片
        CGImageRef frameRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        if (frameRef) {
            UIImage *frame = [UIImage imageWithCGImage:frameRef];
            [frames addObject:frame];
            CGImageRelease(frameRef); // 释放内存
        }
    }
    
    CFRelease(source); // 释放资源
    return frames;
}

// 截取指定UIView的内容为UIImage
- (UIImage *)captureView:(UIView *)view {
    // 开启图形上下文（大小为view的 bounds， scale 设为屏幕scale避免模糊）
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [UIScreen mainScreen].scale);
    // 将view的图层绘制到上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 从上下文获取图片
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return capturedImage;
}

// 保存图片到相册
- (void)saveImageToAlbum:(UIImage *)image {
    if (!image) {
        DLog(@"图片为空，无法保存");
        return;
    }
    // 保存图片到相册，完成后调用saveImageCompletion方法
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

// 保存结果的回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        DLog(@"保存失败：%@", error.localizedDescription);
        [SVProgressHUD showTextHUDWithMessage:@"保存失败"];
    } else {
        DLog(@"保存成功");
        // 可在此处添加提示（如UIAlertController）
        [SVProgressHUD showTextHUDWithMessage:@"保存成功！"];
    }
}

/** 选择视频，合并从相册和相机选择*/
- (void)fetchVideoComplete:(void(^)(NSURL *videoPath,UIImage *firstVideoImage))complete
{
    @weakify(self);
    DYActionSheet *sheet = [[DYActionSheet alloc]initWithTitleArr:@[@"相册",@"相机"]];
    [sheet setDActionSheetClick:^(int index, NSString *title) {
        @strongify(self);
        if (index==0) {
            [self fetchVideoPickerSourceType:1 complete:^(NSURL *videoPath, UIImage *firstVideoImage) {
                complete(videoPath,firstVideoImage);
            }];
        }else if (index==1) {
            [self fetchVideoPickerSourceType:2 complete:^(NSURL *videoPath, UIImage *firstVideoImage) {
                complete(videoPath,firstVideoImage);
            }];
        }
    }];
    [sheet show];
}

@end

