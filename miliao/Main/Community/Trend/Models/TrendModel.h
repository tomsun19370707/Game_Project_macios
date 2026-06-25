//
//  TrendModel.h
//  miliao
//
//  Created by aa on 2019/7/6.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "PicUrlModel.h"
//#import "TagsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendModel : NSObject
//动态id
@property (nonatomic, strong) NSString *uid;
//发布人id
@property (nonatomic, strong) NSString *user_id;
//图片字符串
@property (nonatomic,strong)NSString *image;
//录音
@property (nonatomic, strong) NSString *audio;
//视频
@property (nonatomic, strong) NSString *video;
//文字内容
@property (nonatomic, strong) NSString *content;
//赞数
@property (nonatomic, strong) NSString *praise;
//标签id
@property (nonatomic, strong) NSString *tags;
//发布时间
@property (nonatomic, strong) NSString *addtime;
//点赞、评论时间
@property (nonatomic, strong) NSString *like_time;
//收藏的时间
@property (nonatomic, strong) NSString *created_at;
//头像url
@property (nonatomic, strong) NSString *headimgurl;
//用户昵称
@property (nonatomic, strong) NSString *nickname;
//性别 1:男 2：女
@property (nonatomic, strong) NSString *sex;
//标签字符串
@property (nonatomic, strong) NSString *tags_str;
//评论数
@property (nonatomic, strong) NSString *talk_num;
//点赞数
@property (nonatomic, strong) NSString *praise_num;
//转发数
@property (nonatomic, strong) NSString *forward_num;
//是否收藏
@property (nonatomic, strong) NSString *is_collect;
//vip等级
@property (nonatomic, strong) NSString *vip_level;
//是否点赞
@property (nonatomic,strong)NSString *is_praise;
//是否关注
@property (nonatomic,strong)NSString *is_follow;
//录音时长
@property (nonatomic,strong)NSString *audio_time;
//是否置顶 1置顶 2非置顶
@property (nonatomic,strong)NSString *is_top;
// 图片集合
@property (nonatomic, strong) NSArray *image_urList;
// 标签集合
@property (nonatomic, strong) NSArray *tags_nameList;
//cell高度
@property(assign,nonatomic) CGFloat cellHeight;
//tagsView高度
@property(assign,nonatomic) CGFloat tagsViewHeight;
//内容高度
@property(assign,nonatomic) CGFloat contentLabelHeight;
//cell高度
@property(assign,nonatomic) CGFloat detailcellHeight;
//image高度
@property(assign,nonatomic) CGFloat imageHeight;
//image高度
@property(assign,nonatomic) CGFloat detailImageHeight;
@property (assign,nonatomic) BOOL isPlay;

@end

NS_ASSUME_NONNULL_END
