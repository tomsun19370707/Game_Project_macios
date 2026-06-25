//
//  CFMPlayerMusicListVc.m
//
//  类介绍说明：
//
//
#import "BaseVC.h"

#import <UIKit/UIKit.h>

@interface CFMPlayerMusicListVc : BaseVC 
/** 选择了音频文件*/
@property (nonatomic,copy) void (^fetchSaveMusicFile)(NSString *musicUrl);


/** 可选，当前直播间 正在播放的音乐，用于回显*/
@property (nonatomic,strong) NSString *currentLiveRoomPlayMusic;
@end
