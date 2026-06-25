//
//  ZFTableData.h
//  ZFPlayer
//
//  Created by 紫枫 on 2018/4/24.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

@interface ZFTableData : NSObject
@property (nonatomic, copy) NSString *message_id;
@property (nonatomic, copy) NSString *star_num;
@property (nonatomic, copy) NSString *updatetime_text;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *is_auth;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *comment_num;
@property (nonatomic, copy) NSMutableArray *imgs;
@property (nonatomic, copy) NSDictionary *user;
@property (nonatomic, copy) NSDictionary *comment_res;
@property (nonatomic, copy) NSString *refuse;
@property (nonatomic, copy) NSString *is_star;
@property (nonatomic, copy) NSString *is_auth_text;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *createtime_text;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) CGFloat video_width;
@property (nonatomic, assign) CGFloat video_height;


//@property (nonatomic, copy) NSString *nick_name;
//@property (nonatomic, copy) NSString *create_time;
//@property (nonatomic, copy) NSString *head;
//@property (nonatomic, copy) NSString *age;
//@property (nonatomic, copy) NSString *sex;
//@property (nonatomic, assign) NSInteger agree_num;
//@property (nonatomic, assign) NSInteger share_num;
//@property (nonatomic, assign) NSInteger post_num;
//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, assign) CGFloat thumbnail_width;
//@property (nonatomic, assign) CGFloat thumbnail_height;
//@property (nonatomic, assign) CGFloat video_duration;
//@property (nonatomic, assign) CGFloat video_width;
//@property (nonatomic, assign) CGFloat video_height;
//@property (nonatomic, copy) NSString *thumbnail_url;
//@property (nonatomic, copy) NSString *video_url;

@end
