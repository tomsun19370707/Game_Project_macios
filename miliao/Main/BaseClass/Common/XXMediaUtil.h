//
//  XXMediaUtil.h
//  XiXi
//
//  Created by 李东阳 on 2021/3/31.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/** 如果外界想使用本播放器,必须遵循和实现协议中的两个方法.*/
@protocol MusicPlayToolsDelegate <NSObject>

/** 外界实现这个方法的同时, 也将参数的值拿走了, 这样我们起到了"通过代理方法向外界传递值"的功能.*/
-(void)getCurTiem:(NSString *)curTime Totle:(NSString *)totleTime Progress:(CGFloat)progress;
/**  播放结束之后, 如何操作由外部决定.*/
-(void)endOfPlayAction;

@end


@interface XXMediaUtil : NSObject
/** 本类中的音频播放器指针.*/
@property(nonatomic,strong)AVPlayer * player;
/** 代理*/
@property(nonatomic,weak)id<MusicPlayToolsDelegate> delegate;
/** 音频播放的url*/
@property (nonatomic,strong) NSString *mp3Url;
/** 记录列表中正在播放的音频的cell*/
@property (nonatomic,strong) UITableViewCell *tempPlayingRedioVie;

/** 单例方法*/
+(instancetype)shared;

/** 音频播放器*/
/** 准备播放*/
-(void)musicPrePlay;
/** 播放音乐*/
-(void)musicPlay;
/** 暂停音乐*/
-(void)musicPause;
/** 跳转方法*/
-(void)seekToTimeWithValue:(CGFloat)value;

/** 使用util.tempPlayingRedioVie 记录列表中正在播放的音频的cell，
 当列表滚动到正在播放的cell不可见时候，暂停音乐播放。此方法在list控制器里使用。在音频播放和暂停的时候，记录和清空对应的tempPlayingRedioVie数值
 */
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    XXMediaUtil *util = [XXMediaUtil shareMusicPlay];
//    UITableViewCell *target = util.tempPlayingRedioVie ;
//    if (target) {
//        NSArray *arr = self.listTableview.visibleCells ;
//        /** 正在播放的cell 是否可见*/
//        BOOL isVisable = NO ;
//        for (UITableViewCell *temp in arr) {
//            if ([temp isEqual:target]) {
//                isVisable = YES ;
//                break;
//            }
//        }
//
//        /** 不可见的时候停止播放音乐*/
//        if (!isVisable) {
//            XXSquareZoneContent *vie = (XXSquareZoneContent *)target;
//            [vie pauseMusicHandle];
//        }
//    }
//}





/** 播放全屏视频*/
+ (void)playVideoRestUrl:(NSString *)videoUrl;

/** 播放本地路径视频*/
+ (void)playLocalVideoPath:(NSURL *)filePath;

/** 查看大图*/
+ (void)imagesPreviewDataUrlArr:(NSMutableArray *)arr index:(NSUInteger)index fatherVie:(UIView *)vie;




/** *************************************调用系统方法获取单个图片或者视频*************************************/

/** 图片选取回调  sourceType 1相册2相机*/
- (void)fetchImagePickerSourceType:(int)sourceType complete:(void(^)(UIImage *image))complete;

/** 视频选择回调  sourceType 1相册2相机*/
- (void)fetchVideoPickerSourceType:(int)sourceType complete:(void(^)(NSURL *videoPath,UIImage *firstVideoImage))complete;

/** *************************************调用系统方法获取单个图片或者视频*************************************/

/** 获取多图，最多选择的数量，是否裁剪,可以从相册或者相机进行获取*/
- (void)fetchMutipleImagesMaxCount:(NSUInteger)maxCount isClip:(BOOL)isClip complete:(void(^)(NSArray<UIImage *> *photos))complete;

/** 单张图片指定裁剪的大小*/
- (void)fetchClipedImageSize:(CGRect)clipRect complete:(void(^)(NSArray<UIImage *> *photos))complete;


/** 获取本地视频 时长*/
- (int)getLocalVideoDuration:(NSURL *)path ;

/** 选择视频，合并从相册和相机选择*/
- (void)fetchVideoComplete:(void(^)(NSURL *videoPath,UIImage *firstVideoImage))complete;

/**  加载在线GIF并解析所有帧*/
- (void)loadGIFWithURL:(NSString *)url imageV:(UIImageView*)imageV;

// 截取指定UIView的内容为UIImage
- (UIImage *)captureView:(UIView *)view ;

// 保存图片到相册
- (void)saveImageToAlbum:(UIImage *)image;


//XXMediaUtil *sh = [XXMediaUtil shared];
//[sh fetchImagePickerSourceType:1 complete:^(UIImage *image) {
//
//}];
@end


