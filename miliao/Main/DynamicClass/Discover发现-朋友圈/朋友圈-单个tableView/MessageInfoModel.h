//
//  MessageInfoModel.h
//  MeetHer
//
//  Created by 张世浩 on 2023/3/6.
//

#import "BaseModel.h"
#import "CommentInfoModel.h"
#import "FriendInfoModel.h"
#import "Layout.h"
NS_ASSUME_NONNULL_BEGIN

@interface MessageInfoModel : RootModel
//@property (nonatomic, copy) NSString *cid;

///发布说说的id
@property(nonatomic,copy)NSString *message_id;
///发布说说者id
@property(nonatomic,copy)NSString *uid;
///发布说说的内容
@property(nonatomic,copy)NSString *content;
///话题id
@property(nonatomic,copy)NSString *topic_id;
///话题标题
@property(nonatomic,copy)NSString *topic_list;
///图片
@property(nonatomic,copy)NSString *images;
///图片数组
@property(nonatomic,copy)NSMutableArray *image_arr;
///收藏数量
@property(nonatomic,assign)NSInteger collect_num;
///喜欢数量
@property(nonatomic,assign)NSInteger like_num;
///评论数量
@property(nonatomic,assign)NSInteger comment_num;
///是否收藏
@property(nonatomic,assign)BOOL is_collect;//0否1是
///是否喜欢
@property(nonatomic,assign)BOOL is_like;//0否1是
///是否关注
@property(nonatomic,assign)BOOL is_attention;//0否1是
///是否是自己动态
@property(nonatomic,assign)BOOL is_my_dynamic;//0否1是
///时间
@property(nonatomic,copy)NSString *updatetime;
///时间
@property(nonatomic,copy)NSString *createtime;
///时间
@property(nonatomic,copy)NSString *createtime_text;
///时间
@property(nonatomic,copy)NSString *updatetime_text;
//用户信息
@property(nonatomic,copy)NSDictionary *user;
///展开状态
@property (nonatomic, assign) BOOL isExpand;
///发布说说的类型（可能含有视频）
@property(nonatomic,copy)NSString *type;

///sectionHeaderView的高度
@property (nonatomic, assign) CGFloat headerHeight;
///发布文字的布局
@property (nonatomic, strong) Layout *textLayout;
///九宫格的布局
@property (nonatomic, strong) Layout *jggLayout;

@property(nonatomic,strong)NSMutableAttributedString *mutablAttrStr;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
