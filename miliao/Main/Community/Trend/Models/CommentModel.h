//
//  CommentModel.h
//  miliao
//
//  Created by aa on 2019/7/18.
//  Copyright © 2019 miliao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentModel : NSObject
//动态id
@property (nonatomic, strong) NSString *Tid;
//发布人id
@property (nonatomic, strong) NSString *pid;
//图片字符串
@property (nonatomic,strong)NSString *user_id;

//文字内容
@property (nonatomic, strong) NSString *content;
//赞数
@property (nonatomic, strong) NSString *praise;

//发布时间
@property (nonatomic, strong) NSString *created_at;
//头像url
@property (nonatomic, strong) NSString *headimgurl;
//用户昵称
@property (nonatomic, strong) NSString *nickname;
//vip等级
@property (nonatomic, strong) NSString *vip_level;
//是否点赞
@property (nonatomic,strong) NSString *is_praise;
//回复
@property (nonatomic, strong) NSString *reply;
//cell高度
@property(assign,nonatomic) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
